

import UIKit
import CoreData

class CustomSearchTextField: UITextField {
    
    var dataList : [Cities] = [Cities]()
    var resultsList : [SearchItem] = [SearchItem]()
    var tableView: UITableView?
    
//    weak var myDelegate: CustomSearchTextFieldDelegate?
//    override weak var delegate: UITextFieldDelegate? {
//        didSet {
//            myDelegate = delegate as? CustomSearchTextFieldDelegate
//        }
//    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Connecting the new element to the parent view
    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        tableView?.removeFromSuperview()
    }
    
//    override open func willMove(toSuperview newSuperview: UIView?) {
//        super.willMove(toSuperview: newSuperview)
//        
//        self.addTarget(self, action: #selector(CustomSearchTextField.textFieldDidChange), for: .editingChanged)
//        self.addTarget(self, action: #selector(CustomSearchTextField.textFieldDidBeginEditing), for: .editingDidBegin)
//        self.addTarget(self, action: #selector(CustomSearchTextField.textFieldDidEndEditing), for: .editingDidEnd)
//        self.addTarget(self, action: #selector(CustomSearchTextField.textFieldDidEndEditingOnExit), for: .editingDidEndOnExit)
//    }
    
    
//    override open func layoutSubviews() {
//        super.layoutSubviews()
//        buildSearchTableView()
//    }
    
    
    // MARK: CoreData manipulation methods
    func saveItems() {
        print("Saving items")
        do {
            try context.save()
        } catch {
            print("Error while saving items: \(error)")
        }
    }
    
    func loadItems(withRequest request : NSFetchRequest<Cities>) {
        print("loading items")
        do {
            let tempdata = try context.fetch(request)
            dataList.append(contentsOf: tempdata)
//            dataList = try context.fetch(request)
        } catch {
            print("Error while fetching data: \(error)")
        }
    }
    
    // MARK: Filtering methods
    func filter() {
        dataList.removeAll()
        
        let request: NSFetchRequest<Cities> = Cities.fetchRequest()
        
        var predicate = NSPredicate(format: "cityName CONTAINS[cd] %@", self.text!)
        request.predicate = predicate
        loadItems(withRequest: request)
        
        predicate = NSPredicate(format: "cityName == \"\" AND regionName CONTAINS[cd] %@", self.text!)
        request.predicate = predicate
        loadItems(withRequest: request)

        predicate = NSPredicate(format: "cityName == \"\" AND regionName == \"\" AND countryName CONTAINS[cd] %@", self.text!)
        request.predicate = predicate
        loadItems(withRequest: request)
        
        resultsList = []
        
        for i in 0 ..< dataList.count {
            let item = SearchItem(cityName: dataList[i].cityName!, regionName: dataList[i].regionName!, countryName: dataList[i].countryName!)

            let cityFilterRange = (item.cityName as NSString).range(of: text!, options: .caseInsensitive)
            let regionFilterRange = (item.regionName as NSString).range(of: text!, options: .caseInsensitive)
            let countryFilterRange = (item.countryName as NSString).range(of: text!, options: .caseInsensitive)
                
            if cityFilterRange.location != NSNotFound {
                item.attributedCityName = NSMutableAttributedString(string: item.cityName)
                item.attributedRegionName = NSMutableAttributedString(string: item.regionName)
                item.attributedCountryName = NSMutableAttributedString(string: item.countryName)
                
                item.attributedCityName!.setAttributes([.font: UIFont.boldSystemFont(ofSize: 17)], range: cityFilterRange)
                item.attributedRegionName!.setAttributes([.font: UIFont.boldSystemFont(ofSize: 17)], range: regionFilterRange)
                item.attributedCountryName!.setAttributes([.font: UIFont.boldSystemFont(ofSize: 17)], range: countryFilterRange)
            }
            else if regionFilterRange.location != NSNotFound {
                item.attributedRegionName = NSMutableAttributedString(string: item.regionName)
                item.attributedCountryName = NSMutableAttributedString(string: item.countryName)
                
                item.attributedRegionName!.setAttributes([.font: UIFont.boldSystemFont(ofSize: 17)], range: regionFilterRange)
                item.attributedCountryName!.setAttributes([.font: UIFont.boldSystemFont(ofSize: 17)], range: countryFilterRange)
            }
            else if countryFilterRange.location != NSNotFound{
                item.attributedCountryName = NSMutableAttributedString(string: item.countryName)

                item.attributedCountryName!.setAttributes([.font: UIFont.boldSystemFont(ofSize: 17)], range: countryFilterRange)
            }
            
            resultsList.append(item)
        }
        tableView?.reloadData()
    }
}

//extension CustomSearchTextField {
//
//    // MARK: Early testing methods
//    func addData(){
//        let a = Cities(context: context)
//        a.cityName = "Paris"
//        a.countryName = "France"
//        let b = Cities(context: context)
//        b.cityName = "Porto"
//        b.countryName = "France"
//        let c = Cities(context: context)
//        c.cityName = "Pavard"
//        c.countryName = "France"
//        let d = Cities(context: context)
//        d.cityName = "Parole"
//        d.countryName = "France"
//        let e = Cities(context: context)
//        e.cityName = "Paria"
//        e.countryName = "France"
//
//        saveItems()
//
//        dataList.append(a)
//        dataList.append(b)
//        dataList.append(c)
//        dataList.append(d)
//        dataList.append(e)
//    }
//}
