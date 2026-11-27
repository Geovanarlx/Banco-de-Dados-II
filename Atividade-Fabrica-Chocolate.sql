CREATE DATABASE IF NOT EXISTS fabrica_chocolate
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE fabrica_chocolate;

SET SQL_SAFE_UPDATES = 0;

DROP PROCEDURE IF EXISTS testar_exclusao_fornecedor;
DROP PROCEDURE IF EXISTS testar_check_produto;
DROP PROCEDURE IF EXISTS testar_exclusao_pedido;

DROP TABLE IF EXISTS item_pedido;
DROP TABLE IF EXISTS pedido;
DROP TABLE IF EXISTS receita;
DROP TABLE IF EXISTS produto;
DROP TABLE IF EXISTS ingrediente;
DROP TABLE IF EXISTS fornecedor;
DROP TABLE IF EXISTS funcionario;
DROP TABLE IF EXISTS cliente;
DROP TABLE IF EXISTS setor;

CREATE TABLE setor (
    id_setor INT PRIMARY KEY AUTO_INCREMENT,
    nome_setor VARCHAR(50) NOT NULL UNIQUE,
    andar INT
) ENGINE=InnoDB;

CREATE TABLE funcionario (
    id_func INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cargo VARCHAR(50),
    salario DECIMAL(10, 2),
    data_admissao DATE,
    id_setor INT NULL,
    CONSTRAINT chk_funcionario_salario CHECK (salario > 0),
    CONSTRAINT fk_funcionario_setor
        FOREIGN KEY (id_setor) REFERENCES setor(id_setor)
) ENGINE=InnoDB;

CREATE TABLE fornecedor (
    id_fornecedor INT PRIMARY KEY AUTO_INCREMENT,
    nome_fornecedor VARCHAR(100) NOT NULL,
    pais VARCHAR(50)
) ENGINE=InnoDB;

CREATE TABLE ingrediente (
    id_ingrediente INT PRIMARY KEY AUTO_INCREMENT,
    nome_ingrediente VARCHAR(50),
    preco_kg DECIMAL(10, 2),
    estoque_kg DECIMAL(10, 2) DEFAULT 0,
    id_fornecedor INT,
    CONSTRAINT chk_ingrediente_preco CHECK (preco_kg > 0),
    CONSTRAINT chk_ingrediente_estoque CHECK (estoque_kg >= 0),
    CONSTRAINT fk_ingrediente_fornecedor
        FOREIGN KEY (id_fornecedor) REFERENCES fornecedor(id_fornecedor)
) ENGINE=InnoDB;

CREATE TABLE produto (
    id_produto INT PRIMARY KEY AUTO_INCREMENT,
    nome_produto VARCHAR(100),
    categoria VARCHAR(30),
    preco_venda DECIMAL(10, 2),
    estoque INT DEFAULT 0,
    CONSTRAINT chk_produto_preco CHECK (preco_venda > 0)
) ENGINE=InnoDB;

CREATE TABLE receita (
    id_produto INT NOT NULL,
    id_ingrediente INT NOT NULL,
    qtd_kg DECIMAL(10, 3) NOT NULL,
    PRIMARY KEY (id_produto, id_ingrediente),
    CONSTRAINT fk_receita_produto
        FOREIGN KEY (id_produto) REFERENCES produto(id_produto),
    CONSTRAINT fk_receita_ingrediente
        FOREIGN KEY (id_ingrediente) REFERENCES ingrediente(id_ingrediente)
) ENGINE=InnoDB;

CREATE TABLE cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome_cliente VARCHAR(100) NOT NULL,
    cidade VARCHAR(80),
    tipo VARCHAR(20)
) ENGINE=InnoDB;

CREATE TABLE pedido (
    id_pedido INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT,
    data_pedido DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Pendente',
    CONSTRAINT fk_pedido_cliente
        FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
) ENGINE=InnoDB;

