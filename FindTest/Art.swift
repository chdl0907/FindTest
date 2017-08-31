//
//  Art.swift
//  FindTest
//
//  Created by ktds 22 on 2017. 8. 31..
//  Copyright © 2017년 OliveNetworks, Inc. All rights reserved.
//

import Foundation
import UIKit

class Art{
    var title:String?
    var artist:String?
    var thumbImageURL:String?
    var thumbImage:UIImage?     // image를 처음불러올때만 url로 받아와서 이 변수에 저장
    
    init(title:String?, artist:String?, thumbImageURL:String?){
        self.title=title
        self.artist=artist
        self.thumbImageURL=thumbImageURL
        self.thumbImage=nil
    }
}
