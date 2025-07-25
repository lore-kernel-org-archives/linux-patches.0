Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D48AD2C
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 15:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753458959; cv=none; b=JgYxS4IPPd+IFa+x9YoRNQzU6tYN5rggcRZsOOfFTUq3zF0eT/W652O/0QYyi5fJbI2jhl2MLrodeF8uvQJZ0wiLshgkb0PLsvRzqxk4lrC8XXPLSY64uUKiAyWQ2JBLxs0nElCP5pdvYgBaQPRdFKSBCrrzDb8358cOUaZh1Bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753458959; c=relaxed/simple;
	bh=uST/0Z4WyrCa6m+ay/OtP5+I15YQGzYPvPpx+OqNUfI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=Z3znK1SCjmUdujk5UdZkwPoG/K2rpbe511GcI4EhUgpo5Eq9btzxd+2uHjaELWxHWWb00OuAswss5uIz5Q6m86DKBemGnKtTRiJUTliFyx6MKSrCDaoxAm4Z+E1xh5Aw8MzLxknNs+/J/oUNYCVWcl7P+zu20urq+WDgvqke7kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=O1UUFBQC; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="O1UUFBQC"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250725155556epoutp0409ed8b61fa2fd3aacf2c0c6e2e6fbfb3~ViaFtX_1S2057820578epoutp04p
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 15:55:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250725155556epoutp0409ed8b61fa2fd3aacf2c0c6e2e6fbfb3~ViaFtX_1S2057820578epoutp04p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1753458956;
	bh=dw8aukTtZ/zLtcfpP/Loa8IeVui1SjSnxag81j1Oaf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O1UUFBQCf+MkRi3UOLppCUpqo0UNQTUOiOQZ4sKYiTXA+Rh24w4y6hrPaJTsz8kdz
	 LnjqpIfAq7RWmWFzPhLa4SXUiNG65tkHaS5q1V5XBuKdRWsaC64Hhl17DTpBtFTdBh
	 UbfCK8d1e5Vdvq6poJ924HZ5Zdia+noKWfzsvF3w=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250725155555epcas5p3b18f2196a53b8c39b8e6da98cacdb502~ViaFTxkEp2330123301epcas5p3M;
	Fri, 25 Jul 2025 15:55:55 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.86]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4bpXXV73tLz2SSKX; Fri, 25 Jul
	2025 15:55:54 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250725155502epcas5p2efb36021968a5693170d87f7440cb356~ViZT_UwHD3273432734epcas5p2U;
	Fri, 25 Jul 2025 15:55:02 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250725155502epsmtip2ea93bb2e93c795391b7aa42d71fe5231~ViZTYk1Gk3233232332epsmtip2R;
	Fri, 25 Jul 2025 15:55:02 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: mcgrof@kernel.org
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>, Anuj
	Gupta <anuj20.g@samsung.com>
Subject: [PATCH v2 05/15] writeback: modify bdi_writeback search logic to
 search across all wb ctxs
Date: Fri, 25 Jul 2025 21:24:11 +0530
Message-Id: <20250725155421.3234-6-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250725155421.3234-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250725155502epcas5p2efb36021968a5693170d87f7440cb356
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250725155502epcas5p2efb36021968a5693170d87f7440cb356
References: <20250725155421.3234-1-kundan.kumar@samsung.com>
	<CGME20250725155502epcas5p2efb36021968a5693170d87f7440cb356@epcas5p2.samsung.com>

Since we have multiple cgwb per bdi, embedded in writeback_ctx now, we
iterate over all of them to find the associated writeback.

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/fs-writeback.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index e065cd606b80..60c7c912c7f3 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1090,7 +1090,8 @@ int cgroup_writeback_by_id(u64 bdi_id, int memcg_id,
 {
 	struct backing_dev_info *bdi;
 	struct cgroup_subsys_state *memcg_css;
-	struct bdi_writeback *wb;
+	struct bdi_writeback *wb = NULL;
+	struct bdi_writeback_ctx *bdi_wb_ctx;
 	struct wb_writeback_work *work;
 	unsigned long dirty;
 	int ret;
@@ -1114,7 +1115,11 @@ int cgroup_writeback_by_id(u64 bdi_id, int memcg_id,
 	 * And find the associated wb.  If the wb isn't there already
 	 * there's nothing to flush, don't create one.
 	 */
-	wb = wb_get_lookup(bdi->wb_ctx[0], memcg_css);
+	for_each_bdi_wb_ctx(bdi, bdi_wb_ctx) {
+		wb = wb_get_lookup(bdi_wb_ctx, memcg_css);
+		if (wb)
+			break;
+	}
 	if (!wb) {
 		ret = -ENOENT;
 		goto out_css_put;
-- 
2.25.1

