Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8922531E107;
	Fri,  9 Jan 2026 12:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961961; cv=none; b=pchgi7n6C6xKzLIKgNEKKHYCOmVcn8+exRuqSOwoA1VoXEZI7L9k/Kujjok+47ukMgJibYdOp91WnZbCBuKhzkfEHYwio+ihxmntXiF7JtPzyea1M56CZlCykcmusI9Oox4qRN5zfcfeWZaovnzAp3Xhd3TtCLX1z1fUvHTxQz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961961; c=relaxed/simple;
	bh=lfyp+rdkpORbEoBepapd+PZcBPtCx7IVIEBUE1cQ5KA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mxx8rgSix9OPsTl9yuOHaGhmtByY/hRmMPmNIsVwRfQgwIque1O4sqTcijj1Rq6WLWunVET5QpfKjYKf7z23tD4mqaNmn9TJZYWg/hIkbQy/KR9IbNiJ86Acsel4CdVegWEbV6hrI627Msz9yNIJ8I3dAkY3e8+AayEEETwMU9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GZiLFIcL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GZiLFIcL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14D55C4CEF1;
	Fri,  9 Jan 2026 12:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961961;
	bh=lfyp+rdkpORbEoBepapd+PZcBPtCx7IVIEBUE1cQ5KA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GZiLFIcLrSbstT6ydGnvVxkySymHlqmnozXmWBpYmFADAnSmdgE6wr7TqrUpAItIk
	 Sy0wsBDd2OOxLqMCE/bYmAc3kTGwJpknenwByTsLj6hHpyWC5WGSuM3zrj0MpMsSGD
	 Nbt8tVDIpHD4z+iANghP6dWFj7RIC3BjtrNMf9x4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@primarydata.com>,
	Lance Shelton <lance.shelton@hammerspace.com>,
	Benjamin Coddington <bcodding@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 197/634] Expand the type of nfs_fattr->valid
Date: Fri,  9 Jan 2026 12:37:55 +0100
Message-ID: <20260109112124.848077084@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

[ Upstream commit ce60ab3964782df9ba34f0a64c0bc766dd508bde ]

We need to be able to track more than 32 attributes per inode.

Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Lance Shelton <lance.shelton@hammerspace.com>
Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://lore.kernel.org/r/1e3405fca54efd0be7c91c1da77917b94f5dfcc4.1748515333.git.bcodding@redhat.com
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Stable-dep-of: 2b092175f5e3 ("NFS: Fix inheritance of the block sizes when automounting")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/inode.c            |  2 +-
 include/linux/nfs_fs_sb.h |  2 +-
 include/linux/nfs_xdr.h   | 54 +++++++++++++++++++--------------------
 3 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 627410be2e884..11e690942dbb3 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -2075,7 +2075,7 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 	bool attr_changed = false;
 	bool have_delegation;
 
