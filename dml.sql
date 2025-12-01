USE ecommerce;

-- País / Estado / Cidade
INSERT INTO pais (nome) VALUES ('Brasil');
INSERT INTO estado (nome, uf, pais_id) VALUES ('Amazonas','AM',1);
INSERT INTO cidade (nome, estado_id) VALUES ('Manaus', 1);

-- Clientes PF e PJ
INSERT INTO cliente (nome, tipo, cpf, email, telefone) 
VALUES ('Luiz Andrade', 'PF', '12345678901', 'luiz@example.com', '+55 92 99999-0000');

INSERT INTO cliente (nome, tipo, cnpj, email) 
VALUES ('Tech Manaus Ltda', 'PJ', '11222333000199', 'compras@techmanaus.com');

-- Endereços
INSERT INTO endereco (cliente_id, logradouro, numero, bairro, cep, cidade_id, tipo)
VALUES (1, 'Rua dos Jacarandás', '100', 'Centro', '69000000', 1, 'ambos');

INSERT INTO endereco (cliente_id, logradouro, numero, bairro, cep, cidade_id, tipo)
VALUES (2, 'Av. Industria', '2000', 'Distrito', '69010000', 1, 'entrega');

-- Entidades comerciais
INSERT INTO entidade_comercial (nome, documento, email) 
VALUES ('Grupo Amazonas', '44556677000188', 'contato@grupoamazonas.com');

-- Papéis (mesma entidade é fornecedor e vendedor)
INSERT INTO fornecedor (entidade_id, ativo) VALUES (1, TRUE);
INSERT INTO vendedor (entidade_id, ativo) VALUES (1, TRUE);

-- Categorias e produtos
INSERT INTO categoria (nome) VALUES ('Eletrônicos'), ('Acessórios');

INSERT INTO produto (nome, sku, categoria_id, preco, ativo)
VALUES 
  ('Mouse Óptico', 'MOUS-001', 2, 49.90, TRUE),
  ('Teclado Mecânico', 'TECL-002', 2, 299.00, TRUE),
  ('Notebook 14"', 'NOTE-003', 1, 3999.00, TRUE);

-- Fornecedor-produto
INSERT INTO fornecedor_produto (fornecedor_id, produto_id, preco_custo, lead_time_dias)
VALUES
  (1, 1, 25.00, 3),
  (1, 2, 180.00, 5),
  (1, 3, 3200.00, 7);

-- Estoque
INSERT INTO estoque (produto_id, quantidade, localizacao)
VALUES
  (1, 100, 'CD Manaus'),
  (2, 30,  'CD Manaus'),
  (3, 10,  'CD Manaus');

-- Formas de pagamento
INSERT INTO forma_pagamento (nome, descricao)
VALUES ('Cartão', 'Cartão de crédito/débito'),
       ('Pix',    'Transferência instantânea'),
       ('Boleto', 'Boleto bancário');

-- Cliente cadastra múltiplas formas
INSERT INTO cliente_forma_pagamento (cliente_id, forma_pagamento_id, apelido, detalhes_publicos)
VALUES 
  (1, 1, 'Visa final 1234', '**** **** **** 1234'),
  (1, 2, 'Chave Pix', 'pix*****@email.com'),
  (2, 3, 'Boleto empresa', 'cnpj:11222333000199');

-- Pedido com split de pagamento
INSERT INTO pedido (cliente_id, vendedor_id, endereco_entrega_id, status, total)
VALUES (1, 1, 1, 'pago', 348.90); -- Mouse 49.90 + Teclado 299.00

INSERT INTO pedido_item (pedido_id, produto_id, quantidade, preco_unitario)
VALUES 
  (1, 1, 1, 49.90),
  (1, 2, 1, 299.00);

-- Split: parte em cartão, parte em Pix
INSERT INTO pedido_pagamento (pedido_id, cliente_forma_pagamento_id, valor)
VALUES 
  (1, 1, 200.00),
  (1, 2, 148.90);

-- Entrega
INSERT INTO entrega (pedido_id, codigo_rastreio, status)
VALUES (1, 'AMZ123456789BR', 'postado');
