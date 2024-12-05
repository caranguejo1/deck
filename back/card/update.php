<?php

    require "../conn.php";

    // Get data sent via POST
    $dados = json_decode(file_get_contents('php://input'), true);

    // Validate the data
    if (empty($dados) || !is_array($dados)) {
        $response = [
            'status' => 400,
            'ok' => false,
            'message' => 'No valid data was sent.',
        ];
    } else {
        // Begin transaction
        try {
            $dbConnection->beginTransaction();
            
            // Validate each card and prepare for updating
            foreach ($dados as $card) {
                $missingFields = validateRequiredKeys($card, ['deck_id', 'code']);
                if (!empty($missingFields)) {
                    // If any card is invalid, rollback and return an error
                    $dbConnection->rollBack();
                    $response = [
                        'status' => 400,
                        'ok' => false,
                        'message' => 'Missing required data for one or more cards.',
                        'details' => $missingFields,
                    ];
                    header('Content-Type: application/json');
                    echo json_encode($response);
                    exit;
                }

                // SQL query to update only the on_hand column for each card
                $sql = 'UPDATE cards SET 
                        on_hand = :on_hand
                        WHERE deck_id = :deck_id AND code = :code';

                // Preparing query
                $query = $dbConnection->prepare($sql);

                // Bind parameters for each card
                $query->bindParam(':deck_id', $card['deck_id'], PDO::PARAM_STR);
                $query->bindParam(':code', $card['code'], PDO::PARAM_STR);
                if(!isset($card['on_hand'])) $card['on_hand'] = false;
                $query->bindParam(':on_hand', $card['on_hand'], PDO::PARAM_BOOL);

                // Execute the update query for each card
                if (!$query->execute()) {
                    // If any update fails, rollback and return an error
                    $dbConnection->rollBack();
                    $response = [
                        'status' => 500,
                        'ok' => false,
                        'message' => 'Error updating one or more cards. Operation rolled back.',
                    ];
                    header('Content-Type: application/json');
                    echo json_encode($response);
                    exit;
                }
            }

            // Commit transaction if all updates succeed
            $dbConnection->commit();
            $response = [
                'status' => 200,
                'ok' => true,
                'message' => 'All cards updated successfully.',
            ];

        } catch (PDOException $error) {
            // Rollback on any exception
            $dbConnection->rollBack();
            $response = [
                'status' => 500,
                'ok' => false,
                'message' => 'There was an error updating the cards.',
                'error' => $error->getMessage(),
            ];
        }
    }

    // Return response
    header('Content-Type: application/json');
    echo json_encode($response);
?>
