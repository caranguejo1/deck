/**
Dicionário: Deck = Baralho
*/

const apiDeckUrl = 'https://deckofcardsapi.com/api/deck'; //URL da api de cartas
var deckData = {}; //Objeto que contém dados do deck a ser cadastrado no banco de dados
var deck = []; //Array que contém cartas disponíveis para compra, do deck
var hand = []; //Array que contém cartas compradas
var savedDB = false;//Variável de controle para saber se o baralho sendo mostrado atualmente está salvo no banco de dados ou não
//Variáveis de controle para elementos do HTML
var deckNameElement = document.getElementById('deckName'); //Input para nome do baralho
const deckContainer = document.getElementById('deckContainer'); //Elemento container dos baralhos
const deckTableContainer = document.getElementById('deckTableContainer'); //Elemento container da tabela de baralhos
const deckIdContainer = document.getElementById('deckIdContainer'); //Elemento container do ID do baralho
const handContainer = document.getElementById('handContainer');
const messageQueue = []; // Fila de mensagens
let isMessageVisible = false; // Indica se uma mensagem está sendo exibida

//Mensagem para quando a página toda é carregada
document.addEventListener('DOMContentLoaded', () => {
    showMessage('Página carregada!', true);
});

//Lista logs
async function listarLogs(){
    let logs = await listDB('log');
    if (logs.length > 0) {
        resetarSite();
        createTableFromObjects(logs,'deckTableContainer');
        showMessage('Logs listados', true);
    } else {
        showMessage('Nenhum log cadastrado', false);
    }
}

//Reseta os dados de baralho para simular o recarregamento de uma página
function resetarSite(){
    deckContainer.innerHTML = '';
    deckIdContainer.innerHTML = '';
    handContainer.innerHTML = '';
    deckNameElement.value = '';
    savedDB = false;
    deck = [];
    hand = [];
}

//Reseta a página e chama um novo baralho pela API
async function novoBaralho() {
    resetarSite();
    const response = await axios.get(`${apiDeckUrl}/new/shuffle/`);
    deckData = response.data;
    showMessage('Novo baralho gerado!', true);
    embaralharCartas();
}

//Exibe cartas do baralho
function exibirCartasNoBaralho() {
    deckContainer.innerHTML = deckTableContainer.innerHTML = '';
    deckIdContainer.textContent = deckData.deck_id;
    deckNameElement.value = deckData.name == undefined ? '' : deckData.name;
    deck.forEach(carta => {
        const img = document.createElement('img');
        img.src = carta.image;
        img.classList.add('card');
        deckContainer.appendChild(img);
    });
}

//Compra 5 cartas do baralho
function comprarCincoCartas() {
    if (deck.length < 5) {
        showMessage('Cartas insuficientes', false);
        return;
    }
    const cartasCompradas = deck.splice(0, 5);
    hand.push(...cartasCompradas);
    hand = hand.map((card) => {
        card.on_hand = true;
        return card;
    });
    //console.log(deckData);
    deckData.remaining -= 5;
    //console.log(deckData);
    showMessage('5 cartas compradas!', true);
    //console.log(hand);

    exibirCartasNoBaralho();
    exibirCartasNaMão();
}

//Exibe cartas compradas do baralho
function exibirCartasNaMão() {
    handContainer.innerHTML = '';
    hand.forEach(carta => {
        const img = document.createElement('img');
        img.src = carta.image;
        img.classList.add('card');
        handContainer.appendChild(img);
    });
}

//Embaralha cartas
async function embaralharCartas() {
    const response = await axios.get(`${apiDeckUrl}/${deckData.deck_id}/shuffle/`);
    //console.log(response);
    if (response.data.success) {
        const deckResponse = await axios.get(`${apiDeckUrl}/${deckData.deck_id}/draw/?count=${deck.length > 0 ? deck.length : 52}`);
        //console.log(deckResponse);
        deck = deckResponse.data.cards;
        if(await createDB({numeroregistros: deck.length},'log')){
            showMessage('Logs inseridos', true);
        }else{
            showMessage('Logs não inseridos', false);
        }
        showMessage('Cartas embaralhadas', true);
        exibirCartasNoBaralho();
    }
}

