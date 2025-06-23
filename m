Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C93D230BC2;
	Mon, 23 Jun 2025 13:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685549; cv=none; b=WzeS5gAw9D4U1/6ah7bFYeraCRTd4stwt5PnwrzxuzPVDfcgRtA4AhGNZO5hIY2ysV+SUuy6Z5/wOKM0gdJcaAHkyTgchEdpG1dmOSlmyRCCBaLhCgjaLeeOCpRm4G1aeKCGCs1opBFC5kZmgjMuUPsvUel8jdVTg5bI+5bM92g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685549; c=relaxed/simple;
	bh=D0rlVsyLep/ODSUaMhUtH48752HF2uXqSZz+WPY6ti0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U0IK8AFHd9QlRBWzRJrPqXvs1biJYlAZWQgf9LXDN43/keZtSyYiFkK9sU94idXsFbEhK0Uiya+rGM2z6DehNUYiJtOAglAl8JRlFjLHKA9PUixHFNmrGEEDbLvUAjL9lmlKvH9tcQu0j+eETQYbw7/HRxFvrBbF1+xIPyv+oZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wW9VC/M1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wW9VC/M1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A0EC4CEEA;
	Mon, 23 Jun 2025 13:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685549;
	bh=D0rlVsyLep/ODSUaMhUtH48752HF2uXqSZz+WPY6ti0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wW9VC/M1Q0g0k/0KNKyswJawdwEo7R3gFOa4OQin5mk1tTHHwA/Te9DkUES33xTn2
	 HC34WMYvgBfQYWaYLlMFWxRBn6ss1BI2XZJY/qleNbGLSgFXMhMAVbglsL69RekfRQ
	 bHj1wf+rFp2K7PdnYjpyDeLB55aWuPh9BzcMN17U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 058/355] f2fs: use d_inode(dentry) cleanup dentry->d_inode
Date: Mon, 23 Jun 2025 15:04:19 +0200
Message-ID: <20250623130628.568533103@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 56d23bc254353..1e3e525be68bf 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -396,7 +396,7 @@ static int f2fs_link(struct dentry *old_dentry, struct inode *dir,
 
 	if (is_inode_flag_set(dir, FI_PROJ_INHERIT) &&
 			(!projid_eq(F2FS_I(dir)->i_projid,
-			F2FS_I(old_dentry->d_inode)->i_projid)))
+			F2FS_I(inode)->i_projid)))
 		return -EXDEV;
 
 	err = dquot_initialize(dir);
@@ -932,7 +932,7 @@ static int f2fs_rename(struct inode *old_dir, struct dentry *old_dentry,
 
 	if (is_inode_flag_set(new_dir, FI_PROJ_INHERIT) &&
 			(!projid_eq(F2FS_I(new_dir)->i_projid,
-			F2FS_I(old_dentry->d_inode)->i_projid)))
+			F2FS_I(old_inode)->i_projid)))
 		return -EXDEV;
 
 	/*
@@ -1122,10 +1122,10 @@ static int f2fs_cross_rename(struct inode *old_dir, struct dentry *old_dentry,
 
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
index 9afbb51bd6780..d1a5c64963b6f 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1507,9 +1507,9 @@ static int f2fs_statfs(struct dentry *dentry, struct kstatfs *buf)
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



