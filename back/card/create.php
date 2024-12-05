<?php

    require "../conn.php";

    // Get data sent via POST
    $cards = json_decode(file_get_contents('php://input'), true);

    // Validate the data
    if (empty($cards) || !is_array($cards)) {
        $response = [
            'status' => 400,
            'ok' => false,
            'message' => 'No valid data was sent.',
        ];
    } else {
        // Begin transaction
        try {
            $dbConnection->beginTransaction();
            
            // Validate each card and prepare for insertion
            foreach ($cards as $dados) {
                $missingFields = validateRequiredKeys($dados, ['deck_id', 'code', 'value', 'suit']);
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
            }

            // Insert all cards
            $sql = 'INSERT INTO cards (deck_id, code, value, suit, image, on_hand) 
                    VALUES (:deck_id, :code, :value, :suit, :image, :on_hand)';
            $query = $dbConnection->prepare($sql);

            foreach ($cards as $dados) {
                $query->bindParam(':deck_id', $dados['deck_id'], PDO::PARAM_STR);
                $query->bindParam(':code', $dados['code'], PDO::PARAM_STR);
                $query->bindParam(':value', $dados['value'], PDO::PARAM_STR);
                $query->bindParam(':suit', $dados['suit'], PDO::PARAM_STR);
                $query->bindParam(':image', $dados['image'], PDO::PARAM_STR);
                if(!isset($dados['on_hand'])) $dados['on_hand'] = false;
                $query->bindParam(':on_hand', $dados['on_hand'], PDO::PARAM_BOOL);

                // Execute each insert
                if (!$query->execute()) {
                    // If any insert fails, rollback and return an error
                    $dbConnection->rollBack();
                    $response = [
                        'status' => 500,
                        'ok' => false,
                        'message' => 'Error creating cards. Operation rolled back.',
                    ];
                    header('Content-Type: application/json');
                    echo json_encode($response);
                    exit;
                }
            }

            // Commit transaction
            $dbConnection->commit();
            $response = [
                'status' => 200,
                'ok' => true,
                'message' => 'All cards created successfully.',
            ];
        } catch (PDOException $error) {
            // Rollback on any exception
            $dbConnection->rollBack();
            $response = [
                'status' => 500,
                'ok' => false,
                'message' => 'There was an error creating the cards.',
                'error' => $error->getMessage(),
            ];
        }
    }

    // Return response
    header('Content-Type: application/json');
    echo json_encode($response);
?>
