Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554601DB546
	for <patches@lists.linux.dev>; Thu,  7 Aug 2025 04:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754542748; cv=none; b=tHpwYiZJe98yXjeBFwsz4pnHKzhjnecz06WJtVz4BKWpFUlP5suTG3iVm6IOETk+V4rsFJe/upYAkHH+22epNBjO4AJhBu/jMHcfxBwXpeXYvRNp336bX5ildyJQdp9w9tFmryIQ+Z46O2/Wgz/7XGU4jxM1Tjbgi4rHfkh62cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754542748; c=relaxed/simple;
	bh=HwN6p5gW+0NvLmffjISFpEijDzd2DW64ighH7yNUhJs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=enMJbbh/oKs00sboWSYEX8VVexJ6qloHImbeB+GKGjDUm/ag4J4xgmO2Safj2DhSkCDqnPjC4yaGTbAm9t5H5hOFif2pFg8ysCfPqNhQKFnjYsI61I17aEIGUZOW1S2Fcv5H2674Oad65Nj7We0+gjetXd2kz3yx6hEJYlfg/yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=NBCxjQAK; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="NBCxjQAK"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250807045904epoutp03b6b8902df3b3fdcfc04628bd50c4a0d1~ZY1SRSMZ21440714407epoutp03v
	for <patches@lists.linux.dev>; Thu,  7 Aug 2025 04:59:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250807045904epoutp03b6b8902df3b3fdcfc04628bd50c4a0d1~ZY1SRSMZ21440714407epoutp03v
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1754542744;
	bh=/oic7BQ6tXBTRWoSPQWiW/7t5tv/aEelSJKt5qEOxbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NBCxjQAKOFWD2cB9ScAGfc0mOaOGHfCcD0TehCpUi3HbQmLaqL//TNmzcu1y8taEM
	 J6AcfsXRw/lLZfF5VsLk0FZodKOHZLlITy0i5mKwXoXcdsF3at0rqURkKxwgvn7NNq
	 RqUNggaMllcTymSGpBA0kIlwWupd8nI/HvWlVNPI=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250807045904epcas5p3475d52a82691953f19ba274fc16d3bc4~ZY1R__Phk0438104381epcas5p3E;
	Thu,  7 Aug 2025 04:59:04 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.86]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4byFLb2kyNz6B9m6; Thu,  7 Aug
	2025 04:59:03 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250807045839epcas5p12ee40fdfe06cfac1ed4368cad434992f~ZY063sh6f2146921469epcas5p1R;
	Thu,  7 Aug 2025 04:58:39 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250807045838epsmtip11d2953fe74bda27417c04993c7e63589~ZY06Lhr151580315803epsmtip1q;
	Thu,  7 Aug 2025 04:58:38 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: mcgrof@kernel.org
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>, Anuj
	Gupta <anuj20.g@samsung.com>
Subject: [PATCH v2 15/15] writeback: added support to change the number of
 writebacks using a sysfs attribute
Date: Thu,  7 Aug 2025 10:27:06 +0530
Message-Id: <20250807045706.2848-16-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250807045706.2848-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250807045839epcas5p12ee40fdfe06cfac1ed4368cad434992f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250807045839epcas5p12ee40fdfe06cfac1ed4368cad434992f
References: <20250807045706.2848-1-kundan.kumar@samsung.com>
	<CGME20250807045839epcas5p12ee40fdfe06cfac1ed4368cad434992f@epcas5p1.samsung.com>

User can change the number of writeback contexts with values 1 to num
cpus using the new sysfs attribute

echo <num_writbacks> > /sys/class/bdi/<maj>:<min>/nwritebacks

The sequence of operations when number of writebacks is changed :
  - fetch the superblock for a bdi
  - freezes the filesystem
  - iterate through inodes of the superblock and flush the pages
  - shutdown and free the writeback threads
  - allocate and registter the wb threads
  - thaw the filesystem

Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/super.c                  | 23 +++++++++
 include/linux/backing-dev.h |  1 +
 include/linux/fs.h          |  1 +
 mm/backing-dev.c            | 93 +++++++++++++++++++++++++++++++++++++
 mm/page-writeback.c         |  8 ++++
 5 files changed, 126 insertions(+)

