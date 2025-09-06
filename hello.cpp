#include <iostream>
#include <unordered_map>
using namespace std;
int main() {
    std::unordered_map<int, int> map;
    map.insert({5, 3});
    cout << map[5] << endl;
    return 0;
}

