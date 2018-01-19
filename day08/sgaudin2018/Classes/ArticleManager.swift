import CoreData
import Foundation

public class ArticleManager
{
    public var managedObjectContext: NSManagedObjectContext

    public init(completionClosure: @escaping () -> ())
    {
        let bundle = Bundle(for: ArticleManager.self)
        guard let dataModelURL = bundle.url(forResource: "article", withExtension: "momd") else {
            fatalError("Error initializing dataModelURL")
        }
        
        guard let mom = NSManagedObjectModel(contentsOf: dataModelURL) else {
            fatalError("Error initializing mom")
        }
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        
        managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = psc
        
        let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        queue.async {
            guard let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
                fatalError("Error initializing docURL")
            }
            let storeURL = docURL.appendingPathComponent("article.sqlite")
            do
            {
                try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
                DispatchQueue.main.sync(execute: completionClosure)
            } catch {
                fatalError("Error migrating store \(error)")
            }
        }
    }

    public func newArticle() -> Article
    {
        return NSEntityDescription.insertNewObject(forEntityName: "Article", into: self.managedObjectContext) as! Article
    }
    
    public func getAllArticles() -> [Article]
    {
        var allArticles: [Article] = []
        let request = NSFetchRequest<Article>(entityName: "Article")
        do
        {
            allArticles = try managedObjectContext.fetch(request)
        }
        catch { print("Couldnt load all articles") }
        return allArticles
    }
    
    public func getArticles(withLang lang : String) -> [Article]
    {
        let allArticles = self.getAllArticles()
        var allArticlesWithLang: [Article] = []
        for art in allArticles
        {
            if let artLang = art.langue
            {
                if artLang == lang
                {
                    allArticlesWithLang.append(art)
                }
            }
        }
        return allArticlesWithLang
    }
    
    public func getArticles(containString str : String) -> [Article]
    {
        let allArticles = self.getAllArticles()
        var allArticlesWithStr: [Article] = []
        for art in allArticles
        {
            if let artContent = art.content
            {
                if artContent.contains(str)
                {
                    allArticlesWithStr.append(art)
                    continue
                }
            }
            if let artTitle = art.titre
            {
                if artTitle.contains(str)
                {
                    allArticlesWithStr.append(art)
                    continue
                }
            }
        }
        return allArticlesWithStr
    }
    
    public func removeArticle(article : Article)
    {
        self.managedObjectContext.delete(article)
    }
    
    public func save()
    {
        do
        {
            try self.managedObjectContext.save()
        }
        catch { print("Couldn't save context") }
    }
}
