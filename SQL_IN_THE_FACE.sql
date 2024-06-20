-- Active: 1718737648825@@127.0.0.1@5432@postgres

CREATE TABLE usuario (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    sobrenome VARCHAR(50) NOT NULL,
    cpf VARCHAR(11) NOT NULL UNIQUE 
    CONSTRAINT check_cpf CHECK (CHAR_LENGTH(cpf) = 11 AND cpf ~ '^[0-9]+$')
);


CREATE TABLE endereco (
    id SERIAL PRIMARY KEY,
    id_usuario INT,
    cep VARCHAR(8) NOT NULL,
    rua_nome VARCHAR(30),
    numero INT,
    complemento VARCHAR(50),
    FOREIGN KEY (id_usuario) REFERENCES usuario (id)
);



CREATE TABLE produtos (
  id SERIAL PRIMARY KEY,
    nome VARCHAR(20),
    valor DECIMAL(10, 2)
    CONSTRAINT check_valor_negativo CHECK(valor >=0)
);


CREATE TABLE carrinho (
    id_carrinho SERIAL PRIMARY KEY,
    id_usuario INT,
    id_produto INT,
    qt_itens INT,
    FOREIGN KEY (id_usuario) REFERENCES usuario (id),
    FOREIGN KEY (id_produto) REFERENCES produtos (id)
);


INSERT INTO
    usuario (
        nome,
        sobrenome,
        cpf
    )
VALUES (
        'Joabyson',
        'Souza',
        '12345678901'
    ),
    (
        'Vitor',
        'Castro',
        '09876543210'
    );

    INSERT INTO endereco(id_usuario, cep,rua_nome,numero,complemento)VALUES
    (1,12345678,'AV.logo ali',36,'apartamento 46'),
    (2,87654321, 'rua dos passa',10,'casa azul');




   


INSERT INTO
    produtos (nome, valor)
VALUES ('Laptop', 1500.00),
    ('Smartphone', 800.00),
    ('Tablet', 300.00),
    ('Monitor', 250.00),
    ('Teclado', 50.00),
    ('Mouse', 25.00),
    ('Mouse Pad', 200.00),
    ('Headphones', 100.00),
    ('Webcam', 75.00),
    ('Filtro de linha', 150.00);

INSERT INTO
    carrinho (
        id_usuario,
        id_produto,
        qt_itens
    )
VALUES (1, 3, 5),
    (1, 2, 4),
    (1, 1, 1),
    (1, 4, 3),
    (1, 5, 2);

CREATE VIEW usuario_sem_CPF AS
SELECT usuario.id, usuario.nome, usuario.sobrenome
FROM usuario;

SELECT
    usuario_sem_CPF.nome,
    usuario_sem_CPF.sobrenome,
    usuario_sem_CPF.id,
    endereco.rua_nome,
    endereco.cep,
    endereco.numero,
    SUM(valor * qt_itens) AS Valor_Total_carrinho
FROM
    carrinho
    INNER JOIN usuario_sem_CPF ON carrinho.id_carrinho = usuario_sem_CPF.id
    INNER JOIN endereco ON endereco.id_usuario = usuario_sem_CPF.id
    INNER JOIN produtos ON carrinho.id_produto = produtos.id
GROUP BY
    usuario_sem_CPF.id,
    usuario_sem_CPF.nome,
    usuario_sem_CPF.sobrenome,
    endereco.rua_nome,
    endereco.cep,
    endereco.numero;

  CREATE Table pre_reservados(
        id SERIAL PRIMARY KEY,
        id_usuario INT,
        id_produto INT,
        qt_reservada INT,
        data_reservada TIMESTAMP DEFAULT NOW(),
        FOREIGN KEY (id_usuario) REFERENCES usuario (id),
        FOREIGN KEY (id_produto) REFERENCES produtos (id)
    );

 CREATE Table estoque(
    id_estoque SERIAL PRIMARY KEY,
    id_produto INT,
    qt_em_estoque INT,
    Foreign Key (id_produto) REFERENCES produtos (id)
 );   

 



    CREATE OR REPLACE FUNCTION estoque_quantidade()
    RETURNS TRIGGER AS $$
    BEGIN

    IF (NEW.qt_itens > (SELECT qt_em_estoque FROM estoque WHERE id_produto = NEW.id_produto)) THEN RAISE EXCEPTION 'NÃO É POSSIVEL COMPRAR: ESTOQUE MUITO BAIXO';
    END IF;
      UPDATE estoque
      SET qt_em_estoque = qt_em_estoque - NEW.qt_itens
      WHERE id_produto = NEW.id_produto;
      RETURN NEW;
    END;
    $$ LANGUAGE PLPGSQL; 


CREATE TRIGGER qt_estoque
      AFTER INSERT ON carrinho
      FOR EACH ROW
      EXECUTE FUNCTION estoque_quantidade(); 


    CREATE OR REPLACE FUNCTION atualizar_quantidade_reservada()
    RETURNS TRIGGER AS $$
    BEGIN
         UPDATE pre_reservados
         SET qt_reservada = qt_reservada + new.qt_itens
         WHERE id_produto = NEW.id_produto;
         RETURN NEW;
    END;
    $$ LANGUAGE PLPGSQL;   


CREATE TRIGGER qt_reservados
    AFTER INSERT ON carrinho
    FOR EACH ROW
    EXECUTE FUNCTION atualizar_quantidade_reservada();


INSERT INTO pre_reservados(id_usuario,id_produto,qt_reservada)VALUES(2,1,1);
INSERT INTO carrinho(id_usuario,id_produto,qt_itens)VALUES(2,1,100);
    
INSERT INTO estoque (id_produto, qt_em_estoque)
VALUES
    (1, 100),
    (2, 100),
    (3, 100),
    (4, 100),
    (5, 100),
    (6, 100),
    (7, 100),
    (8, 100),
    (9, 100),
    (10, 100);



INSERT INTO carrinho(id_usuario,id_produto,qt_itens) VALUES(4,1,1);


