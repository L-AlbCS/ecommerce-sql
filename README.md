# 🚀 Projeto Lógico de Banco de Dados – E-commerce

## ✨ Apresentação
Este projeto foi desenvolvido como parte de um desafio de modelagem de banco de dados, com foco em **cenários reais de e-commerce**.  
A proposta é mostrar não apenas a criação de tabelas e relacionamentos, mas também como traduzir regras de negócio complexas em um **esquema lógico robusto** e consultas SQL que respondem perguntas estratégicas.

🔹 **Diferenciais do projeto:**
- Modelagem refinada para clientes PF e PJ (exclusividade garantida).  
- Suporte a múltiplas formas de pagamento e **split de pagamento** em pedidos.  
- Entregas com status e código de rastreio.  
- Entidades comerciais que podem atuar como **fornecedor e vendedor simultaneamente**.  
- Consultas SQL que simulam relatórios gerenciais e análises de negócio.  

---

## 🎯 Objetivos do desafio
- Modelar clientes PF e PJ (uma conta pode ser **PF** ou **PJ**, mas não ambas).  
- Permitir múltiplas formas de pagamento cadastradas por cliente.  
- Implementar pedidos com **split de pagamento** (mais de uma forma usada no mesmo pedido).  
- Criar entregas com **status** e **código de rastreio**.  
- Representar entidades comerciais que podem atuar como **fornecedor e vendedor**.  
- Relacionar produtos, fornecedores e estoques.  

---

## 📂 Estrutura do repositório

ecommerce-sql/
│
├── ddl.sql                # Script de criação do banco e tabelas
├── dml.sql                # Inserções de dados de exemplo
├── queries.sql            # Consultas SQL comentadas
├── README.md              # Documentação do projeto
└── docs/
└── modelo-logico.txt      # Diagrama ASCII do modelo lógico


---

## 🛠️ Tecnologias
- **MySQL**  
- Modelagem baseada em **EER (Enhanced Entity-Relationship)**  

---

## 📊 Modelo lógico (Diagrama ASCII)


+------------------+        +------------------+
|      CLIENTE     |        |     ENDERECO     |
+------------------+        +------------------+
| id (PK)          |<----+  | id (PK)          |
| nome             |     |  | cliente_id (FK)  |
| tipo (PF/PJ)     |     |  | logradouro       |
| cpf (unique)     |     |  | ...              |
| cnpj (unique)    |     |  +------------------+
| email (unique)   |
+------------------+
...
(diagrama completo disponível em docs/modelo-logico.txt)

🚀 Como executar
1. Crie o banco e tabelas:

bash
mysql -u root -p < ddl.sql

2. Insira os dados de exemplo:

bash
mysql -u root -p < dml.sql

3. Execute as consultas:

bash
mysql -u root -p < queries.sql

🧪 Guia rápido de testes
Quantos pedidos foram feitos por cada cliente? → Luiz Andrade (PF) → 1 pedido → Tech Manaus Ltda (PJ) → 0 pedidos

Algum vendedor também é fornecedor? → Grupo Amazonas aparece como ambos.

Relação de fornecedores e produtos: → Grupo Amazonas fornece Mouse Óptico, Teclado Mecânico e Notebook 14".

Produtos com estoque: → Mouse Óptico (100), Teclado Mecânico (30), Notebook 14" (10).

Pagamentos vs total do pedido: → Pedido 1 → Total = 348.90, Soma dos pagamentos = 348.90.

Status e rastreio das entregas: → Pedido 1 → Código = AMZ123456789BR → Status = postado.

📈 Insights de negócio
As queries podem ser usadas para:

Calcular o ticket médio por cliente.

Identificar fornecedores com maior variedade de produtos.

Monitorar status das entregas em tempo real.

Validar consistência entre pagamentos e valores de pedidos.

Avaliar margens brutas por produto e fornecedor.

✅ Conclusão
Este repositório demonstra como transformar requisitos de negócio em um modelo lógico consistente, com scripts SQL claros e consultas que respondem perguntas estratégicas. É um projeto pronto para avaliação e também para compor portfólio profissional.

