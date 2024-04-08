Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358DB7E0F3;
	Mon,  8 Apr 2024 13:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583582; cv=none; b=lt2pU4rW1tL30aEuDCr0BF2mfiRZCsOCdLMzSGfv33RuCCfL6oFlKQd4vwjC2JAG8zFoVTq1O4tX4WOSuv8eskZn080gyPzqbeLcnA/wSFpYbBq2FTTUhIthu6JjNKTLhimLcKzH1SmUVFXgeHIZLQnddk67HiauFGOMBkIlVeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583582; c=relaxed/simple;
	bh=7DUDZ/gQwwW6v85VtnWc32v5xF7yhP/X6rC+yrtrtYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jm1P2q7nQuCFHOFKbM3qdXC358n6BOyoviReiPlpgMxUSldz4f/YlceV5pt3HZ9dZHkJ5GxTSCt6pAWYzeS6jAuUgY+fCL7QW+H4wKniyBUY2YPH2jvUoJymd5JbJgjStjjTca0qs9ixCc6Z8CBysio5lSyOC1080Xrr3WUuJ1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L7jPfRJ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L7jPfRJ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1614C433C7;
	Mon,  8 Apr 2024 13:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583582;
	bh=7DUDZ/gQwwW6v85VtnWc32v5xF7yhP/X6rC+yrtrtYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L7jPfRJ7gXlkvBcRyJaAv5+O43vnUkEawml22ZlyZQxACYeeLJAFQRe9oMT3oIf7P
	 bhKqzO/b0pl+0Dq5uvJQckl7REM1mDqZy/3FR7MZJorkSGb/Y5Kc5Zt9fknZuE8I+B
	 9/cITq03koVR+B+9odBED7uB0NItKkMsCHXfLBj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 262/690] NFSD: Rename boot verifier functions
Date: Mon,  8 Apr 2024 14:52:08 +0200
Message-ID: <20240408125409.119502765@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 3988a57885eeac05ef89f0ab4d7e47b52fbcf630 ]

Clean up: These functions handle what the specs call a write
verifier, which in the Linux NFS server implementation is now
divorced from the server's boot instance

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c |  2 +-
 fs/nfsd/netns.h     |  4 ++--
 fs/nfsd/nfs4proc.c  |  2 +-
 fs/nfsd/nfssvc.c    | 16 ++++++++--------
 fs/nfsd/vfs.c       | 16 ++++++++--------
 5 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index b99852b30308a..94157b82b60e1 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -237,7 +237,7 @@ nfsd_file_do_unhash(struct nfsd_file *nf)
 	trace_nfsd_file_unhash(nf);
 
 	if (nfsd_file_check_write_error(nf))
-		nfsd_reset_boot_verifier(net_generic(nf->nf_net, nfsd_net_id));
+		nfsd_reset_write_verifier(net_generic(nf->nf_net, nfsd_net_id));
 	--nfsd_file_hashtbl[nf->nf_hashval].nfb_count;
 	hlist_del_rcu(&nf->nf_node);
 	atomic_long_dec(&nfsd_filecache_count);
diff --git a/fs/nfsd/netns.h b/fs/nfsd/netns.h
index a6ed300259849..1b1a962a18041 100644
--- a/fs/nfsd/netns.h
+++ b/fs/nfsd/netns.h
@@ -198,6 +198,6 @@ extern void nfsd_netns_free_versions(struct nfsd_net *nn);
 
 extern unsigned int nfsd_net_id;
 
-void nfsd_copy_boot_verifier(__be32 verf[2], struct nfsd_net *nn);
-void nfsd_reset_boot_verifier(struct nfsd_net *nn);
+void nfsd_copy_write_verifier(__be32 verf[2], struct nfsd_net *nn);
+void nfsd_reset_write_verifier(struct nfsd_net *nn);
 #endif /* __NFSD_NETNS_H__ */
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 861af46ebc6cf..a8ad7e6ace927 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -598,7 +598,7 @@ static void gen_boot_verifier(nfs4_verifier *verifier, struct net *net)
 
 	BUILD_BUG_ON(2*sizeof(*verf) != sizeof(verifier->data));
 
-	nfsd_copy_boot_verifier(verf, net_generic(net, nfsd_net_id));
+	nfsd_copy_write_verifier(verf, net_generic(net, nfsd_net_id));
 }
 
 static __be32
diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 5a60664695352..2efe9d33a2827 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -346,14 +346,14 @@ static bool nfsd_needs_lockd(struct nfsd_net *nn)
 }
 
 /**
- * nfsd_copy_boot_verifier - Atomically copy a write verifier
+ * nfsd_copy_write_verifier - Atomically copy a write verifier
  * @verf: buffer in which to receive the verifier cookie
  * @nn: NFS net namespace
  *
  * This function provides a wait-free mechanism for copying the
- * namespace's boot verifier without tearing it.
+ * namespace's write verifier without tearing it.
  */
