@echo off
setlocal

set BOOGIEDIR=..\..\Binaries
set DAFNY_EXE=%BOOGIEDIR%\Dafny.exe
set BPLEXE=%BOOGIEDIR%\Boogie.exe

for %%f in (AssumeStmt0 AssumeStmt1 AssertStmt0 AssertStmt1
    Precondition0 Precondition1 Postcondition0 Postcondition1
    Old0 Old1 Invariant0 Invariant1 Invariant2 Invariant3
    GhostField0 Function0 GhostMultiAssignment0
    MethodGhostParams0 MethodGhostParams1 GhostMethod0
    MethodGhostParams2 MethodGhostParams3 GhostModule0) do (
  echo.
  echo -------------------- %%f --------------------
  %DAFNY_EXE% /nologo /errorTrace:0 /verification:0 /runtimeChecking:0 /compile:2 %* %%f.dfy
  if exist %%f.cs. (
    del %%f.cs
  )
  if exist %%f.exe. (
    del %%f.exe
  )
  if exist %%f.pdb. (
    del %%f.pdb
  )
  if exist %%f.pdb.original. (
    del %%f.pdb.original
  )
)
