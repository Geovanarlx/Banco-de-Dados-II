CREATE DATABASE IF NOT EXISTS hogwarts
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE hogwarts;

SET SQL_SAFE_UPDATES = 0;

DROP VIEW IF EXISTS vw_alunos_destaque;
DROP VIEW IF EXISTS vw_quadro_professores;
DROP VIEW IF EXISTS vw_extrato_loja;
DROP VIEW IF EXISTS vw_boletim;
DROP VIEW IF EXISTS vw_placar_casas;

DROP TABLE IF EXISTS compra;
DROP TABLE IF EXISTS registro_pontos;
DROP TABLE IF EXISTS matricula;
DROP TABLE IF EXISTS disciplina;
DROP TABLE IF EXISTS produto;
DROP TABLE IF EXISTS aluno;
DROP TABLE IF EXISTS professor;
DROP TABLE IF EXISTS log_auditoria;
DROP TABLE IF EXISTS casa;

CREATE TABLE casa (
    id_casa INT PRIMARY KEY AUTO_INCREMENT,
    nome_casa VARCHAR(30) NOT NULL UNIQUE,
    fundador VARCHAR(100),
    pontos INT DEFAULT 0
) ENGINE=InnoDB;

CREATE TABLE professor (
    id_prof INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    salario DECIMAL(10, 2) NOT NULL,
    data_contratacao DATE,
    id_casa INT NULL,
    CONSTRAINT chk_professor_salario CHECK (salario > 0),
    CONSTRAINT fk_professor_casa
        FOREIGN KEY (id_casa) REFERENCES casa(id_casa)
) ENGINE=InnoDB;

CREATE TABLE disciplina (
    id_disc INT PRIMARY KEY AUTO_INCREMENT,
    nome_disc VARCHAR(60) NOT NULL UNIQUE,
    ano_minimo INT NOT NULL,
    id_prof INT NULL,
    CONSTRAINT chk_disciplina_ano CHECK (ano_minimo BETWEEN 1 AND 7),
    CONSTRAINT fk_disciplina_professor
        FOREIGN KEY (id_prof) REFERENCES professor(id_prof)
) ENGINE=InnoDB;

CREATE TABLE aluno (
    id_aluno INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    ano_escolar INT NOT NULL,
    id_casa INT NULL,
    saldo_galeoes DECIMAL(10, 2) DEFAULT 0,
    CONSTRAINT chk_aluno_ano CHECK (ano_escolar BETWEEN 1 AND 7),
    CONSTRAINT chk_aluno_saldo CHECK (saldo_galeoes >= 0),
    CONSTRAINT fk_aluno_casa
        FOREIGN KEY (id_casa) REFERENCES casa(id_casa)
) ENGINE=InnoDB;

CREATE TABLE matricula (
    id_aluno INT NOT NULL,
    id_disc INT NOT NULL,
    nota DECIMAL(4, 2) NOT NULL,
    PRIMARY KEY (id_aluno, id_disc),
    CONSTRAINT chk_matricula_nota CHECK (nota BETWEEN 0 AND 10),
    CONSTRAINT fk_matricula_aluno
        FOREIGN KEY (id_aluno) REFERENCES aluno(id_aluno),
    CONSTRAINT fk_matricula_disciplina
        FOREIGN KEY (id_disc) REFERENCES disciplina(id_disc)
) ENGINE=InnoDB;

CREATE TABLE registro_pontos (
    id_registro INT PRIMARY KEY AUTO_INCREMENT,
    id_aluno INT NOT NULL,
    id_prof INT NOT NULL,
    pontos INT NOT NULL,
    motivo VARCHAR(150),
    data_registro DATE NOT NULL,
    CONSTRAINT fk_registro_pontos_aluno
        FOREIGN KEY (id_aluno) REFERENCES aluno(id_aluno),
    CONSTRAINT fk_registro_pontos_professor
        FOREIGN KEY (id_prof) REFERENCES professor(id_prof)
) ENGINE=InnoDB;

CREATE TABLE produto (
    id_produto INT PRIMARY KEY AUTO_INCREMENT,
    nome_produto VARCHAR(100) NOT NULL,
    loja VARCHAR(50) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    estoque INT DEFAULT 0,
    CONSTRAINT chk_produto_preco CHECK (preco > 0),
    CONSTRAINT chk_produto_estoque CHECK (estoque >= 0)
) ENGINE=InnoDB;

CREATE TABLE compra (
    id_compra INT PRIMARY KEY AUTO_INCREMENT,
    id_aluno INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    valor_total DECIMAL(10, 2) NOT NULL DEFAULT 0,
    data_compra DATE NOT NULL,
    CONSTRAINT chk_compra_quantidade CHECK (quantidade > 0),
    CONSTRAINT fk_compra_aluno
        FOREIGN KEY (id_aluno) REFERENCES aluno(id_aluno),
    CONSTRAINT fk_compra_produto
        FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
) ENGINE=InnoDB;

