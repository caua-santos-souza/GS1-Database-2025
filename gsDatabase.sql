drop table usuarios cascade constraints
drop table alertas cascade constraints
drop table usuario_alertas cascade constraints

SET SERVEROUTPUT ON;

CREATE TABLE USUARIOS (
    ID NUMBER(19,0) NOT NULL,
    CIDADE VARCHAR2(255 CHAR),
    EMAIL VARCHAR2(255 CHAR) NOT NULL,
    NOME VARCHAR2(100 CHAR),
    SENHA VARCHAR2(255 CHAR),
    CONSTRAINT PK_USUARIOS PRIMARY KEY (ID),
    CONSTRAINT UK_USUARIOS_EMAIL UNIQUE (EMAIL)
);

CREATE TABLE ALERTAS (
    ID NUMBER(19,0) NOT NULL,
    CIDADE VARCHAR2(255 CHAR),
    DATA TIMESTAMP(6) NOT NULL,
    DESCRICAO VARCHAR2(255 CHAR),
    TIPO VARCHAR2(255 CHAR),
    CONSTRAINT PK_ALERTAS PRIMARY KEY (ID)
);

CREATE TABLE USUARIO_ALERTAS (
    ID NUMBER(19,0) NOT NULL,
    VISUALIZADO NUMBER(1,0) NOT NULL CHECK (VISUALIZADO IN (0,1)),
    ALERTA_ID NUMBER(19,0) NOT NULL,
    USUARIO_ID NUMBER(19,0) NOT NULL,
    CONSTRAINT PK_USUARIO_ALERTAS PRIMARY KEY (ID),
    CONSTRAINT FK_USUARIO_ALERTAS_ALERTAS FOREIGN KEY (ALERTA_ID) REFERENCES ALERTAS(ID),
    CONSTRAINT FK_USUARIO_ALERTAS_USUARIOS FOREIGN KEY (USUARIO_ID) REFERENCES USUARIOS(ID)
);

select * from alertas
-- Inserção de usuários
BEGIN
  INSERT INTO usuarios (id, nome, email, senha, cidade) VALUES (1, 'João', 'joao@gmail.com', 'senha123', 'São Paulo');
  INSERT INTO usuarios (id, nome, email, senha, cidade) VALUES (2, 'Carlos Mendes', 'carlos@gmail.com', 'carlos123', 'São Paulo');
  INSERT INTO usuarios (id, nome, email, senha, cidade) VALUES (3, 'Maria Oliveira', 'maria@gmail.com', '123maria', 'Rio de Janeiro');
  INSERT INTO usuarios (id, nome, email, senha, cidade) VALUES (4, 'Pedro Santos', 'pedro@gmail.com', 'abc456', 'Curitiba');
  INSERT INTO usuarios (id, nome, email, senha, cidade) VALUES (5, 'Ana Paula', 'ana@gmail.com', 'anap123', 'Recife');
  INSERT INTO usuarios (id, nome, email, senha, cidade) VALUES (6, 'Lucas Rocha', 'lucas@gmail.com', 'lucas@321', 'Porto Alegre');

  INSERT INTO alertas (id, tipo, descricao, cidade, data) VALUES (1, 'chuva', 'Chuva forte prevista', 'São Paulo', SYSTIMESTAMP);
  INSERT INTO alertas (id, tipo, descricao, cidade, data) VALUES (2, 'chuva', 'Chuva forte prevista', 'São Paulo', SYSTIMESTAMP);
  INSERT INTO alertas (id, tipo, descricao, cidade, data) VALUES (3, 'vento', 'Vento moderado', 'São Paulo', SYSTIMESTAMP);
  INSERT INTO alertas (id, tipo, descricao, cidade, data) VALUES (4, 'calor', 'Calor intenso esperado', 'São Paulo', SYSTIMESTAMP);
  INSERT INTO alertas (id, tipo, descricao, cidade, data) VALUES (5, 'vento', 'Rajadas de vento de até 90km/h', 'Rio de Janeiro', SYSTIMESTAMP);
  INSERT INTO alertas (id, tipo, descricao, cidade, data) VALUES (6, 'calor', 'Onda de calor prevista', 'Recife', SYSTIMESTAMP);
  INSERT INTO alertas (id, tipo, descricao, cidade, data) VALUES (7, 'chuva', 'Pancadas leves ao fim do dia', 'Curitiba', SYSTIMESTAMP);
  INSERT INTO alertas (id, tipo, descricao, cidade, data) VALUES (8, 'vento', 'Ventania intensa no litoral', 'Porto Alegre', SYSTIMESTAMP);
  INSERT INTO alertas (id, tipo, descricao, cidade, data) VALUES (9, 'chuva', 'Chuva moderada prevista', 'São Paulo', SYSTIMESTAMP);
  INSERT INTO alertas (id, tipo, descricao, cidade, data) VALUES (10, 'vento', 'Vento fraco', 'Rio de Janeiro', SYSTIMESTAMP);

  INSERT INTO usuario_alertas (id, usuario_id, alerta_id, visualizado) VALUES (1, 1, 1, 0);
  INSERT INTO usuario_alertas (id, usuario_id, alerta_id, visualizado) VALUES (2, 2, 2, 1);
  INSERT INTO usuario_alertas (id, usuario_id, alerta_id, visualizado) VALUES (3, 3, 4, 0);
  INSERT INTO usuario_alertas (id, usuario_id, alerta_id, visualizado) VALUES (4, 4, 3, 1);
  INSERT INTO usuario_alertas (id, usuario_id, alerta_id, visualizado) VALUES (5, 5, 5, 0);
  
  INSERT INTO usuario_alertas (id, usuario_id, alerta_id, visualizado) VALUES (6, 6, (SELECT MAX(id) FROM alertas WHERE tipo = 'calor' AND cidade = 'São Paulo'), 0);
  INSERT INTO usuario_alertas (id, usuario_id, alerta_id, visualizado) VALUES (7, 6, (SELECT MAX(id) FROM alertas WHERE tipo = 'vento' AND cidade = 'São Paulo'), 0);
  INSERT INTO usuario_alertas (id, usuario_id, alerta_id, visualizado) VALUES (8, 6, (SELECT MAX(id) FROM alertas WHERE tipo = 'chuva' AND cidade = 'São Paulo'), 0);

  COMMIT;
