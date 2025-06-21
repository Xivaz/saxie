REM "-- ------------------------------------------------------------------------- --"
REM " SCRIPT PARA ALTERAÇÃO DA TABELA DE CURSOS PARA ARMAZENAR ALGUMAS INF DO CENSO "
REM " SAX - RELEASE 1.2                                                             "
REM " AUTOR: SILAS SILVA 30/06/2017                                                 "
REM "-- ------------------------------------------------------------------------- --"
prompt Executando install_release1_1...
column arquivo new_val arquivo
select 'C:\SAX\INSTALL\LOG\install_release1_2_' || to_char(sysdate, 'yyyymmddhh24mi') || '.log' arquivo from dual;
spool &arquivo;

Alter Session Set nls_language='BRAZILIAN PORTUGUESE';
Alter Session Set NLS_TERRITORY = 'BRAZIL';
Alter Session Set NLS_NUMERIC_CHARACTERS=',.';
Alter Session Set NLS_DATE_FORMAT = 'DD/MM/YYYY HH24:MI:SS';

CREATE OR REPLACE TRIGGER TRG_BIU_MATRICULA BEFORE
  INSERT or UPDATE ON TBL_MATRICULA FOR EACH ROW
  DECLARE
    PROCEDURE SET_STATUS_ALUNO_CURSO(P_ACUR_IN_ID INTEGER, P_STAT_IN_ID INTEGER) IS
    BEGIN
      UPDATE TBL_ALUNO_CURSO
	     SET ACUR_DT_INGRESSO = SYSDATE
	   WHERE ACUR_DT_INGRESSO IS NULL
	     AND ACUR_IN_ID = P_ACUR_IN_ID;
	 
      UPDATE TBL_ALUNO_CURSO
	     SET ACUR_IN_SITUACAO = P_STAT_IN_ID
	       , ACUR_DT_ULTIMA_MATRICULA = (CASE P_STAT_IN_ID WHEN 1 THEN NULL
		                                                 WHEN 2 THEN SYSDATE
														 ELSE ACUR_DT_ULTIMA_MATRICULA
									     END)
		   , ACUR_DT_TRANSFERENCIA = (CASE P_STAT_IN_ID 	 WHEN 1 THEN NULL
		                                                 WHEN 5 THEN SYSDATE
														 ELSE ACUR_DT_TRANSFERENCIA
			   						  END)
	   WHERE ACUR_IN_ID = P_ACUR_IN_ID;
     END;
  BEGIN 
    IF INSERTING THEN
      -- Aluno curso começa com a situação desvínculado do curso
	  SET_STATUS_ALUNO_CURSO(:NEW.ACUR_IN_ID,NVL(:MATR_IN_SITUACAO,4));
    ELSE
      IF :NEW.MATR_IN_SITUACAO <> :OLD.MATR_IN_SITUACAO THEN
        IF :NEW.MATR_IN_SITUACAO = 2 THEN
           :NEW.MATR_DT_MATRICULA := SYSDATE;
           -- Aluno curso Situação Cursando
	       SET_STATUS_ALUNO_CURSO(:NEW.ACUR_IN_ID,2);
        ELSIF :NEW.MATR_IN_SITUACAO = 3 THEN
           :NEW.MATR_DT_TRANCAMENTO := SYSDATE;
           -- Aluno curso Situação Trancado
	       SET_STATUS_ALUNO_CURSO(:NEW.ACUR_IN_ID,3);
        ELSIF :NEW.MATR_IN_SITUACAO = 4 THEN
           :NEW.MATR_DT_CANCELAMENTO := SYSDATE;
           -- Aluno curso Situação Trancado
	       SET_STATUS_ALUNO_CURSO(:NEW.ACUR_IN_ID,3);
        ELSIF :NEW.MATR_IN_SITUACAO = 5 THEN
           :NEW.MATR_DT_TRANSFERENCIA := SYSDATE;
           -- Aluno curso Situação Transferido
	       SET_STATUS_ALUNO_CURSO(:NEW.ACUR_IN_ID,5);		 
        END IF;	 
	  END IF;
    END IF;
    PC_ATUALIZA_USUARIO(:NEW.USER_ST_ATUALIZA,:NEW.USER_DT_ATUALIZA);
  END;
/

show errors;


declare
  cursor c_aluno_curso is
  select acur_in_id, acur_in_situacao 
    from tbl_aluno_curso
   WHERE acur_in_situacao <> 4;
   w_sit_matricula integer; 
   w_peri_in_id    integer;
begin
	for cl in c_aluno_curso loop
		if cl.acur_in_situacao = 2 then
			--cursando
			w_sit_matricula := 2; -- confirmada
			w_peri_in_id := 1;
		elsif cl.acur_in_situacao = 3 then
			-- matricula trancada
			w_sit_matricula := 3; -- confirmada
			w_peri_in_id := 1;
		elsif cl.acur_in_situacao = 5 then
			-- transferido de curso
			w_sit_matricula := 5; -- transferido
			w_peri_in_id := 1;
		elsif cl.acur_in_situacao = 6 then
			-- formado
			w_sit_matricula := 2; -- confirmada
			w_peri_in_id := 8;
		elsif cl.acur_in_situacao = 7 then
			-- falecido
			w_sit_matricula := 1; -- pendente
			w_peri_in_id := 1;
		else
			-- desvinculado do curso
			w_sit_matricula := 1; -- pendente
			w_peri_in_id := 1;
		end if;
		begin
		 insert into tbl_matricula
			(MATR_IN_ID, ACUR_IN_ID, PERI_IN_ID, MATR_IN_SITUACAO,
			 MATR_DT_MATRICULA, MATR_DT_TRANCAMENTO, MATR_DT_TRANSFERENCIA,
			 MATR_RE_DEBITOS, MATR_RE_CREDITOS, MATR_ST_OBSERVACOES)
		 values
			(SQ_MATRICULA.NEXTVAL, cl.acur_in_id, w_peri_in_id, w_sit_matricula,
			 TO_DATE('01032016','DDMMYYYY'),TO_DATE(NULL),TO_DATE(NULL),
			 0,0,NULL);
		end;
	end loop;
	COMMIT;
end;
/
spool off;
prompt install_release1_2 concluído com sucesso.	
prompt Arquivo de log: &arquivo
prompt Verifique o log em &arquivo para mais detalhes.
-- -------------------------------------------------------------------------