Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6E7341678
	for <patches@lists.linux.dev>; Tue, 13 Jan 2026 09:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768296944; cv=none; b=AR8R7tvWg6fsIRKfNTDNv4pPv0I850AcwBzZGzg0RrwixHCIYJHFtVx/GTDaYXTelUpWQMslBS0vGyYtQSGqc3WFuM/mfqReziflpnM6ogdR6sndMS1o7JFZ5ok65vlX1h4iHH1pzHXLh8QIx3hsObl7Vx4WD7q358npBVa5HE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768296944; c=relaxed/simple;
	bh=3/Z4uHerD2Azm4PUQpd57a/8qOZfnIVXLtE7Hv1WmNQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=uCzmJ91bmhzgSftV6BPD4Mij+WH6b97vQ5iFrm8t01quuns6HF54kNc3CajJkqikQKfL4gOtlP+x3uaCoI4tm2HNRBiV1PxHeferHg1b7AqWv6S/RFblMBbXnbmfcCvSFE5HamfAkjhqP7IxswIvy81rcapDrqKx0smCcBLu/cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=cqt5cGwS; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="cqt5cGwS"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260113093539epoutp03272d64ed06e2455c4f416732e07da5e5~KQLKyDzdp0575405754epoutp03h
	for <patches@lists.linux.dev>; Tue, 13 Jan 2026 09:35:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260113093539epoutp03272d64ed06e2455c4f416732e07da5e5~KQLKyDzdp0575405754epoutp03h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1768296939;
	bh=6v0lih7n9GXk10aAmk2cbiH/nXIUk019UpHfdrpY2kU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cqt5cGwS9FKtNhtsCYlQSn6+AOIsBDGNfrYnPL5JI76excScu2xJml00ofYm8JLOc
	 k80N2SDoj16nCUqaIJVlielTkYVO0KpsWn7DTrtz02A+UF2bTABKbh1vWQuV8qA/Q3
	 jBDyb9JRO6RS8Z+EmNGN5LhjyqTOO76GkEiPJAEo=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260113093539epcas5p2770da039c97e57d812169d3f819754af~KQLKfyaaf1628216282epcas5p2G;
	Tue, 13 Jan 2026 09:35:39 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.88]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4dr3yL6MDwz6B9m6; Tue, 13 Jan
	2026 09:35:38 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260113093538epcas5p199dc8af6e4cd847fc6c9c10cc6c519b2~KQLJKknkC2277022770epcas5p1s;
	Tue, 13 Jan 2026 09:35:38 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260113093537epsmtip2bcc8410a2012ab590fec0fc949ae28f4~KQLIp97oM2766827668epsmtip2F;
	Tue, 13 Jan 2026 09:35:37 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: anuj20.g@samsung.com
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>
Subject: [PATCH 4/6] xfs: tag folios with AG number during buffered write
 via iomap attach hook
Date: Tue, 13 Jan 2026 15:00:48 +0530
Message-Id: <20260113093050.31705-5-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260113093050.31705-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260113093538epcas5p199dc8af6e4cd847fc6c9c10cc6c519b2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260113093538epcas5p199dc8af6e4cd847fc6c9c10cc6c519b2
References: <20260113093050.31705-1-kundan.kumar@samsung.com>
	<CGME20260113093538epcas5p199dc8af6e4cd847fc6c9c10cc6c519b2@epcas5p1.samsung.com>

Use the iomap attach hook to tag folios with their predicted
allocation group at write time. Mapped extents derive AG directly;
delalloc and hole cases use a lightweight predictor.

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/xfs/xfs_iomap.c | 120 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 120 insertions(+)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 2a74f2957341..db9be6a14bfd 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -12,6 +12,9 @@
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
+#include "xfs_alloc.h"
+#include "xfs_ag.h"
+#include "xfs_ag_resv.h"
 #include "xfs_btree.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_bmap.h"
@@ -33,6 +36,8 @@
 #include "xfs_icache.h"
 #include "xfs_zone_alloc.h"
 
+struct xfs_alloc_arg;
+
 #define XFS_ALLOC_ALIGN(mp, off) \
 	(((off) >> mp->m_allocsize_log) << mp->m_allocsize_log)
 
@@ -92,8 +97,123 @@ xfs_iomap_valid(
 	return true;
 }
 
