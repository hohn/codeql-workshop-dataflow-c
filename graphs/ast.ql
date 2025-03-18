/**
 * @id cpp/print-ast
 * @kind graph
 */

import cpp
import semmle.code.cpp.PrintAST

class PrintConfig extends PrintAstConfiguration {
  override predicate shouldPrintFunction(Function func) { func.hasName("copy_mem") }
}
