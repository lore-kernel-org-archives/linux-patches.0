Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13ABA32ABC2
	for <patches@lists.linux.dev>; Tue, 13 Jan 2026 09:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768296943; cv=none; b=lptoaX7qx6YZetxz+YDpGA6KzH8dtcqRVF1owQracOxZ0aukcwXa7D67r74nfIGxMOXoxFZgFAMxmgOJSnLEY3TjwSDSrmtmmfZ//sh8RzjwZSLM0GqEyYQFuNdTGte/ih7RQSa42V+46mHIU0ukpXSnn/caXiEyLFMlqAJtto8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768296943; c=relaxed/simple;
	bh=pdiTq/LCxaBT+dwSw53OlzThvnrplFEU+HnRcyhsM+w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=sze04LGifMdH35jf3RpZbSrrm3fOBFcOMQzMjhf2+hj1HiTd61yLEJjzd5HudwTOzVDXiYe++u4fxlEf0IIymE9NcZaklzZANDJRk3HFFVhewUyJPY5xs6SRjqjyHs+OyvPGPtW+iQu3prZyegBBhmScIZU6fA+MaoKWQbDr/r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=oDyTBFdV; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="oDyTBFdV"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260113093539epoutp01d6b49046ff9a0c05c2cf6f41ecd2306f~KQLKx2LRX2459224592epoutp014
	for <patches@lists.linux.dev>; Tue, 13 Jan 2026 09:35:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260113093539epoutp01d6b49046ff9a0c05c2cf6f41ecd2306f~KQLKx2LRX2459224592epoutp014
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1768296939;
	bh=jhI5aV4ejfRSNCpLlciaRb3sXDKepdfXZxhyRyP1K44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oDyTBFdVirzGxFrHb1ZVbCUr1IC7hczJzIx7cmvknMhzt0EB5A/dEBLjjZ9y52PIY
	 omFZchO0PbeZHQ4+V8gEHFxQwgE5OEMNWdM5pHaa2qg+hp7BP2xulroLmaRF8qUE8j
	 hXo3tLFKIZrNPaXCwcLq8Exvx3JxWbFlIfAKCYMU=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260113093539epcas5p408d27ffc45ee3ca15eccabf12a755b90~KQLKScose2181921819epcas5p4-;
	Tue, 13 Jan 2026 09:35:39 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.89]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4dr3yL4HlDz2SSKf; Tue, 13 Jan
	2026 09:35:38 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20260113093537epcas5p38a82c0bf6996f486fabf96a8dc28c9a6~KQLIgRlIZ2158821588epcas5p3B;
	Tue, 13 Jan 2026 09:35:37 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260113093536epsmtip257c06392d4a058cdd559ec5f02581aae~KQLH6TAOv2772127721epsmtip2c;
	Tue, 13 Jan 2026 09:35:36 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: anuj20.g@samsung.com
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>
Subject: [PATCH 3/6] xfs: add per-inode AG prediction map and dirty-AG
 bitmap
Date: Tue, 13 Jan 2026 15:00:47 +0530
Message-Id: <20260113093050.31705-4-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260113093050.31705-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260113093537epcas5p38a82c0bf6996f486fabf96a8dc28c9a6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260113093537epcas5p38a82c0bf6996f486fabf96a8dc28c9a6
References: <20260113093050.31705-1-kundan.kumar@samsung.com>
	<CGME20260113093537epcas5p38a82c0bf6996f486fabf96a8dc28c9a6@epcas5p3.samsung.com>

Add per-inode structures to track predicted AGs of dirty folios using
an xarray and bitmap. This enables efficient identification of AGs
involved in writeback.

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/xfs/xfs_icache.c | 26 ++++++++++++++++++++++++++
 fs/xfs/xfs_inode.h  |  6 ++++++
 2 files changed, 32 insertions(+)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 4cf7abe50143..f3ca3bc3e017 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -80,6 +80,24 @@ static inline xa_mark_t ici_tag_to_mark(unsigned int tag)
 	return XFS_PERAG_BLOCKGC_MARK;
 }
 
+static int xfs_inode_init_ag_bitmap(struct xfs_inode *ip)
+{
+	unsigned int bits = ip->i_mount->m_sb.sb_agcount;
+	unsigned int nlongs;
+
+	xa_init_flags(&ip->i_ag_pmap, XA_FLAGS_LOCK_IRQ);
+	ip->i_ag_dirty_bitmap = NULL;
+	ip->i_ag_dirty_bits = bits;
+
+	spin_lock_init(&ip->i_ag_dirty_lock);
+	if (!bits)
+		return 0;
+
+	nlongs = BITS_TO_LONGS(bits);
+	ip->i_ag_dirty_bitmap = kcalloc(nlongs, sizeof(unsigned long), GFP_NOFS);
+	return ip->i_ag_dirty_bitmap ? 0 : -ENOMEM;
+}
+
 /*
  * Allocate and initialise an xfs_inode.
  */
@@ -131,6 +149,8 @@ xfs_inode_alloc(
 	ip->i_next_unlinked = NULLAGINO;
 	ip->i_prev_unlinked = 0;
 
+	xfs_inode_init_ag_bitmap(ip);
+
 	return ip;
 }
 
@@ -194,6 +214,12 @@ xfs_inode_free(
 	ip->i_ino = 0;
 	spin_unlock(&ip->i_flags_lock);
 
+	/* free xarray contents (values are immediate packed ints) */
+	xa_destroy(&ip->i_ag_pmap);
+	kfree(ip->i_ag_dirty_bitmap);
+	ip->i_ag_dirty_bitmap = NULL;
+	ip->i_ag_dirty_bits = 0;
+
 	__xfs_inode_free(ip);
 }
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index bd6d33557194..7fd55b5bb979 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -99,6 +99,12 @@ typedef struct xfs_inode {
 	spinlock_t		i_ioend_lock;
 	struct work_struct	i_ioend_work;
 	struct list_head	i_ioend_list;
+
+	/* AG prediction map: pgoff_t -> packed u32 */
+	struct xarray           i_ag_pmap;
+	unsigned long           *i_ag_dirty_bitmap;
+	unsigned int            i_ag_dirty_bits;
+	spinlock_t              i_ag_dirty_lock;
 } xfs_inode_t;
 
 static inline bool xfs_inode_on_unlinked_list(const struct xfs_inode *ip)
-- 
2.25.1

