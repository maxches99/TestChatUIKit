//
//  IncomingMessageCell.swift
//  TestChatUIKit
//
//  Created by Максим Чесников on 29.06.2022.
//

import UIKit

@IBDesignable
class IncomingMessageCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var bubbleView: UIView!
    
    @IBOutlet weak var avatarView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        avatarView.layer.cornerRadius = 18
        bubbleView.layer.cornerRadius = 16
        
        avatarView.contentMode = .scaleAspectFill
        selectionStyle = .none
    }
    
    func configure(messageModel: MessageModel) {
        messageLabel.text = messageModel.text
        guard let data = messageModel.avatarData else { return }
        avatarView.image = UIImage(data: data)
    }
    
    override func prepareForReuse() {
        avatarView.image = nil
        messageLabel.text = ""
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.bubbleView.backgroundColor = highlighted ? .gray : UIColor(named: "IncomingBackgroundColor")!
        }
    }
}
