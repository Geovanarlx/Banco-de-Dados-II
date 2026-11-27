CREATE DATABASE IF NOT EXISTS sp_clientes
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE sp_clientes;

DROP PROCEDURE IF EXISTS menormaior;
DROP PROCEDURE IF EXISTS idade;
DROP PROCEDURE IF EXISTS sp_cadastrar_client;
DROP PROCEDURE IF EXISTS sp_relatorio_faixas;

DROP TABLE IF EXISTS cliente;

CREATE TABLE cliente (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    data_nasc DATE NOT NULL
) ENGINE=InnoDB;

INSERT INTO cliente (nome, data_nasc) VALUES
    ('Aguinaldo Neto', '1986-08-02'),
    ('Nicolas Padilha', '2018-07-31'),
    ('Anderson Silva', '2005-03-15'),
    ('João Felix', '1990-11-22');

SELECT * FROM cliente;

DELIMITER $$

CREATE PROCEDURE idade(IN p_id INT, OUT p_idade INT)
BEGIN
    SET p_idade = NULL;
    SELECT YEAR(CURDATE()) - YEAR(data_nasc)
    INTO p_idade
    FROM cliente
    WHERE id = p_id;
END$$

DELIMITER ;

CALL idade(1, @i);
SELECT @i AS idade_calculada;

SELECT
    nome,
    data_nasc,
    YEAR(CURDATE()) - YEAR(data_nasc) AS subtracao_anos,
    TIMESTAMPDIFF(YEAR, data_nasc, CURDATE()) AS idade_real
FROM cliente;

DROP PROCEDURE IF EXISTS idade;

DELIMITER $$

CREATE PROCEDURE idade(IN p_id INT, OUT p_idade INT)
BEGIN
    SET p_idade = NULL;
    SELECT TIMESTAMPDIFF(YEAR, data_nasc, CURDATE())
    INTO p_idade
    FROM cliente
    WHERE id = p_id;
END$$

DELIMITER ;

SET @i = NULL;
CALL idade(99, @i);
SELECT @i AS idade_cliente_inexistente;

DROP PROCEDURE IF EXISTS menormaior;

DELIMITER $$

CREATE PROCEDURE menormaior(
    IN p_id INT,
    OUT p_idade INT,
    OUT p_classe VARCHAR(30)
)
BEGIN
    CALL idade(p_id, p_idade);
    IF p_idade IS NULL THEN
        SET p_classe = 'Cliente não encontrado';
    ELSEIF p_idade >= 18 THEN
        SET p_classe = 'Maior';
    ELSE
        SET p_classe = 'Menor';
    END IF;
END$$

DELIMITER ;

CALL menormaior(1, @idade, @classe);
SELECT @idade AS idade, @classe AS classe;

CALL menormaior(2, @idade, @classe);
SELECT @idade AS idade, @classe AS classe;

CALL menormaior(3, @idade, @classe);
SELECT @idade AS idade, @classe AS classe;

CALL menormaior(4, @idade, @classe);
SELECT @idade AS idade, @classe AS classe;

CALL menormaior(99, @idade, @classe);
SELECT @idade AS idade, @classe AS classe;

DELIMITER $$

CREATE PROCEDURE sp_cadastrar_client(
    IN p_nome VARCHAR(50),
    IN p_data DATE,
    OUT p_msg VARCHAR(100)
)
BEGIN
    IF p_data > CURDATE() THEN
        SET p_msg = 'Data de nascimento não pode estar no futuro';
    ELSE
        INSERT INTO cliente (nome, data_nasc)
        VALUES (p_nome, p_data);
        SET p_msg = CONCAT('Cliente cadastrado com ID ', LAST_INSERT_ID());
    END IF;
END$$

CREATE PROCEDURE sp_relatorio_faixas()
BEGIN
    SELECT
        id,
        nome,
        TIMESTAMPDIFF(YEAR, data_nasc, CURDATE()) AS idade,
        CASE
            WHEN TIMESTAMPDIFF(YEAR, data_nasc, CURDATE()) <= 11 THEN 'Criança'
            WHEN TIMESTAMPDIFF(YEAR, data_nasc, CURDATE()) BETWEEN 12 AND 17 THEN 'Adolescente'
            WHEN TIMESTAMPDIFF(YEAR, data_nasc, CURDATE()) BETWEEN 18 AND 59 THEN 'Adulto'
            ELSE 'Idoso'
        END AS faixa_etaria
    FROM cliente
    ORDER BY id;
END$$

DELIMITER ;

CALL sp_cadastrar_client('Cliente Futuro', '2099-01-01', @m);
SELECT @m AS resultado_cadastro;

CALL sp_cadastrar_client('Maria Lima', '2010-05-20', @m);
SELECT @m AS resultado_cadastro;

CALL sp_relatorio_faixas();