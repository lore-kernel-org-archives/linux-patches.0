Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831270;
	b=viJZTQuwRqwoZnN0Flm4JCrZQIUlzCrZ7+Wx6N0yyoNLpa7tar8kjRT2Lj3cVekI1Ibi
	 FIWEtI9xBcCKk9bvoASnhjunqehg+dy1CuqGybJ9cssAGUM7IJVWStG9dIXWDdCTke73u
	 /NnT66JNTEEupk2H9QdgV6iCtD5CxqysSuhLA32izTGjDjnmIXInxOAmSUDvr+0g5ltXm
	 HOcAE0P0zBrudJwV3uPngxzTgLToqlZg8mBh2OJ8u5gJSQgyGLtSi83X/7P6qPtINuAYd
	 yPPLqklPwEucEGzOAn4NB0ciAYa0tEjfp2U7PBR0e4HtGbIWqeOIM/MByPC/+6yPNaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831270;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FbODHRrcDnarJhMKyis4FrrqcYYUlrIg1oZO8lxHHCs=;
	b=4Mc8IZBmhQRuXP1alXrVgF+PBFwpK29iHQU/q/LEGp/r/xELNphvXyDv333xfTAVKP/k
	 RO/TlfHZGW/KM8q5JsZW/Oc3Xh5hcIgNZQFeHz74ExGoMb9K3t5ruDE73NJ+7qzgXv6/T
	 YriM2jkn1qD/I3h4ijsgdi2YbdeC2n+4ucUYVi+5bjTCF6dmNT9mCkjDOF4NPuplRZaQ0
	 phk/t+jShqpcmF9Q1mr1o2BrKz+kxrX+51fsY1jItqjTKi8oBsKgOyJCQfAADvbbkWwMb
	 Zsb+ckXS+0Lo4U6TFUSOq5iDqVAenjo69bdv9Vre4tRLZZ/+7XshegaSn8EN3NOn1kQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tf+v0Cxp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0D8606A33E;
	Wed,  4 Nov 2026 22:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tf+v0Cxp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B5801F000C1;
	Wed,  4 Nov 2026 22:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831270;
	bh=FbODHRrcDnarJhMKyis4FrrqcYYUlrIg1oZO8lxHHCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tf+v0Cxp2TRp3iP5F0pKPX5iArq4dvQQYzTEY6n7v72aiXnroerJMT2sAUGkqWa3z
	 DdZy77Gbwz4Vv1GBcFUtrHmiXygSQiFVoRSzUBmAuZtf75oTPsPh6TSoqJjOQwY8a+
	 QHmo3Mm/ESecP1SMj+RPsTUb1XArT48PzJCSVdKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Christian Brauner <brauner@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0604/1005] smb: client: clear post-EOF pagecache when extending a file via truncate
Date: Wed,  4 Nov 2026 16:05:37 -0500
Message-ID: <20261104211100.770758529@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit 35024595f641e790e24609f3f046e1667e3b280a ]

cifs_setsize() relied on pagecache_isize_extended() to zero the tail of
the folio straddling the old EOF, but that helper is a no-op on CIFS
(i_blkbits is 14), so data dirtied past EOF through an mmap survived
and became visible once the file was extended.

Use netfs_clear_stale_post_isize() instead, called after i_size is
updated since cifs_setsize() callers hold i_rwsem exclusively for the
whole resize.  truncate_pagecache() is then called as in
truncate_setsize(): a no-op on extend, and it drops the pagecache
beyond the new EOF on shrink.

Also thread old_size as an explicit parameter through cifs_setsize()
and cifs_resize_file_locked(), captured by each caller before its own
resize RPC.  This closes a race where a concurrent stat() could adopt
the RPC's already-updated server size via is_size_safe_to_change()
before cifs_setsize() reads old_size itself.

Closes: https://sashiko.dev/#/patchset/20260921230755.1133425-1-pc%40manguebit.org
Fixes: c510edb9734a ("cifs: call pagecache_isize_extended() in cifs_setsize() when extending")
Reviewed-by: David Howells <dhowells@redhat.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
[ sashal: Dropped the old_size local in cifs_setsize() (now a parameter) and kept this tree's plain i_blocks assignment, since it lacks the u64 blocks local and shrink-clamp context the patch expects. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsfs.h  |  5 +++--
 fs/smb/client/file.c    |  3 ++-
 fs/smb/client/inode.c   | 22 ++++++++++++++--------
 fs/smb/client/smb2ops.c | 10 ++++++----
 4 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/fs/smb/client/cifsfs.h b/fs/smb/client/cifsfs.h
index 3d632d22da6fc..3298311223b04 100644
--- a/fs/smb/client/cifsfs.h
+++ b/fs/smb/client/cifsfs.h
@@ -134,8 +134,9 @@ extern ssize_t cifs_file_copychunk_range(unsigned int xid,
 					size_t len, unsigned int flags);
 
 long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg);
-void cifs_setsize(struct inode *inode, loff_t offset);
-void cifs_resize_file_locked(struct inode *inode, loff_t offset);
+void cifs_setsize(struct inode *inode, loff_t old_size, loff_t offset);
+void cifs_resize_file_locked(struct inode *inode, loff_t old_size,
+			     loff_t offset);
 
 struct fs_context;
 struct smb3_fs_context;
diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index b24a7e191928b..35f6c1cebd1a9 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -1010,6 +1010,7 @@ static int cifs_do_truncate(const unsigned int xid, struct dentry *dentry)
 	if (!rc) {
 		if (cfile) {
 			struct netfs_inode *ictx = netfs_inode(inode);
+			loff_t old_size = i_size_read(inode);
 
 			tcon = tlink_tcon(cfile->tlink);
 			server = tcon->ses->server;
@@ -1018,7 +1019,7 @@ static int cifs_do_truncate(const unsigned int xid, struct dentry *dentry)
 							cfile, 0, false);
 			if (!rc) {
 				netfs_resize_file(&cinode->netfs, 0, true);
-				cifs_setsize(inode, 0);
+				cifs_setsize(inode, old_size, 0);
 				cifs_invalidate_cache(inode, 0);
 			}
 			mutex_unlock(&ictx->wb_lock);
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 88d2732b73a05..382e83735da28 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -3033,12 +3033,9 @@ int cifs_fiemap(struct inode *inode, struct fiemap_extent_info *fei, u64 start,
 	return -EOPNOTSUPP;
 }
 
-void cifs_setsize(struct inode *inode, loff_t offset)
+void cifs_setsize(struct inode *inode, loff_t old_size, loff_t offset)
 {
-	loff_t old_size;
-
 	spin_lock(&inode->i_lock);
-	old_size = i_size_read(inode);
 	i_size_write(inode, offset);
 	/*
 	 * Until we can query the server for actual allocation size,
@@ -3047,21 +3044,29 @@ void cifs_setsize(struct inode *inode, loff_t offset)
 	inode->i_blocks = CIFS_INO_BLOCKS(offset);
 	spin_unlock(&inode->i_lock);
 	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
+
+	/*
+	 * Zero the tail of the folio straddling the old EOF so data dirtied
+	 * past EOF through an mmap isn't exposed.  truncate_pagecache() then
+	 * drops any pagecache beyond the new EOF, as in truncate_setsize().
+	 */
 	if (offset > old_size)
-		pagecache_isize_extended(inode, old_size, offset);
+		netfs_clear_stale_post_isize(inode, old_size, offset);
+
 	truncate_pagecache(inode, offset);
 	netfs_wait_for_outstanding_io(inode);
 	fscache_resize_cookie(cifs_inode_cookie(inode), offset);
 }
 
-void cifs_resize_file_locked(struct inode *inode, loff_t offset)
+void cifs_resize_file_locked(struct inode *inode, loff_t old_size,
+			     loff_t offset)
 {
 	struct fscache_cookie *cookie = cifs_inode_cookie(inode);
 
 	lockdep_assert_held_write(&inode->i_rwsem);
 
 	netfs_resize_file(netfs_inode(inode), offset, true);
-	cifs_setsize(inode, offset);
+	cifs_setsize(inode, old_size, offset);
 
 	if (!cookie)
 		return;
@@ -3078,6 +3083,7 @@ int cifs_file_set_size(const unsigned int xid, struct dentry *dentry,
 	struct inode *inode = d_inode(dentry);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct cifsInodeInfo *cifsInode = CIFS_I(inode);
+	loff_t old_size = i_size_read(inode);
 	struct tcon_link *tlink = NULL;
 	struct cifs_tcon *tcon = NULL;
 	struct TCP_Server_Info *server;
@@ -3136,7 +3142,7 @@ int cifs_file_set_size(const unsigned int xid, struct dentry *dentry,
 
 set_size_out:
 	if (rc == 0)
-		cifs_resize_file_locked(inode, size);
+		cifs_resize_file_locked(inode, old_size, size);
 
 	return rc;
 }
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 600ecf4382fa3..6f6d45afdfb67 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2278,6 +2278,7 @@ smb2_duplicate_extents(const unsigned int xid,
 	struct duplicate_extents_to_file dup_ext_buf;
 	struct timespec64 ts;
 	struct cifs_tcon *tcon = tlink_tcon(trgtfile->tlink);
+	loff_t old_size;
 	u64 asize;
 
 	/* server fileays advertise duplicate extent support with this flag */
@@ -2296,11 +2297,12 @@ smb2_duplicate_extents(const unsigned int xid,
 			       trgtfile->fid.volatile_fid, tcon->tid,
 			       tcon->ses->Suid, src_off, dest_off, len);
 	inode = d_inode(trgtfile->dentry);
-	if (i_size_read(inode) < dest_off + len) {
+	old_size = i_size_read(inode);
+	if (old_size < dest_off + len) {
 		rc = smb2_set_file_size(xid, tcon, trgtfile, dest_off + len, false);
 		if (rc)
 			goto duplicate_extents_out;
-		cifs_resize_file_locked(inode, dest_off + len);
+		cifs_resize_file_locked(inode, old_size, dest_off + len);
 	}
 	rc = SMB2_ioctl(xid, tcon, trgtfile->fid.persistent_fid,
 			trgtfile->fid.volatile_fid,
@@ -3902,7 +3904,7 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 			}
 
 			new_eof = off + len;
-			cifs_resize_file_locked(inode, new_eof);
+			cifs_resize_file_locked(inode, old_eof, new_eof);
 
 			qrc = SMB2_query_info(xid, tcon,
 					      cfile->fid.persistent_fid,
@@ -3927,7 +3929,7 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 		if (rc)
 			goto out;
 
-		cifs_resize_file_locked(inode, new_eof);
+		cifs_resize_file_locked(inode, old_eof, new_eof);
 
 		qrc = SMB2_query_info(xid, tcon,
 				      cfile->fid.persistent_fid,
-- 
2.53.0



