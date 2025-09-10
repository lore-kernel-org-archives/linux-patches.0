Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE5A313275
	for <patches@lists.linux.dev>; Wed, 10 Sep 2025 10:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757499267; cv=none; b=BkbYQh/8zmYMWD3S5lGN6++mCFjTJJHoFM3gmebLGGkiVI6bLb8fNdKm7SnFyBSg4cmHdr+jN8L516LKVrwH+P32Mhu8KNe+JyifhIDUTIptbU95BXrFuC+mMeiqaLeCcoSoOVN8H9DlksM16Hb1X8JbsVmYWauCu79Dk4ab4Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757499267; c=relaxed/simple;
	bh=LTtIF7RL41r4cfiERgvJPvwaO0ymvpUyM7RsZGDymAI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=eLyCugpBrUURX4s/LCLmZrG0eQpPmwjutoG/5RbKJSahkTGRXH2QXyR1RofiPGhhEZq/eGKbfNpIvBl+5waRBcQVXIjq+sTWfRnzEExSXhQdC4bMfsErR6OTQtER6QNFsXFg/isqNfeqMnwbgjk41/bseL78aXSQZo32TVf3ILM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=COW5BrMP; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="COW5BrMP"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250910101423epoutp0338d19aedb8b755ffd462fb9b7babbceb~j5ETHUTnb0946109461epoutp03V
	for <patches@lists.linux.dev>; Wed, 10 Sep 2025 10:14:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250910101423epoutp0338d19aedb8b755ffd462fb9b7babbceb~j5ETHUTnb0946109461epoutp03V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1757499263;
	bh=NkE5+7gk5cDdpEamuT7ffTsUoBrqke3u2KcHUXLV8q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=COW5BrMP0xlsYT7yI5Vi+XztseR3h7+SxGmQN+T+ZIJxGMKcwJMQcnWkx5h9rdy61
	 4Vd4VqgmfSt57aBb+2MjOyYLI2fTkVo0zzhhU6gbl1xEUuuKBg9pkqBkBv5WgVS55h
	 +Pqp3YoLRzi8IKpLKm9a736Cqo2d2eEaeJkv8ZXM=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250910101423epcas5p23b6f6879a9053304f53cc5561ae7c618~j5ESyPB0H1887218872epcas5p2W;
	Wed, 10 Sep 2025 10:14:23 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.94]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4cMGkk1gNpz6B9m5; Wed, 10 Sep
	2025 10:14:22 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250910101421epcas5p4f7a1f1d01aaf12f743f952a7c8838e6a~j5ERIH9Qa2642326423epcas5p4_;
	Wed, 10 Sep 2025 10:14:21 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250910101420epsmtip11db3a0c0692bd5b0de269382a60666e2~j5EQhAOxf2482624826epsmtip1L;
	Wed, 10 Sep 2025 10:14:20 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: mcgrof@kernel.org
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>, Anuj
	Gupta <anuj20.g@samsung.com>
Subject: [PATCH v2 06/16] writeback: invoke all writeback contexts for
 flusher and dirtytime writeback
Date: Wed, 10 Sep 2025 15:42:54 +0530
Message-Id: <20250910101304.2588-7-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250910101304.2588-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250910101421epcas5p4f7a1f1d01aaf12f743f952a7c8838e6a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250910101421epcas5p4f7a1f1d01aaf12f743f952a7c8838e6a
References: <20250910101304.2588-1-kundan.kumar@samsung.com>
	<CGME20250910101421epcas5p4f7a1f1d01aaf12f743f952a7c8838e6a@epcas5p4.samsung.com>

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

