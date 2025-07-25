Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF13AD2C
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 15:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753459000; cv=none; b=r/i6AyBOSR0cpjg/oC3MeRRHKMOolV4q+YkPrkTzNZTEMZB1Vt5JFm+KzcvohfrNUDKIdeibWfih7+7GHRiOTnfBkKoxkfqoWyqKjW2N3W51VBitHedaNwKgS7BWYK6/eSmzL2CsYChyVlNaprr0KUMmb9Wwx/Vh5OyOQiMx36U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753459000; c=relaxed/simple;
	bh=UkFdqKngBB9jGBypulFSg6tFW1X0D7qPvftGNqT8iq0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=WAZcoGeNqxz91L4e9XW3fIzoYEe7eCnYsuEB7KJt6WoPyoq8Z3AsopMFkFxwrdjrF1ekRUbb6zg0zzx42C/D2SfzoDq4B2g0ezc+zdFfy8+AdrRJPWwQOZrPa7UyKD1Bj9RAW/q9yp9z2Iq7u7F6A5HlIYEAvjYU5AIvLtNepK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=G7QYLpRc; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="G7QYLpRc"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250725155635epoutp015f66e95b952fc1a765c751676c47f0b3~Viap9hDmU1131611316epoutp01E
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 15:56:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250725155635epoutp015f66e95b952fc1a765c751676c47f0b3~Viap9hDmU1131611316epoutp01E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1753458995;
	bh=fV1S8GoFebaDETtKRoDqufm54UJde7ONktoG/w1UjO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G7QYLpRc84dTH93BrrBI4jpOqhRjHEETIAnIf99mJ+IppVT6ZpZnkbKL6XtyGci10
	 xu9l9g1Nnm88Rn5ppWR7okhgY5MhFuidD8iS75rxiOwUOfN0Bzt4v/LfHErUngHdPL
	 MT2LiMxbdrh/9IgEAwKQcxAJI6zK5xcHkg+aFcC4=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250725155634epcas5p23d798d246e1074d52fafd1b05822e177~Viapd_Hj92501525015epcas5p2T;
	Fri, 25 Jul 2025 15:56:34 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.92]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4bpXYF5klCz2SSKZ; Fri, 25 Jul
	2025 15:56:33 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250725155510epcas5p1a39021270ba9952f9b520f2fcfd2c5ed~ViZbaYQHg2299122991epcas5p13;
	Fri, 25 Jul 2025 15:55:10 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250725155510epsmtip2898c0b7d0f2e44fa41ce634e4062167e~ViZa0GvVH0442404424epsmtip2T;
	Fri, 25 Jul 2025 15:55:10 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: mcgrof@kernel.org
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>, Anuj
	Gupta <anuj20.g@samsung.com>
Subject: [PATCH v2 14/15] writeback: segregated allocation and free of
 writeback contexts
Date: Fri, 25 Jul 2025 21:24:20 +0530
Message-Id: <20250725155421.3234-15-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250725155421.3234-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250725155510epcas5p1a39021270ba9952f9b520f2fcfd2c5ed
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250725155510epcas5p1a39021270ba9952f9b520f2fcfd2c5ed
References: <20250725155421.3234-1-kundan.kumar@samsung.com>
	<CGME20250725155510epcas5p1a39021270ba9952f9b520f2fcfd2c5ed@epcas5p1.samsung.com>

The independent functions of alloc and free will be used while changing
the number of writeback contexts.

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 mm/backing-dev.c | 73 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 47 insertions(+), 26 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index d32b13234cdd..7c6fbf57e7ef 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -1038,51 +1038,72 @@ static void cgwb_remove_from_bdi_list(struct bdi_writeback *wb)
 
 #endif	/* CONFIG_CGROUP_WRITEBACK */
 
-int bdi_init(struct backing_dev_info *bdi)
+static struct bdi_writeback_ctx **wb_ctx_alloc(struct backing_dev_info *bdi,
+					       int num_ctxs)
 {
-	bdi->dev = NULL;
+	struct bdi_writeback_ctx **wb_ctx;
 
-	kref_init(&bdi->refcnt);
-	bdi->min_ratio = 0;
-	bdi->max_ratio = 100 * BDI_RATIO_SCALE;
-	bdi->max_prop_frac = FPROP_FRAC_BASE;
-	bdi->nr_wb_ctx = num_online_cpus();
-	bdi->wb_ctx = kcalloc(bdi->nr_wb_ctx,
-				  sizeof(struct bdi_writeback_ctx *),
-				  GFP_KERNEL);
-	INIT_LIST_HEAD(&bdi->bdi_list);
-	for (int i = 0; i < bdi->nr_wb_ctx; i++) {
-		bdi->wb_ctx[i] = (struct bdi_writeback_ctx *)
-			 kzalloc(sizeof(struct bdi_writeback_ctx), GFP_KERNEL);
-		if (!bdi->wb_ctx[i]) {
+	wb_ctx = kcalloc(num_ctxs, sizeof(struct bdi_writeback_ctx *),
+			     GFP_KERNEL);
+	if (!wb_ctx)
+		return NULL;
+
+	for (int i = 0; i < num_ctxs; i++) {
+		wb_ctx[i] = (struct bdi_writeback_ctx *)
+			kzalloc(sizeof(struct bdi_writeback_ctx), GFP_KERNEL);
+		if (!wb_ctx[i]) {
 			pr_err("Failed to allocate %d", i);
 			while (--i >= 0)
-				kfree(bdi->wb_ctx[i]);
-			kfree(bdi->wb_ctx);
-			return -ENOMEM;
+				kfree(wb_ctx[i]);
+			kfree(wb_ctx);
+			return NULL;
 		}
-		INIT_LIST_HEAD(&bdi->wb_ctx[i]->wb_list);
-		init_waitqueue_head(&bdi->wb_ctx[i]->wb_waitq);
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
 	}
+	kfree(bdi->wb_ctx);
+}
+
+int bdi_init(struct backing_dev_info *bdi)
+{
+	int ret;
+
+	bdi->dev = NULL;
+
+	INIT_LIST_HEAD(&bdi->bdi_list);
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

