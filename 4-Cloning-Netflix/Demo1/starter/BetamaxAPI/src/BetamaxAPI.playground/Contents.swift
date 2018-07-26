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
    case getProgress(userId: String)
    case updateProgress(userId: String, progress: ProgressParams)
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
        case .getProgress(let userId),
             .updateProgress(let userId, _):
            return "/users/\(userId)/viewings"
        }
    }
    
    var method: Method {
        switch self {
        case .updateProgress:
            return .post
        default:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .showScreencasts:
            return .requestParameters(parameters: ["format" : "screencast"],
                                      encoding: URLEncoding.queryString)
        case .showVideo, .getProgress:
            return .requestPlain
        case .updateProgress(userId: _, progress: let progress):
            return .requestJSONEncodable(progress)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type" : "application/json"]
    }
}

let userId = "00421d2c-176a-11e7-8099-b7b32623e8a9"
let authToken = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIwMDQyMWQyYy0xNzZhLTExZTctODA5OS1iN2IzMjYyM2U4YTkiLCJpYXQiOjE1MzI2MTg0NjB9.nD9eGAFRCMH0LU7EmVB7PRqRUuNT9ONV4PirvyUwIQA"

extension BetamaxAPI: AccessTokenAuthorizable {

    var authorizationType: AuthorizationType {
        return .bearer
    }
}

let provider = MoyaProvider<BetamaxAPI>(
    plugins: [AccessTokenPlugin(tokenClosure: authToken)]
)

provider.request(.getProgress(userId: userId)) { result in
    switch result {
    case .success(let response):
        print(response.statusCode)
        let progress = try! response.map([ProgressParams].self, atKeyPath:
            "viewings")
        print(progress.filter { $0.videoId == 452 })
    case .failure(let error):
        print(error)
    }
}



