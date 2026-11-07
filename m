Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061364;
	b=uhKCefdFqnPOaIIwmA/aa5ltUrYFkXZMPoRyOsN3GZ2aS5jUCueSbvP9e6pC9Ry9nCPI
	 nCR8S9mQtCy9NrRsUEKgXFP7IMyLpY0+03wTVS9DZIwgXx8EvjwxCi7RBhfckdI2OkgBr
	 6oDbSlQgLV71rXejy5k/iiwVzXJijlzmn0+GdclXo3TBYaita7fnsBz76y55kyw/vvMTS
	 y/qki/P/tLbPqufXSyWRANZqIeLiJ9rT/mXUciJ7hH7wpM4Nwb14Lk7XRLLmVveNlBGux
	 mldVsB+e4Dj5s6v0daLwl6CMi11K3Vq0HMilfkmMqdR+6w1ZUVee07wsTjQgCIuNz4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061364;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l0RR+WGdR2C39mrb/yqPIOznQ5kLcs717Z4ljkUrmu0=;
	b=kazBZ4ab2nF2XlvAgBKVjg65qqOBpfl4+qd/ouGukCSuAtNEeHFVIefk2xG9Si+7KsAG
	 Qf85QDDgg9SbdQgmsIoEdM9lDDNNlUD+9xxm47ynSGL8nXmBGk4w6XZTpBCl+WPS7XMuy
	 KFpucXgq+PPPjhYYBMRhQaUWsCDWO1xwO3hNLdeGlnMwmBxi8mfE3SyXFvNGhfJxiD7VY
	 PHgz9dA/kNq5r47YXCITyVBHk0xyDLwmKyNx9SxkjHZRqMPXDwp2/lLvdVu4k0flklTgG
	 bA3zD1Tp50YBhyLmNH0RI8fOyb6yOT2Rxa3Ezo73VnIxASe6q6mH19bIADePX+x1Uug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u6zLtY7m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3EEE606A326;
	Sat,  7 Nov 2026 14:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u6zLtY7m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 052181F008A1;
	Sat,  7 Nov 2026 14:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061363;
	bh=l0RR+WGdR2C39mrb/yqPIOznQ5kLcs717Z4ljkUrmu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u6zLtY7mavSHkPayU581s45USC4mGKr9zJFRuo+d19HaKpXn098YmiafnOH064ufm
	 4iVaSrsZftYEAPYokLYm+TSezEecXgVJZXmrL/uXZJDpkaODxoL6bR+T2Q9dF+q466
	 uS403asjBVUQ6AClnMHia3F/PzSpyS3hBQn2Dpz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.com>,
	Frank Sorenson <sorenson@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0487/1536] cifs: add cifs_resize_file_locked() to guard fscache_resize_cookie() under i_rwsem
Date: Sat,  7 Nov 2026 08:41:43 -0500
Message-ID: <20261107135011.156600899@linuxfoundation.org>
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

From: Frank Sorenson <sorenson@redhat.com>

[ Upstream commit 32a7af68df7361fe7cf153cf36124d04b94aec00 ]

cifs_setsize() calls fscache_resize_cookie() without holding i_rwsem.
When the fscache cookie is active (FSCACHE_COOKIE_IS_CACHING is set),
fscache_resize_cookie() performs a real resize that requires i_rwsem
held exclusively.  If another file descriptor has the same inode open,
fscache_use_cookie() was already called from that cifs_open(), making
the cookie active.  In that case, calling cifs_setsize() from
cifs_do_truncate() (invoked from cifs_open() without i_rwsem) races
against concurrent fscache I/O.

Strip fscache_resize_cookie() from cifs_setsize(), making it a pure
size/page-cache helper.  Add cifs_resize_file_locked() for callers
that already hold i_rwsem: it calls netfs_resize_file() and
cifs_setsize(), then temporarily activates the cookie with
fscache_use_cookie() to perform the resize under the lock, then
deactivates it with cifs_fscache_unuse_inode_cookie().  Using
fscache_use_cookie() before the resize ensures correctness whether or
not another fd already holds the cookie active.

