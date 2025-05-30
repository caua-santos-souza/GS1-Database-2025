# WeatherGuard – Sistema Inteligente de Monitoramento e Alertas Climáticos

## Grupo: WeatherGuard
**Alunos:**  
- Cauã Dos Santos Souza – RM559093  
- Luigi Berzaghi Hernandes Sespedes – RM555516  
- Guilherme Pelissari Feitosa – RM558445  

## Disciplina  
Mastering Relational and Non-Relational Database – Turma 2TDSB  

---

## 🚀 Sobre o Projeto  
WeatherGuard é um sistema desenvolvido para fornecer monitoramento climático em tempo real e geração automatizada de alertas meteorológicos personalizados. O objetivo é apoiar a prevenção de riscos causados por eventos climáticos adversos, com foco na coleta, análise e armazenamento contínuo de dados climáticos, além da emissão de alertas para usuários cadastrados conforme suas cidades de interesse.

---

## 🎯 Objetivo  
- Coletar dados meteorológicos atualizados via APIs externas.  
- Gerar alertas personalizados baseados em regras de negócio para eventos como chuva, vento e calor extremo.  
- Permitir o cadastro e gerenciamento de usuários com associação a cidades específicas.  
- Armazenar dados históricos para consultas e relatórios.  
- Garantir segurança no acesso via API REST autenticada com JWT.

---

## ⚙️ Funcionalidades  
- **Integração com APIs externas:** Captura de dados climáticos atualizados.  
- **Gerenciamento de alertas:** Criação automática e armazenamento de alertas.  
- **Controle de usuários:** Cadastro, autenticação e associação com cidades.  
- **Histórico de alertas:** Registro detalhado para análise posterior.  
- **API segura:** Autenticação JWT para acesso controlado.

---

## 📂 Estrutura do Banco de Dados  

### Tabelas Principais

| Tabela           | Descrição                                |
|------------------|------------------------------------------|
| `usuarios`       | Armazena dados dos usuários do sistema. |
| `alertas`        | Registra alertas climáticos gerados.    |
| `usuario_alertas`| Associação entre usuários e alertas.    |

### Principais Colunas

- **usuarios:**  
  - `id_usuario` (PK)  
  - `nome`  
  - `email` (único)  
  - `senha` (hash)  
  - `cidade`  

- **alertas:**  
  - `id_alerta` (PK)  
  - `tipo` (chuva, vento, calor)  
  - `descricao`  
  - `cidade`  
  - `data_alerta` (timestamp)  

- **usuario_alertas:**  
  - `id_usuario_alerta` (PK)  
  - `usuario_id` (FK para usuarios)  
  - `alerta_id` (FK para alertas)  
  - `visualizado` (S/N)  

---

## 🔗 Relacionamentos

- Usuários e alertas possuem relacionamento muitos-para-muitos via `usuario_alertas`.
- Campos `cidade` em usuários e alertas definem a localização para filtragem de alertas.

---

## 💾 Scripts SQL  

O repositório contém scripts para:  
- Criação das tabelas com restrições e relacionamentos.  
- Inserção de dados de exemplo.  
- Consultas para extrair dados e gerar relatórios.

---

## ⚙️ Tecnologias Utilizadas  

- Oracle SQL para banco de dados relacional.  
- API REST segura (JWT) para integração com o backend (não incluído neste repositório).  

---

## 📌 Como usar

1. Importe o script SQL no seu banco Oracle para criar as tabelas e relacionamentos.  
2. Utilize as consultas SQL para testar o funcionamento dos relacionamentos.  
3. Integre com seu backend para gerenciar dados e consumir alertas.

---

## Contato  

Para dúvidas ou sugestões, entre em contato com o grupo WeatherGuard.

---

## Licença  
Este projeto é para fins acadêmicos e não possui licença comercial.

---

> Desenvolvido para a disciplina Mastering Relational and Non-Relational Database – FIAP 2025  
