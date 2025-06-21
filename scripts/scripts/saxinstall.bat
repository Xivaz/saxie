REM install PauloVI Academico
REM AUTOR: SILAS SILVA
REM DATA: 21/02/2017
REM UTILITÁRIO DE INSTALAÇÃO DO BANCO DE DADOS DO SISTEMA ACADEMICO PARA A FACULDADE PauloVI.
@ECHO OFF;
SET PATH=%PATH%;C:\oraclexe\app\oracle\product\11.2.0\server\bin;
ECHO "Copiando diretório de Imagens..."
C:
CD \oraclexe\app\oracle\product\11.2.0\server\apex\
MKDIR images
robocopy E:\sax\install\apex_5.0.3\apex\images\ C:\oraclexe\app\oracle\product\11.2.0\server\apex\images\ /S /E

E:
CD \SAX\INSTALL\SCRIPT\
SQLPLUS.EXE "%1 as sysdba" @"E:\sax\install\script\tsuser_install.sql"
ECHO "Instalando tablespaces e usuário..."
CD \sax\install\apex_5.0.3\apex\
ECHO "Removendo APEX..."

exit | sqlplus.exe "%1 as sysdba" @apxremov.sql



ECHO "Instalando APEX 5.0.3..."

exit | sqlplus.exe "%1 as sysdba" @apexins.sql TS_APEX TS_DATA TEMP /i/

ECHO "Configurando APEX 5.0.3..."

exit | sqlplus.exe "%1 as sysdba" @apex_epg_config.sql E:\sax\install\apex_5.0.3\
exit | sqlplus.exe "%1 as sysdba" @apxchpwd.sql Kr4!thos
exit | sqlplus.exe "%1 as sysdba" @DISABLE_XDB_POPUP.sql
exit | sqlplus.exe "%1 as sysdba" @dba_network_acl050000.sql

ECHO "Instalando SAX - Software Academico eXpresso para IEs 1.0..."
E:
CD \SAX\INSTALL\SCRIPT\
SQLPLUS.EXE /nolog @"E:\sax\install\script\install.sql"

@ECHO ON;

