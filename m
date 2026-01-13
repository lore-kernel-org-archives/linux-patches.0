Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA03234167B
	for <patches@lists.linux.dev>; Tue, 13 Jan 2026 09:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768296944; cv=none; b=Uf3qMo/gGaD8XA0CVIibul69vZKImGcVElhHrpP8pK29PxTmxAwJfaXnd/xt6cc5c/NCoHwjk2jEEyvLWxwOB8u6cbGO6GybBag56rxvEAkm/2QyfJVM5v2u9AEeyBaH3Pj5dL0y5GgEeN8wQiZYuBqo9ENd8ksfy93nm9EsR4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768296944; c=relaxed/simple;
	bh=1fBsQUYCo7i2F3J1W00LC+Bh7UG07mYXWYtIKWMX5HI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=AMAQ+2LdrrVhxLVgjsS0+Ki8FYzktL6fKPp4YYRhDnS6znvUnP1HrM1j6GPP2pC6cpU5JENT5UiZjMSixbb+ap5zsDNAfNWNdFC6W38os9j6xnUcm8QdYZ/JwQemdrsA7TVzlYbzTjvTCD89TrEmAfro+og285xirTuALCEVELo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=nvKXBBoB; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="nvKXBBoB"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260113093541epoutp023a2372819aadb72c715cc992a40377cd~KQLMGFzrx1750017500epoutp02M
	for <patches@lists.linux.dev>; Tue, 13 Jan 2026 09:35:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260113093541epoutp023a2372819aadb72c715cc992a40377cd~KQLMGFzrx1750017500epoutp02M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1768296941;
	bh=5ZZwSbBXD3iP83HOt36aK0JzGigNCXxXew3cIDxEBHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nvKXBBoBztTlwwz5aNgOiA0OkgfGS1fTF/UXzsDJlKy8AoAJ3tmZWC8WPCPZYJb+w
	 2A/ukiohgKHZHU0ABCkVACyqsSXwA8qKa15d4tUskXIB6Km0dom71V9JoaFwPZBxID
	 GCaf08dYS/Fy+wbOMx3V0b75VBgaHS3TAqqRaVnA=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260113093541epcas5p2ac06e97267a869a00d65df02719be37c~KQLL2L_Zy1628216282epcas5p2L;
	Tue, 13 Jan 2026 09:35:41 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.88]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4dr3yN2NBFz3hhT3; Tue, 13 Jan
	2026 09:35:40 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20260113093539epcas5p2a0e38b5c59155b7dc107943c7a4be798~KQLKvhGzU1108811088epcas5p25;
	Tue, 13 Jan 2026 09:35:39 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260113093539epsmtip22e8b837429d8e46ec377cf16af74095c~KQLKL8Og52909129091epsmtip2k;
	Tue, 13 Jan 2026 09:35:39 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: anuj20.g@samsung.com
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>
Subject: [PATCH 6/6] xfs: offload writeback by AG using per-inode dirty
 bitmap and per-AG workers
Date: Tue, 13 Jan 2026 15:00:50 +0530
Message-Id: <20260113093050.31705-7-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260113093050.31705-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260113093539epcas5p2a0e38b5c59155b7dc107943c7a4be798
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260113093539epcas5p2a0e38b5c59155b7dc107943c7a4be798
References: <20260113093050.31705-1-kundan.kumar@samsung.com>
	<CGME20260113093539epcas5p2a0e38b5c59155b7dc107943c7a4be798@epcas5p2.samsung.com>

Offload XFS writeback to per-AG workers based on the inode dirty-AG
bitmap. Each worker scans and submits writeback only for folios
belonging to its AG.

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/xfs/xfs_aops.c | 225 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 225 insertions(+)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index ff5cca0e9060..55fbc81baeb1 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -23,6 +23,18 @@
 #include "xfs_zone_alloc.h"
 #include "xfs_rtgroup.h"
 
