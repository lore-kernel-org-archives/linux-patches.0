Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40435400981;
	Thu, 16 Jul 2026 14:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211631; cv=none; b=tfUiASmUvx6t/QMW12TBdrk70yEs+8Vf23rpbauRxUsTYAZ6wAMPsT6sKfwx8wSeemYO+FNQzY3oZ0wzaT6BkrrZRWfciXJC8/HAuXgqVcm+8m/jb96KdoTlsgFxZLQ1r9qk75n84l3fUyOBFp74mCfBv97EDD0M4RzB9OHo9do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211631; c=relaxed/simple;
	bh=C+EUy9L8OBqoFzXYa9depN28zM2EalMkuWYvqBf7qHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M94RB9hCAsHH9Em7NqoZVsIc2hGPVwGbBpwuvckqGowDX+cnJbR/hftkzF2VRk/PomMJYYH2xTuKH4s//eOzN+WyaO/NtYeZYaNa7RmcDlsev3gocsXQLa8wshRGzQGF/HvcXqm6r0tqqFvl/mb+Xq2VzfpyI3oR67RgPBZYB4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1taYS9ce; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1taYS9ce"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4DF51F000E9;
	Thu, 16 Jul 2026 14:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211630;
	bh=He7Dmfgv6aWqSGSVn21cM9rWF7SlTrkKGh+bPNDuHYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1taYS9cej0dFkp85Ey9x/P5Vf7ojlDyzv8KLgJ+NknioS2nq0iM1j4/Lxq5EDmYsb
	 vqiMX9hz/e8WWXEo6FniwWyd/aELKlnUKpjeA3zr47oTimTTArBJYCDPXfXXFEhtOp
	 i8MZPgMHzV8bJMYx7NmUEfsUN3uv28YGvP5b2UrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	NeilBrown <neilb@suse.de>,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 021/349] nfs_common: rename functions that invalidate LOCALIO nfs_clients
Date: Thu, 16 Jul 2026 15:29:15 +0200
Message-ID: <20260716133033.773622468@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@kernel.org>

[ Upstream commit b49f049a22227df701bfbca083d6cc859496e615 ]

Rename nfs_uuid_invalidate_one_client to nfs_localio_disable_client.
Rename nfs_uuid_invalidate_clients to nfs_localio_invalidate_clients.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Reviewed-by: NeilBrown <neilb@suse.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Stable-dep-of: 2c6bb3c40bc2 ("NFSv4/flexfiles: reject zero filehandle version count")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/localio.c           |    2 +-
 fs/nfs_common/nfslocalio.c |    8 ++++----
 fs/nfsd/nfsctl.c           |    4 ++--
 include/linux/nfslocalio.h |    5 +++--
 4 files changed, 10 insertions(+), 9 deletions(-)

--- a/fs/nfs/localio.c
+++ b/fs/nfs/localio.c
@@ -141,7 +141,7 @@ void nfs_local_disable(struct nfs_client
 	spin_lock(&clp->cl_localio_lock);
 	if (test_and_clear_bit(NFS_CS_LOCAL_IO, &clp->cl_flags)) {
 		trace_nfs_local_disable(clp);
-		nfs_uuid_invalidate_one_client(&clp->cl_uuid);
+		nfs_localio_disable_client(&clp->cl_uuid);
 	}
 	spin_unlock(&clp->cl_localio_lock);
 }
--- a/fs/nfs_common/nfslocalio.c
+++ b/fs/nfs_common/nfslocalio.c
@@ -107,7 +107,7 @@ static void nfs_uuid_put_locked(nfs_uuid
 	list_del_init(&nfs_uuid->list);
 }
 
-void nfs_uuid_invalidate_clients(struct list_head *list)
+void nfs_localio_invalidate_clients(struct list_head *list)
 {
 	nfs_uuid_t *nfs_uuid, *tmp;
 
@@ -116,9 +116,9 @@ void nfs_uuid_invalidate_clients(struct
 		nfs_uuid_put_locked(nfs_uuid);
 	spin_unlock(&nfs_uuid_lock);
 }
-EXPORT_SYMBOL_GPL(nfs_uuid_invalidate_clients);
+EXPORT_SYMBOL_GPL(nfs_localio_invalidate_clients);
 
-void nfs_uuid_invalidate_one_client(nfs_uuid_t *nfs_uuid)
+void nfs_localio_disable_client(nfs_uuid_t *nfs_uuid)
 {
 	if (nfs_uuid->net) {
 		spin_lock(&nfs_uuid_lock);
@@ -126,7 +126,7 @@ void nfs_uuid_invalidate_one_client(nfs_
 		spin_unlock(&nfs_uuid_lock);
 	}
 }
-EXPORT_SYMBOL_GPL(nfs_uuid_invalidate_one_client);
+EXPORT_SYMBOL_GPL(nfs_localio_disable_client);
 
 /*
  * Caller is responsible for calling nfsd_net_put and
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -2296,14 +2296,14 @@ out_export_error:
  * nfsd_net_pre_exit - Disconnect localio clients from net namespace
  * @net: a network namespace that is about to be destroyed
  *
- * This invalidated ->net pointers held by localio clients
+ * This invalidates ->net pointers held by localio clients
  * while they can still safely access nn->counter.
  */
 static __net_exit void nfsd_net_pre_exit(struct net *net)
 {
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
 
-	nfs_uuid_invalidate_clients(&nn->local_clients);
+	nfs_localio_invalidate_clients(&nn->local_clients);
 }
 #endif
 
--- a/include/linux/nfslocalio.h
+++ b/include/linux/nfslocalio.h
@@ -37,8 +37,9 @@ bool nfs_uuid_begin(nfs_uuid_t *);
 void nfs_uuid_end(nfs_uuid_t *);
 void nfs_uuid_is_local(const uuid_t *, struct list_head *,
 		       struct net *, struct auth_domain *, struct module *);
-void nfs_uuid_invalidate_clients(struct list_head *list);
-void nfs_uuid_invalidate_one_client(nfs_uuid_t *nfs_uuid);
+
+void nfs_localio_disable_client(nfs_uuid_t *nfs_uuid);
+void nfs_localio_invalidate_clients(struct list_head *list);
 
 /* localio needs to map filehandle -> struct nfsd_file */
 extern struct nfsd_file *


