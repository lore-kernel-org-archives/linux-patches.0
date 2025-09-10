Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A1B311955
	for <patches@lists.linux.dev>; Wed, 10 Sep 2025 10:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757499268; cv=none; b=P3+Cl0/FIkCdOK5e41khxY5Iyma7nau8HvtwEobXYNKzTQ2/nnJmqB1F/1N7f7qONbiSoOGaC+QQX9tkQhrjOkuzYWLAljjsL/LV6xojSoiKqQLdizIghC7KQN2uR8uTNOAHteCceFWVPzuPuZ59sfLeEEUcugJFSuPWyvUaIYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757499268; c=relaxed/simple;
	bh=iyQx6r3rwG7MUh+zC7g3Twzy32vZV3AIKWTI4GW2YsQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=FhUHMfISojta/0xvGLo3vGeVvAVMHPVzLwc2esTuA3RbAeDGYpaBkcHhFnPMC0WfIre/GWWNf7C8/lNVW/3ej4cj9gGGlcvwgUCR5VEqBNYtM2spwImqNcxxh9sTQia/uCbBGl25v9W7PJka1ZvHFSkGEflKS62ZG70gyi5mSj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=vGTmAMKm; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="vGTmAMKm"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250910101424epoutp02b121d13081931c7d2ad2bcb0f825c195~j5EUPZJva0282902829epoutp02d
	for <patches@lists.linux.dev>; Wed, 10 Sep 2025 10:14:24 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250910101424epoutp02b121d13081931c7d2ad2bcb0f825c195~j5EUPZJva0282902829epoutp02d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1757499264;
	bh=PWmMCt+JQfY3Cfi5fdwRInVPjGS3fb/TJ4n73j5JKq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vGTmAMKm/fgsig8ar5UBhvtDs26FJSV4Xv+Q0Gl+gebwaFSLES782H+Ua5CD2HaNf
	 d0H35gb0Q6mrrtgmULWOAXcJUF+EcB+KDO9xgBXdnh3ogJ9LoFf6q+WKPsAX3l2JrK
	 D4SCFY3SooZSLX83VjM35PNHfszeEZK5WIOz6TC4=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20250910101424epcas5p27a9df7205c70474e768ea49547347f09~j5ETeAIKO1887218872epcas5p2Z;
	Wed, 10 Sep 2025 10:14:24 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.94]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4cMGkk6bMTz2SSKd; Wed, 10 Sep
	2025 10:14:22 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250910101422epcas5p49c01e081d26f9ff417caf9975b015b70~j5ER_ZWmn2170621706epcas5p4m;
	Wed, 10 Sep 2025 10:14:22 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250910101421epsmtip1a4a0c108761f8eeefd0dc229f0233e93~j5ERW-bm12446624466epsmtip1F;
	Wed, 10 Sep 2025 10:14:21 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: mcgrof@kernel.org
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>, Anuj
	Gupta <anuj20.g@samsung.com>
Subject: [PATCH v2 07/16] writeback: modify sync related functions to
 iterate over all writeback contexts
Date: Wed, 10 Sep 2025 15:42:55 +0530
Message-Id: <20250910101304.2588-8-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250910101304.2588-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250910101422epcas5p49c01e081d26f9ff417caf9975b015b70
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250910101422epcas5p49c01e081d26f9ff417caf9975b015b70
References: <20250910101304.2588-1-kundan.kumar@samsung.com>
	<CGME20250910101422epcas5p49c01e081d26f9ff417caf9975b015b70@epcas5p4.samsung.com>

Modify sync related functions to iterate over all writeback contexts.

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/fs-writeback.c | 66 +++++++++++++++++++++++++++++++----------------
 1 file changed, 44 insertions(+), 22 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 1df8dd7af048..328bf7303df6 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -2752,11 +2752,13 @@ static void wait_sb_inodes(struct super_block *sb)
 	mutex_unlock(&sb->s_sync_lock);
 }
 
