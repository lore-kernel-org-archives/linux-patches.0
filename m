Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930A51AAE23;
	Tue, 18 Jun 2024 13:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716490; cv=none; b=K60KwJsbIPsh3e8/MjXm1PWXDQyec4+S8lFKlnnZcxGS+Nb30j2QLnbd6r/JjVl3NYgGfLj+pVQcRJavYoWMhCjUCbfN+Mr1eGD10pkYVJ7qnbLnfKghyxRivek9HmalfCj0Lmow83X2BVOV8bvJF5XfRghQjKyGayddzlY7B5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716490; c=relaxed/simple;
	bh=Hy4NWByc1oWmLhuJau0I3OFUppgALIPh9p0KNqAWeFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZSbTPY7OAHI+kLRGLSetnDt1J2b4W7VuTsCjEw0d+b//dze4l5iM07YGL6RzqOGwoa618RZePJ1sj5Lj0zJHa6qmPJHHC3rMGtgJnyZfejchWijRtKThB/l1fH33bXS2IDNOVXf85muOUYyOEiJI4ZH/5ldMF1Mb1FCYoFHu63M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OdK2swjL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OdK2swjL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34DDC3277B;
	Tue, 18 Jun 2024 13:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716490;
	bh=Hy4NWByc1oWmLhuJau0I3OFUppgALIPh9p0KNqAWeFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OdK2swjLhDm22lcGVl4OEp3YFL9f6IQ4Q0dLeO5QJYNEOhtwDrTR4u45JRqwTuWLj
	 dLEyX9FCDEDZQC4oT3nY4q9WnlCRN7cC3eysUXTfrTXmgDjd1YSLVzjZmnIXuaRQcv
	 FeNfWW8qoWiUOdWGy+K4sgvbD8U3Ojy/6RmRueVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 663/770] NFSD: Rename the fields in copy_stateid_t
Date: Tue, 18 Jun 2024 14:38:36 +0200
Message-ID: <20240618123432.877399133@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 781fde1a2ba2391f31142f46f964cf1148ca1791 ]

Code maintenance: The name of the copy_stateid_t::sc_count field
collides with the sc_count field in struct nfs4_stid, making the
latter difficult to grep for when auditing stateid reference
counting.

No behavior change expected.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c  |  6 +++---
 fs/nfsd/nfs4state.c | 30 +++++++++++++++---------------
 fs/nfsd/state.h     |  6 +++---
 3 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 1bb0fb917cf0d..e1aa48d496b98 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1818,7 +1818,7 @@ nfsd4_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		if (!nfs4_init_copy_state(nn, copy))
 			goto out_err;
 		refcount_set(&async_copy->refcount, 1);
-		memcpy(&copy->cp_res.cb_stateid, &copy->cp_stateid.stid,
+		memcpy(&copy->cp_res.cb_stateid, &copy->cp_stateid.cs_stid,
 			sizeof(copy->cp_res.cb_stateid));
 		dup_copy_fields(copy, async_copy);
 		async_copy->copy_task = kthread_create(nfsd4_do_async_copy,
@@ -1856,7 +1856,7 @@ find_async_copy(struct nfs4_client *clp, stateid_t *stateid)
 
 	spin_lock(&clp->async_lock);
 	list_for_each_entry(copy, &clp->async_copies, copies) {
-		if (memcmp(&copy->cp_stateid.stid, stateid, NFS4_STATEID_SIZE))
+		if (memcmp(&copy->cp_stateid.cs_stid, stateid, NFS4_STATEID_SIZE))
 			continue;
 		refcount_inc(&copy->refcount);
 		spin_unlock(&clp->async_lock);
@@ -1910,7 +1910,7 @@ nfsd4_copy_notify(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	cps = nfs4_alloc_init_cpntf_state(nn, stid);
 	if (!cps)
 		goto out;
-	memcpy(&cn->cpn_cnr_stateid, &cps->cp_stateid.stid, sizeof(stateid_t));
+	memcpy(&cn->cpn_cnr_stateid, &cps->cp_stateid.cs_stid, sizeof(stateid_t));
 	memcpy(&cps->cp_p_stateid, &stid->sc_stateid, sizeof(stateid_t));
 	memcpy(&cps->cp_p_clid, &clp->cl_clientid, sizeof(clientid_t));
 
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index fce62a4388a26..f207c73ae1b58 100644
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
@@ -6384,12 +6384,12 @@ nfs4_check_file(struct svc_rqst *rqstp, struct svc_fh *fhp, struct nfs4_stid *s,
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
@@ -6411,12 +6411,12 @@ __be32 manage_cpntf_state(struct nfsd_net *nn, stateid_t *st,
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



