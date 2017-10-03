/*
   CalculatorBrain.swift
   Calculator
 
   This is the Model for Calculator, it takes care of all the logic to perform calculations
   This App is a replication of an inclass demo of
   the Stanford CS193P 2017 class during Lectures 2
 
   Lecture 2: https://youtu.be/-auG-myu02Q
 
   While the code is a replication of the demo in the lecture, the comments are all original
 
   In total this app creates a simple calculator
   Simple swift concepts are used inluding let, optionals, and computed properties
 
   Created 10/2/17 by Soorya Kumar
 */

import Foundation

struct CalculatorBrain {
    /*
     a private variable to help the calculator make incremental calculations to get to a final answer
     this variable shouldn't and can't be accessed by any outside class
     no initializer is needed here because this model is a struct and structs have an initializer that autmatically initializes any uninitialized variables
    lastly accumulator is an optional because initially when CalculatorBrain is created the calculator has not accumulated anything and is not set
    */
    private var accumulator: Double?
    
    /* an enum for the different types of operations we will have in the calculator
     the constant case of the enum can have an associated value that is a double
     the unaryOperation case takes a function (that takes a double as input and returns a double as output) as its associated value
     the binaryOperation case takes a function (that takes two doubles as input and returns a double as output) as its associated value
     */
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> (Double))
        case binaryOperation((Double,Double) -> Double)
        case equals
    }
    
    /* a dictionary that will hold constant characters on the calculator and their associated values for use to use in performOperation
       Closures are used to concisely specify a specific function for a particular unary/binary operation
     */
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "cos" : Operation.unaryOperation(cos),
        "±": Operation.unaryOperation({ -$0 }),
        "×": Operation.binaryOperation({ $0 * $1 }),
        "÷": Operation.binaryOperation({ $0 / $1 }),
        "+": Operation.binaryOperation({ $0 + $1 }),
        "-": Operation.binaryOperation({ $0 - $1 }),
        "=": Operation.equals
    ]
    
    /* this function is called by ViewController.performOperation
       the input to this function is a mathematical symbol
       if the input is one of the operations in the dictionary
       one of 4 things happens depening on the type of operation it is
       
         - if it is a constant, the accumulator is simplay set to the value of the constant
         - if it is a unary operator and the accumulator is not nil, the value currently
           in the accumulator is passed into the unary function
         - if it is a binary operator and the accumulator is not nil, a PendingBinaryOperation struct
           is created to store the first operand and the function that will be perfomed (based on the
           input symbol) while the second operand is attained, the accumulator is reset to nil
         - if it is the equals sign, the pending binary operation is performed (equals is only pressed
           when a binary operation is entered)
     */
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
                
            case .equals:
                performPendingBinaryOperation()
            }
        }

    }
    
    /* this function is executed when the user presses the equals button
       
       if the accumulator and the instance of pendingBinaryOperation are not nil
       the pending binary operations (which has the first operand and function stored) is performed
       with the accumulator (which now holds the second operand for the binary operation)
       
       then pendingBinaryOperation is reset to nil*/
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
        
    }
    
    /* an optional private instantiation of PendingBinaryOperation Struct
       used in performOperation and performPendingBinaryOperation */
    private var pendingBinaryOperation: PendingBinaryOperation?
    
    /* a struct to hold a pending binary operation once an initial operand and
       a mathematical symbol (representing a specific operation) have been input
       this struct holds the first operand and the specific function (as let instance variables)
       to be performed while the second operand is recieved from the user
       then its perfom function is called by peformPendingBinaryOperation to execute
       that specific function with the specified operands*/
    private struct PendingBinaryOperation {
        let function: (Double,Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    /* this function sets the operands to then perform an operation
       this function is marked as mutating because structs are passed by copy on write
       swift needs to know when the variable accumlator is being written */
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }

    /* this is computed property that can be accessed by the controller
       to get the result of a calculation
       
       result is an optional because the result is not set until the
       full operations with it operands are declared */
    var result: Double? {
        get {
            return accumulator
        }
    }
}
