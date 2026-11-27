CREATE DATABASE leonida_db;
\connect leonida_db

DROP VIEW IF EXISTS vw_mais_procurados;
DROP VIEW IF EXISTS vw_ficha_criminal;
DROP VIEW IF EXISTS vw_veiculos_sem_dono;
DROP TABLE IF EXISTS participacoes CASCADE;
DROP TABLE IF EXISTS missoes CASCADE;
DROP TABLE IF EXISTS veiculos CASCADE;
DROP TABLE IF EXISTS personagens CASCADE;
DROP TABLE IF EXISTS regioes CASCADE;

CREATE TABLE regioes (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(60) NOT NULL UNIQUE,
    tipo VARCHAR(30)
);

CREATE TABLE personagens (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(80) NOT NULL,
    apelido VARCHAR(40),
    ocupacao VARCHAR(60),
    nivel_procurado INT DEFAULT 0 CHECK (nivel_procurado BETWEEN 0 AND 5),
    saldo NUMERIC(12, 2) DEFAULT 0 CHECK (saldo >= 0),
    id_regiao INT REFERENCES regioes(id)
);

CREATE TABLE veiculos (
    id SERIAL PRIMARY KEY,
    modelo VARCHAR(60) NOT NULL,
    categoria VARCHAR(30),
    preco NUMERIC(10, 2) CHECK (preco > 0),
    id_dono INT REFERENCES personagens(id)
);

CREATE TABLE missoes (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    id_regiao INT REFERENCES regioes(id),
    data_missao DATE,
    valor_estimado NUMERIC(12, 2) CHECK (valor_estimado >= 0),
    status VARCHAR(20) DEFAULT 'planejada' CHECK (status IN ('planejada', 'em_andamento', 'concluida', 'fracassada'))
);

CREATE TABLE participacoes (
    id_missao INT REFERENCES missoes(id),
    id_personagem INT REFERENCES personagens(id),
    funcao VARCHAR(40),
    parte_recebida NUMERIC(12, 2) DEFAULT 0 CHECK (parte_recebida >= 0),
    PRIMARY KEY (id_missao, id_personagem)
);

INSERT INTO regioes (nome, tipo) VALUES
    ('Vice City', 'Cidade'),
    ('Leonida Keys', 'Arquipélago'),
    ('Grassrivers', 'Pântano'),
    ('Port Gellhorn', 'Litoral'),
    ('Ambrosia', 'Interior'),
    ('Mount Kalaga', 'Parque Nacional');

INSERT INTO personagens (nome, apelido, ocupacao, nivel_procurado, saldo, id_regiao) VALUES
    ('Lucia Caminos', 'Lucia', 'Ex-presidiária', 4, 15000.00, 1),
    ('Jason Duval', 'Jason', 'Ex-militar', 3, 12000.00, 2),
    ('Cal Hampton', 'Cal', 'Teórico da conspiração', 0, 800.00, 2),
    ('Boobie Ike', 'Boobie', 'Empresário', 1, 250000.00, 1),
    ('Dre''Quan Priest', 'Dre''Quan', 'Produtor musical', 0, 90000.00, 1),
    ('Raul Bautista', 'Raul', 'Assaltante de bancos', 5, 60000.00, 4),
    ('Brian Heder', 'Brian', 'Contrabandista', 2, 40000.00, 2),
    ('Bae-Luxe', 'Bae-Luxe', 'Rapper', 0, 35000.00, 1),
    ('Roxy', 'Roxy', 'Rapper', 0, 35000.00, 1);

INSERT INTO veiculos (modelo, categoria, preco, id_dono) VALUES
    ('Conversível Vermelho', 'Carro', 85000.00, 1),
    ('Picape 4x4', 'Utilitário', 42000.00, 2),
    ('Lancha Rápida', 'Barco', 120000.00, 7),
    ('Moto Esportiva', 'Moto', 28000.00, 1),
    ('Sedan de Luxo', 'Carro', 150000.00, 4),
    ('Hidroavião', 'Aeronave', 300000.00, NULL),
    ('Jet Ski', 'Barco', 18000.00, NULL),
    ('SUV Blindado', 'Carro', 210000.00, 5);

