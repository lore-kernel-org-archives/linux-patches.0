Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054295;
	b=fCA5k1pttsEsq01pKLWUMgs9UFWExROo7txg4RdmVnK+ZJT9hT+XIEIFLChKmk+glB7i
	 xU5i9h0z2obqAsZqtlBOLv2Qei+40t+EzSUzIimATF1dUqa5Q6xXJkyI1GM+B0/QiJ/fo
	 z1We3llgFAJ7Q4Lz49K0Y4k8VIo7Vxy4084JYeLeRqZRs0BXK8zFpr1E2j9j0JVVAO3dk
	 WzhVbr3hUgqMtA7nZKWDG/NVQw3Oeh69krTeUlOfQIgvZL9PxyI6fCiagSUuZO8aT2HKA
	 rhoQ5zk5m0/R4Hm7ZlKJSaz+W3/9HrRHT2HYo3iYwssFC4NVJr/A9YlGcWWF1IXPZkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054295;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L26clyuEVrpDGOrKZDsQjJFuxtqOm63RzE0xqT9hmHg=;
	b=heSOz9IKHK187WYp4ccMXd3ZsSuW6DtfuHWIQplgPd+ruSpVvAy0subWyZHQr4n1TYLH
	 H7nkhDBjXBgItCmGoi/zSFD4bNJykQQHI3JilzIxMbJfsN0NFOYRjw2A566S3c70Pc5em
	 S+Kj00WkMbRBo/ap76COeGT2Pk5Yy2zF6yrYPKF1jr1q0YL9FYKoElgZIe/tgVjH9rI8e
	 THRCE6EpiEvQfhHKpx/Y3vJr1zx+8sWdH9JaaJcN8FqVaJCmQjB4EpmLvrQJF5sXrNcMG
	 /+AQpQuRIWeZdjFVhnU1XMNOYDvyDHI2qDuBpCMhSrQHUAOWWchzjeTyHOC5Yb6WHww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dgd9ce3M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC046606A31C;
	Thu, 19 Nov 2026 02:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dgd9ce3M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 493E71F000C4;
	Thu, 19 Nov 2026 02:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054294;
	bh=L26clyuEVrpDGOrKZDsQjJFuxtqOm63RzE0xqT9hmHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dgd9ce3MkYKagS3Wio/Wezg61ToG+ZVx6EoJa7LA2mbDBmjInnQ6FizGufNepGnhE
	 nDZt6kpY3btFBDvKvUDyNewyqsVlj7XkzcNzBeWAvWICNRlVlw10r9M7Ulu3YhPZsH
	 K+aRusEtTkhHpP/gBIXZjK4tasXrigjrXSWHh3nQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1224/2214] new helper: d_splice_alias_ops()
Date: Wed, 18 Nov 2026 15:48:20 +0100
Message-ID: <20261118150100.735781584@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ac8f2b6c95576..89e38520f66c4 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -2703,7 +2703,8 @@ EXPORT_SYMBOL(__d_lookup_done);
 
 /* inode->i_lock held if inode is non-NULL */
 
-static inline void __d_add(struct dentry *dentry, struct inode *inode)
+static inline void __d_add(struct dentry *dentry, struct inode *inode,
+			   const struct dentry_operations *ops)
 {
 	struct inode *dir = NULL;
 	unsigned n;
@@ -2713,6 +2714,8 @@ static inline void __d_add(struct dentry *dentry, struct inode *inode)
 		n = start_dir_add(dir);
 		__d_lookup_done(dentry);
 	}
+	if (unlikely(ops))
+		d_set_d_op(dentry, ops);
 	if (inode) {
 		unsigned add_flags = d_flags_for_inode(inode);
 		hlist_add_head(&dentry->d_u.d_alias, &inode->i_dentry);
@@ -2744,7 +2747,7 @@ void d_add(struct dentry *entry, struct inode *inode)
 		security_d_instantiate(entry, inode);
 		spin_lock(&inode->i_lock);
 	}
-	__d_add(entry, inode);
+	__d_add(entry, inode, NULL);
 }
 EXPORT_SYMBOL(d_add);
 
@@ -3039,30 +3042,8 @@ static int __d_unalias(struct inode *inode,
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
@@ -3108,9 +3089,37 @@ struct dentry *d_splice_alias(struct inode *inode, struct dentry *dentry)
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
index 9e23d33bb6f1c..06a80b9b3dc2b 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -242,6 +242,9 @@ extern struct dentry * d_alloc_anon(struct super_block *);
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



