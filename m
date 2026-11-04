Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831028;
	b=zI5w+PVXP7nS5DEZjxdVprP95K1+MjzxwWOsJ2kvzxI/YzXybqZ8ILxsC+0vvbQsGUQN
	 9BB0yy4eeTZntTxzRdYIPZ6YExQagQSHHmHFrxzCrnZW+lytGTJt2pBx32E8vGK4KebKr
	 RRoEDVV2v0Uh/tAvqKyM3N8aK7Gx0VAm8DoTrypnDsqPywiugvwb7C+vDX+Vw0VdKpxRk
	 rHHPizyl3f5Ejsf+adEcf65UejeZwMY5J6BYeDYl5Xzvca8wezHAR54zJybJqsDUNkY4j
	 YCt6E7japkz4q+Y37MCo2zen9RFVKwEw/1vLp4xly/gB3ci5q12xMR3/botCNweeqvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831028;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EWHsS+5PYPaDeiDo+kkunDqewkijZB0YJ63mL+CppXg=;
	b=t5syaWFQDmssz+CojOQI3d8l0fnu4qD6h417sor5JjBK4KiKBCbRE1ElewQbMNk07VGK
	 ehZ+PGuSXzi0lCXBH3ObSUgh2w4NeDkN/ug97YjhTsrtFNFCnyeC++48cA9YF6SG+7oAD
	 WnyGne3A0SGjsF4a3ZydXWmkvrVeCPJVPNorjNw1KOR86rqgr1pgKo6jWjJKv3u6vkCIk
	 Y/yZYawtn7ZcNuGZeFMisDXvsjyXgu+c7zCKT9W8SOFsW9lEOxqN/O1xN/7CssMa8Q/qH
	 xRj7fuEE2eny4g6OIU5IHxreHBds7hwqXIMVT+iNDCX76vsmh7aiBF+pL9vtZxNXjUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LyOYB6zT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F815606A843;
	Wed,  4 Nov 2026 22:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LyOYB6zT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03AEE1F000C1;
	Wed,  4 Nov 2026 22:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831028;
	bh=EWHsS+5PYPaDeiDo+kkunDqewkijZB0YJ63mL+CppXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LyOYB6zTAZcCKT9pcPfPEFmVi1PHMWn7B0IumFSsIc7YKJwCh8Q/fTwcLySNYLgeT
	 eo0ImXT+os1DAZKsFVL6LYQR0oL77TahM2BLK9pGsXVF7uWeAeY2MS9fHAV0rnyzQT
	 5HZesQCXxwXj+jebk6BNj8MpYPvPYFQXJ3/lPbqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Zhu <zhujia.zj@bytedance.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0427/1005] NFSv4: pin the superblock for active state owners
Date: Wed,  4 Nov 2026 16:02:40 -0500
Message-ID: <20261104211056.059800346@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Jia Zhu <zhujia.zj@bytedance.com>

[ Upstream commit 8cb1ce7aa0e8ac30e55f5bccfb80125f2e43e84a ]

NFSv4 open state can outlive the file and dentry that created it. This
was observed in production when NFSv4 state recovery, such as after a
server reboot or lease expiration, raced with unmount.

The race requires recovery to hold an open state reference while the last
open file is closed and the filesystem is unmounted, allowing the
superblock's active reference to drop to zero between
refcount_inc(&state->count) and nfs4_put_open_state():

    state manager                    umount

    nfs4_run_state_manager()
      nfs4_do_reclaim()
        nfs4_reclaim_open_state()
          refcount_inc(&state->count)
          ...
                                      close last file
                                      generic_shutdown_super()
                                        "Busy inodes after unmount"
                                      nfs_free_server()
          nfs4_put_open_state()
            iput(inode)
              evict()
                nfs_clear_inode()
                  nfs_zap_acl_cache()

The "VFS: Busy inodes after unmount" warning is the visible symptom of
that lifetime mismatch: superblock teardown proceeds even though the NFS
open state still pins an inode. After umount has freed the server, the
state manager can then run nfs4_put_open_state() for the last open-state
reference. The resulting iput(inode) can evict an NFS inode with freed
server data, causing crashes at nfs_zap_acl_cache(). This can be
reproduced by delaying the reclaim path before nfs4_put_open_state(),
then closing the last file and unmounting the NFS mount.

