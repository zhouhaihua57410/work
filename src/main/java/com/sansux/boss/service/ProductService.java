package com.sansux.boss.service;


import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.sansux.boss.bo.ProductBo;
import com.sansux.boss.bo.ProductExample;
import com.sansux.boss.bo.Product;
import com.sansux.boss.mapper.ProductMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.transaction.Transactional;
import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.*;

@Service
public class ProductService {

    @Resource
    private ProductMapper productMapper;

    public Product findById(int id) {
        ProductExample productExample = new ProductExample();
        productExample.createCriteria().andIdEqualTo(id);
        List<Product> products = productMapper.selectByExample(productExample);
        return products.get(0);

        //return productMapper.selectById(id);
    }

    public PageInfo<Product> list(Integer userId, Integer pageNo, Integer pageSize) {
        ProductExample productExample = new ProductExample();
        pageNo = pageNo == null ? 1 : pageNo;
        pageSize = pageSize == null ? 5 : pageSize;
        PageHelper.startPage(pageNo, pageSize);
        List<Product> products = productMapper.bill(userId);
        return new PageInfo<>(products);
    }

    public PageInfo<Product> shoppingCart(Integer userId, Integer pageNo, Integer pageSize) {
        ProductExample productExample = new ProductExample();
        pageNo = pageNo == null ? 1 : pageNo;
        pageSize = pageSize == null ? 5 : pageSize;
        PageHelper.startPage(pageNo, pageSize);
        List<Product> products = productMapper.shoppingCart(userId);
        return new PageInfo<>(products);
    }


    public PageInfo<Product> list(Integer userId, String identity, Integer pageNo, Integer pageSize,String buyed) {

        ProductExample productExample = new ProductExample();
        pageNo = pageNo == null ? 1 : pageNo;
        pageSize = pageSize == null ? 12 : pageSize;
        PageHelper.startPage(pageNo, pageSize);
        List<Product> products = new ArrayList<>();

        if (userId == null || "".equals(userId)) {
            productExample.createCriteria().andDeletedEqualTo("0");
            products = productMapper.selectByExample(productExample);
            return new PageInfo<>(products);
        }
        if (identity.equals("seller")) {
            productExample.createCriteria().andSellerIdEqualTo(userId).andDeletedEqualTo("0");
            products = productMapper.selectByExample(productExample);
        } else if (identity.equals("buyer")) {
            if("false".equals(buyed)){
                products = productMapper.selectByBuyerNotBuy(userId);
            }else{
                products = productMapper.selectByBuyer(userId);
            }
        }
        return new PageInfo<>(products);
    }

    private List<Product> listByBuyerId(Integer userId) {


        return null;
    }

    public Product checkName2(Product product) {
        return productMapper.selectByNameAndNotId(product);
    }

    public void deleteById(Integer id) {
        productMapper.deleteById(id);
    }

    public String update(Product product) {
        String result;
        Product flag = checkName2(product);
        if (flag != null) {
            result = "商品名已存在！";
        } else {
            productMapper.updateByPrimaryKeySelective(product);
            result = "修改成功！";
        }
        return result;
    }

    public String add(Product product) {
        if(product.getName() == null || product.getName().equals("") ){
            return "请填写产品标题！";
        }
        if (!checkName(product.getName())) {
            return "商品名已存在！请更换商品名";
        }

        if(product.getAbstracts() == null || product.getAbstracts().equals("") ){
            return "请填写摘要信息！";
        }
        if(product.getDescription() == null || product.getDescription().equals("") ){
            return "请填写正文信息！";
        }
        if(product.getPrice() == null ){
            return "请填写价格信息！";
        }

        product.setDeleted("0");
        int result = productMapper.insert(product);
        return result == 1 ? "发布成功！" : "发布失败";
    }

    private boolean checkName(String name) {
        ProductExample productExample = new ProductExample();
        productExample.createCriteria().andNameEqualTo(name);
        List<Product> products = productMapper.selectByExample(productExample);
        return products.size() == 0;
    }

    private boolean checkName(String name,Integer productId) {
        ProductExample productExample = new ProductExample();
        productExample.createCriteria().andNameEqualTo(name).andIdNotEqualTo(productId);
        List<Product> products = productMapper.selectByExample(productExample);
        return products.size() == 0;
    }

    public Map<String, Object> uploadFile(MultipartFile file, HttpServletRequest request) throws UnsupportedEncodingException {
        String filePath = request.getServletContext().getRealPath("/") + "static/images";
        Map<String, Object> map = new HashMap<>();
        long fileSize = file.getSize();

        String suffix = file.getOriginalFilename().substring(file.getOriginalFilename().lastIndexOf(".")).toLowerCase();
        if (suffix.equals(".png") || suffix.equals(".jpg")||suffix.equals(".jpeg")) {
            if (fileSize < 5 * 1024 * 1024) {
                String fileName = file.getOriginalFilename();
                //File tempFile = new File(filePath, new Date().getTime() + fileName);
                File tempFile = new File(filePath, fileName);

                try {
                    if (!tempFile.getParentFile().exists()) {
                        tempFile.getParentFile().mkdirs();//如果是多级文件使用mkdirs();如果就一层级的话，可以使用mkdir()
                    }
                    if (!tempFile.exists()) {
                        tempFile.createNewFile();
                    }
                    file.transferTo(tempFile);
                } catch (IOException e) {
                    e.printStackTrace();
                }
                map.put("STATUS", "success");
                //map.put("data", filePath + new Date().getTime() + tempFile.getName());
                map.put("DATA", "图片上传成功！");
            } else {
                map.put("STATUS", "fail");
                map.put("DATA", "图片过大！");
            }

        } else {
            map.put("STATUS", "fail");
            map.put("DATA", "图片格式错误！");
        }
        return map;

    }

    public Product checkProductBuy(Integer productId, int userId) {
        return productMapper.checkProductBuy(productId, userId);
    }

    public void joinShoppingCart(int productId, int userId, int count, long price) {
        ProductBo productBo = productMapper.selectByProductIdAndUserId(productId, userId);
        String flag = "";
        if (productBo == null) {
            productMapper.joinShoppingCart(productId, userId, flag, count, 1, price);
        } else {
            int finalCount = productBo.getCount() + count;
            productMapper.updateCountAndPrice(productBo.getId(), finalCount, price);
        }
    }

    public void moveFromShoppingCart(Integer id) {
        productMapper.moveFromShoppingCart(id);
    }

    @Transactional
    public void buyProduct(List<Integer> idList) {
        productMapper.buyProduct(idList);

        // 根据idList 得到 product表中的 id 和 count
        List<ProductBo> productIdList = productMapper.findProductId(idList);

        productMapper.sellNumAutoIncrement(productIdList);
    }

    public String editProduct(Product product) {

        if(product.getName() == null || product.getName().equals("") ){
            return "请填写产品标题！";
        }
        if (!checkName(product.getName(),product.getId())) {
            return "产品名已存在！请更换产品名";
        }
        if(product.getAbstracts() == null || product.getAbstracts().equals("") ){
            return "请填写摘要信息！";
        }
        if(product.getPrice() == null ){
            return "请填写价格信息！";
        }
        if(product.getDescription() == null || product.getDescription().equals("") ){
            return "请填写正文信息！";
        }
        productMapper.editProduct(product);
        return "修改成功！";
    }
}
