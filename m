Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052635;
	b=F5sMDTvq+2H1lfGj98nLGzt5jiFISMUCExUo662AWFP5XS7TT/0eQ268vw88CLOVF4WE
	 U0Q1ObbIXoTLROUPA4aVd5pSsp9FamiClyhdv0vY0fvdY1IbDNSIf/VBiFKHjh5UPN9Gw
	 a2+xXx5HNSAfIDtDP0Lfc4ntxgawfbbyCf3SB/qWddKbBqOhzxDLS2vOeT6342mivg6vl
	 cXobuE07XeqGmQbgtKZmZGU04HkWZJpHCb+WbCKCVHI7DM2dffrw+0ZBpvsB3+gnkG+fa
	 sCzBE7EpydTeiYBjzEaI84kbjfLus9xayrzVSgzwV96thOz/f17x8Ze5rH98pxsSssw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052635;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BhgLH4qx3hxVo80Fz8FD5zgRzo3RjDkQlMEyj0xsKlk=;
	b=DAHjdwFbORcQCEzz07EckfQrfyHk/CYAIJaFGTdHTzqrc/eJ6sbr5U5DuAearAdwO9wQ
	 GQpBelIdfAM42vbTYNaAPTs32lWZq8fmo2EH5Iha1iVbor1hNhhMtpe2aSQ1CIJRi9Xdc
	 S+K+giaPEDESBQQisysXg7Ia9MqWS0BX5k5zx0A+jzD+EI0Lb8raLhAukqAAPe3IAg9aM
	 sOaWqrVPs3dXcVa4iTUQpon/RTbLuAJkVcQFalNXsz5TJUDTCs2UsaPvrEU1POSoEUAgS
	 OkVYSiucFBnB9usMEpsUxEIu+gdFKIqGbTHCtepBLRtVpjMN0jTECMr3P9ROXYybyuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HVvJCmWM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCCFE606A32A;
	Thu, 19 Nov 2026 01:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HVvJCmWM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 176211F000C4;
	Thu, 19 Nov 2026 01:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052635;
	bh=BhgLH4qx3hxVo80Fz8FD5zgRzo3RjDkQlMEyj0xsKlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HVvJCmWMVt0ScUOGNPyBCugialDi3vGwRORtTR5KIogJ/e+gpVrEH3TOBJCK5H+dU
	 88ereP/p3yj2t8mNamoXoHnq7rZ8iZ7nk5pZZSrfCPFgJXAtf3VAMtfeBQtRpojoCB
	 hrDZuO7UfDs7OGcNVntGgzb7Y9aIhFneK6OW4a0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0574/2214] fsverity: hoist statx reporting of fs-verity flag
Date: Wed, 18 Nov 2026 15:37:30 +0100
Message-ID: <20261118150033.919000783@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Albershteyn <aalbersh@kernel.org>

[ Upstream commit f9e450420da2624c93ce9585deebfabb87932774 ]

All filesystems, supporting fsverity, report this status by checking
inode flag. Also, BTRFS was missing stat->attributes_mask, which is
fixed now.

Fixes: 146054090b08 ("btrfs: initial fsverity support")
Cc: stable@vger.kernel.org
Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Acked-by: Eric Biggers <ebiggers@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Link: https://patch.msgid.link/20261002223705.2175542-7-aalbersh@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/inode.c | 3 ---
 fs/ext4/inode.c  | 5 +----
 fs/f2fs/file.c   | 5 +----
 fs/stat.c        | 6 +++++-
 4 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 6ea8ba9f7f423..17f6b60b28a3a 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9525,7 +9525,6 @@ static int btrfs_getattr(struct user_namespace *mnt_userns,
 	struct inode *inode = d_inode(path->dentry);
 	u32 blocksize = inode->i_sb->s_blocksize;
 	u32 bi_flags = BTRFS_I(inode)->flags;
-	u32 bi_ro_flags = BTRFS_I(inode)->ro_flags;
 
 	stat->result_mask |= STATX_BTIME;
 	stat->btime.tv_sec = BTRFS_I(inode)->i_otime.tv_sec;
@@ -9538,8 +9537,6 @@ static int btrfs_getattr(struct user_namespace *mnt_userns,
 		stat->attributes |= STATX_ATTR_IMMUTABLE;
 	if (bi_flags & BTRFS_INODE_NODUMP)
 		stat->attributes |= STATX_ATTR_NODUMP;
-	if (bi_ro_flags & BTRFS_INODE_RO_VERITY)
-		stat->attributes |= STATX_ATTR_VERITY;
 
 	stat->attributes_mask |= (STATX_ATTR_APPEND |
 				  STATX_ATTR_COMPRESSED |
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f248bd14c8dc9..f1e83f321b78e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5677,15 +5677,12 @@ int ext4_getattr(struct user_namespace *mnt_userns, const struct path *path,
 		stat->attributes |= STATX_ATTR_IMMUTABLE;
 	if (flags & EXT4_NODUMP_FL)
 		stat->attributes |= STATX_ATTR_NODUMP;
-	if (flags & EXT4_VERITY_FL)
-		stat->attributes |= STATX_ATTR_VERITY;
 
 	stat->attributes_mask |= (STATX_ATTR_APPEND |
 				  STATX_ATTR_COMPRESSED |
 				  STATX_ATTR_ENCRYPTED |
 				  STATX_ATTR_IMMUTABLE |
-				  STATX_ATTR_NODUMP |
-				  STATX_ATTR_VERITY);
+				  STATX_ATTR_NODUMP);
 
 	generic_fillattr(mnt_userns, inode, stat);
 	return 0;
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 01f772b1604b1..892f19f67904f 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -836,15 +836,12 @@ int f2fs_getattr(struct user_namespace *mnt_userns, const struct path *path,
 		stat->attributes |= STATX_ATTR_IMMUTABLE;
 	if (flags & F2FS_NODUMP_FL)
 		stat->attributes |= STATX_ATTR_NODUMP;
-	if (IS_VERITY(inode))
-		stat->attributes |= STATX_ATTR_VERITY;
 
 	stat->attributes_mask |= (STATX_ATTR_COMPRESSED |
 				  STATX_ATTR_APPEND |
 				  STATX_ATTR_ENCRYPTED |
 				  STATX_ATTR_IMMUTABLE |
-				  STATX_ATTR_NODUMP |
-				  STATX_ATTR_VERITY);
+				  STATX_ATTR_NODUMP);
 
 	generic_fillattr(&init_user_ns, inode, stat);
 
diff --git a/fs/stat.c b/fs/stat.c
index 246d138ec0669..fdea43738d50b 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -115,8 +115,12 @@ int vfs_getattr_nosec(const struct path *path, struct kstat *stat,
 	if (IS_DAX(inode))
 		stat->attributes |= STATX_ATTR_DAX;
 
+	if (IS_VERITY(inode))
+		stat->attributes |= STATX_ATTR_VERITY;
+
 	stat->attributes_mask |= (STATX_ATTR_AUTOMOUNT |
-				  STATX_ATTR_DAX);
+				  STATX_ATTR_DAX |
+				  STATX_ATTR_VERITY);
 
 	mnt_userns = mnt_user_ns(path->mnt);
 	if (inode->i_op->getattr)
-- 
2.53.0



