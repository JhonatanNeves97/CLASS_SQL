/**
eliminando base de dados
só executa se existir
*/

DROP DATABASE IF EXISTS aula_banco;
CREATE DATABASE aula_banco; -- criando a base
USE aula_banco;
DROP TABLE IF EXISTS estado;

CREATE TABLE estado(
id INT NOT NULL AUTO_INCREMENT
,nome VARCHAR(200) NOT NULL UNIQUE -- CONSTRAINT INLINE
,sigla CHAR(2) NOT NULL UNIQUE
,ativo CHAR(1) NOT NULL DEFAULT 'S'
,data_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
,CHECK (ativo IN('S','N')) -- CONSTRAINT OUT OF LINE -regra sem nome
,CONSTRAINT pk_estado PRIMARY KEY (id)
,CONSTRAINT estado_ativo_deve_ser_S_ou_N CHECK (ativo IN('S','N')) -- CONSTRAINT OUT OF LINE - regra com nome
);

CREATE TABLE cidade(
id INT NOT NULL AUTO_INCREMENT
,nome VARCHAR(200) NOT NULL
,ativo CHAR(1) NOT NULL DEFAULT 'S'
,data_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
,estado_id INT NOT NULL 
,CONSTRAINT pk_cidade PRIMARY KEY (id)
,CONSTRAINT fk_cidade_estado FOREIGN KEY (estado_id) REFERENCES estado (id)
,CONSTRAINT cidade_ativo_deve_ser_S_ou_N CHECK ( ativo IN ('S', 'N'))
,CONSTRAINT cidade_unica UNIQUE (nome, estado_id)
);

INSERT INTO estado (id,nome,sigla,ativo,data_cadastro) VALUES (1,'SÃO PAULO','SP','S','2024/11/19');
INSERT INTO estado (id,nome,sigla,ativo,data_cadastro) VALUES (2,'RIO DE JANEIRO','RJ','S','2024/11/19');
INSERT INTO estado (id,nome,sigla,ativo,data_cadastro) VALUES (3,'ESPÍRITO SANTO','ES','S','2024/11/19');
INSERT INTO estado VALUES (DEFAULT,'PARANÁ','PR', DEFAULT, DEFAULT); -- DEFAULT pode ocupar espaço e se tiver todos completos não precisa colocar os nomes antes dos valores
INSERT INTO estado (nome,sigla) VALUES ('AMAZONIA','AM');
INSERT INTO estado (nome,sigla) VALUES ('SANTA CATARINA','SC');

SELECT id,nome,sigla,ativo,data_cadastro FROM estado;

INSERT INTO cidade (nome, estado_id) VALUES ('ABC',1);
INSERT INTO cidade (nome, estado_id) VALUES ('CURITIBA',2), ('BAURU',1), ('LONDRINA',2); -- vários valores de uma vez 
INSERT INTO cidade (estado_id, nome) VALUES (1,'FERNANDÓPOLIS'); -- pode alterar a ordem desde que altere também no valor

SELECT * FROM cidade;

-- ALTER TABLE estado ADD COLUMN regiao INT;
ALTER TABLE estado ADD COLUMN regiao VARCHAR(100) NOT NULL DEFAULT 'valor nao informado';
ALTER TABLE estado MODIFY COLUMN regiao VARCHAR(100) NOT NULL DEFAULT 'valor nao informado' AFTER sigla;
ALTER TABLE estado CHANGE regiao regiao_estado VARCHAR(100) NOT NULL DEFAULT 'valor nao informado';
ALTER TABLE estado DROP COLUMN regiao_estado;
-- para decidir a posição escreve FIRST ou AFTER (nome da coluna)

ALTER TABLE estado DROP CONSTRAINT estado_ativo_deve_ser_S_ou_N;
ALTER TABLE estado MODIFY COLUMN ativo ENUM ('S','N');

UPDATE estado SET nome = 'São Paulo' WHERE id = 1;
UPDATE estado SET nome = 'SÃO PAULO', ativo = 'N' WHERE id = 1;
-- UPDATE estado SET ativo = 'S'; -- proteção ativada
UPDATE cidade SET ativo = 'N' WHERE estado_id = 1;
UPDATE cidade SET ativo = 'S' WHERE estado_id = 1 AND data_cadastro >= '2022-01-01';
 
DELETE FROM cidade WHERE id = 1;
DELETE FROM cidade WHERE estado_id = 1;
-- DELETE FROM cidade; -- proteção ativada

-- DESCRIBE estado;
-- DESC estado;

SELECT 
c.id 'ID DA CIDADE'
,c.nome 'NOME DA CIDADE'
,c.ativo 'ESTA CIDADE ESTÁ ATIVO?'
,c.data_cadastro 'DATA DE CADASTRO DA CIDADE'
FROM 
cidade c
WHERE 
YEAR (data_cadastro) >= 2023 AND YEAR (data_cadastro) <=2025
-- YEAR (data_cadastro) BETWEEN 2023 AND 2025 -- mesma coisa
OR 2026;