diff --git a/fs/super.c b/fs/super.c
index 80418ca8e215..097d10e69e18 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -2061,6 +2061,29 @@ static inline bool may_unfreeze(struct super_block *sb, enum freeze_holder who,
 	return false;
 }
 
+struct super_block *freeze_bdi_super(struct backing_dev_info *bdi)
+{
+	struct super_block *sb_iter;
+	struct super_block *sb = NULL;
+
+	spin_lock(&sb_lock);
+	list_for_each_entry(sb_iter, &super_blocks, s_list) {
+		if (sb_iter->s_bdi == bdi) {
+			sb = sb_iter;
+			break;
+		}
+	}
+	spin_unlock(&sb_lock);
+
+	if (sb) {
+		atomic_inc(&sb->s_active);
+		freeze_super(sb, FREEZE_HOLDER_KERNEL, NULL);
+	}
+
+	return sb;
+}
+EXPORT_SYMBOL(freeze_bdi_super);
+
 /**
  * freeze_super - lock the filesystem and force it into a consistent state
  * @sb: the super to lock
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 5ed8294e0c0e..9c2d70d65277 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -145,6 +145,7 @@ int bdi_set_max_ratio_no_scale(struct backing_dev_info *bdi, unsigned int max_ra
 int bdi_set_min_bytes(struct backing_dev_info *bdi, u64 min_bytes);
 int bdi_set_max_bytes(struct backing_dev_info *bdi, u64 max_bytes);
 int bdi_set_strict_limit(struct backing_dev_info *bdi, unsigned int strict_limit);
+int bdi_set_nwritebacks(struct backing_dev_info *bdi, unsigned int nwritebacks);
 
 /*
  * Flags in backing_dev_info::capability
diff --git a/include/linux/fs.h b/include/linux/fs.h
index edcbc5042427..f82f7ff2381f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2758,6 +2758,7 @@ extern int unregister_filesystem(struct file_system_type *);
 extern int vfs_statfs(const struct path *, struct kstatfs *);
 extern int user_statfs(const char __user *, struct kstatfs *);
 extern int fd_statfs(int, struct kstatfs *);
+struct super_block *freeze_bdi_super(struct backing_dev_info *bdi);
 int freeze_super(struct super_block *super, enum freeze_holder who,
 		 const void *freeze_owner);
 int thaw_super(struct super_block *super, enum freeze_holder who,
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 392a4eb4a878..4de1a741cd57 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -35,6 +35,17 @@ LIST_HEAD(bdi_list);
 /* bdi_wq serves all asynchronous writeback tasks */
 struct workqueue_struct *bdi_wq;
 
+static int cgwb_bdi_init(struct backing_dev_info *bdi);
+static void cgwb_bdi_register(struct backing_dev_info *bdi,
+			      struct bdi_writeback_ctx *bdi_wb_ctx);
+static void cgwb_bdi_unregister(struct backing_dev_info *bdi,
+				struct bdi_writeback_ctx *bdi_wb_ctx);
+static void wb_shutdown(struct bdi_writeback *wb);
+static void wb_exit(struct bdi_writeback *wb);
+static struct bdi_writeback_ctx **wb_ctx_alloc(struct backing_dev_info *bdi,
+					       int num_ctxs);
+static void wb_ctx_free(struct backing_dev_info *bdi);
+
 #ifdef CONFIG_DEBUG_FS
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
@@ -469,6 +480,87 @@ static ssize_t strict_limit_show(struct device *dev,
 }
 static DEVICE_ATTR_RW(strict_limit);
 
