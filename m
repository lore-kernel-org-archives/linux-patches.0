Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC6F24677E
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 15:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753458988; cv=none; b=C3UDFrM9h/HBVqYmcGuqRMBn/TnvxyoI8yuEIZ6IneTCZjLcshvYDUGn8+PVGTvRfqJrrT5yaL0W79fMRqHQk3OllMaSuCjX5tlSjO6KOQ5nrmT/03/JU582dnnUKLE76D5aYqbObtg6RKk6pB5MNWXqfyEclhVJ/KecAqOFYiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753458988; c=relaxed/simple;
	bh=BP8mzYhylWdMnsYvQYVypknrZ9uSeBoVihQuZEj/b/I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=I/pC1oUJc80PRmTtago4mPf8sEO2SgHBVtSEoCqeS0wEgbszO/eD0W6/i8NT9OEdeHVs/+8RxVLT8Iu/k69q+GcIBZIPGEYkHhu+uO8hA/o5EcIkk7jtAwbfi65kh5x5PYS03qUfb/nVJRHbG8i3bFB2yZCeXRoImTJA3WKRf3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=N6ba4psL; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="N6ba4psL"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250725155625epoutp04e7d795530b77ccc1ab0a0dad7542a442~Viagb93H72040320403epoutp046
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 15:56:25 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250725155625epoutp04e7d795530b77ccc1ab0a0dad7542a442~Viagb93H72040320403epoutp046
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1753458985;
	bh=1t8YilI9ua4Lf4OWYMhjNvUl0HEDiTAE+VtUZXOolsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N6ba4psLxBaL+UKzmP0jj7D84DmP2X5zhXwfqDdc8IoO1IIq2n/fY4oa9BDcp3AWK
	 0GqBldIycPGh7tD8wMJpQuAwxQytL5iMWnkMVNyf/4BzAsR/j0y5DdkkZUkPeIzUwm
	 A2VyJTcn45G1ztqjswy6rxuKy+5Q6AH5LGafEuN4=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250725155623epcas5p3cabe7910aa03d094eade412aaadddf64~ViafWng1t2330323303epcas5p3T;
	Fri, 25 Jul 2025 15:56:23 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.91]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4bpXY26lRHz3hhT3; Fri, 25 Jul
	2025 15:56:22 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250725155508epcas5p20ac32126867cbda41622fdacd6322c5a~ViZY9P8N82353723537epcas5p2q;
	Fri, 25 Jul 2025 15:55:08 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250725155507epsmtip212160152085d254ee8ed86de24fd84cc~ViZYXoQRH0442404424epsmtip2R;
	Fri, 25 Jul 2025 15:55:07 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: mcgrof@kernel.org
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>, Anuj
	Gupta <anuj20.g@samsung.com>
Subject: [PATCH v2 11/15] gfs2: add support in gfs2 to handle multiple
 writeback contexts
Date: Fri, 25 Jul 2025 21:24:17 +0530
Message-Id: <20250725155421.3234-12-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250725155421.3234-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250725155508epcas5p20ac32126867cbda41622fdacd6322c5a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250725155508epcas5p20ac32126867cbda41622fdacd6322c5a
References: <20250725155421.3234-1-kundan.kumar@samsung.com>
	<CGME20250725155508epcas5p20ac32126867cbda41622fdacd6322c5a@epcas5p2.samsung.com>

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

