(*
 * Invalid syntax tests for PA3.
 * The goal is to trigger recovery in classes, features, let bindings,
 * and block expressions while allowing the parser to keep scanning.
 *)

(* no error: gives the parser a valid starting point *)
class A {
  ok : Int <- 0;
};

(* class error: parent name must be a TYPEID, not an OBJECTID *)
class BadParent inherits parent {
  x : Int;
};

(* feature error: missing ':' between attribute name and type *)
class BadFeature {
  broken_attr Int <- 1;
  good_attr : Int <- 2;

  (* feature error: missing return type before method body *)
  broken_method(a : Int) { a + 1 };

  good_method(a : Int) : Int {
    a + good_attr
  };
};

(* let binding error: first binding is malformed, second one should recover *)
class BadLet {
  test() : Int {
    let bad_binding Int <- 1, good : Int <- 2 in good + 1
  };
};

(* block expression errors: malformed expressions followed by semicolons *)
class BadBlock {
  test() : Int {
    {
      0;
      x <- ;
      1 + ;
      3;
    }
  };
};

(* class error: misspelled inherits should be skipped before next class *)
class Misspelled inherts A {
  x : Int;
};

(* no error: proves recovery reached the next valid class *)
class Recovered {
  value : Int <- 42;
};