CREATE TABLE item_pedido (
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT,
    preco_unitario DECIMAL(10, 2),
    PRIMARY KEY (id_pedido, id_produto),
    CONSTRAINT chk_item_pedido_quantidade CHECK (quantidade > 0),
    CONSTRAINT fk_item_pedido_pedido
        FOREIGN KEY (id_pedido) REFERENCES pedido(id_pedido),
    CONSTRAINT fk_item_pedido_produto
        FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
) ENGINE=InnoDB;

INSERT INTO setor (nome_setor, andar) VALUES
    ('Sala do Chocolate', 0),
    ('Sala de Invenções', 1),
    ('Sala de Embalagem', 0),
    ('Sala das Nozes', 2),
    ('Sala de Televisão', 3);

INSERT INTO funcionario (nome, cargo, salario, data_admissao, id_setor) VALUES
    ('Willy Wonka', 'Diretor', 25000.00, '2000-01-10', 2),
    ('Charlie Bucket', 'Aprendiz', 1800.00, '2024-03-01', 2),
    ('Vovô Joe', 'Supervisor', 4200.00, '2023-06-15', 1),
    ('Oompa Loompa Lux', 'Operador', 2500.00, '2019-05-20', 1),
    ('Oompa Loompa Zim', 'Operador', 2600.00, '2020-08-11', 1),
    ('Oompa Loompa Bip', 'Embalador', 2200.00, '2021-02-03', 3),
    ('Oompa Loompa Tuk', 'Embalador', 2300.00, '2022-09-14', 3),
    ('Oompa Loompa Nox', 'Tratador de Esquilos', 2100.00, '2018-11-30', 4),
    ('Senhora Bucket', 'Embaladora', 2400.00, '2024-01-08', 3),
    ('Oompa Loompa Kip', 'Operador', 2700.00, '2017-04-22', NULL);

INSERT INTO fornecedor (nome_fornecedor, pais) VALUES
    ('Cacau Loompalândia', 'Loompalândia'),
    ('Açúcar Doce Vale', 'Brasil'),
    ('Laticínios dos Alpes', 'Suíça'),
    ('Nozes & Cia', 'Turquia'),
    ('Baunilha Real', 'Madagascar');

INSERT INTO ingrediente (nome_ingrediente, preco_kg, estoque_kg, id_fornecedor) VALUES
    ('Cacau em pó', 45.00, 500, 1),
    ('Manteiga de cacau', 80.00, 200, 1),
    ('Açúcar refinado', 5.50, 1000, 2),
    ('Leite em pó', 32.00, 300, 3),
    ('Avelã', 95.00, 80, 4),
    ('Amendoim', 22.00, 150, 4),
    ('Caramelo', 28.00, 0, 2);

INSERT INTO produto (nome_produto, categoria, preco_venda, estoque) VALUES
    ('Barra Wonka ao Leite', 'Barra', 12.90, 500),
    ('Barra Wonka Amargo 70%', 'Barra', 15.90, 300),
    ('Bombom de Avelã', 'Bombom', 4.50, 1000),
    ('Chiclete Três Refeições', 'Guloseima', 29.90, 50),
    ('Ovo de Páscoa Dourado', 'Sazonal', 89.90, 20),
    ('Bala Eterna', 'Guloseima', 3.00, 2000),
    ('Trufa de Caramelo', 'Bombom', 6.50, 0);

INSERT INTO receita (id_produto, id_ingrediente, qtd_kg) VALUES
    (1, 1, 0.020),
    (1, 3, 0.030),
    (1, 4, 0.040),
    (2, 1, 0.050),
    (2, 2, 0.020),
    (2, 3, 0.010),
    (3, 1, 0.005),
    (3, 5, 0.008),
    (3, 4, 0.005),
    (5, 1, 0.200),
    (5, 2, 0.100),
    (5, 4, 0.100),
    (5, 5, 0.050),
    (7, 1, 0.010),
    (7, 7, 0.010);

INSERT INTO cliente (nome_cliente, cidade, tipo) VALUES
    ('Doces da Veruca', 'Londres', 'Atacado'),
    ('Mercado Gloop', 'Düsseldorf', 'Varejo'),
    ('Loja Beauregarde', 'Atlanta', 'Varejo'),
    ('Teavee Distribuidora', 'Denver', 'Atacado'),
    ('Confeitaria Bucket', 'Londres', 'Varejo');

