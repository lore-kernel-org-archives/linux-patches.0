Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25642AD2C
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 15:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753458965; cv=none; b=lSm1caJ//L0ODbSerz8ecqMFVSNVAF9+Q85bbQHi7nPG5uSGD19MYSbxOtjn8efKGJJcVHMJND2D8iUEUa1u4DVX3BOZp9PSwtk6FGigLWZQrjqXV8fVQrl5qMH3/WNNzuuJEW5piKkEK1IkZPu09Rt1lScMFgnnHhYr0/G7lXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753458965; c=relaxed/simple;
	bh=LTtIF7RL41r4cfiERgvJPvwaO0ymvpUyM7RsZGDymAI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=bSIS7lnzkuoragNhEREIYyer7jfmWvx+xkGafjM3uDMOYLZ1T31pV5ukN4ZEY9EF5XGhgBP5w/wtU86R4dGgg94EcSiY1iDbBniGYtACq93wAtK2bsO0RJvDCwErh/mpHiVzSZ3i75APoStLQ0SbeWg3YSdMZ/8WkVPtKkojtUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ZrZG5CRb; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ZrZG5CRb"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250725155602epoutp0248210090d9b4fd542104d20b37bc8b8f~ViaLXMjNn1051310513epoutp02Z
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 15:56:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250725155602epoutp0248210090d9b4fd542104d20b37bc8b8f~ViaLXMjNn1051310513epoutp02Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1753458962;
	bh=NkE5+7gk5cDdpEamuT7ffTsUoBrqke3u2KcHUXLV8q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZrZG5CRbV/HyLBXnF900WFSSzi9Dl82z738T7EyKJS5OSaPwOh8RvUCciy5UcxT/D
	 hPNHsXzuA/1RJAFIcDVNXS44p4UsDucim8H2E6txKBlTzG4dgopkF0i861/E0rTG5l
	 xLJq5Uw0qNQHlWROKPLqQvLuYGJjmuRGEjTy3boE=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250725155601epcas5p317eac319701142033e4ed722702cb8c6~ViaKitNrp2330323303epcas5p3_;
	Fri, 25 Jul 2025 15:56:01 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.86]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4bpXXc4JSfz2SSKY; Fri, 25 Jul
	2025 15:56:00 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250725155503epcas5p142aea80acbddccf89d040249b183378d~ViZU0t29T2299122991epcas5p1t;
	Fri, 25 Jul 2025 15:55:03 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250725155503epsmtip298e4e52864537caed086a588f463415c~ViZUNmjGW0442404424epsmtip2O;
	Fri, 25 Jul 2025 15:55:03 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: mcgrof@kernel.org
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>, Anuj
	Gupta <anuj20.g@samsung.com>
Subject: [PATCH v2 06/15] writeback: invoke all writeback contexts for
 flusher and dirtytime writeback
Date: Fri, 25 Jul 2025 21:24:12 +0530
Message-Id: <20250725155421.3234-7-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250725155421.3234-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250725155503epcas5p142aea80acbddccf89d040249b183378d
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250725155503epcas5p142aea80acbddccf89d040249b183378d
References: <20250725155421.3234-1-kundan.kumar@samsung.com>
	<CGME20250725155503epcas5p142aea80acbddccf89d040249b183378d@epcas5p1.samsung.com>

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

