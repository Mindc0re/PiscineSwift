//
//  ViewController.swift
//  Day00Ex02
//
//  Created by Simon GAUDIN on 1/8/18.
//  Copyright © 2018 Simon GAUDIN. All rights reserved.
//

import UIKit

enum CalculMode {
    case ADD
    case SUB
    case MULT
    case DIV
    case NONE
}

class ViewController: UIViewController {
    
    @IBOutlet weak var calculLabel: UILabel!
    
    var leftOperand: Int? = nil;
    var rightOperand: Int? = nil;
    var calculMode: CalculMode = CalculMode.NONE;
    var didChooseNewMode = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func safeUnwrap () -> (Int, Bool)
    {
        let step1 = calculLabel.text!;
        let step2 = Int(step1);
        
        if (step2 == nil)
        {
            return (0, true);
        }
        
        return (step2!, false);
    }
    
    @IBAction func printDebug(_ sender: UIButton)
    {
        let keyName = (sender.titleLabel?.text)!;
        
        print("[DEBUG] '\(keyName)' key pressed");
        switch keyName
        {
        case "AC":
            print("Clearing calculation\n");
            break ;
        case "NEG":
            print("Converting the number to its opposite\n");
            break ;
        case "+":
            print("Proceeding to the 'Addition' mode\n");
            break ;
        case "-":
            print("Proceeding to the 'Substraction' mode\n");
            break ;
        case "*":
            print("Proceeding to the 'Multiplication' mode\n");
            break ;
        case "/":
            print("Proceeding to the 'Division' mode\n");
            break ;
        case "/":
            print("Proceeding to the calculation\n");
            break ;
        default:
            print("Adding the digit to the calculation\n");
            break ;
        }
    }
    
    @IBAction func AddDigit(_ sender: UIButton)
    {
        var newText: String;
        
        if (calculLabel?.text == "NaN")
        {
            return ;
        }
        
        if (didChooseNewMode == true && calculMode == CalculMode.NONE)
        {
            calculLabel.text = "";
            leftOperand = nil;
            didChooseNewMode = false;
        }
        else if (didChooseNewMode == true)
        {
            calculLabel.text = "";
            didChooseNewMode = false;
        }
        
        newText = calculLabel.text! + (sender.titleLabel?.text)!;
        calculLabel.text = newText;
    }
    
    @IBAction func clearCalculation(_ sender: UIButton)
    {
        leftOperand = nil;
        rightOperand = nil;
        calculMode = CalculMode.NONE;
        calculLabel.text = "";
    }
    
    @IBAction func changeSign(_ sender: UIButton)
    {
        if (calculLabel?.text != "" && calculLabel?.text != "NaN")
        {
            let firstChar = (calculLabel?.text![(calculLabel?.text?.startIndex)!])!

            if (firstChar == "-")
            {
                calculLabel?.text?.remove(at: (calculLabel?.text?.startIndex)!);
            }
            else
            {
                calculLabel?.text = "-" + (calculLabel?.text!)!;
            }
        }
    }
    
    @IBAction func chooseCalculMode(_ sender: UIButton)
    {
        var unwrappedLabel: (Int, Bool);
        
        if (calculLabel?.text == "NaN" || calculLabel?.text == "")
        {
            return ;
        }
        
        unwrappedLabel = safeUnwrap();
        if (unwrappedLabel.1 == true)
        {
            calculLabel?.text = "NaN";
            return ;
        }

        rightOperand = leftOperand != nil ? unwrappedLabel.0 : rightOperand;
        leftOperand = leftOperand == nil ? unwrappedLabel.0 : leftOperand;
        
        if (leftOperand != nil && rightOperand != nil)
        {
            calculateTotal(sender);
        }
        else
        {
            calculLabel?.text = "";
        }
        switch (sender.titleLabel?.text)!
        {
        case "+":
            calculMode = CalculMode.ADD;
            break ;
        case "-":
            calculMode = CalculMode.SUB;
            break ;
        case "*":
            calculMode = CalculMode.MULT;
            break ;
        case "/":
            calculMode = CalculMode.DIV;
            break ;
        default:
            break ;
        }
        
        didChooseNewMode = true;
    }
    
    @IBAction func calculateTotal(_ sender: UIButton)
    {
        var result: Int?;
        var tupleOverflow: (Int, Bool);
        var unwrappedLabel: (Int, Bool);
        
        if (calculLabel?.text == "" || calculLabel?.text == "NaN")
        {
            return ;
        }
        
        unwrappedLabel = safeUnwrap();
        if (unwrappedLabel.1 == true)
        {
            calculLabel?.text = "NaN";
            return ;
        }
        
        rightOperand = leftOperand != nil ? unwrappedLabel.0 : rightOperand;
        leftOperand = leftOperand == nil ? unwrappedLabel.0 : leftOperand;
        
        if (calculMode == CalculMode.NONE || rightOperand == nil || (leftOperand == nil && rightOperand == nil))
        {
            return ;
        }
        
        switch calculMode
        {
            case CalculMode.ADD:
                tupleOverflow = (leftOperand?.addingReportingOverflow(rightOperand!))!;
                if (tupleOverflow.1 == true)
                {
                    calculLabel?.text = "NaN";
                    break ;
                }
                result = tupleOverflow.0;
                break ;
            
            case CalculMode.SUB:
                tupleOverflow = (leftOperand?.subtractingReportingOverflow(rightOperand!))!;
                if (tupleOverflow.1 == true)
                {
                    calculLabel?.text = "Overflow";
                    break ;
                }
                result = tupleOverflow.0;
                break ;
            
            case CalculMode.MULT:
                tupleOverflow = (leftOperand?.multipliedReportingOverflow(by: rightOperand!))!;
                if (tupleOverflow.1 == true)
                {
                    calculLabel?.text = "NaN";
                    break ;
                }
                result = tupleOverflow.0;
                break ;
            
            case CalculMode.DIV:
                if (leftOperand == 0 || rightOperand == 0)
                {
                    result = nil;
                    break ;
                }
                tupleOverflow = (leftOperand?.dividedReportingOverflow(by: rightOperand!))!;
                if (tupleOverflow.1 == true)
                {
                    calculLabel?.text = "Overflow";
                    break ;
                }
                result = tupleOverflow.0;
                break ;
            
            default:
                break ;
        }
        
        calculLabel?.text = result == nil ? "NaN" : String(result!);
        leftOperand = result;
        rightOperand = nil;
        calculMode = CalculMode.NONE;
        didChooseNewMode = true;
    }
    
}

