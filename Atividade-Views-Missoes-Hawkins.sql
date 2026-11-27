CREATE DATABASE IF NOT EXISTS hawkins_missoes
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE hawkins_missoes;

DROP VIEW IF EXISTS vw_tempo_total_personagem;
DROP VIEW IF EXISTS vw_quantidade_missoes_personagem;
DROP VIEW IF EXISTS vw_personagens_missoes_ate_1984;
DROP VIEW IF EXISTS vw_missoes_equipamentos;
DROP VIEW IF EXISTS vw_missoes_criaturas;
DROP VIEW IF EXISTS vw_missao_mais_longa;
DROP VIEW IF EXISTS vw_personagem_mais_jovem;
DROP VIEW IF EXISTS vw_data_maior_duracao_missoes;

DROP TABLE IF EXISTS missao;
DROP TABLE IF EXISTS equipamento;
DROP TABLE IF EXISTS criatura;
DROP TABLE IF EXISTS personagem;

CREATE TABLE personagem (
    codigo INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    idade INT NOT NULL,
    telefone VARCHAR(20) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE criatura (
    codigo INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    nivel_ameaca VARCHAR(20) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE equipamento (
    codigo INT PRIMARY KEY,
    descricao VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE missao (
    codigo INT PRIMARY KEY,
    data DATE NOT NULL,
    hora TIME NOT NULL,
    codPers INT NOT NULL,
    codCriatura INT NULL,
    codEquip INT NULL,
    duracao_min INT NOT NULL,
    CONSTRAINT fk_missao_personagem
        FOREIGN KEY (codPers) REFERENCES personagem(codigo),
    CONSTRAINT fk_missao_criatura
        FOREIGN KEY (codCriatura) REFERENCES criatura(codigo),
    CONSTRAINT fk_missao_equipamento
        FOREIGN KEY (codEquip) REFERENCES equipamento(codigo)
) ENGINE=InnoDB;

INSERT INTO personagem (codigo, nome, email, idade, telefone) VALUES
    (1, 'Eleven', 'eleven@hawkins.com', 14, '(317) 555-0101'),
    (2, 'Mike Wheeler', 'mike@hawkins.com', 13, '(317) 555-0102'),
    (3, 'Dustin Henderson', 'dustin@hawkins.com', 13, '(317) 555-0103'),
    (4, 'Steve Harrington', 'steve@hawkins.com', 18, '(317) 555-0104'),
    (5, 'Erica Sinclair', 'erica@hawkins.com', 10, '(317) 555-0105'),
    (6, 'Jim Hopper', 'hopper@hawkins.com', 42, '(317) 555-0106');

INSERT INTO criatura (codigo, nome, nivel_ameaca) VALUES
    (1, 'Demogorgon', 'Alto'),
    (2, 'Devorador de Mentes', 'Extremo'),
    (3, 'Demodogs', 'Médio'),
    (4, 'Vecna', 'Extremo');

INSERT INTO equipamento (codigo, descricao) VALUES
    (1, 'Walkie-talkie'),
    (2, 'Taco com pregos'),
    (3, 'Rádio Cerebro'),
    (4, 'Lanterna');

INSERT INTO missao (codigo, data, hora, codPers, codCriatura, codEquip, duracao_min) VALUES
    (1, '1983-11-06', '20:00:00', 2, 1, 1, 90),
    (2, '1983-11-12', '21:30:00', 1, 1, NULL, 45),
    (3, '1983-11-12', '22:15:00', 6, NULL, 4, 120),
    (4, '1984-10-31', '19:00:00', 4, 3, 2, 60),
    (5, '1984-11-03', '23:00:00', 4, 3, 2, 150),
    (6, '1985-07-04', '18:00:00', 3, 2, 3, 100),
    (7, '1986-03-25', '16:00:00', 1, 4, NULL, 80);

CREATE VIEW vw_data_maior_duracao_missoes AS
SELECT data
FROM missao
GROUP BY data
HAVING SUM(duracao_min) >= ALL (
    SELECT SUM(duracao_min)
    FROM missao
    GROUP BY data
);

CREATE VIEW vw_personagem_mais_jovem AS
SELECT nome
FROM personagem
WHERE idade = (
    SELECT MIN(idade)
    FROM personagem
);

CREATE VIEW vw_missao_mais_longa AS
SELECT data, hora
FROM missao
WHERE duracao_min = (
    SELECT MAX(duracao_min)
    FROM missao
);

CREATE VIEW vw_missoes_criaturas AS
SELECT
    m.data,
    m.hora,
    c.nome AS criatura
FROM missao AS m
LEFT JOIN criatura AS c
    ON c.codigo = m.codCriatura;

CREATE VIEW vw_missoes_equipamentos AS
SELECT
    m.data,
    e.descricao AS equipamento
FROM missao AS m
LEFT JOIN equipamento AS e
    ON e.codigo = m.codEquip
ORDER BY e.descricao IS NULL, e.descricao ASC;

CREATE VIEW vw_personagens_missoes_ate_1984 AS
SELECT
    p.nome,
    m.data AS data_missao
FROM personagem AS p
LEFT JOIN missao AS m
    ON m.codPers = p.codigo
    AND m.data < '1985-01-01';

CREATE VIEW vw_quantidade_missoes_personagem AS
SELECT
    p.nome,
    p.email,
    p.idade,
    COUNT(m.codigo) AS quantidade_missoes
FROM personagem AS p
LEFT JOIN missao AS m
    ON m.codPers = p.codigo
GROUP BY p.codigo, p.nome, p.email, p.idade
ORDER BY quantidade_missoes ASC, p.nome ASC;

CREATE VIEW vw_tempo_total_personagem AS
SELECT
    p.nome,
    p.telefone,
    COALESCE(SUM(m.duracao_min), 0) AS tempo_total_minutos
FROM personagem AS p
LEFT JOIN missao AS m
    ON m.codPers = p.codigo
GROUP BY p.codigo, p.nome, p.telefone
ORDER BY tempo_total_minutos DESC, p.nome ASC;

SELECT * FROM vw_data_maior_duracao_missoes;
SELECT * FROM vw_personagem_mais_jovem;
SELECT * FROM vw_missao_mais_longa;
SELECT * FROM vw_missoes_criaturas;
SELECT * FROM vw_missoes_equipamentos;
SELECT * FROM vw_personagens_missoes_ate_1984;
SELECT * FROM vw_quantidade_missoes_personagem;
SELECT * FROM vw_tempo_total_personagem;