Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7661F7071;
	Tue,  3 Dec 2024 15:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239329; cv=none; b=o0vqNvI4Yw0FKBTzZW3PXnNIUxKVwR8Iy5LLe9gV0c1tJD6zUQSjPBnReX6bVM9wY3Y8P7MEEGbxhGEZbH3b4dMgGA/W9MosVCT7m8C+O2x9AuTA7hZ2b/EpCPLYYOOPBZk875lLDtxxTxnkSx6aHIhyT1iKwxQrARDQRZsK7MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239329; c=relaxed/simple;
	bh=esk7CQQPE5vf6n+Oj/RnupdwuSLxt4246AnseinHogQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TWFoY0ENURoTq7cuk6P/BLVfo1ZJPyR3lXNUILI9x13s5DnDoqm4dYj1My2C9BZb4kw+84zcgyyxF5DxlsfXilOvT8sa1wAZsuMBx44wekeokNkMueE5rIgWBiyWUCqinmNRQEubDi8gm9jwjnQIe3XeOrOYCkyZW9UpDRaaOrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2HtZJVgT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2HtZJVgT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D79B5C4CECF;
	Tue,  3 Dec 2024 15:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239329;
	bh=esk7CQQPE5vf6n+Oj/RnupdwuSLxt4246AnseinHogQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2HtZJVgTd/5VernUzpA0JfwxFnn8NLqLbXXTUbRQQzsK5xYwRrM928vIrCSeOs82b
	 4lAsgq8BxmpLmxGEYLMr2veNuUEa8yGxaU4KEYWuFXRw6mBCJo8dpktWtRCbT3WLAs
	 +W6WkMkyNiZHCyvp705pgnUVaTdJCFpef7qztEXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 545/817] f2fs: clean up val{>>,<<}F2FS_BLKSIZE_BITS
Date: Tue,  3 Dec 2024 15:41:57 +0100
Message-ID: <20241203144017.179784655@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiguo Niu <zhiguo.niu@unisoc.com>

[ Upstream commit 8fb9f31984bdc0aaa1b0f7c7e7a27bd3137f8744 ]

Use F2FS_BYTES_TO_BLK(bytes) and F2FS_BLK_TO_BYTES(blk) for cleanup

Signed-off-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 3273d8ad947d ("f2fs: fix to do cast in F2FS_{BLK_TO_BYTES, BTYES_TO_BLK} to avoid overflow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/checkpoint.c    | 2 +-
 fs/f2fs/debug.c         | 2 +-
 fs/f2fs/file.c          | 6 +++---
 fs/f2fs/node.c          | 4 ++--
 fs/f2fs/super.c         | 2 +-
 include/linux/f2fs_fs.h | 2 +-
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 4184755535553..ee8b29745a5b2 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -1551,7 +1551,7 @@ static int do_checkpoint(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 		blk = start_blk + BLKS_PER_SEG(sbi) - nm_i->nat_bits_blocks;
 		for (i = 0; i < nm_i->nat_bits_blocks; i++)
 			f2fs_update_meta_page(sbi, nm_i->nat_bits +
-					(i << F2FS_BLKSIZE_BITS), blk + i);
+					F2FS_BLK_TO_BYTES(i), blk + i);
 	}
 
 	/* write out checkpoint buffer at block 0 */
diff --git a/fs/f2fs/debug.c b/fs/f2fs/debug.c
index 8b0e1e71b6674..546b8ba912613 100644
--- a/fs/f2fs/debug.c
+++ b/fs/f2fs/debug.c
@@ -275,7 +275,7 @@ static void update_mem_info(struct f2fs_sb_info *sbi)
 	/* build nm */
 	si->base_mem += sizeof(struct f2fs_nm_info);
 	si->base_mem += __bitmap_size(sbi, NAT_BITMAP);
-	si->base_mem += (NM_I(sbi)->nat_bits_blocks << F2FS_BLKSIZE_BITS);
+	si->base_mem += F2FS_BLK_TO_BYTES(NM_I(sbi)->nat_bits_blocks);
 	si->base_mem += NM_I(sbi)->nat_blocks *
 				f2fs_bitmap_size(NAT_ENTRY_PER_BLOCK);
 	si->base_mem += NM_I(sbi)->nat_blocks / 8;
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index b4047d8092890..5f79d49b22bb8 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -3013,9 +3013,9 @@ static int f2fs_move_file_range(struct file *file_in, loff_t pos_in,
 	}
 
 	f2fs_lock_op(sbi);
