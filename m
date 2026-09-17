Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B956C43F09B;
	Thu, 17 Sep 2026 19:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671683; cv=none; b=o3i3Bb6ClIiR6Bq4p1Ud6easjy157CoyZZkIJrmwIEjp8Egjz6BMtQAXWn4YaOPheZIOBxSj4UvYul1wbMZz2F2UYgU5DjOYi7Qyl+511xu1fs/BIfHMoMQU+ZTAAsB/1RlPIzxOzlx6GDc6XuWiQc9EgQoqrAR6jnxlV4uhkX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671683; c=relaxed/simple;
	bh=KQd+sWNMz0lrhsayC8t16eZ97BRCXf+nhptUNwCZGho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F2F7HgxcspmrnlI1ocYGvVk9F7NGq6PQXtEDdYdzXBM0vB+4NlW3PXtaPYytbw0ZSrrVeCwpd5Z6YbaDxrKOIGCZbm14qPLlUanofXqHGUi9Pe+AdbGag8VgAYcz+jKmNHGUDFNqz+ocal52vDiSK5aKofGOPLWcOYyOlEZ1xxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BIir7BaC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BIir7BaC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4775C1F008A2;
	Thu, 17 Sep 2026 19:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671669;
	bh=a9s3GVhON+qMC6d457Bw7UKoGpLYlb4poJGYOHmp2u4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BIir7BaCom0wkjcUW+2pCHNRSmYvEVNa8Mt+luGnXKnUaaYCtVrLg6q5WavNsT9cO
	 2cvgh9wmQLMzvc43r+TbKT5c3SMYBRwkPLJDBaRoYa26dPajy+WLg+0OqL7JuojbqZ
	 knuYfd6mQUHgCZbcMU7lnod7iwmPtQoguW/B+1II=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1045/1102] btrfs: parameter constification in ioctl.c
Date: Thu, 17 Sep 2026 16:16:28 +0100
Message-ID: <20260917151607.028911699@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: David Sterba <dsterba@suse.com>

[ Upstream commit 5e54f9420fc9b8096d0a4b579a84806a3ef0bf88 ]

Add const to function parameters that are not changed.

Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 15f7c86215e8 ("btrfs: do not overwrite NODATASUM flag when removing NODATACOW flag")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ioctl.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -117,8 +117,8 @@ struct btrfs_ioctl_encoded_io_args_32 {
 #endif
 
 /* Mask out flags that are inappropriate for the given type of inode. */
-static unsigned int btrfs_mask_fsflags_for_type(struct inode *inode,
-		unsigned int flags)
+static unsigned int btrfs_mask_fsflags_for_type(const struct inode *inode,
+						unsigned int flags)
 {
 	if (S_ISDIR(inode->i_mode))
 		return flags;
@@ -132,7 +132,7 @@ static unsigned int btrfs_mask_fsflags_f
  * Export internal inode flags to the format expected by the FS_IOC_GETFLAGS
  * ioctl.
  */
-static unsigned int btrfs_inode_flags_to_fsflags(struct btrfs_inode *binode)
+static unsigned int btrfs_inode_flags_to_fsflags(const struct btrfs_inode *binode)
 {
 	unsigned int iflags = 0;
 	u32 flags = binode->flags;
@@ -218,7 +218,7 @@ static int check_fsflags(unsigned int ol
 	return 0;
 }
 
-static int check_fsflags_compatible(struct btrfs_fs_info *fs_info,
+static int check_fsflags_compatible(const struct btrfs_fs_info *fs_info,
 				    unsigned int flags)
 {
 	if (btrfs_is_zoned(fs_info) && (flags & FS_NOCOW_FL))
@@ -247,7 +247,7 @@ static int btrfs_check_ioctl_vol_args2_s
  */
 int btrfs_fileattr_get(struct dentry *dentry, struct fileattr *fa)
 {
-	struct btrfs_inode *binode = BTRFS_I(d_inode(dentry));
+	const struct btrfs_inode *binode = BTRFS_I(d_inode(dentry));
 
 	fileattr_fill_flags(fa, btrfs_inode_flags_to_fsflags(binode));
 	return 0;
@@ -485,7 +485,7 @@ void btrfs_exclop_balance(struct btrfs_f
 	}
 }
 
-static int btrfs_ioctl_getversion(struct inode *inode, int __user *arg)
+static int btrfs_ioctl_getversion(const struct inode *inode, int __user *arg)
 {
 	return put_user(inode->i_generation, arg);
 }
@@ -557,7 +557,7 @@ static noinline int btrfs_ioctl_fitrim(s
  * Calculate the number of transaction items to reserve for creating a subvolume
  * or snapshot, not including the inode, directory entries, or parent directory.
  */
-static unsigned int create_subvol_num_items(struct btrfs_qgroup_inherit *inherit)
+static unsigned int create_subvol_num_items(const struct btrfs_qgroup_inherit *inherit)
 {
 	/*
 	 * 1 to add root block
@@ -967,7 +967,7 @@ static int btrfs_may_delete(struct mnt_i
 
 /* copy of may_create in fs/namei.c() */
 static inline int btrfs_may_create(struct mnt_idmap *idmap,
-				   struct inode *dir, struct dentry *child)
+				   struct inode *dir, const struct dentry *child)
 {
 	if (d_really_is_positive(child))
 		return -EEXIST;
@@ -1539,8 +1539,8 @@ out:
 	return ret;
 }
 
-static noinline int key_in_sk(struct btrfs_key *key,
-			      struct btrfs_ioctl_search_key *sk)
+static noinline int key_in_sk(const struct btrfs_key *key,
+			      const struct btrfs_ioctl_search_key *sk)
 {
 	struct btrfs_key test;
 	int ret;
@@ -1565,7 +1565,7 @@ static noinline int key_in_sk(struct btr
 
 static noinline int copy_to_sk(struct btrfs_path *path,
 			       struct btrfs_key *key,
-			       struct btrfs_ioctl_search_key *sk,
+			       const struct btrfs_ioctl_search_key *sk,
 			       u64 *buf_size,
 			       char __user *ubuf,
 			       unsigned long *sk_offset,
@@ -2843,7 +2843,7 @@ out_free:
 	return ret;
 }
 
-static long btrfs_ioctl_fs_info(struct btrfs_fs_info *fs_info,
+static long btrfs_ioctl_fs_info(const struct btrfs_fs_info *fs_info,
 				void __user *arg)
 {
 	struct btrfs_ioctl_fs_info_args *fi_args;
@@ -2897,7 +2897,7 @@ static long btrfs_ioctl_fs_info(struct b
 	return ret;
 }
 
-static long btrfs_ioctl_dev_info(struct btrfs_fs_info *fs_info,
+static long btrfs_ioctl_dev_info(const struct btrfs_fs_info *fs_info,
 				 void __user *arg)
 {
 	BTRFS_DEV_LOOKUP_ARGS(args);
@@ -4355,7 +4355,7 @@ static int btrfs_ioctl_get_features(stru
 	return 0;
 }
 
-static int check_feature_bits(struct btrfs_fs_info *fs_info,
+static int check_feature_bits(const struct btrfs_fs_info *fs_info,
 			      enum btrfs_feature_set set,
 			      u64 change_mask, u64 flags, u64 supported_flags,
 			      u64 safe_set, u64 safe_clear)


