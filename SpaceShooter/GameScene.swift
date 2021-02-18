//
//  GameScene.swift
//  SpaceShooter
//
//  Created by Sai Balaji on 18/02/21.
//

import SpriteKit
import GameplayKit


var isAlive = true
var score = 0

struct physicsCategory
{
    static let player = 0
    static let projectile = 1
    static let enemy = 2
}


class GameScene: SKScene,SKPhysicsContactDelegate {
    
    var playersprite: SKSpriteNode!
    var projectilesprite: SKSpriteNode!
    var enemysprite: SKSpriteNode!
    
    
    var lbl: SKLabelNode!
    var scorelbl: SKLabelNode!
    
    override func didMove(to view: SKView) {
        
        
        
        
        
        
        
        
        
        physicsWorld.contactDelegate = self
        
        //spawnLabel()
        
        backgroundColor = UIColor.black
        
        
        SpawnScoreLabel()
        spawnPlayer()
        FireEnemy()
        fireProjectile()
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if  let touch = touches.first
        {
            playersprite.position.x = touch.location(in: self).x
        }
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        let firstbody = contact.bodyA
        let secondbody = contact.bodyB
        
        if((firstbody.categoryBitMask==physicsCategory.enemy && secondbody.categoryBitMask == physicsCategory.projectile) || (firstbody.categoryBitMask==physicsCategory.projectile && secondbody.categoryBitMask == physicsCategory.enemy))
        {
            EnemyProjectileCollision(contactA: firstbody.node as! SKSpriteNode, contactB: secondbody.node as! SKSpriteNode)
        }
        
        else if((firstbody.categoryBitMask==physicsCategory.player && secondbody.categoryBitMask == physicsCategory.enemy)
                    || (firstbody.categoryBitMask==physicsCategory.enemy && secondbody.categoryBitMask == physicsCategory.player))
        {
            
            if let a = firstbody.node as? SKSpriteNode,let b = secondbody.node as? SKSpriteNode
            {
                EnemyPlayerCollision(contactA: a , contactB: b)
            }
            
            
            
           
        }
        
    }
    
    
 
}

extension GameScene
{
    func EnemyProjectileCollision(contactA: SKSpriteNode,contactB: SKSpriteNode)
    {
        if(contactA.name == "enemy" && contactB.name == "projectile")
        {
            updateScore(enemy: contactA,enemylocation: contactA.position)
            
        }
        else if (contactA.name == "projectile" && contactB.name == "enemy")
        {
            updateScore(enemy: contactB, enemylocation: contactB.position)
        }
        
        
    }
    
    func EnemyPlayerCollision(contactA: SKSpriteNode,contactB: SKSpriteNode)
    {
        if contactA.name == "enemy" && contactB.name == "player" || contactA.name == "player" && contactB.name == "enemy"
        {
            
            GameOver()
        }
        
    }
    
    func GameOver()
    {
        isAlive = false
        scorelbl.text = "GAME OVER"
        
        playersprite.removeFromParent()
        enemysprite.removeFromParent()
        
        
        
        
    }
    
    func updateScore(enemy: SKSpriteNode,enemylocation: CGPoint)
    {
        score+=1
        scorelbl.text = "SCORE: \(score)"
        SpawnEffect(location: enemylocation)
        enemy.removeFromParent()
    }
    
    func SpawnEffect(location: CGPoint)
    {
        if let sparkeffect = SKEmitterNode(fileNamed: "SparkEffect.sks")
        {
            sparkeffect.position = location
            addChild(sparkeffect)
        }
        
        
    }
    
    
    
    
    func spawnPlayer()
    {
        playersprite = SKSpriteNode(imageNamed: "ship")
        playersprite.position.y =  self.frame.midY - 159
        playersprite.physicsBody = SKPhysicsBody(rectangleOf: playersprite.size)
        playersprite.physicsBody?.affectedByGravity = false
        playersprite.physicsBody?.categoryBitMask = UInt32(physicsCategory.player)
        playersprite.physicsBody?.contactTestBitMask = UInt32(physicsCategory.enemy)
        playersprite.physicsBody?.isDynamic = false
        
        playersprite.name = "player"
        
        addChild(playersprite)
        
        
    }
    