Switch cifs_file_set_size(), smb2_duplicate_extents(), and both size-
extension branches of smb3_simple_falloc() to the new wrapper; those
paths already hold i_rwsem via VFS setattr, lock_two_nondirectories(),
or cifs_fallocate() respectively.  cifs_do_truncate() continues to
call cifs_setsize() followed by cifs_invalidate_cache(), since it runs
without i_rwsem.

Fixes: fa724e235cfd ("cifs: add fscache_resize_cookie() to cifs_setsize()")
Cc: stable@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>
Cc: Paulo Alcantara <pc@manguebit.com>
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
[ sashal: Dropped the "small range beyond EOF" hunk and the second falloc extension branch, which this tree lacks, and kept local i_blocks and cifs_truncate_page code and the older cifs_set_file_size naming. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsfs.h  |  1 +
 fs/smb/client/inode.c   | 21 ++++++++++++++++++---
 fs/smb/client/smb2ops.c |  6 ++----
 3 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/cifsfs.h b/fs/smb/client/cifsfs.h
index 71b720dbb2ce3..7eee688ca30b6 100644
--- a/fs/smb/client/cifsfs.h
+++ b/fs/smb/client/cifsfs.h
@@ -135,6 +135,7 @@ extern ssize_t cifs_file_copychunk_range(unsigned int xid,
 
 extern long cifs_ioctl(struct file *filep, unsigned int cmd, unsigned long arg);
 extern void cifs_setsize(struct inode *inode, loff_t offset);
+extern void cifs_resize_file_locked(struct inode *inode, loff_t offset);
 extern int cifs_truncate_page(struct address_space *mapping, loff_t from);
 
 struct smb3_fs_context;
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 05f525621e0f6..4954d42ae8248 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2977,7 +2977,23 @@ void cifs_setsize(struct inode *inode, loff_t offset)
 		pagecache_isize_extended(inode, old_size, offset);
 	truncate_pagecache(inode, offset);
 	netfs_wait_for_outstanding_io(inode);
-	fscache_resize_cookie(cifs_inode_cookie(inode), offset);
+}
+
+void cifs_resize_file_locked(struct inode *inode, loff_t offset)
+{
+	struct fscache_cookie *cookie = cifs_inode_cookie(inode);
+
+	lockdep_assert_held_write(&inode->i_rwsem);
+
+	netfs_resize_file(netfs_inode(inode), offset, true);
+	cifs_setsize(inode, offset);
+
+	if (!cookie)
+		return;
+
+	fscache_use_cookie(cookie, true);
+	fscache_resize_cookie(cookie, offset);
+	cifs_fscache_unuse_inode_cookie(inode, true);
 }
 
 static int
@@ -3043,8 +3059,7 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 
 set_size_out:
 	if (rc == 0) {
-		netfs_resize_file(&cifsInode->netfs, attrs->ia_size, true);
-		cifs_setsize(inode, attrs->ia_size);
+		cifs_resize_file_locked(inode, attrs->ia_size);
 		/*
 		 * i_blocks is not related to (i_size / i_blksize), but instead
 		 * 512 byte (2**9) size is required for calculating num blocks.
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 7cd2e88a86b72..1f6618cb64b94 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2304,8 +2304,7 @@ smb2_duplicate_extents(const unsigned int xid,
 		 * size will be queried on next revalidate, but it is important
 		 * to make sure that file's cached size is updated immediately
 		 */
-		netfs_resize_file(netfs_inode(inode), dest_off + len, true);
-		cifs_setsize(inode, dest_off + len);
+		cifs_resize_file_locked(inode, dest_off + len);
 	}
 	rc = SMB2_ioctl(xid, tcon, trgtfile->fid.persistent_fid,
 			trgtfile->fid.volatile_fid,
@@ -3832,8 +3831,7 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 		rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
 				  cfile->fid.volatile_fid, cfile->pid, new_eof);
 		if (rc == 0) {
-			netfs_resize_file(&cifsi->netfs, new_eof, true);
-			cifs_setsize(inode, new_eof);
+			cifs_resize_file_locked(inode, new_eof);
 			cifs_truncate_page(inode->i_mapping, inode->i_size);
 			truncate_setsize(inode, new_eof);
 		}
-- 
2.53.0



