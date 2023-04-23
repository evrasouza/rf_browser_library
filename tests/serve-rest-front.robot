*** Settings ***
Resource        ../resources/serve-rest-front.resource
Suite Setup     Cadastrar usuário e logar
Suite Teardown  Close Browser    All

*** Test Cases***
Login com sucesso Serve Rest Front
    [Tags]    login    serve_rest_tests
    Abrir o navegador
    Ir para o site Serve Rest Front
    Preencher os dados do novo usuário e cadastrar
    Conferir usuário cadastrado com sucesso

Cadastro de novo usuario e conferir que aparece na lista de usuários
    [Tags]    lista_usuario
    Abrir o Site Serve Rest Front Logado
    Acessar a Lista de usuários
    Conferir que o usuário aparece na listagem

Cadastro de novo produto e conferir que aparece na lista de usuários
    [Tags]    cad_produto
    Abrir o Site Serve Rest Front Logado
    Cadastrar Novo produto
    Conferir que o produto aparece na listagem

Exemplo utilizando Requisições HTTP
    [Tags]    http
    Abrir o navegador
    Ir para o site Serve Rest Front
    Criar usuário via API
    Logar com usuário cadastrado via API

Exemplo utilizando o storage Armazenando por contexto
    [Tags]    storage_contexto
    Abrir o Site Serve Rest Front Logado
    Acessar a Lista de usuários
    
