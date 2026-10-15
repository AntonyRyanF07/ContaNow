NOME: ANTONY RYAN PEREIRA DA SILVA

# ContaNow — Gerenciador de Contas

O ContaNow é um aplicativo feito em Flutter para ajudar a organizar contas do dia a dia. Com ele, é possível cadastrar despesas, acompanhar vencimentos e controlar pagamentos.

## Funcionalidades

- Cadastrar, editar e excluir contas.
- Marcar contas como pagas ou pendentes.
- Identificar contas atrasadas.
- Ver o resumo financeiro de cada mês.
- Consultar vencimentos pelo calendário.
- Visualizar contas pagas, pendentes e atrasadas por cores.
- Pesquisar e filtrar contas.
- Salvar os dados localmente.

## Tecnologias utilizadas

- Flutter e Dart
- Material Design 3
- shared_preferences
- table_calendar
- intl

## Telas do aplicativo

**Início:** mostra o resumo financeiro do mês e o calendário com os vencimentos.

**Minhas contas:** lista as contas cadastradas e permite pesquisar, editar, excluir e alterar pagamentos.

**Cadastro:** formulário para adicionar contas com descrição, valor, categoria e vencimento.

## Como executar

Com o Flutter instalado, abra o terminal na pasta do projeto e execute:

```bash
flutter pub get
flutter run -d chrome
```

## Verificação do código

Para analisar o projeto:

```bash
flutter analyze
```