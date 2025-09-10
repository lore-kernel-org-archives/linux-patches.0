Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23C23126AE
	for <patches@lists.linux.dev>; Wed, 10 Sep 2025 10:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757499272; cv=none; b=YP7+W9Gp44pMQVunzXk7cMxRkqjNj02pTfbFu6yUG3M0P+L+VX9WhwzmMk3rGHWQjj1bKuwJ9bGcXmB0cg1FpVQUAuM/vUcRkUtA17I9bXTJcIqeqK+W/GZKXbLbG2v+oVzOXEVCwNyfOKzuUZSNsCu6qnyn47XzDtDWlN7x/U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757499272; c=relaxed/simple;
	bh=H0hjwizlG5/aNvcAnk5UUz7nd4ngCXSejYV6xaJybu4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=j0X+H8SoUPGf5rwuYk8Q4SHhLtVm5DTKQhzw9nmSbxBe9e4+xHyokOPZMVPLJ4YEZJeJjRbG3ngLJhO1r7BKizs7FtWvg02JE8XaSZQUlwE94GXxWkcPL+vemSSWZoICA5m3zCppmBiUSwcSEVkoCFFf1bQw9DQ4/s+S2OFLYxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=X8cvVaFB; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="X8cvVaFB"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250910101428epoutp01ba43acfce37487383b831bbc8400ff16~j5EYAWbef1477314773epoutp01N
	for <patches@lists.linux.dev>; Wed, 10 Sep 2025 10:14:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250910101428epoutp01ba43acfce37487383b831bbc8400ff16~j5EYAWbef1477314773epoutp01N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1757499268;
	bh=f4H1/QEshFj3EuvekxUaLhBVgOlWrBeHj/CTf/ruk7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X8cvVaFBIbLnN1okVMVIt2h4/RRTnGRRY23okmdZO3XaYeBgfxqlEjKUVPPqa3pxh
	 NDD9/rihShRE+N8xrbOJuTREaxyDwFYzmt5klccHpGaQulPbNSiVNjk80D5VolQS7s
	 Re1Fq6TQaF3xTEQPC+TXyW3r4sS7sfI6QKmhusdo=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20250910101428epcas5p4d8d5c1c387a8afa1ba5c1986fe042871~j5EXc69k32170621706epcas5p46;
	Wed, 10 Sep 2025 10:14:28 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.95]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4cMGkq2jslz6B9m7; Wed, 10 Sep
	2025 10:14:27 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250910101426epcas5p23e302b27d2f7758cfbd228b21437eedb~j5EWLCiNC2618326183epcas5p2k;
	Wed, 10 Sep 2025 10:14:26 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250910101426epsmtip147523cd1a2537eea252350170f6e1d33~j5EViD1gE2359923599epsmtip15;
	Wed, 10 Sep 2025 10:14:26 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: mcgrof@kernel.org
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>, Anuj
	Gupta <anuj20.g@samsung.com>
Subject: [PATCH v2 12/16] nfs: add support in nfs to handle multiple
 writeback contexts
Date: Wed, 10 Sep 2025 15:43:00 +0530
Message-Id: <20250910101304.2588-13-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250910101304.2588-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250910101426epcas5p23e302b27d2f7758cfbd228b21437eedb
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250910101426epcas5p23e302b27d2f7758cfbd228b21437eedb
References: <20250910101304.2588-1-kundan.kumar@samsung.com>
	<CGME20250910101426epcas5p23e302b27d2f7758cfbd228b21437eedb@epcas5p2.samsung.com>

Fetch writeback context to which an inode is affined. Use it to perform
writeback related operations.

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/nfs/internal.h | 3 +--
 fs/nfs/write.c    | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index 953c32576778..40755ef956d3 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -843,8 +843,7 @@ static inline void nfs_folio_mark_unstable(struct folio *folio,
 		 * writeback is happening on the server now.
 		 */
 		node_stat_mod_folio(folio, NR_WRITEBACK, nr);
-		wb_stat_mod(&inode_to_bdi(inode)->wb_ctx[0]->wb,
-			    WB_WRITEBACK, nr);
+		bdi_wb_stat_mod(inode, nr);
 		__mark_inode_dirty(inode, I_DIRTY_DATASYNC);
 	}
 }
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index dbf5de7d6a75..8cb9e643a7f8 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -919,8 +919,7 @@ static void nfs_folio_clear_commit(struct folio *folio)
 		struct inode *inode = folio->mapping->host;
 
 		node_stat_mod_folio(folio, NR_WRITEBACK, -nr);
-		wb_stat_mod(&inode_to_bdi(inode)->wb_ctx[0]->wb,
-			    WB_WRITEBACK, -nr);
+		bdi_wb_stat_mod(inode, -nr);
 	}
 }
 
-- 
2.25.1

