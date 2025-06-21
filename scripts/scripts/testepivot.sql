select * from (select peri.peri_in_id, peri.peri_st_nome, tur.tur_in_id, tur.tur_st_codigo, hose.hose_in_sequencia, hose.hose_st_horario, hose.hose_in_diasem 
                 from tbl_horario_semana hose
				 left join tbl_periodo peri on peri.peri_in_id = hose.peri_in_id
				 left join tbl_turma tur on tur.tur_in_id = hose.turm_in_id
				 )
pivot (count(hose_in_sequencia) for hose_in_diasem in ( 2 as seg, 3 as ter, 4 as qua, 5 as qui, 6 as sex, 7 as sab));


insert into tbl_horario_semana (HOSE_IN_ID, HOSE_IN_DIASEM, PERI_IN_ID, TURM_IN_ID, HOSE_IN_SEQUENCIA, DISC_IN_ID, HOSE_ST_HORARIO, USUA_ST_ATUALIZA, USUA_DT_ATUALIZA)
values (SQ_HORARIO_SEMANA.NEXTVAL, 1, 1, 1, 1, 1, '08:00',USER,SYSDATE);

insert into tbl_horario_semana (HOSE_IN_ID, HOSE_IN_DIASEM, PERI_IN_ID, TURM_IN_ID, HOSE_IN_SEQUENCIA, DISC_IN_ID, HOSE_ST_HORARIO, USUA_ST_ATUALIZA, USUA_DT_ATUALIZA)
values (SQ_HORARIO_SEMANA.NEXTVAL, 1, 1, 1, 2, 1, '09:00',USER,SYSDATE);

insert into tbl_horario_semana (HOSE_IN_ID, HOSE_IN_DIASEM, PERI_IN_ID, TURM_IN_ID, HOSE_IN_SEQUENCIA, DISC_IN_ID, HOSE_ST_HORARIO, USUA_ST_ATUALIZA, USUA_DT_ATUALIZA)
values (SQ_HORARIO_SEMANA.NEXTVAL, 1, 1, 1, 3, 1, '10:00',USER,SYSDATE);

