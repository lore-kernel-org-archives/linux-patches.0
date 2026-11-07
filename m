Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061023;
	b=I19Plt/pICXpknCJtQT967qT/Y3HPtSlzFKkqbuQ6Lf+4k3v7lSzLzmMIIWOoOw0djyz
	 aKJG10xw8/UFlekjzwTmCIokpBvt/RQHPxX8m6kizUgjgvYVOc3gHyo1aBRfmG0K5JlY/
	 +bRR/T+Jxtwk0YGjNPbmrlaWMQewQV/fBnNBM31DAO2vegU+dlw95SqvJALi1m5A5hw6h
	 1TeY5r2PwIUz4RvRuaYPVnjtt7d8TqcZOjO+nFHTRthvLWdk6WXQHg2yIfxWai3Y+Y67U
	 MGS3T2eo0x96VU+HFvvBYtfqSyXL9pmlw+4/PwpJqBbzSjOsWQweifLvS2OucrqDkrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061023;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JYHj6IHKEyK1hcif95UQZyM8xpKoav8CnbBwKF7y9oY=;
	b=zxv/Lm2PX6KtqK1R0C+qeMQdmX7irs7q4SLZEuxxdt+asu3XERVrPSxNbhRSkKQ1BP1+
	 ga3UHhZTF3e3diZa31unrrtKclQWStZ74+E9tTkUt0a+YahgC0VrvOQoFmDL5UuwLv8p5
	 nuquIOz8A41ojaJE6+ziY6r55yELDURkokydBcDQoPF/yTUWmWbpnjIvUfMRM0sYH6/Lu
	 k8Onz6HAopprxrX+cJE8A4NftYtft3PhTu7NwzTKa4wu5X19ylPJy0EWj+wSoX8X1vxBe
	 k+13xn27C4glvQQJbj8EyytpPG7KRM+zYflm+biCn4AimsUIBnenpXKfowN2VwKEXNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KN05QSGK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98183606D83C;
	Sat,  7 Nov 2026 14:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KN05QSGK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411E81F008A3;
	Sat,  7 Nov 2026 14:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061023;
	bh=JYHj6IHKEyK1hcif95UQZyM8xpKoav8CnbBwKF7y9oY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KN05QSGKAcx0lwoV+dwTbDEhQ21eb5fpvUXWZDoYv8pUc5XmsNhwmLv7L1HxkrUg2
	 2wxL/prvMqVSFnEjnmHGlctinG7LlFawVys6VPbxtPdvlXw7m8mD53PhxOhwQ8FI3d
	 HRAUaZsDykXj0Ke/bd8sfzJrg+4kKGAjpB++hy6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia Zhu <zhujia.zj@bytedance.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0360/1536] NFSv4: pin the superblock for active state owners
Date: Sat,  7 Nov 2026 08:39:36 -0500
Message-ID: <20261107135007.770333020@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 946acdeaf85ad..4db400b9a0b44 100644
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



