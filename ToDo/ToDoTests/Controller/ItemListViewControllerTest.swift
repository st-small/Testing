//
//  ItemListViewControllerTest.swift
//  ToDoTests
//
//  Created by Stanly Shiyanovskiy on 18.06.2022.
//

import XCTest
@testable import ToDo

final class ItemListViewControllerTest: XCTestCase {
    
    var sut: ItemListViewController!
    var addButton: UIBarButtonItem!
    var action: Selector!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ItemListViewController")
        sut = viewController as? ItemListViewController
        sut.loadViewIfNeeded()
        
        addButton = sut.navigationItem.rightBarButtonItem
        action = addButton.action
    }

    func test_TableView_IsNotNil_AfterViewDidLoad() {
        XCTAssertNotNil(sut.tableView)
    }
    
    func test_LoadingView_SetsTableViewDataSource() {
        XCTAssertNotNil(sut.tableView?.dataSource is ItemListDataProvider)
    }
    
    func test_LoadingView_SetsTableViewDelegate() {
        XCTAssertNotNil(sut.tableView?.delegate is ItemListDataProvider)
    }
    
    func test_LoadingView_DataSourceEqualsDelegate() {
        XCTAssertEqual(
            sut.tableView?.dataSource as? ItemListDataProvider,
            sut.tableView?.delegate as? ItemListDataProvider
        )
    }
    
    func test_ItemListViewController_HasAddBarButtonWithSelfAsTarget() {
        let target = sut.navigationItem.rightBarButtonItem?.target
        XCTAssertEqual(target as? UIViewController, sut)
    }
    
    func test_AddItem_PresentsAddItemViewController() {
        XCTAssertNil(sut.presentedViewController)
        
        UIApplication.shared.keyWindow?.rootViewController = sut
        sut.perform(action, on: .main, with: addButton, waitUntilDone: true)
        
        let inputViewController = sut.presentedViewController as! InputViewController
        XCTAssertNotNil(inputViewController.titleTextField)
    }
    
    func test_ItemListVC_SharesItemManagerWithInputVC() {
        
        UIApplication.shared.keyWindow?.rootViewController = sut
        sut.perform(action, on: .main, with: addButton, waitUntilDone: true)
        
        guard let inputViewController = sut.presentedViewController as? InputViewController else {
            XCTFail()
            return
        }
        
        guard let inputItemManager = inputViewController.itemManager else {
            XCTFail()
            return
        }
        
        XCTAssertTrue(sut.itemManager === inputItemManager)
    }
    
    func test_ViewDidLoad_SetsItemManagerToDataProvider() {
        XCTAssertTrue(sut.itemManager === sut.dataProvider.itemManager)
    }
    
    func test_ViewWillAppear_ReloadsTableView() {
        let tableView = MockTableView()
        sut.tableView = tableView
        
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
        
        XCTAssertTrue(tableView.wasReloaded)
    }
    
    func test_ItemSelectedNotification_PushesDetailVC() {
        let mockNavigationController = MockNavigationController(rootViewController: sut)

        UIApplication.shared.keyWindow?.rootViewController = mockNavigationController
        
        sut.loadViewIfNeeded()
        sut.itemManager.add(ToDoItem(title: "foo"))
        sut.itemManager.add(ToDoItem(title: "bar"))

        NotificationCenter.default.post(name: NSNotification.Name("ItemSelectedNotification"), object: self, userInfo: ["index": 1])

        guard let detailViewController = mockNavigationController.lastPushedViewController as? DetailViewController else {
            return XCTFail()
        }

        guard let detailItemManager = detailViewController.itemInfo?.0 else {
            return XCTFail()
        }
        
        guard let index = detailViewController.itemInfo?.1 else { return XCTFail() }

        detailViewController.loadViewIfNeeded()
        
        XCTAssertNotNil(detailViewController.titleLabel)
        XCTAssertTrue(detailItemManager === sut.itemManager)
        XCTAssertEqual(index, 1)
    }
}

extension ItemListViewControllerTest {
    
    class MockTableView: UITableView {
        var wasReloaded = false
        
        override func reloadData() {
            wasReloaded = true
        }
    }
    
    class MockNavigationController : UINavigationController {
        
        var lastPushedViewController: UIViewController?
        
        override func pushViewController(_ viewController: UIViewController, animated: Bool) {
            lastPushedViewController = viewController
            super.pushViewController(viewController, animated: animated) }
    }
}
