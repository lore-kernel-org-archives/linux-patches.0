Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015091;
	b=CBn2ucIow+/hk7HTame8BNGopDmvSY+YXiK/5kdYtZCyOuVymj5dCE8AplpeAT4k430n
	 uUxBlNlZ0/jtc0f6mlXyk4JMlsKosivR/xFon/dcscORlF7a0pKIr8C7KNkeFPI8INbWv
	 8VR/D8jqBnxix5CU6jGXJTYTA9AAdjz7YECR2KqtTwtlfrfMEaOvRf+exzJ6QFK0cA0Dr
	 qgdwB8+LxAz/HIfWJutyhRm2XuBkkdB9JdWmp/INTolGFyCY7PEnGnCsAURrjoJbwKHkO
	 /yJ4z+WwQ4HJL23+n/fXfdbiF5lSV4Mo1rE2TvkBf8HofNIzzR5HU39hi/iJKaVpYrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015091;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VF0DAozOJ1siuqlQKSvqm21n+amcmUiE1xXZEHFPnXE=;
	b=yfQxndL/4A3h1IDLXbRuYcHkaQy73uWw4Y5L3WbUnOdH0oUBKHGRL8cQ2/RC3ffbRMxu
	 9eekeqG4Zy5/n1Xt/gdozTElcGCPRBiMi0ghYxiZKmKG5oJNeamMLxv46MR/Bgucx84nx
	 kFFAyWTY6G3ZCCCPDHsshzZJSqWX0Z9BBbHfwvLcwSwTifjnLPKig00Hyut0BIiM83zQc
	 ZlBo97s2YyX3+ryZoNzJbKgkhJlScuA6ZFtzV2qKDlXgzkmLl3JCZNtJCBvV6gk1pz0qD
	 EZm4yUYZIFmBSwZ5wWXbStD222f1T4iWVIMOFr52upJDSBldE6tn2cdbHQ4mak/AMpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1TB9bjQ1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7DA606A32C;
	Wed, 18 Nov 2026 15:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1TB9bjQ1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1E31F000C9;
	Wed, 18 Nov 2026 15:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015091;
	bh=VF0DAozOJ1siuqlQKSvqm21n+amcmUiE1xXZEHFPnXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1TB9bjQ1Yvq+ZijE09CHMjz2t2ppwljq2LjTKJ4MuYt0iT/VJ3fMAyfynS8gIYaud
	 9Fqd3jbhK9ro0EDDjR40dM/TFwk5/diTfXXrhTWOokozE/qUheb06NyGqkiEaLPbWd
	 zcK5+gVa+biLyDZ6/l/K4r6GjHQD9mvJEHFHuHUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nirmoy Das <nirmoyd@nvidia.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0049/2651] ovl: add assertions in dir cache code
Date: Wed, 18 Nov 2026 15:21:29 +0100
Message-ID: <20261118150249.720335210@linuxfoundation.org>
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

[ Upstream commit ba227ed05b385926094741e2d566789525c36085 ]

Overlayfs may keep two different types of directory cache
merged (refcounted) and impure (not refcounted) in the inode.

They are mutually exclusive and an overlayfs directory is never
expected to switch between merged and impure modes.

Nevertheless it is hard to prove that races in the code are not
possible, so add assertions to fortify the code accessing the
directory cache to make sure it does not free the unexpected
cache type.

If an assertion fires the code may leak dir cache memory
but it will not access freed cache memory.

Suggested-by: Nirmoy Das <nirmoyd@nvidia.com>
Link: https://lore.kernel.org/r/20260511062057.2365769-1-nirmoyd@nvidia.com/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Stable-dep-of: 9ff338af0e00 ("ovl: inherit FMODE_NONOTIFY when reading directory layers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/readdir.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index e23331212a29b..5d21a328fad46 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -36,6 +36,7 @@ struct ovl_cache_entry {
 struct ovl_dir_cache {
 	long refcount;
 	u64 version;
+	bool is_refcounted;
 	struct list_head entries;
 	struct rb_root root;
 };
@@ -479,13 +480,31 @@ static void ovl_seek_cursor(struct ovl_dir_file *od, loff_t pos)
 	od->cursor = p;
 }
 
+/*
+ * Merged (refcounted) and impure (not refcounted) caches are never
+ * expected to be mixed. On mismatch, detach the cache from the inode
+ * and leak it rather than misuse it. A merged cache is still freed by
+ * its last ovl_cache_put().
+ */
+static struct ovl_dir_cache *ovl_dir_cache_check(struct inode *inode,
+						 bool is_refcounted)
+{
+	struct ovl_dir_cache *cache = ovl_dir_cache(inode);
+
+	if (cache && WARN_ON(cache->is_refcounted != is_refcounted)) {
+		ovl_set_dir_cache(inode, NULL);
+		return NULL;
+	}
+	return cache;
+}
+
 static struct ovl_dir_cache *ovl_cache_get(struct dentry *dentry)
 {
 	int res;
 	struct ovl_dir_cache *cache;
 	struct inode *inode = d_inode(dentry);
 
-	cache = ovl_dir_cache(inode);
+	cache = ovl_dir_cache_check(inode, true);
 	if (cache && ovl_inode_version_get(inode) == cache->version) {
 		WARN_ON(!cache->refcount);
 		cache->refcount++;
@@ -498,6 +517,7 @@ static struct ovl_dir_cache *ovl_cache_get(struct dentry *dentry)
 		return ERR_PTR(-ENOMEM);
 
 	cache->refcount = 1;
+	cache->is_refcounted = true;
 	INIT_LIST_HEAD(&cache->entries);
 	cache->root = RB_ROOT;
 
@@ -698,7 +718,7 @@ static struct ovl_dir_cache *ovl_cache_get_impure(const struct path *path)
 	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
 	struct ovl_dir_cache *cache;
 
-	cache = ovl_dir_cache(inode);
+	cache = ovl_dir_cache_check(inode, false);
 	if (cache && ovl_inode_version_get(inode) == cache->version)
 		return cache;
 
@@ -710,6 +730,7 @@ static struct ovl_dir_cache *ovl_cache_get_impure(const struct path *path)
 	if (!cache)
 		return ERR_PTR(-ENOMEM);
 
+	cache->is_refcounted = false;
 	res = ovl_dir_read_impure(path, &cache->entries, &cache->root);
 	if (res) {
 		ovl_cache_free(&cache->entries);
-- 
2.53.0



