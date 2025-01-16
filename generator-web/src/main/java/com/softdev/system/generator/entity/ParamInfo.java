package com.softdev.system.generator.entity;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Post data - ParamInfo
 *
 * @author zhengkai.blog.csdn.net
 */
@Data
public class ParamInfo {

    private List<String> tableSqlList = new ArrayList<>();
    private String tableSql;
    private Map<String,Object> options;

    @Data
    public static class NAME_CASE_TYPE {
        public static String CAMEL_CASE = "CamelCase";
        public static String UNDER_SCORE_CASE = "UnderScoreCase";
        public static String UPPER_UNDER_SCORE_CASE = "UpperUnderScoreCase";
    }

}
