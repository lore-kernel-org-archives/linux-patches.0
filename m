Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212578;
	b=G/LbIiRF66NHuImKJ+nTdjEq2kU1hQQcRO7TttvMnmsm1IqLPW9dEorzfpfBhhV6W9YL
	 HMRMj4aEhHLZuk1Xhkyvbk+ZQaYUX4/PgleCFETxka8a9utmhnN48cFM84BPMO04VcUUi
	 A/pfkTkZpvaNoJ/t+dHdbs4Zypug1V2Q4+9MhpLyUbUZVlL8fk7od5M8tlXy1I+zuT5mx
	 ZL9vo+ihO3jKfQMlmvU5/64fITZXKeD3TeYnHY6fqEo2Knqw9ueEXJ8Yj54/KX3tPfVH2
	 gqJmNcxo/J8uczGxyhFlYnPsdKLUf/jtz+QzmycimBlXhzPZTEDyH1W5bprDz5Y85wQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212578;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GEXROQEHTPEoJYvuIygXeQ8A4dwiSMVOpW7RE1tN3Y8=;
	b=HnRayNnb9OZ9C1vqAh0OVRW6kGZCmy/KuppWSDAmOEqfuJF8kw+oGG5Rn73YOaK/KbIy
	 da99WbwuuDGM5DeGl0FptcTjWmwqr0xpiYi4vG9D//vP4/B0elpLIRwYIn8VXcPs9sV2P
	 vCirMfqep2eqeeb62nBnJWevrGjda8LaGv7Rtje5VvVjlEsU+bSVaIql1zqwRHlCADl1r
	 JtLHTr63jjZZviW132cApW96BjanHHUyQ7ijSfEKH4VnEQnbCzyZzuBFM/ScoGSj8UyRH
	 wwexWgEtLReLK7nIXOUZ5XHay7RqmzLPNvzKPED4OjzG/al7d4cY38MI5/nhYrLl1tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RmXL+BfY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC42606A31C;
	Wed, 28 Oct 2026 18:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RmXL+BfY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BE461F01825;
	Wed, 28 Oct 2026 18:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212578;
	bh=GEXROQEHTPEoJYvuIygXeQ8A4dwiSMVOpW7RE1tN3Y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RmXL+BfYDB3F2JbtR5VrthX/nutUgZRLk5jWcTxBgYEy+V6/tQfr8G8ohagruT+5r
	 gLCKcDD4RTMnRUaV0YE5FjDPqJ5qdx5eSpv8f6lw320XCyWLxef59oDA2KKCG5fA5/
	 NEeok6lY1JBGQtzk49tj++gWkS7Ez3CawxEC6Wms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0159/1887] smb: client: use finish_no_open() for non-regular inodes
Date: Wed, 28 Oct 2026 17:37:35 +0100
Message-ID: <20261028170502.853050822@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit e66cf1625ec4a3fe68346119f371def713fd0a4d ]

An O_CREAT open can find an existing symlink or another non-regular
inode. cifs_atomic_open() calls finish_open() on it and attaches a
cifsFileInfo. Symlink inodes have no CIFS release operation, so the
dentry reference held by cifsFileInfo is leaked. FMODE_OPENED also
prevents the VFS from following the symlink.

Track whether cifs_do_create() returned an open server handle. For
non-regular inodes, close the handle if present, remove the pending
open, and call finish_no_open() so the VFS can continue the lookup.
Do not set FMODE_CREATED unless a regular file was opened. For
O_NOFOLLOW with __O_REGULAR, return -ELOOP before the VFS's
-EFTYPE check.

Defer closing a legacy POSIX handle on a non-regular inode until
after inode lookup. This avoids closing it again if lookup fails.

