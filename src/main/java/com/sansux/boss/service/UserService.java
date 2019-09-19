package com.sansux.boss.service;

import com.sansux.boss.bo.User;
import com.sansux.boss.bo.UserExample;
import com.sansux.boss.mapper.UserMapper;
import com.sansux.boss.util.MD5Util;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;
import java.util.List;

@Service
public class UserService {

    @Autowired
    private UserMapper userMapper;

    public List<User> login(User record) {

        User user = new User();
        String passwordStr = "";


        try {
            passwordStr = MD5Util.EncoderByMd5(record.getPassword());
        } catch (NoSuchAlgorithmException | UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        UserExample userExample = new UserExample();
        userExample.createCriteria().andUsernameEqualTo(record.getUsername()).andPasswordEqualTo(passwordStr);

        return userMapper.selectByExample(userExample);
    }

}
