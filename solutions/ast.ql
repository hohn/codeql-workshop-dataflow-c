/**
 * @id cpp/print-ast
 * @kind graph
 */

import cpp
import semmle.code.cpp.PrintAST

//  extend `PrintASTConfiguration` and override `shouldPrintFunction` to hold for only the functions
class PrintConfig extends PrintAstConfiguration {
  override predicate shouldPrintFunction(Function func) { func.hasName("write_val_to_mem") }
}
