Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E1C24677E
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 15:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753459002; cv=none; b=nmXOK9dEsjsBBZcO5aRZA/vW2Y/yAtk4F0aNUoNPq+iR2/DVZIt86LWgXCHzIQF3isyF/wCU4kvXM5c5H5jgVO8g2h9LpFwbIc1ACK5t6KRLRP9gCt0y515gHh9bTaRiUVLK6SgSbBIktco26UZVmYkSIjAsjz0mMk9gFgyZKKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753459002; c=relaxed/simple;
	bh=kBbUphdLPSjrA8G/UvCmrl7TjiZoaHlFUQRKDjJZUuo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=A6ihATSXpjKNlUMKUF4PHkL7B4nOUn+NBmilXB6KQK/UhDD98+hgOFcMCmujthpBl0pXDKTz0YfdAiT5XHvkYXd3XQ7x7tfliXx565xLQSFPrVOMeDpDhiNZtw/3A8xpJaWzEIQXVtxgsj4uVfczT4sNLNO42AEp+hXpDXgQDdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ijt00/eM; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ijt00/eM"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250725155638epoutp01797cb384dc352ddec333b4ae70e653fb~Vias-9P2K1131611316epoutp01F
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 15:56:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250725155638epoutp01797cb384dc352ddec333b4ae70e653fb~Vias-9P2K1131611316epoutp01F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1753458998;
	bh=jWjj/Jbk+zJVTJpAAYER6euuKQntBbVrbuZ+iyKesjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ijt00/eMHZZm/zJqYszzzH0CxjyUBfB93F3h3Ykxfl7mZzKKvRC9Vzj+HlIvI8pS/
	 jbyVF9m159KVI1fMS7YpGEkbttOMqrcl0JEnWg3EMQLLzU1MCqj406qDq5FSBOxc35
	 63+TRnCwDNJ6isH/1qMhjvhCUv425M6gvTnDGlzI=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250725155638epcas5p187c6c11fa47c7292b7377946cca8fc5f~ViasrDUdu2299122991epcas5p1v;
	Fri, 25 Jul 2025 15:56:38 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.91]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4bpXYK1qFnz6B9m4; Fri, 25 Jul
	2025 15:56:37 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250725155511epcas5p2498b51a3391fa4a8cf0354d6966686ac~ViZcRLMPK3273532735epcas5p2Z;
	Fri, 25 Jul 2025 15:55:11 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250725155511epsmtip2f24725b430634169c8dfb82fbf87422d~ViZbpFr--3233232332epsmtip2Y;
	Fri, 25 Jul 2025 15:55:11 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: mcgrof@kernel.org
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>, Anuj
	Gupta <anuj20.g@samsung.com>
Subject: [PATCH v2 15/15] writeback: added support to change the number of
 writebacks using a sysfs attribute
Date: Fri, 25 Jul 2025 21:24:21 +0530
Message-Id: <20250725155421.3234-16-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250725155421.3234-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250725155511epcas5p2498b51a3391fa4a8cf0354d6966686ac
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250725155511epcas5p2498b51a3391fa4a8cf0354d6966686ac
References: <20250725155421.3234-1-kundan.kumar@samsung.com>
	<CGME20250725155511epcas5p2498b51a3391fa4a8cf0354d6966686ac@epcas5p2.samsung.com>

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
 fs/super.c                  | 23 ++++++++++
 include/linux/backing-dev.h |  1 +
 include/linux/fs.h          |  1 +
 mm/backing-dev.c            | 91 +++++++++++++++++++++++++++++++++++++
 mm/page-writeback.c         |  8 ++++
 5 files changed, 124 insertions(+)

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
index 7c6fbf57e7ef..51fe40af4f98 100644
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
@@ -469,6 +480,85 @@ static ssize_t strict_limit_show(struct device *dev,
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
+		if (inode->i_wb) {
+			WARN_ON_ONCE(!(inode->i_state & I_CLEAR));
+			wb_put(inode->i_wb);
+			inode->i_wb = NULL;
+		}
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
@@ -479,6 +569,7 @@ static struct attribute *bdi_dev_attrs[] = {
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

