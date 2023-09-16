//
//  CharactersVC.swift
//  MApp
//
//  Created by Emad Habib on 15/09/2023.
//

import UIKit
import RxSwift


class CharactersVC: BaseViewController {
    
    @IBOutlet weak var tableView:UITableView!
    var viewModel: CharactersViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: CharactersTableCells.CharactersTCell.rawValue, bundle: nil), forCellReuseIdentifier: CharactersTableCells.CharactersTCell.rawValue)
        bindData()
    }
    
    private func bindData(){
        
        viewModel.chars.asObservable().bind(to: tableView.rx.items){ [weak self] (tableView, row, element) -> UITableViewCell in
            guard let self = self else {return UITableViewCell()}
            let indexPath = IndexPath(row: row, section: 0)
            let cell = tableView.dequeueReusableCell(withIdentifier: CharactersTableCells.CharactersTCell.rawValue, for: indexPath) as! CharactersTCell
            cell.configureCell(char: element)
            return cell
        }.disposed(by: disposeBag)

        
        tableView.rx
            .willDisplayCell
            .filter({[weak self] (cell, indexPath) in
                guard let `self` = self else { return false }
                return (indexPath.row + 1) == self.tableView.numberOfRows(inSection: indexPath.section) - 3
            })
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .map({ event -> Void in
                return Void()
            })
            .bind(to: viewModel.callNextPage)
            .disposed(by: disposeBag)
        
        self.tableView.rx.modelSelected(CharactersResultModel.self).asObservable()
            .subscribe { [weak self] model in
                guard let self = self , let model = model.element  else {return}
                plog(model.name)
                let vc = CharacterDetailVC()
                let app = UIApplication.shared.delegate as! AppDelegate
                let viewModel = CharacterDetailViewModel(dependencies: app.appDependency!, charModel: model)
                vc.viewModel = viewModel
                self.navigationController?.pushViewController(vc, animated: true)
            }.disposed(by: disposeBag)
        
        viewModel.isLoading
            .distinctUntilChanged()
            .drive(onNext: { [weak self] (isLoading) in
                guard let `self` = self else { return }
                self.hideActivityIndicator()
                if isLoading {
                    self.showActivityIndicator()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.alertDialog.observe(on: MainScheduler.instance)
            .subscribe(onNext: {[weak self] (title, message) in
                guard let `self` = self else {return}
                self.showAlertDialogue(title: title, message: message)
            }).disposed(by: disposeBag)

    }
}