CREATE TABLE log_auditoria (
    id_log INT PRIMARY KEY AUTO_INCREMENT,
    tabela VARCHAR(30),
    operacao VARCHAR(10),
    descricao VARCHAR(255),
    data_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

INSERT INTO casa (nome_casa, fundador) VALUES
    ('Grifinória', 'Godric Gryffindor'),
    ('Sonserina', 'Salazar Slytherin'),
    ('Corvinal', 'Rowena Ravenclaw'),
    ('Lufa-Lufa', 'Helga Hufflepuff');

INSERT INTO professor (nome, salario, data_contratacao, id_casa) VALUES
    ('Minerva McGonagall', 9500.00, '1956-12-01', 1),
    ('Severo Snape', 8800.00, '1981-09-01', 2),
    ('Fílio Flitwick', 8200.00, '1974-09-01', 3),
    ('Pomona Sprout', 7900.00, '1972-09-01', 4),
    ('Rúbeo Hagrid', 4500.00, '1993-09-01', NULL),
    ('Remo Lupin', 6200.00, '1993-09-01', NULL),
    ('Sibila Trelawney', 5100.00, '1980-09-01', NULL),
    ('Gilderoy Lockhart', 7000.00, '1992-09-01', NULL),
    ('Horácio Slughorn', 8000.00, '1996-09-01', NULL);

INSERT INTO disciplina (nome_disc, ano_minimo, id_prof) VALUES
    ('Transfiguração', 1, 1),
    ('Poções', 1, 2),
    ('Feitiços', 1, 3),
    ('Herbologia', 1, 4),
    ('Trato das Criaturas Mágicas', 3, 5),
    ('Defesa Contra as Artes das Trevas', 1, 6),
    ('Adivinhação', 3, 7),
    ('Estudo dos Trouxas', 3, NULL),
    ('Runas Antigas', 3, NULL);

INSERT INTO aluno (nome, ano_escolar, id_casa, saldo_galeoes) VALUES
    ('Harry Potter', 5, 1, 120.00),
    ('Hermione Granger', 5, 1, 85.00),
    ('Rony Weasley', 5, 1, 12.00),
    ('Neville Longbottom', 5, 1, 30.00),
    ('Draco Malfoy', 5, 2, 500.00),
    ('Pansy Parkinson', 5, 2, 150.00),
    ('Vicente Crabbe', 5, 2, 40.00),
    ('Luna Lovegood', 4, 3, 45.00),
    ('Cho Chang', 6, 3, 200.00),
    ('Padma Patil', 5, 3, 60.00),
    ('Cedrico Diggory', 7, 4, 180.00),
    ('Ana Abbott', 5, 4, 25.00),
    ('Ernesto Macmillan', 5, 4, 70.00),
    ('Teddy Lupin', 1, NULL, 0.00);

INSERT INTO matricula (id_aluno, id_disc, nota) VALUES
    (1, 1, 7.5), (1, 2, 5.0), (1, 6, 9.8), (1, 5, 8.0),
    (2, 1, 10.0), (2, 2, 9.5), (2, 3, 10.0), (2, 5, 9.0), (2, 9, 9.5),
    (3, 1, 6.0), (3, 2, 4.5), (3, 7, 5.5),
    (4, 2, 3.0), (4, 4, 10.0), (4, 6, 7.0),
    (5, 2, 9.0), (5, 1, 7.0), (5, 5, 4.0),
    (6, 2, 7.5), (6, 7, 6.5),
    (7, 2, 3.5), (7, 6, 2.0),
    (8, 5, 8.5), (8, 3, 8.0), (8, 4, 9.0),
    (9, 3, 8.5), (9, 6, 7.5),
    (10, 3, 9.0), (10, 7, 6.0),
    (11, 4, 8.5), (11, 6, 9.0), (11, 1, 8.0),
    (12, 4, 8.0),
    (13, 4, 7.0), (13, 3, 7.5);

INSERT INTO produto (nome_produto, loja, preco, estoque) VALUES
    ('Varinha de Azevinho', 'Olivaras', 7.00, 10),
    ('Vassoura Nimbus 2001', 'Artigos de Quadribol', 300.00, 3),
    ('Sapo de Chocolate', 'Dedosdemel', 2.00, 200),
    ('Feijõezinhos de Todos os Sabores', 'Dedosdemel', 1.50, 150),
    ('Livro Monstruoso dos Monstros', 'Floreios e Borrões', 12.00, 20),
    ('Caldeirão de Estanho', 'Caldeirões Potage', 9.00, 0),
    ('Kit de Logros', 'Gemialidades Weasley', 25.00, 40),
    ('Pena de Repetição Rápida', 'Escribbulus', 15.00, 5);

SELECT
    (SELECT COUNT(*) FROM casa) AS total_casas,
    (SELECT COUNT(*) FROM professor) AS total_professores,
    (SELECT COUNT(*) FROM disciplina) AS total_disciplinas,
    (SELECT COUNT(*) FROM aluno) AS total_alunos,
    (SELECT COUNT(*) FROM matricula) AS total_matriculas,
    (SELECT COUNT(*) FROM produto) AS total_produtos;

ALTER TABLE aluno
ADD COLUMN email VARCHAR(100);

ALTER TABLE matricula
ADD COLUMN situacao VARCHAR(20) DEFAULT 'Cursando';

ALTER TABLE produto
ADD COLUMN ativo CHAR(1) DEFAULT 'S';

ALTER TABLE casa
MODIFY COLUMN fundador VARCHAR(100);

ALTER TABLE professor
RENAME COLUMN data_contratacao TO data_admissao;

UPDATE aluno
SET email = CONCAT(LOWER(REPLACE(nome, ' ', '.')), '@hogwarts.edu');

ALTER TABLE aluno
ADD CONSTRAINT uq_aluno_email UNIQUE (email);

UPDATE matricula
SET nota = LEAST(nota + 0.5, 10.0)
WHERE id_disc IN (
    SELECT id_disc
    FROM disciplina
    WHERE id_prof = (
        SELECT id_prof
        FROM professor
        WHERE nome = 'Remo Lupin'
    )
);

UPDATE matricula
SET situacao = CASE
    WHEN nota >= 6 THEN 'Aprovado'
    ELSE 'Reprovado'
END;

UPDATE professor
SET salario = salario * 1.10
WHERE id_casa IS NOT NULL
  AND data_admissao < '1980-01-01';

UPDATE produto
SET ativo = 'N'
WHERE estoque = 0;

UPDATE produto
SET preco = preco * 0.80
WHERE loja = 'Dedosdemel';

SELECT
    id_aluno,
    nome,
    email,
    saldo_galeoes
FROM aluno
ORDER BY id_aluno;

SELECT
    id_prof,
    nome,
    salario,
    data_admissao
FROM professor
ORDER BY id_prof;

DELIMITER $$

CREATE PROCEDURE testar_exclusao_casa()
BEGIN
    DECLARE v_codigo INT;
    DECLARE v_mensagem TEXT;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = MYSQL_ERRNO,
            v_mensagem = MESSAGE_TEXT;
        SELECT v_codigo AS codigo_erro, v_mensagem AS mensagem_erro;
    END;
    DELETE FROM casa
    WHERE nome_casa = 'Sonserina';
END$$

CREATE PROCEDURE testar_check_dobby()
BEGIN
    DECLARE v_codigo INT;
    DECLARE v_mensagem TEXT;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = MYSQL_ERRNO,
            v_mensagem = MESSAGE_TEXT;
        SELECT v_codigo AS codigo_erro, v_mensagem AS mensagem_erro;
    END;
    INSERT INTO aluno (nome, ano_escolar, id_casa, saldo_galeoes, email)
    VALUES ('Dobby', 8, 1, 0.00, 'dobby@hogwarts.edu');
END$$

CREATE PROCEDURE testar_email_repetido()
BEGIN
    DECLARE v_codigo INT;
    DECLARE v_mensagem TEXT;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = MYSQL_ERRNO,
            v_mensagem = MESSAGE_TEXT;
        SELECT v_codigo AS codigo_erro, v_mensagem AS mensagem_erro;
    END;
    INSERT INTO aluno (nome, ano_escolar, id_casa, saldo_galeoes, email)
    VALUES ('Harry Potter (Polissuco)', 5, 1, 0.00, 'harry.potter@hogwarts.edu');
END$$

CREATE PROCEDURE testar_exclusao_snape()
BEGIN
    DECLARE v_codigo INT;
    DECLARE v_mensagem TEXT;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = MYSQL_ERRNO,
            v_mensagem = MESSAGE_TEXT;
        SELECT v_codigo AS codigo_erro, v_mensagem AS mensagem_erro;
    END;
    DELETE FROM professor
    WHERE nome = 'Severo Snape';
END$$

DELIMITER ;

CALL testar_exclusao_casa();
CALL testar_check_dobby();
CALL testar_email_repetido();
CALL testar_exclusao_snape();

DROP PROCEDURE testar_exclusao_casa;
DROP PROCEDURE testar_check_dobby;
DROP PROCEDURE testar_email_repetido;
DROP PROCEDURE testar_exclusao_snape;

DELETE FROM professor
WHERE nome = 'Gilderoy Lockhart';

DELETE FROM matricula
WHERE id_aluno IN (
    SELECT id_aluno
    FROM aluno
    WHERE nome = 'Vicente Crabbe'
);

DELETE FROM aluno
WHERE nome = 'Vicente Crabbe';

DELETE FROM disciplina
WHERE id_disc NOT IN (
    SELECT id_disc
    FROM matricula
);

SELECT
    (SELECT COUNT(*) FROM professor) AS total_professores,
    (SELECT COUNT(*) FROM aluno) AS total_alunos,
    (SELECT COUNT(*) FROM disciplina) AS total_disciplinas,
    (SELECT COUNT(*) FROM matricula) AS total_matriculas;

DELIMITER $$

CREATE TRIGGER trg_pontos_casa
AFTER INSERT ON registro_pontos
FOR EACH ROW
BEGIN
    UPDATE casa AS c
    INNER JOIN aluno AS a
        ON a.id_casa = c.id_casa
    SET c.pontos = c.pontos + NEW.pontos
    WHERE a.id_aluno = NEW.id_aluno;
END$$

CREATE TRIGGER trg_valida_compra
BEFORE INSERT ON compra
FOR EACH ROW
BEGIN
    DECLARE v_estoque INT;
    DECLARE v_preco DECIMAL(10, 2);
    DECLARE v_saldo DECIMAL(10, 2);

    SELECT estoque, preco
    INTO v_estoque, v_preco
    FROM produto
    WHERE id_produto = NEW.id_produto;

    SELECT saldo_galeoes
    INTO v_saldo
    FROM aluno
    WHERE id_aluno = NEW.id_aluno;

    IF v_estoque < NEW.quantidade THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Estoque insuficiente no Beco Diagonal';
    END IF;

    IF v_saldo < (v_preco * NEW.quantidade) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Galeões insuficientes no cofre do aluno';
    END IF;

    SET NEW.valor_total = v_preco * NEW.quantidade;
END$$

CREATE TRIGGER trg_baixa_compra
AFTER INSERT ON compra
FOR EACH ROW
BEGIN
    UPDATE produto
    SET estoque = estoque - NEW.quantidade
    WHERE id_produto = NEW.id_produto;

    UPDATE aluno
    SET saldo_galeoes = saldo_galeoes - NEW.valor_total
    WHERE id_aluno = NEW.id_aluno;
END$$

CREATE TRIGGER trg_situacao_nota
BEFORE UPDATE ON matricula
FOR EACH ROW
BEGIN
    IF OLD.nota <> NEW.nota THEN
        SET NEW.situacao = CASE
            WHEN NEW.nota >= 6 THEN 'Aprovado'
            ELSE 'Reprovado'
        END;
    END IF;
END$$

CREATE TRIGGER trg_audita_salario
AFTER UPDATE ON professor
FOR EACH ROW
BEGIN
    IF OLD.salario <> NEW.salario THEN
        INSERT INTO log_auditoria (tabela, operacao, descricao)
        VALUES (
            'professor',
            'UPDATE',
            CONCAT(
                OLD.nome,
                ': salário de ',
                CAST(OLD.salario AS CHAR),
                ' para ',
                CAST(NEW.salario AS CHAR)
            )
        );
    END IF;
END$$

DELIMITER ;

INSERT INTO registro_pontos (id_aluno, id_prof, pontos, motivo, data_registro) VALUES
    (2, 3, 20, 'Feitiço de levitação perfeito', '2026-09-10'),
    (1, 2, -10, 'Atraso na aula de Poções', '2026-09-12'),
    (5, 2, 15, 'Poção do Morto-Vivo impecável', '2026-09-12'),
    (8, 5, 10, 'Cuidou de um testrálio ferido', '2026-09-20'),
    (11, 4, 25, 'Ajudou os alunos do 1º ano', '2026-09-25'),
    (4, 4, 30, 'Identificou uma Mimbulus mimbletonia', '2026-10-02'),
    (6, 1, -20, 'Fora da cama após o toque de recolher', '2026-10-05'),
    (1, 6, 50, 'Conjurou um Patrono corpóreo', '2026-10-15'),
    (9, 3, 15, 'Duelo exemplar no Clube de Duelos', '2026-10-18'),
    (5, 1, -30, 'Duelo proibido no corredor', '2026-10-31'),
    (10, 7, 5, 'Interpretação da bola de cristal', '2026-11-03'),
    (13, 4, 10, 'Colheita de mandrágoras', '2026-11-05'),
    (3, 9, 10, 'Identificou um bezoar', '2026-11-06'),
    (8, 3, 20, 'Resposta brilhante sobre o Diadema', '2026-11-08'),
    (6, 2, 25, 'Antídoto para venenos comuns', '2026-11-09'),
    (5, 9, 40, 'Melhor poção do Clube do Slugue', '2026-11-09');

INSERT INTO compra (id_aluno, id_produto, quantidade, data_compra) VALUES
    (5, 2, 1, '2026-09-01'),
    (2, 5, 2, '2026-09-02'),
    (1, 3, 10, '2026-09-03'),
    (3, 4, 5, '2026-09-03'),
    (9, 8, 1, '2026-09-15'),
    (8, 5, 1, '2026-09-20'),
    (11, 1, 1, '2026-10-01'),
    (6, 3, 20, '2026-10-10'),
    (1, 7, 2, '2026-10-20'),
    (13, 4, 10, '2026-11-02');

SELECT id_casa, nome_casa, pontos
FROM casa
ORDER BY id_casa;

SELECT id_aluno, nome, saldo_galeoes
FROM aluno
ORDER BY id_aluno;

SELECT id_produto, nome_produto, estoque
FROM produto
ORDER BY id_produto;

SELECT SUM(valor_total) AS total_galeoes_compras
FROM compra;

DELIMITER $$

CREATE PROCEDURE testar_compra_nimbus()
BEGIN
    DECLARE v_codigo INT;
    DECLARE v_mensagem TEXT;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = MYSQL_ERRNO,
            v_mensagem = MESSAGE_TEXT;
        SELECT v_codigo AS codigo_erro, v_mensagem AS mensagem_erro;
    END;
    INSERT INTO compra (id_aluno, id_produto, quantidade, data_compra)
    VALUES (3, 2, 1, '2026-11-10');
END$$

CREATE PROCEDURE testar_compra_caldeirao()
BEGIN
    DECLARE v_codigo INT;
    DECLARE v_mensagem TEXT;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1
            v_codigo = MYSQL_ERRNO,
            v_mensagem = MESSAGE_TEXT;
        SELECT v_codigo AS codigo_erro, v_mensagem AS mensagem_erro;
    END;
    INSERT INTO compra (id_aluno, id_produto, quantidade, data_compra)
    VALUES (2, 6, 1, '2026-11-10');
END$$

DELIMITER ;

CALL testar_compra_nimbus();
CALL testar_compra_caldeirao();

DROP PROCEDURE testar_compra_nimbus;
DROP PROCEDURE testar_compra_caldeirao;

UPDATE matricula AS m
INNER JOIN aluno AS a
    ON a.id_aluno = m.id_aluno
INNER JOIN disciplina AS d
    ON d.id_disc = m.id_disc
SET m.nota = 6.5
WHERE a.nome = 'Rony Weasley'
  AND d.nome_disc = 'Poções';

SELECT a.nome, d.nome_disc, m.nota, m.situacao
FROM matricula AS m
INNER JOIN aluno AS a
    ON a.id_aluno = m.id_aluno
INNER JOIN disciplina AS d
    ON d.id_disc = m.id_disc
WHERE a.nome = 'Rony Weasley'
  AND d.nome_disc = 'Poções';

UPDATE professor
SET salario = 5000.00
WHERE nome = 'Rúbeo Hagrid';

UPDATE professor
SET data_admissao = '1993-08-15'
WHERE nome = 'Rúbeo Hagrid';

SELECT * FROM log_auditoria;

START TRANSACTION;

UPDATE aluno
SET saldo_galeoes = saldo_galeoes - 50
WHERE nome = 'Draco Malfoy';

UPDATE aluno
SET saldo_galeoes = saldo_galeoes + 50
WHERE nome = 'Pansy Parkinson';

COMMIT;

SELECT nome, saldo_galeoes
FROM aluno
WHERE nome IN ('Draco Malfoy', 'Pansy Parkinson');

START TRANSACTION;

UPDATE casa
SET pontos = 0;

SELECT id_casa, nome_casa, pontos
FROM casa
ORDER BY id_casa;

ROLLBACK;

SELECT id_casa, nome_casa, pontos
FROM casa
ORDER BY id_casa;

START TRANSACTION;

INSERT INTO compra (id_aluno, id_produto, quantidade, data_compra)
VALUES (1, 1, 1, '2026-11-10');

SELECT nome, saldo_galeoes
FROM aluno
WHERE id_aluno = 1;

SELECT nome_produto, estoque
FROM produto
WHERE id_produto = 1;

ROLLBACK;

SELECT nome, saldo_galeoes
FROM aluno
WHERE id_aluno = 1;

SELECT nome_produto, estoque
FROM produto
WHERE id_produto = 1;

START TRANSACTION;

INSERT INTO registro_pontos (id_aluno, id_prof, pontos, motivo, data_registro)
VALUES (12, 4, 15, 'Cuidou das estufas no feriado', '2026-11-10');

SAVEPOINT sp_pontos_legitimos;

INSERT INTO registro_pontos (id_aluno, id_prof, pontos, motivo, data_registro)
VALUES (6, 2, 100, 'Favoritismo descarado', '2026-11-10');

ROLLBACK TO SAVEPOINT sp_pontos_legitimos;

COMMIT;

SELECT @@autocommit;

SELECT id_casa, nome_casa, pontos
FROM casa
ORDER BY id_casa;

SELECT COUNT(*) AS total_registros_pontos
FROM registro_pontos;

SELECT
    f.nome,
    f.salario
FROM professor AS f
WHERE f.salario BETWEEN 6000.00 AND 9000.00
ORDER BY f.salario DESC;

SELECT nome, ano_escolar
FROM aluno
WHERE ano_escolar IN (1, 4, 6, 7)
ORDER BY ano_escolar ASC, nome ASC;

SELECT nome
FROM aluno
WHERE nome LIKE '_a%'
ORDER BY nome ASC;

SELECT nome_disc
FROM disciplina
WHERE id_prof IS NULL
ORDER BY nome_disc ASC;

SELECT nome_produto, preco
FROM produto
WHERE preco NOT BETWEEN 5.00 AND 20.00
ORDER BY preco ASC;

SELECT DISTINCT loja
FROM produto
ORDER BY loja ASC;

SELECT
    a.nome AS aluno,
    c.nome_casa AS casa
FROM aluno AS a
INNER JOIN casa AS c
    ON c.id_casa = a.id_casa
ORDER BY c.nome_casa ASC, a.nome ASC;

SELECT
    a.nome AS aluno,
    COALESCE(c.nome_casa, 'Aguardando o Chapéu Seletor') AS casa
FROM aluno AS a
LEFT JOIN casa AS c
    ON c.id_casa = a.id_casa
ORDER BY a.nome ASC;

SELECT
    p.id_prof,
    p.nome
FROM disciplina AS d
RIGHT JOIN professor AS p
    ON p.id_prof = d.id_prof
WHERE d.id_disc IS NULL
ORDER BY p.nome ASC;

SELECT
    a.nome AS aluno,
    c.nome_casa AS casa,
    d.nome_disc AS disciplina,
    COALESCE(p.nome, 'Sem professor') AS professor,
    m.nota,
    m.situacao
FROM aluno AS a
INNER JOIN casa AS c
    ON c.id_casa = a.id_casa
INNER JOIN matricula AS m
    ON m.id_aluno = a.id_aluno
INNER JOIN disciplina AS d
    ON d.id_disc = m.id_disc
LEFT JOIN professor AS p
    ON p.id_prof = d.id_prof
WHERE c.nome_casa = 'Grifinória'
ORDER BY a.nome ASC, d.nome_disc ASC;

SELECT
    co.id_compra,
    a.nome AS aluno,
    pr.nome_produto AS produto,
    pr.loja,
    co.quantidade,
    co.valor_total,
    co.data_compra
FROM compra AS co
INNER JOIN aluno AS a
    ON a.id_aluno = co.id_aluno
INNER JOIN produto AS pr
    ON pr.id_produto = co.id_produto
ORDER BY co.data_compra ASC, co.id_compra ASC;

SELECT
    d.nome_disc,
    COUNT(m.id_aluno) AS quantidade_alunos,
    ROUND(AVG(m.nota), 2) AS media,
    MAX(m.nota) AS maior_nota,
    MIN(m.nota) AS menor_nota
FROM disciplina AS d
INNER JOIN matricula AS m
    ON m.id_disc = d.id_disc
GROUP BY d.id_disc, d.nome_disc
HAVING AVG(m.nota) >= 7
ORDER BY media DESC, d.nome_disc ASC;

SELECT
    c.nome_casa,
    COUNT(r.id_registro) AS quantidade_registros,
    SUM(CASE WHEN r.pontos > 0 THEN r.pontos ELSE 0 END) AS pontos_ganhos,
    SUM(CASE WHEN r.pontos < 0 THEN r.pontos ELSE 0 END) AS pontos_perdidos,
    SUM(COALESCE(r.pontos, 0)) AS saldo_pontos
FROM casa AS c
LEFT JOIN aluno AS a
    ON a.id_casa = c.id_casa
LEFT JOIN registro_pontos AS r
    ON r.id_aluno = a.id_aluno
GROUP BY c.id_casa, c.nome_casa
ORDER BY c.nome_casa ASC;

SELECT
    pr.loja,
    COUNT(DISTINCT co.id_compra) AS quantidade_compras,
    SUM(co.valor_total) AS faturamento
FROM produto AS pr
INNER JOIN compra AS co
    ON co.id_produto = pr.id_produto
GROUP BY pr.loja
HAVING SUM(co.valor_total) > 20
ORDER BY faturamento DESC;

SELECT
    MONTH(r.data_registro) AS mes,
    COUNT(r.id_registro) AS quantidade_registros,
    SUM(r.pontos) AS total_pontos
FROM registro_pontos AS r
GROUP BY MONTH(r.data_registro)
ORDER BY MONTH(r.data_registro) ASC;

SELECT
    p.nome,
    COUNT(r.id_registro) AS quantidade_registros,
    SUM(r.pontos) AS total_pontos
FROM professor AS p
INNER JOIN registro_pontos AS r
    ON r.id_prof = p.id_prof
GROUP BY p.id_prof, p.nome
HAVING COUNT(r.id_registro) >= 2
ORDER BY total_pontos DESC, p.nome ASC;

SELECT nome
FROM aluno
WHERE id_aluno IN (
    SELECT id_aluno
    FROM compra
    WHERE id_produto IN (
        SELECT id_produto
        FROM produto
        WHERE loja = 'Dedosdemel'
    )
)
ORDER BY nome ASC;

SELECT nome_produto, estoque
FROM produto
WHERE id_produto NOT IN (
    SELECT id_produto
    FROM compra
)
ORDER BY nome_produto ASC;

SELECT nome, saldo_galeoes
FROM aluno
WHERE saldo_galeoes > (
    SELECT AVG(saldo_galeoes)
    FROM aluno
)
ORDER BY saldo_galeoes DESC;

SELECT nome, salario
FROM professor
WHERE salario > ALL (
    SELECT salario
    FROM professor
    WHERE id_casa IS NULL
)
ORDER BY salario DESC;

SELECT nome, saldo_galeoes
FROM aluno
WHERE id_casa <> (
    SELECT id_casa
    FROM casa
    WHERE nome_casa = 'Sonserina'
)
AND saldo_galeoes > ANY (
    SELECT a.saldo_galeoes
    FROM aluno AS a
    INNER JOIN casa AS c
        ON c.id_casa = a.id_casa
    WHERE c.nome_casa = 'Sonserina'
)
ORDER BY saldo_galeoes DESC;

SELECT c.nome_casa
FROM casa AS c
WHERE EXISTS (
    SELECT 1
    FROM aluno AS a
    INNER JOIN matricula AS m
        ON m.id_aluno = a.id_aluno
    WHERE a.id_casa = c.id_casa
      AND m.nota = 10
)
ORDER BY c.nome_casa ASC;

SELECT a.nome
FROM aluno AS a
WHERE NOT EXISTS (
    SELECT 1
    FROM compra AS co
    WHERE co.id_aluno = a.id_aluno
)
ORDER BY a.nome ASC;

SELECT
    c.nome_casa,
    ROUND(AVG(medias.media_aluno), 2) AS media_das_medias
FROM casa AS c
INNER JOIN (
    SELECT
        a.id_aluno,
        a.id_casa,
        AVG(m.nota) AS media_aluno
    FROM aluno AS a
    INNER JOIN matricula AS m
        ON m.id_aluno = a.id_aluno
    GROUP BY a.id_aluno, a.id_casa
) AS medias
    ON medias.id_casa = c.id_casa
GROUP BY c.id_casa, c.nome_casa
ORDER BY media_das_medias DESC;

SELECT nome, 'Aluno' AS vinculo
FROM aluno
UNION ALL
SELECT nome, 'Professor' AS vinculo
FROM professor
ORDER BY nome ASC;

SELECT a.nome
FROM aluno AS a
INNER JOIN compra AS co
    ON co.id_aluno = a.id_aluno
UNION ALL
SELECT a.nome
FROM aluno AS a
INNER JOIN registro_pontos AS r
    ON r.id_aluno = a.id_aluno
ORDER BY nome ASC;

SELECT a.nome
FROM aluno AS a
INNER JOIN compra AS co
    ON co.id_aluno = a.id_aluno
UNION
SELECT a.nome
FROM aluno AS a
INNER JOIN registro_pontos AS r
    ON r.id_aluno = a.id_aluno
ORDER BY nome ASC;

SELECT
    'Total de pontos distribuídos' AS indicador,
    SUM(pontos) AS valor
FROM registro_pontos
UNION ALL
SELECT
    'Total de galeões gastos na loja',
    SUM(valor_total)
FROM compra
UNION ALL
SELECT
    'Folha salarial dos professores',
    SUM(salario)
FROM professor
UNION ALL
SELECT
    'Total de galeões nos cofres dos alunos',
    SUM(saldo_galeoes)
FROM aluno;

CREATE VIEW vw_placar_casas AS
SELECT nome_casa, pontos
FROM casa
ORDER BY pontos DESC, nome_casa ASC;

CREATE VIEW vw_boletim AS
SELECT
    a.nome AS aluno,
    COALESCE(c.nome_casa, 'Sem casa') AS casa,
    d.nome_disc AS disciplina,
    COALESCE(p.nome, 'Sem professor') AS professor,
    m.nota,
    m.situacao
FROM matricula AS m
INNER JOIN aluno AS a
    ON a.id_aluno = m.id_aluno
LEFT JOIN casa AS c
    ON c.id_casa = a.id_casa
INNER JOIN disciplina AS d
    ON d.id_disc = m.id_disc
LEFT JOIN professor AS p
    ON p.id_prof = d.id_prof;

CREATE VIEW vw_extrato_loja AS
SELECT
    a.nome AS aluno,
    pr.nome_produto AS produto,
    pr.loja,
    co.quantidade,
    co.valor_total,
    co.data_compra
FROM compra AS co
INNER JOIN aluno AS a
    ON a.id_aluno = co.id_aluno
INNER JOIN produto AS pr
    ON pr.id_produto = co.id_produto;

CREATE VIEW vw_alunos_destaque AS
SELECT
    a.nome AS aluno,
    c.nome_casa AS casa,
    ROUND(AVG(m.nota), 2) AS media
FROM aluno AS a
INNER JOIN casa AS c
    ON c.id_casa = a.id_casa
INNER JOIN matricula AS m
    ON m.id_aluno = a.id_aluno
GROUP BY a.id_aluno, a.nome, c.nome_casa
HAVING AVG(m.nota) >= 8;

CREATE VIEW vw_quadro_professores AS
SELECT
    p.nome AS professor,
    COALESCE(c.nome_casa, 'Não é diretor') AS casa_dirigida,
    (
        SELECT COUNT(*)
        FROM disciplina AS d
        WHERE d.id_prof = p.id_prof
    ) AS quantidade_disciplinas,
    COALESCE(
        (
            SELECT SUM(r.pontos)
            FROM registro_pontos AS r
            WHERE r.id_prof = p.id_prof
        ),
        0
    ) AS total_pontos_concedidos
FROM professor AS p
LEFT JOIN casa AS c
    ON c.id_casa = p.id_casa;

SELECT * FROM vw_placar_casas;

SELECT *
FROM vw_boletim
WHERE casa = 'Corvinal';

SELECT loja, SUM(valor_total) AS total_faturado
FROM vw_extrato_loja
GROUP BY loja
ORDER BY total_faturado DESC;

SELECT *
FROM vw_alunos_destaque
ORDER BY media DESC, aluno ASC;

SELECT *
FROM vw_quadro_professores
ORDER BY total_pontos_concedidos DESC, professor ASC;

INSERT INTO registro_pontos (id_aluno, id_prof, pontos, motivo, data_registro)
VALUES (11, 1, 20, 'Venceu a primeira tarefa do Torneio', '2026-11-10');

SELECT * FROM vw_placar_casas;

CREATE OR REPLACE VIEW vw_placar_casas AS
SELECT nome_casa, fundador, pontos
FROM casa
ORDER BY pontos DESC, nome_casa ASC;

SELECT * FROM vw_placar_casas;

DROP USER IF EXISTS 'filch'@'localhost';
DROP USER IF EXISTS 'mcgonagall'@'localhost';
DROP USER IF EXISTS 'dumbledore'@'localhost';
DROP USER IF EXISTS 'percy'@'localhost';
DROP ROLE IF EXISTS 'monitor';

CREATE USER 'filch'@'localhost' IDENTIFIED BY 'MadameNorra#1';
CREATE USER 'mcgonagall'@'localhost' IDENTIFIED BY 'Animago#Gato1';
CREATE USER 'dumbledore'@'localhost' IDENTIFIED BY 'Fenix#Fawkes1';

GRANT SELECT ON hogwarts.vw_placar_casas
TO 'filch'@'localhost';

GRANT SELECT, INSERT ON hogwarts.registro_pontos
TO 'mcgonagall'@'localhost';

GRANT SELECT ON hogwarts.aluno
TO 'mcgonagall'@'localhost';

GRANT SELECT ON hogwarts.vw_boletim
TO 'mcgonagall'@'localhost';

GRANT ALL PRIVILEGES ON hogwarts.*
TO 'dumbledore'@'localhost'
WITH GRANT OPTION;

SHOW GRANTS FOR 'filch'@'localhost';
SHOW GRANTS FOR 'mcgonagall'@'localhost';

INSERT INTO registro_pontos (id_aluno, id_prof, pontos, motivo, data_registro)
VALUES (2, 1, 10, 'Ajudou um colega em Transfiguração', '2026-11-10');

SELECT id_casa, nome_casa, pontos
FROM casa
WHERE id_casa = 1;

REVOKE INSERT ON hogwarts.registro_pontos
FROM 'mcgonagall'@'localhost';

SHOW GRANTS FOR 'mcgonagall'@'localhost';

CREATE ROLE 'monitor';

GRANT SELECT ON hogwarts.vw_boletim TO 'monitor';
GRANT SELECT ON hogwarts.vw_placar_casas TO 'monitor';

CREATE USER 'percy'@'localhost' IDENTIFIED BY 'Monitor#Chefe1';

GRANT 'monitor' TO 'percy'@'localhost';

SET DEFAULT ROLE 'monitor' TO 'percy'@'localhost';

SHOW GRANTS FOR 'percy'@'localhost';