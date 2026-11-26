CREATE DATABASE IF NOT EXISTS atividade03_contas
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE atividade03_contas;

DROP TABLE IF EXISTS Contas;

CREATE TABLE Contas (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(100) NOT NULL,
    Saldo DECIMAL(10, 2) NOT NULL
) ENGINE=InnoDB;

INSERT INTO Contas (Nome, Saldo) VALUES
    ('Lady Gaga', 1000.00),
    ('Bob Marley', 500.00),
    ('Katy Perry', 1500.00);

UPDATE Contas
SET Saldo = Saldo + 250.00
WHERE Nome = 'Lady Gaga';

START TRANSACTION;

UPDATE Contas
SET Saldo = Saldo - 300.00
WHERE Nome = 'Katy Perry';

UPDATE Contas
SET Saldo = Saldo + 300.00
WHERE Nome = 'Bob Marley';

COMMIT;

START TRANSACTION;

UPDATE Contas
SET Saldo = Saldo - 300.00
WHERE Nome = 'Katy Perry';

UPDATE Contas
SET Saldo = Saldo + 300.00
WHERE Nome = 'Bob Marley';

ROLLBACK;

DELETE FROM Contas
WHERE Nome = 'Bob Marley';

SELECT Id, Nome, Saldo
FROM Contas
WHERE Saldo > 1000.00;

SELECT Nome, Saldo
FROM Contas
ORDER BY Saldo DESC;