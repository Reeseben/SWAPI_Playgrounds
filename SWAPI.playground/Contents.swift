import Foundation

struct person: Codable {
    let name: String
    let films: [URL]
}

struct film: Codable {
    let title: String
    let opening_crawl: String
    let release_date: String
}


class SwapiService {
    static private let baseURL = URL(string: "https://swapi.dev/api/")
    
    static func fetchPerson(id: Int, completion: @escaping (person?) -> Void){
        //Prepare URL
        guard let baseURL = baseURL else { return completion(nil) }
        let finalURL = baseURL.appendingPathComponent("people/\(id)")
        
        //Contact Server
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            //Handle errors
            if let error = error {
                print("Error retrieving person from API: \(error.localizedDescription)")
                return completion(nil)
            }
            //Check for data
            guard let data = data else { return completion(nil)}
            
            //Decode Person from JSON
            do{
                let decoder = JSONDecoder()
                let decodedPerson = try decoder.decode(person.self, from: data)
                return completion(decodedPerson)
            } catch {
                print("Error unwrapping JSON person from API: \(error.localizedDescription)")
                return completion(nil)
            }
            
            
        }.resume()
    }
    
    static func getFilm(url: URL, completion: @escaping (film?) -> Void) {
        // Contact server
        URLSession.shared.dataTask(with: url) { data, _, error in
            // Handle errors
            if let error = error {
                print("Error retrieving person from API: \(error.localizedDescription)")
                return completion(nil)
            }
            // Check for data
            guard let data = data else { return completion(nil) }
            
            // Decode film from JSON
            do{
                let decoder = JSONDecoder()
                let filmFromDecoder = try decoder.decode(film.self, from: data)
                return completion(filmFromDecoder)
            } catch {
                print("Error unwrapping JSON person from API: \(error.localizedDescription)")
                return completion(nil)
            }
            
            
            
        }.resume()
        
    }
    
    
}

func fetchFilm(url: URL) {
    SwapiService.getFilm(url: url, completion: { filmFromAPI in
        if let filmFromAPI = filmFromAPI {
            print(filmFromAPI)
        }
    })
}

SwapiService.fetchPerson(id: 10) { personFromAPI in
    if let personFromAPI = personFromAPI {
        print(personFromAPI)
        for film in personFromAPI.films {
            fetchFilm(url: film)
        }
    }
}