INSERT INTO pedido (id_cliente, data_pedido, status) VALUES
    (1, '2025-03-10', 'Entregue'),
    (1, '2025-04-02', 'Entregue'),
    (2, '2025-04-15', 'Entregue'),
    (3, '2025-05-20', 'Cancelado'),
    (4, '2025-06-01', 'Em produção'),
    (2, '2025-06-18', 'Pendente'),
    (4, '2025-07-07', 'Entregue');

INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
    (1, 1, 100, 12.90),
    (1, 3, 200, 4.50),
    (2, 2, 50, 15.90),
    (2, 5, 5, 89.90),
    (3, 1, 30, 12.90),
    (3, 6, 100, 3.00),
    (4, 4, 10, 29.90),
    (5, 3, 300, 4.50),
    (5, 2, 80, 15.90),
    (6, 6, 50, 3.00),
    (6, 1, 20, 12.90),
    (7, 5, 10, 89.90),
    (7, 1, 150, 12.90);

SELECT
    (SELECT COUNT(*) FROM setor) AS total_setores,
    (SELECT COUNT(*) FROM funcionario) AS total_funcionarios,
    (SELECT COUNT(*) FROM fornecedor) AS total_fornecedores,
    (SELECT COUNT(*) FROM ingrediente) AS total_ingredientes,
    (SELECT COUNT(*) FROM produto) AS total_produtos,
    (SELECT COUNT(*) FROM receita) AS total_receitas,
    (SELECT COUNT(*) FROM cliente) AS total_clientes,
    (SELECT COUNT(*) FROM pedido) AS total_pedidos,
    (SELECT COUNT(*) FROM item_pedido) AS total_itens_pedido;

ALTER TABLE funcionario
ADD COLUMN email VARCHAR(100);

ALTER TABLE ingrediente
ADD COLUMN situacao_estoque VARCHAR(20) DEFAULT 'Normal';

ALTER TABLE produto
ADD COLUMN ativo CHAR(1) DEFAULT 'S';

ALTER TABLE cliente
MODIFY COLUMN cidade VARCHAR(80);

ALTER TABLE setor
RENAME COLUMN andar TO pavimento;

UPDATE funcionario
SET email = CONCAT(LOWER(REPLACE(nome, ' ', '.')), '@wonka.com');

UPDATE ingrediente
SET situacao_estoque = 'Crítico'
WHERE estoque_kg > 0 AND estoque_kg < 100;

UPDATE ingrediente
SET situacao_estoque = 'Esgotado'
WHERE estoque_kg = 0;

UPDATE funcionario
SET salario = salario * 1.08
WHERE nome LIKE 'Oompa Loompa%'
  AND data_admissao < '2021-01-01';

UPDATE funcionario
SET cargo = 'Herdeiro',
    salario = 9500.00
WHERE nome = 'Charlie Bucket';

UPDATE produto
SET preco_venda = preco_venda * 1.10
WHERE id_produto IN (
    SELECT r.id_produto
    FROM receita AS r
    INNER JOIN ingrediente AS i
        ON i.id_ingrediente = r.id_ingrediente
    WHERE i.nome_ingrediente = 'Avelã'
);

UPDATE produto
SET ativo = 'N'
WHERE estoque = 0;

DELIMITER $$

CREATE PROCEDURE testar_exclusao_fornecedor()
BEGIN
    DECLARE v_mensagem TEXT;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_mensagem = MESSAGE_TEXT;
        SELECT v_mensagem AS mensagem_erro;
    END;
    DELETE FROM fornecedor
    WHERE nome_fornecedor = 'Cacau Loompalândia';
END$$

CREATE PROCEDURE testar_check_produto()
BEGIN
    DECLARE v_mensagem TEXT;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_mensagem = MESSAGE_TEXT;
        SELECT v_mensagem AS mensagem_erro;
    END;
    INSERT INTO produto (nome_produto, categoria, preco_venda, estoque)
    VALUES ('Chocolate Invisível', 'Barra', -10.00, 100);
