//
//  CharacterDetailVC.swift
//  MApp
//
//  Created by Emad Habib on 15/09/2023.
//

import UIKit
import RxSwift
import RxDataSources

class CharacterDetailVC: BaseViewController {
    
    @IBOutlet weak var tableView:UITableView!
    var viewModel: CharacterDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: CharacterDetailTableCells.CharacterDetailHeaderTCell.rawValue, bundle: nil), forCellReuseIdentifier: CharacterDetailTableCells.CharacterDetailHeaderTCell.rawValue)
        tableView.register(UINib(nibName: CharacterDetailTableCells.CharacterDetailComicsTCell.rawValue, bundle: nil), forCellReuseIdentifier: CharacterDetailTableCells.CharacterDetailComicsTCell.rawValue)
        tableView.rowHeight = UITableView.automaticDimension
        
        bindData()
        setSectionsData()
    }
    
    private func setSectionsData() {
        let dataSource = RxTableViewSectionedReloadDataSource<CharDetailSectionOfCustomData>(
            configureCell: { [weak self] dataSource, tableView, indexPath, item in
                guard let self = self else {return UITableViewCell()}
                switch item.type {
                case.header:
                    let cell = tableView.dequeueReusableCell(withIdentifier: CharacterDetailTableCells.CharacterDetailHeaderTCell.rawValue, for: indexPath) as! CharacterDetailHeaderTCell
                    cell.configure(image: item.image, name: item.name, desc: item.desc)
                    return cell
                case.comics:
                    let cell = tableView.dequeueReusableCell(withIdentifier: CharacterDetailTableCells.CharacterDetailComicsTCell.rawValue, for: indexPath) as! CharacterDetailComicsTCell
                    cell.config(viewModel: .init(comictsList: item.comics ?? []))
                    return cell
                default:return UITableViewCell()
                }
            })
        
        self.viewModel.sections.asObservable().bind(to: self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
    }
    
    private func bindData(){
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
