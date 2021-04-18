//
//  GameScene.swift
//  HelpNagoyaSpecialty
//
//  Created by YashimaMasafumi on 2021/04/12.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //丼の初期設定
    var bowl:SKSpriteNode?
    
    //タイマー
    var timer:Timer?
    
    //落下判定用シェイプ
    var lowestShape:SKNode?
    
    //名古屋名物表示用Node
    var itemNode:SKNode!
    
    //衝突判定カテゴリー
    let itemCategory:UInt32 = 1<<0
    
    //スコア用プロパティ
    var score = 0
    var scoreLabel:SKLabelNode?
    var scoreList = [100,200,300,500,800,1000,1500]

    //GameSceneが表示された時に呼び出されるメソッド
    override func didMove(to view: SKView) {
        //BGMの追加
        let SKBGMAction = SKAction.repeatForever(SKAction.playSoundFileNamed("backmusic.mp3", waitForCompletion: true))
        self.run(SKBGMAction)
        
        //下方向に重力を追加
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
        physicsWorld.contactDelegate = self
        
        //背景スプライトの追加
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.size = self.size
        self.addChild(background)
        
        //落下検知用シェイプノードの追加
        let lowestShape = SKShapeNode(rectOf: CGSize(width: self.size.width*3, height: 10))
        lowestShape.position = CGPoint(x: self.size.width/2, y: -10)
        //シェイプに合わせてPhysicsBodyを生成
        lowestShape.physicsBody = SKPhysicsBody(rectangleOf: lowestShape.frame.size)
        lowestShape.physicsBody?.isDynamic = false
        lowestShape.physicsBody?.contactTestBitMask = self.itemCategory
        self.addChild(lowestShape)
        self.lowestShape = lowestShape
        
        //名古屋名物表示用のスプライトを生成
        itemNode = SKNode()
        self.addChild(itemNode)
        
        //丼を追加
        let bowlTexture = SKTexture(imageNamed: "bowl")
        let bowl = SKSpriteNode(texture: bowlTexture)
        bowl.position = CGPoint(x: self.size.width/2, y: 100)
        bowl.size = CGSize(width: bowlTexture.size().width/2, height: bowlTexture.size().height/2)
        bowl.physicsBody = SKPhysicsBody(texture: bowlTexture, size: bowl.size)
        bowl.physicsBody?.isDynamic = false
        self.bowl = bowl
        itemNode.addChild(bowl)
        
        let scoreLabel = SKLabelNode(fontNamed: "Helvetica")
        scoreLabel.position = CGPoint(x: self.size.width*0.92, y: self.size.height*0.78)
        scoreLabel.text = "¥0"
        scoreLabel.fontSize = 32
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.color = UIColor.green
        self.addChild(scoreLabel)
        self.scoreLabel = scoreLabel
        
        //タイマーを生成
        self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(fallNagoyaSpecialty), userInfo: nil, repeats: true)
    }
    
    //名古屋名物を落下させる
    @objc func fallNagoyaSpecialty() {
        let index = Int.random(in: 0...6)
        //imageName="0...6"の画像を読み込む
        let texture = SKTexture(imageNamed: "\(index)")
        //.nearestで画像が荒いが処理が早いを設定　<-> .linear(画像が綺麗だが処理が遅い)
        texture.filteringMode = .nearest
        //Textureを指定してスプライトを作成
        let sprite = SKSpriteNode(texture: texture)
        //スプライトのポジションを設定
        sprite.position = CGPoint(x: self.size.width/2, y: self.size.height)
        sprite.size = CGSize(width: texture.size().width/2, height: texture.size().height/2)
        //テクスチャから物理演算を設定//テクスチャのコンテンツから物理ボディを作成
        sprite.physicsBody = SKPhysicsBody(texture: texture, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = self.itemCategory
        
        //スプライトを追加する
        itemNode.addChild(sprite)
        
        self.score += self.scoreList[index]
        self.scoreLabel?.text = "¥\(self.score)"
    }
    
    //タッチ開始時
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.timer != nil {
            if let touch = touches.first {
                let location = touch.location(in: self)
                let action = SKAction.move(to: CGPoint(x: location.x, y: 100), duration: 0.2)
                self.bowl?.run(action)
            }
        } else {
            restart()
        }
    }
    
    //ドラッグ時
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let action = SKAction.move(to: CGPoint(x: location.x, y: 100), duration: 0.2)
            self.bowl?.run(action)
        }
    }
    
    //衝突時に呼び出されるメソッド
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node == self.lowestShape || contact.bodyB.node == self.lowestShape {
            let sprite = SKSpriteNode(imageNamed: "gameover")
            sprite.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
            itemNode.addChild(sprite)
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    //リスタート
    func restart() {
        self.score = 0
        self.scoreLabel?.text = "¥\(self.score)"
        itemNode.removeAllChildren()
        self.bowl?.position = CGPoint(x: self.size.width/2, y: 100)
        itemNode.addChild(self.bowl!)
        self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(fallNagoyaSpecialty), userInfo: nil, repeats: true)
    }
}
