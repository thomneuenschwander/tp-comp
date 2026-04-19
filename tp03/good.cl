(*
 * Valid syntax tests for PA3.
 * This file is intended to exercise the parser grammar, not semantic checks.
 *)

class A {
  x : Int;
  y : Int <- 10;
  flag : Bool <- true;
  text : String <- "cool";

  no_args() : Int {
    0
  };

  one_arg(a : Int) : Int {
    a + 1
  };

  many_args(a : Int, b : Int, s : String) : Int {
    {
      x <- a + b * 2;
      x;
    }
  };
};

class B inherits A {
  z : A <- new A;

  dispatches(a : A) : Int {
    {
      a.no_args();
      a@A.one_arg(1);
      self.one_arg(2);
      one_arg(3);
    }
  };

  controls(n : Int) : Int {
    {
      if n < 10 then
        n + 1
      else
        n - 1
      fi;

      while n <= 20 loop
        n <- n + 1
      pool;

      n;
    }
  };

  lets_and_case(obj : A) : Int {
    let a : Int <- 1, b : Int, c : String <- "x" in
      case obj of
        x : A => a + 1;
        y : B => b + 2;
      esac
  };

  operators(a : Int, b : Int) : Bool {
    not isvoid new A = false
  };

  arithmetic(a : Int, b : Int) : Int {
    ~a + (b * 3) / 2 - 1
  };
};

class Main inherits IO {
  main() : Object {
    {
      out_string("parser test\n");
      new B;
    }
  };
};
