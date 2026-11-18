Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015094;
	b=0ZWDiF6xU6LIwQ+uVdyEMRtOZv8lLKfV0d054YIqkh+lM5jm9uAOCG1ooQh0BWFn6LEw
	 i61lIqGCd+QmRq1AIejhweTtTODllS8pIbvgfJPyZiggOQfrC/o+fPWU5996/qgt3Pj+r
	 jdTk4ctW8MYzUnAJ22nlOgX/yroVBo+PGMntj59mTHWHzGD054lYzhJDggF6JsQ9Eqwhu
	 nTYYcIerq6oN6LEtFoQXAuvxDg5MlS42LJB5JMa2mo0F97ofriBeEpJQ2SkFkxWt6AC8E
	 83CEjp+q4oIR1Bg1R49zSobEOqqPodpBeThFDiP+LyahJpJDRuP+cNSoNzKJyEd+GOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015094;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GtBZim4CKg3ticMKOmRq9CrKUw7AHm6p5VNa1gSS56c=;
	b=0FrwKv1FhZXPaI5lNq0WK2aL6RNbFYtQvgb0s/CpPp1JJo3aJ2HGpOwfD/STHnzbd2n1
	 LHTq35SeMo/orJGt2lnMAqhlCjai+p4RQBGbesp6TsRCnkmj2/DjSfy2bC8UiRY1Zqq6n
	 XFnm7YB8csVipM9u7e47VvG19+mFzf4PRcdzW6OBTzvPloyOf47wopEWcVbFUxhSA5QTl
	 NaqzsLRUZNiU0BKKcRTiudoPjKC0fCj83Ppix9wI6FBOESXsoKVDNTiKWf7e7mFOxTPKF
	 uEvjj4KmWlVmaRLuYElCBWR+gux1hsNnR6T0X/FkEV/tuWCGydHis/RJDGn2wCj/1mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dcyvNh4m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED94E60A2616;
	Wed, 18 Nov 2026 15:18:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dcyvNh4m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 485F41F0093B;
	Wed, 18 Nov 2026 15:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015093;
	bh=GtBZim4CKg3ticMKOmRq9CrKUw7AHm6p5VNa1gSS56c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dcyvNh4mP8hh206WFHzUDr6zVv9vv50D4s+s8InoqVGh+/3CboRUhGtZULmv0ghgq
	 IHa7ufm+IC/Cvae689VE65Ge0LMWuMHzvwkZNTAfiAedaTPyHLoX0ULWYWyKwDLuQ8
	 OFX+I/hTjDD8utz3qiwexMZ+cNChDwqr+8bgt7XQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edvard Conrad <edvard@tuta.io>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0050/2651] ovl: inherit FMODE_NONOTIFY when reading directory layers
Date: Wed, 18 Nov 2026 15:21:30 +0100
Message-ID: <20261118150249.757439099@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit 9ff338af0e002fe217cfa16b1289b76f6b21fc72 ]

Listing a merged or impure overlay directory opens the real layer
directories from ovl_dir_read(), when the readdir cache is filled.
Those opens use plain ovl_path_open(), so when the directory fd is
one that fanotify created for a permission event, they can still raise
FS_OPEN_PERM.  A listener that also marks the backing filesystem and
calls getdents() on the event fd before answering then deadlocks the
same way as with the directory open fixed by the previous commit.

Store the overlay user file in struct ovl_readdir_data and pass it to
ovl_path_open_realfile() from ovl_dir_read(), for both the merged and
the impure cache.  Internal readers such as ovl_check_empty_dir() and
the mount-time workdir cleanup still pass no user file.

A note about severity and real world impact: The FAN_OPEN_PERM event is
traditionally used by anti-malware protection agents and security/audit
agents. The scope that is often used in those use cases is FAN_MARK_MOUNT
and agents typically monitor multiple mounts in a mount namespace.
FAN_OPEN_PERM from directory open requires user opt-in with FAN_ONDIR.
It is often not the case that anti-malware agents monitor open of
directories. Security/audit engines are more likely to opt-into
FAN_OPEN_PERM on directories, but are less likely to list the content
of a directory within the scope of FAN_OPEN_PERM event, so the real
world impact of this bug is likely not significant.

