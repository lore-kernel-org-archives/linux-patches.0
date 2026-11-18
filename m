Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059967;
	b=kNduBtq+K/VlrVeSrQZSjz9ocuvUR0Ky8Qe9OlL015CGwexy9is1y2p3V6ulYt2H8Qkq
	 KteXVuQl3jphkJd+xd3f/7YeeLHZEjilxOwFm4zJ5arumnf9eU3oadiyB3PUnhkChyh3a
	 4obIHj2MmsgP6tqWm7G+5k0li/+JKvHWuq2jbtcZz2pLLKtyEi0m9DAHtZ2tJOxIZ8Sfp
	 3LWNjjQ6zu9sTN2VwCq8UnABa6gGFsrDhkpdrlKvtbIcYPikwkDZwKLsqT6t8RltgnQeK
	 zyTJMfzxm9AEZZDoDSnfPylAfT+K5cObLl6IzdAianFDW+RaL1h8caBZcS93JZZhpMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059967;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Clp3wzF75IQKxrtvduhMP8a4DYkmSAzovbxR1g+DOJc=;
	b=OXm+4pQV/VUVi9IHbJOnL9G036RI9vfirWgCJQ1aDDzwcwdv57MKxqwSciFfD5uWUrI6
	 bfAMdhZdf+PPhuui4Myc0SQS9XWAuyMHBTir1XAhvEnQ6RWzP8Gy/hzd/nr896QgTqX4K
	 VRDwjKwaeQhGJLQbfWGI860wIoovtfRJiaIYbS1ryqlfekjEmZAKZQ/YH6NA6ZI1xEXh3
	 d2wzPTjqWlg1fLmFlr2huB0e2ULVRAxxn8Yu3Z9efZgNgRkV3vecKe7UewVp2lSZY/AH0
	 KeJr0LOEmIa9oB6lpq5ff8l8QwyxzbH42uO5Y3YHt2QRBKMjRoAz2XlcrLtgmE2IxTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sgwtWgZR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E266C606A320;
	Thu, 19 Nov 2026 03:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sgwtWgZR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA1A81F000C4;
	Thu, 19 Nov 2026 03:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059966;
	bh=Clp3wzF75IQKxrtvduhMP8a4DYkmSAzovbxR1g+DOJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sgwtWgZRLgO0EOYh90Om1dHyEnX/ugi/Xg/TUmQvwL8rwev+pumd7DFTDqW96MIQp
	 VHuzYC5DJhzbMBfzXewi1ZG1fnqlqs/pjhFPL+/TsT/SvuJ+Xpg0t6oiGU3MMWDSXR
	 SWylWN09BuX+CpCahiDPmtZsA0aIXY0D0VSbRt7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1031/1848] new helper: d_splice_alias_ops()
Date: Wed, 18 Nov 2026 15:51:09 +0100
Message-ID: <20261118150000.548307214@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 790fa81b8c43cda9fe25c1b564d0afe3ddeeb370 ]

Uses of d_set_d_op() on live dentry can be very dangerous; it is going
to be withdrawn and replaced with saner things.

The best way for a filesystem is to have the default dentry_operations
set at mount time and be done with that - __d_alloc() will use that.

Currently there are two cases when d_set_d_op() is used on a live dentry -
one is procfs, which has several genuinely different dentry_operations
instances (different ->d_revalidate(), etc.) and another is
simple_lookup(), where we would be better off without overriding ->d_op.

For procfs we have d_set_d_op() calls followed by d_splice_alias();
provide a new helper (d_splice_alias_ops(inode, dentry, d_ops)) that would
combine those two, and do the d_set_d_op() part while under ->d_lock.
That eliminates one of the places where ->d_flags had been modified
without holding ->d_lock; current behaviour is not racy, but the reasons
for that are far too brittle.  Better move to uniform locking rules and
simpler proof of correctness...

The next commit will convert procfs to use of that helper; it is not
exported and won't be until somebody comes up with convincing modular
user for it.

Again, the best approach is to have default ->d_op and let __d_alloc()
do the right thing; filesystem _may_ need non-uniform ->d_op (procfs
does), but there'd better be good reasons for that.

Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Stable-dep-of: eeecea75ece2 ("proc: don't let an entry below /proc/<pid>/net be a mountpoint")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/dcache.c            | 63 ++++++++++++++++++++++++------------------
 include/linux/dcache.h |  3 ++
 2 files changed, 39 insertions(+), 27 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 34e8a97e0323e..52b7211cba915 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2668,7 +2668,8 @@ EXPORT_SYMBOL(__d_lookup_done);
 
 /* inode->i_lock held if inode is non-NULL */
 