//Salva o baralho atual no banco de dados
//Se o baralho já está carregado, apenas atualiza seus dados
async function salvarBaralho() {
    if (!deckData.deck_id) {
        alert("Não há um baralho válido para salvar.");
        return;
    }

    deckData.name = deckNameElement.value;

    let cards = deck.concat(hand);
    cards = cards.map((card) => {
        card.deck_id = deckData.deck_id;
        return card;
    });

    //console.log(deckData);
    if (savedDB) {
        //Atualizando deck
        if (await updateDB(deckData, 'deck')) {
            showMessage('Baralho atualizado!',true);
        } else {
            showMessage('Baralho não atualizado',false);
        }
        //Atualizando cartas
        if (await updateDB(cards, 'card')) {
            showMessage('Cartas atualizadas!',true);
        } else {
            showMessage('Cartas não atualizadas',false);
        }
    } else {
        //Cadastrando deck
        savedDB = await createDB(deckData, 'deck');
        if (savedDB) {
            showMessage('Baralho cadastrado!', true);
        } else {
            showMessage('Baralho não cadastrado', false);
        }
        //Cadastrando cartas
        if (await createDB(cards, 'card')) {
            showMessage('Cartas cadastradas!', true);
        } else {
            showMessage('Cartas não cadastradas', false);
        }
    }
}

//Lista os baralhos já cadastradas no banco de dados em uma tabela
async function listarBaralhos() {
    let decks = await listDB('deck');
    //console.log(decks);
    if (decks.length > 0) {
        deckContainer.innerHTML = deckTableContainer.innerHTML = '';
        createTableFromObjects(decks, 'deckTableContainer',[
            {
                text: 'Usar',
                class: 'btn btn-dark',
                callback: usarDeck
            }
        ]);
        showMessage('Baralhos listados!', true);
    } else {
        showMessage('Nenhum baralho encontrado!', false);
    }
}

//Busca no banco de dados os dados do deck selecionado e carrega na página
async function usarDeck(obj){
    let cards = await listDB('card',obj.deck_id);
    deckData = obj;
    //console.log("Cartas");
    //console.log(cards);
    deck = cards.filter(card => !card.on_hand);
    hand = cards.filter(card => card.on_hand);
    savedDB = true;
    showMessage('Carregando baralho...', true);
    exibirCartasNaMão();
    exibirCartasNoBaralho();
}

//Deleta baralho atual
async function deletarBaralho() {
    if (Object.keys(deckData).length == 0) {
        showMessage("Não há baralho para deletar", false);
        return false;
    }else{
        if (savedDB) {
            if (!confirm('Tem certeza de que deseja deletar o baralho ' + deckData.deck_id)) {
                showMessage("Deleção abortada", true);
                return false;
            }else{
                if (await deleteDB('deck',deckData.deck_id)) {
                    showMessage('Baralho deletado',true);
                    resetarSite();
                }else{
                    showMessage('Baralho não deletado', false);
                }
            }
        }else{
            showMessage("Baralho não está cadastrado!", false);
            return false;
        }
    }
}

/*Aqui você verá funções padrão de CRUD
C = CREATE = createDB
R = READ = listDB
U = UPDATE = updateDB
D = DELETE = deleteDB
*/

