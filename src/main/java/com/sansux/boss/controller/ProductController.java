package com.sansux.boss.controller;

import com.alibaba.fastjson.JSONObject;
import com.github.pagehelper.PageInfo;
import com.sansux.boss.bo.Product;
import com.sansux.boss.service.ProductService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import javax.persistence.criteria.CriteriaBuilder;
import javax.servlet.http.HttpServletRequest;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/product")
public class ProductController {

    @Autowired
    private ProductService productService;


    @ResponseBody
    @RequestMapping(value = "/add", method = RequestMethod.POST)
    public String add(Product product) {
        product.setImg(product.getImg().replace("C:\\fakepath\\", ""));
        product.setSellNum(0);
        return productService.add(product);

    }

    @ResponseBody
    @RequestMapping("/findById")
    public String findById() {
        productService.findById(1);
        return "success";
    }

    @ResponseBody
    @RequestMapping(value = "/list", method = RequestMethod.POST)
    public PageInfo<Product> list(@RequestParam(required = false) String identity,
                                  @RequestParam(required = false) Integer userId,
                                  @RequestParam(defaultValue = "true") String buyed,
                                  @RequestParam(defaultValue = "1") Integer currentPage,
                                  @RequestParam(defaultValue = "8") Integer pageSize) {

        return productService.list(userId, identity, currentPage, pageSize,buyed);
    }


    @ResponseBody
    @RequestMapping(value = "/bill", method = RequestMethod.POST)
    public PageInfo<Product> bill(@RequestParam(required = false) Integer userId,
                                          @RequestParam(defaultValue = "1") Integer currentPage,
                                          @RequestParam(defaultValue = "8") Integer pageSize) {

        return productService.list(userId, currentPage, pageSize);
    }

    @ResponseBody
    @RequestMapping(value = "/shoppingCart", method = RequestMethod.POST)
    public PageInfo<Product> shoppingCart(@RequestParam(required = false) Integer userId,
                                  @RequestParam(defaultValue = "1") Integer currentPage,
                                  @RequestParam(defaultValue = "8") Integer pageSize) {

        return productService.shoppingCart(userId, currentPage, pageSize);
    }

    @ResponseBody
    @RequestMapping(value = "/update", method = RequestMethod.POST)
    public String update(Product product) {
        return productService.update(product);
    }

    @ResponseBody
    @RequestMapping(value = "/moveFromShoppingCart/{id}", method = RequestMethod.GET)
    public String moveFromShoppingCart(@PathVariable Integer id) {
        productService.moveFromShoppingCart(id);
        return "成功移除购物车！!";
    }

//    @ResponseBody
//    @RequestMapping(value = "/delete/{id}", method = RequestMethod.GET)
//    public String delete(@PathVariable Integer id) {
//        productService.deleteById(id);
//        return "成功删除商品!";
//    }

    @RequestMapping(value = "/show/{id}", method = RequestMethod.GET)
    public ModelAndView show(@PathVariable Integer id, HttpServletRequest request) {

        Product product = productService.findById(id);
        ModelAndView modelAndView = new ModelAndView("show");
        // 验证用户是否购买过该id产品
        Object object = request.getSession().getAttribute("userId");
        if(object != null){
            int userId = (int) object;
            Product producted = productService.checkProductBuy(id, userId);
            int flag;
            long buy_price = 0;
            if (producted == null) {
                flag = 0;
            }else{
                flag =1;
                buy_price = producted.getPrice();
            }
            modelAndView.addObject("product", product);
            modelAndView.addObject("flag", flag);
            modelAndView.addObject("buy_price", buy_price);

        }else{
            modelAndView.addObject("product", product);
        }
        return modelAndView;
    }

    @ResponseBody
    @RequestMapping(value = "/uploadImg", method = RequestMethod.POST)
    public String uploadImg(HttpServletRequest request) {

        MultipartHttpServletRequest multiRequest = (MultipartHttpServletRequest) request;
        MultipartFile file = multiRequest.getFile("file");
        Map<String, Object> map = new HashMap<>();
        try {
            map = productService.uploadFile(file, request);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        return JSONObject.toJSONString(map);
    }

    @ResponseBody
    @RequestMapping(value = "/joinShoppingCart", method = RequestMethod.POST)
    public String joinShoppingCart(HttpServletRequest request) {

        int productId= Integer.valueOf(request.getParameter("productId"));
        int count= Integer.valueOf(request.getParameter("count"));
        int userId = (int) request.getSession().getAttribute("userId");
        long price = Long.parseLong(request.getParameter("price"));
        productService.joinShoppingCart(productId,userId,count,price);
        return "成功加入购物车！";
    }

    @ResponseBody
    @RequestMapping(value = "/buyProduct", method = RequestMethod.POST)
    public String buyProduct(HttpServletRequest request) {

        String idsStr = request.getParameter("idList");
        String[] idStrList = idsStr.split(",");
        System.out.println(idStrList.length);
        System.out.println(idStrList[0]);
        List<Integer> idList = new ArrayList<>();
        for(String idStr : idStrList){
            idList.add(Integer.valueOf(idStr));
        }
        productService.buyProduct(idList);
        return "购买成功！";
    }

    @ResponseBody
    @RequestMapping(value = "/editProduct", method = RequestMethod.POST)
    public String editProduct(Product product) {

        if(product.getPrice() == null || product.getPrice().equals("")){
            return "请输入正确的价格信息";
        }
        product.setImg(product.getImg().replace("C:\\fakepath\\", ""));
        return productService.editProduct(product);
    }


    @ResponseBody
    @RequestMapping(value = "/deleteProduct/{id}", method = RequestMethod.GET)
    public String deleteProduct(@PathVariable Integer id) {
        productService.deleteById(id);
        return "删除成功！";

    }
}