END$$

CREATE PROCEDURE testar_exclusao_pedido()
BEGIN
    DECLARE v_mensagem TEXT;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_mensagem = MESSAGE_TEXT;
        SELECT v_mensagem AS mensagem_erro;
    END;
    DELETE FROM pedido
    WHERE id_pedido = 1;
END$$

DELIMITER ;

CALL testar_exclusao_fornecedor();

DELETE FROM fornecedor
WHERE nome_fornecedor = 'Baunilha Real';

CALL testar_check_produto();

CALL testar_exclusao_pedido();

DROP PROCEDURE testar_exclusao_fornecedor;
DROP PROCEDURE testar_check_produto;
DROP PROCEDURE testar_exclusao_pedido;

DELETE FROM item_pedido
WHERE id_pedido IN (
    SELECT id_pedido
    FROM pedido
    WHERE status = 'Cancelado'
);

DELETE FROM pedido
WHERE status = 'Cancelado';

DELETE FROM ingrediente
WHERE id_ingrediente NOT IN (
    SELECT id_ingrediente
    FROM receita
);

SELECT
    (SELECT COUNT(*) FROM setor) AS total_setores,
    (SELECT COUNT(*) FROM funcionario) AS total_funcionarios,
    (SELECT COUNT(*) FROM fornecedor) AS total_fornecedores,
    (SELECT COUNT(*) FROM ingrediente) AS total_ingredientes,
    (SELECT COUNT(*) FROM produto) AS total_produtos,
    (SELECT COUNT(*) FROM receita) AS total_receitas,
    (SELECT COUNT(*) FROM cliente) AS total_clientes,
    (SELECT COUNT(*) FROM pedido) AS total_pedidos,
    (SELECT COUNT(*) FROM item_pedido) AS total_itens_pedido;

SELECT nome, cargo, salario
FROM funcionario
WHERE salario BETWEEN 2200.00 AND 2800.00
ORDER BY salario DESC;

SELECT nome_produto, categoria, preco_venda
FROM produto
WHERE categoria IN ('Bombom', 'Sazonal')
ORDER BY preco_venda ASC;

SELECT nome, cargo
FROM funcionario
WHERE nome LIKE '%Bucket%'
   OR cargo LIKE 'Emb%'
ORDER BY nome ASC;

SELECT id_func, nome, cargo
FROM funcionario
WHERE id_setor IS NULL;

SELECT nome_cliente, cidade, tipo
FROM cliente
WHERE id_cliente NOT IN (
    SELECT id_cliente
    FROM cliente
    WHERE cidade = 'Londres'
)
ORDER BY nome_cliente ASC;

SELECT DISTINCT categoria
FROM produto
ORDER BY categoria ASC;

SELECT
    f.nome,
    f.cargo,
    s.nome_setor
FROM funcionario AS f
INNER JOIN setor AS s
    ON s.id_setor = f.id_setor
ORDER BY s.nome_setor ASC, f.nome ASC;

SELECT
    f.nome,
    COALESCE(s.nome_setor, 'Sem setor') AS nome_setor
FROM funcionario AS f
LEFT JOIN setor AS s
    ON s.id_setor = f.id_setor
ORDER BY f.nome ASC;

SELECT
    s.id_setor,
    s.nome_setor
FROM funcionario AS f
RIGHT JOIN setor AS s
    ON s.id_setor = f.id_setor
WHERE f.id_func IS NULL
ORDER BY s.nome_setor ASC;

SELECT
    pe.id_pedido,
    c.nome_cliente,
    pe.data_pedido,
    pr.nome_produto,
    ip.quantidade,
    ip.preco_unitario,
    ip.quantidade * ip.preco_unitario AS subtotal
FROM pedido AS pe
INNER JOIN cliente AS c
    ON c.id_cliente = pe.id_cliente
