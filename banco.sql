DROP DATABASE IF EXISTS deck;

-- Criar o banco de dados
CREATE DATABASE deck;

-- Selecionar o banco de dados recém-criado
USE deck;

-- Criar a tabela 'decks' com a coluna 'name' adicionada
CREATE TABLE decks (
    deck_id VARCHAR(255) PRIMARY KEY,  
    -- Identificador único do baralho (corresponde ao 'deck_id' no objeto)
    
    name VARCHAR(255) NULL,       
    -- Nome do baralho (pode ser NULL)
    
    success BOOLEAN NOT NULL,     
    -- Indica se a criação do baralho foi bem-sucedida (true ou false)
    
    remaining INT NOT NULL,       
    -- Número de cartas restantes no baralho
    
    shuffled BOOLEAN NOT NULL,    
    -- Indica se o baralho está embaralhado (true ou false)
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    -- Data e hora em que o registro foi criado
    
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP 
    -- Data e hora da última atualização do registro
);

-- Criar a tabela 'cards' com a nova coluna 'on_hand'
CREATE TABLE cards (
    id INT AUTO_INCREMENT PRIMARY KEY,   
    -- Identificador único para cada carta
    
    deck_id VARCHAR(255),                
    -- Chave estrangeira que referencia o baralho
    
    code VARCHAR(10) NOT NULL,           
    -- Código da carta (ex.: "3S")
    
    image VARCHAR(255),                  
    -- URL da imagem da carta (formato PNG)
    
    svg_image VARCHAR(255),              
    -- URL da imagem SVG da carta
    
    value VARCHAR(50) NOT NULL,          
    -- Valor da carta (ex.: "3")
    
    suit VARCHAR(50) NOT NULL,           
    -- Naipe da carta (ex.: "ESPADAS")
    
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, 
    -- Data e hora em que o registro foi criado
    
    updated_at TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, 
    -- Data e hora da última atualização do registro
    
    on_hand BOOLEAN NOT NULL,  
    -- Indica se a carta está na mão (TRUE ou FALSE)
    
    CONSTRAINT fk_deck FOREIGN KEY (deck_id) REFERENCES decks(deck_id) ON DELETE CASCADE,
    -- Chave estrangeira que referencia a tabela 'decks', com exclusão em cascata
    
    UNIQUE (deck_id, code)  
    -- Garante que o código de cada carta seja único dentro de um baralho
);

-- Criar uma VIEW para listar baralhos traduzidos para português
DROP VIEW IF EXISTS translated_deck_view;

CREATE VIEW translated_deck_view AS
SELECT 
    deck_id,
    name,
    CASE
        WHEN success = 1 THEN 'Sim'
        WHEN success = 0 THEN 'Não'
    END AS 'success',
    remaining,
    CASE 
        WHEN shuffled = 1 THEN 'Sim'
        WHEN shuffled = 0 THEN 'Não'
        ELSE NULL
    END AS "shuffled",
    created_at,
    updated_at
FROM decks;

-- Atualizar a quantidade de cartas restantes nos baralhos com base nas cartas que não estão na mão
/*
UPDATE decks
SET remaining = (
    SELECT COUNT(*) 
    FROM cards
    WHERE cards.deck_id = decks.deck_id AND cards.on_hand = 0
);
*/

CREATE TABLE IF NOT EXISTS log(
    idlog INT PRIMARY KEY AUTO_INCREMENT,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    numeroregistros INT
);