Pin the superblock while a state owner is active, and drop the pin when
the owner becomes idle again, so the NFS server stays alive until all
open state associated with the owner has been released.

Assisted-by: Codex:GPT-5
Signed-off-by: Jia Zhu <zhujia.zj@bytedance.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4state.c | 40 +++++++++++++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 7 deletions(-)

diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 01179f7de3225..6147d8c0ee111 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -403,6 +403,26 @@ const struct cred *nfs4_get_clid_cred(struct nfs_client *clp)
 	return cred;
 }
 
+static bool
+nfs4_get_state_owner_active_locked(struct nfs4_state_owner *sp)
+{
+	struct nfs_server *server = sp->so_server;
+
+	/*
+	 * A counted state owner may dereference so_server until the final
+	 * nfs4_put_state_owner().  Pin the superblock when reviving an idle
+	 * owner so umount cannot free the server underneath it.
+	 */
+	if (atomic_read(&sp->so_count) == 0) {
+		if (!nfs_sb_active(server->super))
+			return false;
+		if (!list_empty(&sp->so_lru))
+			list_del_init(&sp->so_lru);
+	}
+	atomic_inc(&sp->so_count);
+	return true;
+}
+
 static struct nfs4_state_owner *
 nfs4_find_state_owner_locked(struct nfs_server *server, const struct cred *cred)
 {
@@ -421,9 +441,8 @@ nfs4_find_state_owner_locked(struct nfs_server *server, const struct cred *cred)
 		else if (cmp > 0)
 			p = &parent->rb_right;
 		else {
-			if (!list_empty(&sp->so_lru))
-				list_del_init(&sp->so_lru);
-			atomic_inc(&sp->so_count);
+			if (!nfs4_get_state_owner_active_locked(sp))
+				return NULL;
 			return sp;
 		}
 	}
@@ -449,9 +468,8 @@ nfs4_insert_state_owner_locked(struct nfs4_state_owner *new)
 		else if (cmp > 0)
 			p = &parent->rb_right;
 		else {
-			if (!list_empty(&sp->so_lru))
-				list_del_init(&sp->so_lru);
-			atomic_inc(&sp->so_count);
+			if (!nfs4_get_state_owner_active_locked(sp))
+				return NULL;
 			return sp;
 		}
 	}
@@ -501,6 +519,10 @@ nfs4_alloc_state_owner(struct nfs_server *server,
 	sp = kzalloc(sizeof(*sp), gfp_flags);
 	if (!sp)
 		return NULL;
+	if (!nfs_sb_active(server->super)) {
+		kfree(sp);
+		return NULL;
+	}
 	sp->so_seqid.owner_id = atomic64_inc_return(&server->owner_ctr);
 	sp->so_server = server;
 	sp->so_cred = get_cred(cred);
@@ -586,8 +608,10 @@ struct nfs4_state_owner *nfs4_get_state_owner(struct nfs_server *server,
 	spin_lock(&clp->cl_lock);
 	sp = nfs4_insert_state_owner_locked(new);
 	spin_unlock(&clp->cl_lock);
-	if (sp != new)
+	if (sp != new) {
 		nfs4_free_state_owner(new);
+		nfs_sb_deactive(server->super);
+	}
 out:
 	nfs4_gc_state_owners(server);
 	return sp;
@@ -609,6 +633,7 @@ void nfs4_put_state_owner(struct nfs4_state_owner *sp)
 {
 	struct nfs_server *server = sp->so_server;
 	struct nfs_client *clp = server->nfs_client;
+	struct super_block *sb = server->super;
 
 	if (!atomic_dec_and_lock(&sp->so_count, &clp->cl_lock))
 		return;
@@ -616,6 +641,7 @@ void nfs4_put_state_owner(struct nfs4_state_owner *sp)
 	sp->so_expires = jiffies;
 	list_add_tail(&sp->so_lru, &server->state_owners_lru);
 	spin_unlock(&clp->cl_lock);
+	nfs_sb_deactive(sb);
 }
 
 /**
-- 
2.53.0



