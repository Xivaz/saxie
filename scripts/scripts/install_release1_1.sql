REM "-- ------------------------------------------------------------------------- --"
REM " SCRIPT PARA ALTERAÇÃO DA TABELA DE CURSOS PARA ARMAZENAR ALGUMAS INF DO CENSO "
REM " SAX - RELEASE 1.1                                                             "
REM " AUTOR: SILAS SILVA 21/06/2017                                                 "
REM "-- ------------------------------------------------------------------------- --"
prompt Executando install_release1_1...
column arquivo new_val arquivo
select 'C:\SAX\INSTALL\LOG\install_release1_1_' || to_char(sysdate, 'yyyymmddhh24mi') || '.log' arquivo from dual;
spool &arquivo;

Alter Session Set nls_language='BRAZILIAN PORTUGUESE';
Alter Session Set NLS_TERRITORY = 'BRAZIL';
Alter Session Set NLS_NUMERIC_CHARACTERS=',.';
Alter Session Set NLS_DATE_FORMAT = 'DD/MM/YYYY HH24:MI:SS';

alter table tbl_curso
  add cur_in_inst_convenio integer;
  
alter table tbl_curso
  add cur_in_cond_pessdef integer;
  
alter table tbl_curso
  add cur_in_disc_semipresencial integer;

alter table tbl_curso
  add cur_nu_pctl_chsemipresencial number(3);
  
alter table tbl_curso
  add cur_in_utiliza_laboratorio integer;  
  
alter table tbl_docente
  add doce_in_visitante integer;  

comment on column tbl_curso.cur_in_utiliza_laboratorio is 'Utiliza Laboratórios (S=0/N=1)?';
  
comment on column tbl_curso.cur_in_inst_convenio is 'Intituição Conveniada que Financia o Curso';
comment on column tbl_curso.cur_in_cond_pessdef   is 'Condições de Ensino/Aprendisagem por meio de tecnologia assistiva ou ajuda técnica a deficiêntes.';
comment on column tbl_curso.cur_in_disc_semipresencial is 'Curso oferece Disciplinas semi presencial?';
comment on column tbl_curso.cur_in_pctl_chsemipresencial is 'Carga horária de Disciplinas semi presencial';
comment on column tbl_docente.doce_in_visitante is 'Docente Visitante';

INSERT INTO TBL_REFERENCIA(REFE_IN_ID, REFE_ST_TIPO , REFE_IN_CODIGO , REFE_ST_DESCRICAO, user_st_atualiza, user_dt_atualiza)
VALUES (SQ_REFERENCIA.NEXTVAL , 'CONDICAO_ENSINO_APRENDIZAGEM' , 1, 'Material em Braile', 'ADMIN', SYSDATE);
  
INSERT INTO TBL_REFERENCIA(REFE_IN_ID, REFE_ST_TIPO , REFE_IN_CODIGO , REFE_ST_DESCRICAO, user_st_atualiza, user_dt_atualiza)
VALUES (SQ_REFERENCIA.NEXTVAL , 'CONDICAO_ENSINO_APRENDIZAGEM' , 2, 'Material em Audio', 'ADMIN', SYSDATE);
  
INSERT INTO TBL_REFERENCIA(REFE_IN_ID, REFE_ST_TIPO , REFE_IN_CODIGO , REFE_ST_DESCRICAO, user_st_atualiza, user_dt_atualiza)
VALUES (SQ_REFERENCIA.NEXTVAL , 'CONDICAO_ENSINO_APRENDIZAGEM' , 3, 'Recursos de Informática Acessível', 'ADMIN', SYSDATE);

INSERT INTO TBL_REFERENCIA(REFE_IN_ID, REFE_ST_TIPO , REFE_IN_CODIGO , REFE_ST_DESCRICAO, user_st_atualiza, user_dt_atualiza)
VALUES (SQ_REFERENCIA.NEXTVAL , 'CONDICAO_ENSINO_APRENDIZAGEM' , 4, 'Material Impresso com caracter ampliado', 'ADMIN', SYSDATE);

