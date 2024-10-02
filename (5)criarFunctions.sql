-- Consulta 1: Identificar canais patrocinados e valores de patrocínio (Stored procedure -> filtrar por empresa como parâmetro adicional)
CREATE OR REPLACE FUNCTION canais_patrocinados(empresa_nome VARCHAR(32) DEFAULT NULL)
RETURNS TABLE (nome_empresa VARCHAR(32), nome_canal VARCHAR(32), valor_patrocinio DECIMAL(10, 2))
AS $$
SELECT pe.nome_empresa, pe.nome_canal, pe.valor
FROM patrocinio_empresa pe
WHERE empresa_nome IS NULL OR pe.nome_empresa = $1
ORDER BY pe.valor DESC;
$$
 LANGUAGE sql;

-- Consulta 2: Canais que cada usuário é membro e soma do valor gasto por mês (Stored procedure -> filtrar por usuário como parâmetro adicional)
CREATE OR REPLACE FUNCTION canais_membros(usuario_nick VARCHAR(50) DEFAULT NULL)
RETURNS TABLE (
nick_usuario VARCHAR(50),
qtd_canais BIGINT,
valor_total DECIMAL(10, 2)
)
AS $$
SELECT iu.nick_usuario, iu.qtd_canais, iu.valor_total
FROM inscricao_usuario iu
WHERE usuario_nick IS NULL OR iu.nick_usuario = $1
ORDER BY iu.valor_total DESC;
$$
LANGUAGE sql;

-- Consulta 3: Canais que já recebram doações e a soma dos valores recebidos em doação (Stored procedure -> filtrar por canal como parâmetro adicional)
CREATE OR REPLACE FUNCTION canais_receberam_doacoes(canal_nome VARCHAR(32) DEFAULT NULL)
RETURNS TABLE (
    nome_canal VARCHAR(32),
    total_doacoes DECIMAL(10, 2),
    data_doacao DATE,
    status_doacao VARCHAR(20)
)
AS $$
SELECT
    dc.nome_canal,
    dc.total_doacoes,
    dc.data_doacao,
    dc.status_doacao
FROM doacao_canal dc
WHERE (canal_nome IS NULL OR dc.nome_canal = $1)
ORDER BY dc.total_doacoes DESC;
$$
 LANGUAGE sql;

-- Consulta 4: Soma das doações geradas pelos comentários que foram lidos por vídeo (Stored procedure -> filtrar por vídeo como parâmetro adicional)
CREATE OR REPLACE FUNCTION doacoes_video(
    video_id INTEGER DEFAULT NULL,
    data_doacao_inicial DATE DEFAULT NULL,
    data_doacao_final DATE DEFAULT NULL
)
RETURNS TABLE (
    id_video INTEGER,
    total_doacoes DECIMAL(10, 2)
)
AS $$
SELECT
    v.id_video,
    SUM(dc.total_doacoes) AS total_doacoes
FROM doacao_canal dc
JOIN Video v ON dc.nome_canal = (SELECT nome_canal FROM Canal WHERE id_canal = v.id_canal)
WHERE (video_id IS NULL OR v.id_video = video_id)
    AND (data_doacao_inicial IS NULL OR dc.data_doacao >= data_doacao_inicial)
    AND (data_doacao_final IS NULL OR dc.data_doacao <= data_doacao_final)
GROUP BY v.id_video
ORDER BY total_doacoes DESC;
$$
 LANGUAGE sql;

-- 5: Listar e ordenar canais que mais recebem patrocínio e seus valores
CREATE OR REPLACE FUNCTION k_canais_patrocinio(k INTEGER)
RETURNS TABLE (
    nome_canal VARCHAR(32),
    total_patrocinio DECIMAL(10, 2)
)
AS $$
    SELECT
        nome_canal,
        total_patrocinio
    FROM (
        SELECT
            c.nome_canal,
            SUM(p.valor) AS total_patrocinio
        FROM Patrocinio p
        JOIN Canal c ON p.id_canal = c.id_canal
        GROUP BY c.nome_canal
    ) AS subquery
    ORDER BY total_patrocinio DESC
    LIMIT k;
$$
LANGUAGE sql;

-- 6: Listar e ordenar canais que mais recebem dinheiro de membros e os valores recebidos
CREATE OR REPLACE FUNCTION k_canais_aportes(k INT)
RETURNS TABLE(nome_canal VARCHAR, valor_total_aportes DECIMAL)
AS $$
    SELECT 
        c.nome_canal, 
        SUM(nc.valor) AS valor_total_aportes
    FROM 
        Canal c
    JOIN 
        NivelCanal nc ON c.id_canal = nc.id_canal
    GROUP BY 
        c.nome_canal
    ORDER BY 
        valor_total_aportes DESC
    LIMIT k;
$$
LANGUAGE sql;

-- 7: Listar e ordenar os canais que mais receberam doações considerando TODOS os vídeos
CREATE OR REPLACE FUNCTION k_canais_doacao(k INTEGER)
RETURNS TABLE (
    nome_canal VARCHAR(32),
    total_doacoes DECIMAL(10, 2)
)
AS $$
    SELECT
        nome_canal,
        total_doacoes
    FROM doacao_canal
    ORDER BY total_doacoes DESC
    LIMIT k;
$$
LANGUAGE sql;

-- 8: Listar canais que mais faturam considerando as 3 fontes de receita: patrocínio, membros inscritos e doações
CREATE OR REPLACE FUNCTION k_canais_receita(k INTEGER)
RETURNS TABLE (
    nome_canal VARCHAR(32),
    total_receita DECIMAL(10, 2)
)
AS $$
    SELECT
        nome_canal,
        total_receita
    FROM (
        SELECT
            c.nome_canal,
            COALESCE(SUM(pe.valor), 0) + COALESCE(iu.valor_total, 0) + COALESCE(dc.total_doacoes, 0) AS total_receita
        FROM Canal c
        LEFT JOIN patrocinio_empresa pe ON c.nome_canal = pe.nome_canal
        LEFT JOIN inscricao_usuario iu ON c.nome_canal = iu.nick_usuario
        LEFT JOIN doacao_canal dc ON c.nome_canal = dc.nome_canal
        GROUP BY c.nome_canal, iu.valor_total, dc.total_doacoes
    ) AS subquery
    ORDER BY total_receita DESC
    LIMIT k;
$$
LANGUAGE sql;
