Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA0F14F9E2;
	Tue, 18 Jun 2024 12:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715153; cv=none; b=YCXtHJAILRHyIJw4sizEoliV2wkRthmhQAJ0Ib6kfL6w4BKFQcL1/4rGKMk4KEuFDBZ6ZP8y2KUiQGIkqYdMYaFxGx6CAFiBsx7GmcJFdFupQISiSTsZqmPENgAKVlv9WgaiGQNb2ZR6G2fkSaDvZYoBBgrFKWSDWb3bhNZ3UJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715153; c=relaxed/simple;
	bh=02JtmGMiVLFP1ZWIHDpg8kSdysfTUf5yKwMxKmaw8ZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g6xUtKfkOMK/03xg0x8dm0jJ6H+MVbKmpixypYtyjqR1xapiAKrtbexlAizHw753WWNUReeOQvjeabUlwLiVaz6EZNvE7i/7Nx04to+J9Jd8RQComUAB3lgHMxrwztFsoEO0pAHggJLyhyJ7T5DdTECA6c5W2oD9hCZbrifw7W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XOiMl/l8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XOiMl/l8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F66C3277B;
	Tue, 18 Jun 2024 12:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715153;
	bh=02JtmGMiVLFP1ZWIHDpg8kSdysfTUf5yKwMxKmaw8ZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XOiMl/l8reLQC+p+DvrGgP+LLLq3URwkVHTi6uzjAByxHvaOwDmWCBX6OvWZh0mQz
	 +0CwLKlepDB/mY9d/Y9pitMeAB0IeQaC89HW4jkb4zXOFM2UOWaS6Sfe841pKKV91A
	 NngHgKC1vzhW/7g4QcuL9nk/toiderzWsGcG3Utk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 181/770] nfsd: rename lookup_clientid->set_client
Date: Tue, 18 Jun 2024 14:30:34 +0200
Message-ID: <20240618123414.259098586@linuxfoundation.org>
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

[ Upstream commit 460d27091ae2c23e7ac959a61cd481c58832db58 ]

I think this is a better name, and I'm going to reuse elsewhere the code
that does the lookup itself.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 574c88a9da268..60c66becbc876 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4675,7 +4675,7 @@ static __be32 nfsd4_check_seqid(struct nfsd4_compound_state *cstate, struct nfs4
 	return nfserr_bad_seqid;
 }
 
-static __be32 lookup_clientid(clientid_t *clid,
+static __be32 set_client(clientid_t *clid,
 		struct nfsd4_compound_state *cstate,
 		struct nfsd_net *nn,
 		bool sessions)
@@ -4730,7 +4730,7 @@ nfsd4_process_open1(struct nfsd4_compound_state *cstate,
 	if (open->op_file == NULL)
 		return nfserr_jukebox;
 
-	status = lookup_clientid(clientid, cstate, nn, false);
+	status = set_client(clientid, cstate, nn, false);
 	if (status)
 		return status;
 	clp = cstate->clp;
@@ -5320,7 +5320,7 @@ nfsd4_renew(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	struct nfsd_net *nn = net_generic(SVC_NET(rqstp), nfsd_net_id);
 
 	trace_nfsd_clid_renew(clid);
-	status = lookup_clientid(clid, cstate, nn, false);
+	status = set_client(clid, cstate, nn, false);
 	if (status)
 		return status;
 	clp = cstate->clp;
@@ -5701,8 +5701,7 @@ nfsd4_lookup_stateid(struct nfsd4_compound_state *cstate,
 	if (ZERO_STATEID(stateid) || ONE_STATEID(stateid) ||
 		CLOSE_STATEID(stateid))
 		return nfserr_bad_stateid;
-	status = lookup_clientid(&stateid->si_opaque.so_clid, cstate, nn,
-				 false);
+	status = set_client(&stateid->si_opaque.so_clid, cstate, nn, false);
 	if (status == nfserr_stale_clientid) {
 		if (cstate->session)
 			return nfserr_bad_stateid;
@@ -5841,7 +5840,7 @@ static __be32 find_cpntf_state(struct nfsd_net *nn, stateid_t *st,
 
 	cps->cpntf_time = ktime_get_boottime_seconds();
 	memset(&cstate, 0, sizeof(cstate));
-	status = lookup_clientid(&cps->cp_p_clid, &cstate, nn, true);
+	status = set_client(&cps->cp_p_clid, &cstate, nn, true);
 	if (status)
 		goto out;
 	status = nfsd4_lookup_stateid(&cstate, &cps->cp_p_stateid,
@@ -6933,8 +6932,7 @@ nfsd4_lockt(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		 return nfserr_inval;
 
 	if (!nfsd4_has_session(cstate)) {
-		status = lookup_clientid(&lockt->lt_clientid, cstate, nn,
-					 false);
+		status = set_client(&lockt->lt_clientid, cstate, nn, false);
 		if (status)
 			goto out;
 	}
@@ -7118,7 +7116,7 @@ nfsd4_release_lockowner(struct svc_rqst *rqstp,
 	dprintk("nfsd4_release_lockowner clientid: (%08x/%08x):\n",
 		clid->cl_boot, clid->cl_id);
 
-	status = lookup_clientid(clid, cstate, nn, false);
+	status = set_client(clid, cstate, nn, false);
 	if (status)
 		return status;
 
@@ -7258,7 +7256,7 @@ nfs4_check_open_reclaim(clientid_t *clid,
 	__be32 status;
 
 	/* find clientid in conf_id_hashtbl */
-	status = lookup_clientid(clid, cstate, nn, false);
+	status = set_client(clid, cstate, nn, false);
 	if (status)
 		return nfserr_reclaim_bad;
 
-- 
2.43.0



