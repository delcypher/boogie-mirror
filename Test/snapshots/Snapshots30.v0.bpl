procedure {:checksum "0"} P();

implementation {:id "P"} {:checksum "1"} P()
{
    call Q();
}

procedure {:checksum "2"} Q();
  requires 0 == 0;
  requires 1 == 1;
  requires 2 != 2;
  requires 3 == 3;
  requires 4 == 4;
