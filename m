Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019744;
	b=KRlleeiU8wdwSLAjx6q0aoICxs2M+MYDRX0AoP1HcAMA80Zk08n4pyNHdAun263UqooP
	 fOO7d1wj1HRcxvKa1ACGGUP02kqTAXwwC6pBVIVZ2otYgbCCC99w2DMEigArNC8W3A8v3
	 W9W8UNkENnSSOeZLLAb/K/KqXmLc4AfmdbSHvribkE5GNbp5OfCO0CnUkaoKomyCpkFF3
	 TTXSK6jD5/CSeIEsyCuHhFqfuxzhlm8D/BATuju/6KDeYb8jyuMqb/zL3gvSFeBaAKVkZ
	 dM+aS6acpBrl08dOhcNRYs3IUTLj/qndfT8gXYFzVXGuZX2LVVvVNXm0Y+PxnCaqWZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019744;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YzzxK2TI7qrdunpfoNvjquQsBim/1xSlea/9OsbA7cg=;
	b=1kCcdwMscfzDDfF5i2eeNwO4l5kODZkFjwLtnysDcZ701arTq66dsqgK9Z0BGhGVp7UO
	 UqHlvABKyuR0f0DScqzwhx3cCscaj7E2LD1PJacbZ8ClG/d7JzibtnGFcqxWz0Rhkvvdg
	 AC9oh3Kt0vQ+PCd2kPlWcHh447UAuIQAJb0oe9xN0N0lPU1ChKk1Oc6ZKMXwtowuJ2B2k
	 bIAdbFvpDx+ik8wVL44LKFNRkOejyH4rXM+nibM8xyeYQLe2XbwqIsOem5yAFolEdPbKM
	 Y/uOe5rcVX0nX2my8nUghv0Bn1fjdZ15UegUmJWaLVMLuJuGyJw3IELMpUOqx5q/ImQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xiQ8nvWg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A961606A331;
	Wed, 18 Nov 2026 16:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xiQ8nvWg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B4D1F000C4;
	Wed, 18 Nov 2026 16:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019744;
	bh=YzzxK2TI7qrdunpfoNvjquQsBim/1xSlea/9OsbA7cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xiQ8nvWg9VAa8idfVdEKQl6+ULhnJcNZGivh+GbO+kC4MrLZ8lNCsZEeemtqlBJoT
	 lLJT+CdrayZd0HOw+53bsx7YhjLqQCwlkprUxp2izIHG+2pO0ltBxcCyW96e1dC3mm
	 UEz6F9PS+MrmURW/tX3tGt4rWCDgwsmpSe6bJLQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Bergantinos Corpas <rbergant@redhat.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1665/2651] nfs: set gencount on protocol-specific remove
Date: Wed, 18 Nov 2026 15:48:25 +0100
Message-ID: <20261118150347.663705402@linuxfoundation.org>
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
index a26c459ffb041..71a342e9589f2 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1935,7 +1935,7 @@ static int nfs_dentry_delete(const struct dentry *dentry)
 }
 
 /* Ensure that we revalidate inode->i_nlink */
-static void nfs_drop_nlink(struct inode *inode, unsigned long gencount)
+void nfs_drop_nlink(struct inode *inode, unsigned long gencount)
 {
 	struct nfs_inode *nfsi = NFS_I(inode);
 
@@ -1949,6 +1949,7 @@ static void nfs_drop_nlink(struct inode *inode, unsigned long gencount)
 			       NFS_INO_INVALID_NLINK);
 	spin_unlock(&inode->i_lock);
 }
+EXPORT_SYMBOL_GPL(nfs_drop_nlink);
 
 /*
  * Called when the dentry loses inode.
@@ -2556,7 +2557,6 @@ EXPORT_SYMBOL_GPL(nfs_rmdir);
 static int nfs_safe_remove(struct dentry *dentry)
 {
 	struct inode *dir = d_inode(dentry->d_parent);
-	struct inode *inode = d_inode(dentry);
 	int error = -EBUSY;
 		
 	dfprintk(VFS, "NFS: safe_remove(%pd2)\n", dentry);
@@ -2568,14 +2568,7 @@ static int nfs_safe_remove(struct dentry *dentry)
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
index 18e19fe390719..5a1967f9e319e 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -394,6 +394,7 @@ extern unsigned long nfs_access_cache_count(struct shrinker *shrink,
 					    struct shrink_control *sc);
 extern unsigned long nfs_access_cache_scan(struct shrinker *shrink,
 					   struct shrink_control *sc);
+extern void nfs_drop_nlink(struct inode *inode, unsigned long gencount);
 struct dentry *nfs_lookup(struct inode *, struct dentry *, unsigned int);
 void nfs_d_prune_case_insensitive_aliases(struct inode *inode);
 int nfs_create(struct mnt_idmap *, struct inode *, struct dentry *,
diff --git a/fs/nfs/nfs3proc.c b/fs/nfs/nfs3proc.c
index b80d0c5efc279..b5aa3100b6270 100644
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
index e41c792a2725b..028459fb6edbf 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -4969,12 +4969,14 @@ static int nfs4_proc_remove(struct inode *dir, struct dentry *dentry)
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
@@ -4982,6 +4984,9 @@ static int nfs4_proc_remove(struct inode *dir, struct dentry *dentry)
 		err = nfs4_handle_exception(NFS_SERVER(dir), err,
 				&exception);
 	} while (exception.retry);
+
+	if (err == 0 && inode)
+		nfs_drop_nlink(inode, gencount);
 	return err;
 }
 
diff --git a/fs/nfs/proc.c b/fs/nfs/proc.c
index 03c2c1f31be9a..406d04b52a7df 100644
--- a/fs/nfs/proc.c
+++ b/fs/nfs/proc.c
@@ -323,9 +323,17 @@ nfs_proc_remove(struct inode *dir, struct dentry *dentry)
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



