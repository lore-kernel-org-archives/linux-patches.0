Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062245;
	b=JwtPzAlQJjG7/iw4WzDigK+APRFCxYfWg/qZ8oo1jHf/X4h0zMo8TBl9LDeOuhKl1v/0
	 VmeUHzjT2JRkwo8K394rowX7ZxK2cOPrDImwdP1JuvuxXA1PY2PrbmiMo9rGKeof15gdr
	 LOe5HfcVCVYerQyPnsJPypM9e9UBqL3uy8lMgxnKAA/KeepZm110lxkBG9RRYjjHvItN+
	 LQ4ovgPvLSr67qJfQWZWdasQeTC3M1pXGzQytlWdsgrkQiXQy62A2VGOH9vJ9KPOqE8vE
	 sQVVrgYWuMe6eXtMjGCGcpS1xq1UZfU7lwP5kZt0ZiJxnpY3AtSwplz0fWHRNKfsmeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062245;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ES+pvpZC35A5aFIlwTY30HcSJXKLDmdIB5y4wiVQbvE=;
	b=o/D852d6CzGVESbuPod9ORLEv1kQkyWmfb29K88ekJwZAVfpvH5OBw6zLIZECOM87MO+
	 arvfvdOcrJay0P8T/JyygKUXhsM98jWAfduLAn7C4KyroXkSR5PNHnc1OWfUwFMqvmYrY
	 Md69alC/Aw1h1eNGKkUpMPsWZqTWl7dMscPZhVGQ81HTsG3TKKRokDZOGqJR7yDGy73e1
	 jcyHiz9Qoht3eoi7ONwcR8kpLsHo+M1NAOqkF7bPyH1TCYydL+EHDixLaP31ExajciW27
	 UAuF0VOBBWBbJYQ+J9npalvIZl2Majzv2+9ksReeSzQT3BstEUP/K0bceuHO8luwpIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q2SbbQkQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E3A606EE82;
	Sat,  7 Nov 2026 14:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q2SbbQkQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDE821F0089F;
	Sat,  7 Nov 2026 14:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062245;
	bh=ES+pvpZC35A5aFIlwTY30HcSJXKLDmdIB5y4wiVQbvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q2SbbQkQEKsytW6cB2SZrq6pEaIoq4QxoFOU5jyaqcOiEvHC9ErdhKoeBx0lpJKMV
	 zwQJ8pZfVVTIkEDcr02s+1LDx9I0kGiODsFczVlWdNxBsSvx0SIGivJdXlnLyEIwLI
	 rpUR/ymdRLOyL6IK+Z9SX8t5Nh2blXicNDPhPriQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrey Albershteyn <aalbersh@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1156/1536] fsverity: hoist statx reporting of fs-verity flag
Date: Sat,  7 Nov 2026 08:52:52 -0500
Message-ID: <20261107135030.193192234@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9f3881db076fc..f1d9aa14c8286 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7854,7 +7854,6 @@ static int btrfs_getattr(struct mnt_idmap *idmap,
 	struct inode *inode = d_inode(path->dentry);
 	u32 blocksize = btrfs_sb(inode->i_sb)->sectorsize;
 	u32 bi_flags = BTRFS_I(inode)->flags;
-	u32 bi_ro_flags = BTRFS_I(inode)->ro_flags;
 
 	stat->result_mask |= STATX_BTIME;
 	stat->btime.tv_sec = BTRFS_I(inode)->i_otime_sec;
@@ -7867,8 +7866,6 @@ static int btrfs_getattr(struct mnt_idmap *idmap,
 		stat->attributes |= STATX_ATTR_IMMUTABLE;
 	if (bi_flags & BTRFS_INODE_NODUMP)
 		stat->attributes |= STATX_ATTR_NODUMP;
-	if (bi_ro_flags & BTRFS_INODE_RO_VERITY)
-		stat->attributes |= STATX_ATTR_VERITY;
 
 	stat->attributes_mask |= (STATX_ATTR_APPEND |
 				  STATX_ATTR_COMPRESSED |
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index dcd67771f3a3b..aa33c974e9af5 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5749,15 +5749,12 @@ int ext4_getattr(struct mnt_idmap *idmap, const struct path *path,
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
index b4bd73648a014..df4bad21dcc71 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1013,15 +1013,12 @@ int f2fs_getattr(struct mnt_idmap *idmap, const struct path *path,
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
index 41e598376d7e3..80344764a3297 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -158,8 +158,12 @@ int vfs_getattr_nosec(const struct path *path, struct kstat *stat,
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
 	if (inode->i_op->getattr)
-- 
2.53.0



