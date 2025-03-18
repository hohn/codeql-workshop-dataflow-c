/**
 * @name Print part of the CFG
 * @description Outputs a subset of the control flow graph
 * @id cpp/print-cfg
 * @kind graph
 */

// The CFG is large.  Just show the part for
//  int copy_mem(unsigned int unused, dyn_input_t *input,
//     unsigned int input_types) 

import cpp

predicate allSuccessors3(int distance, ControlFlowNode n1, ControlFlowNode n2) {
  // n1.getASuccessor*() = n2 and
  distance = 0 and n1 = n2
  or
  distance = 1 and n1 = n2.getAPredecessor()
  or
  distance = 2 and n1 = n2.getAPredecessor().getAPredecessor()
  or
  // allSuccessors3(distance-1, n2.getAPredecessor(), n2)
  // or
  exists(ControlFlowNode mid |
    // // n1 -> mid
    // n1 = mid.getAPredecessor() and
    // // mid -> n2
    // allSuccessors3(distance-1, mid, n2)
    // --- right-to-left recursion
    // n1 -> mid
    distance < 12 and
    allSuccessors3(distance - 1, n1, mid) and
    // mid -> n2
    mid = n2.getAPredecessor()
  )
}

predicate allSuccessors1(ControlFlowNode n1, ControlFlowNode n2) {
  // n1.getASuccessor*() = n2 and
  n1 = n2
  or
  // n2 =  n1.getASuccessor()
  exists(ControlFlowNode mid |
    allSuccessors1(n1, mid) and
    n2 = mid.getASuccessor()
  )
}

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

// query predicate edgesDist(ControlFlowNode n1, ControlFlowNode n2, int distance) {
//     distance = 12 and
//     // allSuccessors3(distance, n1, n2) and
//     n1.(Function).hasName("copy_mem") and
//     n2 = n1.getASuccessor+()
// }

query predicate edges(ControlFlowNode n1, ControlFlowNode n2) { 
    exists(ControlFlowNode t1, ControlFlowNode t2 |
        t1.(Function).hasName("copy_mem") and
        t2 = t1.(Function).getEntryPoint() and
        n1 = t2.getASuccessor*() and
        n1 = n2.getAPredecessor()
        )
 }
