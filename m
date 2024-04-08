Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C7D762E5;
	Mon,  8 Apr 2024 13:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584524; cv=none; b=gDd5YOX27ArgsxEnm4JogXzOhZR9jRu3OWJICvCtp/FAhwBX4Nrswt03P+kAsg/g8kFMwVjVaC3x5ZsyptpiGqTH5AybtyUVJMchn4+9Mz6g2qj5qBPkZvpbilzRNpoSjCDrniabGcBjByMpfNG2t5+YOFGAh3eQj8AjwrxXg8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584524; c=relaxed/simple;
	bh=J6GvcPSdzi61aqAp2fkea2n5gzYL9f9Rri1nZQKLMdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SwqOzLPSizchfYzYlqO4EUS3fl+Cgi3ZgnuC4yApuEjF0c2NZWPeovHt4eFCfN58oWAmH/1WRWNu27HpKgEdawyAzPTP27FdNZ4MAVsU4+yCo50mtGSuCRqNQt3CqbnrI0jUChQAlaXDm9V2sDSKG2WMBk4qN5YxnatkGPA4Ac8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rgdL8zR7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rgdL8zR7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F77C433C7;
	Mon,  8 Apr 2024 13:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584524;
	bh=J6GvcPSdzi61aqAp2fkea2n5gzYL9f9Rri1nZQKLMdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rgdL8zR7gD59EN2+xFhbk2mbNqsFsNYL/0asW25VIL1HdTZauMGnw/j+mtYMXm3js
	 pv2J/V5C4zHfzPjmoRFVbQDcVp+Noh7CyCaE3k2L2N4Mrtkw4xsUzkfhoMjK2+cw9T
	 3GMhR9+8zUeUxL6T89Whnw0qHjm7DQjlvOYH6F84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 450/690] NFSD: Rename the fields in copy_stateid_t
Date: Mon,  8 Apr 2024 14:55:16 +0200
Message-ID: <20240408125415.964245143@linuxfoundation.org>
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

[ Upstream commit 781fde1a2ba2391f31142f46f964cf1148ca1791 ]

Code maintenance: The name of the copy_stateid_t::sc_count field
collides with the sc_count field in struct nfs4_stid, making the
latter difficult to grep for when auditing stateid reference
counting.

No behavior change expected.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4proc.c  |  6 +++---
 fs/nfsd/nfs4state.c | 30 +++++++++++++++---------------
 fs/nfsd/state.h     |  6 +++---
 3 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index c8d299bc9e55a..59f675f194ebb 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1820,7 +1820,7 @@ nfsd4_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		if (!nfs4_init_copy_state(nn, copy))
 			goto out_err;
 		refcount_set(&async_copy->refcount, 1);
