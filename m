Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40CF4C62;
	Mon, 23 Jun 2025 21:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713568; cv=none; b=dGRIHPtRUjJWAvV4RoT0rEe8rdF0eTFyIb/27PvWEESnQvno0PVpyktCHciRhOMD3TOYDnmYqaO2oEmU8r0HeYzg+IyCxNDhL/k8fnGp2aXN+/YcaIrszuz9yBBmIiwdBvXfN+dSqFKZdAQTtJNsX82/El451/Gv0N8lwpvJRO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713568; c=relaxed/simple;
	bh=VzWf7hDtdHfDM1VMNj++4w+E5XJ7Lt7gFmEDZoOb7yA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SsV/miZvIqcejy8oxiDZMXsWVWoUwk0ozYvkSk/qurhsS5Oh0o6JrTJlVIPakzD9VABSfjx1uTclP/d0aNmx/bKxTW1gv9eu4KZL1NBiFfYkuUNXzQtKOILqf2F/ToBzTJiO0Q2PVKSmKUXsO1XC2KkhH5boXw0CHqXNrCMT3k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RNH3NlSc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RNH3NlSc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BEB4C4CEEA;
	Mon, 23 Jun 2025 21:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713567;
	bh=VzWf7hDtdHfDM1VMNj++4w+E5XJ7Lt7gFmEDZoOb7yA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RNH3NlScc/WgU1JQ8U+OABYMfyor1HNTHtvwVs/bjfX9EPyYDgea5JeIVk20A0Ot/
	 ON86nTaxUHUeyKY7CJuCcE8y3sntONuRuwS7QO1UYd2t1hmjebpqJ+M0L5mOniIPgA
	 96WVG0kSokUKG9I+xwg+7UehxS9PSAMb/83d6HZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 104/508] f2fs: use d_inode(dentry) cleanup dentry->d_inode
Date: Mon, 23 Jun 2025 15:02:29 +0200
Message-ID: <20250623130647.838946820@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9da104c0743c4..77fa3c639ba38 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -401,7 +401,7 @@ static int f2fs_link(struct dentry *old_dentry, struct inode *dir,
 
 	if (is_inode_flag_set(dir, FI_PROJ_INHERIT) &&
 			(!projid_eq(F2FS_I(dir)->i_projid,
-			F2FS_I(old_dentry->d_inode)->i_projid)))
+			F2FS_I(inode)->i_projid)))
 		return -EXDEV;
 
 	err = f2fs_dquot_initialize(dir);
@@ -896,7 +896,7 @@ static int f2fs_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
 
 	if (is_inode_flag_set(new_dir, FI_PROJ_INHERIT) &&
 			(!projid_eq(F2FS_I(new_dir)->i_projid,
-			F2FS_I(old_dentry->d_inode)->i_projid)))
+			F2FS_I(old_inode)->i_projid)))
 		return -EXDEV;
 
 	/*
@@ -1085,10 +1085,10 @@ static int f2fs_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 
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
index 72160b906f4b3..c1738820a8f0d 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1830,9 +1830,9 @@ static int f2fs_statfs(struct dentry *dentry, struct kstatfs *buf)
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



