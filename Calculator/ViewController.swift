/*
   ViewController.swift
   Calculator
 
   This is the View Controller for Calculator, it communicates with the Model and View
   to ensure that UI implementation is seperate from the backend logic
   This App is a replication of an inclass demo of
   the Stanford CS193P 2017 class during Lectures 1 and 2
   
   Lecture 1: https://youtu.be/ilQ-tq772VI
   Lecture 2: https://youtu.be/-auG-myu02Q
 
   While the code is a replication of the demo in the lecture, the comments are all original
   
   In total this app creates a simple calculator
   Simple swift concepts are used inluding let, optionals, and computed properties
 
   Created 10/2/17 by Soorya Kumar
 */

import UIKit

class ViewController: UIViewController {
    
    /* this var is hooked up to a UILabel in the View which displays the calculators results*/
    @IBOutlet weak var display: UILabel!
    
    /* this var keeps track of whether the user is typing a number */
    var userIsInTheMiddleOfTyping = false
    
    /* 
     This function is hooked up to all the digit buttons in the view
     when a user presses a digit this function is run
     
     the title of the button pressed is stored in "digit"
     
     if the user is in the middle of typing a number
     the new value of the new button just pressed is appended 
     to the number currently in the display and display is updated
     with the concatonated number
     
     if the user isn't in the middle of typing a number
     the value of the button just pressed is simply displayed in the display
     */
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }
    
    /* a computer property that allows us to refer to 
       the value in the display, and get and set it, in
       the ViewContoller.performOperation function */
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    /* Calculator Brain is the model class
       we are creating a model to handle our calculations
    */
    private var brain = CalculatorBrain()
    
    /* This function is hooked up to all the non-digit buttons (all the operations)
     in the view when a user presses a digit this function is run
     
     if the user was in the middle of typing a number that number is stored as
     the current operand in the model
     
     the operation button (+,-,×,÷,±,√,=,cos,π) that was pressed is passed to the
     CalculatorBrain.performOperation function (in the model) 
     
     if there is a valid result from the model from the performed operation it is
     stored onto the diplay
    */
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.result {
            displayValue = result
        }
        
    }
}