-static inline void __d_add(struct dentry *dentry, struct inode *inode)
+static inline void __d_add(struct dentry *dentry, struct inode *inode,
+			   const struct dentry_operations *ops)
 {
 	struct inode *dir = NULL;
 	unsigned n;
@@ -2678,6 +2679,8 @@ static inline void __d_add(struct dentry *dentry, struct inode *inode)
 		n = start_dir_add(dir);
 		__d_lookup_done(dentry);
 	}
+	if (unlikely(ops))
+		d_set_d_op(dentry, ops);
 	if (inode) {
 		unsigned add_flags = d_flags_for_inode(inode);
 		hlist_add_head(&dentry->d_u.d_alias, &inode->i_dentry);
@@ -2709,7 +2712,7 @@ void d_add(struct dentry *entry, struct inode *inode)
 		security_d_instantiate(entry, inode);
 		spin_lock(&inode->i_lock);
 	}
-	__d_add(entry, inode);
+	__d_add(entry, inode, NULL);
 }
 EXPORT_SYMBOL(d_add);
 
@@ -3004,30 +3007,8 @@ static int __d_unalias(struct inode *inode,
 	return ret;
 }
 
-/**
- * d_splice_alias - splice a disconnected dentry into the tree if one exists
- * @inode:  the inode which may have a disconnected dentry
- * @dentry: a negative dentry which we want to point to the inode.
- *
- * If inode is a directory and has an IS_ROOT alias, then d_move that in
- * place of the given dentry and return it, else simply d_add the inode
- * to the dentry and return NULL.
- *
- * If a non-IS_ROOT directory is found, the filesystem is corrupt, and
- * we should error out: directories can't have multiple aliases.
- *
- * This is needed in the lookup routine of any filesystem that is exportable
- * (via knfsd) so that we can build dcache paths to directories effectively.
- *
- * If a dentry was found and moved, then it is returned.  Otherwise NULL
- * is returned.  This matches the expected return value of ->lookup.
- *
- * Cluster filesystems may call this function with a negative, hashed dentry.
- * In that case, we know that the inode will be a regular file, and also this
- * will only occur during atomic_open. So we need to check for the dentry
- * being already hashed only in the final case.
- */
-struct dentry *d_splice_alias(struct inode *inode, struct dentry *dentry)
+struct dentry *d_splice_alias_ops(struct inode *inode, struct dentry *dentry,
+				  const struct dentry_operations *ops)
 {
 	if (IS_ERR(inode))
 		return ERR_CAST(inode);
@@ -3073,9 +3054,37 @@ struct dentry *d_splice_alias(struct inode *inode, struct dentry *dentry)
 		}
 	}
 out:
-	__d_add(dentry, inode);
+	__d_add(dentry, inode, ops);
 	return NULL;
 }
+
+/**
+ * d_splice_alias - splice a disconnected dentry into the tree if one exists
+ * @inode:  the inode which may have a disconnected dentry
+ * @dentry: a negative dentry which we want to point to the inode.
+ *
+ * If inode is a directory and has an IS_ROOT alias, then d_move that in
+ * place of the given dentry and return it, else simply d_add the inode
+ * to the dentry and return NULL.
+ *
+ * If a non-IS_ROOT directory is found, the filesystem is corrupt, and
+ * we should error out: directories can't have multiple aliases.
+ *
+ * This is needed in the lookup routine of any filesystem that is exportable
+ * (via knfsd) so that we can build dcache paths to directories effectively.
+ *
+ * If a dentry was found and moved, then it is returned.  Otherwise NULL
+ * is returned.  This matches the expected return value of ->lookup.
+ *
+ * Cluster filesystems may call this function with a negative, hashed dentry.
+ * In that case, we know that the inode will be a regular file, and also this
+ * will only occur during atomic_open. So we need to check for the dentry
+ * being already hashed only in the final case.
+ */
+struct dentry *d_splice_alias(struct inode *inode, struct dentry *dentry)
+{
+	return d_splice_alias_ops(inode, dentry, NULL);
+}
 EXPORT_SYMBOL(d_splice_alias);
 
 /*
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 6f95c3300cbbb..9f21ea124842c 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -240,6 +240,9 @@ extern struct dentry * d_alloc_anon(struct super_block *);
 extern struct dentry * d_alloc_parallel(struct dentry *, const struct qstr *,
 					wait_queue_head_t *);
 extern struct dentry * d_splice_alias(struct inode *, struct dentry *);
+/* weird procfs mess; *NOT* exported */
+extern struct dentry * d_splice_alias_ops(struct inode *, struct dentry *,
+					  const struct dentry_operations *);
 extern struct dentry * d_add_ci(struct dentry *, struct inode *, struct qstr *);
 extern struct dentry * d_exact_alias(struct dentry *, struct inode *);
 extern struct dentry *d_find_any_alias(struct inode *inode);
-- 
2.53.0



