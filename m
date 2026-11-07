Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061724;
	b=TvydIIQr8VUI8vBvwNxKePNqssgXkLVq0YTi/NhLM7cmU9bQpJCKjx0/hHArnyDyF+AZ
	 bohMN/1EAHKN8CB2uZQw4Vcxdann+bNEWcJzcpO4idFFVAtQSoAJRJ/ETO9zxxDuJk/Bh
	 NVofoAlwr0+i1tGSlLFufjKSiT7huLCj1qWxuSFpufRy42rcFOa7+L1TXCQ/eeh5J63U4
	 6IbT7207HmZ5HbpBeDcr8H3UbBdB34vTSUWGpLJD6/lPdaux0LSRZ3xXPE1EgMU2+/gKh
	 dkWvxq34k/f1lmrrrdOA3dVYBqdEdCevpMh/mRhf27g4GNN/4DViFBCP7aiMl61L08A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061724;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CjflSGaanok2DrLpmCpUMAr+0FUmJWcwDF4aQwMTaCw=;
	b=h/Z8gx+WO5Lr64bEMGaXqcclypsFU4Fv8FhZUwLTOU7+iGfgvD5UO+qeo5K/ASOgpIOO
	 gfBo44u/PwJ+mcbnx8aC2APOf94S3xzBx2TvhrqB2KOpI7xbqzk13EQoqsFAWnTfTuTkd
	 IxnFG9dfud6adJCfH4NVM+JTqkqobHNIwyPHn0MGWfdwQRWjPBk0WqczMfEUF+d68XlW6
	 SmnMFo9VTKfy9O2VuNyf20+6NWw0WUVhRnrx3jl+rH1bC4h6F8OjK6XXfja5nLtMchQwI
	 tiSogvbKmRUwtxRW/GrSeNpjsVMsW5hFserhAzwNC9Dxj4scb+rMG6f7HF2tAKLD5mA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="QoVc3E/e";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D17F606A331;
	Sat,  7 Nov 2026 14:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QoVc3E/e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E641F0089F;
	Sat,  7 Nov 2026 14:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061724;
	bh=CjflSGaanok2DrLpmCpUMAr+0FUmJWcwDF4aQwMTaCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QoVc3E/efg8L7AjDXBzxqTakdns3CnHapUrlq103feZ/Lg2OLXKXgoPyX+SDgyWf4
	 rou+d6I5U4qhbMPRZ/V1DkpzAfe9buB2/ALgmaqzUCVo8J+opxguDfdaI/GJwcG5af
	 yli2xoi544TjprkcDIdk0qz4Bsf95nLPGhM0nXfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	AutonomousCodeSecurity@microsoft.com,
	"Cen Zhang (Microsoft Security FORGE Labs)" <blbllhy@gmail.com>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 0768/1536] nfsd: hold cl_lock in client_has_openowners()
Date: Sat,  7 Nov 2026 08:46:24 -0500
Message-ID: <20261107135019.103286830@linuxfoundation.org>
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

From: Cen Zhang (Microsoft Security FORGE Labs) <blbllhy@gmail.com>

commit 5336899b5491eaa2ac22c2925d87daab2b140eb3 upstream.

client_has_openowners() walks clp->cl_openowners and reads so_stateids
without clp->cl_lock. nfs4_put_stateowner() unhashes that openowner under
cl_lock and then frees it, so a concurrent EXCHANGE_ID with mismatched
creds can use-after-free the nfs4_openowner.

BUG: KASAN: slab-use-after-free in client_has_state+0x10a/0x140
  fs/nfsd/nfs4state.c:3718 client_has_openowners()
  nfsd4_exchange_id
  nfsd4_proc_compound
  nfsd_dispatch
  svc_process

Take clp->cl_lock while client_has_openowners() walks the openowner
list.

Fixes: 4eaea1342507 ("nfsd: improve client_has_state to check for unused openowners")
Cc: stable@vger.kernel.org
Reported-by: Xiang Mei (Microsoft) <xmei5@asu.edu>
Cc: AutonomousCodeSecurity@microsoft.com
Signed-off-by: Cen Zhang (Microsoft Security FORGE Labs) <blbllhy@gmail.com>
Link: https://patch.msgid.link/20260828041925.36758-1-blbllhy@gmail.com
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -3641,12 +3641,18 @@ nfsd4_set_ex_flags(struct nfs4_client *n
 static bool client_has_openowners(struct nfs4_client *clp)
 {
 	struct nfs4_openowner *oo;
+	bool found = false;
 
+	spin_lock(&clp->cl_lock);
 	list_for_each_entry(oo, &clp->cl_openowners, oo_perclient) {
-		if (!list_empty(&oo->oo_owner.so_stateids))
-			return true;
+		if (!list_empty(&oo->oo_owner.so_stateids)) {
+			found = true;
+			break;
+		}
 	}
-	return false;
+	spin_unlock(&clp->cl_lock);
+
+	return found;
 }
 
 static bool client_has_state(struct nfs4_client *clp)