+static xfs_agnumber_t
+xfs_predict_delalloc_agno(const struct xfs_inode *ip, loff_t pos, loff_t len)
+{
+	struct xfs_mount *mp = ip->i_mount;
+	xfs_agnumber_t start_agno, agno, best_agno;
+	struct xfs_perag *pag;
+
+	xfs_extlen_t free, resv, avail;
+	xfs_extlen_t need_fsbs, min_free_fsbs;
+	xfs_extlen_t best_free = 0;
+	xfs_agnumber_t agcount = mp->m_sb.sb_agcount;
+
+	/* RT inodes allocate from the realtime volume */
+	if (XFS_IS_REALTIME_INODE(ip))
+		return XFS_INO_TO_AGNO(mp, ip->i_ino);
+
+	start_agno =  XFS_INO_TO_AGNO(mp, ip->i_ino);
+
+	/*
+	 * size-based minimum free requirement.
+	 * Convert bytes to fsbs and require some slack.
+	 */
+	need_fsbs = XFS_B_TO_FSB(mp, (xfs_fsize_t)len);
+	min_free_fsbs = need_fsbs + max_t(xfs_extlen_t, need_fsbs >> 2, 128);
+
+	/*
+	 * scan AGs starting at start_agno and wrapping.
+	 * Pick the first AG that meets min_free_fsbs after reservations.
+	 * Keep a "best" fallback = maximum (free - resv).
+	 */
+	best_agno = start_agno;
+
+	for (xfs_agnumber_t i = 0; i < agcount; i++) {
+		agno = (start_agno + i) % agcount;
+		pag = xfs_perag_get(mp, agno);
+
+		if (!xfs_perag_initialised_agf(pag))
+			goto next;
+
+		free = READ_ONCE(pag->pagf_freeblks);
+		resv = xfs_ag_resv_needed(pag, XFS_AG_RESV_NONE);
+
+		if (free <= resv)
+			goto next;
+
+		avail = free - resv;
+
+		if (avail >= min_free_fsbs) {
+			xfs_perag_put(pag);
+			return agno;
+		}
+
+		if (avail > best_free) {
+			best_free = avail;
+			best_agno = agno;
+		}
+next:
+		xfs_perag_put(pag);
+	}
+
+	return best_agno;
+}
+
+static inline xfs_agnumber_t xfs_ag_from_iomap(const struct xfs_mount *mp,
+		const struct iomap *iomap,
+		const struct xfs_inode *ip, loff_t pos, size_t len)
+{
+	if (iomap->type == IOMAP_MAPPED || iomap->type == IOMAP_UNWRITTEN) {
+		/* iomap->addr is byte address on device for buffered I/O */
+		xfs_fsblock_t fsb = XFS_BB_TO_FSBT(mp, BTOBB(iomap->addr));
+
+		return XFS_FSB_TO_AGNO(mp, fsb);
+	} else if (iomap->type == IOMAP_HOLE || iomap->type == IOMAP_DELALLOC) {
+		return xfs_predict_delalloc_agno(ip, pos, len);
+	}
+
+	return XFS_INO_TO_AGNO(mp, ip->i_ino);
+}
+
+static void xfs_agp_set(struct xfs_inode *ip, pgoff_t index, u16 agno, u8 type)
+{
+	u32 packed = xfs_agp_pack(agno, type, true);
+
+	/* store as immediate value */
+	xa_store(&ip->i_ag_pmap, index, xa_mk_value(packed), GFP_NOFS);
+
+	/* Mark this AG as having potential dirty work */
+	if (ip->i_ag_dirty_bitmap && agno < ip->i_ag_dirty_bits) {
+		spin_lock(&ip->i_ag_dirty_lock);
+		set_bit(agno, ip->i_ag_dirty_bitmap);
+		spin_unlock(&ip->i_ag_dirty_lock);
+	}
+}
+
+static int
+xfs_iomap_attach_folio(const struct iomap *iomap, struct folio *folio,
+		loff_t pos, size_t len)
+{
+	struct inode *inode;
+	struct xfs_inode *ip;
+	struct xfs_mount *mp;
+	u16 agno;
+
+	inode = folio_mapping(folio)->host;
+	ip = XFS_I(inode);
+	mp = ip->i_mount;
+
+	agno = xfs_ag_from_iomap(mp, iomap, ip, pos, len);
+
+	xfs_agp_set(ip, folio->index, (u16)agno, (u8)iomap->type);
+
+	return 0;
+}
+
 const struct iomap_write_ops xfs_iomap_write_ops = {
 	.iomap_valid		= xfs_iomap_valid,
+	.iomap_attach_folio	= xfs_iomap_attach_folio,
 };
 
 int
-- 
2.25.1

