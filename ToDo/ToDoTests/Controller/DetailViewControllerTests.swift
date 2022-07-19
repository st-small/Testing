//
//  DetailViewControllerTests.swift
//  ToDoTests
//
//  Created by Stanly Shiyanovskiy on 16.07.2022.
//

import CoreLocation
import XCTest
@testable import ToDo

final class DetailViewControllerTests: XCTestCase {
    
    var sut: DetailViewController!
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        sut.itemInfo?.0.removeAll()
        super.tearDown()
    }

    func test_HasTitleLabel() {
        let titleLabelIsSubview = sut.titleLabel?.isDescendant(of: sut.view) ?? false
        XCTAssertTrue(titleLabelIsSubview)
    }
    
    func test_HasLocationLabel() {
        let locationLabelIsSubview = sut.locationLabel?.isDescendant(of: sut.view) ?? false
        XCTAssertTrue(locationLabelIsSubview)
    }
    
    func test_HasDateLabel() {
        let dateLabelIsSubview = sut.dateLabel?.isDescendant(of: sut.view) ?? false
        XCTAssertTrue(dateLabelIsSubview)
    }
    
    func test_HasDescriptionLabel() {
        let descriptionLabelIsSubview = sut.descriptionLabel?.isDescendant(of: sut.view) ?? false
        XCTAssertTrue(descriptionLabelIsSubview)
    }

    func test_HasMapView() {
        let mapViewIsSubview = sut.mapView?.isDescendant(of: sut.view) ?? false
        XCTAssertTrue(mapViewIsSubview)
    }
    
    func test_SettingItemInfo_SetsTextsToLabels() {
        let coordinate = CLLocationCoordinate2DMake(51.2277, 6.7735)

        let location = Location(name: "Foo", coordinate: coordinate)
        let item = ToDoItem(title: "Bar",

        itemDescription: "Baz", timestamp: 1456150025, location: location)

        let itemManager = ItemManager()
        itemManager.add(item)

        sut.itemInfo = (itemManager, 0)
        
        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()
        XCTAssertEqual(sut.titleLabel.text, "Bar")
        XCTAssertEqual(sut.dateLabel.text, "02/22/2016")
        XCTAssertEqual(sut.locationLabel.text, "Foo")
        XCTAssertEqual(sut.descriptionLabel.text, "Baz")
        XCTAssertEqual(sut.mapView.centerCoordinate.latitude, coordinate.latitude, accuracy: 0.001)
        XCTAssertEqual(sut.mapView.centerCoordinate.longitude, coordinate.longitude, accuracy: 0.001)
    }
    
    func test_CheckItem_ChecksItemInItemManager() {
        let itemManager = ItemManager()
        itemManager.add(ToDoItem(title: "Foo"))
        
        sut.itemInfo = (itemManager, 0)
        sut.checkItem()
        
        XCTAssertEqual(itemManager.toDoCount, 0)
        XCTAssertEqual(itemManager.doneCount, 1)
    }
}