-void nfsd_copy_boot_verifier(__be32 verf[2], struct nfsd_net *nn)
+void nfsd_copy_write_verifier(__be32 verf[2], struct nfsd_net *nn)
 {
 	int seq = 0;
 
@@ -364,7 +364,7 @@ void nfsd_copy_boot_verifier(__be32 verf[2], struct nfsd_net *nn)
 	done_seqretry(&nn->writeverf_lock, seq);
 }
 
-static void nfsd_reset_boot_verifier_locked(struct nfsd_net *nn)
+static void nfsd_reset_write_verifier_locked(struct nfsd_net *nn)
 {
 	struct timespec64 now;
 	u64 verf;
@@ -379,7 +379,7 @@ static void nfsd_reset_boot_verifier_locked(struct nfsd_net *nn)
 }
 
 /**
- * nfsd_reset_boot_verifier - Generate a new boot verifier
+ * nfsd_reset_write_verifier - Generate a new write verifier
  * @nn: NFS net namespace
  *
  * This function updates the ->writeverf field of @nn. This field
@@ -391,10 +391,10 @@ static void nfsd_reset_boot_verifier_locked(struct nfsd_net *nn)
  * server and MUST be unique between instances of the NFSv4.1
  * server."
  */
-void nfsd_reset_boot_verifier(struct nfsd_net *nn)
+void nfsd_reset_write_verifier(struct nfsd_net *nn)
 {
 	write_seqlock(&nn->writeverf_lock);
-	nfsd_reset_boot_verifier_locked(nn);
+	nfsd_reset_write_verifier_locked(nn);
 	write_sequnlock(&nn->writeverf_lock);
 }
 
@@ -683,7 +683,7 @@ int nfsd_create_serv(struct net *net)
 		register_inet6addr_notifier(&nfsd_inet6addr_notifier);
 #endif
 	}
-	nfsd_reset_boot_verifier(nn);
+	nfsd_reset_write_verifier(nn);
 	return 0;
 }
 
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 721cf315551ad..d7035e3d1a229 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -565,8 +565,8 @@ __be32 nfsd4_clone_file_range(struct svc_rqst *rqstp,
 					&nfsd4_get_cstate(rqstp)->current_fh,
 					dst_pos,
 					count, status);
-			nfsd_reset_boot_verifier(net_generic(nf_dst->nf_net,
-						 nfsd_net_id));
+			nfsd_reset_write_verifier(net_generic(nf_dst->nf_net,
+						  nfsd_net_id));
 			ret = nfserrno(status);
 		}
 	}
@@ -1025,10 +1025,10 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct nfsd_file *nf,
 	iov_iter_kvec(&iter, WRITE, vec, vlen, *cnt);
 	since = READ_ONCE(file->f_wb_err);
 	if (verf)
-		nfsd_copy_boot_verifier(verf, nn);
+		nfsd_copy_write_verifier(verf, nn);
 	host_err = vfs_iter_write(file, &iter, &pos, flags);
 	if (host_err < 0) {
-		nfsd_reset_boot_verifier(nn);
+		nfsd_reset_write_verifier(nn);
 		goto out_nfserr;
 	}
 	*cnt = host_err;
@@ -1041,7 +1041,7 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct nfsd_file *nf,
 	if (stable && use_wgather) {
 		host_err = wait_for_concurrent_writes(file);
 		if (host_err < 0)
-			nfsd_reset_boot_verifier(nn);
+			nfsd_reset_write_verifier(nn);
 	}
 
 out_nfserr:
@@ -1173,7 +1173,7 @@ nfsd_commit(struct svc_rqst *rqstp, struct svc_fh *fhp, u64 offset,
 		err2 = vfs_fsync_range(nf->nf_file, start, end, 0);
 		switch (err2) {
 		case 0:
-			nfsd_copy_boot_verifier(verf, nn);
+			nfsd_copy_write_verifier(verf, nn);
 			err2 = filemap_check_wb_err(nf->nf_file->f_mapping,
 						    since);
 			err = nfserrno(err2);
@@ -1182,11 +1182,11 @@ nfsd_commit(struct svc_rqst *rqstp, struct svc_fh *fhp, u64 offset,
 			err = nfserr_notsupp;
 			break;
 		default:
-			nfsd_reset_boot_verifier(nn);
+			nfsd_reset_write_verifier(nn);
 			err = nfserrno(err2);
 		}
 	} else
-		nfsd_copy_boot_verifier(verf, nn);
+		nfsd_copy_write_verifier(verf, nn);
 
 	nfsd_file_put(nf);
 out:
-- 
2.43.0



