Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D270341678
	for <patches@lists.linux.dev>; Tue, 13 Jan 2026 09:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768296947; cv=none; b=qMcLucjoobC57lt5CvVBUAEe5BmHGOPOPsBf0jGmiGLxEZ8vIrTbBUxZXdCCBvkjrhPveCRviZLSDB4EEStxh2BzLqwuPkeCgCd8u5T30ycdGvL7nXt4/ADfXaJdnszUogweN9t3l2L2bW1yiEtNEf0gqCYAz+ylzvwqZfU6ppI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768296947; c=relaxed/simple;
	bh=Sej1ZQX93ATp2dW4HPDjJlSX+7nIiKdIWVmrJYf1SC4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=Cs8G8MYJKqq8xZi2kmO3Ef76IesRGWf0qsZJ40Si0hCUQhiqPz+mRyzQDw3V3y32j88dozWLe41jfW+cibeBB+RrRo4bCm63JxmN3XEwWFYsmGE5ILD4qokqO/aWMFxD9OOAMXKFmLyOd7n9MO3bnaYf/2thQUP7qwer+ZDbd6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=C2G/1+aI; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="C2G/1+aI"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20260113093537epoutp04a0646de67d32dc0d4a3afb80f2cbf467~KQLI_awRb0353303533epoutp04F
	for <patches@lists.linux.dev>; Tue, 13 Jan 2026 09:35:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20260113093537epoutp04a0646de67d32dc0d4a3afb80f2cbf467~KQLI_awRb0353303533epoutp04F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1768296938;
	bh=W2k6j+UDR9hg14nvC+kHMAmrnyKR1B3Q/aTfRmX8bEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C2G/1+aIKVih1a270m47w0YYwKGJbG2df8O4jRJcBBJbXN5+GU389XI4vN1cyusXI
	 r0txEsZv9vBvjddx6BFpX8Hdq2WdaS1GISqYIGm8VQlEznm4awvMbEircdOLOeJ8oQ
	 4Sf78ua9jtoDmvaAETpzGEU7wpoLfB1SxLPfnXj0=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260113093537epcas5p104ad1cb8fdba2068b4c501ab2a231c59~KQLIt2bVr2753527535epcas5p1I;
	Tue, 13 Jan 2026 09:35:37 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.86]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4dr3yK06qSz3hhT8; Tue, 13 Jan
	2026 09:35:37 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260113093536epcas5p44494b80930a25c63d50241b5359a3ea9~KQLHa5YpM3080830808epcas5p4D;
	Tue, 13 Jan 2026 09:35:36 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260113093534epsmtip2d408abad3dc9fff3f494ad645991e9e0~KQLGGny0m2766827668epsmtip2D;
	Tue, 13 Jan 2026 09:35:34 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: anuj20.g@samsung.com
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>
Subject: [PATCH 2/6] xfs: add helpers to pack AG prediction info for
 per-folio tracking
Date: Tue, 13 Jan 2026 15:00:46 +0530
Message-Id: <20260113093050.31705-3-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260113093050.31705-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260113093536epcas5p44494b80930a25c63d50241b5359a3ea9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260113093536epcas5p44494b80930a25c63d50241b5359a3ea9
References: <20260113093050.31705-1-kundan.kumar@samsung.com>
	<CGME20260113093536epcas5p44494b80930a25c63d50241b5359a3ea9@epcas5p4.samsung.com>

Introduce helper routines to pack and unpack AG prediction metadata
for folios. This provides a compact and self-contained representation
for AG tracking.

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/xfs/xfs_iomap.h | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index ebcce7d49446..fdff7ef2d1a7 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -12,6 +12,36 @@ struct xfs_inode;
 struct xfs_bmbt_irec;
 struct xfs_zone_alloc_ctx;
 
+/* pack prediction in a u32 stored in xarray */
+#define XFS_AGP_VALID_SHIFT 31
+#define XFS_AGP_TYPE_SHIFT 24
+#define XFS_AGP_AGNO_MASK 0x0000ffffu
+
+static inline u32 xfs_agp_pack(u16 agno, u8 iomap_type, bool valid)
+{
+	u32 v = (u32)agno & XFS_AGP_AGNO_MASK;
+
+	v |= ((u32)iomap_type) << XFS_AGP_TYPE_SHIFT;
+	if (valid)
+		v |= (1u << XFS_AGP_VALID_SHIFT);
+	return v;
+}
+
+static inline bool xfs_agp_valid(u32 v)
+{
+	return v >> XFS_AGP_VALID_SHIFT;
+}
+
+static inline u16 xfs_agp_agno(u32 v)
+{
+	return (u16)(v & XFS_AGP_AGNO_MASK);
+}
+
+static inline u8 xfs_agp_type(u32 v)
+{
+	return (u8)((v >> XFS_AGP_TYPE_SHIFT) & 0x7f);
+}
+
 int xfs_iomap_write_direct(struct xfs_inode *ip, xfs_fileoff_t offset_fsb,
 		xfs_fileoff_t count_fsb, unsigned int flags,
 		struct xfs_bmbt_irec *imap, u64 *sequence);
-- 
2.25.1

