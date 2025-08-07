Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE3E1E32A2
	for <patches@lists.linux.dev>; Thu,  7 Aug 2025 04:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754542737; cv=none; b=nYADUnkMjx1mLDshnd5c0nf8A6Zq5hzPfLIjV2xZZdYQ4hkZdXbAvSFX1ZudBcMA3ZyiSDoIsG/bXHDTJHJfFE4FiHS+X6eaTNCd9/NS4iPuI5lxu7iq6rvazl/vreYyNo+jh3n+liCyc3Z3V8oMa+8p7Ap9C9MU24zRG+IFEG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754542737; c=relaxed/simple;
	bh=BP8mzYhylWdMnsYvQYVypknrZ9uSeBoVihQuZEj/b/I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=bK3FfZA070fmv+InANbPBR+BkueK5n2xac+S/DiaMmPOmOV+z6Au8BqnS3yTtgbBnt4mQjMZ7nVtZU9TYDVZLvlXEzvBkLresKaURSeFGvstWqJWZnSSjb9roxSfesYpUQNVktovaz66LvUq1Y3uDIG9nl7QKm5pg6VXNjCEb5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=D+sEIF7u; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="D+sEIF7u"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250807045854epoutp049a101e406d76af43ae5366116aa62978~ZY1I226GB1209512095epoutp044
	for <patches@lists.linux.dev>; Thu,  7 Aug 2025 04:58:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250807045854epoutp049a101e406d76af43ae5366116aa62978~ZY1I226GB1209512095epoutp044
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1754542734;
	bh=1t8YilI9ua4Lf4OWYMhjNvUl0HEDiTAE+VtUZXOolsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D+sEIF7uAeacN+dzpCuUEO6ojU7sgRDvLhpNcHwl27ZFm7WwR325Wue/g9u60wd2j
	 fGDVJ95Nh1KN/DGIjSRdxj9BqsJnMVLd1ZXpNQ2WJxJLyd8Fi+AgfA/2yHQVtqPitr
	 JhyA0mBNLcExMwvsz6NyUzLq/W2r9ewLocgbDn+k=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250807045854epcas5p1b3e6b84626ddc776b1682eca6cdf5890~ZY1IXOM0H1327913279epcas5p1A;
	Thu,  7 Aug 2025 04:58:54 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.90]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4byFLN6QCFz6B9mK; Thu,  7 Aug
	2025 04:58:52 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250807045833epcas5p153b701152376a0fbdd53865d3e7c04e2~ZY01DNgPL2146921469epcas5p1E;
	Thu,  7 Aug 2025 04:58:33 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250807045832epsmtip1bd766cab300213b7752d9cfe53b2ab65~ZY00cUGZt1580815808epsmtip1Z;
	Thu,  7 Aug 2025 04:58:32 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: mcgrof@kernel.org
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>, Anuj
	Gupta <anuj20.g@samsung.com>
Subject: [PATCH v2 11/15] gfs2: add support in gfs2 to handle multiple
 writeback contexts
Date: Thu,  7 Aug 2025 10:27:02 +0530
Message-Id: <20250807045706.2848-12-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250807045706.2848-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250807045833epcas5p153b701152376a0fbdd53865d3e7c04e2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250807045833epcas5p153b701152376a0fbdd53865d3e7c04e2
References: <20250807045706.2848-1-kundan.kumar@samsung.com>
	<CGME20250807045833epcas5p153b701152376a0fbdd53865d3e7c04e2@epcas5p1.samsung.com>

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

