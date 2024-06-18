Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F63215FCED;
	Tue, 18 Jun 2024 12:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715068; cv=none; b=ILWfTiz4wF/ORi+neJ53ns7A2RfJi7UWtRrWw1oC9NYd6o6ziQLfNKxzC+2fiPf2ln2CyIwNQ/DDR2d97rnSp7yRcDNQpZDkbO7/qhn5g4TnyOwHqOvsbGzHiXtGI2prjXK19sE0oCuMVPbKuT00A5HiwwufQFg7K2y1moXu5V4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715068; c=relaxed/simple;
	bh=wKsXk61MPbtWF4Vdn0rKk4WqUEFF4v+FxYsE8iQRmkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uY2lryAi4LUHqYKfCi3+w9DM2vNyHN2CsdwDE15IK32uZRvmmq++YAlRmd5/sTDjF4JfrWcUrL45fl8kNzXGValrQE349GZ40mJ9wniD5dpSN/9DFUkBbKE1h4gTZPNJNQmSvMMXprpE4+5KOYIc/zIQO5RGEwqHGc43PAyjxMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=onZV1VJ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="onZV1VJ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36F9AC3277B;
	Tue, 18 Jun 2024 12:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715067;
	bh=wKsXk61MPbtWF4Vdn0rKk4WqUEFF4v+FxYsE8iQRmkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=onZV1VJ/vIj6nMS+ztJf2As9G0JLRTbbcjOAlVxNNZp9yefWH2fU/FxH6W/YLENs2
	 qthRZqlxcSs/rAWQsx5U8vC8HliaSG9WyLYRiofq+23+3BamvOLpu/VQ6gL9jzgOGO
	 LxQIvlXCA3HoQXBieRVifEbabXD5evfUFIJe9xOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 184/770] nfsd: remove unused set_client argument
Date: Tue, 18 Jun 2024 14:30:37 +0200
Message-ID: <20240618123414.377514005@linuxfoundation.org>
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

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit f71475ba8c2a77fff8051903cf4b7d826c3d1693 ]

Every caller is setting this argument to false, so we don't need it.

Also cut this comment a bit and remove an unnecessary warning.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index b05598e5bc168..cbec87ee6bc0e 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4690,8 +4690,7 @@ static struct nfs4_client *lookup_clientid(clientid_t *clid, bool sessions,
 
 static __be32 set_client(clientid_t *clid,
 		struct nfsd4_compound_state *cstate,
-		struct nfsd_net *nn,
-		bool sessions)
+		struct nfsd_net *nn)
 {
 	if (cstate->clp) {
 		if (!same_clid(&cstate->clp->cl_clientid, clid))
@@ -4701,12 +4700,10 @@ static __be32 set_client(clientid_t *clid,
 	if (STALE_CLIENTID(clid, nn))
 		return nfserr_stale_clientid;
 	/*
-	 * For v4.1+ we get the client in the SEQUENCE op. If we don't have one
-	 * cached already then we know this is for is for v4.0 and "sessions"
-	 * will be false.
+	 * We're in the 4.0 case (otherwise the SEQUENCE op would have
+	 * set cstate->clp), so session = false:
 	 */
-	WARN_ON_ONCE(cstate->session);
-	cstate->clp = lookup_clientid(clid, sessions, nn);
+	cstate->clp = lookup_clientid(clid, false, nn);
 	if (!cstate->clp)
 		return nfserr_expired;
 	return nfs_ok;
@@ -4730,7 +4727,7 @@ nfsd4_process_open1(struct nfsd4_compound_state *cstate,
 	if (open->op_file == NULL)
 		return nfserr_jukebox;
 
-	status = set_client(clientid, cstate, nn, false);
+	status = set_client(clientid, cstate, nn);
 	if (status)
 		return status;
 	clp = cstate->clp;
@@ -5320,7 +5317,7 @@ nfsd4_renew(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	struct nfsd_net *nn = net_generic(SVC_NET(rqstp), nfsd_net_id);
 
 	trace_nfsd_clid_renew(clid);
-	status = set_client(clid, cstate, nn, false);
+	status = set_client(clid, cstate, nn);
 	if (status)
 		return status;
 	clp = cstate->clp;
@@ -5701,7 +5698,7 @@ nfsd4_lookup_stateid(struct nfsd4_compound_state *cstate,
 	if (ZERO_STATEID(stateid) || ONE_STATEID(stateid) ||
 		CLOSE_STATEID(stateid))
 		return nfserr_bad_stateid;
-	status = set_client(&stateid->si_opaque.so_clid, cstate, nn, false);
+	status = set_client(&stateid->si_opaque.so_clid, cstate, nn);
 	if (status == nfserr_stale_clientid) {
 		if (cstate->session)
 			return nfserr_bad_stateid;
@@ -6938,7 +6935,7 @@ nfsd4_lockt(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		 return nfserr_inval;
 
 	if (!nfsd4_has_session(cstate)) {
-		status = set_client(&lockt->lt_clientid, cstate, nn, false);
+		status = set_client(&lockt->lt_clientid, cstate, nn);
 		if (status)
 			goto out;
 	}
@@ -7122,7 +7119,7 @@ nfsd4_release_lockowner(struct svc_rqst *rqstp,
 	dprintk("nfsd4_release_lockowner clientid: (%08x/%08x):\n",
 		clid->cl_boot, clid->cl_id);
 
-	status = set_client(clid, cstate, nn, false);
+	status = set_client(clid, cstate, nn);
 	if (status)
 		return status;
 
@@ -7262,7 +7259,7 @@ nfs4_check_open_reclaim(clientid_t *clid,
 	__be32 status;
 
 	/* find clientid in conf_id_hashtbl */
-	status = set_client(clid, cstate, nn, false);
+	status = set_client(clid, cstate, nn);
 	if (status)
 		return nfserr_reclaim_bad;
 
-- 
2.43.0



