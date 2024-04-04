//
//  ViewController.swift
//  ToDoApp
//
//  Created by 이가을 on 4/1/24.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Property
    @IBOutlet weak var tableView: UITableView!
    
    // 모델(저장 데이터를 관리하는 코어데이터)
    let coreDataManager = CoreDataManager.shared
    
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNaviBar()
        setTableView()
    }
    
    // 화면에 다시 진입할때마다 테이블뷰 리로드
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    // MARK: - Private
    private func setNaviBar() {
        self.title = "Memo"
        
        // 네비게이션 우측에 Plus 버튼
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonTapped))
        plusButton.tintColor = .black
        navigationItem.rightBarButtonItem = plusButton
    }
    
    @objc private func plusButtonTapped() {
        performSegue(withIdentifier: "ToDoCell", sender: nil)
    }
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none // 테이블뷰 선 없애기
    }
}


// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreDataManager.getToDoListFromCoreData().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as! ToDoCell
        
        let todoData = coreDataManager.getToDoListFromCoreData()
        cell.toDoData = todoData[indexPath.row]
        
//        // 셀위에 있는 버튼이 눌렸을때 (뷰컨트롤러에서) 어떤 행동을 하기 위해서 클로저 전달
//        cell.updateButtonPressed = { [weak self] (senderCell) in
//            // 뷰컨트롤러에 있는 세그웨이의 실행
//            self?.performSegue(withIdentifier: "ToDoCell", sender: indexPath)
//        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
}


// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
