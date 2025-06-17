Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A2E23A9B3;
	Tue, 17 Jun 2025 16:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177639; cv=none; b=CVo7xFMdYnC9kr+paCDTTV9afCZCn8LO8NWIygqeV8iV+Fs/bSIGfDGmIfsfvXMg40EmoB6HKJhxKja8vnXBUA0cRQe1GE0fj4b+45viekSk2qtBh3wgNu6OTrz/e4PmiZhJ1a14eyz4Lu/FxHOFjJpGvChOgccA2ffXsVb9TyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177639; c=relaxed/simple;
	bh=9nP+Ozyg+4jwEV6eif+y+HPcY5rYdOzZmKvXSqkq4nQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qka+4XPNhQEebImjGIuPzxb/yoD81V7y+3vp2tpc0DMxdr7t/FCYyRY2g/e+LJSc65IXELosGnZiBcpi6nPzNRh6AWqSW9Sj5HoFtiId3Xcv7OESj9IbVVZkaC35jsEpp9r/fJ27e9nRagygHKqNsGkOWDqDBJ1bWDfwb4l6/vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XTV3bnI9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XTV3bnI9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7334CC4CEE3;
	Tue, 17 Jun 2025 16:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177639;
	bh=9nP+Ozyg+4jwEV6eif+y+HPcY5rYdOzZmKvXSqkq4nQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XTV3bnI9pdWZwqm1M4JDONmP3hsxP1oHFlyNJmJIvZm09dDpnw7VRIh1nmJTB3pdu
	 5zyaEaQ2ZlYpwID4NuqIfGxlPMHXLRxJiofD2lzlya6xJv14PoBJphPuWKIzT+VfsS
	 6HLaFZyACg9AClPsoD/nidiD3bq1zBXmCrilercA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 339/780] f2fs: use d_inode(dentry) cleanup dentry->d_inode
Date: Tue, 17 Jun 2025 17:20:47 +0200
Message-ID: <20250617152505.257042622@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiguo Niu <zhiguo.niu@unisoc.com>

[ Upstream commit a6c397a31f58a1d577c2c8d04b624e9baa31951c ]

no logic changes.

Signed-off-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 9883494c45a1 ("f2fs: fix to correct check conditions in f2fs_cross_rename")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/namei.c | 8 ++++----
 fs/f2fs/super.c | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index 8f8b9b843bdf4..faa5191cf4ca6 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -414,7 +414,7 @@ static int f2fs_link(struct dentry *old_dentry, struct inode *dir,
 
 	if (is_inode_flag_set(dir, FI_PROJ_INHERIT) &&
 			(!projid_eq(F2FS_I(dir)->i_projid,
-			F2FS_I(old_dentry->d_inode)->i_projid)))
+			F2FS_I(inode)->i_projid)))
 		return -EXDEV;
 
 	err = f2fs_dquot_initialize(dir);
@@ -914,7 +914,7 @@ static int f2fs_rename(struct mnt_idmap *idmap, struct inode *old_dir,
 
 	if (is_inode_flag_set(new_dir, FI_PROJ_INHERIT) &&
 			(!projid_eq(F2FS_I(new_dir)->i_projid,
-			F2FS_I(old_dentry->d_inode)->i_projid)))
+			F2FS_I(old_inode)->i_projid)))
 		return -EXDEV;
 
 	/*
@@ -1107,10 +1107,10 @@ static int f2fs_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 	if ((is_inode_flag_set(new_dir, FI_PROJ_INHERIT) &&
 			!projid_eq(F2FS_I(new_dir)->i_projid,
-			F2FS_I(old_dentry->d_inode)->i_projid)) ||
+			F2FS_I(old_inode)->i_projid)) ||
 	    (is_inode_flag_set(new_dir, FI_PROJ_INHERIT) &&
 			!projid_eq(F2FS_I(old_dir)->i_projid,
-			F2FS_I(new_dentry->d_inode)->i_projid)))
+			F2FS_I(new_inode)->i_projid)))
 		return -EXDEV;
 
 	err = f2fs_dquot_initialize(old_dir);
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 7a3bc85df6a7a..386326f7a440e 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1882,9 +1882,9 @@ static int f2fs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_fsid    = u64_to_fsid(id);
 
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



