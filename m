Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E018B33993
	for <patches@lists.linux.dev>; Thu,  7 Aug 2025 04:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754542700; cv=none; b=s7IHnS9wV+LL6gnxaseA+3WJ0ABN84PtNrzCLic+kR2kBNG2SvEpAq/l3IMzvSNyzNwK3xQUiRDd5mFwBfZEZSc8S1qckfUcGQQaQIer6HRHGsNMTtEShtAiFuBDECrKlZStDKL8/ZfvpakwHxa/2JFCDgzNQueN6eBkr/5Sbm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754542700; c=relaxed/simple;
	bh=4ORzJnEQGYKZ9ZxMzHBMT5zCM8yCtm2WkXJN2Nefab8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=lKptvA24VJc4QrkmCtruufhIzc/PcJxxh1NrWlHIviBZsVyEBYotB7l8ybsENuGUSX8nRlPCDBkQqj4buGi0wVcazyW+dZRuuZwoTfMBbQLpW1HRpK1yQN/taYuc/MwtwcHBXr/pUCaoRoXfAnc5e53/HlixoJoWKRPGqTxRy4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=KYsAFNnE; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="KYsAFNnE"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250807045815epoutp026fd081d987877419ef8917e00b1229c2~ZY0k0pt-G2605226052epoutp02O
	for <patches@lists.linux.dev>; Thu,  7 Aug 2025 04:58:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250807045815epoutp026fd081d987877419ef8917e00b1229c2~ZY0k0pt-G2605226052epoutp02O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1754542695;
	bh=7Fpri/DmmIz0lhNfmDYWM4M9dqrldIQivF7NvztYdbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KYsAFNnEXY62KeQlUuSDQCsuwLtT231uowWxzNiDQG9etamPBE+F3YCxjFOQchesr
	 JrPz9joYr0fEXP2qRYfBGjexctNplbI2+OCFQxfwWLJElTPel0O2IZaI3+p/xqG7ZM
	 xF13YRv7cyHnyshqaeH3rw5bkC4vDGoehchiVNBI=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250807045815epcas5p3ce152a8967a05e69ce44fc0dffd240c4~ZY0kiQMiQ0168901689epcas5p3f;
	Thu,  7 Aug 2025 04:58:15 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.91]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4byFKf4hy3z6B9mP; Thu,  7 Aug
	2025 04:58:14 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250807045809epcas5p132cad164f58109d9cfffbe070f6ea99e~ZY0ej1H-60655906559epcas5p1l;
	Thu,  7 Aug 2025 04:58:09 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250807045808epsmtip1a3f3fcf39e47d296ab8198a17ff86b9a~ZY0d8o2xN1615516155epsmtip1R;
	Thu,  7 Aug 2025 04:58:08 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: mcgrof@kernel.org
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>, Anuj
	Gupta <anuj20.g@samsung.com>
Subject: [PATCH v2 03/15] writeback: link bdi_writeback to its corresponding
 bdi_writeback_ctx
Date: Thu,  7 Aug 2025 10:26:54 +0530
Message-Id: <20250807045706.2848-4-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250807045706.2848-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250807045809epcas5p132cad164f58109d9cfffbe070f6ea99e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250807045809epcas5p132cad164f58109d9cfffbe070f6ea99e
References: <20250807045706.2848-1-kundan.kumar@samsung.com>
	<CGME20250807045809epcas5p132cad164f58109d9cfffbe070f6ea99e@epcas5p1.samsung.com>

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

