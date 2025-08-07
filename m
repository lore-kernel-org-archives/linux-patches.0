Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E5C1DB546
	for <patches@lists.linux.dev>; Thu,  7 Aug 2025 04:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754542731; cv=none; b=MzpjummkBo21XRUj3cBkkgpEz43e7l1vKB1RUq1Nv+i5260CLsu7ld9huEnHxFhv6+2motv78///NRk60oBW0UmiehCyh2V/vtS+trB/x26nxRv3LhtuFiAaFkqL8Y8x+QGttfahbChAOR2i5Eg6jR67j2Bo76qxf4deAtr3KSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754542731; c=relaxed/simple;
	bh=BSxaPKuNloUL/cDT7M06s92nsOQVtb5e4t2sIacSZjE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=kx1dk0QFC+nRriVj/lEXtdIJTBB76B4QqJ5GUq/+pua1aIQoccfgp+U5HPB/UAxA91HEWzg9cGiTFFfUxTzD5mwJOuXOs8GIm+H6O6cr0ZFADvnT8or3Lrx31OILTLO9pczdzu9iRVdAbszHWJksXZ6H9vljKqW+rvAdzdeWIUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=n6/Fyw83; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="n6/Fyw83"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250807045847epoutp0426d8dd9c92943cf690530f32a9ea3ea9~ZY1Ca6Q-Q1312513125epoutp04Y
	for <patches@lists.linux.dev>; Thu,  7 Aug 2025 04:58:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250807045847epoutp0426d8dd9c92943cf690530f32a9ea3ea9~ZY1Ca6Q-Q1312513125epoutp04Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1754542727;
	bh=4o6oYdxTCDb5MxCwoYrSW6KFwtCZdYzt3XyL1AmnZ98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n6/Fyw83jxeTE7lgMUyZtm6mUkPqrjU+zo6oqdI1unCd/lKgyW5nDcXOhsra9upAm
	 t4ve9lWwlesGS1P6JgvCLqZu511LILvrbNivd2UqIuS4VurJAiZn3z/+VFLwKEUiBB
	 /8S4237+CtzVdBcAbCfVHhqQLomxNV94aTOS6Qh8=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20250807045847epcas5p414cbe3939717ab0c91d12c00346cd095~ZY1CHNUo70449304493epcas5p48;
	Thu,  7 Aug 2025 04:58:47 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.87]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4byFLG2jz5z3hhTG; Thu,  7 Aug
	2025 04:58:46 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250807045828epcas5p341550e83b1813597d59fdbc4b2f49cb8~ZY0wzoPYF0438104381epcas5p3u;
	Thu,  7 Aug 2025 04:58:28 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250807045828epsmtip1e602d6918383ee0a73619fad91548c5f~ZY0wLihV-1696716967epsmtip1a;
	Thu,  7 Aug 2025 04:58:27 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: mcgrof@kernel.org
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>, Anuj
	Gupta <anuj20.g@samsung.com>
Subject: [PATCH v2 09/15] f2fs: add support in f2fs to handle multiple
 writeback contexts
Date: Thu,  7 Aug 2025 10:27:00 +0530
Message-Id: <20250807045706.2848-10-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250807045706.2848-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250807045828epcas5p341550e83b1813597d59fdbc4b2f49cb8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250807045828epcas5p341550e83b1813597d59fdbc4b2f49cb8
References: <20250807045706.2848-1-kundan.kumar@samsung.com>
	<CGME20250807045828epcas5p341550e83b1813597d59fdbc4b2f49cb8@epcas5p3.samsung.com>

Add support to handle multiple writeback contexts and check for
dirty_exceeded across all the writeback contexts.

Made a new helper for same.

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/f2fs/node.c              |  4 ++--
 fs/f2fs/segment.h           |  2 +-
 include/linux/backing-dev.h | 20 ++++++++++++++++----
 3 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 6c89c8f025c2..8e0220ffea29 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -73,7 +73,7 @@ bool f2fs_available_free_memory(struct f2fs_sb_info *sbi, int type)
 		if (excess_cached_nats(sbi))
 			res = false;
 	} else if (type == DIRTY_DENTS) {
-		if (sbi->sb->s_bdi->wb_ctx[0]->wb.dirty_exceeded)
+		if (bdi_wb_dirty_limit_exceeded(sbi->sb->s_bdi))
 			return false;
 		mem_size = get_pages(sbi, F2FS_DIRTY_DENTS);
 		res = mem_size < ((avail_ram * nm_i->ram_thresh / 100) >> 1);
@@ -114,7 +114,7 @@ bool f2fs_available_free_memory(struct f2fs_sb_info *sbi, int type)
 		res = false;
 #endif
 	} else {
-		if (!sbi->sb->s_bdi->wb_ctx[0]->wb.dirty_exceeded)
+		if (!bdi_wb_dirty_limit_exceeded(sbi->sb->s_bdi))
 			return true;
 	}
 	return res;
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index ca8f8e53c80d..7d13b75c4fdc 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -1000,7 +1000,7 @@ static inline bool sec_usage_check(struct f2fs_sb_info *sbi, unsigned int secno)
  */
 static inline int nr_pages_to_skip(struct f2fs_sb_info *sbi, int type)
 {
-	if (sbi->sb->s_bdi->wb_ctx[0]->wb.dirty_exceeded)
+	if (bdi_wb_dirty_limit_exceeded(sbi->sb->s_bdi))
 		return 0;
 
 	if (type == DATA)
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 6f744aadd83e..831cd9f51162 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -51,6 +51,22 @@ static inline bool wb_has_dirty_io(struct bdi_writeback *wb)
 	return test_bit(WB_has_dirty_io, &wb->state);
 }
 
+#define for_each_bdi_wb_ctx(bdi, wbctx) \
+	for (int __i = 0; __i < (bdi)->nr_wb_ctx \
+		&& ((wbctx) = (bdi)->wb_ctx[__i]) != NULL; __i++)
+
+
+static inline bool bdi_wb_dirty_limit_exceeded(struct backing_dev_info *bdi)
+{
+	struct bdi_writeback_ctx *bdi_wb_ctx;
+
+	for_each_bdi_wb_ctx(bdi, bdi_wb_ctx) {
+		if (bdi_wb_ctx->wb.dirty_exceeded)
+			return true;
+	}
+	return false;
+}
+
 static inline bool bdi_has_dirty_io(struct backing_dev_info *bdi)
 {
 	/*
@@ -148,10 +164,6 @@ static inline bool mapping_can_writeback(struct address_space *mapping)
 	return inode_to_bdi(mapping->host)->capabilities & BDI_CAP_WRITEBACK;
 }
 
-#define for_each_bdi_wb_ctx(bdi, wbctx) \
-	for (int __i = 0; __i < (bdi)->nr_wb_ctx \
-		&& ((wbctx) = (bdi)->wb_ctx[__i]) != NULL; __i++)
-
 static inline struct bdi_writeback_ctx *
 fetch_bdi_writeback_ctx(struct inode *inode)
 {
-- 
2.25.1