INNER JOIN item_pedido AS ip
    ON ip.id_pedido = pe.id_pedido
INNER JOIN produto AS pr
    ON pr.id_produto = ip.id_produto
WHERE pe.status = 'Entregue'
ORDER BY pe.data_pedido ASC, pr.nome_produto ASC;

SELECT
    pr.nome_produto,
    i.nome_ingrediente,
    f.nome_fornecedor,
    r.qtd_kg,
    i.preco_kg,
    r.qtd_kg * i.preco_kg AS custo_ingrediente_unidade
FROM produto AS pr
INNER JOIN receita AS r
    ON r.id_produto = pr.id_produto
INNER JOIN ingrediente AS i
    ON i.id_ingrediente = r.id_ingrediente
INNER JOIN fornecedor AS f
    ON f.id_fornecedor = i.id_fornecedor
WHERE pr.nome_produto = 'Ovo de Páscoa Dourado'
ORDER BY custo_ingrediente_unidade DESC;

SELECT
    s.nome_setor,
    COUNT(f.id_func) AS quantidade_funcionarios,
    SUM(f.salario) AS soma_salarios,
    ROUND(AVG(f.salario), 2) AS media_salarial,
    MAX(f.salario) AS maior_salario,
    MIN(f.salario) AS menor_salario
FROM setor AS s
INNER JOIN funcionario AS f
    ON f.id_setor = s.id_setor
GROUP BY s.id_setor, s.nome_setor
HAVING COUNT(f.id_func) >= 2
ORDER BY media_salarial DESC;

SELECT
    c.nome_cliente,
    COUNT(DISTINCT pe.id_pedido) AS quantidade_pedidos,
    COALESCE(SUM(ip.quantidade * ip.preco_unitario), 0.00) AS valor_total_comprado
FROM cliente AS c
LEFT JOIN pedido AS pe
    ON pe.id_cliente = c.id_cliente
LEFT JOIN item_pedido AS ip
    ON ip.id_pedido = pe.id_pedido
GROUP BY c.id_cliente, c.nome_cliente
ORDER BY valor_total_comprado DESC, c.nome_cliente ASC;

SELECT
    pr.nome_produto,
    SUM(ip.quantidade) AS quantidade_total_vendida
FROM produto AS pr
INNER JOIN item_pedido AS ip
    ON ip.id_produto = pr.id_produto
GROUP BY pr.id_produto, pr.nome_produto
HAVING SUM(ip.quantidade) > 100
ORDER BY quantidade_total_vendida DESC;

SELECT
    pr.categoria,
    SUM(ip.quantidade * ip.preco_unitario) AS total_faturado
FROM produto AS pr
INNER JOIN item_pedido AS ip
    ON ip.id_produto = pr.id_produto
GROUP BY pr.categoria
ORDER BY total_faturado DESC;

SELECT
    MONTH(pe.data_pedido) AS mes,
    COUNT(DISTINCT pe.id_pedido) AS quantidade_pedidos,
    SUM(ip.quantidade * ip.preco_unitario) AS faturamento
FROM pedido AS pe
INNER JOIN item_pedido AS ip
    ON ip.id_pedido = pe.id_pedido
GROUP BY MONTH(pe.data_pedido)
ORDER BY MONTH(pe.data_pedido) ASC;

SELECT nome_cliente, cidade
FROM cliente
WHERE id_cliente IN (
    SELECT pe.id_cliente
    FROM pedido AS pe
    INNER JOIN item_pedido AS ip
        ON ip.id_pedido = pe.id_pedido
    WHERE ip.id_produto IN (
        SELECT id_produto
        FROM produto
        WHERE nome_produto = 'Ovo de Páscoa Dourado'
    )
)
ORDER BY nome_cliente ASC;

SELECT nome_produto, estoque
FROM produto
WHERE id_produto NOT IN (
    SELECT id_produto
    FROM item_pedido
)
ORDER BY nome_produto ASC;

