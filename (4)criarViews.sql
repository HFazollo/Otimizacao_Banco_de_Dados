-- adicionada à function
CREATE MATERIALIZED VIEW patrocinio_empresa AS
SELECT e.nome AS nome_empresa, c.nome_canal, p.valor
FROM Empresa e
JOIN Patrocinio p ON e.nro = p.nro_empresa
JOIN Canal c ON p.id_canal = c.id_canal;


-- adicionada à function
CREATE MATERIALIZED VIEW inscricao_usuario AS
SELECT u.nick AS nick_usuario, COUNT(i.id_canal) AS qtd_canais, SUM(nc.valor) AS valor_total
FROM Usuario u
JOIN Inscricao i ON u.id_usuario = i.id_usuario
JOIN NivelCanal nc ON i.id_canal = nc.id_canal AND i.nivel = nc.nivel
GROUP BY u.nick;


-- adicionada à function
CREATE MATERIALIZED VIEW doacao_canal AS
SELECT 
    c.nome_canal, 
    SUM(d.valor) AS total_doacoes,
    cm.data_registro_comentario AS data_doacao,
    d.status AS status_doacao
FROM 
    Canal c
JOIN 
    Video v ON c.id_canal = v.id_canal
JOIN 
    Comentario cm ON v.id_video = cm.id_video
JOIN 
    Doacao d ON cm.id_comentario = d.id_comentario
GROUP BY 
    c.nome_canal,
    cm.data_registro_comentario,
    d.status;

