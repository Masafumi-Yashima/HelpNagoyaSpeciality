//
//  GameScene.swift
//  HelpNagoyaSpecialty
//
//  Created by YashimaMasafumi on 2021/04/12.
//

import SpriteKit

class GameScene: SKScene {
    
    //丼の初期設定
    var bowl:SKSpriteNode?
    
    //タイマー
    var timer:Timer?

    //GameSceneが表示された時に呼び出されるメソッド
    override func didMove(to view: SKView) {
        //下方向に重力を追加
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0)
        
        //背景スプライトの追加
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.size = self.size
        self.addChild(background)
        
        //丼を追加
        let bowlTexture = SKTexture(imageNamed: "bowl")
        let bowl = SKSpriteNode(texture: bowlTexture)
        bowl.position = CGPoint(x: self.size.width/2, y: 100)
        bowl.size = CGSize(width: bowlTexture.size().width/2, height: bowlTexture.size().height/2)
        bowl.physicsBody = SKPhysicsBody(texture: bowlTexture, size: bowl.size)
        bowl.physicsBody?.isDynamic = false
        self.bowl = bowl
        self.addChild(bowl)
        
        self.fallNagoyaSpecialty()
        
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
        
        //スプライトを追加する
        self.addChild(sprite)
    }
    
    //タッチ開始時
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let action = SKAction.move(to: CGPoint(x: location.x, y: 100), duration: 0.2)
            self.bowl?.run(action)
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
    
}