-	dfprintk(VFS, "NFS: %s(%s/%lu fh_crc=0x%08x ct=%d info=0x%x)\n",
+	dfprintk(VFS, "NFS: %s(%s/%lu fh_crc=0x%08x ct=%d info=0x%llx)\n",
 			__func__, inode->i_sb->s_id, inode->i_ino,
 			nfs_display_fhandle_hash(NFS_FH(inode)),
 			atomic_read(&inode->i_count), fattr->valid);
diff --git a/include/linux/nfs_fs_sb.h b/include/linux/nfs_fs_sb.h
index a9671f9300848..eb1d41d87be30 100644
--- a/include/linux/nfs_fs_sb.h
+++ b/include/linux/nfs_fs_sb.h
@@ -155,8 +155,8 @@ struct nfs_server {
 #define NFS_MOUNT_WRITE_WAIT		0x02000000
 #define NFS_MOUNT_TRUNK_DISCOVERY	0x04000000
 
-	unsigned int		fattr_valid;	/* Valid attributes */
 	unsigned int		caps;		/* server capabilities */
+	__u64			fattr_valid;	/* Valid attributes */
 	unsigned int		rsize;		/* read size */
 	unsigned int		rpages;		/* read size (in pages) */
 	unsigned int		wsize;		/* write size */
diff --git a/include/linux/nfs_xdr.h b/include/linux/nfs_xdr.h
index 2fd973d188c47..0a380d41e4d95 100644
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -45,7 +45,7 @@ struct nfs4_threshold {
 };
 
 struct nfs_fattr {
-	unsigned int		valid;		/* which fields are valid */
+	__u64			valid;		/* which fields are valid */
 	umode_t			mode;
 	__u32			nlink;
 	kuid_t			uid;
@@ -80,32 +80,32 @@ struct nfs_fattr {
 	struct nfs4_label	*label;
 };
 
-#define NFS_ATTR_FATTR_TYPE		(1U << 0)
-#define NFS_ATTR_FATTR_MODE		(1U << 1)
-#define NFS_ATTR_FATTR_NLINK		(1U << 2)
-#define NFS_ATTR_FATTR_OWNER		(1U << 3)
-#define NFS_ATTR_FATTR_GROUP		(1U << 4)
-#define NFS_ATTR_FATTR_RDEV		(1U << 5)
-#define NFS_ATTR_FATTR_SIZE		(1U << 6)
-#define NFS_ATTR_FATTR_PRESIZE		(1U << 7)
-#define NFS_ATTR_FATTR_BLOCKS_USED	(1U << 8)
-#define NFS_ATTR_FATTR_SPACE_USED	(1U << 9)
-#define NFS_ATTR_FATTR_FSID		(1U << 10)
-#define NFS_ATTR_FATTR_FILEID		(1U << 11)
-#define NFS_ATTR_FATTR_ATIME		(1U << 12)
-#define NFS_ATTR_FATTR_MTIME		(1U << 13)
-#define NFS_ATTR_FATTR_CTIME		(1U << 14)
-#define NFS_ATTR_FATTR_PREMTIME		(1U << 15)
-#define NFS_ATTR_FATTR_PRECTIME		(1U << 16)
-#define NFS_ATTR_FATTR_CHANGE		(1U << 17)
-#define NFS_ATTR_FATTR_PRECHANGE	(1U << 18)
-#define NFS_ATTR_FATTR_V4_LOCATIONS	(1U << 19)
-#define NFS_ATTR_FATTR_V4_REFERRAL	(1U << 20)
-#define NFS_ATTR_FATTR_MOUNTPOINT	(1U << 21)
-#define NFS_ATTR_FATTR_MOUNTED_ON_FILEID (1U << 22)
-#define NFS_ATTR_FATTR_OWNER_NAME	(1U << 23)
-#define NFS_ATTR_FATTR_GROUP_NAME	(1U << 24)
-#define NFS_ATTR_FATTR_V4_SECURITY_LABEL (1U << 25)
+#define NFS_ATTR_FATTR_TYPE		BIT_ULL(0)
+#define NFS_ATTR_FATTR_MODE		BIT_ULL(1)
+#define NFS_ATTR_FATTR_NLINK		BIT_ULL(2)
+#define NFS_ATTR_FATTR_OWNER		BIT_ULL(3)
+#define NFS_ATTR_FATTR_GROUP		BIT_ULL(4)
+#define NFS_ATTR_FATTR_RDEV		BIT_ULL(5)
+#define NFS_ATTR_FATTR_SIZE		BIT_ULL(6)
+#define NFS_ATTR_FATTR_PRESIZE		BIT_ULL(7)
+#define NFS_ATTR_FATTR_BLOCKS_USED	BIT_ULL(8)
+#define NFS_ATTR_FATTR_SPACE_USED	BIT_ULL(9)
+#define NFS_ATTR_FATTR_FSID		BIT_ULL(10)
+#define NFS_ATTR_FATTR_FILEID		BIT_ULL(11)
+#define NFS_ATTR_FATTR_ATIME		BIT_ULL(12)
+#define NFS_ATTR_FATTR_MTIME		BIT_ULL(13)
+#define NFS_ATTR_FATTR_CTIME		BIT_ULL(14)
+#define NFS_ATTR_FATTR_PREMTIME		BIT_ULL(15)
+#define NFS_ATTR_FATTR_PRECTIME		BIT_ULL(16)
+#define NFS_ATTR_FATTR_CHANGE		BIT_ULL(17)
+#define NFS_ATTR_FATTR_PRECHANGE	BIT_ULL(18)
+#define NFS_ATTR_FATTR_V4_LOCATIONS	BIT_ULL(19)
+#define NFS_ATTR_FATTR_V4_REFERRAL	BIT_ULL(20)
+#define NFS_ATTR_FATTR_MOUNTPOINT	BIT_ULL(21)
+#define NFS_ATTR_FATTR_MOUNTED_ON_FILEID BIT_ULL(22)
+#define NFS_ATTR_FATTR_OWNER_NAME	BIT_ULL(23)
+#define NFS_ATTR_FATTR_GROUP_NAME	BIT_ULL(24)
+#define NFS_ATTR_FATTR_V4_SECURITY_LABEL BIT_ULL(25)
 
 #define NFS_ATTR_FATTR (NFS_ATTR_FATTR_TYPE \
 		| NFS_ATTR_FATTR_MODE \
-- 
2.51.0



