Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D9324677E
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 15:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753458949; cv=none; b=b4fdig+LNBknPvJhlVixOtVgwpT8mHlPMtRKDQFkqE9m0x0tErLJZmometpiPwk/Y4wIWDdY2ay+zGbfKH4bpbghExNmr4uQShdr2/dU8/7O5+PgsKH8lu6JJa+FYRkKDlK5+4Beac48Xztyze/Qd7fS7jLRIEBnvG0RcgwnTx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753458949; c=relaxed/simple;
	bh=ZNbglygp3HqlxyUhIXQLoGE3vC7qcAz3oDk1ZnhD0OQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=qRn+W3FXFm3Nqco17+XINAVnLTbfLxiBu6yn2h1/FN8eGBHZgMLRbuQ7s/maqV/WmXfW7PXIhbS2l+Y1lIscgdypMbs89b6jH9uM2OH5VnH2p2ipFG9eOH04B9Ynf2+YIuN6u1BSpK0MGDx0UE/zpBHiBR6rckcoF4AatJYFyU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=KnCLzcuH; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="KnCLzcuH"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250725155544epoutp02300a5349325413426b7b1adc44d66c70~ViZ6jCkJc1215412154epoutp02l
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 15:55:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250725155544epoutp02300a5349325413426b7b1adc44d66c70~ViZ6jCkJc1215412154epoutp02l
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1753458944;
	bh=eHJ+QzB7bCnBbwX1a/ip7LbHhQnCIhG/2G0p09gVgzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KnCLzcuH5Pgkb9m3c6n1yvW43nIOSHB4+mpoz0yvyZUC8qz1gtG4+irwpWWnSZWX/
	 9yMB+BYK/3cZAVT84/iJsVNfK2A2ObhrHm2sH+A2GCQoCD2yqZ9NVv5Wb+EqjhT6W2
	 FXJlWLX73SMaMq8g1k7FPQgCEcqZcLoLp0rVBcw8=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250725155544epcas5p3ae87e60c861c096313692e14968e6726~ViZ6Sg_cW2330123301epcas5p34;
	Fri, 25 Jul 2025 15:55:44 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.92]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4bpXXH18H6z3hhT3; Fri, 25 Jul
	2025 15:55:43 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250725155500epcas5p225e5103ea402a715cdde2eefd46af987~ViZRg3Ceg3273532735epcas5p2J;
	Fri, 25 Jul 2025 15:55:00 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250725155459epsmtip2308d459c3ed490fdada14c08fb9ee0b8~ViZQ5wARf0442404424epsmtip2I;
	Fri, 25 Jul 2025 15:54:59 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: mcgrof@kernel.org
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>, Anuj
	Gupta <anuj20.g@samsung.com>
Subject: [PATCH v2 02/15] writeback: add support to initialize and free
 multiple writeback ctxs
Date: Fri, 25 Jul 2025 21:24:08 +0530
Message-Id: <20250725155421.3234-3-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250725155421.3234-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250725155500epcas5p225e5103ea402a715cdde2eefd46af987
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250725155500epcas5p225e5103ea402a715cdde2eefd46af987
References: <20250725155421.3234-1-kundan.kumar@samsung.com>
	<CGME20250725155500epcas5p225e5103ea402a715cdde2eefd46af987@epcas5p2.samsung.com>

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

