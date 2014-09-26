//
//  ViewController.swift
//  Gobang
//
//  Created by llx on 24/06/14.
//  Copyright (c) 2014 llx. All rights reserved.
//  hey, cc. Are you kidding me?????
//
//


import AVFoundation
import UIKit
import Foundation
import iAd

class ViewController: UIViewController,ADBannerViewDelegate {
    var HEIGHT:CGFloat=568
    var WIDTH:CGFloat=320
    var chessboard=Chessboard()
    var currentRow = 7
    var currentColumn = 8
    var count=0
    var turn=2
    var WPImage = UIImageView(image: UIImage(named:"WhitePiece.png"))
    var BPImage = UIImageView(image: UIImage(named:"BlackPiece.png"))
    var RCImage = UIImageView(image: UIImage(named:"RC.png"))
    var gameBackgroundImage = UIImageView(image: UIImage(named:"chessboard3.png"))
    var backgroundImage = UIImageView(image: UIImage(named:"chessboard2.png"))
    var ChessBoardImage = UIImageView(image: UIImage(named:"chessboard1.png"))
    var isWin=0
    var lastRow:[Int]=[]
    var lastColumn:[Int]=[]
    var ccLastRow:[Int]=[]
    var ccLastColumn:[Int]=[]
    var canBack=false
    var simpleMood=false
    var twoPeopleMood=false
    var highLeavelButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
    var twoPeopleLeavelButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
    var mainMenuButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
    var normalLeavelButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
    var oneStepBackButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
    var restartButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
    var soundButton = UIButton.buttonWithType(UIButtonType.System) as? UIButton
    var didLoad=false
    var pan:UIPanGestureRecognizer?
    var tap_Ges:UITapGestureRecognizer?
    var audioPlayer=AVAudioPlayer(contentsOfURL:NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("高山流水",ofType:"mp3")!),error:nil)
    var pieceAudioPlayer=AVAudioPlayer(contentsOfURL:NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("棋子音效",ofType:"mp3")!),error:nil)
    var buttonAudioPlayer=AVAudioPlayer(contentsOfURL:NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("按钮音效",ofType:"mp3")!),error:nil)
    var playSound=true
    var max_x=0
    var min_x=14
    var max_y=0
    var min_y=14
    var backGroundHeight:CGFloat=568
    var adBanner:ADBannerView?
    
    
    
    override func viewDidLoad() {
        HEIGHT=self.view.frame.height
        WIDTH=self.view.frame.width
        adBanner=ADBannerView(frame: CGRect(x: 0,y: HEIGHT-50,width: WIDTH,height: 50))
        backGroundHeight=HEIGHT
        
        self.adBanner!.delegate = self
        self.view.addSubview(adBanner!)
        lastRow=[]
        lastColumn=[]
        ccLastRow=[]
        ccLastColumn=[]
        audioPlayer.numberOfLoops = -1
        audioPlayer.volume=0.1
        audioPlayer.play()
        turn=Int(arc4random()%2+1)
        gameBackgroundImage.frame = CGRect(x:0,y:0,width:WIDTH,height:backGroundHeight)
        backgroundImage.frame = CGRect(x:0,y:0,width:WIDTH,height:backGroundHeight)
        self.view.addSubview(backgroundImage)
        ChessBoardImage.frame = CGRect(x:0,y:(100*HEIGHT/568),width:WIDTH,height:WIDTH)
        super.viewDidLoad()
        twoPeopleLeavelButton!.frame = CGRectMake((9*WIDTH/16), 120*HEIGHT/568, 120, 60)
        twoPeopleLeavelButton!.setBackgroundImage(UIImage(named:"双人对战"), forState: .Normal)
        twoPeopleLeavelButton?.addTarget(self, action: "twoPeople:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(twoPeopleLeavelButton!)
        highLeavelButton!.frame = CGRectMake((9*WIDTH/16), 190*HEIGHT/568, 120, 60)
        highLeavelButton!.setBackgroundImage(UIImage(named:"普通模式"), forState: .Normal)
        highLeavelButton?.addTarget(self, action: "easyGame:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(highLeavelButton!)
        normalLeavelButton!.frame = CGRectMake((9*WIDTH/16), 260*HEIGHT/568, 120, 60)
        normalLeavelButton!.setBackgroundImage(UIImage(named:"高级模式"), forState: .Normal)
        normalLeavelButton?.addTarget(self, action: "highLeavelGame:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(normalLeavelButton!)
        soundButton!.frame = CGRectMake((9*WIDTH/16), 330*HEIGHT/568, 120, 60)
        soundButton!.setBackgroundImage(UIImage(named:"播放声音"), forState: .Normal)
        soundButton?.addTarget(self, action: "sound:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(soundButton!)
    }
    
    func bannerViewDidLoadAd(banner:ADBannerView){
        backGroundHeight=HEIGHT-50
        backgroundImage.frame = CGRect(x:0,y:0,width:WIDTH,height:backGroundHeight)
        gameBackgroundImage.frame = CGRect(x:0,y:0,width:WIDTH,height:backGroundHeight)
    }
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!){
        backGroundHeight=HEIGHT
        backgroundImage.frame = CGRect(x:0,y:0,width:WIDTH,height:backGroundHeight)
        gameBackgroundImage.frame = CGRect(x:0,y:0,width:WIDTH,height:backGroundHeight)
        
    }
    
    func getRange(){
        if currentRow>=max_y-2
        {
            if currentRow<=12
            {
                max_y=currentRow+2
            }
            else
            {
                max_y=14
            }
        }
        if currentRow<=min_y+2
        {
            if currentRow>=2
            {
                min_y=currentRow-2
            }
            else
            {
                min_y=0
            }
        }
        if currentColumn>=max_x-2
        {
            if currentColumn<=12
            {
                max_x=currentColumn+2
            }
            else
            {
                max_x=14
            }
        }
        if currentColumn<=min_x+2
        {
            if currentColumn>=2
            {
                min_x=currentColumn-2
            }
            else
            {
                min_x=0
            }
        }
        
        
    }
    
    func move(sender :UIGestureRecognizer!){
      println("a")
            var startY=100*HEIGHT/568
            var endY=startY+WIDTH
        
//            if (sender.state==UIGestureRecognizerState.Changed || sender.state==UIGestureRecognizerState.Began) && didLoad==true{
//            var p=sender.locationInView(self.view)
//            var x=p.x
//            var y=p.y
//            if x>=0 && x<=WIDTH
//            {
//                currentColumn=Int(x*15/WIDTH)
//            }
//            if y>=startY && y<=CGFloat(backGroundHeight)
//            {
//                currentRow=Int((y-startY)*15/WIDTH)
//            }
//            if currentColumn>14
//            {
//                currentColumn=14
//            }
//            if currentColumn<0
//            {
//                currentColumn=0
//            }
//            if currentRow>14
//            {
//                currentRow=14
//            }
//            if currentRow<0
//            {
//                currentRow=0
//            }
//            if chessboard[currentRow,currentColumn,0]==0
//            {
//                if count==0
//                {
//                    turn=2
//                    drawMovingPieces()
//                    turn=1
//                }
//                else
//                {
//                    drawMovingPieces()
//                }
//            }
//            else
//            {
//                RCImage.removeFromSuperview()
//                WPImage.removeFromSuperview()
//                BPImage.removeFromSuperview()
//                RCImage.frame = CGRect(x:CGFloat(currentColumn*Int(WIDTH)/15+3), y:CGFloat(CGFloat(currentRow*Int(WIDTH)/15)+103*HEIGHT/568), width:18*WIDTH/320, height:18*WIDTH/320)
//                self.view.addSubview(RCImage)
//            }
//            
//        }
                
            if sender.state==UIGestureRecognizerState.Ended && didLoad==true{
                var p=sender.locationInView(self.view)
                var x=p.x
                var y=p.y
                if x>=0 && x<=WIDTH
                {
                    currentColumn=Int(x*15/WIDTH)
                }
                if y>=startY && y<=CGFloat(backGroundHeight)
                {
                    currentRow=Int((y-startY)*15/WIDTH)
                }
                if currentColumn>14
                {
                    currentColumn=14
                }
                if currentColumn<0
                {
                    currentColumn=0
                }
                if currentRow>14
                {
                    currentRow=14
                }
                if currentRow<0
                {
                    currentRow=0
                }
                if chessboard[currentRow,currentColumn,0]==0
                {
                    if count==0
                    {
                        turn=2
                        drawMovingPieces()
                        turn=1
                    }
                    else
                    {
                        drawMovingPieces()
                    }
                }
                else
                {
                    RCImage.removeFromSuperview()
                    WPImage.removeFromSuperview()
                    BPImage.removeFromSuperview()
                    RCImage.frame = CGRect(x:CGFloat(currentColumn*Int(WIDTH)/15+3), y:CGFloat(CGFloat(currentRow*Int(WIDTH)/15)+103*HEIGHT/568), width:18*WIDTH/320, height:18*WIDTH/320)
                    self.view.addSubview(RCImage)
                }
            RCImage.removeFromSuperview()
            WPImage.removeFromSuperview()
            BPImage.removeFromSuperview()
            tap()
            }
        
        
//        {
//            if sender.state==UIGestureRecognizerState.Changed && didLoad==true{
//            var p=sender.locationInView(self.view)
//            var x=p.x
//            var y=p.y
//            if x>=0 && x<=WIDTH
//            {
//                currentColumn=Int(x/16)-5
//            }
//            if y>=100*HEIGHT/568 && y<=CGFloat(backGroundHeight)
//            {
//                currentRow=Int((y-100*HEIGHT/568)/20)-5
//            }
//            if currentColumn>14
//            {
//                currentColumn=14
//            }
//            if currentColumn<0
//            {
//                currentColumn=0
//            }
//            if currentRow>14
//            {
//                currentRow=14
//            }
//            if currentRow<0
//            {
//                currentRow=0
//            }
//            if chessboard[currentRow,currentColumn,0]==0
//            {
//                if count==0
//                {
//                    turn=2
//                    drawMovingPieces()
//                    turn=1
//                }
//                else
//                {
//                    drawMovingPieces()
//                }
//            }
//            else
//            {
//                RCImage.removeFromSuperview()
//                WPImage.removeFromSuperview()
//                BPImage.removeFromSuperview()
//                RCImage.frame = CGRect(x:CGFloat(currentColumn*Int(WIDTH)/15+3), y:CGFloat(CGFloat(currentRow*Int(WIDTH)/15)+103*HEIGHT/568), width:18*WIDTH/320, height:18*WIDTH/320)
//                self.view.addSubview(RCImage)
//            }
//            
//        }
//            else if sender.state==UIGestureRecognizerState.Ended && didLoad==true{
//            RCImage.removeFromSuperview()
//            WPImage.removeFromSuperview()
//            BPImage.removeFromSuperview()
//            tap()
//        }
//        }
    }
    
    func sound(sender:UIButton){
        if playSound==true
        {
            audioPlayer.stop()
            playSound=false
        }
        else
        {
            audioPlayer=AVAudioPlayer(contentsOfURL:NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("高山流水",ofType:"mp3")!),error:nil)
            audioPlayer.volume=0.1
            audioPlayer.numberOfLoops = -1
            audioPlayer.play()
            playSound=true
        }
    }
    
    func tap(){
        if isWin==false && chessboard[currentRow,currentColumn,0]==0 && didLoad==true
        {
            if playSound==true
            {
                
                pieceAudioPlayer.play()
                
            }
            
            if count==0 && twoPeopleMood==false && turn==1
            {getRange()
                chessboard[currentRow,currentColumn,0]=2
                lastRow.append(currentRow)
                lastColumn.append(currentColumn)
                canBack=true
                displayPieces(currentRow,column: currentColumn)
                count++
                
                if chessboard[6,7,0]==2
                {
                    currentRow=6
                    currentColumn=8
                }
                else if chessboard[7,6,0]==2
                {
                    currentRow=6
                    currentColumn=6
                }
                else if chessboard[8,7,0]==2
                {
                    currentRow=8
                    currentColumn=6
                }
                else if chessboard[7,8,0]==2
                {
                    currentRow=8
                    currentColumn=8
                }
                else if chessboard[6,6,0]==2
                {
                    currentRow=8
                    currentColumn=6
                }
                else if chessboard[6,8,0]==2
                {
                    currentRow=8
                    currentColumn=8
                }
                else if chessboard[8,6,0]==2
                {
                    currentRow=8
                    currentColumn=8
                }
                else if chessboard[8,8,0]==2
                {
                    currentRow=8
                    currentColumn=6
                }
                else
                {
                    do{
                        currentRow=Int(arc4random()%3+6)
                        currentColumn=Int(arc4random()%3+6)
                    }while currentRow==7 && currentColumn==7
                    
                }
                chessboard[currentRow,currentColumn,0]=1
                ccLastRow.append(currentRow)
                ccLastColumn.append(currentColumn)
                canBack=true
                displayPieces(currentRow,column:currentColumn)
                turn=1
                RCImage.removeFromSuperview()
                WPImage.removeFromSuperview()
                RCImage.frame = CGRect(x:CGFloat(currentColumn*Int(WIDTH)/15+3), y:CGFloat(CGFloat(currentRow*Int(WIDTH)/15)+103*HEIGHT/568), width:18*WIDTH/320, height:18*WIDTH/320)
                self.view.addSubview(RCImage)
                turn=2
                getRange()
                if playSound==true
                {
                    pieceAudioPlayer.play()
                }
            }
            else
            {
                getRange()
                chessboard[currentRow,currentColumn,0]=turn
                lastRow.append(currentRow)
                lastColumn.append(currentColumn)
                canBack=true
                displayPieces(currentRow,column:currentColumn)
                
                RCImage.frame = CGRect(x:CGFloat(currentColumn*Int(WIDTH)/15+3), y:CGFloat(CGFloat(currentRow*Int(WIDTH)/15)+103*HEIGHT/568), width:18*WIDTH/320, height:18*WIDTH/320)
                self.view.addSubview(RCImage)
                if turn==1
                {
                    turn=2
                }
                else if turn==2
                {
                    turn=1
                }
                detectWin()
                if twoPeopleMood==false && isWin==0
                {
                    callcc()
                    
                }
                if isWin != 0
                {
                    
                    let alert = UIAlertView()
                    if isWin==1
                    {
                        alert.title = "black win"
                    }
                    if isWin==2
                    {
                        alert.title = "white win"
                    }
                    alert.message = "Pls support me by clicking the Ad~~Thx a lot!"
                    alert.addButtonWithTitle("Again")
                    alert.show()
                    
                    
                }
            }
        }
    }
    
    func load(){
        backgroundImage.removeFromSuperview()
        self.view.addSubview(gameBackgroundImage)
        lastRow=[7]
        lastColumn=[7]
        ccLastRow=[7]
        ccLastColumn=[7]
        didLoad=true
        twoPeopleLeavelButton!.hidden=true
        highLeavelButton!.hidden=true
        normalLeavelButton!.hidden=true
        soundButton!.hidden=true
        self.view.addSubview(ChessBoardImage)
        oneStepBackButton!.frame = CGRectMake(140*WIDTH/320, 50, 80, 50)
        oneStepBackButton!.setBackgroundImage(UIImage(named:"悔棋"), forState: .Normal)
        oneStepBackButton?.addTarget(self, action: "back:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(oneStepBackButton!)
        restartButton!.frame = CGRectMake(230*WIDTH/320, 50, 80, 50)
        restartButton!.setBackgroundImage(UIImage(named:"重新开始"), forState: .Normal)
        restartButton?.addTarget(self, action: "restart:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(restartButton!)
        mainMenuButton!.frame = CGRectMake(50*WIDTH/320, 50, 80, 50)
        mainMenuButton!.setBackgroundImage(UIImage(named:"主菜单"), forState: .Normal)
        mainMenuButton?.addTarget(self, action: "mainMenu:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(mainMenuButton!)
        pan=UIPanGestureRecognizer(target: self , action: "move:")
        self.view.addGestureRecognizer(pan!)
        tap_Ges=UITapGestureRecognizer(target: self , action: "move:")
        self.view.addGestureRecognizer(tap_Ges!)
        self.view.userInteractionEnabled=true
        
    }
    
    func mainMenu(sender:UIButton){
        if playSound==true
        {
            buttonAudioPlayer.play()
        }
        turn=Int(arc4random()%2+1)
        max_x=0
        min_x=14
        max_y=0
        min_y=14
        currentRow = 7
        currentColumn = 8
        isWin=0
        count=0
        canBack=false
        simpleMood=false
        twoPeopleMood=false
        didLoad=false
        for i in 0..<15
        {
            for j in 0..<15
            {
                chessboard[i,j,0] = 0
            }
        }
        gameBackgroundImage.removeFromSuperview()
        self.view.addSubview(backgroundImage)
        twoPeopleLeavelButton!.removeFromSuperview()
        highLeavelButton!.removeFromSuperview()
        normalLeavelButton!.removeFromSuperview()
        self.view.addSubview(twoPeopleLeavelButton!)
        self.view.addSubview(highLeavelButton!)
        self.view.addSubview(normalLeavelButton!)
        self.view.addSubview(soundButton!)
        twoPeopleLeavelButton!.hidden=false
        highLeavelButton!.hidden=false
        normalLeavelButton!.hidden=false
        soundButton!.hidden=false
    }
    
    func twoPeople(sender:UIButton){
        if playSound==true
        {
            buttonAudioPlayer.play()
        }
        load()
        twoPeopleMood=true
        currentColumn = 7
        turn=1
        count=1
    }
    
    func easyGame(sender:UIButton){
        if playSound==true
        {
            buttonAudioPlayer.play()
        }
        simpleMood=true
        load()
        if turn==1
        {
            chessboard[7,7,0]=1
            displayPieces(7,column: 7)
        }
        else
        {
            count=1
            
            
        }
        
    }
    
    func back(sender: UIButton) {
        if playSound==true
        {
            buttonAudioPlayer.play()
        }
        if canBack==true && lastRow.count>=2
        {
            isWin=0
            chessboard[lastRow[lastRow.count-1],lastColumn[lastColumn.count-1],0]=0
            lastRow.removeLast()
            lastColumn.removeLast()
            if twoPeopleMood==false
            {
                chessboard[ccLastRow[ccLastRow.count-1],ccLastColumn[ccLastColumn.count-1],0]=0
                ccLastRow.removeLast()
                ccLastColumn.removeLast()
            }
            else
            {
                if turn==1
                {
                    turn=2
                }
                else if turn==2
                {
                    turn=1
                }
            }
            gameBackgroundImage.removeFromSuperview()
            self.view.addSubview(gameBackgroundImage)
            ChessBoardImage.removeFromSuperview()
            self.view.addSubview(ChessBoardImage)
            oneStepBackButton!.removeFromSuperview()
            restartButton!.removeFromSuperview()
            mainMenuButton!.removeFromSuperview()
            self.view.addSubview(mainMenuButton!)
            self.view.addSubview(oneStepBackButton!)
            self.view.addSubview(restartButton!)
            for var i=0;i<15;i++
            {
                for var j=0;j<15;j++
                {
                    displayPieces(i,column: j)
                }
            }
        }
        
        
    }
    
    func restart(sender: UIButton) {
        if playSound==true
        {
            buttonAudioPlayer.play()
        }
        for i in 0..<15
        {
            for j in 0..<15
            {
                chessboard[i,j,0] = 0
            }
        }
        max_x=0
        min_x=14
        max_y=0
        min_y=14
        isWin=0
        count=0
        gameBackgroundImage.removeFromSuperview()
        self.view.addSubview(gameBackgroundImage)
        ChessBoardImage.removeFromSuperview()
        self.view.addSubview(ChessBoardImage)
        currentRow = 7
        currentColumn = 8
        if twoPeopleMood==false
        {
            turn=Int(arc4random()%2+1)
            if turn==1
            {
                count=0
                chessboard[7,7,0]=1
                displayPieces(7,column:7)
            }
            else
            {
                count=1
                
                
            }
            
        }
        else
        {
            count=1
            turn=1
            
        }
        
        
        oneStepBackButton!.removeFromSuperview()
        restartButton!.removeFromSuperview()
        mainMenuButton!.removeFromSuperview()
        
        self.view.addSubview(oneStepBackButton!)
        self.view.addSubview(restartButton!)
        self.view.addSubview(mainMenuButton!)
        
        
    }
    
    func highLeavelGame(sender: UIButton){
        if playSound==true
        {
            buttonAudioPlayer.play()
        }
        load()
        if turn==1
        {
            chessboard[7,7,0]=1
            displayPieces(7,column:7)
        }
        else
        {
            count=1
            
            
        }
        
        
        
    }
    
    func detectWin(){
        var i=0,j=0
        for i=0;i<15;i++
        {
            for j=0;j<15;j++
            {
                if chessboard[i,j,0] != 0
                {
                    let currentTurn=chessboard[i,j,0]
                    if j<=10 && chessboard[i,j,0]==currentTurn && chessboard[i,j+1,0]==currentTurn && chessboard[i,j+2,0]==currentTurn && chessboard[i,j+3,0]==currentTurn && chessboard[i,j+4,0]==currentTurn
                    {
                        isWin=currentTurn
                    }
                        
                    else if i<=10 && chessboard[i,j,0]==currentTurn && chessboard[i+1,j,0]==currentTurn && chessboard[i+2,j,0]==currentTurn && chessboard[i+3,j,0]==currentTurn && chessboard[i+4,j,0]==currentTurn
                    {
                        isWin=currentTurn
                    }
                        
                    else if i<=10 && j<=10 && chessboard[i,j,0]==currentTurn && chessboard[i+1,j+1,0]==currentTurn && chessboard[i+2,j+2,0]==currentTurn && chessboard[i+3,j+3,0]==currentTurn && chessboard[i+4,j+4,0]==currentTurn
                    {
                        isWin=currentTurn
                    }
                        
                    else if i>=4 && j<=10 && chessboard[i,j,0]==currentTurn && chessboard[i-1,j+1,0]==currentTurn && chessboard[i-2,j+2,0]==currentTurn && chessboard[i-3,j+3,0]==currentTurn && chessboard[i-4,j+4,0]==currentTurn
                    {
                        isWin=currentTurn
                    }
                }
            }
        }
    }
    
    func drawMovingPieces() {
        if turn==1{
            RCImage.removeFromSuperview()
            BPImage.frame = CGRect(x:CGFloat(currentColumn*Int(WIDTH)/15+3), y:CGFloat(CGFloat(currentRow*Int(WIDTH)/15)+103*HEIGHT/568), width:18*WIDTH/320, height:18*WIDTH/320)
            self.view.addSubview(BPImage)
        }
        if turn==2{
            RCImage.removeFromSuperview()
            WPImage.frame = CGRect(x:CGFloat(currentColumn*Int(WIDTH)/15+3), y:CGFloat(CGFloat(currentRow*Int(WIDTH)/15)+103*HEIGHT/568), width:18*WIDTH/320, height:18*WIDTH/320)
            self.view.addSubview(WPImage)
        }
        
    }
    
    func displayPieces(row:Int,column:Int){
       
        if chessboard[row,column,0]==1
        {
            var img_1 = UIImage(named:"BlackPiece.png")
            var vImg_1 = UIImageView(image: img_1)
            vImg_1.frame = CGRect(x:CGFloat(column*Int(WIDTH)/15+3), y:CGFloat(CGFloat(row*Int(WIDTH)/15)+103*HEIGHT/568), width:18*WIDTH/320, height:18*WIDTH/320)

            self.view.addSubview(vImg_1)
        }
        else if chessboard[row,column,0]==2
        {
            var img_1 = UIImage(named:"WhitePiece.png")
            var vImg_1 = UIImageView(image: img_1)
            vImg_1.frame = CGRect(x:CGFloat(column*Int(WIDTH)/15+3), y:CGFloat(CGFloat(row*Int(WIDTH)/15)+103*HEIGHT/568), width:18*WIDTH/320, height:18*WIDTH/320)
            self.view.addSubview(vImg_1)

        }
        
    }
    
    func callcc(){
        
        cc()
        getRange()
        chessboard[currentRow,currentColumn,0]=turn
        ccLastRow.append(currentRow)
        ccLastColumn.append(currentColumn)
        displayPieces(currentRow,column:currentColumn)
        turn=1
        RCImage.frame = CGRect(x:CGFloat(currentColumn*Int(WIDTH)/15+3), y:CGFloat(CGFloat(currentRow*Int(WIDTH)/15)+103*HEIGHT/568), width:18*WIDTH/320, height:18*WIDTH/320)
        self.view.addSubview(RCImage)
        turn=2
        
    }
    
    func cc(){
        
        var anotherTurn=2
        
        var currentDegree=0
        
        var highestDegree=0
        
        var haveTwoFree=0
        
        var haveThreeNotFree=0
        
        func runAll(row:Int,column:Int,dir:Int,turn:Int)
        {
            if isWin==0
            {
                if column<=12
                {
                    if column>=2
                    {
                        if row>=2 && row<=12 && chessboard[row+1,column+1,dir]==turn
                        {
                            if chessboard[row-1,column-1,dir]==turn
                            {
                                if chessboard[row+2,column+2,dir]==0
                                {
                                    if chessboard[row-2,column-2,dir] != 0
                                    {
                                        if turn==self.turn
                                        {
                                            currentDegree += 2
                                        }
                                        else
                                        {
                                            currentDegree += 1
                                        }
                                    }
                                    if chessboard[row-2,column-2,dir]==0 && simpleMood==false
                                    {
                                        if turn==self.turn
                                        {
                                            currentDegree += 60
                                            haveTwoFree++
                                        }
                                        else
                                        {
                                            currentDegree += 50
                                        }
                                    }
                                }
                                if chessboard[row+2,column+2,dir]==turn
                                {
                                    if chessboard[row-2,column-2,dir]==0
                                    {
                                        if turn==self.turn
                                        {
                                            currentDegree += 120
                                            haveThreeNotFree++
                                        }
                                        else
                                        {
                                            currentDegree += 100
                                        }
                                    }
                                    if chessboard[row-2,column-2,dir]==turn
                                    {
                                        currentDegree += 30003
                                        if turn==1
                                        {
                                            isWin=1
                                            currentDegree += 30001
                                        }
                                    }
                                }
                            }
                            if chessboard[row-2,column-2,dir]==turn && chessboard[row-1,column-1,dir]==0 && chessboard[row+2,column+2,dir]==turn
                            {
                                if turn==self.turn
                                {
                                    currentDegree += 120
                                    haveThreeNotFree++
                                }
                                else
                                {
                                    currentDegree += 100
                                }
                            }
                            
                        }
                        
                        if chessboard[row,column-1,dir]==turn
                        {
                            if chessboard[row,column+1,dir]==turn
                            {
                                if chessboard[row,column-2,dir]==0
                                {
                                    if chessboard[row,column+2,dir] != 0
                                    {
                                        if turn==self.turn
                                        {
                                            currentDegree += 2
                                        }
                                        else
                                        {
                                            currentDegree += 1
                                        }
                                    }
                                    if chessboard[row,column+2,dir]==0
                                    {
                                        if turn==self.turn
                                        {
                                            currentDegree += 60
                                            haveTwoFree++
                                        }
                                        else
                                        {
                                            currentDegree += 50
                                        }
                                    }
                                }
                                if chessboard[row,column-2,dir]==turn
                                {
                                    if chessboard[row,column+2,dir]==0 && simpleMood==false
                                    {
                                        if turn==self.turn
                                        {
                                            currentDegree += 120
                                            haveThreeNotFree++
                                        }
                                        else
                                        {
                                            currentDegree += 100
                                        }
                                    }
                                    if chessboard[row,column+2,dir]==turn
                                    {
                                        currentDegree += 30006
                                        if turn==1
                                        {
                                            isWin=1
                                            currentDegree += 30001
                                        }
                                    }
                                }
                            }
                            if  chessboard[row,column-2,dir]==turn && chessboard[row,column+2,dir]==turn
                            {
                                if turn==self.turn
                                {
                                    currentDegree += 120
                                    haveThreeNotFree++
                                }
                                else
                                {
                                    currentDegree += 100
                                }
                            }
                            
                        }
                        
                    }
                    if highestDegree==0
                    {
                        if chessboard[row,column+1,dir]==turn && chessboard[row,column+2,dir]==0
                        {
                            if turn==self.turn
                            {
                                currentDegree += 2
                            }
                            else
                            {
                                currentDegree += 1
                            }
                        }
                        if  row<=12 && chessboard[row+1,column+1,dir]==turn && chessboard[row+2,column+2,dir]==0
                        {
                            if turn==self.turn
                            {
                                currentDegree += 2
                            }
                            else
                            {
                                currentDegree += 1
                            }
                        }
                    }
                }
                
                if column<=11
                {
                    if column>=1
                    {
                        if row>=1 && row<=11
                        {
                            if chessboard[row-1,column-1,dir]==0 && chessboard[row+1,column+1,dir]==turn && chessboard[row+2,column+2,dir]==turn && chessboard[row+3,column+3,dir]==turn
                            {
                                if turn==self.turn
                                {
                                    currentDegree += 120
                                    haveThreeNotFree++
                                }
                                else
                                {
                                    currentDegree += 100
                                }
                            }
                            if chessboard[row-1,column-1,dir]==turn
                            {
                                if chessboard[row+1,column+1,dir]==turn
                                {
                                    if chessboard[row+2,column+2,dir]==turn
                                    {
                                        if chessboard[row+3,column+3,dir]==0 && simpleMood==false
                                        {
                                            if turn==self.turn
                                            {
                                                currentDegree += 120
                                                haveThreeNotFree++
                                            }
                                            else
                                            {
                                                currentDegree += 100
                                            }
                                        }
                                        if chessboard[row+3,column+3,dir]==turn
                                        {
                                            currentDegree += 30002
                                            if turn==1
                                            {
                                                isWin=1
                                                currentDegree += 30001
                                            }
                                        }
                                    }
                                    if chessboard[row+2,column+2,dir]==0 && chessboard[row+3,column+3,dir]==turn
                                    {
                                        if turn==self.turn
                                        {
                                            currentDegree += 80
                                            haveThreeNotFree++
                                        }
                                        else
                                        {
                                            currentDegree += 60
                                        }
                                    }
                                }
                                if chessboard[row+1,column+1,dir]==0 && chessboard[row+2,column+2,dir]==turn && chessboard[row+3,column+3,dir]==turn
                                {
                                    if turn==self.turn
                                    {
                                        currentDegree += 80
                                        haveThreeNotFree++
                                    }
                                    else
                                    {
                                        currentDegree += 60
                                    }
                                }
                            }
                            
                        }
                        
                        if chessboard[row,column+1,dir]==turn
                        {
                            if chessboard[row,column+2,dir]==turn
                            {
                                if chessboard[row,column-1,dir]==0
                                {
                                    if chessboard[row,column+3,dir]==0
                                    {
                                        if turn==self.turn
                                        {
                                            currentDegree += 120
                                            haveTwoFree++
                                        }
                                        else
                                        {
                                            currentDegree += 100
                                        }
                                    }
                                    
                                    if chessboard[row,column+3,dir] != 0
                                    {
                                        if turn==self.turn
                                        {
                                            currentDegree += 2
                                        }
                                        else
                                        {
                                            currentDegree += 1
                                        }
                                    }
                                    
                                    if chessboard[row,column+3,dir]==turn && simpleMood==false
                                    {
                                        if turn==self.turn
                                        {
                                            currentDegree += 120
                                            haveThreeNotFree++
                                        }
                                        else
                                        {
                                            currentDegree += 100
                                        }
                                    }
                                }
                                if chessboard[row,column-1,dir]==turn
                                {
                                    if chessboard[row,column+3,dir]==0
                                    {
                                        if turn==self.turn
                                        {
                                            currentDegree += 120
                                            haveThreeNotFree++
                                        }
                                        else
                                        {
                                            currentDegree += 100
                                        }
                                    }
                                    
                                    if chessboard[row,column+3,dir]==turn
                                    {
                                        currentDegree += 30005
                                        if turn==1
                                        {
                                            isWin=1
                                            currentDegree += 30001
                                        }
                                    }
                                }
                            }
                            
                            if chessboard[row,column-1,dir]==turn && chessboard[row,column+2,dir]==0 && chessboard[row,column+3,dir]==turn && simpleMood==false
                            {
                                if turn==self.turn
                                {
                                    currentDegree += 120
                                    haveThreeNotFree++
                                }
                                else
                                {
                                    currentDegree += 100
                                }
                            }
                            
                        }
                        
                        if chessboard[row,column-1,dir]==turn && chessboard[row,column+1,dir]==0 && chessboard[row,column+2,dir]==turn && chessboard[row,column+3,dir]==turn
                        {
                            if turn==self.turn
                            {
                                currentDegree += 120
                                haveThreeNotFree++
                            }
                            else
                            {
                                currentDegree += 100
                            }
                        }
                    }
                    if column>=2
                    {
                        if row>=2 && row<=11 && chessboard[row-2,column-2,dir]==0 && chessboard[row+2,column+2,dir]==turn
                        {
                            if chessboard[row-1,column-1,dir]==0 && chessboard[row+1,column+1,dir]==turn
                            {
                                if chessboard[row+3,column+3,dir] != 0
                                {
                                    if turn==self.turn
                                    {
                                        currentDegree += 2
                                    }
                                    else
                                    {
                                        currentDegree += 1
                                    }
                                }
                                if chessboard[row+3,column+3,dir]==0
                                {
                                    if turn==self.turn
                                    {
                                        currentDegree += 120
                                        haveTwoFree++
                                    }
                                    else
                                    {
                                        currentDegree += 100
                                    }
                                    
                                }
                            }
                            if chessboard[row-1,column-1,dir]==turn
                            {
                                if chessboard[row+1,column+1,dir]==0 && chessboard[row+3,column+3,dir] != 0
                                {
                                    if turn==self.turn
                                    {
                                        currentDegree += 2
                                    }
                                    else
                                    {
                                        currentDegree += 1
                                    }
                                }
                                if chessboard[row+1,column+1,dir]==0 && chessboard[row+3,column+3,dir]==0
                                {
                                    if turn==self.turn
                                    {
                                        currentDegree += 90
                                        haveTwoFree++
                                    }
                                    else
                                    {
                                        currentDegree += 80
                                    }
                                }
                                if chessboard[row+1,column+1,dir]==turn && chessboard[row+3,column+3,dir]==0
                                {
                                    if turn==self.turn
                                    {
                                        currentDegree += 4500
                                    }
                                    else
                                    {
                                        currentDegree += 1000
                                    }
                                }
                            }
                        }
                        
                        if chessboard[row,column-2,dir]==0 && chessboard[row,column-1,dir]==turn && chessboard[row,column+2,dir]==turn
                        {
                            if chessboard[row,column+1,dir]==0 && chessboard[row,column+3,dir]==0 && simpleMood==false
                            {
                                if turn==self.turn
                                {
                                    currentDegree += 90
                                    haveTwoFree++
                                }
                                else
                                {
                                    currentDegree += 80
                                }
                            }
                            if chessboard[row,column+1,dir]==turn && chessboard[row,column+3,dir]==0
                            {
                                if turn==self.turn
                                {
                                    currentDegree += 4500
                                }
                                else
                                {
                                    currentDegree += 1000
                                }
                            }
                            if chessboard[row,column+1,dir]==0 && chessboard[row,column+3,dir] != 0
                            {
                                if turn==self.turn
                                {
                                    currentDegree += 2
                                }
                                else
                                {
                                    currentDegree += 1
                                }
                            }
                        }
                        
                        
                    }
                    if count>=2 && highestDegree==0
                    {
                        if chessboard[row,column+1,dir]==0 && chessboard[row,column+2,dir]==turn && chessboard[row,column+3,dir]==0
                        {
                            if turn==self.turn
                            {
                                currentDegree += 2
                            }
                            else
                            {
                                currentDegree += 1
                            }
                        }
                        if  row<=11 && chessboard[row+1,column+1,dir]==0 && chessboard[row+2,column+2,dir]==turn && chessboard[row+3,column+3,dir]==0
                        {
                            if turn==self.turn
                            {
                                currentDegree += 2
                            }
                            else
                            {
                                currentDegree += 1
                            }
                        }
                    }
                }
                
                if column<=10
                {
                    if column>=1
                    {
                        if row>=1 && row<=10 && chessboard[row-1,column-1,dir]==0 && chessboard[row+3,column+3,dir]==turn
                        {
                            if chessboard[row+1,column+1,dir]==0
                            {
                                if chessboard[row+2,column+2,dir]==turn && chessboard[row+4,column+4,dir] != 0
                                {
                                    if turn==self.turn
                                    {
                                        currentDegree += 2
                                    }
                                    else
                                    {
                                        currentDegree += 1
                                    }
                                }
                                if chessboard[row+2,column+2,dir]==turn && chessboard[row+4,column+4,dir]==0 && simpleMood==false
                                {
                                    if turn==self.turn
                                    {
                                        currentDegree += 90
                                        haveTwoFree++
                                    }
                                    else
                                    {
                                        currentDegree += 80
                                    }
                                }
                            }
                            if chessboard[row+1,column+1,dir]==turn
                            {
                                if chessboard[row+2,column+2,dir]==0 && chessboard[row+4,column+4,dir] != 0
                                {
                                    if turn==self.turn
                                    {
                                        currentDegree += 2
                                    }
                                    else
                                    {
                                        currentDegree += 1
                                    }
                                }
                                if chessboard[row+2,column+2,dir]==0 && chessboard[row+4,column+4,dir]==0 && simpleMood==false
                                {
                                    if turn==self.turn
                                    {
                                        currentDegree += 90
                                        haveTwoFree++
                                    }
                                    else
                                    {
                                        currentDegree += 80
                                    }
                                }
                                if chessboard[row+2,column+2,dir]==turn && chessboard[row+4,column+4,dir]==0
                                {
                                    if turn==self.turn
                                    {
                                        currentDegree += 4500
                                    }
                                    else
                                    {
                                        currentDegree += 1000
                                    }
                                }
                            }
                        }
                        
                        if chessboard[row,column-1,dir]==0 && chessboard[row,column+3,dir]==turn
                        {
                            if chessboard[row,column+2,dir]==turn && chessboard[row,column+1,dir]==0
                            {
                                if chessboard[row,column+4,dir] != 0
                                {
                                    if turn==self.turn
                                    {
                                        currentDegree += 2
                                    }
                                    else
                                    {
                                        currentDegree += 1
                                    }
                                }
                                if chessboard[row,column+4,dir]==0 && simpleMood==false
                                {
                                    if turn==self.turn
                                    {
                                        currentDegree += 90
                                        haveTwoFree++
                                    }
                                    else
                                    {
                                        currentDegree += 80
                                    }
                                }
                            }
                            if chessboard[row,column+1,dir]==turn
                            {
                                if chessboard[row,column+2,dir]==0 && chessboard[row,column+4,dir] != 0
                                {
                                    if turn==self.turn
                                    {
                                        currentDegree += 2
                                    }
                                    else
                                    {
                                        currentDegree += 1
                                    }
                                }
                                if chessboard[row,column+2,dir]==0 && chessboard[row,column+4,dir]==0
                                {
                                    if turn==self.turn
                                    {
                                        haveTwoFree++
                                        currentDegree += 90
                                    }
                                    else
                                    {
                                        currentDegree += 80
                                    }
                                }
                                if chessboard[row,column+2,dir]==turn && chessboard[row,column+4,dir]==0
                                {
                                    if turn==self.turn
                                    {
                                        currentDegree += 4500
                                    }
                                    else
                                    {
                                        currentDegree += 1000
                                    }
                                }
                            }
                        }
                    }
                    if row<=10 && chessboard[row+1,column+1,dir]==turn && chessboard[row+2,column+2,dir]==turn && chessboard[row+3,column+3,dir]==turn && chessboard[row+4,column+4,dir]==turn
                    {
                        currentDegree += 30001
                        if turn==1
                        {
                            isWin=1
                            currentDegree += 30001
                        }
                    }
                    if chessboard[row,column+1,dir]==turn && chessboard[row,column+2,dir]==turn && chessboard[row,column+3,dir]==turn && chessboard[row,column+4,dir]==turn
                    {
                        currentDegree += 30004
                        if turn==1
                        {
                            isWin=1
                            currentDegree += 30001
                        }
                    }
                }
            }
        }
        var i=0,j=0,dir=0,equallyColumn=0,equallyRow=0
        
        highestDegree=0
        
        
        for i=min_y;i<=max_y;i++
        {
            for j=min_x;j<=max_x;j++
            {
                if chessboard[i,j,0]==0 && isWin==0
                {
                    haveTwoFree=0
                    haveThreeNotFree=0
                    currentDegree=0
                    for dir=0;dir<4;dir++
                    {
                        switch dir
                            {
                            
                        case 0:
                            
                            equallyRow=i
                            
                            equallyColumn=j
                            
                            runAll(equallyRow, equallyColumn, dir, turn)
                            
                            runAll(equallyRow, equallyColumn, dir, anotherTurn)
                            
                        case 1:
                            
                            equallyRow=14-i
                            
                            equallyColumn=14-j
                            
                            runAll(equallyRow, equallyColumn, dir, turn)
                            
                            runAll(equallyRow, equallyColumn, dir, anotherTurn)
                            
                        case 2:
                            
                            equallyRow=14-j
                            
                            equallyColumn=i
                            
                            runAll(equallyRow, equallyColumn, dir, turn)
                            
                            runAll(equallyRow, equallyColumn, dir, anotherTurn)
                            
                        case 3:
                            
                            equallyRow=j
                            
                            equallyColumn=14-i
                            
                            runAll(equallyRow, equallyColumn, dir, turn)
                            
                            runAll(equallyRow, equallyColumn, dir, anotherTurn)
                            
                        default: break
                            
                        }
                    }
                    if (haveTwoFree>=1 && haveThreeNotFree>=1) || haveTwoFree>=2 || haveThreeNotFree>=2
                    {
                        currentDegree += 500
                    }
                    
                    if currentDegree>highestDegree
                    {
                        highestDegree=currentDegree
                        currentRow=i
                        currentColumn=j
                    }
                }
            }
        }
        
    }
    
}



