Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA9F34320D;
	Tue, 16 Dec 2025 11:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884838; cv=none; b=Z4vnTNsA/hcgQal86+Ur0VPIu65Z4oDrfRhKgwZ5JPgNVqfw/A4gY0l549cIJ7ABPTLeYnnrHrrAGrzvNXN6bf0byCzHTwKANZVnkbF/cQ4P+eQVOXC8jEV4EMS38KYlWa9ltwUcIcflyC+Z3AdyR84YxisHZS6bePFAT/2fvvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884838; c=relaxed/simple;
	bh=tWpR2EZJneZmlGg7Gaw+XBttQxflLjgAOYweqbD2FZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MImBkQT7aEsYDoDyUmqQvrspfQTAm4svcpwQwNwRuTH0lqxrRIhbT6PLEDk78IPkF6fv+mwgOGi2h6qhYcFiz3UAsllWabY2wz43J2/Z4JzNNR4vD0go1tFyL4dd4S1FFVIgBvi+G1D5tZzODL19X2L6ASw5ZMzJaOWwU2286yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zBeeLzQ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zBeeLzQ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFBC7C4CEF1;
	Tue, 16 Dec 2025 11:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884838;
	bh=tWpR2EZJneZmlGg7Gaw+XBttQxflLjgAOYweqbD2FZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zBeeLzQ5raWSF1mXITqLrX5GSj0HIFqgeIvNQ+/v1IEMbLbWESlTeoaoyrpKnNf08
	 N0cy9Axq+d6F1MLx1ypEt1WD/GeWpq+JFVxSjRok980BxXl/08tVeu9gEhLK2TYqiR
	 5NWR1RV+aje3TnOW/FgokpXyxVCE3t9hancL6CZA=
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
Subject: [PATCH 6.12 313/354] Expand the type of nfs_fattr->valid
Date: Tue, 16 Dec 2025 12:14:40 +0100
Message-ID: <20251216111332.250851195@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5bab9db5417c2..1b43331eb6ece 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -2214,7 +2214,7 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 	bool attr_changed = false;
 	bool have_delegation;
 
-	dfprintk(VFS, "NFS: %s(%s/%lu fh_crc=0x%08x ct=%d info=0x%x)\n",
+	dfprintk(VFS, "NFS: %s(%s/%lu fh_crc=0x%08x ct=%d info=0x%llx)\n",
 			__func__, inode->i_sb->s_id, inode->i_ino,
 			nfs_display_fhandle_hash(NFS_FH(inode)),
 			atomic_read(&inode->i_count), fattr->valid);
diff --git a/include/linux/nfs_fs_sb.h b/include/linux/nfs_fs_sb.h
index 2cff5cafbaa78..97edf7b583d5e 100644
--- a/include/linux/nfs_fs_sb.h
+++ b/include/linux/nfs_fs_sb.h
@@ -169,8 +169,8 @@ struct nfs_server {
 #define NFS_MOUNT_SHUTDOWN			0x08000000
 #define NFS_MOUNT_NO_ALIGNWRITE		0x10000000
 
-	unsigned int		fattr_valid;	/* Valid attributes */
 	unsigned int		caps;		/* server capabilities */
+	__u64			fattr_valid;	/* Valid attributes */
 	unsigned int		rsize;		/* read size */
 	unsigned int		rpages;		/* read size (in pages) */
 	unsigned int		wsize;		/* write size */
diff --git a/include/linux/nfs_xdr.h b/include/linux/nfs_xdr.h
index b7a08c875514f..ea751edf247bf 100644
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