Fixes: d2c127197dfc ("cifs: implement i_op->atomic_open()")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
[ replaced S_ISREG(inode->i_mode) with d_is_reg(direntry) because the older cifs_do_create() already attaches the inode. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/dir.c | 39 +++++++++++++++++++++++++++++----------
 1 file changed, 29 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/dir.c b/fs/smb/client/dir.c
index b5b64b061b715..d34230b8e1246 100644
--- a/fs/smb/client/dir.c
+++ b/fs/smb/client/dir.c
@@ -176,7 +176,8 @@ check_name(struct dentry *direntry, struct cifs_tcon *tcon)
 
 static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned int xid,
 			  struct tcon_link *tlink, unsigned int oflags, umode_t mode, __u32 *oplock,
-			  struct cifs_fid *fid, struct cifs_open_info_data *buf)
+			  struct cifs_fid *fid, struct cifs_open_info_data *buf,
+			  bool *opened)
 {
 	int rc = -ENOENT;
 	int create_options = CREATE_NOT_DIR;
@@ -191,6 +192,7 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 	struct cifs_open_parms oparms;
 	int rdwr_for_fscache = 0;
 
+	*opened = false;
 	*oplock = 0;
 	if (tcon->ses->server->oplocks)
 		*oplock = REQ_OPLOCK;
@@ -213,6 +215,7 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 				     oflags, oplock, &fid->netfid, xid);
 		switch (rc) {
 		case 0:
+			*opened = true;
 			if (newinode == NULL) {
 				/* query inode info */
 				goto cifs_create_get_file_info;
@@ -229,11 +232,9 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 				/*
 				 * The server may allow us to open things like
 				 * FIFOs, but the client isn't set up to deal
-				 * with that. If it's not a regular file, just
-				 * close it and proceed as if it were a normal
-				 * lookup.
+				 * with that. Keep the handle until the caller
+				 * can finish the lookup.
 				 */
-				CIFSSMBClose(xid, tcon, fid->netfid);
 				goto cifs_create_get_file_info;
 			}
 			/* success, no need to query */
@@ -333,6 +334,7 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 		}
 		goto out;
 	}
+	*opened = true;
 	if (rdwr_for_fscache == 2)
 		cifs_invalidate_cache(inode, FSCACHE_INVAL_DIO_WRITE);
 
@@ -423,7 +425,7 @@ static int cifs_do_create(struct inode *inode, struct dentry *direntry, unsigned
 	return rc;
 
 out_err:
-	if (server->ops->close)
+	if (*opened && server->ops->close)
 		server->ops->close(xid, tcon, fid);
 	if (newinode)
 		iput(newinode);
@@ -442,6 +444,8 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
 	struct cifs_fid fid = {};
 	struct cifs_pending_open open;
 	__u32 oplock;
+	bool is_regular;
+	bool opened;
 	struct cifsFileInfo *file_info;
 	struct cifs_open_info_data buf = {};
 
@@ -501,15 +505,28 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
 	cifs_add_pending_open(&fid, tlink, &open);
 
 	rc = cifs_do_create(inode, direntry, xid, tlink, oflags, mode,
-			    &oplock, &fid, &buf);
+			    &oplock, &fid, &buf, &opened);
 	if (rc) {
 		cifs_del_pending_open(&open);
 		goto out;
 	}
 
-	if ((oflags & (O_CREAT | O_EXCL)) == (O_CREAT | O_EXCL))
+	is_regular = d_is_reg(direntry);
+	if (!is_regular || !opened) {
+		if (opened && server->ops->close)
+			server->ops->close(xid, tcon, &fid);
+		cifs_del_pending_open(&open);
+	}
+
+	if (is_regular && opened &&
+	    (oflags & (O_CREAT | O_EXCL)) == (O_CREAT | O_EXCL))
 		file->f_mode |= FMODE_CREATED;
 
+	if (!is_regular || !opened) {
+		rc = finish_no_open(file, NULL);
+		goto out;
+	}
+
 	rc = finish_open(file, direntry, generic_file_open);
 	if (rc) {
 		if (server->ops->close)
@@ -564,6 +581,7 @@ int cifs_create(struct user_namespace *mnt_userns, struct inode *inode,
 	struct TCP_Server_Info *server;
 	struct cifs_fid fid;
 	__u32 oplock;
+	bool opened;
 	struct cifs_open_info_data buf = {};
 
 	cifs_dbg(FYI, "cifs_create parent inode = 0x%p name is: %pd and dentry = 0x%p\n",
@@ -585,8 +603,9 @@ int cifs_create(struct user_namespace *mnt_userns, struct inode *inode,
 	if (server->ops->new_lease_key)
 		server->ops->new_lease_key(&fid);
 
-	rc = cifs_do_create(inode, direntry, xid, tlink, oflags, mode, &oplock, &fid, &buf);
-	if (!rc && server->ops->close)
+	rc = cifs_do_create(inode, direntry, xid, tlink, oflags, mode,
+			    &oplock, &fid, &buf, &opened);
+	if (!rc && opened && server->ops->close)
 		server->ops->close(xid, tcon, &fid);
 
 	cifs_free_open_info(&buf);
-- 
2.53.0



