Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585998;
	b=StRVmlpXiIejw9ZL8+17C6Z2OJBdKOADtDTW91MpNWXQO8cnPZir6IpEgWgTN88LBs/s
	 eTHWBHpQ00uqk9xuiXvi1a48otvLDq4h5tlEmdXLMfSDN1lu4G4uQWnpS1P0HR7jlsJa2
	 8Fb7+yiXcHKGNJ3lr9eBW8pJsaPyN7lFg8R+HjH0fqLAL6GVyGFYjW0KcS578iULhnqpQ
	 u/qhjtLXwW6DHJW5HG59DNwfHc1tgCv1GwZ11itKESJ5oZjvIwqe3WqBanx2yY4st0GA1
	 UxTTTNmE27N1pH1w1/LM9AqoW0eGpZiRQ6Ivq9nMXzS+8e3HUvfHCUTEF8M/+8CR9RQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585998;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r1EKusX3vXCIh5HOXCNwWMUGHxxycNCYFJJvjXzIsoA=;
	b=lahYogehWJ6To98efnI8Iijkf60/YnVSNF7tivIzWoizv9N+03SR5c9svH363Jpe2GW/
	 pdKrDoHdxL48VfA8BG5lI8v5E/scDhAMKlXJJbAG5qBREtDoYJvG4S3lW4bK3GG/KEbBT
	 2u6TKtntrTiang3MwqPoJ1q3P3GMUh/xBIij7+jhTgIohgM0ErAeJYjNHxo9R2MN8IjrA
	 lq0O2klIjyPq3Bf1xlRxFpfCuUEeGe59Idji+hYsNWWcnYhybyXiNFrvomsvIO/3/zOYx
	 IKVtk0YSz8KQCQJRwNwJyUVCqgel6z9j3z8lU6LiYsznHI6dbBcvfuuP+XIpEp5Rj6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZeL8VFrN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C42D6076E30;
	Fri, 13 Nov 2026 16:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZeL8VFrN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 187451F000C6;
	Fri, 13 Nov 2026 16:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585998;
	bh=r1EKusX3vXCIh5HOXCNwWMUGHxxycNCYFJJvjXzIsoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZeL8VFrN8Ecl0g5yVGxI8sEgyjos3za10Djfn5Rw4i50xxIhDjwJG7zmg+cww+L9G
	 y1oA3l0BPgaDFu95gLVUkmLaj683y39On39spbvvpfDyN8fXQCTdu0l0x29eM5K43L
	 c08VMyWwsV6+N3ceNVsrhaoAAZ+dBAgE34FHNSOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 039/686] exportfs,nfsd: rework checking for layout-based block device access support
Date: Fri, 13 Nov 2026 10:42:52 -0500
Message-ID: <20261113153822.295281827@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit da9baa5470dcb077a7c9806f0925c60b530c470b ]

Currently NFSD hard codes checking support for block-style layouts.
Lift the checks into a file system-helper and provide a exportfs-level
helper to implement the typical checks.

This prepares for supporting block layout export of multiple devices
per file system.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Link: https://patch.msgid.link/20260423181854.743150-5-cel@kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 5d28b2c920d9 ("nfsd: don't offer flexfiles layouts when NFSv3 isn't being served")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/export.c               |  3 +-
 fs/nfsd/nfs4layouts.c          | 26 +++++------------
 fs/xfs/xfs_pnfs.c              | 13 +++++++++
 include/linux/exportfs_block.h | 52 +++++++++++++++++++++++++++++++++-
 4 files changed, 73 insertions(+), 21 deletions(-)

diff --git a/fs/nfsd/export.c b/fs/nfsd/export.c
index 2a1499f2ad196..e33843a937dd6 100644
--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -722,7 +722,8 @@ static int svc_export_parse(struct cache_detail *cd, char *mesg, int mlen)
 			goto out4;
 		err = 0;
 
-		nfsd4_setup_layout_type(&exp);
+		if (exp.ex_flags & NFSEXP_PNFS)
+			nfsd4_setup_layout_type(&exp);
 	}
 
 	expp = svc_export_lookup(&exp);
diff --git a/fs/nfsd/nfs4layouts.c b/fs/nfsd/nfs4layouts.c
index 6b6f55ae0472d..c2d435c99bf5e 100644
--- a/fs/nfsd/nfs4layouts.c
+++ b/fs/nfsd/nfs4layouts.c
@@ -2,7 +2,6 @@
 /*
  * Copyright (c) 2014 Christoph Hellwig.
  */
-#include <linux/blkdev.h>
 #include <linux/exportfs_block.h>
 #include <linux/kmod.h>
 #include <linux/file.h>
