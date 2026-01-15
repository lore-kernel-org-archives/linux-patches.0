Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB85029B200;
	Thu, 15 Jan 2026 17:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497529; cv=none; b=dCMF9xzaWc3wrrXGuVbyguQKDExnWaa5BvKg0/EgrYhEoN3D/QqxPqArcXCwh2afNQ+8cWrmF9TorxR9x6aaX9T8TK3rpbBRrO+CzEYDzs4mt6LnUKP7vRQ2xXIYx/RA2hYVbss5s3j0xP6Zc6dg3uHEtGpFrD1H4tzzye6lDSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497529; c=relaxed/simple;
	bh=UuP8GAKREXOfxs9AIVSQ660q1pMy+Ynump0sQaTnWvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GcaGtB/0NLzFs4PGSblSU7/4kwYGrceICgzYbgg/P0xJc0DIDNswOocy+OHs/kuXZ2OzSgnhrFl0axNESiJ9x73dft9mw1VdxO5OaV2nySqFNoJKsTZpfyO9GJoUURdqHqWFnxDcKBYjqL6OeE38FEC95PrsYTIk55P4zO/U3Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NDT4SoaG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NDT4SoaG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C78C116D0;
	Thu, 15 Jan 2026 17:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497529;
	bh=UuP8GAKREXOfxs9AIVSQ660q1pMy+Ynump0sQaTnWvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NDT4SoaGllB7b/VFNMEf9TpRbYG4z79xiHTaiVsumW390byGkKmEmjidOjAiN25Jc
	 C7vyyrUwXZxnHq9vanL0yRH8g3ZmJmI4MDu5SWF0q9hrnwTLdmVR+x1EpP1VpEIILz
	 1hpMQ0Wn5IfDhNmQSRE9b/SfgqKCIOxCW6VBu2dw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 114/554] fs/ntfs3: Remove unused mi_mark_free
Date: Thu, 15 Jan 2026 17:43:00 +0100
Message-ID: <20260115164250.379543161@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 6700eabb90d50c50be21ecbb71131cd6ecf91ded ]

Cleaning up dead code
Fix wrong comments

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Stable-dep-of: 4d78d1173a65 ("fs/ntfs3: out1 also needs to put mi")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/namei.c   |  2 +-
 fs/ntfs3/ntfs_fs.h |  1 -
 fs/ntfs3/record.c  | 22 ----------------------
 fs/ntfs3/super.c   |  2 +-
 4 files changed, 2 insertions(+), 25 deletions(-)

diff --git a/fs/ntfs3/namei.c b/fs/ntfs3/namei.c
index c1bce9d656cff..b66694b84caa0 100644
--- a/fs/ntfs3/namei.c
+++ b/fs/ntfs3/namei.c
@@ -218,7 +218,7 @@ static int ntfs_mkdir(struct user_namespace *mnt_userns, struct inode *dir,
 }
 
 /*
- * ntfs_rmdir - inode_operations::rm_dir
+ * ntfs_rmdir - inode_operations::rmdir
  */
 static int ntfs_rmdir(struct inode *dir, struct dentry *dentry)
 {
diff --git a/fs/ntfs3/ntfs_fs.h b/fs/ntfs3/ntfs_fs.h
index 7b46926e920c6..f7ef60bed6d84 100644
--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -740,7 +740,6 @@ static inline struct ATTRIB *rec_find_attr_le(struct mft_inode *rec,
 int mi_write(struct mft_inode *mi, int wait);
 int mi_format_new(struct mft_inode *mi, struct ntfs_sb_info *sbi, CLST rno,
 		  __le16 flags, bool is_mft);
-void mi_mark_free(struct mft_inode *mi);
 struct ATTRIB *mi_insert_attr(struct mft_inode *mi, enum ATTR_TYPE type,
 			      const __le16 *name, u8 name_len, u32 asize,
 			      u16 name_off);
diff --git a/fs/ntfs3/record.c b/fs/ntfs3/record.c
index 383fc3437f02e..cef53583f9a16 100644
--- a/fs/ntfs3/record.c
+++ b/fs/ntfs3/record.c
@@ -405,28 +405,6 @@ int mi_format_new(struct mft_inode *mi, struct ntfs_sb_info *sbi, CLST rno,
 	return err;
 }
 
-/*
- * mi_mark_free - Mark record as unused and marks it as free in bitmap.
- */
-void mi_mark_free(struct mft_inode *mi)
-{
-	CLST rno = mi->rno;
-	struct ntfs_sb_info *sbi = mi->sbi;
-
-	if (rno >= MFT_REC_RESERVED && rno < MFT_REC_FREE) {
-		ntfs_clear_mft_tail(sbi, rno, rno + 1);
-		mi->dirty = false;
-		return;
-	}
-
-	if (mi->mrec) {
-		clear_rec_inuse(mi->mrec);
-		mi->dirty = true;
-		mi_write(mi, 0);
-	}
-	ntfs_mark_rec_free(sbi, rno);
-}
-
 /*
  * mi_insert_attr - Reserve space for new attribute.
  *
diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index 78b0865273317..a9952b0321837 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -1382,7 +1382,7 @@ static const struct fs_context_operations ntfs_context_ops = {
 /*
  * ntfs_init_fs_context - Initialize spi and opts
  *
- * This will called when mount/remount. We will first initiliaze
+ * This will called when mount/remount. We will first initialize
  * options so that if remount we can use just that.
  */
 static int ntfs_init_fs_context(struct fs_context *fc)
-- 
2.51.0



