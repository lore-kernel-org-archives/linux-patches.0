Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B0C24677E
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 15:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753458985; cv=none; b=aHQtoY1vFG5G4Q9Ow5M4TOD+DLWVhLoAzMsMqNQNHYS6NH3qIC9GzNXAvrBBOZtjCudtnrI1E0QwBIJws+z4bXqOWbnvlsm7oZA2zmALA3jv8bpZmqAUe/VOI/iCU3fabZwOAD1v7paWyp4ZxthKwfeOsuZgXNO/vqS97goSyGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753458985; c=relaxed/simple;
	bh=yOLC2zL+EkibJaJIov4ddsXHdrQxeMOTGHQ3ig5KiRM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=LJ6KdbK45V+JDgItJqzFBjdGzVnXNNW77u7f0I78Uu8wgZyULfkHakm3aMDKa+gMY6vW+yV4PwOVyYXhEeSsmRLPVwer/C5aTyUNwK8tERDC5fKTlQW13+Yp4l1/9yhSzZcu7KHQ8dAXIMFNhpEV7dNVoGyYaPQGD7RyKTNufcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=UxCgfW7w; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="UxCgfW7w"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250725155621epoutp0182fd83bc2c67449e5106a5f9304291b9~ViadOaniJ1131611316epoutp01C
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 15:56:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250725155621epoutp0182fd83bc2c67449e5106a5f9304291b9~ViadOaniJ1131611316epoutp01C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1753458981;
	bh=OjH1eG+DNzN7VfQsZbZoty3xj5wHQ1NHGFhBRJ0m7GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UxCgfW7wLyjSf/8hWu0/YICpxwXd3a2othw+dufvutgLz3F3o21TOS2FPmKFxe/Z6
	 3bgqSSGSlaS1sPkOfVulpn2ApwoYVhNr/BvLl/rsnWXyZk6rpGLnSx4UZqxeCvMcdF
	 yAvLjBu7eGntPkPC2ID6eV2fjmoKXp17pqKiEL5U=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250725155620epcas5p2abc5e0602a0fb1b3f67950c26c850e0c~ViacFt0gt2501625016epcas5p2F;
	Fri, 25 Jul 2025 15:56:20 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.95]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4bpXXz2hGXz3hhT3; Fri, 25 Jul
	2025 15:56:19 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250725155507epcas5p113787f985ae9dcc5ff8c42caf2035047~ViZYJHJx62299122991epcas5p1x;
	Fri, 25 Jul 2025 15:55:07 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250725155506epsmtip2e331d65c8c3ccaeab664cf959d1406d1~ViZXjg4Ty0442304423epsmtip2T;
	Fri, 25 Jul 2025 15:55:06 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: mcgrof@kernel.org
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>, Anuj
	Gupta <anuj20.g@samsung.com>
Subject: [PATCH v2 10/15] fuse: add support for multiple writeback contexts
 in fuse
Date: Fri, 25 Jul 2025 21:24:16 +0530
Message-Id: <20250725155421.3234-11-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250725155421.3234-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250725155507epcas5p113787f985ae9dcc5ff8c42caf2035047
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250725155507epcas5p113787f985ae9dcc5ff8c42caf2035047
References: <20250725155421.3234-1-kundan.kumar@samsung.com>
	<CGME20250725155507epcas5p113787f985ae9dcc5ff8c42caf2035047@epcas5p1.samsung.com>

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