SELECT nome_produto, categoria
FROM produto
WHERE id_produto NOT IN (
    SELECT r.id_produto
    FROM receita AS r
    INNER JOIN ingrediente AS i
        ON i.id_ingrediente = r.id_ingrediente
    INNER JOIN fornecedor AS f
        ON f.id_fornecedor = i.id_fornecedor
    WHERE f.nome_fornecedor = 'Cacau Loompalândia'
)
ORDER BY nome_produto ASC;

SELECT nome, salario
FROM funcionario
WHERE salario > (
    SELECT AVG(salario)
    FROM funcionario
)
ORDER BY salario DESC;

SELECT f.nome, f.salario
FROM funcionario AS f
WHERE f.salario > ALL (
    SELECT f2.salario
    FROM funcionario AS f2
    INNER JOIN setor AS s
        ON s.id_setor = f2.id_setor
    WHERE s.nome_setor = 'Sala de Embalagem'
)
ORDER BY f.salario DESC;

SELECT nome_produto, categoria, preco_venda
FROM produto
WHERE categoria <> 'Bombom'
  AND preco_venda < ANY (
      SELECT preco_venda
      FROM produto
      WHERE categoria = 'Bombom'
  )
ORDER BY preco_venda ASC;

SELECT f.nome_fornecedor, f.pais
FROM fornecedor AS f
WHERE EXISTS (
    SELECT 1
    FROM ingrediente AS i
    INNER JOIN receita AS r
        ON r.id_ingrediente = i.id_ingrediente
    INNER JOIN produto AS pr
        ON pr.id_produto = r.id_produto
    WHERE i.id_fornecedor = f.id_fornecedor
      AND pr.categoria = 'Sazonal'
)
ORDER BY f.nome_fornecedor ASC;

SELECT c.nome_cliente
FROM cliente AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM pedido AS pe
    WHERE pe.id_cliente = c.id_cliente
)
ORDER BY c.nome_cliente ASC;

SELECT
    pr.nome_produto,
    ROUND(SUM(r.qtd_kg * i.preco_kg), 2) AS custo_producao,
    ROUND(pr.preco_venda - SUM(r.qtd_kg * i.preco_kg), 2) AS margem_reais,
    ROUND(
        ((pr.preco_venda - SUM(r.qtd_kg * i.preco_kg)) / pr.preco_venda) * 100,
        2
    ) AS margem_percentual
FROM produto AS pr
INNER JOIN receita AS r
    ON r.id_produto = pr.id_produto
INNER JOIN ingrediente AS i
    ON i.id_ingrediente = r.id_ingrediente
GROUP BY pr.id_produto, pr.nome_produto, pr.preco_venda
ORDER BY margem_percentual DESC;

SELECT
    c.nome_cliente,
    COALESCE(SUM(ip.quantidade * ip.preco_unitario), 0.00) AS total_comprado
FROM cliente AS c
LEFT JOIN pedido AS pe
    ON pe.id_cliente = c.id_cliente
LEFT JOIN item_pedido AS ip
    ON ip.id_pedido = pe.id_pedido
GROUP BY c.id_cliente, c.nome_cliente
HAVING COALESCE(SUM(ip.quantidade * ip.preco_unitario), 0.00) >= ALL (
    SELECT COALESCE(SUM(ip2.quantidade * ip2.preco_unitario), 0.00)
    FROM cliente AS c2
    LEFT JOIN pedido AS pe2
        ON pe2.id_cliente = c2.id_cliente
    LEFT JOIN item_pedido AS ip2
        ON ip2.id_pedido = pe2.id_pedido
    GROUP BY c2.id_cliente
);

SELECT
    i.nome_ingrediente,
    i.estoque_kg,
    i.situacao_estoque,
    COUNT(DISTINCT r.id_produto) AS quantidade_produtos
FROM ingrediente AS i
LEFT JOIN receita AS r
    ON r.id_ingrediente = i.id_ingrediente
WHERE i.situacao_estoque IN ('Crítico', 'Esgotado')
GROUP BY i.id_ingrediente, i.nome_ingrediente, i.estoque_kg, i.situacao_estoque
ORDER BY i.nome_ingrediente ASC;