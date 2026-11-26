CREATE DATABASE IF NOT EXISTS atividade63_relacionamentos
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE atividade63_relacionamentos;

DROP TABLE IF EXISTS funcionario;
DROP TABLE IF EXISTS cliente;
DROP TABLE IF EXISTS pessoa;

CREATE TABLE pessoa (
    id_pessoa INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    cpf VARCHAR(255) NOT NULL,
    rg VARCHAR(255) NOT NULL
);

CREATE TABLE cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    saldo_devedor DECIMAL(10, 2) NOT NULL,
    id_pessoa INT NOT NULL,
    CONSTRAINT fk_cliente_pessoa
        FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa)
);

CREATE TABLE funcionario (
    id_funcionario INT AUTO_INCREMENT PRIMARY KEY,
    matricula VARCHAR(25) NOT NULL,
    salario DECIMAL(10, 2) NOT NULL,
    id_pessoa INT NOT NULL,
    CONSTRAINT fk_funcionario_pessoa
        FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa)
);

INSERT INTO pessoa (nome, cpf, rg) VALUES
    ('Frodo Bolseiro', '111', 'RG1'),
    ('Aragorn', '222', 'RG2'),
    ('Legolas', '333', 'RG3'),
    ('Gimli', '444', 'RG4'),
    ('Gandalf', '555', 'RG5'),
    ('Samwise Gamgee', '666', 'RG6');

INSERT INTO cliente (saldo_devedor, id_pessoa) VALUES
    (150.00, 1),
    (0.00,   2),
    (50.00,  3),
    (500.00, 4),
    (10.00,  6);

INSERT INTO funcionario (matricula, salario, id_pessoa) VALUES
    ('MAG01',   9000.00, 5),
    ('REI01',   8500.00, 2),
    ('ELF01',   7000.00, 3),
    ('ANAO01',  7000.00, 4),
    ('JAR01',   3000.00, 6);

SELECT
    p.nome,
    c.saldo_devedor,
    f.salario
FROM pessoa AS p
INNER JOIN cliente AS c
    ON c.id_pessoa = p.id_pessoa
INNER JOIN funcionario AS f
    ON f.id_pessoa = p.id_pessoa;

SELECT
    salario,
    AVG(salario) AS media_salarial
FROM funcionario
GROUP BY salario
HAVING AVG(salario) > 5000.00;

SELECT
    p.nome,
    f.matricula,
    f.salario
FROM funcionario AS f
INNER JOIN pessoa AS p
    ON p.id_pessoa = f.id_pessoa
WHERE UPPER(p.nome) LIKE 'G%';
