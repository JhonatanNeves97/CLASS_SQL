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
INSERT INTO cidade (nome, estado_id) VALUES ('CURITIBA',4), ('BAURU',1), ('LONDRINA',4); -- vários valores de uma vez 
INSERT INTO cidade (estado_id, nome) VALUES (1,'FERNANDÓPOLIS'); -- pode alterar a ordem desde que altere também no valor
INSERT INTO cidade (nome, estado_id) VALUES ('RIO DE JANEIRO',2);
INSERT INTO cidade (nome, estado_id) VALUES ('VITÓRIA',3);
INSERT INTO cidade (nome, estado_id) VALUES ('MANAUS',5);
INSERT INTO cidade (nome, estado_id) VALUES ('FLORIANÓPOLIS',6);
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
 
-- DELETE FROM cidade WHERE id = 1;
-- DELETE FROM cidade WHERE estado_id = 1;
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

-- SQL 89
SELECT *
FROM estado,cidade
WHERE estado.id = cidade.estado_id;

-- SQL 92
SELECT *
FROM estado
INNER JOIN cidade ON estado.id = cidade.estado_id; -- ou esconde o inner que entende

/**Responda as questões:
01 - O que é JOIN? Quando é necessário?
é uma clausula usada para juntar duas tabelas, né necessário quando você precisa relacionar duas tabelas para melhor visualização e/ou entendimento.

02 - Qual a sintaxe do JOIN? Maiúscula ou minúscula faz diferença? Existe algum padrão? Explique.
'SQL 89' SELECT (nome das colunas) FROM (nome das tabelas) WHERE (coluna pk = coluna fk)
'SQL 92' SELECT (nome das colunas) FROM (tabela 1) INNER JOIN (tabela 2) ON (coluna pk = coluna fk)
Não faz diferença maiúscula e minúscula no sistema operacional Windowns (somente no Linux), 
mas é de extrema importancia adotar um padrão para que possa rodar o arquivo nos 2 sistemas operacionais além de outros benefícios.

04 - O que é primordial para que o resultado tenha sentido em consultas com JOIN? Explique.
A condição de junção (para o SQL saber quais tabelas vocÊ quer juntar), 
a comparação do identificador de uma tabela e a sua referência na tabela que será juntada (para não receber todas as combinações possiveis, somente as desejadas.

05 - Existe mais de uma maneira de realizar o JOIN? Quantas? Qual é a mais eficiente?
Existe 2, a 'SQL89' e a 'SQL92', não existe mais eficiente, você adota a que for melhor para você.

06 - Para realizar o JOIN de 1523 tabelas, quantas comparações de junções são necessárias? Explique.
São necessárias 1522 comparações de junções, para cada duas tabelas, uma comparação de junção é necessária.

07 - O que é análise semântica e de sintaxe? Qual a diferença? Para que serve?
A sintaxe é a escrita de um comando, na ordem correta, para que o sistema entenda.
A semântica enfatiza a interpretação de um comando pelo sistema.
A sintaxe errada é bloqueada pelo sistema. E a semântica errada pode passar pelo sistema e dar informações erradas, o que é mais perigoso, pois é mais difícil achar o erro.

8 - Em uma consulta com JOIN, há casos em que seja necessário atribuir o nome da tabela na projeção das colunas? Explique.
Sim, em casos de nomes iguais das colunas de tabelas diferentes, o sistema precisa entender de onde retirar a informação, necessitando do nome da tabela na projeção das colunas.
 
09 - De acordo com o estudo de caso, cite 4 exemplos em que seja possível utilizar o JOIN e 3 exemplos que não seja possível realizar o JOIN.
Junções possíveis: estado e cidade, cliente e numero telefônico, produtos e valores, pessoas e endereços.
Junções impossíveis: estado e cliente, venda e compra, recebimento e pagamento.

01 - Liste o id e o nome de todas as cidades e as respectivas siglas do estado.

'SQL89'
SELECT cidade.id, cidade.nome, sigla
FROM cidade, estado
WHERE estado.id = cidade.estado_id;

SQL92
SELECT cidade.id, cidade.nome, sigla
FROM estado
INNER JOIN cidade ON estado.id = cidade.estado_id;

02 - Em relação ao resultado do exercício anterior, note que os nomes das colunas não estão claras. Refaça o comando para que torne mais claras.

'SQL89'
SELECT 
	cidade.id 'CODIGO DA CIDADE'
	, cidade.nome 'NOME DA CIDADE'
	, sigla 'SIGLA DO ESTADO'
FROM cidade, estado
WHERE estado.id = cidade.estado_id;

'SQL92'
SELECT 
	cidade.id 'CODIGO DA CIDADE'
	, cidade.nome 'NOME DA CIDADE'
	, sigla 'SIGLA DO ESTADO'
FROM estado
INNER JOIN cidade ON estado.id = cidade.estado_id;

3 - Refaça o exercício anterior atribuindo o nome completo da tabela em todos os atributos.

'SQL89'
SELECT 
	cidade.id 'CODIGO DA CIDADE'
	, cidade.nome 'NOME DA CIDADE'
	, estado.sigla 'SIGLA DO ESTADO'
FROM cidade, estado
WHERE estado.id = cidade.estado_id;

'SQL92'
SELECT 
	cidade.id 'CODIGO DA CIDADE'
	, cidade.nome 'NOME DA CIDADE'
	, estado.sigla 'SIGLA DO ESTADO'
FROM estado
INNER JOIN cidade ON estado.id = cidade.estado_id;

04 - Refaça o exercício anterior definindo o apelido na tabela.
'SQL89'
SELECT 
	c.id 'CODIGO DA CIDADE'
	, c.nome 'NOME DA CIDADE'
	, e.sigla 'SIGLA DO ESTADO'
FROM cidade c, estado e
WHERE e.id = c.estado_id;

'SQL92'
SELECT 
	c.id 'CODIGO DA CIDADE'
	, c.nome 'NOME DA CIDADE'
	, e.sigla 'SIGLA DO ESTADO'
FROM estado e
INNER JOIN cidade c ON e.id = c.estado_id;
/* 