//Cria registro no banco de dados
async function createDB(data, type) {
    // Define allowed resource types in an array
    const allowedTypes = ['card', 'deck', 'log'];

    // Validate if the type is included in the allowedTypes array
    if (!allowedTypes.includes(type)) {
        console.log(`Tipo invalido, deve ser um destes: ${allowedTypes.join(',')}. ${type} foi informado`);
        return false;
    }

    // Set the appropriate endpoint based on the type
    const endpoint = `back/${type}/create.php`;

    // Send the data to the server via POST
    const response = await fetch(endpoint, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(data)
    });

    //console.log(response);

    // Parse the response as JSON
    const result = await response.json();
    //console.log(result);

    // Handle the response from the server
    if (!result.ok) console.log(result);
    return result.ok;
}

//Atualiza registro no banco de dados
async function updateDB(data, type) {
    // Validando o tipo para garantir que seja 'card' ou 'deck'
    const validTypes = ['card', 'deck'];
    if (!validTypes.includes(type)) {
        throw new Error("Tipo de recurso inválido. Deve ser 'card' ou 'deck'.");
    }

    // Definindo a URL de acordo com o tipo do recurso
    const url = `back/${type}/update.php`;

    // Configurando as opções para a requisição
    const options = {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(data), // Enviando os dados como JSON
    };

    // Enviando a requisição para o servidor
    const response = await fetch(url, options);

    const result = await response.json();

    if (!result.ok) console.log(result);
    return result.ok;
}

/*
Lista registros do banco de dados

Se o tipo for DECK (baralho), não é necessário informar um deck_id
Se o tipo for CARD (cartas), é necessário informar um deck_id, para saber de qual baralho as cartas devem ser listadas
*/
async function listDB(tipo, deck_id = null) {
    // Valida se o tipo fornecido é válido
    const tiposPermitidos = ['deck', 'card', 'log'];
    if (!tiposPermitidos.includes(tipo)) {
        console.error(`Tipo inválido, deve ser dos tipos ${tiposPermitidos.join(',')}. ${tipo} informado`);
        return [];
    }

    // Define o endpoint com base no tipo
    let endpoint = `back/${tipo}/list.php`;

    if (deck_id && ['deck','card'].includes(tipo)) endpoint += `?deck_id=${deck_id}`;

    // Envia uma requisição GET para o servidor para listar o recurso
    const response = await fetch(endpoint, {
        method: 'GET'
    });

    // Verifica se a resposta foi bem-sucedida
    if (!response.ok) {
        console.log(response);
    }

    // Parseia a resposta como JSON
    const result = await response.json();

    if (!result.ok) {
        console.log(result);
        return [];
    } else {
        return result.data;
    }
}

//Deleta registros do banco de dados
//Gostaria de ter usado o método DELETE, mas infelizmente meu apache só aceita GET, POST e OPTIONS
async function deleteDB(tipo, deck_id) {
    // Valida se o tipo fornecido é válido
    const tiposPermitidos = ['deck', 'hand'];
    if (!tiposPermitidos.includes(tipo)) {
        throw new Error("Tipo inválido. Deve ser 'deck' ou 'hand'.");
    }

    // Verifica se o ID foi fornecido
    if (!deck_id) {
        throw new Error("O ID é necessário para deletar o recurso.");
    }

    // Define o endpoint com base no tipo e no ID
    const endpoint = `back/${tipo}/delete.php?deck_id=${deck_id}`;

    // Envia uma requisição DELETE para o servidor
    const response = await fetch(endpoint, {
        method: 'POST',
        // Não é necessário o header 'Content-Type' já que não estamos enviando corpo com dados
    });

    // Parseia a resposta como JSON
    const result = await response.json();

    // Verifica se a requisição foi bem-sucedida
    if (!result.ok) {
        console.log(result);
    }
    return result.ok;
}

