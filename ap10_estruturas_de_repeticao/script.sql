--tratamento de erros
DO $$
BEGIN
    RAISE NOTICE '%', 1 / 0;
    RAISE NOTICE 'Acabou...';
EXCEPTION
    WHEN division_by_zero THEN
        RAISE NOTICE 'Nao divida por zero';
END;
$$

--FOREACH com fatias (slice)
DO $$
DECLARE
    vetor INT[] := ARRAY[1, 2, 3];
    matriz INT[] := ARRAY[
        [1, 2, 3],
        [4, 5, 6],
        [7, 8, 9]
    ];
    var_aux INT;
    vet_aux INT[];
BEGIN
    RAISE NOTICE 'SLICE %, vetor', 0; -- 0: representa dimensão escalar (elementos)
    FOREACH var_aux IN ARRAY vetor LOOP
        RAISE NOTICE '%', var_aux;
    END LOOP;

    RAISE NOTICE 'SLICE %, vetor', 1; --1: representa 1 dimensão, LINHA
    FOREACH vet_aux SLICE 1 IN ARRAY vetor LOOP
        RAISE NOTICE '%',vet_aux;
    END LOOP;

    RAISE NOTICE 'SLICE %, matriz', 0;
    FOREACH var_aux IN ARRAY matriz LOOP
        RAISE NOTICE '%', var_aux;
    END LOOP;

    RAISE NOTICE 'SLICE %, matriz', 1;
    FOREACH vet_aux SLICE 1 IN ARRAY matriz LOOP
        RAISE NOTICE '%', vet_aux;
    END LOOP;

    RAISE NOTICE 'SLICE %, matriz', 2; --2: representa 2 dimensões, LINHA e COLUNA
    FOREACH vet_aux SLICE 2 IN ARRAY matriz LOOP
        RAISE NOTICE '%', vet_aux;
    END LOOP;    

END;
$$

--FOREACH
DO $$
DECLARE
    valores INT[] := ARRAY [
        valor_aleatorio_entre(1, 10),
        valor_aleatorio_entre(1, 10),
        valor_aleatorio_entre(1, 10),
        valor_aleatorio_entre(1, 10),
        valor_aleatorio_entre(1, 10)
    ];
    valor INT;
    soma INT := 0;
BEGIN
    FOREACH valor IN ARRAY valores LOOP
        RAISE NOTICE 'Valor da vez: %', valor;
        soma := soma + valor;
    END LOOP;
    RAISE NOTICE 'Soma: %', soma;
END;
$$

DO $$
DECLARE
    aluno RECORD;
    media NUMERIC(10, 2) := 0;
    total_alunos INT;
BEGIN
    FOR aluno IN 
        SELECT * FROM tb_aluno
    LOOP
        RAISE NOTICE 'Nota do aluno %: %', aluno.cod_aluno, aluno.nota;
        media := media + aluno.nota;
    END LOOP;
    SELECT COUNT(*) FROM tb_aluno INTO total_alunos;
    RAISE NOTICE 'Média: %', media / total_alunos;
END;
$$

DO $$
BEGIN
    FOR i IN 1..10 LOOP
        INSERT INTO tb_aluno
        (nota)
        VALUES
        (valor_aleatorio_entre(0, 10));
    END LOOP;
END;
$$

--criando a tabela
CREATE TABLE tb_aluno(
    cod_aluno SERIAL PRIMARY KEY,
    nota INT
);

-- for
DO $$
BEGIN
    --contar de 0 a 10, de 1 em 1
    --intervalo fechado[1, 10]
    FOR i IN 1..10 LOOP
        RAISE NOTICE '%', i;
    END LOOP;
    --não mostra nada
    FOR i IN 10..1 LOOP
        RAISE NOTICE '%', i;
    END LOOP;
    --contagem regressiva
    FOR i IN REVERSE 10..1 LOOP
        RAISE NOTICE '%', i;
    END LOOP;

    --de 1 a 50 de 2 em 2
    FOR i IN 1..50 BY 2 LOOP
        RAISE NOTICE '%', i;
    END LOOP;
    --de 50 a 1 de 2 em 2
    FOR i IN REVERSE 50..1 BY 2 LOOP
        RAISE NOTICE '%', i;
    END LOOP;

