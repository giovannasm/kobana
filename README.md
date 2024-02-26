# Kobana - Gerenciador de Boletos

Esta é uma aplicação web desenvolvida em Ruby on Rails para gerenciar boletos bancários usando a API Kobana (https://api-sandbox.kobana.com.br/v1).

## Pré-Requisitos
- Ruby 3.1.2
- Rails 7.1.3

## Rodando localmente

### Importante: a aplicação usa Active Resource, portanto não é necessário configurar banco de dados

Clone o repositório

```bash
  git clone https://github.com/giovannasm/kobana.git
```

Navegue até o diretório do projeto

```bash
  cd kobana
```

Instale as dependências

```bash
  bundle install
```

Para rodar esse projeto, você vai precisar adicionar o API Token de Kobana no seu arquivo `.env`. Abra o arquivo `.env` no diretório raiz do projeto e adicione a seguinte linha:

`BOLETOSIMPLES_API_TOKEN='seu_token_aqui'`

Inicie o servidor

```bash
  rails s
```
Acesse a aplicação em `http://localhost:3000`

Caso seja necessário, há um script para seed que pode ser rodado com:
```bash
  rails c
  BankBillet.seed
```

## Executando Testes

Os testes são organizados em duas categorias principais: testes de sistema e testes com RSpec. Os testes de sistema ajudam a garantir que a aplicação funciona como esperado em um ambiente de navegador, enquanto os testes com RSpec são usados para testar a lógica de negócios e a integração com a API Kobana.

Para executar os testes de sistema, use:

```bash
rails test:system
```

Para executar os testes com RSpec, use:

```bash
rspec
```