Reported-by: Edvard Conrad <edvard@tuta.io>
Closes: https://lore.kernel.org/all/P5Qu3co--N-9@tuta.io/
Cc: stable@vger.kernel.org
Tested-by: Edvard Conrad <edvard@tuta.io>
Link: https://lore.kernel.org/ltp/P5WKBbq--F-9@tuta.io/
Co-developed-by: Edvard Conrad <edvard@tuta.io>
Signed-off-by: Edvard Conrad <edvard@tuta.io>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/readdir.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 5d21a328fad46..4cd4af097e5c1 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -43,6 +43,7 @@ struct ovl_dir_cache {
 
 struct ovl_readdir_data {
 	struct dir_context ctx;
+	const struct file *user_file;
 	struct dentry *dentry;
 	bool is_lowest;
 	struct rb_root *root;
@@ -377,7 +378,8 @@ static inline int ovl_dir_read(const struct path *realpath,
 	struct file *realfile;
 	int err;
 
-	realfile = ovl_path_open(realpath, O_RDONLY | O_LARGEFILE);
+	realfile = ovl_path_open_realfile(rdd->user_file, realpath,
+					  O_RDONLY | O_LARGEFILE);
 	if (IS_ERR(realfile))
 		return PTR_ERR(realfile);
 
@@ -421,13 +423,14 @@ static void ovl_dir_reset(struct file *file)
 }
 
 static int ovl_dir_read_merged(struct dentry *dentry, struct list_head *list,
-	struct rb_root *root)
+	struct rb_root *root, const struct file *user_file)
 {
 	int err;
 	struct path realpath;
 	struct ovl_readdir_data rdd = {
 		.ctx.actor = ovl_fill_merge,
 		.ctx.count = INT_MAX,
+		.user_file = user_file,
 		.dentry = dentry,
 		.list = list,
 		.root = root,
@@ -498,9 +501,10 @@ static struct ovl_dir_cache *ovl_dir_cache_check(struct inode *inode,
 	return cache;
 }
 
-static struct ovl_dir_cache *ovl_cache_get(struct dentry *dentry)
+static struct ovl_dir_cache *ovl_dir_cache_get(struct file *file)
 {
 	int res;
+	struct dentry *dentry = file->f_path.dentry;
 	struct ovl_dir_cache *cache;
 	struct inode *inode = d_inode(dentry);
 
@@ -521,7 +525,7 @@ static struct ovl_dir_cache *ovl_cache_get(struct dentry *dentry)
 	INIT_LIST_HEAD(&cache->entries);
 	cache->root = RB_ROOT;
 
-	res = ovl_dir_read_merged(dentry, &cache->entries, &cache->root);
+	res = ovl_dir_read_merged(dentry, &cache->entries, &cache->root, file);
 	if (res) {
 		ovl_cache_free(&cache->entries);
 		kfree(cache);
@@ -665,8 +669,8 @@ static bool ovl_fill_plain(struct dir_context *ctx, const char *name,
 	return true;
 }
 
-static int ovl_dir_read_impure(const struct path *path,  struct list_head *list,
-			       struct rb_root *root)
+static int ovl_dir_read_impure(const struct path *path, struct list_head *list,
+			       struct rb_root *root, const struct file *user_file)
 {
 	int err;
 	struct path realpath;
@@ -674,6 +678,7 @@ static int ovl_dir_read_impure(const struct path *path,  struct list_head *list,
 	struct ovl_readdir_data rdd = {
 		.ctx.actor = ovl_fill_plain,
 		.ctx.count = INT_MAX,
+		.user_file = user_file,
 		.list = list,
 		.root = root,
 	};
@@ -710,9 +715,10 @@ static int ovl_dir_read_impure(const struct path *path,  struct list_head *list,
 	return 0;
 }
 
-static struct ovl_dir_cache *ovl_cache_get_impure(const struct path *path)
+static struct ovl_dir_cache *ovl_cache_get_impure(struct file *file)
 {
 	int res;
+	const struct path *path = &file->f_path;
 	struct dentry *dentry = path->dentry;
 	struct inode *inode = d_inode(dentry);
 	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
@@ -731,7 +737,7 @@ static struct ovl_dir_cache *ovl_cache_get_impure(const struct path *path)
 		return ERR_PTR(-ENOMEM);
 
 	cache->is_refcounted = false;
-	res = ovl_dir_read_impure(path, &cache->entries, &cache->root);
+	res = ovl_dir_read_impure(path, &cache->entries, &cache->root, file);
 	if (res) {
 		ovl_cache_free(&cache->entries);
 		kfree(cache);
@@ -852,7 +858,7 @@ static int ovl_iterate_real(struct file *file, struct dir_context *ctx)
 	dput(parent);
 
 	if (ovl_is_impure_dir(file)) {
-		rdt.cache = ovl_cache_get_impure(&file->f_path);
+		rdt.cache = ovl_cache_get_impure(file);
 		if (IS_ERR(rdt.cache))
 			return PTR_ERR(rdt.cache);
 	}
@@ -866,14 +872,13 @@ static int ovl_iterate_real(struct file *file, struct dir_context *ctx)
 static int ovl_iterate_merged(struct file *file, struct dir_context *ctx)
 {
 	struct ovl_dir_file *od = file->private_data;
-	struct dentry *dentry = file->f_path.dentry;
 	struct ovl_cache_entry *p;
 	int err;
 
 	if (!od->cache) {
 		struct ovl_dir_cache *cache;
 
-		cache = ovl_cache_get(dentry);
+		cache = ovl_dir_cache_get(file);
 		if (IS_ERR(cache))
 			return PTR_ERR(cache);
 
@@ -1120,7 +1125,7 @@ int ovl_check_empty_dir(struct dentry *dentry, struct list_head *list)
 	struct rb_root root = RB_ROOT;
 
 	with_ovl_creds(dentry->d_sb)
-		err = ovl_dir_read_merged(dentry, list, &root);
+		err = ovl_dir_read_merged(dentry, list, &root, NULL);
 	if (err)
 		return err;
 
-- 
2.53.0



