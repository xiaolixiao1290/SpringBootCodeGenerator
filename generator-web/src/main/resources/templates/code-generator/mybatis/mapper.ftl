<#if isAutoImport?exists && isAutoImport==true>
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Mapper;
import java.util.List;
</#if>

/**
 * @description ${classInfo.classComment}
 * @author ${authorName}
 * @date ${.now?string('yyyy-MM-dd')}
 */
@Mapper
public interface ${classInfo.className}Mapper {
    /**
    * 新增
    **/
    int insert(${classInfo.className} ${classInfo.className?uncap_first});

    /**
    * 新增或在重复键冲突时更新
    **/
    int insertOrUpdateOnDuplicateKey(${classInfo.className} ${classInfo.className?uncap_first});

    /**
    * 刪除
    **/
    int deleteById(@Param("id") int id);

    /**
    * 更新
    **/
    int updateById(${classInfo.className} ${classInfo.className?uncap_first});

    /**
    * 查询 根据主键 id 查询
    **/
    ${classInfo.className} selectById(@Param("id") int id);
}