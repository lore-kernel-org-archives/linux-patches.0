Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D71013C673;
	Tue, 18 Jun 2024 13:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716082; cv=none; b=AG7wUzRKikHLaXW9yaz1wQxutvk8Ff8m6fePoiQrb9IlnOvoFcniVUf3KPUpm0CnYGHxtimbYEer2il5hLeZHtW4SZcixDyzOZp7VYJB1EK5ANMph98KrD3vCNavwWU2XaBICNQtgrmw4lUCxVUZCYJdz2WRPyZ8EsopSnCOVdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716082; c=relaxed/simple;
	bh=xL6Hdtm0BVDQ5BypUuIJ8V2nkxRz1q8Yz/2zRvfgoss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nT5iqGSzPEj/ODv7zx09UG58LURQMuJutBboSKtAUu0gQUIWf7nfkuLEXj86NAYTKEPfAR0Au+Q6hs9OlRhKo++aCzyvKt1za+aADI+CBYT3NX+iqOIGHdYcJo+/h0vwZSKlZ1nTOeRHAFfU/ZlRpoYLXKc6x5+4yacwffFEbm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IMBnBAE6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IMBnBAE6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05DB3C3277B;
	Tue, 18 Jun 2024 13:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716082;
	bh=xL6Hdtm0BVDQ5BypUuIJ8V2nkxRz1q8Yz/2zRvfgoss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IMBnBAE6wgm6ymprUrY9HHh3G7E/erjQeRLL4GZx9K3LPdNphqYaAvQVo4n1gp1fw
	 I1xLji2+SV53ou0Q4lvKxAzIWcCQTa/DgiFCI9EdfuJNWmk9S1ZufjYDm1Azkupwjp
	 QdZL4mT2yoOCFnU6zBJJ9RCqPPfRrZwDWgVAKjtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 527/770] NFSD: Move documenting comment for nfsd4_process_open2()
Date: Tue, 18 Jun 2024 14:36:20 +0200
Message-ID: <20240618123427.657533116@linuxfoundation.org>
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

[ Upstream commit 7e2ce0cc15a509b859199235a2bad9cece00f67a ]

Clean up nfsd4_open() by converting a large comment at the only
call site for nfsd4_process_open2() to a kerneldoc comment in
front of that function.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c  |  6 +-----
 fs/nfsd/nfs4state.c | 12 ++++++++++++
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 90a12ccf96713..d62d962ed2f13 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -628,11 +628,7 @@ nfsd4_open(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		status = nfserr_inval;
 		goto out;
 	}
-	/*
-	 * nfsd4_process_open2() does the actual opening of the file.  If
-	 * successful, it (1) truncates the file if open->op_truncate was
-	 * set, (2) sets open->op_stateid, (3) sets open->op_delegation.
-	 */
+
 	status = nfsd4_process_open2(rqstp, resfh, open);
 	WARN(status && open->op_created,
 	     "nfsd4_process_open2 failed to open newly-created file! status=%u\n",
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 9f972ca09eec7..e0ce0412d7dea 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -5465,6 +5465,18 @@ static void nfsd4_deleg_xgrade_none_ext(struct nfsd4_open *open,
 	 */
 }
 
+/**
+ * nfsd4_process_open2 - finish open processing
+ * @rqstp: the RPC transaction being executed
+ * @current_fh: NFSv4 COMPOUND's current filehandle
+ * @open: OPEN arguments
+ *
+ * If successful, (1) truncate the file if open->op_truncate was
+ * set, (2) set open->op_stateid, (3) set open->op_delegation.
+ *
+ * Returns %nfs_ok on success; otherwise an nfs4stat value in
+ * network byte order is returned.
+ */
 __be32
 nfsd4_process_open2(struct svc_rqst *rqstp, struct svc_fh *current_fh, struct nfsd4_open *open)
 {
-- 
2.43.0



