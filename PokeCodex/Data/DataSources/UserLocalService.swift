import Foundation
import CouchbaseLiteSwift
import RxSwift

protocol UserLocalServiceProtocol {
    func saveUser(_ user: User) -> Observable<Bool>
    func getUserByEmail(_ email: String) -> Observable<User?>
    func getUserByUsername(_ username: String) -> Observable<User?>
    func validateUser(username: String, password: String) -> Observable<User?>
}

class UserLocalService: UserLocalServiceProtocol {
    private var database: Database?
    private let databaseName = "pokecodex_users"
    
    init() {
        setupDatabase()
    }
    
    private func setupDatabase() {
        do {
            let config = DatabaseConfiguration()
            database = try Database(name: databaseName, config: config)
        } catch {
            print("Error setting up database: \(error)")
        }
    }
    
    func saveUser(_ user: User) -> Observable<Bool> {
        return Observable.create { observer in
            guard let database = self.database else {
                observer.onNext(false)
                observer.onCompleted()
                return Disposables.create()
            }
            
            do {
                let document = MutableDocument()
                document.setString(user.id, forKey: "id")
                document.setString(user.username, forKey: "username")
                document.setString(user.email, forKey: "email")
                document.setString(user.password, forKey: "password")
                document.setDate(user.createdAt, forKey: "createdAt")
                
                try database.saveDocument(document)
                observer.onNext(true)
                observer.onCompleted()
            } catch {
                observer.onNext(false)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    func getUserByEmail(_ email: String) -> Observable<User?> {
        return Observable.create { observer in
            guard let database = self.database else {
                observer.onNext(nil)
                observer.onCompleted()
                return Disposables.create()
            }
            
            let query = QueryBuilder
                .select(SelectResult.all())
                .from(DataSource.database(database))
                .where(Expression.property("email").equalTo(Expression.string(email)))
            
            do {
                let results = try query.execute()
                if let result = results.next(),
                   let userDict = result.dictionary(forKey: "pokecodex_users") {
                    let user = User(
                        id: userDict.string(forKey: "id") ?? "",
                        username: userDict.string(forKey: "username") ?? "",
                        email: userDict.string(forKey: "email") ?? "",
                        password: userDict.string(forKey: "password") ?? ""
                    )
                    observer.onNext(user)
                } else {
                    observer.onNext(nil)
                }
                observer.onCompleted()
            } catch {
                observer.onNext(nil)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    func getUserByUsername(_ username: String) -> Observable<User?> {
        return Observable.create { observer in
            guard let database = self.database else {
                observer.onNext(nil)
                observer.onCompleted()
                return Disposables.create()
            }
            
            let query = QueryBuilder
                .select(SelectResult.all())
                .from(DataSource.database(database))
                .where(Expression.property("username").equalTo(Expression.string(username)))
            
            do {
                let results = try query.execute()
                if let result = results.next(),
                   let userDict = result.dictionary(forKey: "pokecodex_users") {
                    let user = User(
                        id: userDict.string(forKey: "id") ?? "",
                        username: userDict.string(forKey: "username") ?? "",
                        email: userDict.string(forKey: "email") ?? "",
                        password: userDict.string(forKey: "password") ?? ""
                    )
                    observer.onNext(user)
                } else {
                    observer.onNext(nil)
                }
                observer.onCompleted()
            } catch {
                observer.onNext(nil)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    func validateUser(username: String, password: String) -> Observable<User?> {
        return Observable.create { observer in
            guard let database = self.database else {
                observer.onNext(nil)
                observer.onCompleted()
                return Disposables.create()
            }
            
            let query = QueryBuilder
                .select(SelectResult.all())
                .from(DataSource.database(database))
                .where(Expression.property("username").equalTo(Expression.string(username))
                    .and(Expression.property("password").equalTo(Expression.string(password))))
            
            do {
                let results = try query.execute()
                if let result = results.next(),
                   let userDict = result.dictionary(forKey: "pokecodex_users") {
                    let user = User(
                        id: userDict.string(forKey: "id") ?? "",
                        username: userDict.string(forKey: "username") ?? "",
                        email: userDict.string(forKey: "email") ?? "",
                        password: userDict.string(forKey: "password") ?? ""
                    )
                    observer.onNext(user)
                } else {
                    observer.onNext(nil)
                }
                observer.onCompleted()
            } catch {
                observer.onNext(nil)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
}
