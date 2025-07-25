Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E16D2EF29E
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 15:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753458994; cv=none; b=pX25/MZQL0Cq2SOEvIrIrAuO9s1a/PmCnU7YgzAEC4+FckP2b6nnVmnzpHyIhOkr1tbLIWzknOxL2oBqrOXnYiyuIKaw1yZ+71cY0JGBWycmwSdYqSLGsDb8gWg/Cj7TVMjgsPC2rU+XrHFfeQ8NDPKEPqTwELrhgN73cU7vp9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753458994; c=relaxed/simple;
	bh=Vxx6fNUYg64ntQgm7gAVJbZi82Pj1DM/BEXxl09yrZU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=KnS3stGfNCo7Srt8EO4f4JMIBYhweGOp+9DvDHXaFIZilypQEuxxCPBDxoN8Eikbs1pbwsb+HB3yowvPgDcyn2DwSHP+xIxyYNUjiyPgllEC8O3tQ28lt8PGpMLDjof0Cexj2X8lPPHgl2tG5MnQyzp+omwxQQmfV9oCWtS9MoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=AXkArNWN; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="AXkArNWN"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250725155631epoutp024584f460a036ff2ab0b2ef5777c89445~ViamZHoot1051310513epoutp02g
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 15:56:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250725155631epoutp024584f460a036ff2ab0b2ef5777c89445~ViamZHoot1051310513epoutp02g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1753458991;
	bh=7Jj0KwuRPtcL9TvobE+gsu7gadsJiiquV1dPw0ObR14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AXkArNWNRR4SxBMbXrs0Wo+/H6oPxV9fC+btrz28WwixwxrFpeCXuSbF1Pxujm2qD
	 Cc+CC5n9wwgEIYGIrjj66Rsf4KfO/qv9Cwm4MzAR6BGVWTM3CYCzO5q3jULphwyw0Z
	 qLCUy9z9I5ZO87V+H7Nm+DhvZk/5HwAyRf09f+l0=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250725155630epcas5p1fabdd03740c975a4ccdd99baa3448833~VialtyLsZ2299122991epcas5p1p;
	Fri, 25 Jul 2025 15:56:30 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.91]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4bpXY95LYbz6B9m5; Fri, 25 Jul
	2025 15:56:29 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250725155510epcas5p18d4d8948dc80a8324e89746090f27e9f~ViZalYoNv2299522995epcas5p11;
	Fri, 25 Jul 2025 15:55:10 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250725155509epsmtip241f377911f5422421d2af6e56c1230b4~ViZZ-vCVB3057430574epsmtip2Y;
	Fri, 25 Jul 2025 15:55:09 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: mcgrof@kernel.org
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>, Anuj
	Gupta <anuj20.g@samsung.com>
Subject: [PATCH v2 13/15] writeback: set the num of writeback contexts to
 number of online cpus
Date: Fri, 25 Jul 2025 21:24:19 +0530
Message-Id: <20250725155421.3234-14-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250725155421.3234-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250725155510epcas5p18d4d8948dc80a8324e89746090f27e9f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250725155510epcas5p18d4d8948dc80a8324e89746090f27e9f
References: <20250725155421.3234-1-kundan.kumar@samsung.com>
	<CGME20250725155510epcas5p18d4d8948dc80a8324e89746090f27e9f@epcas5p1.samsung.com>

We create N number of writeback contexts, N = number of online cpus. The
inodes gets distributed across different writeback contexts, enabling
parallel writeback.

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 mm/backing-dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 0a772d984ecf..d32b13234cdd 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -1046,7 +1046,7 @@ int bdi_init(struct backing_dev_info *bdi)
 	bdi->min_ratio = 0;
 	bdi->max_ratio = 100 * BDI_RATIO_SCALE;
 	bdi->max_prop_frac = FPROP_FRAC_BASE;
-	bdi->nr_wb_ctx = 1;
+	bdi->nr_wb_ctx = num_online_cpus();
 	bdi->wb_ctx = kcalloc(bdi->nr_wb_ctx,
 				  sizeof(struct bdi_writeback_ctx *),
 				  GFP_KERNEL);
-- 
2.25.1

