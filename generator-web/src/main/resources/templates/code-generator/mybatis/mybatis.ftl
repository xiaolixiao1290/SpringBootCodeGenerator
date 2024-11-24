<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="${packageName}.mapper.${classInfo.className}Mapper">

    <resultMap id="BaseResultMap" type="${packageName}.model.${classInfo.className}">
        <#if classInfo.fieldList?exists && classInfo.fieldList?size gt 0>
            <#list classInfo.fieldList as fieldItem >
                <result column="${fieldItem.columnName}" property="${fieldItem.fieldName}"/>
            </#list>
        </#if>
    </resultMap>

    <sql id="Base_Column_List">
        <#if classInfo.fieldList?exists && classInfo.fieldList?size gt 0>
            <#list classInfo.fieldList as fieldItem >
        ${fieldItem.columnName}<#if fieldItem_has_next>,</#if>
            </#list>
        </#if>
    </sql>

    <insert id="insert" useGeneratedKeys="true" keyColumn="id" keyProperty="id" parameterType="${packageName}.model.${classInfo.className}">
        INSERT INTO ${classInfo.originTableName}
        <trim prefix="(" suffix=")" suffixOverrides=",">
            <#if classInfo.fieldList?exists && classInfo.fieldList?size gt 0>
                <#list classInfo.fieldList as fieldItem >
                    <#if fieldItem.columnName != "id" >
                        <if test="null != ${fieldItem.fieldName} <#if fieldItem.fieldClass ="String">and '' != ${fieldItem.fieldName}</#if>">
                        ${fieldItem.columnName}<#if fieldItem_has_next>,</#if>
                        ${r"</if>"}
                    </#if>
                </#list>
            </#if>
        </trim>
        <trim prefix="values (" suffix=")" suffixOverrides=",">
            <#if classInfo.fieldList?exists && classInfo.fieldList?size gt 0>
                <#list classInfo.fieldList as fieldItem >
                    <#if fieldItem.columnName != "id" >
                    <#--<#if fieldItem.columnName="addtime" || fieldItem.columnName="updatetime" >
                    ${r"<if test ='null != "}${fieldItem.fieldName}${r"'>"}
                        NOW()<#if fieldItem_has_next>,</#if>
                    ${r"</if>"}
                    <#else>-->
                        <if test="null != ${fieldItem.fieldName} <#if fieldItem.fieldClass ="String">and '' != ${fieldItem.fieldName}</#if>">
                        ${r"#{"}${fieldItem.fieldName}${r"}"}<#if fieldItem_has_next>,</#if>
                        ${r"</if>"}
                    <#--</#if>-->
                    </#if>
                </#list>
            </#if>
        </trim>
    </insert>

    <insert id="insertOrUpdateOnDuplicateKey" useGeneratedKeys="true" keyColumn="id" keyProperty="id" parameterType="${packageName}.model.${classInfo.className}">
        INSERT INTO ${classInfo.originTableName}
        <trim prefix="(" suffix=")" suffixOverrides=",">
            <#if classInfo.fieldList?exists && classInfo.fieldList?size gt 0>
                <#list classInfo.fieldList as fieldItem>
                    <#if fieldItem.columnName != "id">
                        <if test="null != ${fieldItem.fieldName} <#if fieldItem.fieldClass = "String">and '' != ${fieldItem.fieldName}</#if>">
                            ${fieldItem.columnName}<#if fieldItem_has_next>,</#if>
                        </if>
                    </#if>
                </#list>
            </#if>
        </trim>
        <trim prefix="values (" suffix=")" suffixOverrides=",">
            <#if classInfo.fieldList?exists && classInfo.fieldList?size gt 0>
                <#list classInfo.fieldList as fieldItem>
                    <#if fieldItem.columnName != "id">
                        <if test="null != ${fieldItem.fieldName} <#if fieldItem.fieldClass = "String">and '' != ${fieldItem.fieldName}</#if>">
                            ${r"#{"}${fieldItem.fieldName}${r"}"}<#if fieldItem_has_next>,</#if>
                        </if>
                    </#if>
                </#list>
            </#if>
        </trim>
        ON DUPLICATE KEY UPDATE
        <trim suffixOverrides=",">
            <#if classInfo.fieldList?exists && classInfo.fieldList?size gt 0>
                <#list classInfo.fieldList as fieldItem>
                    <#if fieldItem.columnName != "id">
                        <if test="null != ${fieldItem.fieldName} <#if fieldItem.fieldClass = "String">and '' != ${fieldItem.fieldName}</#if>">
                            ${fieldItem.columnName} = ${r"#{"}${fieldItem.fieldName}${r"}"}<#if fieldItem_has_next>,</#if>
                        </if>
                    </#if>
                </#list>
            </#if>
        </trim>
    </insert>

    <delete id="deleteById" >
        DELETE FROM ${classInfo.originTableName}
        WHERE id = ${r"#{id}"}
    </delete>

    <update id="updateById" parameterType="${packageName}.model.${classInfo.className}">
        UPDATE ${classInfo.originTableName}
        <set>
            <#list classInfo.fieldList as fieldItem >
                <#if fieldItem.columnName != "id" && fieldItem.columnName != "AddTime" && fieldItem.columnName != "UpdateTime" >
                    <if test="null != ${fieldItem.fieldName} <#if fieldItem.fieldClass ="String">and '' != ${fieldItem.fieldName}</#if>">${fieldItem.columnName} = ${r"#{"}${fieldItem.fieldName}${r"}"}<#if fieldItem_has_next>,</#if>${r"</if>"}
                </#if>
            </#list>
        </set>
        WHERE id = ${r"#{"}id${r"}"}
    </update>

    <select id="selectById" resultMap="BaseResultMap">
        SELECT <include refid="Base_Column_List" />
        FROM ${classInfo.originTableName}
        WHERE id = ${r"#{id}"}
    </select>
</mapper>