Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7DD158D79;
	Tue, 18 Jun 2024 13:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716308; cv=none; b=qB/naMtj0A5sRdCwWAf7dWax7JJC39VUblBzzolhFheEH9Xx9ITlodZHedf/qLZwkZGmy0tlphBbqZC2vJlGPkenDKe4gQwahzebjMI0yssUi+Mz8AIzXAGzIyYF3+AsWmoCwEqmFHl26abQKNK2E2+Me8spRy8fhDzntSjgBkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716308; c=relaxed/simple;
	bh=doJPyst/ofUPVvaw7EdcKCivBrHsiqPGxxa8ERoKh/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ciy3AWji0R6yU0/9GiyHz8wuvhDCyvQ2v1ciiCpSMKf35aqo8RaoiDXJ5Raflr0pLgnpF6waD3diiWIzcYxPg05Lki9B1WPdEZRz4NUGA5CtPcfl2UBvCgEUlnCfelM1ydx6LIo2o2KAKNNu4LaVrZ1Dao4j+elu64zvSadrokU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YuaBT9AF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YuaBT9AF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D2FC3277B;
	Tue, 18 Jun 2024 13:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716308;
	bh=doJPyst/ofUPVvaw7EdcKCivBrHsiqPGxxa8ERoKh/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YuaBT9AFzKLwMEH3C1grhj98rLtDNTi7Z6VLVbZNdGEayjpIJim6gCULVu0A7NluC
	 SdM1VsBFeRHxaonrARNVQmSfpEQ+Y0weFXxjVDV8zggjT0tGiYNEkQIn9clLYxHm/C
	 nKY6/Wu8vbuJiL34THJYg7sl+taxqhxQL3GTJ/Zk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 602/770] NFSD: Make nfs4_put_copy() static
Date: Tue, 18 Jun 2024 14:37:35 +0200
Message-ID: <20240618123430.527188437@linuxfoundation.org>
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

[ Upstream commit 8ea6e2c90bb0eb74a595a12e23a1dff9abbc760a ]

Clean up: All call sites are in fs/nfsd/nfs4proc.c.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 2 +-
 fs/nfsd/state.h    | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 7fb1ef7c4383e..64879350ccbda 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1287,7 +1287,7 @@ nfsd4_clone(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	return status;
 }
 
-void nfs4_put_copy(struct nfsd4_copy *copy)
+static void nfs4_put_copy(struct nfsd4_copy *copy)
 {
 	if (!refcount_dec_and_test(&copy->refcount))
 		return;
diff --git a/fs/nfsd/state.h b/fs/nfsd/state.h
index f3d6313914ed0..ae596dbf86675 100644
--- a/fs/nfsd/state.h
+++ b/fs/nfsd/state.h
@@ -703,7 +703,6 @@ extern struct nfs4_client_reclaim *nfs4_client_to_reclaim(struct xdr_netobj name
 extern bool nfs4_has_reclaimed_state(struct xdr_netobj name, struct nfsd_net *nn);
 
 void put_nfs4_file(struct nfs4_file *fi);
-extern void nfs4_put_copy(struct nfsd4_copy *copy);
 extern struct nfsd4_copy *
 find_async_copy(struct nfs4_client *clp, stateid_t *staetid);
 extern void nfs4_put_cpntf_state(struct nfsd_net *nn,
-- 
2.43.0



