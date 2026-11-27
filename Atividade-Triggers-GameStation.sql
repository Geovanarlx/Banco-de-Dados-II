CREATE DATABASE IF NOT EXISTS gamestation
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE gamestation;

SET SQL_SAFE_UPDATES = 0;

DROP TABLE IF EXISTS item_venda;
DROP TABLE IF EXISTS historico_preco;
DROP TABLE IF EXISTS jogo_removido;
DROP TABLE IF EXISTS venda;
DROP TABLE IF EXISTS cliente;
DROP TABLE IF EXISTS jogo;
DROP TABLE IF EXISTS categoria;

CREATE TABLE categoria (
    id_categoria INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE jogo (
    id_jogo INT PRIMARY KEY AUTO_INCREMENT,
    titulo VARCHAR(100) NOT NULL,
    id_categoria INT NOT NULL,
    plataforma VARCHAR(30) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    estoque INT NOT NULL DEFAULT 0,
    data_cadastro DATETIME NULL,
    data_atualizacao DATETIME NULL,
    CONSTRAINT fk_jogo_categoria
        FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
) ENGINE=InnoDB;

CREATE TABLE cliente (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    data_cadastro DATETIME NULL
) ENGINE=InnoDB;

CREATE TABLE venda (
    id_venda INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    data_venda DATETIME NOT NULL,
    valor_total DECIMAL(10, 2) NOT NULL DEFAULT 0,
    CONSTRAINT fk_venda_cliente
        FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
) ENGINE=InnoDB;

CREATE TABLE item_venda (
    id_item INT PRIMARY KEY AUTO_INCREMENT,
    id_venda INT NOT NULL,
    id_jogo INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10, 2) NOT NULL,
    CONSTRAINT fk_item_venda_venda
        FOREIGN KEY (id_venda) REFERENCES venda(id_venda),
    CONSTRAINT fk_item_venda_jogo
        FOREIGN KEY (id_jogo) REFERENCES jogo(id_jogo)
) ENGINE=InnoDB;

CREATE TABLE historico_preco (
    id_historico INT PRIMARY KEY AUTO_INCREMENT,
    id_jogo INT NOT NULL,
    preco_antigo DECIMAL(10, 2) NOT NULL,
    preco_novo DECIMAL(10, 2) NOT NULL,
    data_alteracao DATETIME NOT NULL
) ENGINE=InnoDB;

CREATE TABLE jogo_removido (
    id_jogo INT NOT NULL,
    titulo VARCHAR(100) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    estoque INT NOT NULL,
    data_remocao DATETIME NOT NULL
) ENGINE=InnoDB;

INSERT INTO categoria (nome) VALUES
    ('Ação'),
    ('Esporte'),
    ('RPG');

DELIMITER $$

CREATE TRIGGER trg_jogo_insert
BEFORE INSERT ON jogo
FOR EACH ROW
BEGIN
    IF NEW.preco <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Preço deve ser maior que zero';
    END IF;
    IF NEW.estoque < 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Estoque não pode ser negativo';
    END IF;
    SET NEW.data_cadastro = NOW();
END$$

CREATE TRIGGER trg_jogo_update
BEFORE UPDATE ON jogo
FOR EACH ROW
BEGIN
    IF NEW.estoque < 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Estoque insuficiente';
    END IF;
    SET NEW.data_atualizacao = NOW();
END$$

CREATE TRIGGER trg_jogo_preco
AFTER UPDATE ON jogo
FOR EACH ROW
BEGIN
    IF OLD.preco <> NEW.preco THEN
        INSERT INTO historico_preco (
            id_jogo,
            preco_antigo,
            preco_novo,
            data_alteracao
        )
        VALUES (
            OLD.id_jogo,
            OLD.preco,
            NEW.preco,
            NOW()
        );
    END IF;
END$$

CREATE TRIGGER trg_jogo_delete
AFTER DELETE ON jogo
FOR EACH ROW
BEGIN
    INSERT INTO jogo_removido (
        id_jogo,
        titulo,
        preco,
        estoque,
        data_remocao
    )
    VALUES (
        OLD.id_jogo,
        OLD.titulo,
        OLD.preco,
        OLD.estoque,
        NOW()
    );
END$$

CREATE TRIGGER trg_cliente_insert
BEFORE INSERT ON cliente
FOR EACH ROW
BEGIN
    SET NEW.email = LOWER(NEW.email);
    SET NEW.data_cadastro = NOW();
END$$

