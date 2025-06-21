REM install PauloVI Academico
REM AUTOR: SILAS SILVA
REM DATA: 21/02/2017
REM UTILITÁRIO DE INSTALAÇÃO DO BANCO DE DADOS DO SISTEMA ACADEMICO PARA A FACULDADE PauloVI.
@ECHO OFF;
SET PATH=%PATH%;C:\oraclexe\app\oracle\product\11.2.0\server\bin;
ECHO "Instalando Banco de Dados do SAX - Software Academico eXpresso para IEs 1.0..."
C:
CD \SAX\INSTALL\SCRIPT\

EXIT | SQLPLUS.EXE %1 AS SYSDBA @userrole.sql
EXIT | SQLPLUS.EXE /nolog @install.sql

@ECHO ON;