INSERT INTO missoes (nome, id_regiao, data_missao, valor_estimado, status) VALUES
    ('Assalto à Loja de Conveniência', 2, '2026-01-10', 3500.00, 'concluida'),
    ('Roubo ao Banco de Vice City', 1, '2026-02-14', 450000.00, 'concluida'),
    ('Carga no Pântano', 3, '2026-03-05', 80000.00, 'concluida'),
    ('Golpe na Boate', 1, '2026-04-20', 120000.00, 'fracassada'),
    ('Contrabando nas Keys', 2, '2026-05-18', 200000.00, 'concluida'),
    ('Roubo do Carro-Forte', 5, '2026-06-30', 300000.00, 'em_andamento'),
    ('Resgate em Port Gellhorn', 4, '2026-08-12', 50000.00, 'planejada'),
    ('Fuga para Mount Kalaga', 6, '2026-09-01', 0.00, 'planejada');

INSERT INTO participacoes (id_missao, id_personagem, funcao, parte_recebida) VALUES
    (1, 1, 'Líder', 1750.00),
    (1, 2, 'Motorista', 1750.00),
    (2, 1, 'Líder', 150000.00),
    (2, 2, 'Atirador', 150000.00),
    (2, 6, 'Planejador', 150000.00),
    (3, 2, 'Piloto', 30000.00),
    (3, 7, 'Fornecedor', 50000.00),
    (4, 1, 'Infiltrada', 0.00),
    (4, 5, 'Contato', 0.00),
    (4, 8, 'Distração', 0.00),
    (5, 2, 'Líder', 80000.00),
    (5, 7, 'Fornecedor', 70000.00),
    (5, 3, 'Vigia', 10000.00),
    (6, 1, 'Líder', 0.00),
    (6, 2, 'Motorista', 0.00),
    (6, 6, 'Planejador', 0.00),
    (7, 4, 'Financiador', 0.00);

SELECT * FROM regioes;
SELECT * FROM personagens;
SELECT * FROM veiculos;
SELECT * FROM missoes;
SELECT * FROM participacoes;

SELECT nome, apelido, ocupacao, nivel_procurado
FROM personagens
ORDER BY nivel_procurado DESC, nome ASC;

SELECT modelo, categoria, preco
FROM veiculos
WHERE preco BETWEEN 30000 AND 150000
ORDER BY preco ASC;

SELECT id, nome, status
FROM missoes
WHERE nome ILIKE '%roubo%';

SELECT p.nome AS personagem, m.nome AS missao, pa.funcao, pa.parte_recebida
FROM participacoes AS pa
INNER JOIN personagens AS p ON p.id = pa.id_personagem
INNER JOIN missoes AS m ON m.id = pa.id_missao
WHERE m.status = 'concluida'
ORDER BY m.data_missao;

SELECT p.id, p.nome
FROM personagens AS p
LEFT JOIN participacoes AS pa ON pa.id_personagem = p.id
WHERE pa.id_missao IS NULL;

SELECT v.modelo, v.categoria, p.nome AS dono
FROM personagens AS p
RIGHT JOIN veiculos AS v ON v.id_dono = p.id
ORDER BY v.id;

SELECT r.nome AS regiao, COUNT(p.id) AS quantidade_personagens
FROM regioes AS r
LEFT JOIN personagens AS p ON p.id_regiao = r.id
GROUP BY r.id, r.nome
ORDER BY quantidade_personagens DESC, r.nome;

SELECT p.nome AS personagem, COALESCE(SUM(pa.parte_recebida), 0) AS total_recebido
FROM personagens AS p
LEFT JOIN participacoes AS pa ON pa.id_personagem = p.id
GROUP BY p.id, p.nome
ORDER BY p.nome;

