CREATE OR REPLACE VIEW VW_CURSO_TURNO AS
SELECT 
       CT.CTURN_IN_ID,
	   CT.CUR_IN_ID, 
       C.CUR_ST_NOME, 
	   CT.TURN_IN_ID, 
	   T.TURN_ST_DESCRICAO, 
       CT.in_vaga_nova,
	   CT.in_vaga_reman,
       CT.in_vaga_progesp,
       CT.in_prazo_minimo_integra,
       CT.in_prazo_maximo_integra,
       CT.in_inscrito_nova,
       CT.in_inscrito_reman,
       CT.in_inscrito_progesp,
	   CT.user_st_atualiza,
	   CT.user_dt_atualiza
  FROM  TBL_CURSO_TURNO CT
 INNER JOIN TBL_CURSO C
    ON C.CUR_IN_ID = CT.CUR_IN_ID
 INNER JOIN TBL_TURNO T
    ON T.TURN_IN_ID = CT.TURN_IN_ID;
	
GRANT SELECT ON VW_CURSO_TURNO TO PUBLIC;	