END;
/


-- Bloco de UPDATEs
BEGIN
  UPDATE usuarios SET senha = 'novaSenha456' WHERE id = 1;
  UPDATE alertas SET descricao = 'Chuva muito intensa nas próximas horas' WHERE id = 1;
  UPDATE usuario_alertas SET visualizado = 1 WHERE id = 1;
  UPDATE usuarios SET cidade = 'Campinas' WHERE id = 3;
  UPDATE alertas SET cidade = 'Campinas' WHERE id = 4;

  COMMIT;
END;
/

-- Bloco de DELETEs
BEGIN
  DELETE FROM usuario_alertas WHERE id = 2;
  DELETE FROM alertas WHERE id = 4;
  DELETE FROM usuarios WHERE id = 5;
  DELETE FROM usuario_alertas WHERE alerta_id = 3;
  DELETE FROM alertas WHERE tipo = 'vento' AND cidade = 'Porto Alegre';

  COMMIT;
END;
/


-- Função 1: total de alertas por cidade
CREATE OR REPLACE FUNCTION total_alertas_por_cidade(p_cidade VARCHAR2)
RETURN NUMBER IS
    v_total NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_total
    FROM alertas
    WHERE UPPER(cidade) = UPPER(p_cidade); 

    RETURN v_total;
END;
/

-- Função 2: total de alertas não visualizados por usuario
CREATE OR REPLACE FUNCTION alertas_nao_visualizados(p_usuario_id NUMBER)
RETURN NUMBER IS
    v_qtd NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_qtd
    FROM usuario_alertas
    WHERE usuario_id = p_usuario_id AND visualizado = 0;  

    RETURN v_qtd;
END;
/



-- Teste das funções
BEGIN
    DBMS_OUTPUT.PUT_LINE('Total de alertas em Recife: ' || total_alertas_por_cidade('Recife'));
    DBMS_OUTPUT.PUT_LINE('Alertas não visualizados pelo usuário 1: ' || alertas_nao_visualizados(1));
END;
/

-- Bloco 1: total de alertas por cidade e nível
BEGIN
    DBMS_OUTPUT.PUT_LINE('Total de alertas por cidade:');
    FOR cidade_info IN (
        SELECT cidade, COUNT(*) AS total_alertas FROM alertas
        GROUP BY cidade ORDER BY total_alertas DESC
    ) LOOP
        IF cidade_info.total_alertas > 3 THEN
            DBMS_OUTPUT.PUT_LINE('Cidade: ' || cidade_info.cidade || ' | ALERTAS: ' || cidade_info.total_alertas || ' (Nível ALTO)');
        ELSIF cidade_info.total_alertas BETWEEN 2 AND 3 THEN
            DBMS_OUTPUT.PUT_LINE('Cidade: ' || cidade_info.cidade || ' | ALERTAS: ' || cidade_info.total_alertas || ' (Nível MODERADO)');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Cidade: ' || cidade_info.cidade || ' | ALERTAS: ' || cidade_info.total_alertas || ' (Nível BAIXO)');
        END IF;
    END LOOP;
END;
/

-- Bloco 2: alertas não visualizados por usuário
DECLARE
    CURSOR c_usuarios IS
        SELECT id, nome FROM usuarios ORDER BY nome;
    v_count_alertas NUMBER;
