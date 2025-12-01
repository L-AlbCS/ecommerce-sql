USE ecommerce;

-- =========================================================
-- 1) Recuperações simples com SELECT + WHERE
-- =========================================================

-- Lista de clientes PF
SELECT id, nome, cpf, email
FROM cliente
WHERE tipo = 'PF';

-- Produtos ativos com preço acima de 100
SELECT id, nome, sku, preco
FROM produto
WHERE ativo = TRUE AND preco > 100
ORDER BY preco DESC;

-- =========================================================
-- 2) Atributos derivados (expressões)
-- =========================================================

-- Valor total do item (quantidade * preço_unitário)
SELECT 
  pi.pedido_id,
  pi.produto_id,
  pi.quantidade,
  pi.preco_unitario,
  (pi.quantidade * pi.preco_unitario) AS valor_item
FROM pedido_item pi;

-- Margem bruta estimada por produto (preço - custo médio)
SELECT 
  p.id,
  p.nome,
  p.preco,
  AVG(fp.preco_custo) AS custo_medio,
  (p.preco - AVG(fp.preco_custo)) AS margem_bruta
FROM produto p
JOIN fornecedor_produto fp ON fp.produto_id = p.id
GROUP BY p.id, p.nome, p.preco
ORDER BY margem_bruta DESC;

-- =========================================================
-- 3) Junções entre tabelas
-- =========================================================

-- Relação de nomes dos fornecedores e nomes dos produtos
SELECT 
  ec.nome AS fornecedor,
  p.nome AS produto,
  fp.preco_custo,
  fp.lead_time_dias
FROM fornecedor f
JOIN entidade_comercial ec ON ec.id = f.entidade_id
JOIN fornecedor_produto fp ON fp.fornecedor_id = f.id
JOIN produto p ON p.id = fp.produto_id
ORDER BY fornecedor, produto;

-- Relação de produtos, fornecedores e estoques
SELECT 
  p.nome AS produto,
  ec.nome AS fornecedor,
  e.localizacao,
  e.quantidade
FROM produto p
JOIN fornecedor_produto fp ON fp.produto_id = p.id
JOIN fornecedor f ON f.id = fp.fornecedor_id
JOIN entidade_comercial ec ON ec.id = f.entidade_id
LEFT JOIN estoque e ON e.produto_id = p.id
ORDER BY produto;

-- =========================================================
-- 4) Grupos com HAVING
-- =========================================================

-- Quantos pedidos foram feitos por cada cliente (somente quem tem ao menos 1 pedido)
SELECT 
  c.id AS cliente_id,
  c.nome,
  COUNT(p.id) AS qtd_pedidos
FROM cliente c
LEFT JOIN pedido p ON p.cliente_id = c.id
GROUP BY c.id, c.nome
HAVING COUNT(p.id) > 0
ORDER BY qtd_pedidos DESC;

-- =========================================================
-- 5) Consultas específicas do desafio
-- =========================================================

-- Algum vendedor também é fornecedor?
SELECT 
  ec.documento,
  ec.nome,
  v.id AS vendedor_id,
  f.id AS fornecedor_id
FROM entidade_comercial ec
JOIN vendedor v   ON v.entidade_id = ec.id
JOIN fornecedor f ON f.entidade_id = ec.id;

-- Status e código de rastreio das entregas por pedido
SELECT 
  p.id AS pedido_id,
  e.codigo_rastreio,
  e.status,
  e.atualizado_em
FROM pedido p
JOIN entrega e ON e.pedido_id = p.id
ORDER BY e.atualizado_em DESC;

-- Validação: soma dos pagamentos por pedido vs total do pedido
SELECT 
  p.id AS pedido_id,
  p.total AS total_pedido,
  COALESCE(SUM(pp.valor), 0) AS total_pagamentos,
  (COALESCE(SUM(pp.valor), 0) - p.total) AS diferenca
FROM pedido p
LEFT JOIN pedido_pagamento pp ON pp.pedido_id = p.id
GROUP BY p.id, p.total
ORDER BY pedido_id;

-- Itens do pedido com categoria e vendedor
SELECT 
  p.id AS pedido_id,
  c.nome AS cliente,
  v_ent.nome AS vendedor,
  pr.nome AS produto,
  cat.nome AS categoria,
  pi.quantidade,
  pi.preco_unitario,
  (pi.quantidade * pi.preco_unitario) AS valor_item
FROM pedido p
JOIN cliente c ON c.id = p.cliente_id
LEFT JOIN vendedor v ON v.id = p.vendedor_id
LEFT JOIN entidade_comercial v_ent ON v_ent.id = v.entidade_id
JOIN pedido_item pi ON pi.pedido_id = p.id
JOIN produto pr ON pr.id = pi.produto_id
LEFT JOIN categoria cat ON cat.id = pr.categoria_id
ORDER BY pedido_id, produto;
