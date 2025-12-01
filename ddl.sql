CREATE DATABASE ecommerce;
USE ecommerce;

-- País / Estado / Cidade
CREATE TABLE pais (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE estado (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  uf CHAR(2) NOT NULL UNIQUE,
  pais_id INT NOT NULL,
  FOREIGN KEY (pais_id) REFERENCES pais(id)
);

CREATE TABLE cidade (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  estado_id INT NOT NULL,
  FOREIGN KEY (estado_id) REFERENCES estado(id),
  UNIQUE (nome, estado_id)
);

-- Cliente PF ou PJ
CREATE TABLE cliente (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(160) NOT NULL,
  tipo ENUM('PF','PJ') NOT NULL,
  cpf CHAR(11) UNIQUE,
  cnpj CHAR(14) UNIQUE,
  email VARCHAR(180) NOT NULL UNIQUE,
  telefone VARCHAR(20),
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE endereco (
  id INT AUTO_INCREMENT PRIMARY KEY,
  cliente_id INT NOT NULL,
  logradouro VARCHAR(180) NOT NULL,
  numero VARCHAR(20) NOT NULL,
  complemento VARCHAR(100),
  bairro VARCHAR(100),
  cep CHAR(8) NOT NULL,
  cidade_id INT NOT NULL,
  tipo ENUM('cobranca','entrega','ambos') NOT NULL,
  FOREIGN KEY (cliente_id) REFERENCES cliente(id) ON DELETE CASCADE,
  FOREIGN KEY (cidade_id) REFERENCES cidade(id)
);

-- Entidades comerciais
CREATE TABLE entidade_comercial (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(160) NOT NULL,
  documento VARCHAR(20) NOT NULL UNIQUE,
  email VARCHAR(180),
  telefone VARCHAR(20)
);

CREATE TABLE fornecedor (
  id INT AUTO_INCREMENT PRIMARY KEY,
  entidade_id INT NOT NULL UNIQUE,
  ativo BOOLEAN DEFAULT TRUE,
  FOREIGN KEY (entidade_id) REFERENCES entidade_comercial(id) ON DELETE CASCADE
);

CREATE TABLE vendedor (
  id INT AUTO_INCREMENT PRIMARY KEY,
  entidade_id INT NOT NULL UNIQUE,
  ativo BOOLEAN DEFAULT TRUE,
  FOREIGN KEY (entidade_id) REFERENCES entidade_comercial(id) ON DELETE CASCADE
);

-- Catálogo
CREATE TABLE categoria (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE produto (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(160) NOT NULL,
  sku VARCHAR(40) NOT NULL UNIQUE,
  categoria_id INT,
  preco DECIMAL(12,2) NOT NULL,
  ativo BOOLEAN DEFAULT TRUE,
  FOREIGN KEY (categoria_id) REFERENCES categoria(id)
);

CREATE TABLE fornecedor_produto (
  fornecedor_id INT NOT NULL,
  produto_id INT NOT NULL,
  preco_custo DECIMAL(12,2) NOT NULL,
  lead_time_dias INT,
  PRIMARY KEY (fornecedor_id, produto_id),
  FOREIGN KEY (fornecedor_id) REFERENCES fornecedor(id) ON DELETE CASCADE,
  FOREIGN KEY (produto_id) REFERENCES produto(id) ON DELETE CASCADE
);

CREATE TABLE estoque (
  id INT AUTO_INCREMENT PRIMARY KEY,
  produto_id INT NOT NULL,
  quantidade INT NOT NULL,
  localizacao VARCHAR(100),
  UNIQUE (produto_id, localizacao),
  FOREIGN KEY (produto_id) REFERENCES produto(id) ON DELETE CASCADE
);

-- Pagamento
CREATE TABLE forma_pagamento (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL UNIQUE,
  descricao VARCHAR(200)
);

CREATE TABLE cliente_forma_pagamento (
  id INT AUTO_INCREMENT PRIMARY KEY,
  cliente_id INT NOT NULL,
  forma_pagamento_id INT NOT NULL,
  apelido VARCHAR(60),
  detalhes_publicos VARCHAR(120),
  ativo BOOLEAN DEFAULT TRUE,
  UNIQUE (cliente_id, forma_pagamento_id, apelido),
  FOREIGN KEY (cliente_id) REFERENCES cliente(id) ON DELETE CASCADE,
  FOREIGN KEY (forma_pagamento_id) REFERENCES forma_pagamento(id)
);

-- Pedido
CREATE TABLE pedido (
  id INT AUTO_INCREMENT PRIMARY KEY,
  cliente_id INT NOT NULL,
  vendedor_id INT,
  endereco_entrega_id INT,
  criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  status ENUM('criado','pago','enviado','entregue','cancelado') NOT NULL,
  total DECIMAL(12,2) NOT NULL,
  FOREIGN KEY (cliente_id) REFERENCES cliente(id),
  FOREIGN KEY (vendedor_id) REFERENCES vendedor(id),
  FOREIGN KEY (endereco_entrega_id) REFERENCES endereco(id)
);

CREATE TABLE pedido_item (
  id INT AUTO_INCREMENT PRIMARY KEY,
  pedido_id INT NOT NULL,
  produto_id INT NOT NULL,
  quantidade INT NOT NULL,
  preco_unitario DECIMAL(12,2) NOT NULL,
  UNIQUE (pedido_id, produto_id),
  FOREIGN KEY (pedido_id) REFERENCES pedido(id) ON DELETE CASCADE,
  FOREIGN KEY (produto_id) REFERENCES produto(id)
);

CREATE TABLE pedido_pagamento (
  id INT AUTO_INCREMENT PRIMARY KEY,
  pedido_id INT NOT NULL,
  cliente_forma_pagamento_id INT NOT NULL,
  valor DECIMAL(12,2) NOT NULL,
  FOREIGN KEY (pedido_id) REFERENCES pedido(id) ON DELETE CASCADE,
  FOREIGN KEY (cliente_forma_pagamento_id) REFERENCES cliente_forma_pagamento(id)
);

CREATE TABLE entrega (
  id INT AUTO_INCREMENT PRIMARY KEY,
  pedido_id INT NOT NULL UNIQUE,
  codigo_rastreio VARCHAR(60) NOT NULL UNIQUE,
  status ENUM('preparando','postado','em_transito','agencia','entregue','devolvido') NOT NULL,
  atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (pedido_id) REFERENCES pedido(id) ON DELETE CASCADE
);
