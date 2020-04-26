//
//  ViewController.swift
//  calculate
//
//  Created by 柴田将吾 on 2020/04/20.
//  Copyright © 2020 柴田将吾. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var label: UILabel!
    
    var beforeNumber:Double = 0    //+-×÷の前に表示されていた値
    var currentNumber:Double = 0   //画面に表示されている値
    var calculate = false   //true: 今表示されている数字を画面から消す場合
    var operation = 0       //sender.tag(+-×÷)を記憶
    var op = 1 // +-×÷を二回連続で押させない(op = 2の時は+-×÷を押せない)
    var op2 = 1 //+-×÷の途中で%を押させない(op2 = 2の時は%を押せない)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func numbers(_ sender: UIButton) {

        if calculate == true{
            label.text = String(sender.tag - 1)
            currentNumber = Double(label.text!)!
            op = 1
            op2 = 1
            calculate = false
        }else{
            op = 1
            print(label.text)
            label.text = label.text! + String(sender.tag - 1)
            currentNumber = Double(label.text!)!
        }
   
    }
    
    
    @IBAction func button(_ sender: UIButton) {
        
        
        //四則演算ボタン
        if label.text != "" && sender.tag != 11 && sender.tag != 16 && operation == 0{
            beforeNumber = Double(label.text!)!
            if sender.tag == 12{
                label.text = "÷"
            }else if sender.tag == 13{
                label.text = "×"
            }else if sender.tag == 14{
                label.text = "-"
            }else if sender.tag == 15{
                label.text = "+"
            }
            op = 2
            operation = sender.tag
            calculate = true
            
        // 三個以上の数による四則演算
        }else if label.text != "" && sender.tag != 11 && sender.tag != 16 && operation != 0 && op == 1{
            //浮動小数点の誤差対策
            let nsBefore:NSDecimalNumber = NSDecimalNumber(string: "\(beforeNumber)")
            let nsCurrent:NSDecimalNumber = NSDecimalNumber(string: "\(currentNumber)")
            
            if operation == 12{
                let answer = divide(lhs: nsBefore, rhs: nsCurrent)
                label.text = "\(answer)"
                beforeNumber = Double(answer)
                
            }else if operation == 13{
                let answer = multiply(lhs: nsBefore, rhs: nsCurrent)
                label.text = "\(answer)"
                beforeNumber = Double(answer)
                
            }else if operation == 14{
                let answer = minus(lhs: nsBefore, rhs: nsCurrent)
                label.text = "\(answer)"
                beforeNumber = Double(answer)
                
            }else if operation == 15{
                let answer = plus(lhs: nsBefore, rhs: nsCurrent)
                label.text = "\(answer)"
                beforeNumber = Double(answer)
                
            }
            
            if Double(label.text!)!.truncatingRemainder(dividingBy: 1) == 0{
                let integer3 = Int(Double(label.text!)!)
                label.text = String(integer3)
            }
            op = 2
            op2 = 2
            calculate = true
            operation = sender.tag
        
        // =ボタン
        }else if sender.tag == 16 && label.text != "" && label.text != "÷" && label.text != "×" && label.text != "-" && label.text != "+" {
            
            let nsBefore:NSDecimalNumber = NSDecimalNumber(string: "\(beforeNumber)")
            let nsCurrent:NSDecimalNumber = NSDecimalNumber(string: "\(currentNumber)")
            
            if operation == 12{
                
                let answer = divide(lhs: nsBefore, rhs: nsCurrent)
                label.text = "\(answer)"
                
            }else if operation == 13{
                
                let answer = multiply(lhs: nsBefore, rhs: nsCurrent)
                label.text = "\(answer)"
                
            }else if operation == 14{
                
                let answer = minus(lhs: nsBefore, rhs: nsCurrent)
                label.text = "\(answer)"
                
            }else if operation == 15{
                
                let answer = plus(lhs: nsBefore, rhs: nsCurrent)
                label.text = "\(answer)"
                
            }
            if Double(label.text!)!.truncatingRemainder(dividingBy: 1) == 0{
                let integer4 = Int(Double(label.text!)!)
                label.text = String(integer4)
            }
            calculate = true
            operation = 0
        
        // Clearボタン
        }else if sender.tag == 11{
            
            label.text = ""
            beforeNumber = 0
            currentNumber = 0
            calculate = false
            operation = 0
        }
    }
    
    //プラスマイナスボタン
    @IBAction func plusMinus(_ sender: UIButton) {
        
        if label.text != "" && label.text != "÷" && label.text != "×" && label.text != "-" && label.text != "+" {
            
            if label.text != "" && Double(label.text!)!.truncatingRemainder(dividingBy: 1) == 0{
                let integer2 = Int(Double(label.text!)!)
                label.text = String(integer2 * -1)
                currentNumber = Double(label.text!)!
            }else{
                label.text = String(Double(label.text!)! * -1)
                currentNumber = Double(label.text!)!
            }
            calculate = false
        }
    }
    
    //パーセントボタン
    @IBAction func percent(_ sender: UIButton) {
        
        if label.text != "" && label.text != "÷" && label.text != "×" && label.text != "-" && label.text != "+" && op2 == 1{
            let nsValue:NSDecimalNumber = NSDecimalNumber(string: label.text)
            let hundred:NSDecimalNumber = NSDecimalNumber(string: "100")
            let answer = divide(lhs: nsValue, rhs: hundred)
            label.text = "\(answer)"
            currentNumber = Double(answer)
            calculate = true
        }
    }

    //小数点ボタン
    @IBAction func double(_ sender: UIButton) {
        
        if label.text != "" && label.text != "÷" && label.text != "×" && label.text != "-" && label.text != "+"{
            
            if label.text != "" && Double(label.text!)!.truncatingRemainder(dividingBy: 1) == 0{
                let integer = Int(Double(label.text!)!)
                label.text = String(integer) + "."
                calculate = false
            }
        
        }
    
    }
    
    //浮動小数点の誤差対策
    func plus (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> NSDecimalNumber {
        return lhs.adding(rhs)
    }
     
    func minus (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> NSDecimalNumber {
        return lhs.subtracting(rhs)
    }
     
    func multiply (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> NSDecimalNumber {
        return lhs.multiplying(by: rhs)
    }
     
    func divide (lhs: NSDecimalNumber, rhs: NSDecimalNumber) -> NSDecimalNumber {
        return lhs.dividing(by: rhs)
    
    
    }

}

