CREATE DATABASE shopping_db;

USE shopping_db;

CREATE TABLE usuario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    sobrenome VARCHAR(50) NOT NULL,
    cpf VARCHAR(11) NOT NULL UNIQUE 
    CONSTRAINT check_cpf CHECK (CHAR_LENGTH(cpf) = 11)
);



CREATE TABLE endereco (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    cep VARCHAR(8) NOT NULL,
    rua_nome VARCHAR(30),
    endereco_numero_casa INT,
    FOREIGN KEY (id_usuario) REFERENCES usuario (id)
);

CREATE TABLE produtos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(20),
    valor DECIMAL(10, 2)
    CONSTRAINT check_valor_negativo CHECK(valor >=0);
);




CREATE TABLE carrinho (
    id_carrinho INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    id_produto INT,
    qt_itens INT,
    FOREIGN KEY (id_usuario) REFERENCES usuario (id),
    FOREIGN KEY (id_produto) REFERENCES produtos (id)
);

INSERT INTO
    `usuario` (
        nome,
        sobrenome,
        endereço,
        cpf
    )
VALUES (
        'Joabyson',
        'Souza',
        '34 Av.José Bolteiro',
        '12345678901'
    ),
    (
        'Vitor',
        'Castro',
        ' 123 Av.Rua 2',
        '09876543210'
    );

INSERT INTO
    `endereco` (
        id_usuario,
        cep,
        rua_nome,
        endereco_numero_casa
    )
VALUES (
        2,
        '12348765',
        'AV.JUCELINO',
        25
    );

INSERT INTO
    `produtos` (nome, valor)
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
    `carrinho` (
        id_usuario,
        id_produto,
        qt_itens
    )
VALUES (1, 3, 5),
    (1, 2, 4),
    (1, 1, 1),
    (1, 4, 3),
    (1, 5, 2);

INSERT INTO
    `carrinho` (
        id_usuario,
        id_produto,
        qt_itens
    )
VALUES (3, 6, 10);
    

    INSERT INTO `carrinho`(id_usuário,id_produto,qt_itens) VALUES(3,1,10);

CREATE VIEW usuario_sem_CPF AS
SELECT usuario.id, usuario.nome, usuario.sobrenome
FROM usuario;

SELECT
    `usuario_sem_CPF`.nome,
    `usuario_sem_CPF`.sobrenome,
    `usuario_sem_CPF`.id,
    `endereco`.rua_nome,
    `endereco`.cep,
    `endereco`.endereco_numero_casa,
    SUM(valor * qt_itens) AS Valor_Total_carrinho
FROM
    `carrinho`
    INNER JOIN `usuario_sem_CPF` ON `carrinho`.id_carrinho = `usuario_sem_CPF`.id
    INNER JOIN `endereco` ON endereco.id_usuario = `usuario_sem_CPF`.id
    INNER JOIN `produtos` ON `carrinho`.id_produto = `produtos`.id
GROUP BY
    `usuario_sem_CPF`.id,
    `usuario_sem_CPF`.nome,
    `usuario_sem_CPF`.sobrenome,
    `endereco`.rua_nome,
    `endereco`.cep,
    `endereco`.endereco_numero_casa;

    CREATE Table pre_reservados(
        id INT AUTO_INCREMENT PRIMARY KEY,
        id_usuario INT,
        id_produto INT,
        qt_reservada INT,
        data_reservada TIMESTAMP DEFAULT NOW()
        FOREIGN KEY (id_usuario) REFERENCES usuario (id),
        FOREIGN KEY (id_produto) REFERENCES produtos (id)
    );

    CREATE Trigger qt_reservados
    AFTER INSERT ON carrinho
    FOR EACH ROW
    BEGIN 
    UPDATE pre_reservados
    SET qt_reservada = qt_reservada + 1
    WHERE id_produto = NEW.id_produto;
    END;

 
INSERT INTO pre_reservados (id_produto,id_usuario,qt_reservada)
VALUES (1,3 ,1);
INSERT INTO `carrinho`(id_usuário,id_produto,qt_itens) VALUES(3,1,1);

 SELECT * FROM pre_reservados;


 