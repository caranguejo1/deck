<?php

require "../conn.php";

// Get data sent via GET
$deck_id = isset($_GET['deck_id']) ? $_GET['deck_id'] : null;

try {
    if ($deck_id) {
        // Fetch a specific card by deck_id
        $sql = 'SELECT * FROM cards WHERE deck_id = :deck_id';
        $query = $dbConnection->prepare($sql);
        $query->bindParam(':deck_id', $deck_id, PDO::PARAM_STR);
        $query->execute();
        $cards = [];

        while($card = $query->fetch(PDO::FETCH_ASSOC)){
            $cards[] = $card;
        }

        if ($query->rowCount() > 0) {
            $response['status'] = 200;
            $response['ok'] = true;
            $response['message'] = $query->rowCount().' cartas encontradas';
            $response['data'] = $cards;
        } else {
            $response['status'] = 404;
            $response['ok'] = false;
            $response['message'] = 'Nenhuma carta encontrada';
        }
    } else {
        // Fetch all cards
        $sql = 'SELECT * FROM cards';
        $query = $dbConnection->prepare($sql);
        $query->execute();
        $cards = $query->fetchAll(PDO::FETCH_ASSOC);

        if ($cards) {
            $response['status'] = 200;
            $response['ok'] = true;
            $response['message'] = 'Cards found.';
            $response['data'] = $cards;
        } else {
            $response['status'] = 404;
            $response['ok'] = false;
            $response['message'] = 'No cards found.';
        }
    }
} catch (PDOException $error) {
    $response['status'] = 500;
    $response['ok'] = false;
    $response['message'] = 'There was an error fetching the cards.';
    $response['error'] = $error->getMessage();
}

// Return response
header('Content-Type: application/json');
echo json_encode($response);
?>