CREATE TRIGGER trg_item_preco
BEFORE INSERT ON item_venda
FOR EACH ROW
BEGIN
    SET NEW.preco_unitario = (
        SELECT preco
        FROM jogo
        WHERE id_jogo = NEW.id_jogo
    );
END$$

CREATE TRIGGER trg_item_estoque
AFTER INSERT ON item_venda
FOR EACH ROW
BEGIN
    UPDATE jogo
    SET estoque = estoque - NEW.quantidade
    WHERE id_jogo = NEW.id_jogo;

    UPDATE venda
    SET valor_total = valor_total + (NEW.quantidade * NEW.preco_unitario)
    WHERE id_venda = NEW.id_venda;
END$$

DELIMITER ;

SHOW TRIGGERS;
SHOW TRIGGERS LIKE 'jogo';
SHOW CREATE TRIGGER trg_item_estoque;

SELECT
    TRIGGER_NAME,
    ACTION_TIMING,
    EVENT_MANIPULATION,
    EVENT_OBJECT_TABLE
FROM information_schema.TRIGGERS
WHERE TRIGGER_SCHEMA = 'gamestation'
ORDER BY EVENT_OBJECT_TABLE, TRIGGER_NAME;

INSERT INTO jogo (titulo, id_categoria, plataforma, preco, estoque) VALUES
    ('Cidade Neon', 1, 'PC', 199.90, 10),
    ('Futebol Total 26', 2, 'PS5', 299.90, 25),
    ('Lendas de Aruanda', 3, 'Switch', 149.90, 8),
    ('Corrida Extrema', 2, 'Xbox', 89.90, 3),
    ('Reino Perdido', 3, 'PC', 249.90, 6);

INSERT INTO cliente (nome, email) VALUES
    ('Ana Souza', 'ANA.SOUZA@EMAIL.COM'),
    ('Bruno Lima', 'bruno.lima@email.com'),
    ('Carla Dias', 'Carla.Dias@Email.com'),
    ('Davi Rocha', 'davi.rocha@email.com');

INSERT INTO jogo (titulo, id_categoria, plataforma, preco, estoque)
VALUES ('Jogo com preço inválido', 1, 'PC', 0.00, 10);

INSERT INTO jogo (titulo, id_categoria, plataforma, preco, estoque)
VALUES ('Jogo com estoque inválido', 1, 'PC', 50.00, -2);

SELECT * FROM jogo;
SELECT * FROM cliente;

UPDATE jogo
SET preco = 179.90
WHERE id_jogo = 1;

SELECT * FROM historico_preco;
SELECT id_jogo, titulo, data_atualizacao
FROM jogo
WHERE id_jogo = 1;

UPDATE jogo
SET estoque = 30
WHERE id_jogo = 2;

SELECT * FROM historico_preco;
SELECT id_jogo, titulo, estoque, data_atualizacao
FROM jogo
WHERE id_jogo = 2;

INSERT INTO venda (id_cliente, data_venda)
VALUES (1, NOW());

INSERT INTO item_venda (id_venda, id_jogo, quantidade) VALUES
    (1, 1, 2),
    (1, 3, 1);

SELECT id_item, id_venda, id_jogo, quantidade, preco_unitario
FROM item_venda
WHERE id_venda = 1;

SELECT id_jogo, titulo, estoque
FROM jogo
WHERE id_jogo IN (1, 3);

SELECT id_venda, valor_total
FROM venda
WHERE id_venda = 1;

INSERT INTO venda (id_cliente, data_venda)
VALUES (2, NOW());

INSERT INTO item_venda (id_venda, id_jogo, quantidade)
VALUES (2, 4, 5);

SELECT id_item, id_venda, id_jogo, quantidade, preco_unitario
FROM item_venda
WHERE id_venda = 2;

SELECT id_jogo, titulo, estoque
FROM jogo
WHERE id_jogo = 4;

SELECT id_venda, valor_total
FROM venda
WHERE id_venda = 2;

DELETE FROM jogo
WHERE id_jogo = 5;

SELECT * FROM jogo_removido;

DELETE FROM jogo
WHERE id_jogo = 1;

SELECT * FROM jogo_removido;

SELECT
    id_venda,
    id_cliente,
    data_venda,
    valor_total
FROM venda
ORDER BY id_venda;

SELECT
    id_jogo,
    titulo,
    preco,
    estoque,
    data_cadastro,
    data_atualizacao
FROM jogo
ORDER BY id_jogo;