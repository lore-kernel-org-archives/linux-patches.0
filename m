Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5DD1DB546
	for <patches@lists.linux.dev>; Thu,  7 Aug 2025 04:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754542745; cv=none; b=FelK0nA9Qjgo+hiBjlls750IcpIe9GoDMxpthf5UPDXxAKVxpB8eLyI14lfJ5P+Zitflr0EkHdTz/G0mLEHk0N5Sk0bsrCyZP9lCdZX8kM6htbOD4gynup30YGI/6/fFsNl6Z27VcaT0rY/ZHQ8cwdRPa/npEMu6b5q769Ht8jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754542745; c=relaxed/simple;
	bh=wEzF6zPvBjia0Sjs7p8SKb16yHlPXShEJq3tfzedtik=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=nJIr5jLgj2CQcqoKwTl+Rr7M3eETjRoGku0Ov6NSm/hrXeC67ydcxcjn0cR97s9ARWYGwjnvu3AitsnLv3X6hn9XCHSFoGt17mLt5GI4OfzYILuI4TbNvl/mklKdtDm5c25H4gQNuaRfMTmYL74AtQfrk5M9zEMgXVoD/A+lUrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ewzk+Bbj; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ewzk+Bbj"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250807045901epoutp02f13e1ebba8b8ae2f80f6d1f8984bd645~ZY1PdNL0f2597925979epoutp025
	for <patches@lists.linux.dev>; Thu,  7 Aug 2025 04:59:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250807045901epoutp02f13e1ebba8b8ae2f80f6d1f8984bd645~ZY1PdNL0f2597925979epoutp025
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1754542741;
	bh=24GxEJZkBoqknXDGmlcoHnN49fa9wV3mlQJfnf84Wk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ewzk+Bbj587oK3Ju5FQwFSYotZj6hF5zma4rpY3EQh0YMq+MIn967AY8z75+KE0IN
	 kQUyfHvk3iPsifK17g3N60EjziBhI24ZTCkQxZvtgrSun5WlNMlBmRe5s5RFNpJXCR
	 QDyZ4TBWDp94vu9vAfFfh1c1MdUjJ5F3mip2zDLQ=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250807045901epcas5p253e94cd885ab38efcd683432bc1ade44~ZY1PFEnDS1388013880epcas5p2O;
	Thu,  7 Aug 2025 04:59:01 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.89]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4byFLX1qz1z6B9m9; Thu,  7 Aug
	2025 04:59:00 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250807045837epcas5p29f7f584cdc93a6d4fdf2b974231e8f33~ZY05YlnJ-3181431814epcas5p2-;
	Thu,  7 Aug 2025 04:58:37 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250807045837epsmtip15d9a5520e3175fd49c2716d195ca3807~ZY04xu0901696716967epsmtip1f;
	Thu,  7 Aug 2025 04:58:37 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: mcgrof@kernel.org
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>, Anuj
	Gupta <anuj20.g@samsung.com>
Subject: [PATCH v2 14/15] writeback: segregated allocation and free of
 writeback contexts
Date: Thu,  7 Aug 2025 10:27:05 +0530
Message-Id: <20250807045706.2848-15-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250807045706.2848-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250807045837epcas5p29f7f584cdc93a6d4fdf2b974231e8f33
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250807045837epcas5p29f7f584cdc93a6d4fdf2b974231e8f33
References: <20250807045706.2848-1-kundan.kumar@samsung.com>
	<CGME20250807045837epcas5p29f7f584cdc93a6d4fdf2b974231e8f33@epcas5p2.samsung.com>

The independent functions of alloc and free will be used while changing
the number of writeback contexts.

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 mm/backing-dev.c | 73 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 49 insertions(+), 24 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index d32b13234cdd..392a4eb4a878 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -1038,51 +1038,76 @@ static void cgwb_remove_from_bdi_list(struct bdi_writeback *wb)
 
 #endif	/* CONFIG_CGROUP_WRITEBACK */
 
