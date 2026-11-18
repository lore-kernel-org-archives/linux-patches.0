Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023765;
	b=twcjmz0UCwj3huU7EtGoOIt+KeQdwy4bJcEWeDaFbcP2wkLVhx52npx+u7vjB8Lf6Wan
	 TcODf2AmhuJpQ9LoG+I5l1JMHWk79JlqZfY7O0NXyrtVaQujq1bELMkA3AdFXhqmEGYXy
	 fxgNC92F0N95/XLMTX6lu1BPAnByJ9njIYfOkYeSqzFDHY18eau75utPKMo0L5NKAtYXr
	 VRc2bsphDGfNIRbWYcyWOv5cvCQftShuLs+PX5WT1wt1MIulLnWSEE4Y8wwd8CVRG/ePt
	 sqmilZUs2VUxs6P842MI0nLpdQAKrYodKm+SIxctVlgZTteFXbTHvsG7KSp4c6YNTwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023765;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HqKPIAQK/hAHR2le7vsa1l8eo9CLT+9TVq8FOMt4Pak=;
	b=EiIWmn6ccp3JhhSBDb1Zz2/5gPBwcGV8WCopwPLL8Seyuu40dYcPmPcItZHcZLYBFxln
	 phWN0KGxymyPPir1na99cpMnVhWVQG8a8y2HzW3KXOGbFgz+G7FIxQPK3FxkrZNE2KMgz
	 yXHOhS50+ruCndD4UwEPbG4DK68PqucmByKWCUYHqhzdf4ful/f/XtC/uN73Q2gt8MLkH
	 rv17jtscVc5gD1KRhLdsG4iXoPHOW46+5l9p1xXd3VH7FFDjedqI/SBsw1cQvhg5hrUR8
	 Cr8Mwws2NaTZ+8xN/S5YjnO+SVU0jOQM0MjpHpESXdyiK2o+XsWWS6k93WdHFShrgbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A8RbdxGI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04F0606A31C;
	Wed, 18 Nov 2026 17:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A8RbdxGI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A8A21F000C4;
	Wed, 18 Nov 2026 17:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023765;
	bh=HqKPIAQK/hAHR2le7vsa1l8eo9CLT+9TVq8FOMt4Pak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A8RbdxGITsn/xZP+qP0RE8HYLgJSeTNCWkWJeskL9Wktg9gtpzA7Q9lqsiHw2eMP5
	 TvuVd9ToeXO7Ci8mZ0rlGkfC8QwwekXlV432lW4FmcmDaTjjdm7L99W3k2tScNZTu+
	 TvFmYDuw8bSholZpjU9uD248jf4qlh9Tl/X0PgWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0487/2151] kernfs: dont repeat or skip an entry when readdir resumes
Date: Wed, 18 Nov 2026 15:37:02 +0100
Message-ID: <20261118150139.792116067@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Shakeel Butt <shakeel.butt@linux.dev>

[ Upstream commit 5ebcb578adeec7407dd501108ab2f423ca8e3e55 ]

readdir keeps its place as a name hash in ctx->pos and pins the entry in
file->private_data.  If that entry is gone when the listing comes back,
kernfs_dir_pos() searches the rbtree for the hash and keeps whatever
node the descent stopped on.  That is the entry before or after the
missing one, depending on the shape of the tree.

Landing before it repeats an entry the previous getdents(2) call already
reported.  Landing after it, kernfs_dir_next_pos() calls rb_next() and
steps over an unreported entry.

With children A(10), B(20), C(30):

  report A, ctx->pos = 10
                                    A removed
  kernfs_dir_next_pos(10, A)
    A is gone, the search for 10 stops at B
    rb_next(B) -> C, so B is never reported

Only the repeat happens today, between two getdents(2) calls.  The skip
needs the pinned entry to go away inside one call, which the next patch
allows when it drops kernfs_rwsem around dir_emit().

Before the commit 4e4d6d860b93 the descent kept a node only on the way
left, which is a search for the first entry at or after the hash.  That
commit moved the assignment to the top of the loop, where it runs on
right turns too.  Restore that search, and step forward only when the
pinned entry is still there rather than when the hash matches, since two
entries in one directory can share a hash.

