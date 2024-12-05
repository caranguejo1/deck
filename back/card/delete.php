<?php

require "conn.php";

// Get data sent via GET
$id = isset($_GET['id']) ? $_GET['id'] : null;

if ($id) {
    try {
        // SQL query to delete card
        $sql = 'DELETE FROM cards WHERE id = :id';
        $query = $dbConnection->prepare($sql);
        $query->bindParam(':id', $id, PDO::PARAM_INT);

        // Execute query
        if ($query->execute()) {
            $response['status'] = 200;
            $response['ok'] = true;
            $response['message'] = 'Card deleted successfully.';
        } else {
            $response['status'] = 500;
            $response['ok'] = false;
            $response['message'] = 'Error deleting card.';
        }
    } catch (PDOException $error) {
        $response['status'] = 500;
        $response['ok'] = false;
        $response['message'] = 'There was an error deleting the card.';
        $response['error'] = $error->getMessage();
    }
} else {
    $response['status'] = 400;
    $response['ok'] = false;
    $response['message'] = 'No card ID provided.';
}

// Return response
header('Content-Type: application/json');
echo json_encode($response);
?>
