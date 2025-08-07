Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E28C51DB546
	for <patches@lists.linux.dev>; Thu,  7 Aug 2025 04:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754542735; cv=none; b=K069cgHGVZa+DdHEKI3gwrWU6HUzGys5PkY5zvZg40z/PiOHWDDk4NfC/Dv61j9Mn47RSRTGDDTw03ktf7093Rn9NZhr9UW1bcVlYVMVNHXZZFiFb7mbbmMiu8PQ6sr3bUajc9mIsKWv3agp/rqDn2aO0YH+mM24mxrxYo3vD8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754542735; c=relaxed/simple;
	bh=yOLC2zL+EkibJaJIov4ddsXHdrQxeMOTGHQ3ig5KiRM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=j69qcGgtX/7LPTsTedgo4McRXF++tNJXwcWDwGmJjR4odVKskUU33PI3kuNaFVZ7c0UIgWTto0tKf5UJccYX13JFSh2WpnWLMtRSTOwKB/sEFaRlrmVSAnrckSzOLlqNHoLJUOMNTgNNchfIiyLU1Zjdg2kfC+rik0Q93I67ulU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=IujIVJyh; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="IujIVJyh"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250807045851epoutp01e28f93092a699aeef8537d1a272b60bc~ZY1GY3tvA1903619036epoutp01s
	for <patches@lists.linux.dev>; Thu,  7 Aug 2025 04:58:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250807045851epoutp01e28f93092a699aeef8537d1a272b60bc~ZY1GY3tvA1903619036epoutp01s
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1754542731;
	bh=OjH1eG+DNzN7VfQsZbZoty3xj5wHQ1NHGFhBRJ0m7GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IujIVJyhyYWw1y5OsVY24gamrv3Yla7OCo5Kqhgy9D5k/LIL10c4VRkg+kcXr3aKN
	 kMS0bJwbHOrpXTsIzpCPyBEI8u0NeDyfwRSoH8dAwIAv/AxhadyTZK5GKQJezIafMI
	 W82Bch56ie/o1/IaAYU6b8J/GqDxlELENodaCTdY=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250807045851epcas5p17ff7da43b1f23cd1e017945b129c793f~ZY1GHHrd-2146921469epcas5p1z;
	Thu,  7 Aug 2025 04:58:51 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.87]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4byFLL4Z72z3hhTH; Thu,  7 Aug
	2025 04:58:50 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250807045831epcas5p3d6403f830e0c1fa2048d4b6c35394b6a~ZY0zAkU2W0438104381epcas5p31;
	Thu,  7 Aug 2025 04:58:31 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250807045830epsmtip14f3a3fd2daa4dbf3b428090874c93611~ZY0yXrEbu1740217402epsmtip1H;
	Thu,  7 Aug 2025 04:58:30 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: mcgrof@kernel.org
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>, Anuj
	Gupta <anuj20.g@samsung.com>
Subject: [PATCH v2 10/15] fuse: add support for multiple writeback contexts
 in fuse
Date: Thu,  7 Aug 2025 10:27:01 +0530
Message-Id: <20250807045706.2848-11-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250807045706.2848-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250807045831epcas5p3d6403f830e0c1fa2048d4b6c35394b6a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250807045831epcas5p3d6403f830e0c1fa2048d4b6c35394b6a
References: <20250807045706.2848-1-kundan.kumar@samsung.com>
	<CGME20250807045831epcas5p3d6403f830e0c1fa2048d4b6c35394b6a@epcas5p3.samsung.com>

Made a helper to fetch writeback context to which an inode is affined.
Use it to perform writeback related operations.

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/fuse/file.c              |  8 ++++----
 include/linux/backing-dev.h | 17 +++++++++++++++++
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 69874c906319..1194fdd24b01 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1785,7 +1785,6 @@ static void fuse_writepage_finish(struct fuse_writepage_args *wpa)
 	struct fuse_args_pages *ap = &wpa->ia.ap;
 	struct inode *inode = wpa->inode;
 	struct fuse_inode *fi = get_fuse_inode(inode);
-	struct backing_dev_info *bdi = inode_to_bdi(inode);
 	int i;
 
 	for (i = 0; i < ap->num_folios; i++) {
@@ -1795,8 +1794,9 @@ static void fuse_writepage_finish(struct fuse_writepage_args *wpa)
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
@@ -1990,7 +1990,7 @@ static void fuse_writepage_args_page_fill(struct fuse_writepage_args *wpa, struc
 	ap->descs[folio_index].offset = 0;
 	ap->descs[folio_index].length = folio_size(folio);
 
-	inc_wb_stat(&inode_to_bdi(inode)->wb_ctx[0]->wb, WB_WRITEBACK);
+	bdi_wb_stat_mod(inode, 1);
 }
 
 static struct fuse_writepage_args *fuse_writepage_args_setup(struct folio *folio,
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 831cd9f51162..5ed8294e0c0e 100644
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
@@ -104,6 +107,20 @@ static inline s64 wb_stat_sum(struct bdi_writeback *wb, enum wb_stat_item item)
 
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

