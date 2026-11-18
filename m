Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056062;
	b=wPjDsWgPN/GXTk9zNRu8O+es6i25SE7IB82oKyGbSlxwwbi+hRXPUcYIsyLqZQC9cCAO
	 6nWi3gNieIfgqnw5VnHTTj0HHgHmcUEoXQX/yimgH3YZdj2gz/26aiAh3PzLAlWQ6WuNj
	 JRgW5+Pth8EIRozo6QoWFtzqYwbtQwvYIV0rN2NA84fntUy7Qc1h3lRgMafA3KFfF/YFc
	 N/IBEDOzpuBhiDK2yqG85NemwoKp2EZTumn+4H/icHpvagzxfZL73zR2TdAq1trRG/wlO
	 elooIkQBaUV9REJGEtKY1mpIFT/6xWfOUJt+JsCAJosM7DKTBW0i8BphgETWcBZbrbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056062;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rvb+/U9D6fTgHxwHDubfKT/xCq29mk5pEBa+8bv5q2M=;
	b=1cyf8iXSzcHFwyAPtWRBlMDpURe2Tws2LVud0FeaRHW6XQjUtXGmtkcMVGWZxM0Wk8d+
	 blS7ZnwRN+zkI06ekR/a78iCIxBuOFm2AJQEIusW1WOUWqmR4hDQByVr6xuG/g/XtE3Va
	 5DOEISnHizQeV7heXucbGC8BfX4T6OGFg3cIcal2rEi1F5YBXaEU0KbSuYLkwDDugEP1h
	 JHfjcoFylEYFn0BFwzr/i0J1dd7cRwYui2Vw3xn8j3GvxMUbYsWet93spaUDxxTgeuf3c
	 ZOKOjaIvgrzs+kdLpdrleLgdYhhBeGIqMQKPfcmauMTV037hH6JOWcpkAeYp1wzAHZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LJabvxFV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00DC606A33A;
	Thu, 19 Nov 2026 02:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LJabvxFV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C00F1F000CA;
	Thu, 19 Nov 2026 02:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056062;
	bh=rvb+/U9D6fTgHxwHDubfKT/xCq29mk5pEBa+8bv5q2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LJabvxFVWjqc+0j+vvktknwTxLx3/I0gfbVxQIcfBi6zkhG1HY2bLIAPbVGtf+N5Q
	 ToSMQe9ujsXv2KEPugrjA47/NGvQ0XieefomQnKFNnQmhysLnuKPaaicB2B0nRc1JL
	 dfXAA8qGkS3qLOrLC93UAhD8fAaBvdVQlxmW4n6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Bergantinos Corpas <rbergant@redhat.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1852/2214] nfs: set gencount on protocol-specific remove
Date: Wed, 18 Nov 2026 15:58:48 +0100
Message-ID: <20261118150125.463089249@linuxfoundation.org>
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
index dd0b7488e9ccb..09060c4a64eee 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1738,7 +1738,7 @@ static int nfs_dentry_delete(const struct dentry *dentry)
 }
 
 /* Ensure that we revalidate inode->i_nlink */
-static void nfs_drop_nlink(struct inode *inode, unsigned long gencount)
+void nfs_drop_nlink(struct inode *inode, unsigned long gencount)
 {
 	struct nfs_inode *nfsi = NFS_I(inode);
 
@@ -1752,6 +1752,7 @@ static void nfs_drop_nlink(struct inode *inode, unsigned long gencount)
 			       NFS_INO_INVALID_NLINK);
 	spin_unlock(&inode->i_lock);
 }
+EXPORT_SYMBOL_GPL(nfs_drop_nlink);
 
 /*
  * Called when the dentry loses inode.
@@ -2301,7 +2302,6 @@ EXPORT_SYMBOL_GPL(nfs_rmdir);
 static int nfs_safe_remove(struct dentry *dentry)
 {
 	struct inode *dir = d_inode(dentry->d_parent);
-	struct inode *inode = d_inode(dentry);
 	int error = -EBUSY;
 		
 	dfprintk(VFS, "NFS: safe_remove(%pd2)\n", dentry);
@@ -2313,14 +2313,7 @@ static int nfs_safe_remove(struct dentry *dentry)
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
index cb3e126f1c2b7..8cdb4d9967e69 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -383,6 +383,7 @@ extern unsigned long nfs_access_cache_count(struct shrinker *shrink,
 					    struct shrink_control *sc);
 extern unsigned long nfs_access_cache_scan(struct shrinker *shrink,
 					   struct shrink_control *sc);
+extern void nfs_drop_nlink(struct inode *inode, unsigned long gencount);
 struct dentry *nfs_lookup(struct inode *, struct dentry *, unsigned int);
 int nfs_create(struct user_namespace *, struct inode *, struct dentry *,
 	       umode_t, bool);
diff --git a/fs/nfs/nfs3proc.c b/fs/nfs/nfs3proc.c
index f7524310ddf4b..32d2dca738bff 100644
--- a/fs/nfs/nfs3proc.c
+++ b/fs/nfs/nfs3proc.c
@@ -443,13 +443,21 @@ nfs3_proc_remove(struct inode *dir, struct dentry *dentry)
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
index 750e125576a4c..69c389d28b81e 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -4758,12 +4758,14 @@ static int nfs4_proc_remove(struct inode *dir, struct dentry *dentry)
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
@@ -4771,6 +4773,9 @@ static int nfs4_proc_remove(struct inode *dir, struct dentry *dentry)
 		err = nfs4_handle_exception(NFS_SERVER(dir), err,
 				&exception);
 	} while (exception.retry);
+
+	if (err == 0 && inode)
+		nfs_drop_nlink(inode, gencount);
 	return err;
 }
 
diff --git a/fs/nfs/proc.c b/fs/nfs/proc.c
index a5b0bdcb53963..3bff1cec8d010 100644
--- a/fs/nfs/proc.c
+++ b/fs/nfs/proc.c
@@ -324,9 +324,17 @@ nfs_proc_remove(struct inode *dir, struct dentry *dentry)
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



