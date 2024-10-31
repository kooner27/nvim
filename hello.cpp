#include <iostream>
#include <unordered_map>

using namespace std;

int main() {
    // clangd file in ~ directoroy -std = c++20 for latest lsp
    unordered_map<int, int> map;
    map.insert({5, 5});
    cout << map.contains(5) << endl;
    return 0;
}