+#define XFS_AG_TASK_POOL_MIN 1024
+
+static struct kmem_cache *xfs_ag_task_cachep;
+static mempool_t *xfs_ag_task_pool;
+
+struct xfs_ag_wb_task {
+	struct list_head list;
+	struct xfs_inode *ip;
+	struct writeback_control wbc;
+	xfs_agnumber_t agno;
+};
+
 struct xfs_ag_wb {
 	struct delayed_work ag_work;
 	spinlock_t lock;
@@ -674,6 +686,213 @@ static const struct iomap_writeback_ops xfs_zoned_writeback_ops = {
 	.writeback_submit	= xfs_zoned_writeback_submit,
 };
 
+static bool xfs_agp_match(struct xfs_inode *ip, pgoff_t index,
+			  xfs_agnumber_t agno)
+{
+	void *ent;
+	u32 v;
+
+	ent = xa_load(&ip->i_ag_pmap, index);
+	if (!ent)
+		return false;
+	if (!xa_is_value(ent))
+		return false;
+
+	v = xa_to_value(ent);
+	if (!xfs_agp_valid(v))
+		return false;
+
+	return xfs_agp_agno(v) == agno;
+}
+
+static bool xfs_folio_matches_ag(struct folio *folio, xfs_agnumber_t agno)
+{
+	struct xfs_inode *ip = XFS_I(folio_mapping(folio)->host);
+
+	return xfs_agp_match(ip, folio->index, agno);
+}
+
+static int xfs_writepages_ag(struct xfs_inode *ip,
+			     struct writeback_control *wbc,
+			     xfs_agnumber_t agno)
+{
+	struct inode *inode = VFS_I(ip);
+	struct address_space *mapping = inode->i_mapping;
+	struct folio_batch fbatch;
+	int ret = 0;
+	pgoff_t index, end;
+
+	folio_batch_init(&fbatch);
+	index = wbc->range_start >> PAGE_SHIFT;
+	end = wbc->range_end >> PAGE_SHIFT;
+
+	struct xfs_writepage_ctx wpc = {
+		.ctx = {
+			.inode = inode,
+			.wbc = wbc,
+			.ops = &xfs_writeback_ops,
+		},
+	};
+
+	while (index <= end) {
+		int i, nr;
+
+		/* get a batch of DIRTY folios starting at index */
+		nr = filemap_get_folios_tag(mapping, &index, end,
+					    PAGECACHE_TAG_DIRTY, &fbatch);
+		if (!nr)
+			break;
+
+		for (i = 0; i < nr; i++) {
+			struct folio *folio = fbatch.folios[i];
+
+			/* Filter BEFORE locking */
+			if (!xfs_folio_matches_ag(folio, agno))
+				continue;
+
+			folio_lock(folio);
+
+			/*
+			 * Now it's ours: clear dirty and submit.
+			 * This prevents *this AG worker* from seeing it again
+			 * next time.
+			 */
+			if (!folio_clear_dirty_for_io(folio)) {
+				folio_unlock(folio);
+				continue;
+			}
+			xa_erase(&XFS_I(mapping->host)->i_ag_pmap, folio->index);
+
+			ret = iomap_writeback_folio(&wpc.ctx, folio);
+			folio_unlock(folio);
+
+			if (ret) {
+				folio_batch_release(&fbatch);
+				goto out;
+			}
+		}
+
+		folio_batch_release(&fbatch);
+		cond_resched();
+	}
+	if (wpc.ctx.wb_ctx)
+		xfs_writeback_ops.writeback_submit(&wpc.ctx, ret);
+
+out:
+	return ret;
+}
+
+static void xfs_ag_writeback_work(struct work_struct *work)
+{
+	struct xfs_ag_wb *awb = container_of(to_delayed_work(work),
+					     struct xfs_ag_wb, ag_work);
+	for (;;) {
+		struct xfs_ag_wb_task *task;
+		struct inode *inode;
+		struct xfs_inode *ip;
+		int ret;
+
+		spin_lock(&awb->lock);
+		task = list_first_entry_or_null(&awb->task_list,
+						struct xfs_ag_wb_task, list);
+		if (task)
+			list_del_init(&task->list);
+		spin_unlock(&awb->lock);
+
+		if (!task)
+			break;
+
+		ip = task->ip;
+		inode = VFS_I(ip);
+
+		ret = xfs_writepages_ag(ip, &task->wbc, task->agno);
+
+		/*
+		 * If we submit everything for this AG, clear its bit.
+		 */
+		if (ret == 0) {
+			spin_lock(&ip->i_ag_dirty_lock);
+			clear_bit(task->agno, ip->i_ag_dirty_bitmap);
+			spin_unlock(&ip->i_ag_dirty_lock);
+		}
+
+		iput(inode); /* drop igrab */
+		mempool_free(task, xfs_ag_task_pool);
+	}
+}
+
+static int xfs_vm_writepages_offload(struct address_space *mapping,
+				     struct writeback_control *wbc)
+{
+	struct inode *inode = mapping->host;
+	struct xfs_inode *ip = XFS_I(inode);
+	struct xfs_mount *mp = ip->i_mount;
+	unsigned int nlongs;
+	xfs_agnumber_t agno;
+
+	if (!ip->i_ag_dirty_bits)
+		return 0;
+
+	nlongs = BITS_TO_LONGS(ip->i_ag_dirty_bits);
+
+	spin_lock(&ip->i_ag_dirty_lock);
+	for_each_set_bit(agno, ip->i_ag_dirty_bitmap, ip->i_ag_dirty_bits) {
+		struct xfs_ag_wb *awb = &mp->m_ag_wb[agno];
+		struct xfs_ag_wb_task *task;
+
+		task =  mempool_alloc(xfs_ag_task_pool, GFP_NOFS);
+		if (!task)
+			continue;
+
+		INIT_LIST_HEAD(&task->list);
+		task->ip = ip;
+		task->agno = agno;
+		task->wbc = *wbc;
+		igrab(inode); /* worker owns inode ref */
+
+		spin_lock(&awb->lock);
+		list_add_tail(&task->list, &awb->task_list);
+		spin_unlock(&awb->lock);
+
+		mod_delayed_work(mp->m_ag_wq, &awb->ag_work, 0);
+	}
+	spin_unlock(&ip->i_ag_dirty_lock);
+
+	return 0;
+}
+
+static int xfs_ag_task_pool_init(void)
+{
+	if (xfs_ag_task_pool)
+		return 0;
+
+	xfs_ag_task_cachep = kmem_cache_create("xfs_ag_wb_task",
+					       sizeof(struct xfs_ag_wb_task),
+					       0,
+					       SLAB_RECLAIM_ACCOUNT,
+					       NULL);
+	if (!xfs_ag_task_cachep)
+		return -ENOMEM;
+
+	xfs_ag_task_pool = mempool_create_slab_pool(XFS_AG_TASK_POOL_MIN,
+						    xfs_ag_task_cachep);
+	if (!xfs_ag_task_pool) {
+		kmem_cache_destroy(xfs_ag_task_cachep);
+		xfs_ag_task_cachep = NULL;
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+static void xfs_ag_task_pool_destroy(void)
+{
+	mempool_destroy(xfs_ag_task_pool);
+	xfs_ag_task_pool = NULL;
+
+	kmem_cache_destroy(xfs_ag_task_cachep);
+	xfs_ag_task_cachep = NULL;
+}
+
 void
 xfs_init_ag_writeback(struct xfs_mount *mp)
 {
@@ -697,11 +916,13 @@ xfs_init_ag_writeback(struct xfs_mount *mp)
 	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
 		struct xfs_ag_wb *awb = &mp->m_ag_wb[agno];
 
+		INIT_DELAYED_WORK(&awb->ag_work, xfs_ag_writeback_work);
 		spin_lock_init(&awb->lock);
 		INIT_LIST_HEAD(&awb->task_list);
 		awb->agno = agno;
 		awb->mp = mp;
 	}
+	xfs_ag_task_pool_init();
 }
 
 void
@@ -714,6 +935,7 @@ xfs_destroy_ag_writeback(struct xfs_mount *mp)
 	}
 	kfree(mp->m_ag_wb);
 	mp->m_ag_wb = NULL;
+	xfs_ag_task_pool_destroy();
 }
 
 STATIC int
@@ -740,6 +962,9 @@ xfs_vm_writepages(
 			xfs_open_zone_put(xc.open_zone);
 		return error;
 	} else {
+		if (wbc->sync_mode != WB_SYNC_ALL)
+			return xfs_vm_writepages_offload(mapping, wbc);
+
 		struct xfs_writepage_ctx	wpc = {
 			.ctx = {
 				.inode	= mapping->host,
-- 
2.25.1

