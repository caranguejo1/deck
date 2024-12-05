<?php

// Pegando arquivo que contém conexão com banco de dados
require "../conn.php";

// Configuração da resposta
$response = [
    'status' => 200,
    'ok' => true,
    'message' => ''
];

// Pegando parâmetro 'id' da URL
$deck_id = isset($_GET['deck_id']) ? $_GET['deck_id'] : null;

// Verificando se o 'id' foi fornecido
if (!$deck_id) {
    $response['status'] = 400;
    $response['ok'] = false;
    $response['message'] = 'O parâmetro "id" é obrigatório.';
} else {
    try {
        // Definindo SQL para deletar o deck
        $sql = 'DELETE FROM decks WHERE deck_id = :deck_id';

        // Preparando a consulta
        $query = $dbConnection->prepare($sql);

        // Bind do parâmetro 'deck_id'
        $query->bindParam(':deck_id', $deck_id, PDO::PARAM_STR);

        // Executando a consulta
        if ($query->execute()) {
            // Verificando se a quantidade de registros deletados é maior que 0
            if ($query->rowCount() > 0) {
                $response['message'] = 'Deck deletado com sucesso.';
            } else {
                $response['status'] = 404;
                $response['ok'] = false;
                $response['message'] = 'Deck não encontrado.';
            }
        } else {
            $response['status'] = 500;
            $response['ok'] = false;
            $response['message'] = 'Erro ao deletar o deck.';
            $response['error'] = $dbConnection->errorInfo();
        }

    } catch (PDOException $error) {
        // Caso ocorra um erro
        $response['status'] = 500;
        $response['ok'] = false;
        $response['message'] = 'Houve um erro ao tentar deletar o deck.';
        $response['error'] = $error->getMessage();
    }
}

// Configurando o header de resposta e retornando o resultado
header('Content-Type: application/json');
echo json_encode($response);

?>
