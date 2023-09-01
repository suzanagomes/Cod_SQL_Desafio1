--Essas consultas exploram o banco de dados para atender aos requisitos do Desafio.
-- Todos os dados fictícios foram gerados aleatoriamente exclusivamente para fins de avaliação.

--  Idade dos Clientes por data de Nascimento
SELECT 
    tipoCliente, 
    nome, 
    cpf_cnpj, 
    endereco, 
    dataNascimento,
    YEAR(CURDATE()) - YEAR(dataNascimento) - 
    CASE WHEN MONTH(CURDATE()) < MONTH(dataNascimento)
        OR (MONTH(CURDATE()) = MONTH(dataNascimento) AND DAY(CURDATE()) < DAY(dataNascimento)) 
        THEN 1
        ELSE 0
    END AS idade
FROM fornecedores
ORDER BY idade DESC;


--  Quantidade de Pedidos por Cliente:
SELECT c.nome, COUNT(p.idPedido) AS quantidade_pedidos
FROM clientes c
LEFT JOIN pedidos p ON c.idCliente = p.idCliente
GROUP BY c.nome;


-- Fornecedores que possuem mais de 3 produtos
SELECT v.idVendedor, v.NomeSocial, COUNT(pv.idProduto) AS TotalProdutos
FROM fornecedores f
INNER JOIN vendedores v ON f.cnpj = v.cnpj
INNER JOIN produtosVendedores pv ON v.idVendedor = pv.idProdutoVendedor
GROUP BY v.idVendedor, v.NomeSocial
HAVING TotalProdutos > 3;


-- Algum vendedor também é fornecedor?

SELECT v.razaoSocial AS vendedor_razao_social, f.razaoSocial AS fornecedor_razao_social
FROM vendedores v
INNER JOIN fornecedores f ON v.cnpj = f.cnpj;

-- Produtos mais avaliados
SELECT nomeProduto, avaliacao
FROM produtos
ORDER BY avaliacao DESC
LIMIT 5;


--Relação de Produtos, Fornecedores e Estoques:

SELECT p.nomeProduto, f.razaoSocial AS fornecedor, ep.quantidade AS estoque
FROM produtos p
JOIN produtosFornecedores pf ON p.idProduto = pf.idProduto
JOIN fornecedores f ON pf.idFornecedor = f.idFornecedor
JOIN estoqueProdutos ep ON p.idProduto = ep.idProduto;

--Relação de Nomes de Fornecedores e Nomes de Produtos:

SELECT f.razaoSocial AS fornecedor, p.nomeProduto AS produto
FROM fornecedores f
JOIN produtosFornecedores pf ON f.idFornecedor = pf.idFornecedor
JOIN produtos p ON pf.idProduto = p.idProduto;

--Quantidade de Produtos Vendidos por Vendedor:

SELECT v.nomeFantasia, COUNT(*) AS quantidade_vendida
FROM vendedores v
JOIN produtosVendedores pv ON v.idVendedor = pv.idVendedor
GROUP BY v.nomeFantasia;

--Média de Avaliação por Categoria de Produto:

SELECT categoria, AVG(avaliacao) AS media_avaliacao
FROM produtos
GROUP BY categoria;

--Total de Vendas por Forma de Pagamento:

SELECT formaPagamento, COUNT(*) AS total_vendas
FROM pagamentos
GROUP BY formaPagamento;

--Valor Total de Pedidos por Status de Entrega:

SELECT e.statusEntrega, SUM(p.valor) AS valor_total_pedidos
FROM entregas e
JOIN pedidos p ON e.idPedido = p.idPedido
GROUP BY e.statusEntrega;

--Quantidade de Produtos por Categoria em Estoque:

SELECT p.categoria, SUM(ep.quantidade) AS quantidade_em_estoque
FROM produtos p
JOIN estoqueProdutos ep ON p.idProduto = ep.idProduto
GROUP BY p.categoria;


--Vendedores com Maior Número de Pedidos Entregues:

SELECT v.nomeFantasia, COUNT(p.idPedido) AS quantidade_pedidos_entregues
FROM vendedores v
JOIN produtosVendedores pv ON v.idVendedor = pv.idVendedor
JOIN pedidos p ON pv.idProduto = p.idProduto
WHERE p.statusPedido = 'Entregue'
GROUP BY v.nomeFantasia
ORDER BY quantidade_pedidos_entregues DESC;