INSERT INTO TBL_REFERENCIA(REFE_IN_ID, REFE_ST_TIPO , REFE_IN_CODIGO , REFE_ST_DESCRICAO, user_st_atualiza, user_dt_atualiza)
VALUES (SQ_REFERENCIA.NEXTVAL , 'CONDICAO_ENSINO_APRENDIZAGEM' , 5, 'Material Pedagógico Tátil', 'ADMIN', SYSDATE);

INSERT INTO TBL_REFERENCIA(REFE_IN_ID, REFE_ST_TIPO , REFE_IN_CODIGO , REFE_ST_DESCRICAO, user_st_atualiza, user_dt_atualiza)
VALUES (SQ_REFERENCIA.NEXTVAL , 'CONDICAO_ENSINO_APRENDIZAGEM' , 6, 'Recursos de Acessibilidade à Comunicação', 'ADMIN', SYSDATE);

INSERT INTO TBL_REFERENCIA(REFE_IN_ID, REFE_ST_TIPO , REFE_IN_CODIGO , REFE_ST_DESCRICAO, user_st_atualiza, user_dt_atualiza)
VALUES (SQ_REFERENCIA.NEXTVAL , 'CONDICAO_ENSINO_APRENDIZAGEM' , 7, 'Tradutor Intérprete de Libras', 'ADMIN', SYSDATE);

INSERT INTO TBL_REFERENCIA(REFE_IN_ID, REFE_ST_TIPO , REFE_IN_CODIGO , REFE_ST_DESCRICAO, user_st_atualiza, user_dt_atualiza)
VALUES (SQ_REFERENCIA.NEXTVAL , 'CONDICAO_ENSINO_APRENDIZAGEM' , 8, 'Insersão de Libras no Curso', 'ADMIN', SYSDATE);

INSERT INTO TBL_REFERENCIA(REFE_IN_ID, REFE_ST_TIPO , REFE_IN_CODIGO , REFE_ST_DESCRICAO, user_st_atualiza, user_dt_atualiza)
VALUES (SQ_REFERENCIA.NEXTVAL , 'CONDICAO_ENSINO_APRENDIZAGEM' , 9, 'Guia Interprete', 'ADMIN', SYSDATE);

INSERT INTO TBL_REFERENCIA(REFE_IN_ID, REFE_ST_TIPO , REFE_IN_CODIGO , REFE_ST_DESCRICAO, user_st_atualiza, user_dt_atualiza)
VALUES (SQ_REFERENCIA.NEXTVAL , 'CONDICAO_ENSINO_APRENDIZAGEM' , 10, 'Material Didático em Libras', 'ADMIN', SYSDATE);

INSERT INTO TBL_REFERENCIA(REFE_IN_ID, REFE_ST_TIPO , REFE_IN_CODIGO , REFE_ST_DESCRICAO, user_st_atualiza, user_dt_atualiza)
VALUES (SQ_REFERENCIA.NEXTVAL , 'CONDICAO_ENSINO_APRENDIZAGEM' , 11, 'Material Didático em formato impresso acessível', 'ADMIN', SYSDATE);

INSERT INTO TBL_REFERENCIA(REFE_IN_ID, REFE_ST_TIPO , REFE_IN_CODIGO , REFE_ST_DESCRICAO, user_st_atualiza, user_dt_atualiza)
VALUES (SQ_REFERENCIA.NEXTVAL , 'CONDICAO_ENSINO_APRENDIZAGEM' , 12, 'Material Didático em formato digital acessível', 'ADMIN', SYSDATE);

INSERT INTO TBL_TURNO(TURN_IN_ID, TURN_ST_DESCRICAO, TURN_IN_MODALIDADE, USER_ST_ATUALIZA, USER_DT_ATUALIZA)
VALUES (4, 'Vespertino',1,user,sysdate);

INSERT INTO TBL_TURNO(TURN_IN_ID, TURN_ST_DESCRICAO, TURN_IN_MODALIDADE, USER_ST_ATUALIZA, USER_DT_ATUALIZA)
VALUES (5, 'Integral',1,user,sysdate);

COMMIT;
spool off;

prompt install_release1_1 concluído com sucesso.
prompt Verifique o log em &arquivo para mais detalhes.
