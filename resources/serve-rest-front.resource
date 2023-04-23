*** Settings ***
Library    Browser
#...        timeout=00:00:10
#...        enable_presenter_mode=${true}
Library    FakerLibrary
Library    DateTime

*** Variables ***
${BROWSER}            chromium
${HEADLESS}           ${true}
${SITE_SERVE_REST}    https://front.serverest.dev/

*** Keyword ***
Abrir o navegador
    New Browser    browser=${BROWSER}
    ...            headless=${HEADLESS}
    
    ${TRACE_NAME}  FakerLibrary.Uuid 4
    ${NOW}         Get Current Date  result_format=%d-%m-%Y_%H%M%S
    New Context    viewport={'width': 1200, 'height': 800}
    #...            tracing=${OUTPUT_DIR}/evidencies/traces/${NOW}/${TRACE_NAME}.zip
    #...            recordVideo={'dir':'${OUTPUT_DIR}/evidencies/videos/${NOW}'}

Ir para o site Serve Rest Front
    New Page       ${SITE_SERVE_REST}
    ${title}       Get Title    ==    Front - ServeRest
    Log    ${title}

Preencher os dados do novo usuário e cadastrar
    Click       css=.btn-link
    ${NOME}    FakerLibrary.Name
    Set Test Variable    ${NOME}
    ${EMAIL}    FakerLibrary.Email
    Set Test Variable    ${EMAIL}
    Fill Text        css=input[data-testid='nome']        ${NOME}
    Fill Text        css=input[data-testid='email']       ${EMAIL}
    Fill Text        css=input[data-testid='password']    pwd123
    Check Checkbox   css=input[data-testid='checkbox']
    Click            css=button[data-testid='cadastrar']

Conferir usuário cadastrado com sucesso
    Wait For Elements State    h1    visible
    Get Text    h1    ==    Bem Vindo ${NOME}
    Get Element States    css=button[data-testid='logout']    validate    value & visible

Cadastrar Novo usuário
    Abrir o navegador
    Ir para o site Serve Rest Front
    Preencher os dados do novo usuário e cadastrar
    Conferir usuário cadastrado com sucesso

Acessar a Lista de usuários
    Click    css=a[data-testid='listarUsuarios']

Conferir que o usuário aparece na listagem
    ${elemento}  Get Table Cell Element    css=table    "Nome"    "${EMAIL}"
    ${usuario_nome}      Get Text     ${elemento}  ==  ${NOME}
    Highlight Elements     ${elemento}
    Take Screenshot    fullPage=${true}

Cadastrar Novo produto
    ${NOME_PRODUTO}    FakerLibrary.Company
    Set Test Variable    ${NOME_PRODUTO}

    ${DESCRICAO_PRODUTO}    FakerLibrary.Company
    Set Test Variable    ${DESCRICAO_PRODUTO}

    Click        css=a[data-testid='cadastrarProdutos']
    Fill Text    css=input[data-testid='nome']            Xbox ${NOME_PRODUTO}
    Fill Text    css=input[data-testid='preco']           100
    Fill Text    css=textarea[data-testid='descricao']    Console ${DESCRICAO_PRODUTO}
    Fill Text    css=input[data-testid='quantity']        1

    Click        css=button[data-testid='cadastarProdutos']

Conferir que o produto aparece na listagem
    ${elemento}  Get Table Cell Element    css=table    "Nome"    "Console ${DESCRICAO_PRODUTO}"
    ${usuario_nome}      Get Text     ${elemento}  ==  Xbox ${NOME_PRODUTO}
    Highlight Elements     ${elemento}
    Take Screenshot    fullPage=${true}

Criar usuário via API
    ${EMAIL}    FakerLibrary.Email
    Set Suite Variable    ${EMAIL}

    ${NOME}    FakerLibrary.Name
    Set Suite Variable    ${NOME}

    ${resposta}    Http    url=https://serverest.dev/usuarios
    ...                    method=POST
    ...                    body={"nome": "${NOME}", "email": "${EMAIL}", "password": "teste", "administrador": "true"}
    
    Should Be Equal As Integers    ${resposta["status"]}    201


Logar com usuário cadastrado via API
    ${resposta}        Http    url=https://serverest.dev/Login
    ...                    method=POST
    ...                    body={"email": "${EMAIL}", "password": "teste"}
    
    Should Be Equal As Integers    ${resposta["status"]}    200

    LocalStorage Set Item    serverest/userEmail    ${EMAIL}
    LocalStorage Set Item    serverest/userToken    ${resposta["body"]["authorization"]}
    LocalStorage Set Item    serverest/userNome     ${NOME}
    
    Go To    url=https://front.serverest.dev/admin/home

    Take Screenshot

Cadastrar usuário e logar
    New Browser
    New Page    url=${SITE_SERVE_REST}
    Criar usuário via API
    Logar com usuário cadastrado via API
    ${STORAGE_FILE}    Save Storage State
    Set Suite Variable     ${STORAGE_FILE}

Abrir o Site Serve Rest Front Logado
    New Browser    browser=${BROWSER}
    ...            headless=${HEADLESS}
    New Context    viewport={'width': 1200, 'height': 800}
    ...            storageState=${STORAGE_FILE}
    New Page       url=https://front.serverest.dev/admin/home
    #Get Text       h1    ==    Bem Vindo ${NOME}
    Take Screenshot