    func spawnLabel()
    {
        lbl = SKLabelNode()
        lbl.text = "SpaceShooter"
        lbl.fontSize = 30
        lbl.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 190)
        lbl.fontColor = UIColor.white
        
        addChild(lbl)
        
    }
    
    func spawnProjectile()
    {
        //let projectilerate = 0.2
        let projectilespeed = 10.0
        
        projectilesprite = SKSpriteNode(imageNamed: "bullet")
        projectilesprite.position = CGPoint(x: playersprite.position.x, y: playersprite.position.y)
        
        projectilesprite.physicsBody = SKPhysicsBody(rectangleOf: projectilesprite.size)
        projectilesprite.physicsBody?.allowsRotation = false
        projectilesprite.physicsBody?.affectedByGravity = false
        projectilesprite.physicsBody?.categoryBitMask = UInt32(physicsCategory.projectile)
        projectilesprite.physicsBody?.contactTestBitMask = UInt32(physicsCategory.enemy)
        projectilesprite.physicsBody?.isDynamic = false
        projectilesprite.zPosition = -1
        
        projectilesprite.name = "projectile"
        
        let moveforward = SKAction.moveTo(y: 1000, duration: projectilespeed)
        let destroy = SKAction.removeFromParent()
        
        projectilesprite.run(SKAction.sequence([moveforward,destroy]))
        
        self.addChild(projectilesprite)
        
        
        
        
    }
    
    func spawnEnemy()
    {
        let enemyspeed = 5.0
        // let enemySpawnRate = 0.5
        
        enemysprite = SKSpriteNode(imageNamed: "meteoroid")
        
        enemysprite.physicsBody = SKPhysicsBody(circleOfRadius: 10)
        enemysprite.physicsBody?.allowsRotation = false
        enemysprite.physicsBody?.affectedByGravity = false
        enemysprite.physicsBody?.categoryBitMask = UInt32(physicsCategory.enemy)
        enemysprite.physicsBody?.contactTestBitMask = UInt32(physicsCategory.projectile)
        enemysprite.physicsBody?.isDynamic = true
        
        enemysprite.name = "enemy"
        
        enemysprite.position.x = self.frame.midX + CGFloat.random(in: -100...100)
        enemysprite.position.y = self.frame.midY + 500
        
        
      
        
        let moveToPlayer = SKAction.moveTo(y: -500, duration: enemyspeed)
        let destroy = SKAction.removeFromParent()
        
        enemysprite.run(SKAction.repeatForever(SKAction.sequence([moveToPlayer,destroy])))
        
        self.addChild(enemysprite)
      
    }
    
    func SpawnScoreLabel()
    {
        scorelbl = SKLabelNode()
        scorelbl.text = "SCORE: \(score)"
        scorelbl.fontSize = 20
        scorelbl.fontColor = UIColor.white
        
        scorelbl.position = CGPoint(x: self.frame.midX, y: self.frame.midY -  200)
        
        addChild(scorelbl)
            
    }
    
    
    
    func fireProjectile() //fire laser
    {
        let timer = SKAction.wait(forDuration: 0.5) // spawn projectile every 0.5 seconds
        
        
        let spawn = SKAction.run {
            if isAlive == true
            {
            self.spawnProjectile()
            }
        }
        
        let sequence = SKAction.sequence([timer,spawn])
        
        self.run(SKAction.repeatForever(sequence))
        
    }
    
    func FireEnemy() //Fire meteoroids towards player
    {
        let timer = SKAction.wait(forDuration: 0.8)
        
        let spawn = SKAction.run {
            self.spawnEnemy()
        }
        
        let  sequence = SKAction.sequence([timer,spawn])
        
        self.run(SKAction.repeatForever(sequence))
        
        
    }
    
    
    
    
    
    func SpawnStars()
    {
        
    }
}
