package com.navercorp.pinpoint.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * @author 汪正章
 * @ClassName IndexController
 * @create 2019-01-16 17:57
 * @desc
 * @Version 1.0V
 **/
@Controller
public class IndexController {
    @RequestMapping("/index")
    public String index(){
      return "index";
    }
}
