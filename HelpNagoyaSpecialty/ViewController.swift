//
//  ViewController.swift
//  HelpNagoyaSpecialty
//
//  Created by YashimaMasafumi on 2021/04/06.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SKViewに型を変換
        //StoryBoardと関連づける
        let skView = self.view as! SKView
        
        //FPSの表示
        skView.showsFPS = true
        
        //ノード数の表示
        skView.showsNodeCount = true
        
        //シーンの作成
        let scene = GameScene(size: skView.frame.size)
        
        //ビュー上にシーンを表示する
        skView.presentScene(scene)
        
        // Do any additional setup after loading the view.
    }


}

