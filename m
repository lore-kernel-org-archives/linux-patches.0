Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031504;
	b=t6VPtXJQT/DdtOPZ7Dh8MMUlcG6E/v34bg/Odclze9lp1wbCbiVSii4/WF3o+Orpgtl6
	 uY5nHv8nnNV6oJd6WAsBFHvkMO+F34snzuUTL0HvHqNuhD8FmwbqX6jy5xn0wPIKpjLji
	 OjIISdM7TdnHUi5nUw2dk4zWu9yclcHyuMjAtJPSP+kJz8exNX0pGuRCtp3gYv6lxz4Yk
	 iF2ScAdvhnf21KJLYc8oeWSuf4mBvr6iTiVm1TjpH+nZSdUCvj6uosQnVxSv4uDwG21BO
	 6UP/2JKFwYWmu0MvNxnUenUYlIpTXP1CbVsmIqyng3ovRlyW0CKtZ7WoCLW/JfMm9wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031504;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9vvsntkVzCzplSBHEzSnLYNiBWpYzevp6KoOeo7bxVo=;
	b=WiDeoTtfJmaOr8sKFK8WVwnOcwtIO6svOGbPAWU0QdzFy7AUrjr+q0zDnlZelSiVzli8
	 Jz1wF2ZW11oh6tFwbhypZeggxV19btrYDhvYZqYg8FOmQSxExvW1emc7uKIW95cTPsWVX
	 Kvd8WJnGxa/bufAmTdRw8i+kCIZsPVlU7MCSoQkM5fYQ83LpWy8w5W70s5XUmbKJns9fb
	 Mg4LJOaguKBG4xhKow9iGp7oThqOS9+VZfAmt3cqDKD9f9JiZrJQcNY18QbCKU6TljZ0I
	 ff9q0Nc9MDMmoWWAyDl9X9p4iXhTeyXz7zo53hKCqsbr8MO48WCCHIzTiWslgFcjxZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OebDzYXO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E400606A320;
	Wed, 18 Nov 2026 19:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OebDzYXO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC0D1F000C4;
	Wed, 18 Nov 2026 19:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031504;
	bh=9vvsntkVzCzplSBHEzSnLYNiBWpYzevp6KoOeo7bxVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OebDzYXO3rv8Z8v8e/vyXcPAq63bY5BXvJ5Xx5rm0riKSeDx0WMZ5AAEy1ZTYmlrQ
	 flZ5DDeucuVVIAlETUA1G44d+CmW1ajZmd9je1dhtjVpHlPRcTJcD+SNDkYAtjLMP+
	 8XoytQlbKGNiU9FXHji+DqEUn4TBWqOrilrIoYCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Bergantinos Corpas <rbergant@redhat.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1082/1756] nfs: set gencount on protocol-specific remove
Date: Wed, 18 Nov 2026 15:53:29 +0100
Message-ID: <20261118150053.284053616@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roberto Bergantinos Corpas <rbergant@redhat.com>

[ Upstream commit 8c955dacf45f8964b98f26910ffecb5e26c02e31 ]

commit bd4928ec799b ("NFS: Avoid changing nlink when file removes and
attribute updates race") avoids races on attribute cache with any
inflight RPC that may modify inode attributes (and gencount) during
i.e. REMOVE.

However it does not take into account that REMOVE may trigger
a delegation return which also advances gencount (via the attribute
refresh during delegation return), and in that case the gencount
mismatch is not due to an inflight RPC that already reflected the
removal.

Push the setting of gencount under each version-specific layer,
reordering correctly for nfsv4 case after the delegation returns.

This fixes LTP/inotify04 failure after bd4928ec799b.

Fixes: bd4928ec799b ("NFS: Avoid changing nlink when file removes and attribute updates race")
Signed-off-by: Roberto Bergantinos Corpas <rbergant@redhat.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/dir.c      | 13 +++----------
 fs/nfs/internal.h |  1 +
 fs/nfs/nfs3proc.c |  8 ++++++++
 fs/nfs/nfs4proc.c |  5 +++++
 fs/nfs/proc.c     |  8 ++++++++
 5 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 0356b80e4a357..3b07cda9a8f43 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1904,7 +1904,7 @@ static int nfs_dentry_delete(const struct dentry *dentry)
 }
 
 /* Ensure that we revalidate inode->i_nlink */
-static void nfs_drop_nlink(struct inode *inode, unsigned long gencount)
+void nfs_drop_nlink(struct inode *inode, unsigned long gencount)
 {
 	struct nfs_inode *nfsi = NFS_I(inode);
 
@@ -1918,6 +1918,7 @@ static void nfs_drop_nlink(struct inode *inode, unsigned long gencount)
 			       NFS_INO_INVALID_NLINK);
 	spin_unlock(&inode->i_lock);
 }
