-- Trigger para atualizar visualizações
CREATE OR REPLACE FUNCTION update_visualizacoes() RETURNS TRIGGER AS 
$$
BEGIN
    UPDATE Canal
    SET qtd_visualizacoes = qtd_visualizacoes + NEW.visu_total_video
    WHERE id_canal = NEW.id_canal;
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER update_visualizacoes
AFTER INSERT ON Video
FOR EACH ROW
EXECUTE FUNCTION update_visualizacoes();

-- Trigger para atualizar a quantidade de usuários 
CREATE OR REPLACE FUNCTION update_plataforma_users() RETURNS TRIGGER AS
$$
BEGIN
    UPDATE Plataforma
    SET qtd_users = qtd_users + 1
    WHERE nro = NEW.nro_plataforma;
    RETURN NEW;
END;
$$ 
LANGUAGE plpgsql;

CREATE TRIGGER update_plataforma_users_trigger
AFTER INSERT ON PlataformaUsuario
FOR EACH ROW
EXECUTE FUNCTION update_plataforma_users();

