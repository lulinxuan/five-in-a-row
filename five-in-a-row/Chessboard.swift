//
//  Chessboard.swift
//  Gobang
//
//  Created by llx on 24/06/14.
//  Copyright (c) 2014年 llx. All rights reserved.
//

import Foundation

class Chessboard{
    var point:[Int]
    init(){
        point=Array(count:225,repeatedValue:0)
        }
    subscript(row:Int,column:Int,dir:Int)->Int{
        get{
            
            switch dir
            {
        case 0: return point[row*15+column]
        case 1: return point[224-row*15-column]
        case 2: return point[15*column-row+14]
        case 3: return point[row-15*column+210]
        default: return 0
            }
        }
        set{
           point[row*15+column]=newValue
                   }
    }
  
}