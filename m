Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD45533993
	for <patches@lists.linux.dev>; Thu,  7 Aug 2025 04:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754542703; cv=none; b=A94l5bLr8b0ZTvOzUixelBho0ASvipYSJGpwnNfgmIK1GZ5GzxFdWjPQGgHkklVFEjW9nDuvi7M3FfiC/aE7px8ucpgCxNfJfsuhhJbVGH7mVHLQSi8Jj3hAIzvOcTpUPShqNiMJRgwHshTD5AThgWDs9xWWTjdisTJCHvQ2avs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754542703; c=relaxed/simple;
	bh=ZNbglygp3HqlxyUhIXQLoGE3vC7qcAz3oDk1ZnhD0OQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=VfzyiOCxnmfE+zZixZkgT/+IoqC/tEcuZ7C+cbq2JXXUeRHILt7Dj0ljdujXIEWUGm9NM3nps+JQ1gHiXhMKx9hF78R1MSnB5SXf6uqtJo1eHD+I79LT5Nu6PtUj2iYoxgGivNqEMRrJtoDpRNimbHhEf1MV8rWd6KeoaM2KU4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=fZUtbqmM; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="fZUtbqmM"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250807045812epoutp04a994fc9744c5be0e07f75601c85d6d77~ZY0htkP7n1312613126epoutp04B
	for <patches@lists.linux.dev>; Thu,  7 Aug 2025 04:58:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250807045812epoutp04a994fc9744c5be0e07f75601c85d6d77~ZY0htkP7n1312613126epoutp04B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1754542692;
	bh=eHJ+QzB7bCnBbwX1a/ip7LbHhQnCIhG/2G0p09gVgzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fZUtbqmMeK14hIuQy11krbcczv/R0pNSTdGlb+t8L0PqVwCUIFE2XHc0O6CGcdVut
	 5KSke67u3/tx5kQ7vFr9nu8ixxWUMSSqdji7n6IZzMvRRkBwD0z4CWuCBB0NxnwaGl
	 /Ven3Hl+/TaOGO4SO6Yq4EUnVRQxV5tbmg/wbAhg=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250807045812epcas5p2b0f61d5e6d88c6186180ebfffbfaa620~ZY0hOA6Dk2724127241epcas5p2g;
	Thu,  7 Aug 2025 04:58:12 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.86]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4byFKb0BvRz2SSKh; Thu,  7 Aug
	2025 04:58:11 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250807045801epcas5p4599ce34b287af15786d83975e5970bc0~ZY0XAGIll0449304493epcas5p4F;
	Thu,  7 Aug 2025 04:58:01 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250807045800epsmtip11bf17aecf3f2704485876a8cf5ac08c1~ZY0WYkCKZ1636316363epsmtip12;
	Thu,  7 Aug 2025 04:58:00 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: mcgrof@kernel.org
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>, Anuj
	Gupta <anuj20.g@samsung.com>
Subject: [PATCH v2 02/15] writeback: add support to initialize and free
 multiple writeback ctxs
Date: Thu,  7 Aug 2025 10:26:53 +0530
Message-Id: <20250807045706.2848-3-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250807045706.2848-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250807045801epcas5p4599ce34b287af15786d83975e5970bc0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250807045801epcas5p4599ce34b287af15786d83975e5970bc0
References: <20250807045706.2848-1-kundan.kumar@samsung.com>
	<CGME20250807045801epcas5p4599ce34b287af15786d83975e5970bc0@epcas5p4.samsung.com>

Introduce a new macro for_each_bdi_wb_ctx to iterate over multiple
writeback ctxs. Added logic for allocation, init, free, registration
and unregistration of multiple writeback contexts within a bdi.

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 include/linux/backing-dev.h |  4 ++
 mm/backing-dev.c            | 81 +++++++++++++++++++++++++++----------
 2 files changed, 63 insertions(+), 22 deletions(-)

diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 92674543ac8a..951ab5497500 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -148,6 +148,10 @@ static inline bool mapping_can_writeback(struct address_space *mapping)
 	return inode_to_bdi(mapping->host)->capabilities & BDI_CAP_WRITEBACK;
 }
 
