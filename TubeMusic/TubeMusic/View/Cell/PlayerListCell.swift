//
//  playerListCell.swift
//  TubeMusic
//
//  Created by 古智鹏 on 2018/8/14.
//  Copyright © 2018年 古智鹏. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import SnapKit
import SDWebImage
import Alamofire
import EFAutoScrollLabel
class PlayerListCell: UITableViewCell {
    
    lazy var artwork = UIImageView()
    lazy  var  playlistName = EFAutoScrollLabel()
    lazy  var  playlistCount = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "34")
        
        
         playlistName.font = UIFont.systemFont(ofSize: 15)
         playlistName.labelSpacing = 30
         playlistName.pauseInterval = 1
         playlistName.scrollSpeed = 30
         playlistName.textAlignment = NSTextAlignment.center
         playlistName.fadeLength = 12
         playlistName.scrollDirection = EFAutoScrollDirection.Left
         playlistName.observeApplicationNotifications()
        
      
        self.playlistCount.font = UIFont.systemFont(ofSize: 15)
        self.playlistCount.adjustsFontSizeToFitWidth = true
    
        self.contentView.addSubview(self.artwork)
        self.contentView.addSubview(self.playlistName)
        self.contentView.addSubview(self.playlistCount)

        self.artwork.snp.makeConstraints { make in
            make.left.top.equalTo(self.contentView).offset(8)
            make.bottom.equalTo(self.contentView).offset(-8)
            make.height.equalTo(75)
            make.width.equalTo(self.artwork.snp.height).multipliedBy(120.0/90.0)
        }
        
        self.playlistName.snp.makeConstraints { make in
            make.left.equalTo(self.artwork.snp.right).offset(10)
            make.top.equalTo(self.contentView).offset(30)
            make.height.equalTo(30)
            make.right.equalTo(self.contentView).offset(-60)
        }
        
        self.playlistCount.snp.makeConstraints { make in
            make.left.equalTo(self.playlistName.snp.right).offset(10)
            make.right.equalTo(self.contentView).offset(0)
            make.top.equalTo(self.contentView).offset(30)
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    internal func title(item:Item)
    {
        playlistName.text = item.snippet.title!
        if item.snippet.thumbnails.defaultField.url != nil
        {
            let imageurl=URL(string:item.snippet.thumbnails.defaultField.url)
            artwork.sd_setImage(with: imageurl) { ( thisuiimage, error, sdimagetypr, url ) in
            self.artwork.sd_cancelCurrentAnimationImagesLoad()
            }
        }
        
        let id = item.snippet.resourceId.videoId!
        HttpEngine.shareInstance.getDuration(id: id,
         success: { (duration) in
         self.playlistCount.text=duration
        },
         failure: {(error) in
         print(error)
        })
    }
    
    
    internal func getTitle(song:Song)
    {
        
        playlistName.text = song.songTitle
        
        let imageurl = URL(string: song.songPhotoUrl)
        artwork.sd_setImage(with: imageurl) { ( thisuiimage, error, sdimagetypr, url ) in
            self.artwork.sd_cancelCurrentAnimationImagesLoad()
        }
        
        
        let id = song.songVideoId
        HttpEngine.shareInstance.getDuration(id: id,
          success: { (duration) in
          self.playlistCount.text=duration
        },
          failure: {(error) in
          self.playlistCount.text="..."
           print(error)
        })
    }
    
    
}

