Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8063126AE
	for <patches@lists.linux.dev>; Wed, 10 Sep 2025 10:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757499269; cv=none; b=U7A2GEsldPMtWpeNRCu4jnfyD+vq/XuwNp6eqMbhoNOREEewlYmXOvp6AWWiO6IftiuX7jw2DaXZrlBJeP/OyU6GftaoGwMmVynRZyPjqszQzCqczu9HN/uPpnC9zPrVwYlB2mzRqpDV8oO+KW1ayv35D0i5PYOVxLpUaKZaNOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757499269; c=relaxed/simple;
	bh=X2rd5Zb2IvIKz0JsE9x4cnmf7P69eIIdTd/CkptHcqk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=BJLY1r2RnZVq6MkiQpZvfRb1w+zv5WNEwxAFkFMjrt/dt51IMEhk6WeawBS/7jdJOT8vzDyQFcDIMH3AlEYrG05HGz44A16guxI2Gl7KkC2uz4844FfpKV6hQiucPi3ZkgGUqwZy9TUnRtH+maPaD4aN2WQwDX8tVEgTiZvn8Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=dnokA23Z; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="dnokA23Z"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250910101426epoutp019e44104bf7c22d0425e34b1fa40991c2~j5EVmJW9z1477714777epoutp01K
	for <patches@lists.linux.dev>; Wed, 10 Sep 2025 10:14:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250910101426epoutp019e44104bf7c22d0425e34b1fa40991c2~j5EVmJW9z1477714777epoutp01K
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1757499266;
	bh=GmQ9xz+/iNZfnq9q1qnJArF1snFqsr6J/rCXnr93+8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dnokA23ZEgmPZdsoCHmk6ZH328qnYIryeZdueo3f7rpB+C/ZiYbgAr2xZC2iwQ+Nm
	 YYnnpGFoE2yeULiV64ujTvcg5JKwveQIfDUkKIyI7sN3QZ3BsjYmMNaXZ7Bs7XGGNW
	 vzsC6qoAAJqoPLGWCRNU+O50nanif6Mbv802ygZk=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250910101426epcas5p1b9e63e3086206d9644dd442a67e17630~j5EVS825f0086900869epcas5p1x;
	Wed, 10 Sep 2025 10:14:25 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.91]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4cMGkn07gjz2SSKY; Wed, 10 Sep
	2025 10:14:25 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250910101424epcas5p40a4d9947369d661f58ad17815c0bac39~j5ETqHcnM2642326423epcas5p4K;
	Wed, 10 Sep 2025 10:14:24 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250910101423epsmtip16cd6b4c2c05db09f1f58595ea8d48a9e~j5ETEAZDQ2482624826epsmtip1M;
	Wed, 10 Sep 2025 10:14:23 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: mcgrof@kernel.org
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>, Anuj
	Gupta <anuj20.g@samsung.com>
Subject: [PATCH v2 09/16] f2fs: add support in f2fs to handle multiple
 writeback contexts
Date: Wed, 10 Sep 2025 15:42:57 +0530
Message-Id: <20250910101304.2588-10-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250910101304.2588-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250910101424epcas5p40a4d9947369d661f58ad17815c0bac39
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250910101424epcas5p40a4d9947369d661f58ad17815c0bac39
References: <20250910101304.2588-1-kundan.kumar@samsung.com>
	<CGME20250910101424epcas5p40a4d9947369d661f58ad17815c0bac39@epcas5p4.samsung.com>

Add support to handle multiple writeback contexts and check for
dirty_exceeded across all the writeback contexts.

Made a new helper for same.

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/f2fs/node.c              |  4 ++--
 fs/f2fs/segment.h           |  2 +-
 include/linux/backing-dev.h | 18 +++++++++++++++---
 3 files changed, 18 insertions(+), 6 deletions(-)

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
index 59bbb69d300c..bb35f8fa4973 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -51,6 +51,21 @@ static inline bool wb_has_dirty_io(struct bdi_writeback *wb)
 	return test_bit(WB_has_dirty_io, &wb->state);
 }
 
+#define for_each_bdi_wb_ctx(bdi, wbctx) \
+	for (int __i = 0; __i < (bdi)->nr_wb_ctx \
+		&& ((wbctx) = (bdi)->wb_ctx[__i]) != NULL; __i++)
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
@@ -149,9 +164,6 @@ static inline bool mapping_can_writeback(struct address_space *mapping)
 }
 
 #define DEFAULT_WB_CTX 0
-#define for_each_bdi_wb_ctx(bdi, wbctx) \
-	for (int __i = 0; __i < (bdi)->nr_wb_ctx \
-		&& ((wbctx) = (bdi)->wb_ctx[__i]) != NULL; __i++)
 
 static inline struct bdi_writeback_ctx *
 fetch_bdi_writeback_ctx(struct inode *inode)
-- 
2.25.1

