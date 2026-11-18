Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044909;
	b=eBehxbmVlTLKbxh+cOMyP0HJ48uZhBUHc4QIBEWx8nQmNcegd1tIdjigt/UQ/QqnvKo9
	 RgtzCe9df6f0gbBunJY/42GU4GNBiX+GfD6DKzYbRqJBQ4B9rl5PLfpPsfFz5qEjeGspF
	 Immk1FiD/xZRxYju8L3z9bH/eVQ3QkjM96CnzsMQMjr4cOyIyfBrjsKsEJ3gE0kv++gg7
	 HUANTvILXSD5LDjFfodRRvPPOdZHINCRAFsbdkIZQJbiARH3MttwomIri56B5prFm1oK3
	 /pn1mS5BHkPPsSA/KIQuG+FTnqN1CG4ysvUlkCZrL6rS6i2I6C2WmUW71JY+Q3gUsLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044909;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=irh9O+GGCSX5mAtPWo7eru+lL5kRtOizew0PrH2yzMA=;
	b=MjO/9VpT8FUwvg4ynLnPebWhh8lgSPBdJeotfFGouxzXWGgQMUlNriFUsBpDc6rMjgfF
	 eSwn+OcBbNqN2/E8eyc5FA7HZP/i51DB3t8i+jbdAkSzB7gViykved8cBs4wdXMiYZ3ZG
	 q+2UHGfCH1mJixEOE6XxJ5JcFRXY4PHPqKC7qphag6yjfoVWrP2jKyHXh2qCn90D8nDjt
	 h+bbr8jZA6ntf780boC9IcrEVI4dfaqMdduNEShG130XL054sn5KUMMSlSj2RsoTerCM5
	 SNLOUmx4XX+EyUR4QcvvFFERK/Rhq7KzfIEcFCV7jmkphW6zGo81QslDxBaVF1DqnrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iMRGZlET;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB876606A337;
	Wed, 18 Nov 2026 23:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iMRGZlET
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6831F000C4;
	Wed, 18 Nov 2026 23:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044909;
	bh=irh9O+GGCSX5mAtPWo7eru+lL5kRtOizew0PrH2yzMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iMRGZlETZjcK4SJwxm+Yzmzr866kxRzkv+dBaKJ4eJbHJi0/J1K53ILwSGWS6zURr
	 nZriOiezMbn07bbswTpzmvcQYRObOfHpB5QLQF0eduGpdHZGbx0eliv2p/kPuCFa/z
	 U96BtWyyyqVgERo3X3E+8CA+hMP/d6orkxpdv7go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0685/2857] ovl: hold a reference on the parent in readdir
Date: Wed, 18 Nov 2026 15:28:39 +0100
Message-ID: <20261118150226.222244652@linuxfoundation.org>
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

From: Chris Mason <mason@kernel.org>

commit 16d319e12328acafeafd3eecdf09c46d7fb43452 upstream.

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
[backport: no ovl_need_adjust_d_ino(), take the parent with dget_parent()
 in ovl_iterate() and test a local flag]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/readdir.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 36a26a0ec966f..cd7a81b6da8be 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -474,8 +474,8 @@ static int ovl_cache_update_ino(const struct path *path, struct ovl_cache_entry
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
@@ -693,6 +693,7 @@ static int ovl_iterate_real(struct file *file, struct dir_context *ctx)
 	struct ovl_dir_file *od = file->private_data;
 	struct dentry *dir = file->f_path.dentry;
 	const struct ovl_layer *lower_layer = ovl_layer_lower(dir);
+	struct dentry *parent;
 	struct ovl_readdir_translate rdt = {
 		.ctx.actor = ovl_fill_real,
 		.orig_ctx = ctx,
@@ -703,18 +704,26 @@ static int ovl_iterate_real(struct file *file, struct dir_context *ctx)
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
@@ -742,6 +751,10 @@ static int ovl_iterate(struct file *file, struct dir_context *ctx)
 		ovl_dir_reset(file);
 
 	if (od->is_real) {
+		struct dentry *parent = dget_parent(dentry);
+		bool parent_merge = OVL_TYPE_MERGE(ovl_path_type(parent));
+
+		dput(parent);
 		/*
 		 * If parent is merge, then need to adjust d_ino for '..', if
 		 * dir is impure then need to adjust d_ino for copied up
@@ -749,8 +762,7 @@ static int ovl_iterate(struct file *file, struct dir_context *ctx)
 		 */
 		if (ovl_xino_bits(dentry->d_sb) ||
 		    (ovl_same_fs(dentry->d_sb) &&
-		     (ovl_is_impure_dir(file) ||
-		      OVL_TYPE_MERGE(ovl_path_type(dentry->d_parent))))) {
+		     (ovl_is_impure_dir(file) || parent_merge))) {
 			err = ovl_iterate_real(file, ctx);
 		} else {
 			err = iterate_dir(od->realfile, ctx);
-- 
2.53.0



