//
//  ToDoCell.swift
//  ToDoApp
//
//  Created by 이가을 on 4/2/24.
//

import UIKit

class ToDoCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var toDoTextLabel: UILabel!
    @IBOutlet weak var dateTextLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    // ToDoData를 전달받을 변수 (전달 받으면 ==> 표시하는 메서드 실행) ⭐️
    var toDoData: ToDoData? {
        didSet {
            configureUIwithData()
        }
    }
    
    // (델리게이트 대신에) 실행하고 싶은 클로저 저장
    // 뷰컨트롤러에 있는 클로저 저장할 예정 (셀(자신)을 전달)
    var updateButtonPressed: (ToDoCell) -> Void = { (sender) in }
    /*  ⭐️⭐️⭐️ 메인 뷰컨트롤러의 tableView extension - cellForRowAt 메서드에 아래와 같이 선언되어 있음
     
        cell.updateButtonPressed = { [weak self] (senderCell) in
            self?.performSegue(withIdentifier: "toDetailView", sender: indexPath)
        }
    */
    
    var deleteButtonPressed: (ToDoCell) -> Void = { (sender) in }
    
    
    // 스토리보드의 생성자
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureUI()
    }
    
    // 기본 UI
    private func configureUI() {
        backView.clipsToBounds = true
        backView.layer.cornerRadius = 8
        
        updateButton.clipsToBounds = true
        updateButton.layer.cornerRadius = 10
    }
    
    // 데이터를 가지고 적절한 UI 표시하기
    private func configureUIwithData() {
        toDoTextLabel.text = toDoData?.memoText
        dateTextLabel.text = toDoData?.dateString
        guard let colorNum = toDoData?.color else { return }
        let color = MyColor(rawValue: colorNum) ?? .red
        updateButton.backgroundColor = color.buttonColor
        backView.backgroundColor = color.backgoundColor
        deleteButton.tintColor = color.buttonColor
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func updateButtonTapped(_ sender: UIButton) {
        // 뷰컨트롤로에서 전달받은 클로저를 실행 (내 자신 ToDoCell을 전달하면서) ⭐️
        updateButtonPressed(self)
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        deleteButtonPressed(self)
    }
}
