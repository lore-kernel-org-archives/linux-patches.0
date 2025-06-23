Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3D124BBE4;
	Mon, 23 Jun 2025 13:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684859; cv=none; b=k5BUyMHqN8sL0hQhODD8oIHqipYeBAtPYOad/l74CUGzj5CyQoubG2q1+QZ7KoaSSioFpa51/MI5CTqZ18lAGx/YBSAebD1w+CYOzGZj/tI2bxlStrrJ0/bV0M/qtyjJfFVe6v2xCjBgjEOBfILkvvwOnKAcI9DukXnuhRq+dsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684859; c=relaxed/simple;
	bh=qxObiOjVLEbe7HopXL9RuYnz1JrPR+HomhiV5H1Kd1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o3SwwyquBslNIViEthV+Mpr7wJsZY2Tv6aTZi5BIojDx55thURjE/ITFqecNDC+r2skFqMokYLZHchW4+jKaBYVaLDwlL8zY4xr8zsnpTgL1/F8ygF0/XauoL1Liam9F7IKKeaI+PvMVHArqVuerfXyNLd50zRJoQdJiLz5sFiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wCZwiK6I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wCZwiK6I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC1EC4CEF0;
	Mon, 23 Jun 2025 13:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684859;
	bh=qxObiOjVLEbe7HopXL9RuYnz1JrPR+HomhiV5H1Kd1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wCZwiK6Ia9lpepscR9PdLUV6ZD4rpZbbhyTqAKVxU22kggYEbn5Y+sz9uri4GprD9
	 yRPBDceEoFi7781favDP8fATsquX8oG5bdqPj/UR8p2q+Q56Lrdofb9Ot+Gc0iG+M3
	 5LE/xA+2bZNKGT2Mrd/MhXFWZJ+t2tquy+ZlamyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 040/222] f2fs: use d_inode(dentry) cleanup dentry->d_inode
Date: Mon, 23 Jun 2025 15:06:15 +0200
Message-ID: <20250623130613.108160386@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiguo Niu <zhiguo.niu@unisoc.com>

[ Upstream commit a6c397a31f58a1d577c2c8d04b624e9baa31951c ]

no logic changes.

Signed-off-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/namei.c | 8 ++++----
 fs/f2fs/super.c | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 99a91c746b399..e74e5d2570ef6 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -329,7 +329,7 @@ static int f2fs_link(struct dentry *old_dentry, struct inode *dir,
 
 	if (is_inode_flag_set(dir, FI_PROJ_INHERIT) &&
 			(!projid_eq(F2FS_I(dir)->i_projid,
-			F2FS_I(old_dentry->d_inode)->i_projid)))
+			F2FS_I(inode)->i_projid)))
 		return -EXDEV;
 
 	err = dquot_initialize(dir);
@@ -869,7 +869,7 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 	if (is_inode_flag_set(new_dir, FI_PROJ_INHERIT) &&
 			(!projid_eq(F2FS_I(new_dir)->i_projid,
-			F2FS_I(old_dentry->d_inode)->i_projid)))
+			F2FS_I(old_inode)->i_projid)))
 		return -EXDEV;
 
 	if (flags & RENAME_WHITEOUT) {
@@ -1066,10 +1066,10 @@ static int f2fs_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 	if ((is_inode_flag_set(new_dir, FI_PROJ_INHERIT) &&
 			!projid_eq(F2FS_I(new_dir)->i_projid,
-			F2FS_I(old_dentry->d_inode)->i_projid)) ||
+			F2FS_I(old_inode)->i_projid)) ||
 	    (is_inode_flag_set(new_dir, FI_PROJ_INHERIT) &&
 			!projid_eq(F2FS_I(old_dir)->i_projid,
-			F2FS_I(new_dentry->d_inode)->i_projid)))
+			F2FS_I(new_inode)->i_projid)))
 		return -EXDEV;
 
 	err = dquot_initialize(old_dir);
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index da51474596eff..d4ba9ad16a137 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1342,9 +1342,9 @@ static int f2fs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_fsid.val[1] = (u32)(id >> 32);
 
 #ifdef CONFIG_QUOTA
-	if (is_inode_flag_set(dentry->d_inode, FI_PROJ_INHERIT) &&
+	if (is_inode_flag_set(d_inode(dentry), FI_PROJ_INHERIT) &&
 			sb_has_quota_limits_enabled(sb, PRJQUOTA)) {
-		f2fs_statfs_project(sb, F2FS_I(dentry->d_inode)->i_projid, buf);
+		f2fs_statfs_project(sb, F2FS_I(d_inode(dentry))->i_projid, buf);
 	}
 #endif
 	return 0;
-- 
2.39.5



