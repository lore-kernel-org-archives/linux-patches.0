Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035639;
	b=04zopLp0mW/0AWCz9/vCJ8+Nccet7AyTzJ97S2HBfAcLIh9HoQxdLKTwhHYT2i1omByt
	 vXKCeRrC4rPIAxOSkfMxYxYkkv18cP8ycxBu+MeDyP1afA54VKD3Ay1pLa6WiXrc5jSvH
	 KWsRt2vWOvLTWfocv59hZvpXJXmvlSG35mEVXhFOXccd2JDocVtTdU/tEYfBwvn36qEBI
	 cLxCVzkZhe1ljSYXq70TNMgLMSDmcAQoJHfyBPB+Wk0QfszpxPKqHqCNf5aGpDoThciZD
	 ChpO2hkN6iQf96qga6FnKsZysuRT09jIZzyoFm+qfzTZLRE8sAbGN2OML+SWWxM6vjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035639;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ef1PQ8P6CPMUX0BtJbThU3AH/6Nrme0JLF2gPpMWGYY=;
	b=arJy47zuym8JNGUQ3YkL4Diog4E9UWQmu/s6dUEt1WhkFtCdJZ0fV0sa3J+c8n3Fublq
	 6kbUmDomXUQj0zBGVzy/e0aDXwJoz1Ud7gBgCbWUs3pUHDY0sxrSNDC4OXU0HauC6pp5H
	 ohQJTTY79CK+s9jrRZgWJnrQ5LVoHB4sLCoUIUCC6zD7ZOgf38RiBZeYiIOKkV0RY+/wE
	 60JY+o/PDMAxkSouzdOT0uT6LJaXxn6imBnC5eTdpb0PBQ+EBsg9bUqddPXkOd/WMBhIm
	 QWgA5VTH1X4JHbdHYLt0+tjPdmxp/8ZWF4/8svLYivI8O1d4sDgbGeAe4oW9sh9AMxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EjSmX6XL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88216606A325;
	Wed, 18 Nov 2026 21:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EjSmX6XL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3891F000C6;
	Wed, 18 Nov 2026 21:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035639;
	bh=Ef1PQ8P6CPMUX0BtJbThU3AH/6Nrme0JLF2gPpMWGYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EjSmX6XLJVQc5aART4JIJGd8FD1yraIyLqdrZtbGv5rqArL7UrEH6mJyLWxCso7jf
	 PMpO65e8w+WKgRw33S5suBxQBc54kZffnM47MIuB9JwbUSmOz2RzKA7Qw+BwYGySpt
	 s8G2tXCS7wWjOR9z0GQfdS7zKkPU6qS1lNTsN/iM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0774/3318] ovl: hold a reference on the parent in readdir
Date: Wed, 18 Nov 2026 15:23:16 +0100
Message-ID: <20261118150342.000669549@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 07eda53d282f7..9252e20bdab8b 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -476,8 +476,8 @@ static int ovl_cache_update_ino(const struct path *path, struct ovl_cache_entry
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
@@ -697,6 +697,7 @@ static int ovl_iterate_real(struct file *file, struct dir_context *ctx)
 	struct dentry *dir = file->f_path.dentry;
 	struct ovl_fs *ofs = OVL_FS(dir->d_sb);
 	const struct ovl_layer *lower_layer = ovl_layer_lower(dir);
+	struct dentry *parent;
 	struct ovl_readdir_translate rdt = {
 		.ctx.actor = ovl_fill_real,
 		.orig_ctx = ctx,
@@ -707,18 +708,26 @@ static int ovl_iterate_real(struct file *file, struct dir_context *ctx)
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
@@ -747,6 +756,10 @@ static int ovl_iterate(struct file *file, struct dir_context *ctx)
 		ovl_dir_reset(file);
 
 	if (od->is_real) {
+		struct dentry *parent = dget_parent(dentry);
+		bool parent_merge = OVL_TYPE_MERGE(ovl_path_type(parent));
+
+		dput(parent);
 		/*
 		 * If parent is merge, then need to adjust d_ino for '..', if
 		 * dir is impure then need to adjust d_ino for copied up
@@ -754,8 +767,7 @@ static int ovl_iterate(struct file *file, struct dir_context *ctx)
 		 */
 		if (ovl_xino_bits(ofs) ||
 		    (ovl_same_fs(ofs) &&
-		     (ovl_is_impure_dir(file) ||
-		      OVL_TYPE_MERGE(ovl_path_type(dentry->d_parent))))) {
+		     (ovl_is_impure_dir(file) || parent_merge))) {
 			err = ovl_iterate_real(file, ctx);
 		} else {
 			err = iterate_dir(od->realfile, ctx);
-- 
2.53.0



