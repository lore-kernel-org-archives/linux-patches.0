Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1631B3126A2
	for <patches@lists.linux.dev>; Wed, 10 Sep 2025 10:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757499271; cv=none; b=DmvI7/wYw3gmySEiJWZSePknK+p3v5rcwvB7dLfER3NEorFIYymuvk4NuegTxY83U0apcGN3vuN72co7mhzPj1Hdjy5Lkd1xfTOSo0rVjDJCgfqGCKajMI10vkw3t3FjWST1Xxj8ozaXNfyMEMRzMu9VPGlvBu48Ap0GMOgFGr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757499271; c=relaxed/simple;
	bh=BP8mzYhylWdMnsYvQYVypknrZ9uSeBoVihQuZEj/b/I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=N1vcFjlJ98n7NgEGNMnzJFnoDTQJHx115mqgBPBXoN/4WR5Rpfza/IgrwN4WPEYJOqAZykIFzmCK0j6NJgsM1S70q48+7I9DInO8AttwEc/8ECTuSe7F9d2MfEfeTRSe7zbmorgUyAlP5LvBJN79kHcUhjx1DpZGMEMwp2yZcHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=bwffkY3P; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="bwffkY3P"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250910101428epoutp04c95854a8bba14e174a3106a02ad56a67~j5EXYSRsD1895918959epoutp044
	for <patches@lists.linux.dev>; Wed, 10 Sep 2025 10:14:28 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250910101428epoutp04c95854a8bba14e174a3106a02ad56a67~j5EXYSRsD1895918959epoutp044
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1757499268;
	bh=1t8YilI9ua4Lf4OWYMhjNvUl0HEDiTAE+VtUZXOolsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bwffkY3Po190CEyJ5ggZnH49ehykyh6gELj/FsDDQEqqwi1iuDPqqLl6rgnnSJN3P
	 +A7ny35baug8nx+iiPPs2kl8h5XEuBq54LCcO/3fMCj7G5rUOEdimRxoJ7t9jC7ktC
	 /VoH8MOhZ7NuY7vyNCHT5Oi4Pxp0PmxunyhtgAtc=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20250910101427epcas5p49a08b69ac2e93881c1fa66951e00c676~j5EWo91qt2170621706epcas5p44;
	Wed, 10 Sep 2025 10:14:27 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.93]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4cMGkp3KDPz6B9m8; Wed, 10 Sep
	2025 10:14:26 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250910101426epcas5p4edc2e21ef8786b2d86f43fbbb9850008~j5EVTah7S2170621706epcas5p4z;
	Wed, 10 Sep 2025 10:14:26 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250910101425epsmtip1ccd6e0c9375f2ea4bc48dbfa8ebfe353~j5EUt1Vek2482124821epsmtip1d;
	Wed, 10 Sep 2025 10:14:25 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: mcgrof@kernel.org
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>, Anuj
	Gupta <anuj20.g@samsung.com>
Subject: [PATCH v2 11/16] gfs2: add support in gfs2 to handle multiple
 writeback contexts
Date: Wed, 10 Sep 2025 15:42:59 +0530
Message-Id: <20250910101304.2588-12-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250910101304.2588-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250910101426epcas5p4edc2e21ef8786b2d86f43fbbb9850008
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250910101426epcas5p4edc2e21ef8786b2d86f43fbbb9850008
References: <20250910101304.2588-1-kundan.kumar@samsung.com>
	<CGME20250910101426epcas5p4edc2e21ef8786b2d86f43fbbb9850008@epcas5p4.samsung.com>

Add support to handle multiple writeback contexts and check for
dirty_exceeded across all the writeback contexts

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/gfs2/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index d3f7a11f4ca7..a053202a176a 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -447,7 +447,7 @@ static int gfs2_write_inode(struct inode *inode, struct writeback_control *wbc)
 		gfs2_log_flush(GFS2_SB(inode), ip->i_gl,
 			       GFS2_LOG_HEAD_FLUSH_NORMAL |
 			       GFS2_LFC_WRITE_INODE);
-	if (bdi->wb_ctx[0]->wb.dirty_exceeded)
+	if (bdi_wb_dirty_limit_exceeded(bdi))
 		gfs2_ail1_flush(sdp, wbc);
 	else
 		filemap_fdatawrite(metamapping);
-- 
2.25.1

