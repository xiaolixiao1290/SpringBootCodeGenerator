package com.softdev.system.generator.controller;


import com.softdev.system.generator.entity.ParamInfo;
import com.softdev.system.generator.entity.ReturnT;
import com.softdev.system.generator.util.MapUtil;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletResponse;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.*;
import java.nio.file.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

@RestController
@Slf4j
public class FileDownloadController {
    @Resource
    private GeneratorController generatorController;

    @RequestMapping("/downloadZip")
    public void downloadZip(@RequestBody ParamInfo paramInfo, HttpServletResponse response) throws Exception {
        List<FileEntry> files = new ArrayList<>();
        for (String tableSql : paramInfo.getTableSqlList()) {
            ParamInfo item = new ParamInfo();
            item.setTableSql(tableSql);
            item.setOptions(paramInfo.getOptions());
            ReturnT res = generatorController.generateCode(item);
            String className = MapUtil.getString((HashMap) res.get("outputJson"), "className");
            String mapper = MapUtil.getString((HashMap) res.get("outputJson"), "mapper");
            String mybatis = MapUtil.getString((HashMap) res.get("outputJson"), "mybatis");
            String model = MapUtil.getString((HashMap) res.get("outputJson"), "model");

            files.add(new FileEntry(mapper, "mapper/" + className + "Mapper.java"));
            files.add(new FileEntry(mybatis, "mybatis/" + className + "Mapper.xml"));
            files.add(new FileEntry(model, "model/" + className + ".java"));
        }
        // 输出 ZIP 文件名
        String zipFileName = "ScrmFiles.zip";

        // 调用封装的方法生成 ZIP 文件并响应下载
        generateAndDownloadZip(files, zipFileName, response);
    }

    /**
     * 封装方法：生成 ZIP 文件并返回给客户端
     *
     * @param files       要生成的文件内容和路径
     * @param zipFileName 输出的 ZIP 文件名
     * @param response    HttpServletResponse
     * @throws IOException
     */
    private void generateAndDownloadZip(List<FileEntry> files, String zipFileName, HttpServletResponse response) throws IOException {
        // 创建临时目录
        Path tempDir = Files.createTempDirectory("scrm-files");

        try {
            // 创建文件
            for (FileEntry fileEntry : files) {
                File file = new File(tempDir.toFile(), fileEntry.getFileName());
                file.getParentFile().mkdirs(); // 创建子目录
                try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
                    writer.write(fileEntry.getContent());
                }
            }

            // 创建 ZIP 文件
            File zipFile = new File(tempDir.toFile(), zipFileName);
            try (FileOutputStream fos = new FileOutputStream(zipFile);
                 ZipOutputStream zos = new ZipOutputStream(fos)) {

                // 添加文件到 ZIP
                for (FileEntry fileEntry : files) {
                    File file = new File(tempDir.toFile(), fileEntry.getFileName());
                    addToZipFile(file, fileEntry.getFileName(), zos);
                }
            }

            // 设置 HTTP 响应
            response.setContentType("application/zip");
            response.setHeader("Content-Disposition", "attachment; filename=" + zipFileName);

            try (FileInputStream fis = new FileInputStream(zipFile)) {
                OutputStream os = response.getOutputStream();
                byte[] buffer = new byte[1024];
                int length;
                while ((length = fis.read(buffer)) > 0) {
                    os.write(buffer, 0, length);
                }
                os.flush();
            }
        } finally {
            // 清理临时目录和文件
            Files.walk(tempDir)
                    .sorted((p1, p2) -> p2.compareTo(p1)) // 先删除文件再删除目录
                    .map(Path::toFile)
                    .forEach(File::delete);
        }
    }

    /**
     * 将文件添加到 ZIP 中
     *
     * @param file          要添加的文件
     * @param fileNameInZip ZIP 内的文件路径
     * @param zos           ZipOutputStream
     * @throws IOException
     */
    private void addToZipFile(File file, String fileNameInZip, ZipOutputStream zos) throws IOException {
        try (FileInputStream fis = new FileInputStream(file)) {
            ZipEntry zipEntry = new ZipEntry(fileNameInZip);
            zos.putNextEntry(zipEntry);

            byte[] buffer = new byte[1024];
            int length;
            while ((length = fis.read(buffer)) > 0) {
                zos.write(buffer, 0, length);
            }
        }
    }

    /**
     * 文件条目类，用于封装文件内容和路径
     */
    @Data
    @AllArgsConstructor
    public static class FileEntry {
        private final String content;
        private final String fileName;
    }
}
