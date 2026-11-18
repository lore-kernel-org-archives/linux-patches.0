Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045306;
	b=AZy4CQhLmG7a9FiN2JfOY2SfrP/4XZDssObT0aI+FGkFHFhhUlRvVP8njsfM1HTiH6Js
	 rFnJpm6vDb/d8DAlVburprhvtfmMIDPwW/EXIuDsAh9QF9Wt1+tq5T/3Yy7XgJ3aBsKWr
	 bgbsWXzgaJBWlcyDsPaE2E2xSOeRPOvvvgvoywSivWjPcEIMhh4lHHCOUfYC+h9oqYDNu
	 /lfwvuxmz6mf09PM0SmvDEmedtl5qFg4Dm6F7XcuxWUaQ5r3cXOslyv++fGbaR7h1O6gr
	 gmB9xhS3BWE0JgWjRezx3ezkvC1X6zrZp7wkhvX2Fs9w6ofnFOj0V+V1Pcz9BIx+CWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045306;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iedEG45REsGPNWNas4H/JV6ruo5Hce5oZmR4QbUixuI=;
	b=rRGKajcxF5Lk5bj1jLRGXihCVnMNz09a1RXqgZEQHvaJ2MpzUgb3qxrvdtNd6wBwajDh
	 44Wnq7Wwkbmqc30GhU9NY/UjhJNV8q6mqk5vFm6kdM9aPLL/xE0MqSJs2PHFvOZkZf51W
	 meJT77Ji/Aey38+pEllGF0JucSioGEga5XOGemUOrRTjWdNvGXEJaP1BfsKrV53anTecL
	 1G+EnGM3xPeyjw+p4dnE4c/AA7A5GPHVPzGo1qpVSqmkc5QxSnu9yO0wtZhMjq0Lkvxrt
	 p1MIxtB0wjsPbDE5TN91ULXw1DVy4XcX6AufxiY2Oc/OXbhyoIEjDDC/e36DzqLmxNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2NvpoZRg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8668E606A32C;
	Wed, 18 Nov 2026 23:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2NvpoZRg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 870461F000C4;
	Wed, 18 Nov 2026 23:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045306;
	bh=iedEG45REsGPNWNas4H/JV6ruo5Hce5oZmR4QbUixuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2NvpoZRg7uIFXHrTx2KhRDC8QG1j5DTe6+2G5KU3587YZZzk3KSWI6j+vQgq6ywXj
	 3WZxLElP1Fs5bIX8MC6++PuOUviq7oCb6UT9YmxXnru35e1UMFEoXlkQ9bnWF7vex2
	 pZ2sx11v86Id11nMJISGtG2zOqJzVTWdQXP14YRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0875/2857] fsverity: hoist statx reporting of fs-verity flag
Date: Wed, 18 Nov 2026 15:31:49 +0100
Message-ID: <20261118150233.067806015@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 976aad24ae0a3..abc834c828519 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -9262,7 +9262,6 @@ static int btrfs_getattr(struct user_namespace *mnt_userns,
 	struct inode *inode = d_inode(path->dentry);
 	u32 blocksize = btrfs_sb(inode->i_sb)->sectorsize;
 	u32 bi_flags = BTRFS_I(inode)->flags;
-	u32 bi_ro_flags = BTRFS_I(inode)->ro_flags;
 
 	stat->result_mask |= STATX_BTIME;
 	stat->btime.tv_sec = BTRFS_I(inode)->i_otime.tv_sec;
@@ -9275,8 +9274,6 @@ static int btrfs_getattr(struct user_namespace *mnt_userns,
 		stat->attributes |= STATX_ATTR_IMMUTABLE;
 	if (bi_flags & BTRFS_INODE_NODUMP)
 		stat->attributes |= STATX_ATTR_NODUMP;
-	if (bi_ro_flags & BTRFS_INODE_RO_VERITY)
-		stat->attributes |= STATX_ATTR_VERITY;
 
 	stat->attributes_mask |= (STATX_ATTR_APPEND |
 				  STATX_ATTR_COMPRESSED |
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b17d13cea6c72..2bb05fc0bc094 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5797,15 +5797,12 @@ int ext4_getattr(struct user_namespace *mnt_userns, const struct path *path,
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
index 4dd995b0c472b..bde1c9cfe1df4 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -928,15 +928,12 @@ int f2fs_getattr(struct user_namespace *mnt_userns, const struct path *path,
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
 
 	generic_fillattr(mnt_userns, inode, stat);
 
diff --git a/fs/stat.c b/fs/stat.c
index ef50573c72a26..5f48a36ce4666 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -116,8 +116,12 @@ int vfs_getattr_nosec(const struct path *path, struct kstat *stat,
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