END;
$$

-- while
DO $$
DECLARE
    nota INT;
    media NUMERIC(10, 2) := 0;
    contador INT := 0;
    total_alunos INT := 20;
BEGIN
    --[n, m]
    --[-1, 10]
    WHILE contador <= total_alunos LOOP --repetição controlada por contador
        SELECT valor_aleatorio_entre(0, 10) INTO nota;
        RAISE NOTICE '%', nota;
        media := media + nota;
        contador := contador + 1;
    END LOOP;
    IF contador > 0 THEN
        RAISE NOTICE 'Média: %', media / contador;
    ELSE
        RAISE NOTICE 'Nenhuma nota gerada';
    END IF;
END;
$$

-- while
DO $$
DECLARE
    nota INT;
    media NUMERIC(10, 2) := 0;
    contador INT := 0;
BEGIN
    --[n, m]
    --[-1, 10]
    --valor_aleatorio_entre(0, 11) - 1 se trata de uma operação mesmo, valor_aleatorio_entre(0, 11)
    SELECT valor_aleatorio_entre(0, 11) - 1 INTO nota;
    WHILE nota >= 0 LOOP --repetição controlada por sentinela
        RAISE NOTICE '%', nota;
        media := media + nota;
        contador := contador + 1;
        SELECT valor_aleatorio_entre(0, 11) - 1 INTO nota;
    END LOOP;
    IF contador > 0 THEN
        RAISE NOTICE 'Média: %', media / contador;
    ELSE
        RAISE NOTICE 'Nenhuma nota gerada';
    END IF;
END;
$$

-- loops aninhados e rótulos
DO $$
DECLARE
    i INT;
    j INT;
BEGIN
    i := 0;
    <<externo>>
    LOOP
        i := i + 1;
        EXIT WHEN i > 10;
        j := 1;
        <<interno>>
        LOOP
            RAISE NOTICE '% %', i, j;            
            j := j + 1;
            CONTINUE externo WHEN j > 5;
        END LOOP;
    END LOOP;
END;
$$

-- loops aninhados e rótulos
DO $$
DECLARE
    j INT;
    i INT;
BEGIN
    i := 0;
    <<externo>>
    LOOP
        i  := i + 1;
        EXIT WHEN i > 10;
        j := 1;
        <<interno>>
        LOOP
            RAISE NOTICE '% %', i, j;
            j := j + 1;
            EXIT externo WHEN j > 5;
        END LOOP;
    END LOOP;
END;
$$

-- ignorando iterações com CONTINUE
DO $$
DECLARE
    contador INT := 0;
BEGIN
    LOOP
        contador := contador + 1;
        EXIT WHEN contador > 100;

        IF contador % 7 = 0 THEN
            CONTINUE; --"continue" = pule a interação
        END IF;
        
        CONTINUE WHEN contador % 11 = 0; --outra maneira de fazer
        
        RAISE NOTICE '%', contador;
    END LOOP;
END
$$;

--EXIT WHEN
DO $$
DECLARE
    contador INT := 1;
BEGIN
    LOOP
        RAISE NOTICE '%', contador;
        contador := contador + 1;
        EXIT WHEN contador > 10;
    END LOOP;
END
$$;

DO $$
DECLARE
    contador INT := 1;
BEGIN
    LOOP
        RAISE NOTICE '%', contador;
        contador := contador + 1;
        IF contador > 10 THEN
            EXIT;
        END IF;
    END LOOP;
END
$$;

DO $$
BEGIN
    -- esse é um loop infinito, nao execute!
    LOOP
        RAISE NOTICE 'Um loop simples...';
    END LOOP;
END
$$;