Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061464;
	b=yjdFcgcLeUzD9b4lcb8saUfdoKs647dufzVJosQZHWeXJNbOwFnSmigj3fC8JrQFfEer
	 e17F0XN0RJOCCrZcNtl9AnaSnV3aEAUZ+RDFRCYZwvp2KTIJ8W9adN51G0o4q/swK68LL
	 5qrPx/NGGkhMwpX4NbSTY5Y4SDr4hxkysclIL+owZ8dviuiwrJm1XVtVVagO3gPUI/O6i
	 SXweGd/5tUrwCAix9tsGwnfQtTpl3FyPUY7oSgoAL67ByaagmYiXhJsR49RZCzKvZIyMo
	 WBKdytESAbnT+9eZ7LVq2B9OK/NRVgNNI08BrP4evn7VucKoe8hNKjq3qbj+2DJ2XKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061464;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vtm1e0RiF47pBZFRLrJLOWZKphbdZVyvEf5ryuQGgC8=;
	b=d/fecEMAw81KFeqaf3Ynvsy2X1qkAqRyjcfzh5pUi6tcR9TvezzVIjx+mNPPJVBA5rS4
	 IQjC9cYjFadx3KHttaG2Rz4Yem/vxxUsqYclWsNGxd70qhiVLs7ElM5r0ihhxNCJHtAcz
	 tWBR1P8Q5fzCS3Gkr3TH29HyaRv9fOMiy7PsB8Q3yT+S/tlJH+uG2gyRasYQC0XZdCOVL
	 4z2tc5DaT2jBGjRG28Bb5hxm00e3uL7u+9SzcGv7VIX0bROnJymaGY1IhE5WDuMIfaquu
	 BpomI3WICEknR8tW9LCHQ/4WS0npyKVxXnCaj9FCDLtSt2X8TS1INCQ8+f8BxFrSOtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wee0a+3l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE14606A338;
	Sat,  7 Nov 2026 14:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wee0a+3l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B7B1F0089F;
	Sat,  7 Nov 2026 14:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061463;
	bh=vtm1e0RiF47pBZFRLrJLOWZKphbdZVyvEf5ryuQGgC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wee0a+3l9kywdvN4dvJFhNrL7Qm5HR+wJ7yyYDYfRYOppv7u9ulpvV7yMjHiFL84/
	 KttoVxh3TO/SgxI6SV3Svgu2vzR6nFHeeFvXdOdFzGFu2KB0BNwUZteI82y8paYdU2
	 s1RhE1jkBdY/RN5MFxhw6JF6la7wdKeVqSMWt+L8=
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
Subject: [PATCH 6.12 0539/1536] smb: client: clear post-EOF pagecache when extending a file via truncate
Date: Sat,  7 Nov 2026 08:42:35 -0500
Message-ID: <20261107135012.735368348@linuxfoundation.org>
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
[ sashal: Adapted to older CIFS code: dropped the missing cifs_do_truncate() hunk, kept extern prototypes and older cifs_setsize() body, and used existing old_eof in smb3_simple_falloc(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifsfs.h  |  5 +++--
 fs/smb/client/inode.c   | 21 ++++++++++++++-------
 fs/smb/client/smb2ops.c |  8 +++++---
 3 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/fs/smb/client/cifsfs.h b/fs/smb/client/cifsfs.h
index 7eee688ca30b6..abc510a6cb262 100644
--- a/fs/smb/client/cifsfs.h
+++ b/fs/smb/client/cifsfs.h
@@ -134,8 +134,9 @@ extern ssize_t cifs_file_copychunk_range(unsigned int xid,
 					size_t len, unsigned int flags);
 
 extern long cifs_ioctl(struct file *filep, unsigned int cmd, unsigned long arg);
-extern void cifs_setsize(struct inode *inode, loff_t offset);
-extern void cifs_resize_file_locked(struct inode *inode, loff_t offset);
+extern void cifs_setsize(struct inode *inode, loff_t old_size, loff_t offset);
+extern void cifs_resize_file_locked(struct inode *inode, loff_t old_size,
+				    loff_t offset);
 extern int cifs_truncate_page(struct address_space *mapping, loff_t from);
 
 struct smb3_fs_context;
diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 8f7bb68565f2f..a7142ce90ecd8 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2961,32 +2961,38 @@ int cifs_truncate_page(struct address_space *mapping, loff_t from)
 	return rc;
 }
 
-void cifs_setsize(struct inode *inode, loff_t offset)
+void cifs_setsize(struct inode *inode, loff_t old_size, loff_t offset)
 {
 	struct cifsInodeInfo *cifs_i = CIFS_I(inode);
-	loff_t old_size;
 
 	spin_lock(&inode->i_lock);
-	old_size = i_size_read(inode);
 	i_size_write(inode, offset);
 	spin_unlock(&inode->i_lock);
 
 	/* Cached inode must be refreshed on truncate */
 	cifs_i->time = 0;
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
@@ -3004,6 +3010,7 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 	struct cifsFileInfo *open_file;
 	struct cifsInodeInfo *cifsInode = CIFS_I(inode);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	loff_t old_size = i_size_read(inode);
 	struct tcon_link *tlink = NULL;
 	struct cifs_tcon *tcon = NULL;
 	struct TCP_Server_Info *server;
@@ -3059,7 +3066,7 @@ cifs_set_file_size(struct inode *inode, struct iattr *attrs,
 
 set_size_out:
 	if (rc == 0) {
-		cifs_resize_file_locked(inode, attrs->ia_size);
+		cifs_resize_file_locked(inode, old_size, attrs->ia_size);
 		/*
 		 * i_blocks is not related to (i_size / i_blksize), but instead
 		 * 512 byte (2**9) size is required for calculating num blocks.
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 1f6618cb64b94..f2a78aee07e3b 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2275,6 +2275,7 @@ smb2_duplicate_extents(const unsigned int xid,
 	struct inode *inode;
 	struct duplicate_extents_to_file dup_ext_buf;
 	struct cifs_tcon *tcon = tlink_tcon(trgtfile->tlink);
+	loff_t old_size;
 
 	/* server fileays advertise duplicate extent support with this flag */
 	if ((le32_to_cpu(tcon->fsAttrInfo.Attributes) &
@@ -2292,7 +2293,8 @@ smb2_duplicate_extents(const unsigned int xid,
 			       trgtfile->fid.volatile_fid, tcon->tid,
 			       tcon->ses->Suid, src_off, dest_off, len);
 	inode = d_inode(trgtfile->dentry);
-	if (i_size_read(inode) < dest_off + len) {
+	old_size = i_size_read(inode);
+	if (old_size < dest_off + len) {
 		rc = smb2_set_file_size(xid, tcon, trgtfile, dest_off + len, false);
 		if (rc)
 			goto duplicate_extents_out;
@@ -2304,7 +2306,7 @@ smb2_duplicate_extents(const unsigned int xid,
 		 * size will be queried on next revalidate, but it is important
 		 * to make sure that file's cached size is updated immediately
 		 */
-		cifs_resize_file_locked(inode, dest_off + len);
+		cifs_resize_file_locked(inode, old_size, dest_off + len);
 	}
 	rc = SMB2_ioctl(xid, tcon, trgtfile->fid.persistent_fid,
 			trgtfile->fid.volatile_fid,
@@ -3831,7 +3833,7 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
 		rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
 				  cfile->fid.volatile_fid, cfile->pid, new_eof);
 		if (rc == 0) {
-			cifs_resize_file_locked(inode, new_eof);
+			cifs_resize_file_locked(inode, old_eof, new_eof);
 			cifs_truncate_page(inode->i_mapping, inode->i_size);
 			truncate_setsize(inode, new_eof);
 		}
-- 
2.53.0



