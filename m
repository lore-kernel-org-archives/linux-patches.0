Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049519;
	b=fYrSgO6Aj50zaGU4WO7kX/K1a+tuhRQoQvWeEAPVLM1EXVEr+yzUPY6CXHagXylQWefQ
	 gAUoR32J0z3jBTel84EP/TmcDl2LcSkSQHGbXE/+KhlTUwve9hKXMkyIp9gqpc/PU06oS
	 5NSnHaM6csPZ68t31HIBikXckFcyi/6GGfFfXBYuvBlUl1mv1fytQ4vNq32MxbarKFUDE
	 0LhYfw5sLQtZ4iPca1EB7AOhPdMJ8jeCcbY6BXaooQnZPATcXwU41Qt50g3itOw/Rd/BI
	 sh5w/6yl+54GFYD5PHEowZEbvx7PRa3uN1qV8hsuFFj9nPsehr2GZ32Zw0jOL1JkvRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049519;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E11QsiPHdu7W19Q4PbscYLrIN756cncFoRuTKdg5bJo=;
	b=gPgs34cricVvrRuBruwl7NIHkxUXnnczLNzD4viM7rKjZNUW2aKSbkZn4+72/+jKMG99
	 VzvbnS9XZvV7S959b0JaRixqgKT7uWXlALztBgKAzxitr1NvpSOTeKnJkHO5u9Vz/nP3v
	 nZsqxBGSegOK21+HnoFfJ+87C/pifiWLmst5a4s9KfMymRHvPB1RJUmYmrT4xRr3fTEj0
	 19xHiN7ShvMnT0tMBusgI6TJ0xYjRtN7UDuD0jiC+arKIyBYgWWzf57UuYwJ1asO+eJBa
	 bxnuR4IFK2B0c98C/I0dLsJnYX0cEmYU2TYn1PGRoeghpT58QhKVBq1h/naDxwRiMTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VSYGvkCq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41392606A31C;
	Thu, 19 Nov 2026 00:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VSYGvkCq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C8B1F000C4;
	Thu, 19 Nov 2026 00:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049519;
	bh=E11QsiPHdu7W19Q4PbscYLrIN756cncFoRuTKdg5bJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VSYGvkCq6ptDGrqHe1RWIPOlvI2MjyayuqzO9DvmObB26iw9fcDXjkevC4EPV4PWT
	 gmDQFYgJKc57U9ZBKRfCKhSqLdN9K/Xi6i3bvVVhfi+Vb9+Bnal6GRrZVOADV2trIT
	 SG+gCa64fcmo+8UPpnUTrGTuBMYq7AyVZUIVCCVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Bergantinos Corpas <rbergant@redhat.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2380/2857] nfs: set gencount on protocol-specific remove
Date: Wed, 18 Nov 2026 15:56:54 +0100
Message-ID: <20261118150327.221580170@linuxfoundation.org>
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
index a5344ddc00a02..be793e10da830 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1892,7 +1892,7 @@ static int nfs_dentry_delete(const struct dentry *dentry)
 }
 
 /* Ensure that we revalidate inode->i_nlink */
-static void nfs_drop_nlink(struct inode *inode, unsigned long gencount)
+void nfs_drop_nlink(struct inode *inode, unsigned long gencount)
 {
 	struct nfs_inode *nfsi = NFS_I(inode);
 
@@ -1906,6 +1906,7 @@ static void nfs_drop_nlink(struct inode *inode, unsigned long gencount)
 			       NFS_INO_INVALID_NLINK);
 	spin_unlock(&inode->i_lock);
 }
+EXPORT_SYMBOL_GPL(nfs_drop_nlink);
 
 /*
  * Called when the dentry loses inode.
@@ -2457,7 +2458,6 @@ EXPORT_SYMBOL_GPL(nfs_rmdir);
 static int nfs_safe_remove(struct dentry *dentry)
 {
 	struct inode *dir = d_inode(dentry->d_parent);
-	struct inode *inode = d_inode(dentry);
 	int error = -EBUSY;
 		
 	dfprintk(VFS, "NFS: safe_remove(%pd2)\n", dentry);
@@ -2469,14 +2469,7 @@ static int nfs_safe_remove(struct dentry *dentry)
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
index d010999801a8f..87f16510777ec 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -382,6 +382,7 @@ extern unsigned long nfs_access_cache_count(struct shrinker *shrink,
 					    struct shrink_control *sc);
 extern unsigned long nfs_access_cache_scan(struct shrinker *shrink,
 					   struct shrink_control *sc);
+extern void nfs_drop_nlink(struct inode *inode, unsigned long gencount);
 struct dentry *nfs_lookup(struct inode *, struct dentry *, unsigned int);
 void nfs_d_prune_case_insensitive_aliases(struct inode *inode);
 int nfs_create(struct user_namespace *, struct inode *, struct dentry *,
diff --git a/fs/nfs/nfs3proc.c b/fs/nfs/nfs3proc.c
index f036d30f7515c..637db30868443 100644
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
index 58d189601dac1..e63a5b688fb08 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -4805,12 +4805,14 @@ static int nfs4_proc_remove(struct inode *dir, struct dentry *dentry)
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
@@ -4818,6 +4820,9 @@ static int nfs4_proc_remove(struct inode *dir, struct dentry *dentry)
 		err = nfs4_handle_exception(NFS_SERVER(dir), err,
 				&exception);
 	} while (exception.retry);
+
+	if (err == 0 && inode)
+		nfs_drop_nlink(inode, gencount);
 	return err;
 }
 
diff --git a/fs/nfs/proc.c b/fs/nfs/proc.c
index e3570c656b0f9..80d5d4337877c 100644
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



