(*
 *  CS164 Fall 94
 *
 *  Programming Assignment 1
 *    Implementation of a simple stack machine.
 *
 *  Skeleton file
 *)

class Node {
   item : String;
   next : Node;

   init(i : String, n : Node) : Node {
      {
         item <- i;
         next <- n;
         self;
      }
   };

   getItem() : String { item };
   getNext() : Node { next };
};

class Stack {
   top : Node;

   init() : Stack {
      {
         self;
      }
   };

   push(item : String) : Stack {
      {
         let newNode : Node <- new Node in {
            newNode.init(item, top);
            top <- newNode;
            self;
         };
      }
   };

   pop() : Stack {
      {
         top <- top.getNext();
         self;
      }
   };

   peek() : String { top.getItem() };

   isEmpty() : Bool { isvoid top };

   toString() : String {
      let result : String <- "" in
      let current : Node <- top in {
         while (not isvoid current) loop {
            result <- result.concat(current.getItem()).concat("\n");
            current <- current.getNext();
         } pool;
         result;
      }
   };
};


class Main inherits IO {
   main() : Object {
      let stack : Stack <- new Stack in
      let a2i : A2I <- new A2I in

      let input : String <- "" in {
         while (not input = "x") loop {
            out_string(">");
            input <- in_string();
               
            if input = "d" then
               out_string(stack.toString())
            else if input = "e" then
               if stack.isEmpty() then
                  stack
               else
                  let top : String <- stack.peek() in
                  if top = "+" then {
                     stack.pop();
                     let firstInt : Int <- a2i.a2i(stack.peek()) in {
                        stack.pop();
                        let secondInt : Int <- a2i.a2i(stack.peek()) in {
                           stack.pop();
                           stack.push(a2i.i2a(firstInt + secondInt));
                        };
                     };
                  }
                  else if top = "s" then {
                     stack.pop();
                     let first : String <- stack.peek() in {
                        stack.pop();
                        let second : String <- stack.peek() in {
                           stack.pop();
                           stack.push(first);
                           stack.push(second);
                        };
                     };
                  }
                  else
                     stack
                  fi
                  fi
               fi
            else
               stack.push(input)
            fi
            fi;

         } pool;
      }
   };
};
