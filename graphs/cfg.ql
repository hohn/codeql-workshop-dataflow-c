/**
 * @name Print part of the CFG
 * @description Outputs a subset of the control flow graph
 * @id cpp/print-cfg
 * @kind graph
 */

// The CFG is large.  Just show the part for
//  int copy_mem(unsigned int unused, dyn_input_t *input,
//      unsigned int input_types) 

import cpp

query predicate nodes(ControlFlowNode n1, string key, string value) {
  exists(ControlFlowNode startFrom |
    (edges(n1, _) or edges(_, n1)) and
    (
      if startFrom.getASuccessor*() = n1
      then (
        key = "color" and value = "red"
        or
        key = "line" and value = n1.getLocation().getStartLine().toString()
      ) else (
        key = "color" and value = "black"
        or
        key = "line" and value = n1.getLocation().getStartLine().toString()
      )
    )
  )
}

query predicate edges(ControlFlowNode n1, ControlFlowNode n2) { 
    exists(ControlFlowNode t1, ControlFlowNode t2 |
        t1.(Function).hasName("copy_mem") and
        t2 = t1.(Function).getEntryPoint() and
        n1 = t2.getASuccessor*() and
        n1 = n2.getAPredecessor()
        )
 }
