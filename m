Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C538AAD2C
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 15:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753458956; cv=none; b=LjyQqeZwsa84FRRu/MqspZgKFCkpuC53N6y5HDjQ+483figW44mzHtf1v3b9SiRTF8FSrwyt883tg/I3DVHbla+9esM+yXUkBBvMjTBgVnnFJUzhLZZx7CKArOXmbUMX2ryVyP5PR5l4GwZEoSMOHkT+C/AETdFO/HfDCkTUqWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753458956; c=relaxed/simple;
	bh=VIDEPf0kn2PhS3JZvLDJq+1umrWsiDvNM9HArmPuVNY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=daWNayeQWV0AMQWWDYuTk1PK17FVR9fMGClKg7Xj3lB2ZY5hJGYPZqL3RT5eVL3TRN/DC+pokT5FlkqxOYpsjTc4HnZcVXF6UzcYQQx7daoaRAbvWMqMTMDXousj0bH9j12tJPj5lpBDTro3GGd/TvluJ1SjirjUdslJ6wmPSXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=pUbuIOvX; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="pUbuIOvX"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250725155552epoutp014da454023c2acfa64207e585c76ea20b~ViaCXW53e0702307023epoutp01e
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 15:55:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250725155552epoutp014da454023c2acfa64207e585c76ea20b~ViaCXW53e0702307023epoutp01e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1753458952;
	bh=+9Y6zZqvnVNa64YlpuGo2lnBkapQ7eKzkTo2U2at1Rk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pUbuIOvXaLlRYPHZMtKkBFwz4qaT86yC5+/2FhBhMghE5XBa6DrfmQQQ+jqSkwjDn
	 7HxdJl7WDFHGcanQTHcJqxrVOt9kBfAZaw5gpYpyhUxzC3CkS4uFtpRYankE/hEUC+
	 0jAh36BsraXGYbAnxVwpu7F6qxmBXP5VusLz5WCw=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20250725155552epcas5p43ae3d78b85eb5aa373d943b0e6b6ba43~ViaB0C9-q0805708057epcas5p40;
	Fri, 25 Jul 2025 15:55:52 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.90]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4bpXXR1fZkz6B9m4; Fri, 25 Jul
	2025 15:55:51 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250725155502epcas5p149ee8859fd9a97523bf876b50deaa84f~ViZTKFvog2299522995epcas5p1q;
	Fri, 25 Jul 2025 15:55:02 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250725155501epsmtip2ced6bc8adcd0627d347de7eb835c7170~ViZSjqQLJ0442404424epsmtip2N;
	Fri, 25 Jul 2025 15:55:01 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: mcgrof@kernel.org
Cc: patches@lists.linux.dev, Kundan Kumar <kundan.kumar@samsung.com>, Anuj
	Gupta <anuj20.g@samsung.com>
Subject: [PATCH v2 04/15] writeback: affine inode to a writeback ctx within
 a bdi
Date: Fri, 25 Jul 2025 21:24:10 +0530
Message-Id: <20250725155421.3234-5-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250725155421.3234-1-kundan.kumar@samsung.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250725155502epcas5p149ee8859fd9a97523bf876b50deaa84f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250725155502epcas5p149ee8859fd9a97523bf876b50deaa84f
References: <20250725155421.3234-1-kundan.kumar@samsung.com>
	<CGME20250725155502epcas5p149ee8859fd9a97523bf876b50deaa84f@epcas5p1.samsung.com>

Affine inode to a writeback context. This helps in minimizing the
filesytem fragmentation due to inode being processed by different
threads.

To support parallel writeback, wire up a new superblock operation
get_inode_wb_ctx(). Filesystems with 64 bit inode numbers can implement
this callback to return suitable writeback context for the inode.
In fetch_bdi_writeback_ctx(), if the callback is implemented, it is used
to obtain the context. Otherwise the default fallback computes the
writeback context by taking mod with the 32-bit inode number.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>
---
 fs/fs-writeback.c           |  3 ++-
 fs/xfs/xfs_super.c          | 12 ++++++++++++
 include/linux/backing-dev.h |  4 +++-
 include/linux/fs.h          |  1 +
 4 files changed, 18 insertions(+), 2 deletions(-)

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
index 0bc4b5489078..645a426d1e41 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -53,6 +53,7 @@
 #include <linux/magic.h>
 #include <linux/fs_context.h>
 #include <linux/fs_parser.h>
+#include <linux/backing-dev.h>
 
 static const struct super_operations xfs_super_operations;
 
@@ -1294,6 +1295,16 @@ xfs_fs_show_stats(
 	return 0;
 }
 
+static struct bdi_writeback_ctx *
+xfs_get_inode_wb_ctx(
+	struct inode		*inode)
+{
+	struct xfs_inode *ip = XFS_I(inode);
+	struct backing_dev_info *bdi = inode_to_bdi(inode);
+
+	return bdi->wb_ctx[ip->i_ino % bdi->nr_wb_ctx];
+}
+
 static const struct super_operations xfs_super_operations = {
 	.alloc_inode		= xfs_fs_alloc_inode,
 	.destroy_inode		= xfs_fs_destroy_inode,
@@ -1310,6 +1321,7 @@ static const struct super_operations xfs_super_operations = {
 	.free_cached_objects	= xfs_fs_free_cached_objects,
 	.shutdown		= xfs_fs_shutdown,
 	.show_stats		= xfs_fs_show_stats,
+	.get_inode_wb_ctx       = xfs_get_inode_wb_ctx,
 };
 
 static int
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 951ab5497500..6f744aadd83e 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -157,7 +157,9 @@ fetch_bdi_writeback_ctx(struct inode *inode)
 {
 	struct backing_dev_info *bdi = inode_to_bdi(inode);
 
-	return bdi->wb_ctx[0];
+	if (inode->i_sb->s_op->get_inode_wb_ctx)
+		return inode->i_sb->s_op->get_inode_wb_ctx(inode);
+	return bdi->wb_ctx[inode->i_ino % bdi->nr_wb_ctx];
 }
 
 #ifdef CONFIG_CGROUP_WRITEBACK
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8e2a041ce430..edcbc5042427 100644
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

