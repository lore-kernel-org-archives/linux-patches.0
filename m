Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FA8340A51
	for <patches@lists.linux.dev>; Tue, 13 Jan 2026 09:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768296945; cv=none; b=JWanKvdZCf2QrxnzO5KCE4mK6yLRR8QIXcWAQPvsYLjtLM/4eP/G69+HO8ypF+d1C2xnG2hCO8BVJaurgMYy04Z30ljrxV6XUYqYf3APsreZ6OY6HoIMDWQViJJN3ErPzuHMXTMZGzoi42KT0XFIfKAojyG48dk8TV1URZWMtZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768296945; c=relaxed/simple;
	bh=X1NTbZ4HtgwItf1M0dGUZmKPl1yEOX5dIuYzHBLldhc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=ADnPkn7fPTbI8x12Q0NL7b839goqPhqwzSVaPUjpla7y5Go+0tNk+5ybEydnuooYa1pelAPCEw4PjbPTJ3CyBwkpSL182fqVopBkjpgiSYqfRQj5YumqtRfI1bjLLa9o+CctNWIUIyn4gItKhLX35nX7Xzi7uLrtU1BUrdSs/fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=KhzcHs4d; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="KhzcHs4d"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260113093541epoutp02b329488ffe1c6a913dc0678eb1705876~KQLLxzZc_1749317493epoutp02P
	for <patches@lists.linux.dev>; Tue, 13 Jan 2026 09:35:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260113093541epoutp02b329488ffe1c6a913dc0678eb1705876~KQLLxzZc_1749317493epoutp02P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1768296941;
	bh=JXEc7WYYz0D91lss2sfQ8WHA1SKGfdDKsfd3hEXieV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KhzcHs4dLbAkp/+kD7ZFdQKc/xSNR+ysPF0oqzocHmPyFG6l3/3tdJ3dK/q5CoJMT
	 2q69i+waXEu+mQCbwvRYCUr22CCBIVR761SQEHcrq1NRPc2jj5fwJxWZsWNWqZ3OTN
	 a18+xw4UOCISxjCqoL3iVHrgJpvrJrlScAG78Ovo=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260113093540epcas5p2c87db7c3dff53117adbf562eb32e469d~KQLLYe9Gp1630616306epcas5p2B;
	Tue, 13 Jan 2026 09:35:40 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.88]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4dr3yM6MKlz6B9m5; Tue, 13 Jan
	2026 09:35:39 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260113093539epcas5p2cad66d9ab86c35d9e5e0b14ac59268a8~KQLJ8guRH1108811088epcas5p23;
	Tue, 13 Jan 2026 09:35:39 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260113093538epsmtip2ba548fc57fc78f870761879335dcb52f~KQLJZ71eD2795327953epsmtip2t;
	Tue, 13 Jan 2026 09:35:38 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: anuj20.g@samsung.com
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>
Subject: [PATCH 5/6] xfs: add per-AG writeback workqueue infrastructure
Date: Tue, 13 Jan 2026 15:00:49 +0530
Message-Id: <20260113093050.31705-6-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260113093050.31705-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260113093539epcas5p2cad66d9ab86c35d9e5e0b14ac59268a8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260113093539epcas5p2cad66d9ab86c35d9e5e0b14ac59268a8
References: <20260113093050.31705-1-kundan.kumar@samsung.com>
	<CGME20260113093539epcas5p2cad66d9ab86c35d9e5e0b14ac59268a8@epcas5p2.samsung.com>

Introduce per-AG writeback worker infrastructure at mount time.
This patch adds initialization and teardown only, without changing
writeback behavior.

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/xfs/xfs_aops.c  | 50 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_aops.h  |  3 +++
 fs/xfs/xfs_mount.c |  2 ++
 fs/xfs/xfs_mount.h |  6 ++++++
 fs/xfs/xfs_super.c |  2 ++
 5 files changed, 63 insertions(+)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index a26f79815533..ff5cca0e9060 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -23,6 +23,14 @@
 #include "xfs_zone_alloc.h"
 #include "xfs_rtgroup.h"
 
