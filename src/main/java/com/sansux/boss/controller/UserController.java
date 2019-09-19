package com.sansux.boss.controller;


import com.sansux.boss.bo.User;
import com.sansux.boss.service.UserService;
import com.sansux.boss.util.MD5Util;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;
import java.util.List;

@Controller
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;

    @ResponseBody
    @RequestMapping("/test")
    public String test() {
        System.out.println("hello world!");
        return "hello world";
    }

    @RequestMapping("/test2")
    public String test2() {
        System.out.println("hello world!");
        return "login";
    }

    @RequestMapping(value = "/login", method = RequestMethod.POST)
    public String login(User record, HttpServletRequest request) {
        String result;
        List<User> users = userService.login(record);
        if (users.size() == 0) {
            result = "用户名或密码错误!";
            request.getSession().setAttribute("result;", result);
            return "forward:/failed.jsp";
        }else{
            result = "登录成功!";
            request.getSession().setAttribute("username", record.getUsername());
            request.getSession().setAttribute("identity", users.get(0).getIdentity());
            request.getSession().setAttribute("userId", users.get(0).getId());
            request.getSession().setAttribute("result;", result);
            return "redirect:/index.jsp";
        }
    }

    @RequestMapping(value = "/logout", method = RequestMethod.GET)
    public String logout( HttpServletRequest request) {
        request.getSession().removeAttribute("username");
        request.getSession().removeAttribute("identity");
        request.getSession().removeAttribute("userId");
        request.getSession().removeAttribute("result");
        return "redirect:/login.jsp";
    }

}
