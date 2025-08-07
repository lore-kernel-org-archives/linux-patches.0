Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD01C1E32A2
	for <patches@lists.linux.dev>; Thu,  7 Aug 2025 04:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754542740; cv=none; b=tUPicLjUdLd+BdaZfMkYUgVxGJKgtjt9m+rey2GtOpIl7Jd2o6Y2Q6DgYsqk6uefBp7Pzde4egqeCDo9po38WETOjYFaYAVrB/uc9JEXfytbUv7VnGxR5ljLdf6ukSCL16kTJX6SHHCa1b97q6GWOPF1valKFH/BF1w7ea6kfCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754542740; c=relaxed/simple;
	bh=H0hjwizlG5/aNvcAnk5UUz7nd4ngCXSejYV6xaJybu4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=UYnFmPaQlpG0UMVNj9IUbw8ICrYRvwEXI94T1ryd+wCrkZA46CHNcz4c2r95ZwUljWk3rLz16+5B2UAc8x78shN28Mq+nQRozhm+ismPgOOo4NZK8Q75MCtFtwXZNH6LyxtHnqDeJMd+Q4f4yz2bLjm0TxrbhUqrHFc2HhIIK9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=QUyQPbSJ; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="QUyQPbSJ"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250807045857epoutp03d4cb584ee84ab90c2d953e1b92af0f0d~ZY1LLmJ351449414494epoutp03h
	for <patches@lists.linux.dev>; Thu,  7 Aug 2025 04:58:57 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250807045857epoutp03d4cb584ee84ab90c2d953e1b92af0f0d~ZY1LLmJ351449414494epoutp03h
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1754542737;
	bh=f4H1/QEshFj3EuvekxUaLhBVgOlWrBeHj/CTf/ruk7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QUyQPbSJycg5vkvn/l7LKfYGyKyBXOybu34CM3d5MfRUrWBTy3T5wIg4TWRPkSf7B
	 Al+BbHilvpRiVcf9Cg4gRgVsWmhm8BRh3c4ghctB91yLPWZeqsuO+JraRm4yYS90zE
	 NQY9jjwrFHocK6rLjTWl4jBkAKgaQMXo3iY8N5WY=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20250807045856epcas5p4b83f340d6207de07d70bc1fce0937ae5~ZY1K06muP0966209662epcas5p4F;
	Thu,  7 Aug 2025 04:58:56 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.95]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4byFLR4ryVz3hhTK; Thu,  7 Aug
	2025 04:58:55 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250807045834epcas5p1fe47c945f2f06eb0dd7115a211687551~ZY02jnEI52146921469epcas5p1H;
	Thu,  7 Aug 2025 04:58:34 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250807045834epsmtip16815804072a369f2441c8ed9b52bb3ce~ZY019xMLf1580815808epsmtip1a;
	Thu,  7 Aug 2025 04:58:34 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: mcgrof@kernel.org
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>, Anuj
	Gupta <anuj20.g@samsung.com>
Subject: [PATCH v2 12/15] nfs: add support in nfs to handle multiple
 writeback contexts
Date: Thu,  7 Aug 2025 10:27:03 +0530
Message-Id: <20250807045706.2848-13-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250807045706.2848-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250807045834epcas5p1fe47c945f2f06eb0dd7115a211687551
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250807045834epcas5p1fe47c945f2f06eb0dd7115a211687551
References: <20250807045706.2848-1-kundan.kumar@samsung.com>
	<CGME20250807045834epcas5p1fe47c945f2f06eb0dd7115a211687551@epcas5p1.samsung.com>

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