+struct xfs_ag_wb {
+	struct delayed_work ag_work;
+	spinlock_t lock;
+	struct list_head task_list;
+	xfs_agnumber_t agno;
+	struct xfs_mount *mp;
+};
+
 struct xfs_writepage_ctx {
 	struct iomap_writepage_ctx ctx;
 	unsigned int		data_seq;
@@ -666,6 +674,48 @@ static const struct iomap_writeback_ops xfs_zoned_writeback_ops = {
 	.writeback_submit	= xfs_zoned_writeback_submit,
 };
 
+void
+xfs_init_ag_writeback(struct xfs_mount *mp)
+{
+	xfs_agnumber_t agno;
+
+	mp->m_ag_wq = alloc_workqueue("xfs-ag-wb", WQ_UNBOUND | WQ_MEM_RECLAIM,
+		0);
+	if (!mp->m_ag_wq)
+		return;
+
+	mp->m_ag_wb = kcalloc(mp->m_sb.sb_agcount,
+			      sizeof(struct xfs_ag_wb),
+			      GFP_KERNEL);
+
+	if (!mp->m_ag_wb) {
+		destroy_workqueue(mp->m_ag_wq);
+		mp->m_ag_wq = NULL;
+		return;
+	}
+
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		struct xfs_ag_wb *awb = &mp->m_ag_wb[agno];
+
+		spin_lock_init(&awb->lock);
+		INIT_LIST_HEAD(&awb->task_list);
+		awb->agno = agno;
+		awb->mp = mp;
+	}
+}
+
+void
+xfs_destroy_ag_writeback(struct xfs_mount *mp)
+{
+	if (mp->m_ag_wq) {
+		flush_workqueue(mp->m_ag_wq);
+		destroy_workqueue(mp->m_ag_wq);
+		mp->m_ag_wq = NULL;
+	}
+	kfree(mp->m_ag_wb);
+	mp->m_ag_wb = NULL;
+}
+
 STATIC int
 xfs_vm_writepages(
 	struct address_space	*mapping,
diff --git a/fs/xfs/xfs_aops.h b/fs/xfs/xfs_aops.h
index 5a7a0f1a0b49..e84acb7e8ca8 100644
--- a/fs/xfs/xfs_aops.h
+++ b/fs/xfs/xfs_aops.h
@@ -12,4 +12,7 @@ extern const struct address_space_operations xfs_dax_aops;
 int xfs_setfilesize(struct xfs_inode *ip, xfs_off_t offset, size_t size);
 void xfs_end_bio(struct bio *bio);
 
+void xfs_init_ag_writeback(struct xfs_mount *mp);
+void xfs_destroy_ag_writeback(struct xfs_mount *mp);
+
 #endif /* __XFS_AOPS_H__ */
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index dc32c5e34d81..78cb115e05fe 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1336,6 +1336,8 @@ xfs_unmountfs(
 
 	xfs_qm_unmount(mp);
 
+	xfs_destroy_ag_writeback(mp);
+
 	/*
 	 * Unreserve any blocks we have so that when we unmount we don't account
 	 * the reserved free space as used. This is really only necessary for
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 97de44c32272..7477173fc7b6 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -13,6 +13,7 @@ struct xfs_ail;
 struct xfs_quotainfo;
 struct xfs_da_geometry;
 struct xfs_perag;
+struct xfs_ag_wb;
 
 /* dynamic preallocation free space thresholds, 5% down to 1% */
 enum {
@@ -343,6 +344,11 @@ typedef struct xfs_mount {
 
 	/* Hook to feed dirent updates to an active online repair. */
 	struct xfs_hooks	m_dir_update_hooks;
+
+	/* global XFS AG writeback wq */
+	struct workqueue_struct *m_ag_wq;
+	/* array of [sb_agcount] */
+	struct xfs_ag_wb	*m_ag_wb;
 } xfs_mount_t;
 
 #define M_IGEO(mp)		(&(mp)->m_ino_geo)
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index aa97b59f53c6..5c0fc487badd 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1785,6 +1785,8 @@ xfs_fs_fill_super(
 
 	bdi_inc_writeback(sb->s_bdi, mp->m_sb.sb_agcount);
 
+	xfs_init_ag_writeback(mp);
+
 	/*
 	 * V4 support is undergoing deprecation.
 	 *
-- 
2.25.1

