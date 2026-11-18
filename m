Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058858;
	b=wAymP389+5883aV4C7kg1+OyuXeu/w6fzK6JRKnHxYmGZRgWt3vua/B/IewPbQwKgVt6
	 lIT6sitg7/81/JKoVQDuK84BcpweWSjXo5h0kntpc5c0eRSBJy0HoHi2qGhEvZwIAnP84
	 OJxlkUlVBboYQp2GpFu9dVvgZv3CZA87ol/U9hzZ/7rUiDgSBlyX8Uka0uiX/JrPdFWMt
	 iYWF5fqEXDCJq7y3AmhCdsRM/gnMCO9YKZHABT5C/JzU7TTjOcpKtan5BQjluoNs9CU4I
	 HVEoe+LgS34w7DA9kck6oWVftVacCqEEEdM+gl51oKyBLViqRbcnYp0JOAK/8MQmupw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058858;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7Lj6GuCdarBU0jna2HEwvyEY3vchUwPvV0NqeSR4bF4=;
	b=zbf6Ja4wTXdsoqGqysPV1vkU5PKx9hJGFZzrtWkvoHGRb58xFdpesQW/DCUxAcdAk+pH
	 L8OC67FY0A442uU2DcMtE7NAa9lhie8/Ed/s1X7M53Rn4FD1BG09sbxmCBDaFJBB/R2rL
	 IKljnmvNLvHBN4Ze23L/i/7LmOTM5xzr1DiDEBtWpcoQ+d+vC19oi2RI800G8588BQaDt
	 8iG7EsXKdew+Z/BDaFtyIWgIMM/fCEHwSpqxLqU8NtnNG8gYdUNhKp1W6xSPkXzhb7Ky2
	 aYL1vSbwRAik6HDuvOb6Abpfq7qMK8LxyGJwdMurT5iGFtq6PKWVWMxS5xD1qHFAbPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X0+sqGTC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0D8606A320;
	Thu, 19 Nov 2026 03:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X0+sqGTC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0C031F000C4;
	Thu, 19 Nov 2026 03:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058858;
	bh=7Lj6GuCdarBU0jna2HEwvyEY3vchUwPvV0NqeSR4bF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X0+sqGTC3idlzv8FTkM5KUE7k6CzS95kPvdvaUscZOBN1pW5EB7pHLjacAhkEGZu4
	 O6fVai7zKwv6mgDPc6mG0MCBikb2YMPEXNWK1SSUsWsbX7zrioCNZy1365SSThfst9
	 RZoKIwIXlgYLNqDfubVosJjs8/1rLoN3mVmlRf9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0619/1848] ovl: hold a reference on the parent in readdir
Date: Wed, 18 Nov 2026 15:44:17 +0100
Message-ID: <20261118145941.180371997@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

[ Upstream commit 16d319e12328acafeafd3eecdf09c46d7fb43452 ]

Listing a directory on an overlay uses a freed dentry and crashes the
kernel when a lookup moves the directory at the same time.

Code that can sleep may only use d_parent without a reference while
something stops a move of the dentry. ovl_iterate_real(),
ovl_need_adjust_d_ino() and ovl_cache_update() use the d_parent of the
listed directory and hold only the lock of that directory. When a
lookup finds the directory under another parent after a change to a
layer, d_splice_alias() moves it without that lock and drops its
reference on the old parent.

With a delay in ovl_iterate_real(), getdents64 on an overlay directory
raced a rename in the lower layer and a lookup that moved its dentry,
and after an rmdir of the old parent KASAN reported a use-after-free in
security_inode_getattr().

Fix this by using dget_parent() in the three functions.

Fixes: b5efccbe0a12 ("ovl: constant d_ino across copy up")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[amir: fix comments in ovl_need_adjust_d_ino()]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
[ sashal: adapted ovl_need_adjust_d_ino() changes to the inline logic in ovl_iterate() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/readdir.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 6e13cad49ce54..abfe17068b7d6 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -474,8 +474,8 @@ static int ovl_cache_update_ino(struct path *path, struct ovl_cache_entry *p)
 			goto get;
 		}
 		if (p->len == 2 && p->name[1] == '.') {
-			/* we shall not be moved */
-			this = dget(dir->d_parent);
+			/* d_splice_alias() can move even a locked dir */
+			this = dget_parent(dir);
 			goto get;
 		}
 	}
@@ -691,6 +691,7 @@ static int ovl_iterate_real(struct file *file, struct dir_context *ctx)
 	struct ovl_dir_file *od = file->private_data;
 	struct dentry *dir = file->f_path.dentry;
 	const struct ovl_layer *lower_layer = ovl_layer_lower(dir);
+	struct dentry *parent;
 	struct ovl_readdir_translate rdt = {
 		.ctx.actor = ovl_fill_real,
 		.orig_ctx = ctx,
@@ -701,18 +702,26 @@ static int ovl_iterate_real(struct file *file, struct dir_context *ctx)
 	if (rdt.xinobits && lower_layer)
 		rdt.fsid = lower_layer->fsid;
 
-	if (OVL_TYPE_MERGE(ovl_path_type(dir->d_parent))) {
+	/*
+	 * The lock on dir does not stop d_splice_alias() from moving it to
+	 * another parent, which drops the reference dir holds on this one.
+	 */
+	parent = dget_parent(dir);
+	if (OVL_TYPE_MERGE(ovl_path_type(parent))) {
 		struct kstat stat;
 		struct path statpath = file->f_path;
 
-		statpath.dentry = dir->d_parent;
+		statpath.dentry = parent;
 		err = vfs_getattr(&statpath, &stat, STATX_INO, 0);
-		if (err)
+		if (err) {
+			dput(parent);
 			return err;
+		}
 
 		WARN_ON_ONCE(dir->d_sb->s_dev != stat.dev);
 		rdt.parent_ino = stat.ino;
 	}
+	dput(parent);
 
 	if (ovl_is_impure_dir(file)) {
 		rdt.cache = ovl_cache_get_impure(&file->f_path);
@@ -740,6 +749,8 @@ static int ovl_iterate(struct file *file, struct dir_context *ctx)
 		ovl_dir_reset(file);
 
 	if (od->is_real) {
+		struct dentry *parent = dget_parent(dentry);
+
 		/*
 		 * If parent is merge, then need to adjust d_ino for '..', if
 		 * dir is impure then need to adjust d_ino for copied up
@@ -748,11 +759,12 @@ static int ovl_iterate(struct file *file, struct dir_context *ctx)
 		if (ovl_xino_bits(dentry->d_sb) ||
 		    (ovl_same_fs(dentry->d_sb) &&
 		     (ovl_is_impure_dir(file) ||
-		      OVL_TYPE_MERGE(ovl_path_type(dentry->d_parent))))) {
+		      OVL_TYPE_MERGE(ovl_path_type(parent))))) {
 			err = ovl_iterate_real(file, ctx);
 		} else {
 			err = iterate_dir(od->realfile, ctx);
 		}
+		dput(parent);
 		goto out;
 	}
 
-- 
2.53.0



