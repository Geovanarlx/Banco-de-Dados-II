CREATE DATABASE IF NOT EXISTS atividade67_clinica
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE atividade67_clinica;

DROP TABLE IF EXISTS paciente;
DROP TABLE IF EXISTS profissional;
DROP TABLE IF EXISTS pessoa;
DROP TABLE IF EXISTS unidade;

CREATE TABLE unidade (
    id_unidade INT PRIMARY KEY AUTO_INCREMENT,
    nome_unidade VARCHAR(50) NOT NULL
);

CREATE TABLE pessoa (
    id_pessoa INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL,
    telefone VARCHAR(20) NOT NULL
);

CREATE TABLE profissional (
    id_prof INT PRIMARY KEY AUTO_INCREMENT,
    crm_coren VARCHAR(20) NOT NULL,
    salario DECIMAL(10, 2) NOT NULL,
    id_pessoa INT NOT NULL,
    id_unidade INT NOT NULL,
    CONSTRAINT fk_profissional_pessoa
        FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa),
    CONSTRAINT fk_profissional_unidade
        FOREIGN KEY (id_unidade) REFERENCES unidade(id_unidade)
);

CREATE TABLE paciente (
    id_paciente INT PRIMARY KEY AUTO_INCREMENT,
    debito_exames DECIMAL(10, 2) NOT NULL,
    id_pessoa INT NOT NULL,
    CONSTRAINT fk_paciente_pessoa
        FOREIGN KEY (id_pessoa) REFERENCES pessoa(id_pessoa)
);

INSERT INTO unidade (nome_unidade) VALUES
    ('Cardiologia'),
    ('Pronto Atendimento'),
    ('Oncologia');

INSERT INTO pessoa (nome, cpf, telefone) VALUES
    ('Dr. Goku', '111', '9999-0001'),
    ('Enf. Buma', '222', '9999-0002'),
    ('Vegeta', '333', '9999-0003'),
    ('Piccolo', '444', '9999-0004'),
    ('Dra. Videl', '555', '9999-0005'),
    ('Dr. Gohan', '666', '9999-0006'),
    ('Trunks', '777', '9999-0007'),
    ('Majin Boo', '888', '9999-0008'),
    ('Broly', '999', '9999-0009');

INSERT INTO profissional (crm_coren, salario, id_pessoa, id_unidade) VALUES
    ('MD123', 15000.00, 1, 1),
    ('ENF456', 6000.00, 2, 2),
    ('TEC789', 4500.00, 3, 2),
    ('MD555', 12000.00, 5, 1),
    ('MD666', 20000.00, 6, 3),
    ('MD888', 18000.00, 8, 3);

INSERT INTO paciente (debito_exames, id_pessoa) VALUES
    (250.00, 3),
    (1200.00, 4),
    (3500.00, 7),
    (50.00, 9);

ALTER TABLE profissional
ADD COLUMN status_plantao VARCHAR(20) NOT NULL DEFAULT 'Indisponível';

UPDATE profissional
SET status_plantao = CASE
    WHEN salario > 10000.00 THEN 'Disponível'
    ELSE 'Indisponível'
END;

SELECT
    u.nome_unidade,
    COUNT(pr.id_prof) AS quantidade_profissionais,
    SUM(pr.salario) AS soma_salarios,
    AVG(pr.salario) AS media_salarial
FROM unidade AS u
INNER JOIN profissional AS pr
    ON pr.id_unidade = u.id_unidade
GROUP BY u.id_unidade, u.nome_unidade
HAVING AVG(pr.salario) > 8000.00;

SELECT
    p.nome,
    pr.crm_coren,
    SUM(pa.debito_exames) AS total_debito_exames
FROM pessoa AS p
INNER JOIN profissional AS pr
    ON pr.id_pessoa = p.id_pessoa
INNER JOIN paciente AS pa
    ON pa.id_pessoa = p.id_pessoa
GROUP BY pr.id_prof, p.id_pessoa, p.nome, pr.crm_coren;

SELECT
    p.nome,
    pr.salario,
    pr.status_plantao
FROM profissional AS pr
INNER JOIN pessoa AS p
    ON p.id_pessoa = pr.id_pessoa
WHERE UPPER(TRIM(SUBSTRING(p.nome, LOCATE(' ', p.nome) + 1))) LIKE 'G%'
ORDER BY pr.salario DESC;

SELECT
    SUM(debito_exames) AS total_a_receber
FROM paciente;