/*
Cria uma tabela de acordo com uma lista de objetos

objectsList = lista de objetos
containerId = id do elemento onde a tabela deve ser inserida
actionsList = lista de objetos contendo texto, classe e função de callback. É necessário para inserir botões na tabela
*/
function createTableFromObjects(objectsList, containerId, actionsList = []) {
    // Ensure there's data to create the table
    if (!objectsList || objectsList.length === 0) {
        console.error('No data available to create the table.');
        return;
    }

    // Get the container to insert the table
    const container = document.getElementById(containerId);
    if (!container) {
        console.error(`Container with ID "${containerId}" not found.`);
        return;
    }

    // Clear existing content in the container
    container.innerHTML = '';

    // Create the table
    const table = document.createElement('table');
    table.border = "1"; // Optional: Add border for better visibility
    table.style.borderCollapse = 'collapse';
    table.style.width = '100%';

    // Create the table header row
    const headerRow = document.createElement('tr');
    const headers = Object.keys(objectsList[0]); // Get headers from the first object
    headers.forEach(header => {
        const th = document.createElement('th');
        th.textContent = header.charAt(0).toUpperCase() + header.slice(1); // Capitalize headers
        th.style.padding = '8px';
        th.style.backgroundColor = '#f2f2f2';
        th.style.textAlign = 'left';
        headerRow.appendChild(th);
    });

    // Add "Actions" column header if actions are provided
    if (actionsList.length > 0) {
        const actionsTh = document.createElement('th');
        actionsTh.textContent = 'Actions';
        actionsTh.style.padding = '8px';
        actionsTh.style.backgroundColor = '#f2f2f2';
        actionsTh.style.textAlign = 'center';
        headerRow.appendChild(actionsTh);
    }
    table.appendChild(headerRow);

    // Create rows for each object
    objectsList.forEach((obj, index) => {
        const row = document.createElement('tr');
        headers.forEach(header => {
            const td = document.createElement('td');
            td.textContent = obj[header];
            td.style.padding = '8px';
            row.appendChild(td);
        });

        // Add "Actions" column with buttons if actions are provided
        if (actionsList.length > 0) {
            const actionsTd = document.createElement('td');
            actionsTd.style.padding = '8px';
            actionsTd.style.textAlign = 'center';

            actionsList.forEach(action => {
                const button = document.createElement('button');
                button.textContent = action.text;
                button.className = action.class || '';
                button.style.marginRight = '5px';
                // Bind the callback function to the button, passing the row's data if needed
                button.onclick = () => action.callback(obj, index);
                actionsTd.appendChild(button);
            });

            row.appendChild(actionsTd);
        }

        table.appendChild(row);
    });

    // Append the table to the container
    container.appendChild(table);
}

//Adiciona uma mensagem na fila de mensagens a serem mostradas (ver linha 15 e 16)
function showMessage(message, isSuccess) {
    // Adiciona a mensagem à fila
    messageQueue.push({ message, isSuccess });

    // Se não houver nenhuma mensagem sendo exibida, processa a fila
    if (!isMessageVisible) {
        processMessageQueue();
    }
}

//Processa mensagens da fila de mensagens
function processMessageQueue() {
    if (messageQueue.length === 0) {
        isMessageVisible = false; // Não há mais mensagens na fila
        return;
    }

    isMessageVisible = true; // Uma mensagem está sendo exibida
    const { message, isSuccess } = messageQueue.shift(); // Retira a próxima mensagem da fila

    // Cria o container
    const container = document.createElement('div');
    container.className = 'message-container'; // Usa uma classe para estilos
    container.textContent = message;

    // Define a cor do fundo com base no sucesso ou erro
    container.style.backgroundColor = isSuccess ? '#4caf50' : '#f44336'; // Verde para sucesso, vermelho para erro
    container.style.opacity = '1'; // Inicia o fade-in

    // Adiciona o container ao body
    document.body.appendChild(container);

    // Esconde a mensagem após 1 segundo
    setTimeout(() => {
        container.style.opacity = '0'; // Inicia o fade-out
        setTimeout(() => {
            document.body.removeChild(container); // Remove o elemento após o fade-out
            processMessageQueue(); // Processa a próxima mensagem na fila
        }, 1000); // Aguarda o término do fade-out
    }, 1000); // Mantém a mensagem visível por 1 segundo
}