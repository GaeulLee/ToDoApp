//
//  DetailViewController.swift
//  ToDoApp
//
//  Created by 이가을 on 4/2/24.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK: - Property
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var purpleButton: UIButton!
    
    lazy var buttons: [UIButton] = { // 버튼에 쉽게 접근하기 위해 배열로 만들어 놓기
        return [redButton, greenButton, blueButton, purpleButton]
    }()
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var mainTextView: UITextView!
    
    @IBOutlet weak var saveButton: UIButton!
    
    let coreDataManager = CoreDataManager.shared
    
    var toDoData: ToDoData? {
        didSet {
            temporaryNum = toDoData?.color
        }
    }
    
    // ToDo 색깔 구분을 위해 임시적으로 숫자 저장하는 변수
    // (나중에 어떤 색상이 선택되어 있는지 쉽게 파악하기 위해)
    var temporaryNum: Int64? = 1
    
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        configureUI()
    }
    
    // 버튼 둥글게 깍기 위한 정확한 시점
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // 모든 버튼에 설정 변경
        buttons.forEach { button in
            button.clipsToBounds = true
            button.layer.cornerRadius = button.bounds.height / 2
        }
    }

    
    // MARK: - Private
    private func setUI() {
        backView.clipsToBounds = true
        backView.layer.cornerRadius = 10
        
        saveButton.clipsToBounds = true
        saveButton.layer.cornerRadius = 8
        
        clearButtonColors()
    }
    
    private func configureUI() {
        self.title = "New Memo"
        
        mainTextView.text = "텍스트를 여기에 입력하세요."
        mainTextView.textColor = .lightGray
        setupColorTheme(color: .red)
        
        setupColorButton(num: temporaryNum ?? 1)
    }
    
    // 텍스트뷰/저장(업데이트)버튼 색상 설정
    private func setupColorTheme(color: MyColor? = .red) {
        backView.backgroundColor = color?.backgoundColor
        saveButton.backgroundColor = color?.buttonColor
    }
    
    // 버튼 색상 새롭게 셋팅
    private func clearButtonColors() {
        redButton.backgroundColor = MyColor.red.backgoundColor
        redButton.setTitleColor(MyColor.red.buttonColor, for: .normal)
        greenButton.backgroundColor = MyColor.green.backgoundColor
        greenButton.setTitleColor(MyColor.green.buttonColor, for: .normal)
        blueButton.backgroundColor = MyColor.blue.backgoundColor
        blueButton.setTitleColor(MyColor.blue.buttonColor, for: .normal)
        purpleButton.backgroundColor = MyColor.purple.backgoundColor
        purpleButton.setTitleColor(MyColor.purple.buttonColor, for: .normal)
    }
    
    // 눌려진 버튼 색상 설정
    private func setupColorButton(num: Int64) {
        switch num {
        case 1:
            redButton.backgroundColor = MyColor.red.buttonColor
            redButton.setTitleColor(.white, for: .normal)
        case 2:
            greenButton.backgroundColor = MyColor.green.buttonColor
            greenButton.setTitleColor(.white, for: .normal)
        case 3:
            blueButton.backgroundColor = MyColor.blue.buttonColor
            blueButton.setTitleColor(.white, for: .normal)
        case 4:
            purpleButton.backgroundColor = MyColor.purple.buttonColor
            purpleButton.setTitleColor(.white, for: .normal)
        default:
            redButton.backgroundColor = MyColor.red.buttonColor
            redButton.setTitleColor(.white, for: .normal)
        }
    }

    
    
    // MARK: - Action
    @IBAction func colorButtonTapped(_ sender: UIButton) {
        self.temporaryNum = Int64(sender.tag) // 임시숫자 저장
        
        
        let color = MyColor(rawValue: Int64(sender.tag))
        setupColorTheme(color: color)
        
        clearButtonColors()
        setupColorButton(num: Int64(sender.tag))
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        let memoText = mainTextView.text
        coreDataManager.saveToDoData(memo: memoText ?? "", colorInt: temporaryNum ?? 1)
        print("저장완료")
        
        self.navigationController?.popViewController(animated: true) // 다시 전화면으로 돌아가기
    }
    
    // 다른 곳 터치하면 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
