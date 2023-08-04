package com.li.project.crypto;


import java.io.File;
import java.io.FileInputStream;
import java.nio.ByteBuffer;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;
import java.security.MessageDigest;

public class FileMD5Util {
    private static final String TAG = "FileMD5Util";

    public static String hashForFilePath(String path) {
        try {
            File file = new File(path);
            if (file.exists()) {
                return getFileMD5(file);
            }
        } catch (Exception e) {
        }
        return "";
    }

    private static String getFileMD5(File file) {
        StringBuilder stringbuffer = null;
//        MappedByteBuffer[] mappedByteBuffers;
//        int bufferCount;
        try {
            FileInputStream inputStream = new FileInputStream(file);
            FileChannel fileChannel = inputStream.getChannel();
            MessageDigest messagedigest = MessageDigest.getInstance("MD5");

            ByteBuffer buffer = ByteBuffer.allocate(1024*8);
            while (fileChannel.read(buffer) > 0) {
                buffer.flip();
                messagedigest.update(buffer);
                buffer.clear();
            }

//            long fileSize = fileChannel.size();
//            bufferCount = (int) Math.ceil((double) fileSize / (double) Integer.MAX_VALUE);
//            mappedByteBuffers = new MappedByteBuffer[bufferCount];
//
//            long preLength = 0;
//            long regionSize = Integer.MAX_VALUE;
//            for (int i = 0; i < bufferCount; i++) {
//                if (fileSize - preLength < Integer.MAX_VALUE) {
//                    regionSize = fileSize - preLength;
//                }
//                mappedByteBuffers[i] = fileChannel.map(FileChannel.MapMode.READ_ONLY, preLength, regionSize);
//                preLength += regionSize;
//            }

            inputStream.close();

            char[] hexDigits = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'};
//            MessageDigest messagedigest = MessageDigest.getInstance("MD5");

//            for (int i = 0; i < bufferCount; i++) {
//                messagedigest.update(mappedByteBuffers[i]);
//            }

            byte[] bytes = messagedigest.digest();//digest

            int n = bytes.length;
            stringbuffer = new StringBuilder(2 * n);
            for (byte bt : bytes) {
                char c0 = hexDigits[(bt & 0xf0) >> 4];
                char c1 = hexDigits[bt & 0xf];
                stringbuffer.append(c0);
                stringbuffer.append(c1);
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
        return stringbuffer.toString();
    }

}