-static void __writeback_inodes_sb_nr(struct super_block *sb, unsigned long nr,
-				     enum wb_reason reason, bool skip_if_busy)
+static void __writeback_inodes_sb_nr_ctx(struct super_block *sb,
+					 unsigned long nr,
+					 enum wb_reason reason,
+					 bool skip_if_busy,
+					 struct bdi_writeback_ctx *bdi_wb_ctx)
 {
-	struct backing_dev_info *bdi = sb->s_bdi;
-	DEFINE_WB_COMPLETION(done, bdi->wb_ctx[0]);
+	DEFINE_WB_COMPLETION(done, bdi_wb_ctx);
 	struct wb_writeback_work work = {
 		.sb			= sb,
 		.sync_mode		= WB_SYNC_NONE,
@@ -2766,13 +2768,23 @@ static void __writeback_inodes_sb_nr(struct super_block *sb, unsigned long nr,
 		.reason			= reason,
 	};
 
+	bdi_split_work_to_wbs(sb->s_bdi, bdi_wb_ctx, &work, skip_if_busy);
+	wb_wait_for_completion(&done);
+}
+
+static void __writeback_inodes_sb_nr(struct super_block *sb, unsigned long nr,
+				     enum wb_reason reason, bool skip_if_busy)
+{
+	struct backing_dev_info *bdi = sb->s_bdi;
+	struct bdi_writeback_ctx *bdi_wb_ctx;
+
 	if (!bdi_has_dirty_io(bdi) || bdi == &noop_backing_dev_info)
 		return;
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
-	bdi_split_work_to_wbs(sb->s_bdi, bdi->wb_ctx[0], &work,
-			      skip_if_busy);
-	wb_wait_for_completion(&done);
+	for_each_bdi_wb_ctx(bdi, bdi_wb_ctx)
+		__writeback_inodes_sb_nr_ctx(sb, nr, reason, skip_if_busy,
+					     bdi_wb_ctx);
 }
 
 /**
@@ -2825,17 +2837,11 @@ void try_to_writeback_inodes_sb(struct super_block *sb, enum wb_reason reason)
 }
 EXPORT_SYMBOL(try_to_writeback_inodes_sb);
 
-/**
- * sync_inodes_sb	-	sync sb inode pages
- * @sb: the superblock
- *
- * This function writes and waits on any dirty inode belonging to this
- * super_block.
- */
-void sync_inodes_sb(struct super_block *sb)
+static void sync_inodes_bdi_wb_ctx(struct super_block *sb,
+				   struct backing_dev_info *bdi,
+				   struct bdi_writeback_ctx *bdi_wb_ctx)
 {
-	struct backing_dev_info *bdi = sb->s_bdi;
-	DEFINE_WB_COMPLETION(done, bdi->wb_ctx[0]);
+	DEFINE_WB_COMPLETION(done, bdi_wb_ctx);
 	struct wb_writeback_work work = {
 		.sb		= sb,
 		.sync_mode	= WB_SYNC_ALL,
@@ -2846,6 +2852,25 @@ void sync_inodes_sb(struct super_block *sb)
 		.for_sync	= 1,
 	};
 
+	/* protect against inode wb switch, see inode_switch_wbs_work_fn() */
+	bdi_down_write_wb_ctx_switch_rwsem(bdi_wb_ctx);
+	bdi_split_work_to_wbs(bdi, bdi_wb_ctx, &work, false);
+	wb_wait_for_completion(&done);
+	bdi_up_write_wb_ctx_switch_rwsem(bdi_wb_ctx);
+}
+
+/**
+ * sync_inodes_sb	-	sync sb inode pages
+ * @sb: the superblock
+ *
+ * This function writes and waits on any dirty inode belonging to this
+ * super_block.
+ */
+void sync_inodes_sb(struct super_block *sb)
+{
+	struct backing_dev_info *bdi = sb->s_bdi;
+	struct bdi_writeback_ctx *bdi_wb_ctx;
+
 	/*
 	 * Can't skip on !bdi_has_dirty() because we should wait for !dirty
 	 * inodes under writeback and I_DIRTY_TIME inodes ignored by
@@ -2855,11 +2880,8 @@ void sync_inodes_sb(struct super_block *sb)
 		return;
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
-	/* protect against inode wb switch, see inode_switch_wbs_work_fn() */
-	bdi_down_write_wb_ctx_switch_rwsem(bdi->wb_ctx[0]);
-	bdi_split_work_to_wbs(bdi, bdi->wb_ctx[0], &work, false);
-	wb_wait_for_completion(&done);
-	bdi_up_write_wb_ctx_switch_rwsem(bdi->wb_ctx[0]);
+	for_each_bdi_wb_ctx(bdi, bdi_wb_ctx)
+		sync_inodes_bdi_wb_ctx(sb, bdi, bdi_wb_ctx);
 
 	wait_sb_inodes(sb);
 }
-- 
2.25.1

