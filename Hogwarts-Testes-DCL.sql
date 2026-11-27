SELECT * FROM hogwarts.vw_placar_casas;
SELECT * FROM hogwarts.aluno;

INSERT INTO hogwarts.registro_pontos (id_aluno, id_prof, pontos, motivo, data_registro)
VALUES (2, 1, 10, 'Ajudou um colega em Transfiguração', '2026-11-10');

UPDATE hogwarts.casa
SET pontos = 1000
WHERE id_casa = 1;