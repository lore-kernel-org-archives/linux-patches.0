Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A16072AF07;
	Mon, 28 Oct 2024 06:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098511; cv=none; b=Uru9vszOViIJ1Qi/XDC7sXINqHbOaBuOgoOC2kwk7BohCvAAjyeaowpi4jCoG66zQ5vir8r05NUv7oJlmq4Pgfej8gvZZEmiXbuYg+VG9QqNif8YtcW3RUk4wJ34ZrXnXGfYabYLwYBHH1QWuaIOt/VkSoqDIShg8xERnMnskY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098511; c=relaxed/simple;
	bh=Q6cpx5RdZN5gegGY5VOUjOXnqr04zC42B0RI21qfZoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oktSgh3fwDm6tg5M1HgRQ4tom96TNJTGvTB85qvZO+PLJZQLlaKM1Cci5e1CdLvSudPxccMxPR+DUIQNwq3um5mvAwPbA68d+OSNlsElPajcf6RT0t8O8rLWxuvLpj2LLyQ1lMQ7PoVsl2mF6jbUNDEshbROYc7xBVbVKw0DS8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wYK3xVWf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wYK3xVWf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41054C4CEC3;
	Mon, 28 Oct 2024 06:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098511;
	bh=Q6cpx5RdZN5gegGY5VOUjOXnqr04zC42B0RI21qfZoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wYK3xVWfpIHKaf7dMf1pXa0b3d+/xHl/OuzuRnIWnSHZZ9VslRJfq5I5PuC3lCU88
	 JZNtfR6oDf4BLzuFnWi0/gaMvzV2LEQ0IarSbB/M3jl/yzgEVOP57TIy3+ahkFsRHl
	 YsuAyeRaHic5WVUcCpJb37jL0vXAcN3xgyrf6tMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>
Subject: [PATCH 6.11 252/261] Revert "fs/9p: remove redundant pointer v9ses"
Date: Mon, 28 Oct 2024 07:26:34 +0100
Message-ID: <20241028062318.422163907@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dominique Martinet <asmadeus@codewreck.org>

commit fedd06210b14febfa69e09d0721746749ea9ea20 upstream.

This reverts commit 10211b4a23cf4a3df5c11a10e5b3d371f16a906f.

This is a requirement to revert commit 724a08450f74 ("fs/9p: simplify
iget to remove unnecessary paths"), see that revert for details.

Fixes: 724a08450f74 ("fs/9p: simplify iget to remove unnecessary paths")
Reported-by: Will Deacon <will@kernel.org>
Link: https://lkml.kernel.org/r/20240923100508.GA32066@willie-the-truck
Cc: stable@vger.kernel.org # v6.9+
Message-ID: <20241024-revert_iget-v1-2-4cac63d25f72@codewreck.org>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/9p/vfs_inode_dotl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 55dde186041a..2b313fe7003e 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -297,6 +297,7 @@ static int v9fs_vfs_mkdir_dotl(struct mnt_idmap *idmap,
 			       umode_t omode)
 {
 	int err;
+	struct v9fs_session_info *v9ses;
 	struct p9_fid *fid = NULL, *dfid = NULL;
 	kgid_t gid;
 	const unsigned char *name;
@@ -306,6 +307,7 @@ static int v9fs_vfs_mkdir_dotl(struct mnt_idmap *idmap,
 	struct posix_acl *dacl = NULL, *pacl = NULL;
 
 	p9_debug(P9_DEBUG_VFS, "name %pd\n", dentry);
+	v9ses = v9fs_inode2v9ses(dir);
 
 	omode |= S_IFDIR;
 	if (dir->i_mode & S_ISGID)
@@ -737,6 +739,7 @@ v9fs_vfs_mknod_dotl(struct mnt_idmap *idmap, struct inode *dir,
 	kgid_t gid;
 	const unsigned char *name;
 	umode_t mode;
+	struct v9fs_session_info *v9ses;
 	struct p9_fid *fid = NULL, *dfid = NULL;
 	struct inode *inode;
 	struct p9_qid qid;
@@ -746,6 +749,7 @@ v9fs_vfs_mknod_dotl(struct mnt_idmap *idmap, struct inode *dir,
 		 dir->i_ino, dentry, omode,
 		 MAJOR(rdev), MINOR(rdev));
 
+	v9ses = v9fs_inode2v9ses(dir);
 	dfid = v9fs_parent_fid(dentry);
 	if (IS_ERR(dfid)) {
 		err = PTR_ERR(dfid);
-- 
2.47.0



