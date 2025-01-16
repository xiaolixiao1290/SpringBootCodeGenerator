package ${packageName}.model;
<#-- 检查是否需要导入 BigDecimal 包 -->
<#assign hasBigDecimal = false>
<#assign hasCreateTimeOrUpdateTime = false>
<#if classInfo.fieldList?exists && classInfo.fieldList?size gt 0>
    <#list classInfo.fieldList as fieldItem>
        <#if fieldItem.fieldClass == "BigDecimal">
            <#assign hasBigDecimal = true>
        </#if>
        <#if fieldItem.fieldName == "createTime" || fieldItem.fieldName == "updateTime">
            <#assign hasCreateTimeOrUpdateTime = true>
        </#if>
    </#list>
</#if>

<#if hasCreateTimeOrUpdateTime>import com.fasterxml.jackson.annotation.JsonFormat;</#if>
<#if isLombok?exists && isLombok == true>import lombok.Data;</#if>
<#if hasBigDecimal>import java.math.BigDecimal;</#if>
import java.util.Date;
/**
* ${classInfo.classComment}
*
* @author ${authorName}
* @date ${.now?string('yyyy-MM-dd')}
*/
<#if isLombok?exists && isLombok==true>@Data</#if>
public class ${classInfo.className} {
<#if classInfo.fieldList?exists && classInfo.fieldList?size gt 0>
<#list classInfo.fieldList as fieldItem >
    <#if isComment?exists && isComment==true>/**
    * ${fieldItem.fieldComment}
    */</#if>
    <#if fieldItem.fieldName == "createTime" || fieldItem.fieldName == "updateTime">
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss", timezone = "GMT+8")
    </#if>
    private ${fieldItem.fieldClass} ${fieldItem.fieldName};
    <#if fieldItem?has_next>

    </#if>
</#list>
</#if>
}