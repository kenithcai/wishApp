//
//  main.cpp
//  testRap
//
//  Created by KenithCai on 16/11/18.
//  Copyright © 2016年 KenithCai. All rights reserved.
//

#include <iostream>
#include "document.h"

using namespace rapidjson;

int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    
    
    const char* json = "{\"project\":\"rapidjson\",\"stars\":10}";
    rapidjson::Document d;
    d.Parse(json);
    // 2. 利用 DOM 作出修改。
    
    // Output {"project":"rapidjson","stars":11}
    std::cout << d["project"].GetString() << std::endl;
    
    return 0;
}