+static ssize_t nwritebacks_store(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t count)
+{
+	struct backing_dev_info *bdi = dev_get_drvdata(dev);
+	unsigned int nwritebacks;
+	ssize_t ret;
+	struct super_block *sb = NULL;
+	struct bdi_writeback_ctx **wb_ctx;
+	struct bdi_writeback_ctx *bdi_wb_ctx;
+	struct inode *inode;
+
+	ret = kstrtouint(buf, 10, &nwritebacks);
+	if (ret < 0)
+		return ret;
+
+	if (nwritebacks < 1 || nwritebacks > num_online_cpus())
+		return -EINVAL;
+
+	if (nwritebacks == bdi->nr_wb_ctx)
+		return count;
+
+	wb_ctx = wb_ctx_alloc(bdi, nwritebacks);
+	if (!wb_ctx)
+		return -ENOMEM;
+
+	sb = freeze_bdi_super(bdi);
+	if (!sb)
+		return -EBUSY;
+
+	spin_lock(&sb->s_inode_list_lock);
+	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
+		filemap_write_and_wait(inode->i_mapping);
+		truncate_inode_pages_final(inode->i_mapping);
+#ifdef CONFIG_CGROUP_WRITEBACK
+		if (inode->i_wb) {
+			WARN_ON_ONCE(!(inode->i_state & I_CLEAR));
+			wb_put(inode->i_wb);
+			inode->i_wb = NULL;
+		}
+#endif
+	}
+	spin_unlock(&sb->s_inode_list_lock);
+
+	for_each_bdi_wb_ctx(bdi, bdi_wb_ctx) {
+		wb_shutdown(&bdi_wb_ctx->wb);
+		cgwb_bdi_unregister(bdi, bdi_wb_ctx);
+	}
+
+	for_each_bdi_wb_ctx(bdi, bdi_wb_ctx) {
+		WARN_ON_ONCE(test_bit(WB_registered, &bdi_wb_ctx->wb.state));
+		wb_exit(&bdi_wb_ctx->wb);
+		kfree(bdi_wb_ctx);
+	}
+	kfree(bdi->wb_ctx);
+
+	ret = bdi_set_nwritebacks(bdi, nwritebacks);
+
+	bdi->wb_ctx = wb_ctx;
+
+	cgwb_bdi_init(bdi);
+	for_each_bdi_wb_ctx(bdi, bdi_wb_ctx) {
+		cgwb_bdi_register(bdi, bdi_wb_ctx);
+		set_bit(WB_registered, &bdi_wb_ctx->wb.state);
+	}
+
+	thaw_super(sb, FREEZE_HOLDER_KERNEL, NULL);
+	deactivate_super(sb);
+
+	return ret;
+}
+
+static ssize_t nwritebacks_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct backing_dev_info *bdi = dev_get_drvdata(dev);
+
+	return sysfs_emit(buf, "%d\n", bdi->nr_wb_ctx);
+}
+static DEVICE_ATTR_RW(nwritebacks);
+
 static struct attribute *bdi_dev_attrs[] = {
 	&dev_attr_read_ahead_kb.attr,
 	&dev_attr_min_ratio.attr,
@@ -479,6 +571,7 @@ static struct attribute *bdi_dev_attrs[] = {
 	&dev_attr_max_bytes.attr,
 	&dev_attr_stable_pages_required.attr,
 	&dev_attr_strict_limit.attr,
+	&dev_attr_nwritebacks.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(bdi_dev);
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 8b4271e75f9e..a28845d0171a 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -818,6 +818,14 @@ int bdi_set_strict_limit(struct backing_dev_info *bdi, unsigned int strict_limit
 	return 0;
 }
 
+int bdi_set_nwritebacks(struct backing_dev_info *bdi, unsigned int nwritebacks)
+{
+	spin_lock_bh(&bdi_lock);
+	bdi->nr_wb_ctx = nwritebacks;
+	spin_unlock_bh(&bdi_lock);
+	return 0;
+}
+
 static unsigned long dirty_freerun_ceiling(unsigned long thresh,
 					   unsigned long bg_thresh)
 {
-- 
2.25.1

