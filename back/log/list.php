<?php

require "../conn.php";

try {
    // Fetch all logs
    $sql = 'SELECT * FROM log';
    $query = $dbConnection->prepare($sql);
    $query->execute();
    $logs = $query->fetchAll(PDO::FETCH_ASSOC);

    if ($logs) {
        $response['status'] = 200;
        $response['ok'] = true;
        $response['message'] = 'logs encontrados';
        $response['data'] = $logs;
    } else {
        $response['status'] = 404;
        $response['ok'] = false;
        $response['message'] = 'logs não encontrados';
    }
} catch (PDOException $error) {
    $response['status'] = 500;
    $response['ok'] = false;
    $response['message'] = 'Houve um erro ao buscar logs';
    $response['error'] = $error->getMessage();
}

// Return response
header('Content-Type: application/json');
echo json_encode($response);
?>