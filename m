Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7330633993
	for <patches@lists.linux.dev>; Thu,  7 Aug 2025 04:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754542712; cv=none; b=gM1CxcPez0lEyrMwAOXHg0/7IOPZ6nybrjuXMgQ8KkeOYEq5YHzJUc4278T71NJWLncWAePQTAy+TVrp4ucdaysFPFavY56ux2dBr/MfaQv3E2q75TMYvET/Hu09Bqlc2oL/n9eAfQ8wXGZMiGiGIc5/pF52yo0+D6RzxZaW1Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754542712; c=relaxed/simple;
	bh=LTtIF7RL41r4cfiERgvJPvwaO0ymvpUyM7RsZGDymAI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=oiMLgnYA1Ax5FVXoVN5HkSEqKmbIDYGLN+gxpfcnLMbRK6jwce2UXQ3UbnFCUNpaf0J3IIfrbjVz+2WXALbFXMIB0wG3e+/5BuXxU6balmU08EAsypOjVlGwg4NU1UbnrOYPaVBd3l+esoEk9Izk41iUoYGG04Dxc4CaHbwzxUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=XSXFt5Ti; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="XSXFt5Ti"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250807045828epoutp04341aa79b7a6c9cb5b77da5f610a03920~ZY0wnLijn1312513125epoutp04O
	for <patches@lists.linux.dev>; Thu,  7 Aug 2025 04:58:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250807045828epoutp04341aa79b7a6c9cb5b77da5f610a03920~ZY0wnLijn1312513125epoutp04O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1754542708;
	bh=NkE5+7gk5cDdpEamuT7ffTsUoBrqke3u2KcHUXLV8q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XSXFt5Ti5j1jUSSniJ6M7F8zKqZeSYEPpSpfAQf20jnh8CQkgBD1POGcUp3iNPq43
	 rQ0ksptw5aeXB2C7NPq8wSxIxXTb3QOcq/N7bilcQsP0ZFWZEid/PEl3IxjTmHCocB
	 8zrLEM7tVNa60c3NePaFYRLkWBZ74iBhWDO58XN8=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250807045827epcas5p145ea62504acc21d1030e249106d2e51e~ZY0wFCcQq1327913279epcas5p10;
	Thu,  7 Aug 2025 04:58:27 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.93]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4byFKt6v0Nz3hhT8; Thu,  7 Aug
	2025 04:58:26 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250807045818epcas5p1d3c078b67a8c79e70a89cd6d8a8d30b2~ZY0nlUdz71327913279epcas5p1m;
	Thu,  7 Aug 2025 04:58:18 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250807045818epsmtip1a6ba8b3395c94862f73d08f14642fb45~ZY0m-XMXW1051310513epsmtip1w;
	Thu,  7 Aug 2025 04:58:18 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: mcgrof@kernel.org
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>, Anuj
	Gupta <anuj20.g@samsung.com>
Subject: [PATCH v2 06/15] writeback: invoke all writeback contexts for
 flusher and dirtytime writeback
Date: Thu,  7 Aug 2025 10:26:57 +0530
Message-Id: <20250807045706.2848-7-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250807045706.2848-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250807045818epcas5p1d3c078b67a8c79e70a89cd6d8a8d30b2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250807045818epcas5p1d3c078b67a8c79e70a89cd6d8a8d30b2
References: <20250807045706.2848-1-kundan.kumar@samsung.com>
	<CGME20250807045818epcas5p1d3c078b67a8c79e70a89cd6d8a8d30b2@epcas5p1.samsung.com>

Modify flusher and dirtytime logic to iterate through all the writeback
contexts.

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/fs-writeback.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 60c7c912c7f3..1df8dd7af048 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -2389,12 +2389,14 @@ static void __wakeup_flusher_threads_bdi(struct backing_dev_info *bdi,
 					 enum wb_reason reason)
 {
 	struct bdi_writeback *wb;
+	struct bdi_writeback_ctx *bdi_wb_ctx;
 
 	if (!bdi_has_dirty_io(bdi))
 		return;
 
-	list_for_each_entry_rcu(wb, &bdi->wb_ctx[0]->wb_list, bdi_node)
-		wb_start_writeback(wb, reason);
+	for_each_bdi_wb_ctx(bdi, bdi_wb_ctx)
+		list_for_each_entry_rcu(wb, &bdi_wb_ctx->wb_list, bdi_node)
+			wb_start_writeback(wb, reason);
 }
 
 void wakeup_flusher_threads_bdi(struct backing_dev_info *bdi,
@@ -2444,15 +2446,17 @@ static DECLARE_DELAYED_WORK(dirtytime_work, wakeup_dirtytime_writeback);
 static void wakeup_dirtytime_writeback(struct work_struct *w)
 {
 	struct backing_dev_info *bdi;
+	struct bdi_writeback_ctx *bdi_wb_ctx;
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(bdi, &bdi_list, bdi_list) {
 		struct bdi_writeback *wb;
 
-		list_for_each_entry_rcu(wb, &bdi->wb_ctx[0]->wb_list,
-					bdi_node)
-			if (!list_empty(&wb->b_dirty_time))
-				wb_wakeup(wb);
+		for_each_bdi_wb_ctx(bdi, bdi_wb_ctx)
+			list_for_each_entry_rcu(wb, &bdi_wb_ctx->wb_list,
+						bdi_node)
+				if (!list_empty(&wb->b_dirty_time))
+					wb_wakeup(wb);
 	}
 	rcu_read_unlock();
 	schedule_delayed_work(&dirtytime_work, dirtytime_expire_interval * HZ);
-- 
2.25.1

