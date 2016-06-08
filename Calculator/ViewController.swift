//
//  ViewController.swift
//  Calculator
//
//  Created by Başar Oğuz on 02/06/16.
//  Copyright © 2016 basaroguz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var display: UILabel!
    
    private var displayValue: Double {
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }
    
    private var userIsInTheMiddleOfTyping = false
    
    @IBAction private func touchDigit(sender: UIButton) {
        
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTyping{
            
            let textCurrentlyInDisplay = display.text!
            
            if ( digit == ".") && (textCurrentlyInDisplay.rangeOfString(".") != nil) {
                return
            }
            else {
                display.text = textCurrentlyInDisplay + digit
            }
            
        } else {
            if (digit == "."){
                display.text = "0."
            } else {
                display.text = digit
            }
        }
        
        userIsInTheMiddleOfTyping = true
    
    }
   
    private var brain = CalculatorBrain()
    
    var savedProgram: CalculatorBrain.PropertyList?
    
    @IBAction func save() {
        savedProgram = brain.program
    }
    
    @IBAction func restore() {
        if savedProgram != nil {
            brain.program = savedProgram!
            displayValue = brain.result
        }
    }
    
    @IBAction private func compute(sender: UIButton) {
        
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            //print(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        
        displayValue = brain.result
        
    }//end of compute
    
    


}