-		memcpy(&copy->cp_res.cb_stateid, &copy->cp_stateid.stid,
+		memcpy(&copy->cp_res.cb_stateid, &copy->cp_stateid.cs_stid,
 			sizeof(copy->cp_res.cb_stateid));
 		dup_copy_fields(copy, async_copy);
 		async_copy->copy_task = kthread_create(nfsd4_do_async_copy,
@@ -1858,7 +1858,7 @@ find_async_copy(struct nfs4_client *clp, stateid_t *stateid)
 
 	spin_lock(&clp->async_lock);
 	list_for_each_entry(copy, &clp->async_copies, copies) {
-		if (memcmp(&copy->cp_stateid.stid, stateid, NFS4_STATEID_SIZE))
+		if (memcmp(&copy->cp_stateid.cs_stid, stateid, NFS4_STATEID_SIZE))
 			continue;
 		refcount_inc(&copy->refcount);
 		spin_unlock(&clp->async_lock);
@@ -1912,7 +1912,7 @@ nfsd4_copy_notify(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	cps = nfs4_alloc_init_cpntf_state(nn, stid);
 	if (!cps)
 		goto out;
-	memcpy(&cn->cpn_cnr_stateid, &cps->cp_stateid.stid, sizeof(stateid_t));
+	memcpy(&cn->cpn_cnr_stateid, &cps->cp_stateid.cs_stid, sizeof(stateid_t));
 	memcpy(&cps->cp_p_stateid, &stid->sc_stateid, sizeof(stateid_t));
 	memcpy(&cps->cp_p_clid, &clp->cl_clientid, sizeof(clientid_t));
 
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index cc258f2988c73..f427f95ab934e 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -985,19 +985,19 @@ struct nfs4_stid *nfs4_alloc_stid(struct nfs4_client *cl, struct kmem_cache *sla
  * Create a unique stateid_t to represent each COPY.
  */
 static int nfs4_init_cp_state(struct nfsd_net *nn, copy_stateid_t *stid,
-			      unsigned char sc_type)
+			      unsigned char cs_type)
 {
 	int new_id;
 
-	stid->stid.si_opaque.so_clid.cl_boot = (u32)nn->boot_time;
-	stid->stid.si_opaque.so_clid.cl_id = nn->s2s_cp_cl_id;
-	stid->sc_type = sc_type;
+	stid->cs_stid.si_opaque.so_clid.cl_boot = (u32)nn->boot_time;
+	stid->cs_stid.si_opaque.so_clid.cl_id = nn->s2s_cp_cl_id;
+	stid->cs_type = cs_type;
 
 	idr_preload(GFP_KERNEL);
 	spin_lock(&nn->s2s_cp_lock);
 	new_id = idr_alloc_cyclic(&nn->s2s_cp_stateids, stid, 0, 0, GFP_NOWAIT);
-	stid->stid.si_opaque.so_id = new_id;
-	stid->stid.si_generation = 1;
+	stid->cs_stid.si_opaque.so_id = new_id;
+	stid->cs_stid.si_generation = 1;
 	spin_unlock(&nn->s2s_cp_lock);
 	idr_preload_end();
 	if (new_id < 0)
@@ -1019,7 +1019,7 @@ struct nfs4_cpntf_state *nfs4_alloc_init_cpntf_state(struct nfsd_net *nn,
 	if (!cps)
 		return NULL;
 	cps->cpntf_time = ktime_get_boottime_seconds();
-	refcount_set(&cps->cp_stateid.sc_count, 1);
+	refcount_set(&cps->cp_stateid.cs_count, 1);
 	if (!nfs4_init_cp_state(nn, &cps->cp_stateid, NFS4_COPYNOTIFY_STID))
 		goto out_free;
 	spin_lock(&nn->s2s_cp_lock);
@@ -1035,11 +1035,11 @@ void nfs4_free_copy_state(struct nfsd4_copy *copy)
 {
 	struct nfsd_net *nn;
 
-	WARN_ON_ONCE(copy->cp_stateid.sc_type != NFS4_COPY_STID);
+	WARN_ON_ONCE(copy->cp_stateid.cs_type != NFS4_COPY_STID);
 	nn = net_generic(copy->cp_clp->net, nfsd_net_id);
 	spin_lock(&nn->s2s_cp_lock);
 	idr_remove(&nn->s2s_cp_stateids,
-		   copy->cp_stateid.stid.si_opaque.so_id);
+		   copy->cp_stateid.cs_stid.si_opaque.so_id);
 	spin_unlock(&nn->s2s_cp_lock);
 }
 
@@ -6044,7 +6044,7 @@ nfs4_laundromat(struct nfsd_net *nn)
 	spin_lock(&nn->s2s_cp_lock);
 	idr_for_each_entry(&nn->s2s_cp_stateids, cps_t, i) {
 		cps = container_of(cps_t, struct nfs4_cpntf_state, cp_stateid);
-		if (cps->cp_stateid.sc_type == NFS4_COPYNOTIFY_STID &&
+		if (cps->cp_stateid.cs_type == NFS4_COPYNOTIFY_STID &&
 				state_expired(&lt, cps->cpntf_time))
 			_free_cpntf_state_locked(nn, cps);
 	}
@@ -6374,12 +6374,12 @@ nfs4_check_file(struct svc_rqst *rqstp, struct svc_fh *fhp, struct nfs4_stid *s,
 static void
 _free_cpntf_state_locked(struct nfsd_net *nn, struct nfs4_cpntf_state *cps)
 {
-	WARN_ON_ONCE(cps->cp_stateid.sc_type != NFS4_COPYNOTIFY_STID);
-	if (!refcount_dec_and_test(&cps->cp_stateid.sc_count))
+	WARN_ON_ONCE(cps->cp_stateid.cs_type != NFS4_COPYNOTIFY_STID);
+	if (!refcount_dec_and_test(&cps->cp_stateid.cs_count))
 		return;
 	list_del(&cps->cp_list);
 	idr_remove(&nn->s2s_cp_stateids,
-		   cps->cp_stateid.stid.si_opaque.so_id);
+		   cps->cp_stateid.cs_stid.si_opaque.so_id);
 	kfree(cps);
 }
 /*
@@ -6401,12 +6401,12 @@ __be32 manage_cpntf_state(struct nfsd_net *nn, stateid_t *st,
 	if (cps_t) {
 		state = container_of(cps_t, struct nfs4_cpntf_state,
 				     cp_stateid);
-		if (state->cp_stateid.sc_type != NFS4_COPYNOTIFY_STID) {
+		if (state->cp_stateid.cs_type != NFS4_COPYNOTIFY_STID) {
 			state = NULL;
 			goto unlock;
 		}
 		if (!clp)
-			refcount_inc(&state->cp_stateid.sc_count);
+			refcount_inc(&state->cp_stateid.cs_count);
 		else
 			_free_cpntf_state_locked(nn, state);
 	}
diff --git a/fs/nfsd/state.h b/fs/nfsd/state.h
index 4155be65d8069..b3477087a9fc3 100644
--- a/fs/nfsd/state.h
+++ b/fs/nfsd/state.h
@@ -57,11 +57,11 @@ typedef struct {
 } stateid_t;
 
 typedef struct {
-	stateid_t		stid;
+	stateid_t		cs_stid;
 #define NFS4_COPY_STID 1
 #define NFS4_COPYNOTIFY_STID 2
-	unsigned char		sc_type;
-	refcount_t		sc_count;
+	unsigned char		cs_type;
+	refcount_t		cs_count;
 } copy_stateid_t;
 
 struct nfsd4_callback {
-- 
2.43.0



