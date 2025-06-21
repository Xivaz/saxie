REM "Criação dos tablespaces e usuário dono da aplicação"
REM "Autor: Silas Silva Data:21/03/2017                 "
REM "---------------------------------------------------"
prompt Conectando como sys
connect sys/Kr4!th0s as sysdba;

spool c:\temp\tsuser_install.log;

prompt criando tablespaces...
@@tablespaces.sql;

prompt Criando Usuário...
@@userrole.sql;

disconnect;

spool off;

exit;