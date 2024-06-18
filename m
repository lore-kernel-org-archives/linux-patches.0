Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B125813AD1D;
	Tue, 18 Jun 2024 12:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715289; cv=none; b=d2LI5x03XvsWlQQxm5Vymc5Fk4f4znF+5IWMVBK5hYdwCtenBx3Z3KJoBRk5CyfCr5gvXn7jgD5oy4aVLL+pxRHmgfy+nS1CB1c8oxIV7KIfS7b40JE1FaQ5JIuN/T028xTsqnOEr9WVQIW66FiNCOxLBJ5r6nBadCTJ/u1DOKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715289; c=relaxed/simple;
	bh=yhJT+ksVBVbvp+5vM9W+mRohS14QlAVhCT3rR9vsZrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r3eK8KPKdNSaRdBg4FUYQyb6K6mgrAh98uqXmDu6DK0j3fgbqN9aogNV4+Y/4hbv4zIAKYsTYt5pVczDH478Lb3mnnP+kAReMcRKqbG7mv2I7krZ2Jvt8P+1tJtYrQlc5Cvxl60VMI3s5JOco1JPYb7b+eMbBPnsiO/FBxi/hDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q1/92tpf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q1/92tpf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 374E5C3277B;
	Tue, 18 Jun 2024 12:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715289;
	bh=yhJT+ksVBVbvp+5vM9W+mRohS14QlAVhCT3rR9vsZrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q1/92tpfvs1HD1gHxpznYC8xd7zGcVWd0ojZ/YdYhe2EPP0oPurbWK8uaMvwgEF93
	 zEJcxghjmWul7R2sIMyeKZcmHwHbyvSDtx11PjU6dlCJcS8V1DZvKOOvVoFNQjIUm3
	 aI+km7HP9g8GeJJlZbT2uY/s155FudzUc5JnMjB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasily Averin <vvs@virtuozzo.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 259/770] nfsd: removed unused argument in nfsd_startup_generic()
Date: Tue, 18 Jun 2024 14:31:52 +0200
Message-ID: <20240618123417.272166168@linuxfoundation.org>
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

From: Vasily Averin <vvs@virtuozzo.com>

[ Upstream commit 70c5307564035c160078401f541c397d77b95415 ]

Since commit 501cb1849f86 ("nfsd: rip out the raparms cache")
nrservs is not used in nfsd_startup_generic()

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfssvc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 79bc75d415226..731d89898903a 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -308,7 +308,7 @@ static int nfsd_init_socks(struct net *net, const struct cred *cred)
 
 static int nfsd_users = 0;
 
-static int nfsd_startup_generic(int nrservs)
+static int nfsd_startup_generic(void)
 {
 	int ret;
 
@@ -374,7 +374,7 @@ void nfsd_reset_boot_verifier(struct nfsd_net *nn)
 	write_sequnlock(&nn->boot_lock);
 }
 
-static int nfsd_startup_net(int nrservs, struct net *net, const struct cred *cred)
+static int nfsd_startup_net(struct net *net, const struct cred *cred)
 {
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
 	int ret;
@@ -382,7 +382,7 @@ static int nfsd_startup_net(int nrservs, struct net *net, const struct cred *cre
 	if (nn->nfsd_net_up)
 		return 0;
 
-	ret = nfsd_startup_generic(nrservs);
+	ret = nfsd_startup_generic();
 	if (ret)
 		return ret;
 	ret = nfsd_init_socks(net, cred);
@@ -790,7 +790,7 @@ nfsd_svc(int nrservs, struct net *net, const struct cred *cred)
 
 	nfsd_up_before = nn->nfsd_net_up;
 
-	error = nfsd_startup_net(nrservs, net, cred);
+	error = nfsd_startup_net(net, cred);
 	if (error)
 		goto out_destroy;
 	error = nn->nfsd_serv->sv_ops->svo_setup(nn->nfsd_serv,
-- 
2.43.0



