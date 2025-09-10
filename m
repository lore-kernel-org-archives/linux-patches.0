Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE94219A7D
	for <patches@lists.linux.dev>; Wed, 10 Sep 2025 10:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757499270; cv=none; b=JHRYvmbE5WqYwgkPNeL/jS82/GF0sOf2UV95mxHjIZZBoSEO/sljq4mLjyBPjSv/8oH74DTWMZilgaZxxbl1w0iCYItWy3eBbkX0saJaZTkTHCwSB6OcFDxRZA2AjFPsq28alpY1JtDyA+6kTE3nalJ9LmLWSEnAfgZZpc+GqUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757499270; c=relaxed/simple;
	bh=+N8WUvCLFNgEQEoJ666JcXBBw4o/PWuKB8LHvW+2xc4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=L1LBp198hPa9/cFDsGA6SKF5y8RDhvYeYdSgwf0PtpLN5xMPW/3g2F4cF11J/FYghfV46ilu2GpBuwmDM4R7yhbzIfxVCC/Tt9TcQ1SDCPYGcjt8M+Heibj5fs0ls9jAywVQPPBuhY68yseU3izxXWYRWmB4xu86UszbKvhlk3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ebdgIJXV; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ebdgIJXV"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250910101427epoutp040b807f5f7bba08bf4e09f007f265fda3~j5EWSabH32008220082epoutp04a
	for <patches@lists.linux.dev>; Wed, 10 Sep 2025 10:14:27 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250910101427epoutp040b807f5f7bba08bf4e09f007f265fda3~j5EWSabH32008220082epoutp04a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1757499267;
	bh=VTLVC2A6RBylbXJ2eodytFpJHYEggmezCLqh42emnkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ebdgIJXVEoFAGyI41PUgbmtyfij4Eck/uPrEhERWRm4K5BjncHtgW2eXri0Zgk7eF
	 pHIrXGcNDg1KJjAfjyaDnghBgzEHK7wrdL+WfRp7WMMzvqQR2MrmduFJ+JWstTJ7im
	 NyER/1zC+ROFu2evqyQDezwrQ4L4RmDkG8pRONII=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20250910101426epcas5p41b76cbe9d9bb9e4090404d6e20211ba7~j5EV8yp3n2642326423epcas5p4Q;
	Wed, 10 Sep 2025 10:14:26 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.95]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4cMGkn4t25z6B9mF; Wed, 10 Sep
	2025 10:14:25 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250910101425epcas5p463b7de32198366adab95a13982d7614e~j5EUe_WcO2170621706epcas5p4x;
	Wed, 10 Sep 2025 10:14:25 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250910101424epsmtip1f0c094c840cbef574c23916d7bafa997~j5ET47F4A2482124821epsmtip1c;
	Wed, 10 Sep 2025 10:14:24 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: mcgrof@kernel.org
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>, Anuj
	Gupta <anuj20.g@samsung.com>
Subject: [PATCH v2 10/16] fuse: add support for multiple writeback contexts
 in fuse
Date: Wed, 10 Sep 2025 15:42:58 +0530
Message-Id: <20250910101304.2588-11-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250910101304.2588-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250910101425epcas5p463b7de32198366adab95a13982d7614e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250910101425epcas5p463b7de32198366adab95a13982d7614e
References: <20250910101304.2588-1-kundan.kumar@samsung.com>
	<CGME20250910101425epcas5p463b7de32198366adab95a13982d7614e@epcas5p4.samsung.com>

Made a helper to fetch writeback context to which an inode is affined.
Use it to perform writeback related operations.

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/fuse/file.c              |  8 ++++----
 include/linux/backing-dev.h | 17 +++++++++++++++++
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 509fe853e81a..37145fd2f055 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1784,7 +1784,6 @@ static void fuse_writepage_finish(struct fuse_writepage_args *wpa)
 	struct fuse_args_pages *ap = &wpa->ia.ap;
 	struct inode *inode = wpa->inode;
 	struct fuse_inode *fi = get_fuse_inode(inode);
-	struct backing_dev_info *bdi = inode_to_bdi(inode);
 	int i;
 
 	for (i = 0; i < ap->num_folios; i++) {
@@ -1794,8 +1793,9 @@ static void fuse_writepage_finish(struct fuse_writepage_args *wpa)
 		 * contention and noticeably improves performance.
 		 */
 		folio_end_writeback(ap->folios[i]);
-		dec_wb_stat(&bdi->wb_ctx[0]->wb, WB_WRITEBACK);
-		wb_writeout_inc(&bdi->wb_ctx[0]->wb);
+
+		bdi_wb_stat_mod(inode, -1);
+		bdi_wb_writeout_inc(inode);
 	}
 
 	wake_up(&fi->page_waitq);
@@ -1989,7 +1989,7 @@ static void fuse_writepage_args_page_fill(struct fuse_writepage_args *wpa, struc
 	ap->descs[folio_index].offset = 0;
 	ap->descs[folio_index].length = folio_size(folio);
 
-	inc_wb_stat(&inode_to_bdi(inode)->wb_ctx[0]->wb, WB_WRITEBACK);
+	bdi_wb_stat_mod(inode, 1);
 }
 
 static struct fuse_writepage_args *fuse_writepage_args_setup(struct folio *folio,
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index bb35f8fa4973..fb042e593c16 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -46,6 +46,9 @@ extern struct list_head bdi_list;
 
 extern struct workqueue_struct *bdi_wq;
 
+static inline struct bdi_writeback_ctx *
+fetch_bdi_writeback_ctx(struct inode *inode);
+
 static inline bool wb_has_dirty_io(struct bdi_writeback *wb)
 {
 	return test_bit(WB_has_dirty_io, &wb->state);
@@ -103,6 +106,20 @@ static inline s64 wb_stat_sum(struct bdi_writeback *wb, enum wb_stat_item item)
 
 extern void wb_writeout_inc(struct bdi_writeback *wb);
 
+static inline void bdi_wb_stat_mod(struct inode *inode, s64 amount)
+{
+	struct bdi_writeback_ctx *bdi_wb_ctx = fetch_bdi_writeback_ctx(inode);
+
+	wb_stat_mod(&bdi_wb_ctx->wb, WB_WRITEBACK, amount);
+}
+
+static inline void bdi_wb_writeout_inc(struct inode *inode)
+{
+	struct bdi_writeback_ctx *bdi_wb_ctx = fetch_bdi_writeback_ctx(inode);
+
+	wb_writeout_inc(&bdi_wb_ctx->wb);
+}
+
 /*
  * maximal error of a stat counter.
  */
-- 
2.25.1

