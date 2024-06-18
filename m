Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BD51AAE3B;
	Tue, 18 Jun 2024 13:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716499; cv=none; b=TIB5nFf2j6HgeOvQo4g0kwS7883KYRNsC6AlgvVFnlm2/S/CxH3UkOS3trGoZoX81GpF3lZLLMu/LW9qO6be6D4r4gRvE3F0ehFgU/hRv9WCEMZYljEDNH/mwB5m6N8iRoRnVl2v9DiSADG7EzrKd5Lo49HlWgTITsC0M66UhI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716499; c=relaxed/simple;
	bh=9TD9krmM4TYibCOFwB6Vpl/h3W9cZwG5D71BnBoo1Bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FoKjSKCfl2s6M16MxL2g66m/G3C8ItlMUHfqo/hufrlsnOsNACeCeuFo4PQ59VF6OWuEPMtoh1pE9Ke0eS3U347wAdiWiJe4q8s7XhS/HfgeowWfpK3UL5pwaWfOfdlA07lCn/TIzJHVQWh0ChouUYiFCWbkx9dj5jJPCBRA/Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hM8FJYek; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hM8FJYek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62D0C3277B;
	Tue, 18 Jun 2024 13:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716499;
	bh=9TD9krmM4TYibCOFwB6Vpl/h3W9cZwG5D71BnBoo1Bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hM8FJYeko8vkIRrooz2MDcbb7ryHsNKaPJB+9ygBYzyZtO/9d5N5d/dlj3lVlAh2u
	 YL2biW0QF/i+1nIrlIp86XAvsYYuK7QASlRCoGCOCUv8VVXKJysvEZuiy2JJzk0S3o
	 YX16V09jZBaRWYZEP1mi3DqCCtdWgCb1rxe6LSq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 666/770] nfsd: fix comments about spinlock handling with delegations
Date: Tue, 18 Jun 2024 14:38:39 +0200
Message-ID: <20240618123432.991110872@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 25fbe1fca14142beae6c882f7906510363d42bff ]

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 1dc3823f3d124..e9fc5a357fc4d 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4870,14 +4870,14 @@ static void nfsd_break_one_deleg(struct nfs4_delegation *dp)
 	 * We're assuming the state code never drops its reference
 	 * without first removing the lease.  Since we're in this lease
 	 * callback (and since the lease code is serialized by the
-	 * i_lock) we know the server hasn't removed the lease yet, and
+	 * flc_lock) we know the server hasn't removed the lease yet, and
 	 * we know it's safe to take a reference.
 	 */
 	refcount_inc(&dp->dl_stid.sc_count);
 	nfsd4_run_cb(&dp->dl_recall);
 }
 
-/* Called from break_lease() with i_lock held. */
+/* Called from break_lease() with flc_lock held. */
 static bool
 nfsd_break_deleg_cb(struct file_lock *fl)
 {
-- 
2.43.0



