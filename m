Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D857B57F727;
	Wed,  9 Sep 2026 14:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964570; cv=none; b=QhqEJd8FgUT8DpA5L5Yj6ZH7YQxqJJyPy+ddQoD4M+jGoF1UeDTWWCLZBZm9am2XwkQO0O+ICD1gKv4fzOMSMeg2yIwiCvCBQtOE8Y77HVgRck7xFzCHqmD29+Z0yHJ6Fnj8xBqfVLYQIBlVOnxdNsKQ3uaO/JqLuMlz2mx4Ft0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964570; c=relaxed/simple;
	bh=Cyp4b1sH9xOWlgusXjR4hkPRmqnevYTzUGltKJeMaoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZXcDeNXKg/9ywhAgebPPvaRSOPa0kko/nXeW7kZNCfBR8LJPZx9pSLm7Dpz5pleVv/4qTMttJ1VHmWx9TYdpPl1bFkYGHYYvmX/eEvNGX9efXNbd92oruxhbxHyhb9ct3VIZo/h94JBimzaJABwA4MiqwTrPwAh4/DJpwWudNqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kUkVD6ai; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kUkVD6ai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C8F1F00A3A;
	Wed,  9 Sep 2026 14:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964568;
	bh=KRAuPpmAppZqc+nsIW8x6rIel0daj651k63WJZT/0uU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kUkVD6ai8dhF8Pxwgl84iUP2jzfZLE+VOjyTC1zXO0xzpHOuKqzY1fUftEwNhnz2e
	 FIKlWTUmAa0K0IFBCVKjcmAVxvww0/0wkfCtoTd/riUySisHl4VcBK1fcrq3pzB5pU
	 IQ7RHLO9PxHE6d4tPkRQmhwz546a+KFHGYkwVNrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 467/583] smb: move some definitions from common/smb2pdu.h into common/fscc.h
Date: Wed,  9 Sep 2026 15:42:32 +0200
Message-ID: <20260909134254.069091909@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ZhangGuoDong <zhangguodong@kylinos.cn>

[ Upstream commit a5e581093b1d9321cbb627dd8c209d0d4e0a988a ]

These definitions are specified in MS-FSCC, so move them into fscc.h.

Only add some documentation references, no other changes.

Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Reviewed-by: Steve French <stfrench@microsoft.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>

The original header relocation is not applicable to this stable tree: fscc.h is absent and the relevant definitions are already kept in smb2pdu.h.

For this stable-only dependency adaptation, prepare the existing fallocate paths for EOF-extending ranges and allocation metadata refresh, and align the cifs declarations with the target patch context. This lets the fscache resize locking fix apply without adding its new helper in the dependency.

[ sashal: Reduced backport -- upstream a5e581093b1d9 touches 2 file(s), this
  backport carries 2. Not backported here:
  fs/smb/common/fscc.h
  fs/smb/common/smb2pdu.h
  This note is generated from the file lists only; see the resolution record
  for the reasoning. ]

Stable-dep-of: 32a7af68df73 ("cifs: add cifs_resize_file_locked() to guard fscache_resize_cookie() under i_rwsem")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsfs.h  |    5 +-
 fs/smb/client/smb2ops.c |   89 +++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 80 insertions(+), 14 deletions(-)

--- a/fs/smb/client/cifsfs.h
+++ b/fs/smb/client/cifsfs.h
@@ -133,9 +133,10 @@ extern ssize_t cifs_file_copychunk_range
 					struct file *dst_file, loff_t destoff,
 					size_t len, unsigned int flags);
 
-extern long cifs_ioctl(struct file *filep, unsigned int cmd, unsigned long arg);
-extern void cifs_setsize(struct inode *inode, loff_t offset);
+long cifs_ioctl(struct file *filep, unsigned int command, unsigned long arg);
+void cifs_setsize(struct inode *inode, loff_t offset);
 
