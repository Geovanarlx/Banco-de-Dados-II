CREATE DATABASE IF NOT EXISTS atividade_views_consultorio
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE atividade_views_consultorio;

DROP VIEW IF EXISTS vw_medicos_por_especializacao;
DROP VIEW IF EXISTS vw_gasto_total_paciente;
DROP VIEW IF EXISTS vw_qtd_consultas_paciente;
DROP VIEW IF EXISTS vw_pacientes_consultas_ate_2025;
DROP VIEW IF EXISTS vw_consultas_medicamentos;
DROP VIEW IF EXISTS vw_consultas_convenio;
DROP VIEW IF EXISTS vw_consulta_maior_valor;
DROP VIEW IF EXISTS vw_paciente_mais_jovem;
DROP VIEW IF EXISTS vw_dia_maior_faturamento;

DROP TABLE IF EXISTS cons_medicame;
DROP TABLE IF EXISTS consulta;
DROP TABLE IF EXISTS medEsp;
DROP TABLE IF EXISTS paciente;
DROP TABLE IF EXISTS medico;
DROP TABLE IF EXISTS medicamento;
DROP TABLE IF EXISTS convenio;
DROP TABLE IF EXISTS especializacao;
DROP TABLE IF EXISTS cidade;
DROP TABLE IF EXISTS profissao;

