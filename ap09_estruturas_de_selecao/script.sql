--ddmmaaaa
DO $$
DECLARE
    --testar
    --22/10/2022: válida
    --29/02/2020: válida
    --29/02/2021: inválida
    --28/02/2021: válida
    --31/09/2025: inválida
    --31/06/2025: inválida
    data INT := 22102022;
    dia INT;
    mes INT;
    ano INT;
    data_valida BOOL := TRUE;
BEGIN
    dia := data / 1000000; --divisao inteira da data por 1.000.000 nos dá 22, a quantidade inteira de dias
    mes := data % 1000000 / 10000; --divisao inteira da operação anterior por 10.000 nos dá 10, a quantidade inteira de mes
    ano := data % 10000; --aqui pegamos o resto da operação por 10.000
    RAISE NOTICE '%/%/%', dia, mes, ano;
    RAISE NOTICE 'Vejamos se ela é válida...';
    IF ano >= 1 THEN
        CASE
            WHEN mes > 12 OR mes < 1 OR  dia < 1 OR dia > 31 THEN
                data_valida := FALSE;
            ELSE
                IF (mes IN (4, 6, 9, 11)) AND dia > 30 THEN
                    data_valida := FALSE;
                ELSE
                    IF mes = 2 THEN
                        CASE
                            WHEN ano % 04 = 0 AND ano % 100 <> 0 OR ano % 400 = 0 THEN
                                IF dia > 29 THEN
                                    data_valida := FALSE;
                                END IF;
                            ELSE
                                IF dia > 28 THEN
                                    data_valida := FALSE;
                                END IF;
                        END CASE;
                END IF;
            END IF;
        END CASE;
    ELSE
        data_valida := FALSE;
    END IF;
    CASE
        WHEN data_valida THEN
            RAISE NOTICE 'Data válida!!';
        ELSE
            RAISE NOTICE 'Data inválida!';
    END CASE;
END;
$$

DO $$
DECLARE
    valor INT := valor_aleatorio_entre(1, 12);
    mensagem VARCHAR(200);
BEGIN
    RAISE NOTICE 'O valor da vez é %', valor;
    CASE valor
        WHEN 1, 3, 5, 7, 9 THEN
            mensagem := 'ímpar';
        WHEN 2, 4, 6, 8, 10 THEN
            mensagem := 'Par';
        ELSE
            mensagem := 'Fora do intervalo'
    END CASE;
    RAISE NOTICE '%', mensagem;
END;
$$

DO $$
DECLARE
    v_valor INT;
BEGIN
    v_valor := valor_aleatorio_entre(1,30);
    IF v_valor <= 20 THEN
        RAISE NOTICE 'A metade de % é %', v_valor, v_valor / 2::FLOAT;
    END IF;
END
$$;

CREATE OR REPLACE FUNCTION valor_aleatorio_entre (lim_inferior INT, lim_superior INT) RETURNS INT AS
$$
BEGIN
RETURN FLOOR(RANDOM() * (lim_superior - lim_inferior + 1) + lim_inferior)::INT;
END;
$$
LANGUAGE plpgsql;