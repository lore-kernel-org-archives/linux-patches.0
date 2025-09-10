Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74334219A7D
	for <patches@lists.linux.dev>; Wed, 10 Sep 2025 10:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757499275; cv=none; b=UHrh/ulWwbs+qo7xLtV33VsF28WRBmDpUhJHoya9/cpfppxEnta+BOfTQX+rivSfPd128EFhjHGcWcj8lquMGI7M2fd4X2seyD4I5rCa6AjDVv8/dqqpwHeczXwLp3ULpOkw9VWJ+8DIDOrnpkUYVP1vj90jUX4w3k70a6m0C8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757499275; c=relaxed/simple;
	bh=SO39GGiA3J5zNh5Vr0aeRgvN0ifd1nd1CNPwkI2bAUU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=bvgw87jBbyFRjHkLCcNDn5yBT090x9pKK44ymJhaDtC8Xgksl0lDOtBsyMCK8ZQEdVc3xqwDIsCu/PgSgeW9Yjz6r58tYnMOAdw+bXGJOOBH+ulhQtuQX65ehCPqwLkVMOyG4lmNUD/sliSksGJNr7siWICjBdk9S0ZyR9oihB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=blX1O0OZ; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="blX1O0OZ"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250910101431epoutp03aaef9af1e70df75118ab4bfc85700663~j5EatNmGZ0945709457epoutp03a
	for <patches@lists.linux.dev>; Wed, 10 Sep 2025 10:14:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250910101431epoutp03aaef9af1e70df75118ab4bfc85700663~j5EatNmGZ0945709457epoutp03a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1757499271;
	bh=B1ZlBhO1OXD7aGIBLXLavQWqtxpZ4QhvKIJlBAZ+cRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=blX1O0OZx8uzGqJtt6JQZ7hYQ7es/UjodY+Tlr33kMH172It1kcfc2S8FJi3ZkUtB
	 wJtzgAi+S6jzqL/Mv2cPhcdRVilg1ln7qXXbxPAv8mJK2Y/Lp/GC2kFVJ+Z9QrPN3H
	 G12MfFVz+uS1uPTp1puMq5a/RA7GjUizdSbX+3V4=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250910101431epcas5p26b9562e755c06c4d8989fa36d766d1a0~j5EaU22BU1887218872epcas5p2p;
	Wed, 10 Sep 2025 10:14:31 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.87]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4cMGkt2Hdvz6B9m5; Wed, 10 Sep
	2025 10:14:30 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250910101429epcas5p4fcede537e31ed70db9d4de5b778c96f6~j5EYk1UUX2642326423epcas5p4Y;
	Wed, 10 Sep 2025 10:14:29 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250910101428epsmtip1dd9824db6482817e0cc3796235b0412f~j5EXsUuvM2482624826epsmtip1O;
	Wed, 10 Sep 2025 10:14:28 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: mcgrof@kernel.org
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>, Anuj
	Gupta <anuj20.g@samsung.com>
Subject: [PATCH v2 14/16] writeback: segregated allocation and free of
 writeback contexts
Date: Wed, 10 Sep 2025 15:43:02 +0530
Message-Id: <20250910101304.2588-15-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250910101304.2588-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250910101429epcas5p4fcede537e31ed70db9d4de5b778c96f6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250910101429epcas5p4fcede537e31ed70db9d4de5b778c96f6
References: <20250910101304.2588-1-kundan.kumar@samsung.com>
	<CGME20250910101429epcas5p4fcede537e31ed70db9d4de5b778c96f6@epcas5p4.samsung.com>

The independent functions of alloc and free will be used while changing
the number of writeback contexts.

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 mm/backing-dev.c | 72 ++++++++++++++++++++++++++++++++----------------
 1 file changed, 49 insertions(+), 23 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index bee8da1f872b..0d2018351228 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -1038,8 +1038,46 @@ static void cgwb_remove_from_bdi_list(struct bdi_writeback *wb)
 
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
+	int ret;
+
 	bdi->dev = NULL;
 
 	kref_init(&bdi->refcnt);
@@ -1047,48 +1085,36 @@ int bdi_init(struct backing_dev_info *bdi)
 	bdi->max_ratio = 100 * BDI_RATIO_SCALE;
 	bdi->max_prop_frac = FPROP_FRAC_BASE;
 
+	INIT_LIST_HEAD(&bdi->bdi_list);
+
 	/*
 	 * User or filesystem can configure nr_wb_ctx using the newly
 	 * introduced sysfs knob.
 	 * echo N > /sys/class/bdi/<maj>:<min>/nwritebacks
 	 */
 	bdi->nr_wb_ctx = 1;
-	bdi->wb_ctx = kcalloc(bdi->nr_wb_ctx,
-				  sizeof(struct bdi_writeback_ctx *),
-				  GFP_KERNEL);
-	INIT_LIST_HEAD(&bdi->bdi_list);
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

