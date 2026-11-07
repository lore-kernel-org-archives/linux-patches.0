Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064422;
	b=nKOSsOevwSLsClRYBOSOe4unrydpradrtfz5fm3jtW3sHJfHTy5bSh1yubTHIGbwre+B
	 C/Xy5fZpXaMgweQs5G/CA7nUf5Tzw/zGKqUkuJdxcgMsLKEv5TT9Ulaq8PUHIl0IQpSuZ
	 KUxeVYKI8IElZdx5PAKVId5eoBHeIf7Nxj9kva6MTiL6oqUK/NhCP/vuS2wr2Nemktuab
	 5ndX4uoOzAMRLMSlR3RuEam3YIvJnSkO2pB7TAh9oHSb/zHXzZ9LpeZ/F/wUHALxPhXiG
	 QS5oWdnZGKuQwQ9x+DrG4iADfbeYwYUSRmQ5f+h4iIBwvcFB1ZM+mq6wxHCxty/KJrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064422;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=A09vAVsi+fEWdHjPra5S3lDpGb3MDw1J+YK3JmqYf0U=;
	b=zoj1LRt3mfYAROn2CdJjpPkJ3A4bd4eJTaI3r+vlQlV6UbogjP7NloycpF0X6sjIRPbb
	 DUhLeaSBNOV1JT7Hdh7xtZ/qASTogR25zAWCLcIH3WeB6Idjfhb5dpKrQSgrZWvT0GZ/L
	 rnrMF8JqUGnwosluXkcrU8fG4dxoM2tUEe9Lk7pnhWWwe0tSZxdW6ftnupBrTfpQxYm0N
	 I4fg/VPWr32JwH40gWDcrxYvRnDXU054pTWI9eawhGNkYoOqlp6xJqLYsXtcZ5F7Rl8QV
	 feQymL22ELkyVJ7w+Sx9JAzUrUiD/0sSdVYZ6vlsfjpNoslYE71PzQEvcHs/Iz3vMcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xmKGWBxi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9EC8606A9C1;
	Sat,  7 Nov 2026 15:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xmKGWBxi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943FB1F0089F;
	Sat,  7 Nov 2026 15:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064421;
	bh=A09vAVsi+fEWdHjPra5S3lDpGb3MDw1J+YK3JmqYf0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xmKGWBxi5YEmwZM+JOhL4M2Y0cStpzulrWbEFALQYVFCEblG+ksbPMBzbCB00wys1
	 3JrWdVsbfQXkWOK2JtMO5w4zf2g0HPbExep2kU5C75FF4apNmBowA0/8d8MvZIdd8T
	 KaUNtAYAB9KI53Zx5Bqr6T+9DH9lDH2bVpnfYBZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0472/1257] fsverity: hoist statx reporting of fs-verity flag
Date: Sat,  7 Nov 2026 08:46:08 -0500
Message-ID: <20261107134952.490617516@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index faf6ed7deb18b..aa1201fe4d7f8 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8252,7 +8252,6 @@ static int btrfs_getattr(struct mnt_idmap *idmap,
 	struct inode *inode = d_inode(path->dentry);
 	u32 blocksize = btrfs_sb(inode->i_sb)->sectorsize;
 	u32 bi_flags = BTRFS_I(inode)->flags;
-	u32 bi_ro_flags = BTRFS_I(inode)->ro_flags;
 
 	stat->result_mask |= STATX_BTIME;
 	stat->btime.tv_sec = BTRFS_I(inode)->i_otime_sec;
@@ -8265,8 +8264,6 @@ static int btrfs_getattr(struct mnt_idmap *idmap,
 		stat->attributes |= STATX_ATTR_IMMUTABLE;
 	if (bi_flags & BTRFS_INODE_NODUMP)
 		stat->attributes |= STATX_ATTR_NODUMP;
-	if (bi_ro_flags & BTRFS_INODE_RO_VERITY)
-		stat->attributes |= STATX_ATTR_VERITY;
 
 	stat->attributes_mask |= (STATX_ATTR_APPEND |
 				  STATX_ATTR_COMPRESSED |
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 26f0f9714f03c..206c6245c6192 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -6318,15 +6318,12 @@ int ext4_getattr(struct mnt_idmap *idmap, const struct path *path,
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
 
 	generic_fillattr(idmap, request_mask, inode, stat);
 	return 0;
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 29466a7367e55..5bd908799e7d5 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1075,15 +1075,12 @@ int f2fs_getattr(struct mnt_idmap *idmap, const struct path *path,
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
 
 	generic_fillattr(idmap, request_mask, inode, stat);
 
diff --git a/fs/stat.c b/fs/stat.c
index c461c30542340..e03954c36b33e 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -203,8 +203,12 @@ int vfs_getattr_nosec(const struct path *path, struct kstat *stat,
 	if (IS_DAX(inode))
 		stat->attributes |= STATX_ATTR_DAX;
 
+	if (IS_VERITY(inode))
+		stat->attributes |= STATX_ATTR_VERITY;
+
 	stat->attributes_mask |= (STATX_ATTR_AUTOMOUNT |
-				  STATX_ATTR_DAX);
+				  STATX_ATTR_DAX |
+				  STATX_ATTR_VERITY);
 
 	idmap = mnt_idmap(path->mnt);
 	if (inode->i_op->getattr) {
-- 
2.53.0



