// RUN: %boogie -noinfer -typeEncoding:m -useArrayTheory "%s" > "%t"
// RUN: %diff "%s.expect" "%t"
type X;
const nil: X;
var {:layer 1} l: X;
var {:layer 1} x: int;

function {:builtin "MapConst"} MapConstBool(bool) : [X]bool;
function {:inline} {:linear "tid"} TidCollector(x: X) : [X]bool
{
  MapConstBool(false)[x := true]
}

procedure Allocate() returns ({:linear "tid"} xls: X);
ensures {:layer 1} xls != nil;

procedure {:yields} {:layer 1} main()
{
    var {:linear "tid"} tid: X;
    var val: int;

    yield;
    while (*) 
    {
        call tid := Allocate();
        havoc val;
        async call foo(tid, val);
	yield;
    }
    yield;
}
procedure {:yields} {:layer 0,1} Lock(tid: X);
ensures {:atomic} |{A: assume l == nil; l := tid; return true; }|;

procedure {:yields} {:layer 0,1} Unlock();
ensures {:atomic} |{A: l := nil; return true; }|;

procedure {:yields} {:layer 0,1} Set(val: int);
ensures {:atomic} |{A: x := val; return true; }|;

procedure {:yields} {:layer 1} foo({:linear_in "tid"} tid': X, val: int)
requires {:layer 1} tid' != nil;
{
    var {:linear "tid"} tid: X;
    tid := tid';

    yield;
    call Lock(tid);    
    call tid := Yield(tid);
    call Set(val);
    call tid := Yield(tid);
    assert {:layer 1} x == val;
    call tid := Yield(tid);
    call Unlock();
    yield;
}

procedure {:yields} {:layer 1} Yield({:linear_in "tid"} tid': X) returns ({:linear "tid"} tid: X)
requires {:layer 1} tid' != nil;
ensures {:layer 1} tid == tid';
ensures {:layer 1} old(l) == tid ==> old(l) == l && old(x) == x;
{
    tid := tid';
    yield;
    assert {:layer 1} tid != nil;
    assert {:layer 1} (old(l) == tid ==> old(l) == l && old(x) == x);
}