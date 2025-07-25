Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63EFEAD2C
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 15:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753458981; cv=none; b=O3QomP0FPwmWQbMu7MY7P4cXsVhcXqmFMNdK4W4XdGyF5FqhSNdsdrJieV/iy8qZ6f4P/yP5cxcUc9bRAzECfiYFmctWRDtvTWW6KDMvxdLFj+DcWdlKvoJdqdwBS9uAfaVi3aDp8xsHcnHGih1jpgpDtrnSFQM00Jy6Bj4L41Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753458981; c=relaxed/simple;
	bh=BSxaPKuNloUL/cDT7M06s92nsOQVtb5e4t2sIacSZjE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=nem6Af4RJJMGpSZ2rQERbk/K/zO7O6kV2HFtGwg6KBTQiXzy3lXrM9zlSFXYQjBlx9yzb27j6qWm2q7sMSPH8Uv4a3bjat8U3DzJZx/0b6DZWSyBk3WH35zEfXzkQHcIZePZ2Gnl1ZbmsNg2FOcLO14AMuQXsSVRaKVXFEl8FyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=WmrgdZcE; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="WmrgdZcE"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250725155612epoutp0304f569f667570b2edd811a55f9939118~ViaUkQ4AC0926709267epoutp03k
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 15:56:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250725155612epoutp0304f569f667570b2edd811a55f9939118~ViaUkQ4AC0926709267epoutp03k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1753458972;
	bh=4o6oYdxTCDb5MxCwoYrSW6KFwtCZdYzt3XyL1AmnZ98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WmrgdZcEC7S1aUEmUUxzclmCG4tuYuLgzYUzsFGI3PkHgHPGejZysS/wKYP3L8IRq
	 PNeIelbvsA6PzdmhRNuNH1ir1TnfnRMeB1+ggHyF5xytwoYKv2ne4puT1JdWoehOXm
	 W/oAcTJxW8y7CJy3ZrXSgKoxkSzQ2mjKe3VgwohA=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250725155611epcas5p1409cdf77bfd3eef5d516015619a70e4f~ViaUDtonF2299122991epcas5p1h;
	Fri, 25 Jul 2025 15:56:11 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.86]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4bpXXp5mmWz6B9m4; Fri, 25 Jul
	2025 15:56:10 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250725155506epcas5p3db90b1c2f47ed6f67c18825f0a39c51b~ViZXUcNct2330323303epcas5p3E;
	Fri, 25 Jul 2025 15:55:06 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250725155505epsmtip26a888cd1f22c88a16004564641b2fe42~ViZWuS0aa3233232332epsmtip2T;
	Fri, 25 Jul 2025 15:55:05 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: mcgrof@kernel.org
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>, Anuj
	Gupta <anuj20.g@samsung.com>
Subject: [PATCH v2 09/15] f2fs: add support in f2fs to handle multiple
 writeback contexts
Date: Fri, 25 Jul 2025 21:24:15 +0530
Message-Id: <20250725155421.3234-10-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250725155421.3234-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250725155506epcas5p3db90b1c2f47ed6f67c18825f0a39c51b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250725155506epcas5p3db90b1c2f47ed6f67c18825f0a39c51b
References: <20250725155421.3234-1-kundan.kumar@samsung.com>
	<CGME20250725155506epcas5p3db90b1c2f47ed6f67c18825f0a39c51b@epcas5p3.samsung.com>

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