BEGIN
    FOR user_rec IN c_usuarios LOOP
        SELECT COUNT(*) INTO v_count_alertas FROM usuario_alertas
        WHERE usuario_id = user_rec.id AND visualizado = 0;

        IF v_count_alertas > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Usuário: ' || user_rec.nome || ' | Alertas não visualizados: ' || v_count_alertas);
        ELSE
            DBMS_OUTPUT.PUT_LINE('Usuário: ' || user_rec.nome || ' | Todos os alertas foram visualizados.');
        END IF;
    END LOOP;
END;
/

-- Cursores Explícitos para alertas detalhados por usuário
DECLARE
    CURSOR c_usuarios IS
        SELECT id, nome FROM usuarios ORDER BY nome;

    v_id_usuario usuarios.id%TYPE;
    v_nome usuarios.nome%TYPE;

    CURSOR c_alertas_nao_visualizados(p_usuario_id NUMBER) IS
        SELECT alertas.id, alertas.tipo, alertas.descricao, alertas.cidade, alertas.data
        FROM alertas
        JOIN usuario_alertas ON alertas.id = usuario_alertas.alerta_id
        WHERE usuario_alertas.usuario_id = p_usuario_id AND usuario_alertas.visualizado = 0;

    v_id_alerta alertas.id%TYPE;
    v_tipo alertas.tipo%TYPE;
    v_descricao alertas.descricao%TYPE;
    v_cidade alertas.cidade%TYPE;
    v_data_alerta alertas.data%TYPE;

BEGIN
    OPEN c_usuarios;
    LOOP
        FETCH c_usuarios INTO v_id_usuario, v_nome;
        EXIT WHEN c_usuarios%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE('Usuário: ' || v_nome || ' (ID: ' || v_id_usuario || ')');

        OPEN c_alertas_nao_visualizados(v_id_usuario);
        LOOP
            FETCH c_alertas_nao_visualizados INTO v_id_alerta, v_tipo, v_descricao, v_cidade, v_data_alerta;
            EXIT WHEN c_alertas_nao_visualizados%NOTFOUND;

            DBMS_OUTPUT.PUT_LINE('  Alerta ID: ' || v_id_alerta || ', Tipo: ' || v_tipo || ', Descrição: ' || v_descricao || ', Cidade: ' || v_cidade || ', Data: ' || TO_CHAR(v_data_alerta, 'DD/MM/YYYY HH24:MI:SS'));
        END LOOP;
        CLOSE c_alertas_nao_visualizados;

        DBMS_OUTPUT.PUT_LINE('-----------------------------');
    END LOOP;
    CLOSE c_usuarios;
END;
/

-- Consultas SQL Complexas (relatórios)

-- Total de alertas por tipo e cidade, mostrando só cidades com mais de 1 alerta
SELECT 
    tipo, 
    cidade, 
    COUNT(*) AS total_alertas
FROM 
    alertas
GROUP BY 
    tipo, cidade
HAVING 
    COUNT(*) > 1
ORDER BY 
    cidade, total_alertas DESC;

-- Número de alertas não visualizados por usuário e por tipo de alerta
SELECT 
    u.nome, 
    a.tipo, 
    COUNT(*) AS alertas_nao_visualizados
FROM 
    usuarios u
JOIN 
    usuario_alertas ua ON u.id = ua.usuario_id
JOIN 
    alertas a ON ua.alerta_id = a.id
WHERE 
    ua.visualizado = 0
GROUP BY 
    u.nome, a.tipo
ORDER BY 
    u.nome, alertas_nao_visualizados DESC;

-- Média de alertas por cidade para cidades que possuem pelo menos 2 usuários cadastrados
SELECT 
    a.cidade,
    COUNT(a.id) AS total_alertas
FROM 
    alertas a
JOIN 
    usuarios u ON a.cidade = u.cidade
GROUP BY 
    a.cidade
HAVING 
    COUNT(DISTINCT u.id) >= 2
ORDER BY 
    total_alertas DESC;

-- Lista de usuários com o número total de alertas visualizados e não visualizados
SELECT
    u.nome,
    SUM(CASE WHEN ua.visualizado = 1 THEN 1 ELSE 0 END) AS total_visualizados,
    SUM(CASE WHEN ua.visualizado = 0 THEN 1 ELSE 0 END) AS total_nao_visualizados
FROM 
    usuarios u
LEFT JOIN 
    usuario_alertas ua ON u.id = ua.usuario_id
GROUP BY 
    u.nome
ORDER BY 
    total_nao_visualizados DESC, total_visualizados DESC;

-- Usuários que possuem alertas de todos os tipos ('chuva', 'vento', 'calor') não visualizados
SELECT 
    nome
FROM 
    usuarios u
WHERE 
    NOT EXISTS (
        SELECT 1 FROM (
            SELECT DISTINCT tipo FROM alertas
        ) tipos
        WHERE NOT EXISTS (
            SELECT 1 FROM usuario_alertas ua
            JOIN alertas a ON ua.alerta_id = a.id
            WHERE ua.usuario_id = u.id
              AND ua.visualizado = 0
              AND a.tipo = tipos.tipo
        )
    )
ORDER BY nome;














