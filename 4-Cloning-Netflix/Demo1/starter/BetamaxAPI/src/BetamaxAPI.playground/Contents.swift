/*
 * Copyright (c) 2018 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Moya
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

enum BetamaxAPI {
    case showScreencasts
    case showVideo(id: Int)
}

extension BetamaxAPI: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://videos.raywenderlich.com/api/v1")!
    }
    
    var path: String {
        switch self {
        case .showScreencasts:
            return "/videos"
        case .showVideo(id: let id):
            return "/videos/\(id)"
        }
    }
    
    var method: Method {
        return .get }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .showScreencasts:
            return .requestParameters(parameters: ["format" : "screencast"],
                                      encoding: URLEncoding.queryString)
        case .showVideo:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type" : "application/json"]
    }
}

let provider = MoyaProvider<BetamaxAPI>()

provider.request(.showScreencasts) { result in
    switch result {
    case .success(let response):
        print(response.statusCode)
        print(String(bytes: response.data, encoding: .utf8)!)
    case .failure(let error):
        print(error)
    }
}