-	ret = __exchange_data_block(src, dst, pos_in >> F2FS_BLKSIZE_BITS,
-				pos_out >> F2FS_BLKSIZE_BITS,
-				len >> F2FS_BLKSIZE_BITS, false);
+	ret = __exchange_data_block(src, dst, F2FS_BYTES_TO_BLK(pos_in),
+				F2FS_BYTES_TO_BLK(pos_out),
+				F2FS_BYTES_TO_BLK(len), false);
 
 	if (!ret) {
 		if (dst_max_i_size)
diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index b72ef96f7e33a..296cd3a0049a7 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -3166,7 +3166,7 @@ static int __get_nat_bitmaps(struct f2fs_sb_info *sbi)
 
 	nm_i->nat_bits_blocks = F2FS_BLK_ALIGN((nat_bits_bytes << 1) + 8);
 	nm_i->nat_bits = f2fs_kvzalloc(sbi,
-			nm_i->nat_bits_blocks << F2FS_BLKSIZE_BITS, GFP_KERNEL);
+			F2FS_BLK_TO_BYTES(nm_i->nat_bits_blocks), GFP_KERNEL);
 	if (!nm_i->nat_bits)
 		return -ENOMEM;
 
@@ -3185,7 +3185,7 @@ static int __get_nat_bitmaps(struct f2fs_sb_info *sbi)
 		if (IS_ERR(page))
 			return PTR_ERR(page);
 
-		memcpy(nm_i->nat_bits + (i << F2FS_BLKSIZE_BITS),
+		memcpy(nm_i->nat_bits + F2FS_BLK_TO_BYTES(i),
 					page_address(page), F2FS_BLKSIZE);
 		f2fs_put_page(page, 1);
 	}
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index bb892d92c5b26..403b5877c748e 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -3323,7 +3323,7 @@ loff_t max_file_blocks(struct inode *inode)
 	 * fit within U32_MAX + 1 data units.
 	 */
 
-	result = min(result, (((loff_t)U32_MAX + 1) * 4096) >> F2FS_BLKSIZE_BITS);
+	result = min(result, F2FS_BYTES_TO_BLK(((loff_t)U32_MAX + 1) * 4096));
 
 	return result;
 }
diff --git a/include/linux/f2fs_fs.h b/include/linux/f2fs_fs.h
index c68e37201a12a..b0b821edfd97d 100644
--- a/include/linux/f2fs_fs.h
+++ b/include/linux/f2fs_fs.h
@@ -19,7 +19,6 @@
 #define F2FS_BLKSIZE_BITS		PAGE_SHIFT /* bits for F2FS_BLKSIZE */
 #define F2FS_MAX_EXTENSION		64	/* # of extension entries */
 #define F2FS_EXTENSION_LEN		8	/* max size of extension */
-#define F2FS_BLK_ALIGN(x)	(((x) + F2FS_BLKSIZE - 1) >> F2FS_BLKSIZE_BITS)
 
 #define NULL_ADDR		((block_t)0)	/* used as block_t addresses */
 #define NEW_ADDR		((block_t)-1)	/* used as block_t addresses */
@@ -28,6 +27,7 @@
 #define F2FS_BYTES_TO_BLK(bytes)	((bytes) >> F2FS_BLKSIZE_BITS)
 #define F2FS_BLK_TO_BYTES(blk)		((blk) << F2FS_BLKSIZE_BITS)
 #define F2FS_BLK_END_BYTES(blk)		(F2FS_BLK_TO_BYTES(blk + 1) - 1)
+#define F2FS_BLK_ALIGN(x)			(F2FS_BYTES_TO_BLK((x) + F2FS_BLKSIZE - 1))
 
 /* 0, 1(node nid), 2(meta nid) are reserved node id */
 #define F2FS_RESERVED_NODE_NUM		3
-- 
2.43.0