+static struct bdi_writeback_ctx **wb_ctx_alloc(struct backing_dev_info *bdi,
+					       int num_ctxs)
+{
+	struct bdi_writeback_ctx **wb_ctx;
+
+	wb_ctx = kcalloc(num_ctxs, sizeof(struct bdi_writeback_ctx *),
+			     GFP_KERNEL);
+	if (!wb_ctx)
+		return NULL;
+
+	for (int i = 0; i < num_ctxs; i++) {
+		wb_ctx[i] = (struct bdi_writeback_ctx *)
+			kzalloc(sizeof(struct bdi_writeback_ctx), GFP_KERNEL);
+		if (!wb_ctx[i]) {
+			pr_err("Failed to allocate %d", i);
+			while (--i >= 0)
+				kfree(wb_ctx[i]);
+			kfree(wb_ctx);
+			return NULL;
+		}
+		INIT_LIST_HEAD(&wb_ctx[i]->wb_list);
+		init_waitqueue_head(&wb_ctx[i]->wb_waitq);
+	}
+	return wb_ctx;
+}
+
+static void wb_ctx_free(struct backing_dev_info *bdi)
+{
+	struct bdi_writeback_ctx *bdi_wb_ctx;
+
+	for_each_bdi_wb_ctx(bdi, bdi_wb_ctx) {
+		kfree(bdi_wb_ctx);
+	}
+	kfree(bdi->wb_ctx);
+}
+
 int bdi_init(struct backing_dev_info *bdi)
 {
-	bdi->dev = NULL;
+	int ret;
 
+	bdi->dev = NULL;
 	kref_init(&bdi->refcnt);
 	bdi->min_ratio = 0;
 	bdi->max_ratio = 100 * BDI_RATIO_SCALE;
 	bdi->max_prop_frac = FPROP_FRAC_BASE;
-	bdi->nr_wb_ctx = num_online_cpus();
-	bdi->wb_ctx = kcalloc(bdi->nr_wb_ctx,
-				  sizeof(struct bdi_writeback_ctx *),
-				  GFP_KERNEL);
+
 	INIT_LIST_HEAD(&bdi->bdi_list);
-	for (int i = 0; i < bdi->nr_wb_ctx; i++) {
-		bdi->wb_ctx[i] = (struct bdi_writeback_ctx *)
-			 kzalloc(sizeof(struct bdi_writeback_ctx), GFP_KERNEL);
-		if (!bdi->wb_ctx[i]) {
-			pr_err("Failed to allocate %d", i);
-			while (--i >= 0)
-				kfree(bdi->wb_ctx[i]);
-			kfree(bdi->wb_ctx);
-			return -ENOMEM;
-		}
-		INIT_LIST_HEAD(&bdi->wb_ctx[i]->wb_list);
-		init_waitqueue_head(&bdi->wb_ctx[i]->wb_waitq);
-	}
+	bdi->nr_wb_ctx = num_online_cpus();
+
+	bdi->wb_ctx = wb_ctx_alloc(bdi, bdi->nr_wb_ctx);
+	if (!bdi->wb_ctx)
+		return -ENOMEM;
+
 	bdi->last_bdp_sleep = jiffies;
 
-	return cgwb_bdi_init(bdi);
+	ret = cgwb_bdi_init(bdi);
+	if (ret)
+		wb_ctx_free(bdi);
+	return ret;
 }
 
 struct backing_dev_info *bdi_alloc(int node_id)
 {
 	struct backing_dev_info *bdi;
-	struct bdi_writeback_ctx *bdi_wb_ctx;
 
 	bdi = kzalloc_node(sizeof(*bdi), GFP_KERNEL, node_id);
 	if (!bdi)
 		return NULL;
 
 	if (bdi_init(bdi)) {
-		for_each_bdi_wb_ctx(bdi, bdi_wb_ctx) {
-			kfree(bdi_wb_ctx);
-		}
-		kfree(bdi->wb_ctx);
 		kfree(bdi);
 		return NULL;
 	}
-- 
2.25.1

