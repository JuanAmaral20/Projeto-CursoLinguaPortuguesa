CREATE OR ALTER TRIGGER TRG_InserirNomeCompleto
        ON [dbo].[Usuario]
        AFTER INSERT 
        AS

        BEGIN
            DECLARE @IdI INT

            SELECT @IdI = Id
            FROM inserted

            IF @IdI IS NOT NULL
                UPDATE Usuario
                    SET NomeCompleto = CONCAT(Nome,' ', Sobrenome)
                WHERE Id = @IdI
        END
    GO