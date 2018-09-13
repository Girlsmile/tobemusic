//
//  musicListCell.swift
//  TubeMusic
//
//  Created by 古智鹏 on 2018/8/3.
//  Copyright © 2018年 古智鹏. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage
import Alamofire
import RealmSwift

class MusicListCell: UITableViewCell {
    
    lazy var artwork = UIImageView()
    lazy  var  playlistName = UILabel()
    lazy  var  playlistCount = UILabel()
    lazy  var selectionIcon = UIImageView()
    lazy  var  playingIcon = UIImageView()
    lazy var rhythmView = RhythmView(numberOfLines: 3)
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "33")
        rhythmView?.isHidden = true
       
        self.rhythmView?.lineTintColor = UIColor.blue
        self.rhythmView?.lineSpacing = 1.5
        self.rhythmView?.defaultLineHeight = 2

    
        
        self.playlistName.numberOfLines = 2
        self.playlistName.lineBreakMode = .byClipping
        self.playlistName.font = UIFont.systemFont(ofSize: 14)
        
        self.playlistCount.font = UIFont.systemFont(ofSize: 13)
        self.playlistCount.adjustsFontSizeToFitWidth = true
        
        self.selectionIcon.image = #imageLiteral(resourceName: "Unselected")
        self.playingIcon.image = #imageLiteral(resourceName: "Playing")
        self.selectionIcon.image=#imageLiteral(resourceName: "Add")
        self.playingIcon.isHidden = true
        self.selectionIcon.isHidden = false
        
        
        self.contentView.addSubview(self.artwork)
        self.contentView.addSubview(self.playlistName)
        self.contentView.addSubview(self.playlistCount)
        self.contentView.addSubview(self.selectionIcon)
        self.contentView.addSubview(self.playingIcon)
        self.contentView.addSubview(self.rhythmView!)
        
        self.artwork.snp.makeConstraints { make in
            make.left.top.equalTo(self.contentView).offset(8)
            make.bottom.equalTo(self.contentView).offset(-8)
            make.height.equalTo(75)
            make.width.equalTo(self.artwork.snp.height).multipliedBy(120.0/90.0)
        }
        
        self.playlistName.snp.makeConstraints { make in
            make.left.equalTo(self.artwork.snp.right).offset(10)
            make.top.equalTo(self.contentView).offset(15)
//            make.height.equalTo(30)
            make.right.equalTo(self.contentView).offset(-40)
        }
        
        self.playlistCount.snp.makeConstraints { make in
            make.left.equalTo(self.artwork.snp.right).offset(8)
            make.bottom.equalTo(self.contentView).offset(-8)
            make.width.equalTo(50)
            make.height.equalTo(14)
        }
        
        self.selectionIcon.snp.makeConstraints { make in
            make.height.width.equalTo(22)
            make.centerY.equalTo(self.contentView)
            make.right.equalTo(self.contentView).offset(-12)
        }
        
        self.playingIcon.snp.makeConstraints { make in
            make.width.height.equalTo(10)
            make.left.equalTo(self.playlistCount.snp.right).offset(4)
            make.centerY.equalTo(self.playlistCount.snp.centerY)
        }
        
        self.rhythmView?.snp.makeConstraints { (make) in
            make.left.equalTo(self.playlistCount).offset(30)
            make.bottom.equalTo(self.playlistCount).offset(-2)
            make.width.equalTo(12)
            make.height.equalTo(8)

        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        
    internal func getTitle(item:Item) {
        playlistName.text = item.snippet.title!
        if item.snippet.thumbnails.defaultField.url != nil
        {
            let imageurl=URL(string:item.snippet.thumbnails.defaultField.url)
            artwork.sd_setImage(with: imageurl) { ( thisuiimage, error, sdimagetypr, url ) in
                self.artwork.sd_cancelCurrentAnimationImagesLoad()
            }
        }
        
        let id = item.snippet.resourceId.videoId!
        if item.isselsected {
            selectionIcon.image = #imageLiteral(resourceName: "Selected")
        } else {
            selectionIcon.image = #imageLiteral(resourceName: "Add")
        }
        HttpEngine.shareInstance.getDuration(id: id,
            success: { (duration) in
            self.playlistCount.text=duration
        },
            failure: {(error) in
            print(error)
        })
      }
    
    internal func getSearchTitle(item:Item) {
        
        playlistName.text = item.snippet.title!
        if item.snippet.thumbnails.defaultField.url != nil
        {
            let imageurl=URL(string:item.snippet.thumbnails.defaultField.url)
            artwork.sd_setImage(with: imageurl) { ( thisuiimage, error, sdimagetypr, url ) in
                self.artwork.sd_cancelCurrentAnimationImagesLoad()
            }
        }
        
        let id = item.id.videoId
        if item.isselsected {
            selectionIcon.image = #imageLiteral(resourceName: "Selected")
        } else {
            selectionIcon.image = #imageLiteral(resourceName: "Add")
        }
        HttpEngine.shareInstance.getDuration(id: id!,
                                             success: { (duration) in
                                                self.playlistCount.text=duration
        },
                                             failure: {(error) in
                                                print(error)
        })
    }
    
    internal func getTitle(songList:SongList) {
        
        playlistName.text = songList.name
        selectionIcon.isHidden = true
        if songList.songs.count >= 1 {
            let imageurl = URL(string: (songList.songs.first?.songPhotoUrl)!)
            artwork.sd_setImage(with: imageurl) { ( thisuiimage, error, sdimagetypr, url ) in
                self.artwork.sd_cancelCurrentAnimationImagesLoad()
            }
        } else {
            artwork.image = #imageLiteral(resourceName: "TrackArtwork")
        }
        //playlistCount.text = ("\(songList.songs.count)") + "  item"
    }
    
}