While here, kernfs_dir_next_pos() called the hash @ino.  It is never an
inode number, so name it @hash.

Fixes: 4e4d6d860b93 ("sysfs: Add s_hash to sysfs_dirent and order directory entries by hash")
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Link: https://patch.msgid.link/20260911182815.1992483-2-shakeel.butt@linux.dev
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/kernfs/dir.c | 43 ++++++++++++++++++++++++++++---------------
 1 file changed, 28 insertions(+), 15 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 0fcebf4201206..8730e0ab96d27 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -1840,9 +1840,16 @@ static int kernfs_dir_fop_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
+/*
+ * Find where a listing left off.  @resumed says whether @pos is still that
+ * entry; if not, the first entry at or after @hash is returned instead.
+ */
 static struct kernfs_node *kernfs_dir_pos(const struct ns_common *ns,
-	struct kernfs_node *parent, loff_t hash, struct kernfs_node *pos)
+	struct kernfs_node *parent, loff_t hash, struct kernfs_node *pos,
+	bool *resumed)
 {
+	if (resumed)
+		*resumed = false;
 	if (pos) {
 		int valid = kernfs_active(pos) &&
 			rcu_access_pointer(pos->__parent) == parent &&
@@ -1850,23 +1857,26 @@ static struct kernfs_node *kernfs_dir_pos(const struct ns_common *ns,
 		kernfs_put(pos);
 		if (!valid)
 			pos = NULL;
+		else if (resumed)
+			*resumed = true;
 	}
 	if (!pos && (hash > 1) && (hash < INT_MAX)) {
 		struct rb_node *node = parent->dir.children.rb_node;
-		u64 ns_id = kernfs_ns_id(ns);
+
+		/*
+		 * Keep a node only on the way left, so the search ends on the
+		 * first entry at or after @hash.  The empty name sorts before
+		 * every entry sharing the hash, so it lands on the first.
+		 */
 		while (node) {
-			pos = rb_to_kn(node);
+			struct kernfs_node *kn = rb_to_kn(node);
 
-			if (hash < pos->hash)
+			if (kernfs_name_compare(hash, "", ns, kn) < 0) {
+				pos = kn;
 				node = node->rb_left;
-			else if (hash > pos->hash)
+			} else {
 				node = node->rb_right;
-			else if (ns_id < kernfs_ns_id(pos->ns))
-				node = node->rb_left;
-			else if (ns_id > kernfs_ns_id(pos->ns))
-				node = node->rb_right;
-			else
-				break;
+			}
 		}
 	}
 	/* Skip over entries which are dying/dead or in the wrong namespace */
@@ -1881,10 +1891,13 @@ static struct kernfs_node *kernfs_dir_pos(const struct ns_common *ns,
 }
 
 static struct kernfs_node *kernfs_dir_next_pos(const struct ns_common *ns,
-	struct kernfs_node *parent, ino_t ino, struct kernfs_node *pos)
+	struct kernfs_node *parent, loff_t hash, struct kernfs_node *pos)
 {
-	pos = kernfs_dir_pos(ns, parent, ino, pos);
-	if (pos) {
+	bool resumed;
+
+	pos = kernfs_dir_pos(ns, parent, hash, pos, &resumed);
+	/* Step over @pos only if it survived; two entries can share a hash. */
+	if (pos && resumed) {
 		do {
 			struct rb_node *node = rb_next(&pos->rb);
 			if (!node)
@@ -1913,7 +1926,7 @@ static int kernfs_fop_readdir(struct file *file, struct dir_context *ctx)
 	if (kernfs_ns_enabled(parent))
 		ns = kernfs_info(dentry->d_sb)->ns;
 
-	for (pos = kernfs_dir_pos(ns, parent, ctx->pos, pos);
+	for (pos = kernfs_dir_pos(ns, parent, ctx->pos, pos, NULL);
 	     pos;
 	     pos = kernfs_dir_next_pos(ns, parent, ctx->pos, pos)) {
 		const char *name = kernfs_rcu_name(pos);
-- 
2.53.0