+struct fs_context;
 struct smb3_fs_context;
 extern struct dentry *cifs_smb3_do_mount(struct file_system_type *fs_type,
 					 int flags, struct smb3_fs_context *ctx);
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3544,12 +3544,25 @@ static int smb3_simple_fallocate_range(u
 				       loff_t off, loff_t len)
 {
 	struct file_allocated_range_buffer in_data, *out_data = NULL, *tmp_data;
+	struct inode *inode = d_inode(cfile->dentry);
 	u32 out_data_len;
 	char *buf = NULL;
 	u64 range_start, range_len, range_end;
 	loff_t l;
 	int rc;
 
+	buf = kvzalloc(1024 * 1024, GFP_KERNEL);
+	if (buf == NULL) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	if (off >= i_size_read(inode)) {
+		rc = smb3_simple_fallocate_write_range(xid, tcon, cfile,
+						       off, len, buf);
+		goto out;
+	}
+
 	in_data.file_offset = cpu_to_le64(off);
 	in_data.length = cpu_to_le64(len);
 	rc = SMB2_ioctl(xid, tcon, cfile->fid.persistent_fid,
@@ -3561,12 +3574,6 @@ static int smb3_simple_fallocate_range(u
 	if (rc)
 		goto out;
 
-	buf = kvzalloc(1024 * 1024, GFP_KERNEL);
-	if (buf == NULL) {
-		rc = -ENOMEM;
-		goto out;
-	}
-
 	tmp_data = out_data;
 	while (len) {
 		/*
@@ -3641,18 +3648,22 @@ static long smb3_simple_falloc(struct fi
 	struct cifsFileInfo *cfile = file->private_data;
 	long rc = -EOPNOTSUPP;
 	unsigned int xid;
-	loff_t new_eof;
+	loff_t old_eof, new_eof;
+	struct smb2_file_all_info file_inf;
+	u64 asize;
+	int qrc;
 
 	xid = get_xid();
 
 	inode = d_inode(cfile->dentry);
 	cifsi = CIFS_I(inode);
+	old_eof = i_size_read(inode);
 
 	trace_smb3_falloc_enter(xid, cfile->fid.persistent_fid, tcon->tid,
 				tcon->ses->Suid, off, len);
 	/* if file not oplocked can't be sure whether asking to extend size */
 	if (!CIFS_CACHE_READ(cifsi))
-		if (keep_size == false) {
+		if (!keep_size) {
 			trace_smb3_falloc_err(xid, cfile->fid.persistent_fid,
 				tcon->tid, tcon->ses->Suid, off, len, rc);
 			free_xid(xid);
@@ -3662,21 +3673,75 @@ static long smb3_simple_falloc(struct fi
 	/*
 	 * Extending the file
 	 */
-	if ((keep_size == false) && i_size_read(inode) < off + len) {
+	if (!keep_size && old_eof < off + len) {
 		rc = inode_newsize_ok(inode, off + len);
 		if (rc)
 			goto out;
 
+		/*
+		 * A small range at or beyond EOF can be allocated by writing
+		 * zeroes.  For off > old_eof, this preserves the intervening
+		 * hole instead of allocating from offset 0.
+		 */
+		if (off > old_eof ||
+		    (off == old_eof && old_eof != 0 &&
+		     (cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE))) {
+			if (len > 1024 * 1024) {
+				rc = -EOPNOTSUPP;
+				goto out;
+			}
+
+			rc = smb3_simple_fallocate_range(xid, tcon, cfile,
+							 off, len);
+			if (rc) {
+				spin_lock(&inode->i_lock);
+				cifsi->time = 0;
+				spin_unlock(&inode->i_lock);
+				goto out;
+			}
+
+			new_eof = off + len;
+			netfs_resize_file(&cifsi->netfs, new_eof, true);
+			cifs_setsize(inode, new_eof);
+
+			qrc = SMB2_query_info(xid, tcon,
+					      cfile->fid.persistent_fid,
+					      cfile->fid.volatile_fid, &file_inf);
+			spin_lock(&inode->i_lock);
+			if (qrc == 0) {
+				asize = le64_to_cpu(file_inf.AllocationSize);
+				inode->i_blocks = CIFS_INO_BLOCKS(asize);
+			} else {
+				cifsi->time = 0;
+			}
+			spin_unlock(&inode->i_lock);
+			goto out;
+		}
+
 		if (cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE)
 			smb2_set_sparse(xid, tcon, cfile, inode, false);
 
 		new_eof = off + len;
 		rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
 				  cfile->fid.volatile_fid, cfile->pid, new_eof);
-		if (rc == 0) {
-			netfs_resize_file(&cifsi->netfs, new_eof, true);
-			cifs_setsize(inode, new_eof);
+		if (rc)
+			goto out;
+
+		netfs_resize_file(&cifsi->netfs, new_eof, true);
+		cifs_setsize(inode, new_eof);
+
+		qrc = SMB2_query_info(xid, tcon,
+				      cfile->fid.persistent_fid,
+				      cfile->fid.volatile_fid, &file_inf);
+		spin_lock(&inode->i_lock);
+		if (qrc == 0) {
+			asize = le64_to_cpu(file_inf.AllocationSize);
+			if (asize >= new_eof)
+				inode->i_blocks = CIFS_INO_BLOCKS(asize);
+		} else {
+			cifsi->time = 0;
 		}
+		spin_unlock(&inode->i_lock);
 		goto out;
 	}
 


