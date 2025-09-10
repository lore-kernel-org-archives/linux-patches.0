Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACE930DEBC
	for <patches@lists.linux.dev>; Wed, 10 Sep 2025 10:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757499265; cv=none; b=GK0tKm1I0h3AD6dH052m0ZmWRnGaOj43i+lg+fNa/1/uR1VOs1XRWl2+aIGZSurywzayJrMrWn4WmlxZDPZv1tIhyuUzDt9bn0mJGpLoKrAqNuWIHSYf2gzloqsd8Fak5NdICFkUaMnNDOPSvTzUi7Yyk6+bkAih5KY+lS94YcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757499265; c=relaxed/simple;
	bh=4ORzJnEQGYKZ9ZxMzHBMT5zCM8yCtm2WkXJN2Nefab8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=AA9KjTi7fLw3lhk0iYY1h4kNg9WK81bFmSaxlg1O0YrXsRLEZwVQlfDezkcjhyOKVNHpvkoHk1PU6Vsy0lMoym0XwCEMI37cmT10f3hlhh+K/RWWNmgdGRpcktNGJJPA24YuHa1ZsJbNgmFGDNTbaQ7AlhWAn0eT35ssNMn/cO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=bgBOInR/; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="bgBOInR/"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250910101421epoutp01e54b45cf449187d890b1f23d796cdb36~j5EQpwPUG1477714777epoutp01F
	for <patches@lists.linux.dev>; Wed, 10 Sep 2025 10:14:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250910101421epoutp01e54b45cf449187d890b1f23d796cdb36~j5EQpwPUG1477714777epoutp01F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1757499261;
	bh=7Fpri/DmmIz0lhNfmDYWM4M9dqrldIQivF7NvztYdbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bgBOInR/m1ZE+M5IELxVN93dCPVM5zDMV+rAnXEQ16gKAEIVGO+O8TG+RnpuzF/6S
	 gliP0KPuOxO6fQ+NHRkwheKqkR9VN2W2I/6MOYMHsSKRVUbsEJHD7xT9eqFBsFzXsk
	 QVxDKGQpXCTSGd0M8ImIYJuoZUhmCILsX+CP5FNc=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20250910101420epcas5p49bc1b9cef2022dc679b87e1e09a6a0fc~j5EP7quZA2642326423epcas5p45;
	Wed, 10 Sep 2025 10:14:20 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.92]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4cMGkg21L9z3hhT8; Wed, 10 Sep
	2025 10:14:19 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250910101418epcas5p353a2253bb017f0f85987e18285d92c5e~j5EOopHsN3179931799epcas5p3S;
	Wed, 10 Sep 2025 10:14:18 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250910101418epsmtip1cfca580d4c001137ee70fd7651bc6c7c~j5EOAYQG_2446624466epsmtip1D;
	Wed, 10 Sep 2025 10:14:18 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: mcgrof@kernel.org
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>, Anuj
	Gupta <anuj20.g@samsung.com>
Subject: [PATCH v2 03/16] writeback: link bdi_writeback to its corresponding
 bdi_writeback_ctx
Date: Wed, 10 Sep 2025 15:42:51 +0530
Message-Id: <20250910101304.2588-4-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250910101304.2588-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250910101418epcas5p353a2253bb017f0f85987e18285d92c5e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250910101418epcas5p353a2253bb017f0f85987e18285d92c5e
References: <20250910101304.2588-1-kundan.kumar@samsung.com>
	<CGME20250910101418epcas5p353a2253bb017f0f85987e18285d92c5e@epcas5p3.samsung.com>

Introduce a bdi_writeback_ctx field in bdi_writeback. This helps in
fetching the writeback context from the bdi_writeback.

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 mm/backing-dev.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 47196d326e16..754f2f6c6d7c 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -513,15 +513,16 @@ static void wb_update_bandwidth_workfn(struct work_struct *work)
  */
 #define INIT_BW		(100 << (20 - PAGE_SHIFT))
 
-static int wb_init(struct bdi_writeback *wb, struct backing_dev_info *bdi,
-		   gfp_t gfp)
+static int wb_init(struct bdi_writeback *wb,
+		   struct bdi_writeback_ctx *bdi_wb_ctx,
+		   struct backing_dev_info *bdi, gfp_t gfp)
 {
 	int err;
 
 	memset(wb, 0, sizeof(*wb));
 
 	wb->bdi = bdi;
-	wb->bdi_wb_ctx = bdi->wb_ctx[0];
+	wb->bdi_wb_ctx = bdi_wb_ctx;
 	wb->last_old_flush = jiffies;
 	INIT_LIST_HEAD(&wb->b_dirty);
 	INIT_LIST_HEAD(&wb->b_io);
@@ -698,7 +699,7 @@ static int cgwb_create(struct backing_dev_info *bdi,
 		goto out_put;
 	}
 
-	ret = wb_init(wb, bdi, gfp);
+	ret = wb_init(wb, bdi_wb_ctx, bdi, gfp);
 	if (ret)
 		goto err_free;
 
@@ -843,7 +844,7 @@ static int cgwb_bdi_init(struct backing_dev_info *bdi)
 		mutex_init(&bdi->cgwb_release_mutex);
 		init_rwsem(&bdi_wb_ctx->wb_switch_rwsem);
 
-		ret = wb_init(&bdi_wb_ctx->wb, bdi, GFP_KERNEL);
+		ret = wb_init(&bdi_wb_ctx->wb, bdi_wb_ctx, bdi, GFP_KERNEL);
 		if (!ret) {
 			bdi_wb_ctx->wb.memcg_css = &root_mem_cgroup->css;
 			bdi_wb_ctx->wb.blkcg_css = blkcg_root_css;
@@ -1000,7 +1001,7 @@ static int cgwb_bdi_init(struct backing_dev_info *bdi)
 	for_each_bdi_wb_ctx(bdi, bdi_wb_ctx) {
 		int ret;
 
-		ret = wb_init(&bdi_wb_ctx->wb, bdi, GFP_KERNEL);
+		ret = wb_init(&bdi_wb_ctx->wb, bdi_wb_ctx, bdi, GFP_KERNEL);
 		if (ret)
 			return ret;
 	}
-- 
2.25.1

