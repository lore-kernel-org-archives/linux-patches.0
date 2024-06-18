Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C67140E37;
	Tue, 18 Jun 2024 12:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714758; cv=none; b=AYRILiK+BPIOhi+l4fl7UtrveuRBUTSwDqs7P3KMdAgq+J4OuJvcnWQjUTEaQcwThNvVLl6mm7SINCtdeqX5TQLWY/CXbFXkJheyychDi5z81Wn27idZnKjLB2XtXfN9pvfYy0qB8JG2PfMUzAZLYqb/1MkSrhmqDlCJcsTvo0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714758; c=relaxed/simple;
	bh=c5umScpVJQB+hY/LkCdYipDDwAvYMbUaje1rz7utp6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gNqnRK8pe9Ni4IGswJKjAH5tDLLVrGsV1HVDyt7Qhx4g0GohG3FUzWjLBY+FvEmE3ci4tC8zaSJ7/czqfNEhArO+asLkc+piMLugqB4aahT1yLQ3KDk+Qu4uT2zyG487vDECTS8voN7qNy9LFFeyN0sLYd6BnB8E7sz5pnnlKjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pE/WNNjk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pE/WNNjk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D81C3277B;
	Tue, 18 Jun 2024 12:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714758;
	bh=c5umScpVJQB+hY/LkCdYipDDwAvYMbUaje1rz7utp6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pE/WNNjkZWXHS6odNlQmz5PXjI9fhhV8GO7zFnVyoOU3bv9MKPFeDFYT5Q2jXGynv
	 6TYDcyG+hFY2lIXgUDtkf4uqFW0t1ku8ZN5LI8oLkL/DhN0PtXOFRE+30XUE7i7wFl
	 4CL9dNtJoqliwDBpatmeVIMW0lmV66SvkM6sFC1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 079/770] NFSD: Replace READ* macros in nfsd4_decode_destroy_clientid()
Date: Tue, 18 Jun 2024 14:28:52 +0200
Message-ID: <20240618123410.331798724@linuxfoundation.org>
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

[ Upstream commit c95f2ec3490586cbb33badc8f4c82d6aa4955078 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 9642de1550431..d0f0b7cd4e74e 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1738,16 +1738,6 @@ nfsd4_decode_free_stateid(struct nfsd4_compoundargs *argp,
 	return nfsd4_decode_stateid4(argp, &free_stateid->fr_stateid);
 }
 
-static __be32 nfsd4_decode_destroy_clientid(struct nfsd4_compoundargs *argp, struct nfsd4_destroy_clientid *dc)
-{
-	DECODE_HEAD;
-
-	READ_BUF(8);
-	COPYMEM(&dc->clientid, 8);
-
-	DECODE_TAIL;
-}
-
 static __be32 nfsd4_decode_reclaim_complete(struct nfsd4_compoundargs *argp, struct nfsd4_reclaim_complete *rc)
 {
 	DECODE_HEAD;
@@ -1908,6 +1898,12 @@ nfsd4_decode_test_stateid(struct nfsd4_compoundargs *argp, struct nfsd4_test_sta
 	return nfs_ok;
 }
 
+static __be32 nfsd4_decode_destroy_clientid(struct nfsd4_compoundargs *argp,
+					    struct nfsd4_destroy_clientid *dc)
+{
+	return nfsd4_decode_clientid4(argp, &dc->clientid);
+}
+
 static __be32
 nfsd4_decode_fallocate(struct nfsd4_compoundargs *argp,
 		       struct nfsd4_fallocate *fallocate)
-- 
2.43.0