+#define for_each_bdi_wb_ctx(bdi, wbctx) \
+	for (int __i = 0; __i < (bdi)->nr_wb_ctx \
+		&& ((wbctx) = (bdi)->wb_ctx[__i]) != NULL; __i++)
+
 static inline struct bdi_writeback_ctx *
 fetch_bdi_writeback_ctx(struct inode *inode)
 {
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 8b7125349f6c..47196d326e16 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -835,17 +835,20 @@ struct bdi_writeback *wb_get_create(struct backing_dev_info *bdi,
 
 static int cgwb_bdi_init(struct backing_dev_info *bdi)
 {
-	int ret;
-	struct bdi_writeback_ctx *bdi_wb_ctx = bdi->wb_ctx[0];
+	int ret = 0;
+	struct bdi_writeback_ctx *bdi_wb_ctx;
 
-	INIT_RADIX_TREE(&bdi_wb_ctx->cgwb_tree, GFP_ATOMIC);
-	mutex_init(&bdi->cgwb_release_mutex);
-	init_rwsem(&bdi_wb_ctx->wb_switch_rwsem);
+	for_each_bdi_wb_ctx(bdi, bdi_wb_ctx) {
+		INIT_RADIX_TREE(&bdi_wb_ctx->cgwb_tree, GFP_ATOMIC);
+		mutex_init(&bdi->cgwb_release_mutex);
+		init_rwsem(&bdi_wb_ctx->wb_switch_rwsem);
 
-	ret = wb_init(&bdi_wb_ctx->wb, bdi, GFP_KERNEL);
-	if (!ret) {
-		bdi_wb_ctx->wb.memcg_css = &root_mem_cgroup->css;
-		bdi_wb_ctx->wb.blkcg_css = blkcg_root_css;
+		ret = wb_init(&bdi_wb_ctx->wb, bdi, GFP_KERNEL);
+		if (!ret) {
+			bdi_wb_ctx->wb.memcg_css = &root_mem_cgroup->css;
+			bdi_wb_ctx->wb.blkcg_css = blkcg_root_css;
+		} else
+			return ret;
 	}
 	return ret;
 }
@@ -992,7 +995,16 @@ subsys_initcall(cgwb_init);
 
 static int cgwb_bdi_init(struct backing_dev_info *bdi)
 {
-	return wb_init(&bdi->wb_ctx[0]->wb, bdi, GFP_KERNEL);
+	struct bdi_writeback_ctx *bdi_wb_ctx;
+
+	for_each_bdi_wb_ctx(bdi, bdi_wb_ctx) {
+		int ret;
+
+		ret = wb_init(&bdi_wb_ctx->wb, bdi, GFP_KERNEL);
+		if (ret)
+			return ret;
+	}
+	return 0;
 }
 
 static void cgwb_bdi_unregister(struct backing_dev_info *bdi,
@@ -1026,10 +1038,19 @@ int bdi_init(struct backing_dev_info *bdi)
 				  sizeof(struct bdi_writeback_ctx *),
 				  GFP_KERNEL);
 	INIT_LIST_HEAD(&bdi->bdi_list);
-	bdi->wb_ctx[0] = (struct bdi_writeback_ctx *)
-			kzalloc(sizeof(struct bdi_writeback_ctx), GFP_KERNEL);
-	INIT_LIST_HEAD(&bdi->wb_ctx[0]->wb_list);
-	init_waitqueue_head(&bdi->wb_ctx[0]->wb_waitq);
+	for (int i = 0; i < bdi->nr_wb_ctx; i++) {
+		bdi->wb_ctx[i] = (struct bdi_writeback_ctx *)
+			 kzalloc(sizeof(struct bdi_writeback_ctx), GFP_KERNEL);
+		if (!bdi->wb_ctx[i]) {
+			pr_err("Failed to allocate %d", i);
+			while (--i >= 0)
+				kfree(bdi->wb_ctx[i]);
+			kfree(bdi->wb_ctx);
+			return -ENOMEM;
+		}
+		INIT_LIST_HEAD(&bdi->wb_ctx[i]->wb_list);
+		init_waitqueue_head(&bdi->wb_ctx[i]->wb_waitq);
+	}
 	bdi->last_bdp_sleep = jiffies;
 
 	return cgwb_bdi_init(bdi);
@@ -1038,13 +1059,16 @@ int bdi_init(struct backing_dev_info *bdi)
 struct backing_dev_info *bdi_alloc(int node_id)
 {
 	struct backing_dev_info *bdi;
+	struct bdi_writeback_ctx *bdi_wb_ctx;
 
 	bdi = kzalloc_node(sizeof(*bdi), GFP_KERNEL, node_id);
 	if (!bdi)
 		return NULL;
 
 	if (bdi_init(bdi)) {
-		kfree(bdi->wb_ctx[0]);
+		for_each_bdi_wb_ctx(bdi, bdi_wb_ctx) {
+			kfree(bdi_wb_ctx);
+		}
 		kfree(bdi->wb_ctx);
 		kfree(bdi);
 		return NULL;
@@ -1109,6 +1133,7 @@ int bdi_register_va(struct backing_dev_info *bdi, const char *fmt, va_list args)
 {
 	struct device *dev;
 	struct rb_node *parent, **p;
+	struct bdi_writeback_ctx *bdi_wb_ctx;
 
 	if (bdi->dev)	/* The driver needs to use separate queues per device */
 		return 0;
@@ -1118,8 +1143,11 @@ int bdi_register_va(struct backing_dev_info *bdi, const char *fmt, va_list args)
 	if (IS_ERR(dev))
 		return PTR_ERR(dev);
 
-	cgwb_bdi_register(bdi, bdi->wb_ctx[0]);
-	set_bit(WB_registered, &bdi->wb_ctx[0]->wb.state);
+	for_each_bdi_wb_ctx(bdi, bdi_wb_ctx) {
+		cgwb_bdi_register(bdi, bdi_wb_ctx);
+		set_bit(WB_registered, &bdi_wb_ctx->wb.state);
+	}
+
 	bdi->dev = dev;
 
 	bdi_debug_register(bdi, dev_name(dev));
@@ -1174,12 +1202,17 @@ static void bdi_remove_from_list(struct backing_dev_info *bdi)
 
 void bdi_unregister(struct backing_dev_info *bdi)
 {
+	struct bdi_writeback_ctx *bdi_wb_ctx;
+
 	timer_delete_sync(&bdi->laptop_mode_wb_timer);
 
 	/* make sure nobody finds us on the bdi_list anymore */
 	bdi_remove_from_list(bdi);
-	wb_shutdown(&bdi->wb_ctx[0]->wb);
-	cgwb_bdi_unregister(bdi, bdi->wb_ctx[0]);
+
+	for_each_bdi_wb_ctx(bdi, bdi_wb_ctx) {
+		wb_shutdown(&bdi_wb_ctx->wb);
+		cgwb_bdi_unregister(bdi, bdi_wb_ctx);
+	}
 
 	/*
 	 * If this BDI's min ratio has been set, use bdi_set_min_ratio() to
@@ -1205,11 +1238,15 @@ static void release_bdi(struct kref *ref)
 {
 	struct backing_dev_info *bdi =
 			container_of(ref, struct backing_dev_info, refcnt);
+	struct bdi_writeback_ctx *bdi_wb_ctx;
 
 	WARN_ON_ONCE(bdi->dev);
-	WARN_ON_ONCE(test_bit(WB_registered, &bdi->wb_ctx[0]->wb.state));
-	wb_exit(&bdi->wb_ctx[0]->wb);
-	kfree(bdi->wb_ctx[0]);
+
+	for_each_bdi_wb_ctx(bdi, bdi_wb_ctx) {
+		WARN_ON_ONCE(test_bit(WB_registered, &bdi_wb_ctx->wb.state));
+		wb_exit(&bdi_wb_ctx->wb);
+		kfree(bdi_wb_ctx);
+	}
 	kfree(bdi->wb_ctx);
 	kfree(bdi);
 }
-- 
2.25.1

