<?php

// Pegando arquivo que contém conexão com banco de dados
require "../conn.php";

// Configuração da resposta
$response = [
    'status' => 200,
    'ok' => true,
    'message' => '',
    'data' => []
];

// Pegando parâmetros da URL
$deck_id = isset($_GET['id']) ? $_GET['id'] : null;
$limit = isset($_GET['limit']) && is_numeric($_GET['limit']) ? (int)$_GET['limit'] : 10; // Limite padrão é 10

// Definindo SQL
if ($deck_id) {
    // Se o ID for passado, busca o deck específico
    $sql = 'SELECT * FROM translated_deck_view WHERE deck_id = :deck_id';
} else {
    // Se não passar ID, verifica se o limite é 0 (sem limite)
    if ($limit == 0) {
        $sql = 'SELECT * FROM translated_deck_view'; // Nenhum limite
    } else {
        $sql = 'SELECT * FROM translated_deck_view LIMIT :limit'; // Limite especificado
    }
}

try {
    // Preparando a consulta
    $query = $dbConnection->prepare($sql);

    // Se ID for fornecido, bind do parâmetro 'deck_id'
    if ($deck_id) {
        $query->bindParam(':deck_id', $deck_id, PDO::PARAM_STR);
    }

    // Se limite for fornecido e não for 0, bind do parâmetro 'limit'
    if ($limit != 0) {
        $query->bindParam(':limit', $limit, PDO::PARAM_INT);
    }

    // Executando a consulta
    $query->execute();

    // Verificando se há resultados
    if ($query->rowCount() > 0) {
        $response['data'] = $query->fetchAll(PDO::FETCH_ASSOC);
        $response['message'] = 'Deck(s) encontrado(s).';
    } else {
        $response['status'] = 404;
        $response['ok'] = false;
        $response['message'] = 'Nenhum deck encontrado.';
    }

} catch (PDOException $error) {
    // Caso ocorra um erro
    $response['status'] = 500;
    $response['ok'] = false;
    $response['message'] = 'Erro ao consultar os decks.';
    $response['error'] = $error->getMessage();
}

// Configurando o header de resposta e retornando o resultado
header('Content-Type: application/json');
echo json_encode($response);

?>