@@ -126,28 +125,17 @@ nfsd4_set_deviceid(struct nfsd4_deviceid *id, const struct svc_fh *fhp,
 
 void nfsd4_setup_layout_type(struct svc_export *exp)
 {
-#if defined(CONFIG_NFSD_BLOCKLAYOUT) || defined(CONFIG_NFSD_SCSILAYOUT)
 	struct super_block *sb = exp->ex_path.mnt->mnt_sb;
-	const struct exportfs_block_ops *bops = sb->s_export_op->block_ops;
-#endif
-
-	if (!(exp->ex_flags & NFSEXP_PNFS))
-		return;
+	expfs_block_layouts_t block_supported = exportfs_layouts_supported(sb);
 
-#ifdef CONFIG_NFSD_FLEXFILELAYOUT
-	exp->ex_layout_types |= 1 << LAYOUT_FLEX_FILES;
-#endif
-#ifdef CONFIG_NFSD_BLOCKLAYOUT
-	if (bops && bops->get_uuid && bops->map_blocks && bops->commit_blocks)
+	if (IS_ENABLED(CONFIG_NFSD_FLEXFILELAYOUT))
+		exp->ex_layout_types |= 1 << LAYOUT_FLEX_FILES;
+	if (IS_ENABLED(CONFIG_NFSD_BLOCKLAYOUT) &&
+	    (block_supported & EXPFS_BLOCK_IN_BAND_ID))
 		exp->ex_layout_types |= 1 << LAYOUT_BLOCK_VOLUME;
-#endif
-#ifdef CONFIG_NFSD_SCSILAYOUT
-	if (bops && bops->map_blocks && bops->commit_blocks &&
-	    sb->s_bdev &&
-	    sb->s_bdev->bd_disk->fops->pr_ops &&
-	    sb->s_bdev->bd_disk->fops->get_unique_id)
+	if (IS_ENABLED(CONFIG_NFSD_SCSILAYOUT) &&
+	    (block_supported & EXPFS_BLOCK_OUT_OF_BAND_ID))
 		exp->ex_layout_types |= 1 << LAYOUT_SCSI;
-#endif
 }
 
 void nfsd4_close_layout(struct nfs4_layout_stateid *ls)
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index c685995b69d7e..1b0b739571612 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -13,6 +13,7 @@
 #include "xfs_bmap.h"
 #include "xfs_iomap.h"
 #include "xfs_pnfs.h"
+#include <linux/exportfs_block.h>
 
 /*
  * Ensure that we do not have any outstanding pNFS layouts that can be used by
@@ -45,6 +46,17 @@ xfs_break_leased_layouts(
 	return error;
 }
 
+static expfs_block_layouts_t
+xfs_fs_layouts_supported(
+	struct super_block	*sb)
+{
+	expfs_block_layouts_t	supported = EXPFS_BLOCK_IN_BAND_ID;
+
+	if (exportfs_bdev_supports_out_of_band_id(sb->s_bdev))
+		supported |= EXPFS_BLOCK_OUT_OF_BAND_ID;
+	return supported;
+}
+
 /*
  * Get a unique ID including its location so that the client can identify
  * the exported device.
@@ -334,6 +346,7 @@ xfs_fs_commit_blocks(
 }
 
 const struct exportfs_block_ops xfs_export_block_ops = {
+	.layouts_supported	= xfs_fs_layouts_supported,
 	.get_uuid		= xfs_fs_get_uuid,
 	.map_blocks		= xfs_fs_map_blocks,
 	.commit_blocks		= xfs_fs_commit_blocks,
diff --git a/include/linux/exportfs_block.h b/include/linux/exportfs_block.h
index 1f52fea8e4dce..92f990d190bba 100644
--- a/include/linux/exportfs_block.h
+++ b/include/linux/exportfs_block.h
@@ -7,14 +7,36 @@
 #ifndef LINUX_EXPORTFS_BLOCK_H
 #define LINUX_EXPORTFS_BLOCK_H 1
 
-#include <linux/types.h>
+#include <linux/blkdev.h>
+#include <linux/exportfs.h>
+#include <linux/fs.h>
 
 struct iattr;
 struct inode;
 struct iomap;
 struct super_block;
 
+/*
+ * There are the two types of block-style layout support:
+ *  - In-band implies a device identified by a unique cookie inside the actual
+ *    device address space checked by the ->get_uuid method as used by the pNFS
+ *    block layout.  This is a bit dangerous and deprecated.
+ *  - Out of band implies identification by out of band unique identifiers
+ *    specified by the storage protocol, which is much safer and used by the
+ *    pNFS SCSI/NVMe layouts.
+ */
+typedef unsigned int __bitwise expfs_block_layouts_t;
+#define EXPFS_BLOCK_FLAG(__bit) \
+	((__force expfs_block_layouts_t)(1u << __bit))
+#define EXPFS_BLOCK_IN_BAND_ID		EXPFS_BLOCK_FLAG(0)
+#define EXPFS_BLOCK_OUT_OF_BAND_ID	EXPFS_BLOCK_FLAG(1)
+
 struct exportfs_block_ops {
+	/*
+	 * Returns the EXPFS_BLOCK_* bitmap of supported layout types.
+	 */
+	expfs_block_layouts_t (*layouts_supported)(struct super_block *sb);
+
 	/*
 	 * Get the in-band device unique signature exposed to clients.
 	 */
@@ -36,4 +58,32 @@ struct exportfs_block_ops {
 			int nr_iomaps, struct iattr *iattr);
 };
 
+static inline bool
+exportfs_bdev_supports_out_of_band_id(struct block_device *bdev)
+{
+	return bdev->bd_disk->fops->pr_ops &&
+		bdev->bd_disk->fops->get_unique_id;
+}
+
+#ifdef CONFIG_EXPORTFS_BLOCK_OPS
+static inline expfs_block_layouts_t
+exportfs_layouts_supported(struct super_block *sb)
+{
+	const struct exportfs_block_ops *bops = sb->s_export_op->block_ops;
+
+	if (!bops ||
+	    !bops->layouts_supported ||
+	    WARN_ON_ONCE(!bops->map_blocks) ||
+	    WARN_ON_ONCE(!bops->commit_blocks))
+		return 0;
+	return bops->layouts_supported(sb);
+}
+#else
+static inline expfs_block_layouts_t
+exportfs_layouts_supported(struct super_block *sb)
+{
+	return 0;
+}
+#endif /* CONFIG_EXPORTFS_BLOCK_OPS */
+
 #endif /* LINUX_EXPORTFS_BLOCK_H */
-- 
2.53.0



