Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64FEA3126A2
	for <patches@lists.linux.dev>; Wed, 10 Sep 2025 10:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757499266; cv=none; b=FiTjoFLiEAZIRqVkklYMO5I+oTJdpaRGiyWKPPxl08oy/sQpaJ9ISioG64J0cymVCfXkeaRm0sl6q9fSjbCDaEK7PCIPXiGDVxzSqIu9UYkA2qjs+UnppKxLl7IOY0iJVKGuHxBid7y6aAP/zxj2hyvWtbPepF1307a6FbRg08I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757499266; c=relaxed/simple;
	bh=g2Kyz6kJ3614flmZ7atWqXtVZnEbymKOmYZqWbLWQE4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=HPxb8g8/5l8V2SIVkfBgibQoIYdoLB4x0soRs6kHoCIhFj6JElvwoHwkjoXJrH6g4AYGUUK8KfnB5/OpzBrPgiEziEEsorIrO1I2q6HQR2Pn3S6r9+35s+UpEBHq+cOFVRvbtutCBcPCHa5ZQoQpezk9TtKtZeXkJSECXyzuU3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=i0cJG0x4; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="i0cJG0x4"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250910101422epoutp020151f1d45e6d4739c47ebb76451ec2d4~j5ERw6Nmh0516705167epoutp02B
	for <patches@lists.linux.dev>; Wed, 10 Sep 2025 10:14:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250910101422epoutp020151f1d45e6d4739c47ebb76451ec2d4~j5ERw6Nmh0516705167epoutp02B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1757499262;
	bh=yro6bHWst9woC+33EzUIqaE/hoFw67jMJtTNvn1fKDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i0cJG0x4dBbeNo5V328jc9+UayYe7dfGrIFvk/64S/ujPBRmM2BraKZn1eSZiHApM
	 RHaXtKO7Q+Dd/PrK+mSdwZEUvMJ+Qm7YR0G5ZAUuKXMFGpkNSe0AwJIc6kzMPQfl4h
	 +sNbNNFomZmqCvdphBqCYlBzksDu3UhuH2u92rq0=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20250910101421epcas5p4b02a1d4859507e01523c68af9748a123~j5EQ0GQ8Q2642326423epcas5p48;
	Wed, 10 Sep 2025 10:14:21 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.92]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4cMGkh1JHCz3hhT7; Wed, 10 Sep
	2025 10:14:20 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250910101419epcas5p2be6cec4f7027d57561a183041dec2245~j5EPdt_rq2618326183epcas5p2Z;
	Wed, 10 Sep 2025 10:14:19 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250910101419epsmtip199216ae6c8f5931153761651d95dd4b5~j5EO3Y7C92347023470epsmtip1S;
	Wed, 10 Sep 2025 10:14:18 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: mcgrof@kernel.org
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>, Anuj
	Gupta <anuj20.g@samsung.com>
Subject: [PATCH v2 04/16] writeback: affine inode to a writeback ctx within
 a bdi
Date: Wed, 10 Sep 2025 15:42:52 +0530
Message-Id: <20250910101304.2588-5-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250910101304.2588-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250910101419epcas5p2be6cec4f7027d57561a183041dec2245
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250910101419epcas5p2be6cec4f7027d57561a183041dec2245
References: <20250910101304.2588-1-kundan.kumar@samsung.com>
	<CGME20250910101419epcas5p2be6cec4f7027d57561a183041dec2245@epcas5p2.samsung.com>

Affine inode to a writeback context. This helps in minimizing the
filesytem fragmentation due to inode being processed by different
threads.

To support parallel writeback, wire up a new superblock operation
get_inode_wb_ctx(). Filesystems can override this callback and select
desired writeback context for a inode. FS can use the wb context based
on its geometry and also use 64 bit inode numbers.

If a filesystem doesn't implement this callback, it defaults to
DEFALT_WB_CTX = 0, maintaining its original behavior.

An example implementation for XFS is provided, where XFS selects the
writeback context based on its Allocation Group number.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
---
 fs/fs-writeback.c           |  3 ++-
 fs/xfs/xfs_super.c          | 13 +++++++++++++
 include/linux/backing-dev.h |  5 ++++-
 include/linux/fs.h          |  1 +
 4 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 5165b7cc86e2..e065cd606b80 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -265,7 +265,8 @@ void __inode_attach_wb(struct inode *inode, struct folio *folio)
 {
 	struct backing_dev_info *bdi = inode_to_bdi(inode);
 	struct bdi_writeback *wb = NULL;
-	struct bdi_writeback_ctx *bdi_writeback_ctx = bdi->wb_ctx[0];
+	struct bdi_writeback_ctx *bdi_writeback_ctx =
+						fetch_bdi_writeback_ctx(inode);
 
 	if (inode_cgwb_enabled(inode)) {
 		struct cgroup_subsys_state *memcg_css;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index bb0a82635a77..b3ec9141d902 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -53,6 +53,7 @@
 #include <linux/magic.h>
 #include <linux/fs_context.h>
 #include <linux/fs_parser.h>
+#include <linux/backing-dev.h>
 
 static const struct super_operations xfs_super_operations;
 
@@ -1294,6 +1295,17 @@ xfs_fs_show_stats(
 	return 0;
 }
 
+static struct bdi_writeback_ctx *
+xfs_get_inode_wb_ctx(
+	struct inode		*inode)
+{
+	struct xfs_inode *ip = XFS_I(inode);
+	struct backing_dev_info *bdi = inode_to_bdi(inode);
+	xfs_agino_t agno = XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino);
+
+	return bdi->wb_ctx[agno % bdi->nr_wb_ctx];
+}
+
 static const struct super_operations xfs_super_operations = {
 	.alloc_inode		= xfs_fs_alloc_inode,
 	.destroy_inode		= xfs_fs_destroy_inode,
@@ -1310,6 +1322,7 @@ static const struct super_operations xfs_super_operations = {
 	.free_cached_objects	= xfs_fs_free_cached_objects,
 	.shutdown		= xfs_fs_shutdown,
 	.show_stats		= xfs_fs_show_stats,
+	.get_inode_wb_ctx       = xfs_get_inode_wb_ctx,
 };
 
 static int
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 951ab5497500..59bbb69d300c 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -148,6 +148,7 @@ static inline bool mapping_can_writeback(struct address_space *mapping)
 	return inode_to_bdi(mapping->host)->capabilities & BDI_CAP_WRITEBACK;
 }
 
+#define DEFAULT_WB_CTX 0
 #define for_each_bdi_wb_ctx(bdi, wbctx) \
 	for (int __i = 0; __i < (bdi)->nr_wb_ctx \
 		&& ((wbctx) = (bdi)->wb_ctx[__i]) != NULL; __i++)
@@ -157,7 +158,9 @@ fetch_bdi_writeback_ctx(struct inode *inode)
 {
 	struct backing_dev_info *bdi = inode_to_bdi(inode);
 
-	return bdi->wb_ctx[0];
+	if (inode->i_sb->s_op->get_inode_wb_ctx)
+		return inode->i_sb->s_op->get_inode_wb_ctx(inode);
+	return bdi->wb_ctx[DEFAULT_WB_CTX];
 }
 
 #ifdef CONFIG_CGROUP_WRITEBACK
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f92f45c09b5c..7a8db7a958c4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2367,6 +2367,7 @@ struct super_operations {
 	long (*free_cached_objects)(struct super_block *,
 				    struct shrink_control *);
 	void (*shutdown)(struct super_block *sb);
+	struct bdi_writeback_ctx *(*get_inode_wb_ctx)(struct inode *inode);
 };
 
 /*
-- 
2.25.1