CREATE TABLE profissao (
    codigo INT PRIMARY KEY,
    area VARCHAR(50) NOT NULL,
    nome VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE cidade (
    codigo INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    UF CHAR(2) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE paciente (
    codigo INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(255) NULL,
    idade INT NOT NULL,
    fone VARCHAR(20) NULL,
    codProf INT NOT NULL,
    codCid INT NOT NULL,
    CONSTRAINT fk_paciente_profissao
        FOREIGN KEY (codProf) REFERENCES profissao(codigo),
    CONSTRAINT fk_paciente_cidade
        FOREIGN KEY (codCid) REFERENCES cidade(codigo)
) ENGINE=InnoDB;

CREATE TABLE medico (
    codigo INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(255) NULL,
    CRM VARCHAR(20) NOT NULL,
    codCid INT NOT NULL,
    CONSTRAINT fk_medico_cidade
        FOREIGN KEY (codCid) REFERENCES cidade(codigo)
) ENGINE=InnoDB;

CREATE TABLE especializacao (
    codigo INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    area VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE convenio (
    codigo INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE medEsp (
    codEsp INT NOT NULL,
    codMed INT NOT NULL,
    PRIMARY KEY (codEsp, codMed),
    CONSTRAINT fk_medEsp_especializacao
        FOREIGN KEY (codEsp) REFERENCES especializacao(codigo),
    CONSTRAINT fk_medEsp_medico
        FOREIGN KEY (codMed) REFERENCES medico(codigo)
) ENGINE=InnoDB;

CREATE TABLE consulta (
    data DATE NOT NULL,
    hora TIME NOT NULL,
    codPac INT NOT NULL,
    codMed INT NOT NULL,
    valor DECIMAL(10, 2) NOT NULL,
    codConv INT NULL,
    PRIMARY KEY (data, hora, codPac),
    CONSTRAINT fk_consulta_paciente
        FOREIGN KEY (codPac) REFERENCES paciente(codigo),
    CONSTRAINT fk_consulta_medico
        FOREIGN KEY (codMed) REFERENCES medico(codigo),
    CONSTRAINT fk_consulta_convenio
        FOREIGN KEY (codConv) REFERENCES convenio(codigo)
) ENGINE=InnoDB;

CREATE TABLE medicamento (
    codigo INT PRIMARY KEY,
    descricao VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE cons_medicame (
    data DATE NOT NULL,
    hora TIME NOT NULL,
    codPac INT NOT NULL,
    codMedica INT NOT NULL,
    PRIMARY KEY (data, hora, codPac, codMedica),
    CONSTRAINT fk_cons_medicame_consulta
        FOREIGN KEY (data, hora, codPac)
        REFERENCES consulta(data, hora, codPac),
    CONSTRAINT fk_cons_medicame_medicamento
        FOREIGN KEY (codMedica) REFERENCES medicamento(codigo)
) ENGINE=InnoDB;

INSERT INTO profissao (codigo, area, nome) VALUES
    (1, 'Medicina', 'Médico'),
    (2, 'Odontologia', 'Dentista'),
    (3, 'Psicologia', 'Psicólogo'),
    (4, 'Enfermagem', 'Enfermeiro'),
    (5, 'Fisioterapia', 'Fisioterapeuta');

INSERT INTO cidade (codigo, nome, UF) VALUES
    (1, 'Manaus', 'AM'),
    (2, 'Boa Vista', 'RR'),
    (3, 'Cruzeiro do Sul', 'AC'),
    (4, 'Coari', 'AM'),
    (5, 'Rio Branco', 'AC');

INSERT INTO paciente (codigo, nome, email, idade, fone, codProf, codCid) VALUES
    (101, 'Rickson Gracie', NULL, 23, NULL, 1, 1),
    (102, 'Cauã Remo', NULL, 16, NULL, 2, 2),
    (103, 'Elon Delon', NULL, 30, NULL, 3, 3),
    (104, 'Daniel San', NULL, 22, NULL, 4, 4),
    (105, 'Gustavo Lima', NULL, 20, NULL, 5, 5);

INSERT INTO medico (codigo, nome, email, CRM, codCid) VALUES
    (1, 'Marcus Palmeira', NULL, '23453', 1),
    (2, 'José Sócrates', NULL, '555453', 2),
    (3, 'Neymar Junior', NULL, '677755', 3),
    (4, 'Albert Einstein', NULL, '987666', 4),
    (5, 'Daiane dos Santos', NULL, '983456', 5);

INSERT INTO especializacao (codigo, nome, area) VALUES
    (1, 'Pediatria', 'Saúde Infantil'),
    (2, 'Urologia', 'Saúde Masculina'),
    (3, 'Psicologia', 'Saúde Mental'),
    (4, 'Cardiologia', 'Saúde do Coração');

INSERT INTO convenio (codigo, nome) VALUES
    (1, 'Unimed'),
    (2, 'Bradesco Saúde'),
    (3, 'Amil'),
    (4, 'Hapvida'),
    (5, 'SulAmérica');

INSERT INTO medEsp (codEsp, codMed) VALUES
    (1, 5),
    (2, 1),
    (3, 1),
    (3, 2),
    (4, 2),
    (4, 4);

INSERT INTO consulta (data, hora, codPac, codMed, valor, codConv) VALUES
    ('2025-03-20', '09:00:00', 101, 1, 150.00, 1),
    ('2025-02-21', '10:00:00', 102, 2, 180.00, 2),
    ('2025-02-20', '11:00:00', 103, 3, 200.00, 1),
    ('2025-03-21', '09:00:00', 104, 1, 120.00, 2),
    ('2025-03-21', '14:00:00', 105, 5, 250.00, 1);

INSERT INTO medicamento (codigo, descricao) VALUES
    (1, 'Aspirina'),
    (2, 'Diclofenaco'),
    (3, 'Engove'),
    (4, 'Eno'),
    (5, 'Hipoglos'),
    (6, 'Moura Brasil'),
    (7, 'Olina'),
    (8, 'Sonrisal'),
    (9, 'Tylenol');

INSERT INTO cons_medicame (data, hora, codPac, codMedica) VALUES
    ('2025-03-20', '09:00:00', 101, 1),
    ('2025-02-21', '10:00:00', 102, 2),
    ('2025-02-20', '11:00:00', 103, 3),
    ('2025-03-21', '09:00:00', 104, 4),
    ('2025-03-21', '14:00:00', 105, 5);

CREATE VIEW vw_dia_maior_faturamento AS
SELECT data
FROM consulta
GROUP BY data
HAVING SUM(valor) >= ALL (
    SELECT SUM(valor)
    FROM consulta
    GROUP BY data
);

CREATE VIEW vw_paciente_mais_jovem AS
SELECT nome
FROM paciente
WHERE idade = (SELECT MIN(idade) FROM paciente);

CREATE VIEW vw_consulta_maior_valor AS
SELECT data, hora
FROM consulta
WHERE valor = (SELECT MAX(valor) FROM consulta);

CREATE VIEW vw_consultas_convenio AS
SELECT
    c.data,
    c.hora,
    COALESCE(cv.nome, 'Particular') AS convenio
FROM consulta AS c
LEFT JOIN convenio AS cv
    ON cv.codigo = c.codConv;

CREATE VIEW vw_consultas_medicamentos AS
SELECT
    c.data,
    m.descricao AS medicamento
FROM consulta AS c
LEFT JOIN cons_medicame AS cm
    ON cm.data = c.data
    AND cm.hora = c.hora
    AND cm.codPac = c.codPac
LEFT JOIN medicamento AS m
    ON m.codigo = cm.codMedica
ORDER BY m.descricao IS NULL, m.descricao ASC;

CREATE VIEW vw_pacientes_consultas_ate_2025 AS
SELECT
    p.nome,
    c.data AS data_consulta
FROM paciente AS p
LEFT JOIN consulta AS c
    ON c.codPac = p.codigo
    AND c.data < '2026-01-01';

CREATE VIEW vw_qtd_consultas_paciente AS
SELECT
    p.nome,
    p.email,
    p.idade,
    COUNT(c.codPac) AS quantidade_consultas
FROM paciente AS p
LEFT JOIN consulta AS c
    ON c.codPac = p.codigo
GROUP BY p.codigo, p.nome, p.email, p.idade
ORDER BY quantidade_consultas ASC, p.nome ASC;

CREATE VIEW vw_gasto_total_paciente AS
SELECT
    p.nome,
    p.fone,
    COALESCE(SUM(c.valor), 0.00) AS valor_total_gasto
FROM paciente AS p
LEFT JOIN consulta AS c
    ON c.codPac = p.codigo
GROUP BY p.codigo, p.nome, p.fone
ORDER BY valor_total_gasto DESC, p.nome ASC;

CREATE VIEW vw_medicos_por_especializacao AS
SELECT
    m.nome AS medico,
    e.nome AS especializacao
FROM medico AS m
LEFT JOIN medEsp AS me
    ON me.codMed = m.codigo
LEFT JOIN especializacao AS e
    ON e.codigo = me.codEsp
ORDER BY m.nome ASC, e.nome ASC;

SELECT * FROM vw_dia_maior_faturamento;
SELECT * FROM vw_paciente_mais_jovem;
SELECT * FROM vw_consulta_maior_valor;
SELECT * FROM vw_consultas_convenio;
SELECT * FROM vw_consultas_medicamentos;
SELECT * FROM vw_pacientes_consultas_ate_2025;
SELECT * FROM vw_qtd_consultas_paciente;
SELECT * FROM vw_gasto_total_paciente;
SELECT * FROM vw_medicos_por_especializacao;

