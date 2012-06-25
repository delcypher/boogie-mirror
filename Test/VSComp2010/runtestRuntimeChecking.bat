@echo off
setlocal

set BOOGIEDIR=..\..\Binaries
set DAFNY_EXE=%BOOGIEDIR%\Dafny.exe
set BPLEXE=%BOOGIEDIR%\Boogie.exe

for %%f in (Problem1-SumMax Problem2-Invert Problem3-FindZero
            Problem4-Queens Problem5-DoubleEndedQueue) do (
  echo.
  echo -------------------- %%f --------------------
  %DAFNY_EXE% /nologo /errorTrace:0 /runtimeChecking:1 /compile:3 %* %%f.dfy
  if exist %%f.cs. (
    del %%f.cs
  )
  if exist %%f.exe. (
    del %%f.exe
  )
  if exist %%f.dll. (
    del %%f.dll
  )
  if exist %%f.pdb. (
    del %%f.pdb
  )
  if exist %%f.pdb.original. (
    del %%f.pdb.original
  )
)
