//
//  GameScene.swift
//  Locks
//
//  Created by Sergio Díaz on 5/5/17.
//  Copyright (c) 2017 Sergio Díaz. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameScene: SKScene {
    
    var Circle = SKSpriteNode(imageNamed: "Circle")
    var Person = SKSpriteNode(imageNamed: "Person")
    var Dot = SKSpriteNode(imageNamed: "Dot")
    
    var Path = UIBezierPath()
    
    var gameStarted = Bool()
    
    var movingClockwise = Bool()
    var intersected = false
    
    var LevelLabel = UILabel()
    
    var currentLevel = Int()
    var currentScore = Int()
    var highLevel = Int()
    
    override func didMoveToView(view: SKView) {
        //Cargar la view del juego y establecer datos por defecto si estos no existen
        loadView()
        let Defaults = NSUserDefaults.standardUserDefaults()
        if Defaults.integerForKey("HighLevel") != 0 {
            highLevel = Defaults.integerForKey("HighLevel") as Int!
            currentLevel = highLevel
            currentScore = currentLevel
            LevelLabel.text = "\(currentScore)"
        }else{
            Defaults.setInteger(1, forKey: "HighLevel")
        }
    }
    
    func loadView(){
        movingClockwise = true
        
        backgroundColor = SKColor.blackColor()
        
        //Creamos el circulo
        Circle.size = CGSize(width: 300, height: 300)
        Circle.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        self.addChild(Circle)
        
        //Creamos la persona
        Person = SKSpriteNode(imageNamed: "Person")
        Person.size = CGSize(width: 40, height: 7)
        Person.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + 120)
        Person.zRotation = 3.14 / 2
        Person.zPosition = 2.0
        self.addChild(Person)
        
        //Añadimos el punto
        addDot()
        
        //Creamos el textview del nivel
        LevelLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        LevelLabel.center = (self.view?.center)!
        LevelLabel.text = "How you feel?"
        LevelLabel.sizeToFit()
        LevelLabel.textColor = SKColor.darkGrayColor()
        LevelLabel.textAlignment = NSTextAlignment.Center
        self.view?.addSubview(LevelLabel)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //Comprobamos el estado del juego por cada touch, para mover o parar la aguja.
        if gameStarted == false {
            moveClockWise()
            movingClockwise = true
            gameStarted = true
        }
        else if gameStarted == true  {
            if movingClockwise == true {
                moveCounterClockWise()
                movingClockwise = false
            }
            else if movingClockwise == false {
                moveClockWise()
                movingClockwise = true
            }
            DotTouched()
        }
    }
    
    func addDot(){
        //Creamos el punto
        Dot.size = CGSize(width: 30, height: 30)
        Dot.zPosition = 1.0
        
        let dx = Person.position.x - self.frame.width / 2
        let dy = Person.position.y - self.frame.height / 2
        
        let rad = atan2(dy, dx)
        
        if movingClockwise == true{
            let tempAngle = CGFloat.random(min: rad - 1.0, max: rad - 2.5)
            let Path2 = UIBezierPath(arcCenter: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2), radius: 120, startAngle: tempAngle, endAngle: tempAngle + CGFloat(M_PI * 4), clockwise: true)
            Dot.position = Path2.currentPoint
        }
        else if movingClockwise == false{
            let tempAngle = CGFloat.random(min: rad + 1.0, max: rad + 2.5)
            let Path2 = UIBezierPath(arcCenter: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2), radius: 120, startAngle: tempAngle, endAngle: tempAngle + CGFloat(M_PI * 4), clockwise: true)
            Dot.position = Path2.currentPoint
        }
        self.addChild(Dot)
    }
    
    
    func moveClockWise(){
        //Creamos el movimiento que va a tener la aguja (Person) y que va a seguir el camino (Path) por dentro del circulo (hacia una direccion)
        let dx = Person.position.x - self.frame.width / 2
        let dy = Person.position.y - self.frame.height / 2
        
        let rad = atan2(dy, dx)
        
        Path = UIBezierPath(arcCenter: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2), radius: 120, startAngle: rad, endAngle: rad + CGFloat(M_PI * 4), clockwise: true)
        let follow = SKAction.followPath(Path.CGPath, asOffset: false, orientToPath: true, speed: 200)
        Person.runAction(SKAction.repeatActionForever(follow).reversedAction())
        
    }
    
    func moveCounterClockWise(){
        //Creamos el movimiento que va a tener la aguja (Person) y que va a seguir el camino (Path) por dentro del circulo (hacia una direccion contraria a la anterior)
        let dx = Person.position.x - self.frame.width / 2
        let dy = Person.position.y - self.frame.height / 2
        
        let rad = atan2(dy, dx)
        
        Path = UIBezierPath(arcCenter: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2), radius: 120, startAngle: rad, endAngle: rad + CGFloat(M_PI * 4), clockwise: true)
        let follow = SKAction.followPath(Path.CGPath, asOffset: false, orientToPath: true, speed: 200)
        Person.runAction(SKAction.repeatActionForever(follow))
    }
    
    func DotTouched(){
        //Comprobar si el punto ha sido tocado por la persona en el momento de tocar la pantalla y si la persona sigue dentro del punto
        if intersected == true {
            Dot.removeFromParent()
            addDot()
            intersected = false
            
            currentScore--
            LevelLabel.text = "\(currentScore)"
            if currentScore <= 0 {
                nextLevel()
            }
        }
        else if intersected == false {
            die()
        }
    }
    
    func nextLevel(){
        //Augmentar el nivel y cambiar el texto que marca el nivel
        currentLevel++
        currentScore = currentLevel
        LevelLabel.text = "\(currentScore)"
        won()
        if currentLevel > highLevel {
            highLevel = currentLevel
            let Defaults = NSUserDefaults.standardUserDefaults()
            Defaults.setInteger(highLevel, forKey: "HighLevel")
        }
    }
    
    func die(){
        //Resetear la view y mostrar destello rojo
        self.removeAllChildren()
        let action1 = SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1.0, duration: 0.2)
        let action2 = SKAction.colorizeWithColor(UIColor.whiteColor(), colorBlendFactor: 1.0, duration: 0.2)
        self.scene?.runAction(SKAction.sequence([action1,action2]))
        intersected = false
        gameStarted = false
        LevelLabel.removeFromSuperview()
        currentScore = currentLevel
        self.loadView()
    }
    
    func won(){
        //Resetear la view, augmentar nivel y mostrar destello verde
        self.removeAllChildren()
        let action1 = SKAction.colorizeWithColor(UIColor.greenColor(), colorBlendFactor: 1.0, duration: 0.2)
        let action2 = SKAction.colorizeWithColor(UIColor.whiteColor(), colorBlendFactor: 1.0, duration: 0.2)
        self.scene?.runAction(SKAction.sequence([action1,action2]))
        intersected = false
        gameStarted = false
        LevelLabel.removeFromSuperview()
        self.loadView()
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        //Comprobar si la persona esta intersectando el punto en cada momento
        if Person.intersectsNode(Dot) {
            intersected = true
        }
        else{
            if intersected == true {
                if Person.intersectsNode(Dot) == false {
                    die()
                }
            }
        }
    }
}
