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
INSERT INTO estado (id,nome,sigla,ativo,data_cadastro) VALUES (DEFAULT,'PARANÁ','PR', DEFAULT, DEFAULT);
INSERT INTO estado (nome,sigla) VALUES ('MATO GROSSO','MT');

SELECT id,nome,sigla,ativo,data_cadastro FROM estado;

INSERT INTO cidade (nome, estado_id) VALUES ('CAMPINAS',2);
INSERT INTO cidade (nome, estado_id) VALUES ('CURITIBA',1), ('BAURU',1), ('LONDRINA',2); -- vários valores de uma vez 

SELECT * FROM cidade;

-- ALTER TABLE estado ADD COLUMN regiao INT;
-- ALTER TABLE estado ADD COLUMN regiao VARCHAR(100) NOT NULL DEFAULT 'valor nao informado';
-- ALTER TABLE estado MODIFY COLUMN regiao VARCHAR(100) NOT NULL DEFAULT 'valor nao informado' AFTER sigla;
-- ALTER TABLE estado DROP COLUMN regiao_estado;
-- ALTER TABLE estado CHANGE regiao regiao_estado VARCHAR(100) NOT NULL DEFAULT 'valor nao informado';
-- para decidir a posição escreve FIRST ou AFTER (nome da coluna)

ALTER TABLE estado DROP CONSTRAINT estado_ativo_deve_ser_S_ou_N;
ALTER TABLE estado MODIFY COLUMN ativo ENUM ('S','N');

-- DESCRIBE estado;
-- DESC estado;
