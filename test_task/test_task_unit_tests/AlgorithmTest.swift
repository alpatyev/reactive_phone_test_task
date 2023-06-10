import XCTest

// MARK: - First task

final class AlgorithmTests: XCTestCase {
    
    // MARK: - Stubs
    
    let input: [[Int]] = [[1,0,1],
                          [0,1,0],
                          [0,0,0]]
    
    let output: [[Int]] = [[0,1,0],
                           [1,0,1],
                           [2,1,2]]
    
    // MARK: - Tests
    
    func test_first_case() {
        let result = findDistances(input)
        
        XCTAssertEqual(result, output)
    }
    
    // MARK: - SUT
    
    func findDistances(_ matrix: [[Int]]) -> [[Int]] {
        let n = matrix.count
        guard let m = matrix.first?.count else { return [] }
        
        var distances = Array(repeating: Array(repeating: Int.max, count: m), count: n)
        
        var queue: [(x: Int, y: Int)] = []
        for x in 0 ..< n {
            for y in 0 ..< m {
                if matrix[x][y] == 1 {
                    distances[x][y] = 0
                    queue.append((x, y))
                }
            }
        }
        
        let dx = [0, 1, 0, -1]
        let dy = [1, 0, -1, 0]
        
        while !queue.isEmpty {
            let (x, y) = queue.removeFirst()
            for i in 0..<4 {
                let nx = x + dx[i]
                let ny = y + dy[i]
                if nx >= 0 && nx < n && ny >= 0 && ny < m && distances[nx][ny] > distances[x][y] + 1 {
                    distances[nx][ny] = distances[x][y] + 1
                    queue.append((nx, ny))
                }
            }
        }
        
        return distances
    }
}
