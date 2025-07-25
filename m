Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13C42EE614
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 15:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753458991; cv=none; b=XBXpEXAhKFpMdtjDd2odZysAbix1ca0NbabLQZopbusEMEFyBSiRCoJ+pnBRRnGkOf9YfEylcwLpVyBDrzlNOTpEt27FaA0W/dLdH20sKqNf/f7yzL5SVeqnoyMYciIjJZNdBKVGqZiL05omOKXyBxFItPQrOAKxmpZA1u3iKus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753458991; c=relaxed/simple;
	bh=H0hjwizlG5/aNvcAnk5UUz7nd4ngCXSejYV6xaJybu4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=qXcueUJ+1VgmMVD8yf3MuITIGeug/ugd19qq24aY7Hr0s4DeoOaMTByVgyzPkPpWFtOJvzI3Pu5HHnVPO+nTyvciQ6PcZEP4IjLOOTLcWPiAccNq4PGXxY4Fi9ki/HYdotYfq7Ygx/4HVBuCxe2eRXOjfA/N4+FdOFDH5dMtWXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=FAo8Wlkr; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="FAo8Wlkr"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250725155628epoutp04d4c145f80cce6b79cf183e9aeafd7eb7~Viajji4pf2057820578epoutp040
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 15:56:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250725155628epoutp04d4c145f80cce6b79cf183e9aeafd7eb7~Viajji4pf2057820578epoutp040
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1753458988;
	bh=f4H1/QEshFj3EuvekxUaLhBVgOlWrBeHj/CTf/ruk7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FAo8WlkrLk7cS/zGiKyRFuLHh3kd5a5kdr0L+PlPGvcThx6e71znBsyTAljxJS0D5
	 rncyjS4vXjsOVNmKUaVsCxc7cejy3kRrtx/7w1U3VTm1VLmBYU5O9k8W7cCKLg5mPu
	 zmWLNHyHg1WmHtJOLJDgM1UKy1jVvCfgoJCRPuU8=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20250725155627epcas5p415e7590993e53d4787aa8915d9c5ba75~ViajFKdLz2120021200epcas5p45;
	Fri, 25 Jul 2025 15:56:27 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.87]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4bpXY66kmcz3hhT4; Fri, 25 Jul
	2025 15:56:26 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250725155509epcas5p1875d4078e902601aa5807da9f67501e6~ViZZxIQEu2299522995epcas5p10;
	Fri, 25 Jul 2025 15:55:09 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250725155508epsmtip23909ddbc5cc4602dafa6d206f292e329~ViZZLpbMV0442304423epsmtip2U;
	Fri, 25 Jul 2025 15:55:08 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: mcgrof@kernel.org
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>, Anuj
	Gupta <anuj20.g@samsung.com>
Subject: [PATCH v2 12/15] nfs: add support in nfs to handle multiple
 writeback contexts
Date: Fri, 25 Jul 2025 21:24:18 +0530
Message-Id: <20250725155421.3234-13-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250725155421.3234-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250725155509epcas5p1875d4078e902601aa5807da9f67501e6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250725155509epcas5p1875d4078e902601aa5807da9f67501e6
References: <20250725155421.3234-1-kundan.kumar@samsung.com>
	<CGME20250725155509epcas5p1875d4078e902601aa5807da9f67501e6@epcas5p1.samsung.com>

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

