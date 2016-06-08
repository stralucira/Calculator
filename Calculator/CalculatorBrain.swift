//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Başar Oğuz on 02/06/16.
//  Copyright © 2016 basaroguz. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    typealias PropertyList = AnyObject
    
    private var accumulator = 0.0
    private var descriptionAccumulator = "0"
    private var internalProgram = [AnyObject]()
    
    func setOperand(operand: Double) {
        accumulator = operand
        internalProgram.append(operand)
    }
    
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.Constant(M_PI), //M_PI,
        "e" : Operation.Constant(M_E), //M_E,
        "√" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        "×" : Operation.BinaryOperation({ $0 * $1 }),
        "+" : Operation.BinaryOperation({ $0 + $1 }),
        "-" : Operation.BinaryOperation({ $0 - $1 }),
        "÷" : Operation.BinaryOperation({ $0 / $1 }),
        "=" : Operation.Equals,
        "c" : Operation.Clear,
        "x²": Operation.UnaryOperation({ x in x * x }),
        "log": Operation.UnaryOperation(log2),
        "tan": Operation.UnaryOperation(tan),
        "Rnd": Operation.NullaryOperation(drand48)
    ]
    
    private enum Operation {
        case Constant(Double)
        case NullaryOperation( () -> (Double))
        case UnaryOperation((Double) -> (Double))
        case BinaryOperation((Double, Double) -> Double)
        case Equals
        case Clear
    }
    
    func performOperation(symbol: String) {
        
        internalProgram.append(symbol)
        
        if let operation = operations[symbol]{
        
            switch operation {
                case .Constant(let value):
                    accumulator = value
                case .UnaryOperation(let function):
                    accumulator = function(accumulator)
                case .BinaryOperation(let function):
                    executePendingBinaryOperation()
                    pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
                case .Equals:
                    executePendingBinaryOperation()
                case .Clear:
                    clear()
                case .NullaryOperation(let function):
                    accumulator = function()
            }
        }
    }
    
    private func executePendingBinaryOperation(){
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double,Double) -> Double
        var firstOperand: Double
    }
    
    var program: AnyObject {
        get {
            return internalProgram
        }
        set {
            clear()
            if let arrayOfOps = newValue as? [AnyObject]{
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand)
                    } else if let operation = op as? String {
                        performOperation(operation)
                    }
                }
            }
        }
    }
    
    private func clear() {
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
    }
    
    var isPartialResult: Bool {
        get {
            if (pending == nil){
                return false
            }
            else {return true}
        }
    }
    
    var publicDescription: String {
        get {
            return descriptionAccumulator
        }
    }
    
    var result: Double {
        get{
            return accumulator
        }
    }
}