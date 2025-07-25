Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF492EE5FD
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 15:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753458958; cv=none; b=TK1O2N3AE3r95bGeWQrs4lPpozCuvDmHmlKE1kce1U3puCwt+uMjSPd8dN6mdr/zBY+5gdKwOCKJ4gTslG7Pge+kJ6otwvYeDD/FUa7sQ4f+lUF7RNruJe5PyONDiHsFL2zdqosgVDvRPY0otmCg52cCyd6zMdR5OtUDAJIP118=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753458958; c=relaxed/simple;
	bh=4ORzJnEQGYKZ9ZxMzHBMT5zCM8yCtm2WkXJN2Nefab8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=vCq6OiGWQ/ZVs97TZtYE03Cg2gG+yzJGIBaZsN9dIEfyk2hMAzozIYOstVI6zgDb8qoXmcfgN8XzlbO/WTwXpt2NmasyKhfwUt+KyFbSRguBlsgexKarU8TBS2dRN4Jge3FFz3ZmEzYtjixbhzoeReXXjdSNzeH6PMy7r80yIAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=rFJlYShV; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="rFJlYShV"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250725155548epoutp04096ce6c3d21bbe3db02fc0abf44a9d89~ViZ_q4Ywd1890218902epoutp04B
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 15:55:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250725155548epoutp04096ce6c3d21bbe3db02fc0abf44a9d89~ViZ_q4Ywd1890218902epoutp04B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1753458948;
	bh=7Fpri/DmmIz0lhNfmDYWM4M9dqrldIQivF7NvztYdbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rFJlYShVUqaWofmhBNyaWuYktp9RnT4qEfxzJ/QHZyQ20RwObyNHMJBtA6VNYVgNy
	 N9s/u1eAfnUyTsfmTvAfjwcKxHLZNMscroT5LeFLu7rNYQtgeKNNlzg0vYUkAx+Sqq
	 r4CisJw7qXjPaAWQFWJht/SSYbl136HkdLt+42hM=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250725155547epcas5p3300026a236f28e88bdc7ced3248e7049~ViZ9434Om2330323303epcas5p3u;
	Fri, 25 Jul 2025 15:55:47 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.90]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4bpXXM05J6z3hhT3; Fri, 25 Jul
	2025 15:55:47 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250725155501epcas5p1d281c17292ea2fa12e6dcc9c90eee929~ViZSVBPbo0708107081epcas5p1E;
	Fri, 25 Jul 2025 15:55:01 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250725155500epsmtip2ff2910f0252e9f4b5c778ebf57c55473~ViZRvAycJ0442304423epsmtip2P;
	Fri, 25 Jul 2025 15:55:00 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: mcgrof@kernel.org
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>, Anuj
	Gupta <anuj20.g@samsung.com>
Subject: [PATCH v2 03/15] writeback: link bdi_writeback to its corresponding
 bdi_writeback_ctx
Date: Fri, 25 Jul 2025 21:24:09 +0530
Message-Id: <20250725155421.3234-4-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250725155421.3234-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250725155501epcas5p1d281c17292ea2fa12e6dcc9c90eee929
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250725155501epcas5p1d281c17292ea2fa12e6dcc9c90eee929
References: <20250725155421.3234-1-kundan.kumar@samsung.com>
	<CGME20250725155501epcas5p1d281c17292ea2fa12e6dcc9c90eee929@epcas5p1.samsung.com>

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