+EXPORT_SYMBOL_GPL(nfs_drop_nlink);
 
 /*
  * Called when the dentry loses inode.
@@ -2522,7 +2523,6 @@ EXPORT_SYMBOL_GPL(nfs_rmdir);
 static int nfs_safe_remove(struct dentry *dentry)
 {
 	struct inode *dir = d_inode(dentry->d_parent);
-	struct inode *inode = d_inode(dentry);
 	int error = -EBUSY;
 		
 	dfprintk(VFS, "NFS: safe_remove(%pd2)\n", dentry);
@@ -2534,14 +2534,7 @@ static int nfs_safe_remove(struct dentry *dentry)
 	}
 
 	trace_nfs_remove_enter(dir, dentry);
-	if (inode != NULL) {
-		unsigned long gencount = READ_ONCE(NFS_I(inode)->attr_gencount);
-
-		error = NFS_PROTO(dir)->remove(dir, dentry);
-		if (error == 0)
-			nfs_drop_nlink(inode, gencount);
-	} else
-		error = NFS_PROTO(dir)->remove(dir, dentry);
+	error = NFS_PROTO(dir)->remove(dir, dentry);
 	if (error == -ENOENT)
 		nfs_dentry_handle_enoent(dentry);
 	trace_nfs_remove_exit(dir, dentry, error);
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index da7087c80ceab..ea0524be7c743 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -396,6 +396,7 @@ extern unsigned long nfs_access_cache_count(struct shrinker *shrink,
 					    struct shrink_control *sc);
 extern unsigned long nfs_access_cache_scan(struct shrinker *shrink,
 					   struct shrink_control *sc);
+extern void nfs_drop_nlink(struct inode *inode, unsigned long gencount);
 struct dentry *nfs_lookup(struct inode *, struct dentry *, unsigned int);
 void nfs_d_prune_case_insensitive_aliases(struct inode *inode);
 int nfs_create(struct mnt_idmap *, struct inode *, struct dentry *,
diff --git a/fs/nfs/nfs3proc.c b/fs/nfs/nfs3proc.c
index b02ea9fc812da..c7be4fe0e0f15 100644
--- a/fs/nfs/nfs3proc.c
+++ b/fs/nfs/nfs3proc.c
@@ -448,13 +448,21 @@ nfs3_proc_remove(struct inode *dir, struct dentry *dentry)
 		.rpc_resp = &res,
 	};
 	int status = -ENOMEM;
+	struct inode *inode = d_inode(dentry);
+	unsigned long gencount;
 
 	dprintk("NFS call  remove %pd2\n", dentry);
 	res.dir_attr = nfs_alloc_fattr();
 	if (res.dir_attr == NULL)
 		goto out;
 
+	if (inode)
+		gencount = READ_ONCE(NFS_I(inode)->attr_gencount);
+
 	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0);
+	if (status == 0 && inode)
+		nfs_drop_nlink(inode, gencount);
+
 	nfs_post_op_update_inode(dir, res.dir_attr);
 	nfs_free_fattr(res.dir_attr);
 out:
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 760171dead8ef..cc14a62a23d74 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -4915,12 +4915,14 @@ static int nfs4_proc_remove(struct inode *dir, struct dentry *dentry)
 	};
 	struct inode *inode = d_inode(dentry);
 	int err;
+	unsigned long gencount;
 
 	if (inode) {
 		if (inode->i_nlink == 1)
 			nfs4_inode_return_delegation(inode);
 		else
 			nfs4_inode_make_writeable(inode);
+		gencount = READ_ONCE(NFS_I(inode)->attr_gencount);
 	}
 	do {
 		err = _nfs4_proc_remove(dir, &dentry->d_name, NF4REG);
@@ -4928,6 +4930,9 @@ static int nfs4_proc_remove(struct inode *dir, struct dentry *dentry)
 		err = nfs4_handle_exception(NFS_SERVER(dir), err,
 				&exception);
 	} while (exception.retry);
+
+	if (err == 0 && inode)
+		nfs_drop_nlink(inode, gencount);
 	return err;
 }
 
diff --git a/fs/nfs/proc.c b/fs/nfs/proc.c
index 6c09cd090c34c..81173f90aa1d8 100644
--- a/fs/nfs/proc.c
+++ b/fs/nfs/proc.c
@@ -322,9 +322,17 @@ nfs_proc_remove(struct inode *dir, struct dentry *dentry)
 		.rpc_argp = &arg,
 	};
 	int			status;
+	struct inode *inode = d_inode(dentry);
+	unsigned long gencount;
 
 	dprintk("NFS call  remove %pd2\n",dentry);
+	if (inode)
+		gencount = READ_ONCE(NFS_I(inode)->attr_gencount);
+
 	status = rpc_call_sync(NFS_CLIENT(dir), &msg, 0);
+	if (status == 0 && inode)
+		nfs_drop_nlink(inode, gencount);
+
 	nfs_mark_for_revalidate(dir);
 
 	dprintk("NFS reply remove: %d\n", status);
-- 
2.53.0



