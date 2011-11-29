// Dafny prelude
// Created 9 February 2008 by Rustan Leino.
// Converted to Boogie 2 on 28 June 2008.
// Edited sequence axioms 20 October 2009 by Alex Summers.
// Copyright (c) 2008-2010, Microsoft.

const $$Language$Dafny: bool;  // To be recognizable to the ModelViewer as
axiom $$Language$Dafny;        // coming from a Dafny program.

// ---------------------------------------------------------------
// -- References -------------------------------------------------
// ---------------------------------------------------------------

type ref;
const null: ref;

// ---------------------------------------------------------------
// -- Axiomatization of sets -------------------------------------
// ---------------------------------------------------------------

type Set T = [T]bool;

function Set#Empty<T>(): Set T;
axiom (forall<T> o: T :: { Set#Empty()[o] } !Set#Empty()[o]);

function Set#Singleton<T>(T): Set T;
axiom (forall<T> r: T :: { Set#Singleton(r) } Set#Singleton(r)[r]);
axiom (forall<T> r: T, o: T :: { Set#Singleton(r)[o] } Set#Singleton(r)[o] <==> r == o);

function Set#UnionOne<T>(Set T, T): Set T;
axiom (forall<T> a: Set T, x: T, o: T :: { Set#UnionOne(a,x)[o] }
  Set#UnionOne(a,x)[o] <==> o == x || a[o]);
axiom (forall<T> a: Set T, x: T :: { Set#UnionOne(a, x) }
  Set#UnionOne(a, x)[x]);
axiom (forall<T> a: Set T, x: T, y: T :: { Set#UnionOne(a, x), a[y] }
  a[y] ==> Set#UnionOne(a, x)[y]);

function Set#Union<T>(Set T, Set T): Set T;
axiom (forall<T> a: Set T, b: Set T, o: T :: { Set#Union(a,b)[o] }
  Set#Union(a,b)[o] <==> a[o] || b[o]);
axiom (forall<T> a, b: Set T, y: T :: { Set#Union(a, b), a[y] }
  a[y] ==> Set#Union(a, b)[y]);
axiom (forall<T> a, b: Set T, y: T :: { Set#Union(a, b), b[y] }
  b[y] ==> Set#Union(a, b)[y]);
axiom (forall<T> a, b: Set T :: { Set#Union(a, b) }
  Set#Disjoint(a, b) ==>
    Set#Difference(Set#Union(a, b), a) == b &&
    Set#Difference(Set#Union(a, b), b) == a);

function Set#Intersection<T>(Set T, Set T): Set T;
axiom (forall<T> a: Set T, b: Set T, o: T :: { Set#Intersection(a,b)[o] }
  Set#Intersection(a,b)[o] <==> a[o] && b[o]);

axiom (forall<T> a, b: Set T :: { Set#Union(Set#Union(a, b), b) }
  Set#Union(Set#Union(a, b), b) == Set#Union(a, b));
axiom (forall<T> a, b: Set T :: { Set#Union(a, Set#Union(a, b)) }
  Set#Union(a, Set#Union(a, b)) == Set#Union(a, b));
axiom (forall<T> a, b: Set T :: { Set#Intersection(Set#Intersection(a, b), b) }
  Set#Intersection(Set#Intersection(a, b), b) == Set#Intersection(a, b));
axiom (forall<T> a, b: Set T :: { Set#Intersection(a, Set#Intersection(a, b)) }
  Set#Intersection(a, Set#Intersection(a, b)) == Set#Intersection(a, b));

function Set#Difference<T>(Set T, Set T): Set T;
axiom (forall<T> a: Set T, b: Set T, o: T :: { Set#Difference(a,b)[o] }
  Set#Difference(a,b)[o] <==> a[o] && !b[o]);
axiom (forall<T> a, b: Set T, y: T :: { Set#Difference(a, b), b[y] }
  b[y] ==> !Set#Difference(a, b)[y] );

function Set#Subset<T>(Set T, Set T): bool;
axiom(forall<T> a: Set T, b: Set T :: { Set#Subset(a,b) }
  Set#Subset(a,b) <==> (forall o: T :: {a[o]} {b[o]} a[o] ==> b[o]));

function Set#Equal<T>(Set T, Set T): bool;
axiom(forall<T> a: Set T, b: Set T :: { Set#Equal(a,b) }
  Set#Equal(a,b) <==> (forall o: T :: {a[o]} {b[o]} a[o] <==> b[o]));
axiom(forall<T> a: Set T, b: Set T :: { Set#Equal(a,b) }  // extensionality axiom for sets
  Set#Equal(a,b) ==> a == b);

function Set#Disjoint<T>(Set T, Set T): bool;
axiom (forall<T> a: Set T, b: Set T :: { Set#Disjoint(a,b) }
  Set#Disjoint(a,b) <==> (forall o: T :: {a[o]} {b[o]} !a[o] || !b[o]));

function Set#Choose<T>(Set T, TickType): T;
axiom (forall<T> a: Set T, tick: TickType :: { Set#Choose(a, tick) }
  a != Set#Empty() ==> a[Set#Choose(a, tick)]);

// ---------------------------------------------------------------
// -- Axiomatization of sequences --------------------------------
// ---------------------------------------------------------------

type Seq T;

function Seq#Length<T>(Seq T): int;
axiom (forall<T> s: Seq T :: { Seq#Length(s) } 0 <= Seq#Length(s));

function Seq#Empty<T>(): Seq T;
axiom (forall<T> :: Seq#Length(Seq#Empty(): Seq T) == 0);
axiom (forall<T> s: Seq T :: { Seq#Length(s) } Seq#Length(s) == 0 ==> s == Seq#Empty());

function Seq#Singleton<T>(T): Seq T;
axiom (forall<T> t: T :: { Seq#Length(Seq#Singleton(t)) } Seq#Length(Seq#Singleton(t)) == 1);

function Seq#Build<T>(s: Seq T, index: int, val: T, newLength: int): Seq T;
axiom (forall<T> s: Seq T, i: int, v: T, len: int :: { Seq#Length(Seq#Build(s,i,v,len)) }
  0 <= len ==> Seq#Length(Seq#Build(s,i,v,len)) == len);

function Seq#Append<T>(Seq T, Seq T): Seq T;
axiom (forall<T> s0: Seq T, s1: Seq T :: { Seq#Length(Seq#Append(s0,s1)) }
  Seq#Length(Seq#Append(s0,s1)) == Seq#Length(s0) + Seq#Length(s1));

function Seq#Index<T>(Seq T, int): T;
axiom (forall<T> t: T :: { Seq#Index(Seq#Singleton(t), 0) } Seq#Index(Seq#Singleton(t), 0) == t);
axiom (forall<T> s0: Seq T, s1: Seq T, n: int :: { Seq#Index(Seq#Append(s0,s1), n) }
  (n < Seq#Length(s0) ==> Seq#Index(Seq#Append(s0,s1), n) == Seq#Index(s0, n)) &&
  (Seq#Length(s0) <= n ==> Seq#Index(Seq#Append(s0,s1), n) == Seq#Index(s1, n - Seq#Length(s0))));
axiom (forall<T> s: Seq T, i: int, v: T, len: int, n: int :: { Seq#Index(Seq#Build(s,i,v,len),n) }
  0 <= n && n < len ==>
    (i == n ==> Seq#Index(Seq#Build(s,i,v,len),n) == v) &&
    (i != n ==> Seq#Index(Seq#Build(s,i,v,len),n) == Seq#Index(s,n)));

function Seq#Update<T>(Seq T, int, T): Seq T;
axiom (forall<T> s: Seq T, i: int, v: T :: { Seq#Length(Seq#Update(s,i,v)) }
  0 <= i && i < Seq#Length(s) ==> Seq#Length(Seq#Update(s,i,v)) == Seq#Length(s));
axiom (forall<T> s: Seq T, i: int, v: T, n: int :: { Seq#Index(Seq#Update(s,i,v),n) }
  0 <= n && n < Seq#Length(s) ==>
    (i == n ==> Seq#Index(Seq#Update(s,i,v),n) == v) &&
    (i != n ==> Seq#Index(Seq#Update(s,i,v),n) == Seq#Index(s,n)));

function Seq#Contains<T>(Seq T, T): bool;
axiom (forall<T> s: Seq T, x: T :: { Seq#Contains(s,x) }
  Seq#Contains(s,x) <==>
    (exists i: int :: { Seq#Index(s,i) } 0 <= i && i < Seq#Length(s) && Seq#Index(s,i) == x));
axiom (forall x: ref ::
  { Seq#Contains(Seq#Empty(), x) }
  !Seq#Contains(Seq#Empty(), x));
axiom (forall<T> s0: Seq T, s1: Seq T, x: T ::
  { Seq#Contains(Seq#Append(s0, s1), x) }
  Seq#Contains(Seq#Append(s0, s1), x) <==>
    Seq#Contains(s0, x) || Seq#Contains(s1, x));
axiom (forall<T> i: int, v: T, len: int, x: T ::
  { Seq#Contains(Seq#Build(Seq#Empty(), i, v, len), x) }
  0 <= i && i < len ==>
  (Seq#Contains(Seq#Build(Seq#Empty(), i, v, len), x) <==> x == v));
axiom (forall<T> s: Seq T, i0: int, v0: T, len0: int, i1: int, v1: T, len1: int, x: T ::
  { Seq#Contains(Seq#Build(Seq#Build(s, i0, v0, len0), i1, v1, len1), x) }
  0 <= i0 && i0 < len0 && len0 <= i1 && i1 < len1 ==>
  (Seq#Contains(Seq#Build(Seq#Build(s, i0, v0, len0), i1, v1, len1), x) <==>
     v1 == x ||
     Seq#Contains(Seq#Build(s, i0, v0, len0), x)));
axiom (forall<T> s: Seq T, n: int, x: T ::
  { Seq#Contains(Seq#Take(s, n), x) }
  Seq#Contains(Seq#Take(s, n), x) <==>
    (exists i: int :: { Seq#Index(s, i) }
      0 <= i && i < n && i < Seq#Length(s) && Seq#Index(s, i) == x));
axiom (forall<T> s: Seq T, n: int, x: T ::
  { Seq#Contains(Seq#Drop(s, n), x) }
  Seq#Contains(Seq#Drop(s, n), x) <==>
    (exists i: int :: { Seq#Index(s, i) }
      0 <= n && n <= i && i < Seq#Length(s) && Seq#Index(s, i) == x));

function Seq#Equal<T>(Seq T, Seq T): bool;
axiom (forall<T> s0: Seq T, s1: Seq T :: { Seq#Equal(s0,s1) }
  Seq#Equal(s0,s1) <==>
    Seq#Length(s0) == Seq#Length(s1) &&
    (forall j: int :: { Seq#Index(s0,j) } { Seq#Index(s1,j) }
        0 <= j && j < Seq#Length(s0) ==> Seq#Index(s0,j) == Seq#Index(s1,j)));
axiom (forall<T> a: Seq T, b: Seq T :: { Seq#Equal(a,b) }  // extensionality axiom for sequences
  Seq#Equal(a,b) ==> a == b);

function Seq#SameUntil<T>(Seq T, Seq T, int): bool;
axiom (forall<T> s0: Seq T, s1: Seq T, n: int :: { Seq#SameUntil(s0,s1,n) }
  Seq#SameUntil(s0,s1,n) <==>
    (forall j: int :: { Seq#Index(s0,j) } { Seq#Index(s1,j) }
        0 <= j && j < n ==> Seq#Index(s0,j) == Seq#Index(s1,j)));

function Seq#Take<T>(s: Seq T, howMany: int): Seq T;
axiom (forall<T> s: Seq T, n: int :: { Seq#Length(Seq#Take(s,n)) }
  0 <= n ==>
    (n <= Seq#Length(s) ==> Seq#Length(Seq#Take(s,n)) == n) &&
    (Seq#Length(s) < n ==> Seq#Length(Seq#Take(s,n)) == Seq#Length(s)));
axiom (forall<T> s: Seq T, n: int, j: int :: { Seq#Index(Seq#Take(s,n), j) } {:weight 25}
  0 <= j && j < n && j < Seq#Length(s) ==>
    Seq#Index(Seq#Take(s,n), j) == Seq#Index(s, j));

function Seq#Drop<T>(s: Seq T, howMany: int): Seq T;
axiom (forall<T> s: Seq T, n: int :: { Seq#Length(Seq#Drop(s,n)) }
  0 <= n ==>
    (n <= Seq#Length(s) ==> Seq#Length(Seq#Drop(s,n)) == Seq#Length(s) - n) &&
    (Seq#Length(s) < n ==> Seq#Length(Seq#Drop(s,n)) == 0));
axiom (forall<T> s: Seq T, n: int, j: int :: { Seq#Index(Seq#Drop(s,n), j) } {:weight 25}
  0 <= n && 0 <= j && j < Seq#Length(s)-n ==>
    Seq#Index(Seq#Drop(s,n), j) == Seq#Index(s, j+n));

axiom (forall<T> s, t: Seq T ::
  { Seq#Append(s, t) }
  Seq#Take(Seq#Append(s, t), Seq#Length(s)) == s &&
  Seq#Drop(Seq#Append(s, t), Seq#Length(s)) == t);

// ---------------------------------------------------------------
// -- Boxing and unboxing ----------------------------------------
// ---------------------------------------------------------------

type BoxType;

function $Box<T>(T): BoxType;
function $Unbox<T>(BoxType): T;

axiom (forall<T> x: T :: { $Box(x) } $Unbox($Box(x)) == x);
axiom (forall b: BoxType :: { $Unbox(b): int } $Box($Unbox(b): int) == b);
axiom (forall b: BoxType :: { $Unbox(b): ref } $Box($Unbox(b): ref) == b);
axiom (forall b: BoxType :: { $Unbox(b): Set BoxType } $Box($Unbox(b): Set BoxType) == b);
axiom (forall b: BoxType :: { $Unbox(b): Seq BoxType } $Box($Unbox(b): Seq BoxType) == b);
axiom (forall b: BoxType :: { $Unbox(b): DatatypeType } $Box($Unbox(b): DatatypeType) == b);
// Note: an axiom like this for bool would not be sound; instead, we do:
function $IsCanonicalBoolBox(BoxType): bool;
axiom $IsCanonicalBoolBox($Box(false)) && $IsCanonicalBoolBox($Box(true));
axiom (forall b: BoxType :: { $Unbox(b): bool } $IsCanonicalBoolBox(b) ==> $Box($Unbox(b): bool) == b);

// ---------------------------------------------------------------
// -- Encoding of type names -------------------------------------
// ---------------------------------------------------------------

type ClassName;
const unique class.int: ClassName;
const unique class.bool: ClassName;
const unique class.set: ClassName;
const unique class.seq: ClassName;

function /*{:never_pattern true}*/ dtype(ref): ClassName;
function /*{:never_pattern true}*/ TypeParams(ref, int): ClassName;

function TypeTuple(a: ClassName, b: ClassName): ClassName;
function TypeTupleCar(ClassName): ClassName;
function TypeTupleCdr(ClassName): ClassName;
// TypeTuple is injective in both arguments:
axiom (forall a: ClassName, b: ClassName :: { TypeTuple(a,b) }
  TypeTupleCar(TypeTuple(a,b)) == a &&
  TypeTupleCdr(TypeTuple(a,b)) == b);

// ---------------------------------------------------------------
// -- Datatypes --------------------------------------------------
// ---------------------------------------------------------------

type DatatypeType;

function /*{:never_pattern true}*/ DtType(DatatypeType): ClassName;  // the analog of dtype for datatype values
function /*{:never_pattern true}*/ DtTypeParams(DatatypeType, int): ClassName;  // the analog of TypeParams

type DtCtorId;
function DatatypeCtorId(DatatypeType): DtCtorId;

function DtRank(DatatypeType): int;

// ---------------------------------------------------------------
// -- Axiom contexts ---------------------------------------------
// ---------------------------------------------------------------

// used to make sure function axioms are not used while their consistency is being checked
const $ModuleContextHeight: int;
const $FunctionContextHeight: int;
const $InMethodContext: bool;

// ---------------------------------------------------------------
// -- Fields -----------------------------------------------------
// ---------------------------------------------------------------

type Field alpha;

function FDim<T>(Field T): int;

function IndexField(int): Field BoxType;
axiom (forall i: int :: { IndexField(i) } FDim(IndexField(i)) == 1);
function IndexField_Inverse<T>(Field T): int;
axiom (forall i: int :: { IndexField(i) } IndexField_Inverse(IndexField(i)) == i);

function MultiIndexField(Field BoxType, int): Field BoxType;
axiom (forall f: Field BoxType, i: int :: { MultiIndexField(f,i) } FDim(MultiIndexField(f,i)) == FDim(f) + 1);
function MultiIndexField_Inverse0<T>(Field T): Field T;
function MultiIndexField_Inverse1<T>(Field T): int;
axiom (forall f: Field BoxType, i: int :: { MultiIndexField(f,i) }
  MultiIndexField_Inverse0(MultiIndexField(f,i)) == f &&
  MultiIndexField_Inverse1(MultiIndexField(f,i)) == i);


function DeclType<T>(Field T): ClassName;

// ---------------------------------------------------------------
// -- Allocatedness ----------------------------------------------
// ---------------------------------------------------------------

const unique alloc: Field bool;
axiom FDim(alloc) == 0;

function DtAlloc(DatatypeType, HeapType): bool;
axiom (forall h, k: HeapType, d: DatatypeType ::
  { $HeapSucc(h, k), DtAlloc(d, h) }
  { $HeapSucc(h, k), DtAlloc(d, k) }
  $HeapSucc(h, k) ==> DtAlloc(d, h) ==> DtAlloc(d, k));

function GenericAlloc(BoxType, HeapType): bool;
axiom (forall h: HeapType, k: HeapType, d: BoxType ::
  { $HeapSucc(h, k), GenericAlloc(d, h) }
  { $HeapSucc(h, k), GenericAlloc(d, k) }
  $HeapSucc(h, k) ==> GenericAlloc(d, h) ==> GenericAlloc(d, k));
// GenericAlloc ==>
axiom (forall b: BoxType, h: HeapType ::
  { GenericAlloc(b, h), h[$Unbox(b): ref, alloc] }
  GenericAlloc(b, h) ==>
  $Unbox(b): ref == null || h[$Unbox(b): ref, alloc]);
axiom (forall b: BoxType, h: HeapType, i: int ::
  { GenericAlloc(b, h), Seq#Index($Unbox(b): Seq BoxType, i) }
  GenericAlloc(b, h) &&
  0 <= i && i < Seq#Length($Unbox(b): Seq BoxType) ==>
  GenericAlloc( Seq#Index($Unbox(b): Seq BoxType, i), h ) );
axiom (forall b: BoxType, h: HeapType, t: BoxType ::
  { GenericAlloc(b, h), ($Unbox(b): Set BoxType)[t] }
  GenericAlloc(b, h) && ($Unbox(b): Set BoxType)[t] ==>
  GenericAlloc(t, h));
axiom (forall b: BoxType, h: HeapType ::
  { GenericAlloc(b, h), DtType($Unbox(b): DatatypeType) }
  GenericAlloc(b, h) ==> DtAlloc($Unbox(b): DatatypeType, h));
// ==> GenericAlloc
axiom (forall b: bool, h: HeapType ::
  $IsGoodHeap(h) ==> GenericAlloc($Box(b), h));
axiom (forall x: int, h: HeapType ::
  $IsGoodHeap(h) ==> GenericAlloc($Box(x), h));
axiom (forall r: ref, h: HeapType ::
  { GenericAlloc($Box(r), h) }
  $IsGoodHeap(h) && (r == null || h[r,alloc]) ==> GenericAlloc($Box(r), h));

// ---------------------------------------------------------------
// -- Arrays -----------------------------------------------------
// ---------------------------------------------------------------

procedure UpdateArrayRange(arr: ref, low: int, high: int, rhs: BoxType);
  modifies $Heap;
  ensures $HeapSucc(old($Heap), $Heap);
  ensures (forall i: int :: { read($Heap, arr, IndexField(i)) } low <= i && i < high ==> read($Heap, arr, IndexField(i)) == rhs);
  ensures (forall<alpha> o: ref, f: Field alpha :: { read($Heap, o, f) } read($Heap, o, f) == read(old($Heap), o, f) ||
            (o == arr && FDim(f) == 1 && low <= IndexField_Inverse(f) && IndexField_Inverse(f) < high));

// ---------------------------------------------------------------
// -- The heap ---------------------------------------------------
// ---------------------------------------------------------------

type HeapType = <alpha>[ref,Field alpha]alpha;
function {:inline true} read<alpha>(H:HeapType, r:ref, f:Field alpha): alpha { H[r, f] }
function {:inline true} update<alpha>(H:HeapType, r:ref, f:Field alpha, v:alpha): HeapType { H[r,f := v] }

function $IsGoodHeap(HeapType): bool;
var $Heap: HeapType where $IsGoodHeap($Heap);

function $HeapSucc(HeapType, HeapType): bool;
axiom (forall<alpha> h: HeapType, r: ref, f: Field alpha, x: alpha :: { update(h, r, f, x) }
  $IsGoodHeap(update(h, r, f, x)) ==>
  $HeapSucc(h, update(h, r, f, x)));
axiom (forall a,b,c: HeapType :: { $HeapSucc(a,b), $HeapSucc(b,c) }
  $HeapSucc(a,b) && $HeapSucc(b,c) ==> $HeapSucc(a,c));
axiom (forall h: HeapType, k: HeapType :: { $HeapSucc(h,k) }
  $HeapSucc(h,k) ==> (forall o: ref :: { read(k, o, alloc) } read(h, o, alloc) ==> read(k, o, alloc)));

// ---------------------------------------------------------------
// -- Non-determinism --------------------------------------------
// ---------------------------------------------------------------

type TickType;
var $Tick: TickType;

// ---------------------------------------------------------------
// -- Arithmetic -------------------------------------------------
// ---------------------------------------------------------------

// the connection between % and /
axiom (forall x:int, y:int :: {x % y} {x / y}  x % y == x - x / y * y);

// remainder is always Euclidean Modulus.
axiom (forall x:int, y:int :: {x % y}  0 < y  ==>  0 <= x % y  &&  x % y < y);
axiom (forall x:int, y:int :: {x % y}  y < 0  ==>  0 <= x % y  &&  x % y < -y);

// the following axiom has some unfortunate matching, but it does state a property about % that
// is sometimes useful
axiom (forall a: int, b: int, d: int :: { a % d, b % d } 2 <= d && a % d == b % d && a < b  ==>  a + d <= b);

// ---------------------------------------------------------------
