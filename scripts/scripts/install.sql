REM "Script de instalação do software SAXIE - Software Academico Express para instituições de ensino."
REM "Autor: Silas Silva, Data: 20/03/2017 - Mogi das Cruzes - SP - Brasil"
REM "Esse script deve ser executado como usuário SYS para criação dos objetos necessários para o sistema SAXIE"
REM "Cria usuário do cliente e garante os privilégios para o mesmo."
REM "Cria tablespaces do sistema"
REM "Instala APEX versão 5.0.3"
REM "Cria Modelo de Dados do Sistema SAX para IE"
REM "Importa Applicação APEX SAX para IE"


connect saxie/s4x13;

prompt instalando software SAXIE...

@@dminstall.sql;
@@install_release1_0.sql;

exit;

