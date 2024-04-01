-- 1
CREATE OR ALTER PROC [dbo].[insertCursos]
	@IdUsuario INT,
	@IdTipoCurso INT,
	@Nome VARCHAR(45),
	@DataInicial DATE,
	@Duracao SMALLINT
	AS
	/*
    Documentação
    Arquivo fonte.....: smningatreinamentogrupo3.sql
    Objetivo..........: Inserir cursos
    Autor.............: SMN - Emanuel
    Data..............: 01/04/2024
    Ex................: DECLARE @RESULTADO TINYINT
						EXEC @RESULTADO = [dbo].[insertCursos] 4, 1, 'Como falar OI', '2024-04-01', 5
						SELECT @RESULTADO
    Retornos..........: 0 - OK
						1 - Usuario n existe
						2 - Tipo curso n existe
						3 - Erro ao inserir
    */
	BEGIN 
		IF (SELECT IdProfessor FROM Usuario WHERE Id = @IdUsuario) IS NULL RETURN 1

		IF NOT EXISTS(SELECT * FROM TipoCurso WHERE Id = @IdTipoCurso) RETURN 2

		INSERT INTO Curso (IdUsuario, Nome, Duracao, DataInicial, IdTipoCurso)
			VALUES (@IdUsuario, @Nome, @Duracao, @DataInicial, @IdTipoCurso)

		IF @@ERROR != 0 RETURN 3

		RETURN 0
	END 
GO

-- 2
CREATE OR ALTER PROC [dbo].[selectTodosCursos]
	@idUsuario INT
	AS
	/*
    Documentação
    Arquivo fonte.....: smningatreinamentogrupo3.sql
    Objetivo..........: Selecionar cursos
    Autor.............: SMN - Emanuel
    Data..............: 01/04/2024
    Ex................: EXEC [dbo].[selectTodosCursos] 1
    Retornos..........:
    */
	BEGIN 
		IF NOT EXISTS (SELECT Id FROM Autenticacao WHERE IdUsuario = @idUsuario)
			BEGIN
				SELECT 'Usuário n autenticado'
			END
		ELSE
			BEGIN
				SELECT CR.Nome, CR.DataInicial, CR.DataFinal, US.NomeCompleto, CR.Duracao, TC.Nome FROM Curso AS CR
					INNER JOIN Usuario AS US
						ON US.Id = CR.IdUsuario
					INNER JOIN TipoCurso AS TC
						ON TC.Id = CR.IdTipoCurso
			END
	END 
GO

-- 3
CREATE OR ALTER PROC SP_InserirModulo(
        @IdDificuldade TINYINT,
        @IdCurso TINYINT,
        @Nome VARCHAR(45)
        )
        AS
        /*
        Documentação
        Arquivo fonte.....: 
        Objetivo..........: Inserir Modulo
        Autor.............: SMN - JUAN
        Data..............: 27/03/2024
        Ex................: EXEC [dbo].[SP_InserirModulo]
        Retornos..........: 0 - Processamento OK
                            1 - Id Dificuldade não existe
                            2 - Id Curso não existe
        */
        BEGIN
            IF NOT EXISTS(SELECT Id FROM Dificuldade WHERE Id = @IdDificuldade ) RETURN 1

            IF NOT EXISTS(SELECT Id FROM Curso WHERE Id = @IdCurso ) RETURN 2

            INSERT INTO Modulo(IdDificuldade, IdCurso, Nome)
                VALUES(@IdDificuldade, @IdCurso, @Nome)

            RETURN 0

        END
    GO

CREATE OR ALTER PROC SP_InserirLicao(
         @IdDificuldade TINYINT,
         @Nome VARCHAR(45)
         )
         AS
         /*
        Documentação
        Arquivo fonte.....: 
        Objetivo..........: Inserir Lição
        Autor.............: SMN - JUAN
        Data..............: 27/03/2024
        Ex................: EXEC [dbo].[SP_InserirModulo]
        Retornos..........: 0 - Processamento OK
                            1 - Id Dificuldade não existe
        */
         BEGIN

            IF NOT EXISTS(SELECT Id FROM Dificuldade WHERE Id = @IdDificuldade ) RETURN 1

            INSERT INTO Licao(IdDificuldade, Nome)
                VALUES(@IdDificuldade, @Nome)

            RETURN 0
        END
    GO

-- 4
CREATE OR ALTER PROC [dbo].[insertDicionario]
	@IdCurso INT,
	@Nome VARCHAR(45),
	@Descricao VARCHAR(100)
	AS
	/*
    Documentação
    Arquivo fonte.....: smningatreinamentogrupo3.sql
    Objetivo..........: Inserir dicionario
    Autor.............: SMN - Emanuel
    Data..............: 01/04/2024
    Ex................: DECLARE @RESULTADO TINYINT
						EXEC @RESULTADO = [dbo].[insertDicionario] 1, 'Dicionario de portgues', 'Muito bom'
						SELECT @RESULTADO
    Retornos..........: 0 - OK
						1 - Curso n existe
						2 - Erro ao inserir
    */
	BEGIN 
		IF (SELECT Id FROM Curso WHERE Id = @IdCurso) IS NULL RETURN 1

		INSERT INTO Dicionario (IdCurso, Nome, Descricao)
			VALUES (@IdCurso, @Nome, @Descricao)

		IF @@ERROR != 0 RETURN 2

		RETURN 0
	END 
GO

CREATE OR ALTER PROC [dbo].[insertForum]
	@IdCurso INT,
	@Descricao VARCHAR(100)
	AS
	/*
    Documentação
    Arquivo fonte.....: smningatreinamentogrupo3.sql
    Objetivo..........: Inserir forum
    Autor.............: SMN - Emanuel
    Data..............: 01/04/2024
    Ex................: DECLARE @RESULTADO TINYINT
						EXEC @RESULTADO = [dbo].[insertForum] 1, 'Comentários total'
						SELECT @RESULTADO
    Retornos..........: 0 - OK
						1 - Curso n existe
						2 - Erro ao inserir
    */
	BEGIN 
		IF (SELECT Id FROM Curso WHERE Id = @IdCurso) IS NULL RETURN 1

		INSERT INTO Forum (IdCurso, DescricaoCurso)
			VALUES (@IdCurso, @Descricao)

		IF @@ERROR != 0 RETURN 2

		RETURN 0
	END 
GO