SELECT r.nome AS regiao, COUNT(m.id) AS quantidade_missoes, SUM(m.valor_estimado) AS valor_total
FROM regioes AS r
INNER JOIN missoes AS m ON m.id_regiao = r.id
GROUP BY r.id, r.nome
HAVING SUM(m.valor_estimado) > 100000
ORDER BY valor_total DESC;

SELECT p.nome, COUNT(pa.id_missao) AS quantidade_missoes
FROM personagens AS p
INNER JOIN participacoes AS pa ON pa.id_personagem = p.id
GROUP BY p.id, p.nome
ORDER BY quantidade_missoes DESC, p.nome
LIMIT 3;

SELECT nome, saldo
FROM personagens
WHERE saldo > (SELECT AVG(saldo) FROM personagens)
ORDER BY saldo DESC;

SELECT m.id, m.nome
FROM missoes AS m
WHERE NOT EXISTS (
    SELECT 1
    FROM participacoes AS pa
    WHERE pa.id_missao = m.id
);

SELECT nome, 'Personagem' AS tipo
FROM personagens
UNION
SELECT nome, 'Região' AS tipo
FROM regioes
ORDER BY nome;

CREATE VIEW vw_ficha_criminal AS
SELECT
    p.id,
    p.nome,
    p.apelido,
    r.nome AS regiao,
    p.nivel_procurado,
    COUNT(DISTINCT pa.id_missao) AS qtd_missoes,
    COALESCE(SUM(pa.parte_recebida), 0)::NUMERIC(12, 2) AS total_recebido
FROM personagens AS p
LEFT JOIN regioes AS r ON r.id = p.id_regiao
LEFT JOIN participacoes AS pa ON pa.id_personagem = p.id
GROUP BY p.id, p.nome, p.apelido, r.nome, p.nivel_procurado;

CREATE VIEW vw_mais_procurados AS
SELECT *
FROM vw_ficha_criminal
WHERE nivel_procurado >= 3;

SELECT *
FROM vw_mais_procurados
ORDER BY nivel_procurado DESC, nome;

CREATE VIEW vw_veiculos_sem_dono AS
SELECT id, modelo, categoria, preco, id_dono
FROM veiculos
WHERE id_dono IS NULL;

UPDATE vw_veiculos_sem_dono
SET preco = 280000.00
WHERE modelo = 'Hidroavião';

SELECT * FROM veiculos WHERE modelo = 'Hidroavião';

DO $$
BEGIN
    UPDATE vw_ficha_criminal
    SET nivel_procurado = 5
    WHERE nome = 'Jason Duval';
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE '%: %', SQLSTATE, SQLERRM;
END $$;

ALTER TABLE personagens ADD COLUMN perfil_social VARCHAR(50);

UPDATE personagens
SET perfil_social = '@lucia.vc'
WHERE nome = 'Lucia Caminos';

UPDATE personagens
SET perfil_social = '@jason.keys'
WHERE nome = 'Jason Duval';

ALTER TABLE personagens RENAME COLUMN saldo TO dinheiro_vivo;

SELECT nome, dinheiro_vivo
FROM personagens
ORDER BY nome;

UPDATE missoes
SET status = 'concluida'
WHERE nome = 'Roubo do Carro-Forte';

UPDATE participacoes
SET parte_recebida = 100000.00
WHERE id_missao = (
    SELECT id
    FROM missoes
    WHERE nome = 'Roubo do Carro-Forte'
);

SELECT * FROM vw_ficha_criminal ORDER BY id;

DO $$
BEGIN
    INSERT INTO personagens (nome, nivel_procurado)
    VALUES ('Fã de Leonida', 6);
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE '%: %', SQLSTATE, SQLERRM;
END $$;

DO $$
BEGIN
    INSERT INTO missoes (nome, status)
    VALUES ('Missão Teste', 'abandonada');
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE '%: %', SQLSTATE, SQLERRM;
END $$;

DO $$
BEGIN
    DELETE FROM personagens
    WHERE nome = 'Lucia Caminos';
EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE '%: %', SQLSTATE, SQLERRM;
END $$;

DELETE FROM personagens
WHERE nome = 'Roxy';

SELECT * FROM personagens ORDER BY id;

