Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D531B6EB72;
	Mon,  8 Apr 2024 13:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584471; cv=none; b=DzYQv+nZCNIolWzq5S8vUOGCc5mUd88U2JGUe0vOBM6eF+ZXvsHkT71vZhm0oNkgjngWzspXr4739dn7Hx45duIjlEE7+0tBw5ewH+udaGhlQFHafADbZW5MlzIuUiYKtrl+h7BTNlvWN14kK6u9FutR9c0/liJYKk+/+uomWG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584471; c=relaxed/simple;
	bh=W01yAgXPUIKnfXMxeD2tEADcA8pgoksA+S6edVTPbtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EmoWL4UmF8T5dCLARxuzLyV+f7faTCV95lZGAF3A6jA7O+HYbvZICzhHJZUff17DDNjcrh8Ih6rJzqI9NJ7ZG0uJVUZSXaZoGoByQISYYeIW2QhweBz/omg4BXoQN4b5B2zV4cvV/1Fv/TiNISDWyKqyx2qotUTAZRE0Ko79S7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uVb5NzlZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uVb5NzlZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F98DC433C7;
	Mon,  8 Apr 2024 13:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584471;
	bh=W01yAgXPUIKnfXMxeD2tEADcA8pgoksA+S6edVTPbtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uVb5NzlZ2Cr9jHusnsd3lb8+IeqFHFcm1l0eTAdKwsuFttyl4kC5yf0IAIlHXRhS7
	 6NO8cbBNgLQQ3mHhsBU9QUZ2L67LKnDeGTiyGQfPtCWL9zGbMHupxAO+FNIoyJwUdh
	 u6qTNh607e2G5rffmUz/wqCjfbXevq8xJnR9JzxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zeal Robot <zealci@zte.com.cn>,
	Jinpeng Cui <cui.jinpeng2@zte.com.cn>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 419/690] NFSD: remove redundant variable status
Date: Mon,  8 Apr 2024 14:54:45 +0200
Message-ID: <20240408125414.787351848@linuxfoundation.org>
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

From: Jinpeng Cui <cui.jinpeng2@zte.com.cn>

[ Upstream commit 4ab3442ca384a02abf8b1f2b3449a6c547851873 ]

Return value directly from fh_verify() do_open_permission()
exp_pseudoroot() instead of getting value from
redundant variable status.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Jinpeng Cui <cui.jinpeng2@zte.com.cn>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4proc.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index b2bfe540c1cb0..69d3013fb1b26 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -141,7 +141,6 @@ fh_dup2(struct svc_fh *dst, struct svc_fh *src)
 static __be32
 do_open_permission(struct svc_rqst *rqstp, struct svc_fh *current_fh, struct nfsd4_open *open, int accmode)
 {
-	__be32 status;
 
 	if (open->op_truncate &&
 		!(open->op_share_access & NFS4_SHARE_ACCESS_WRITE))
@@ -156,9 +155,7 @@ do_open_permission(struct svc_rqst *rqstp, struct svc_fh *current_fh, struct nfs
 	if (open->op_share_deny & NFS4_SHARE_DENY_READ)
 		accmode |= NFSD_MAY_WRITE;
 
-	status = fh_verify(rqstp, current_fh, S_IFREG, accmode);
-
-	return status;
+	return fh_verify(rqstp, current_fh, S_IFREG, accmode);
 }
 
 static __be32 nfsd_check_obj_isreg(struct svc_fh *fh)
@@ -454,7 +451,6 @@ static __be32
 do_open_fhandle(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate, struct nfsd4_open *open)
 {
 	struct svc_fh *current_fh = &cstate->current_fh;
-	__be32 status;
 	int accmode = 0;
 
 	/* We don't know the target directory, and therefore can not
@@ -479,9 +475,7 @@ do_open_fhandle(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate, str
 	if (open->op_claim_type == NFS4_OPEN_CLAIM_DELEG_CUR_FH)
 		accmode = NFSD_MAY_OWNER_OVERRIDE;
 
-	status = do_open_permission(rqstp, current_fh, open, accmode);
-
-	return status;
+	return do_open_permission(rqstp, current_fh, open, accmode);
 }
 
 static void
@@ -668,11 +662,9 @@ static __be32
 nfsd4_putrootfh(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		union nfsd4_op_u *u)
 {
-	__be32 status;
-
 	fh_put(&cstate->current_fh);
-	status = exp_pseudoroot(rqstp, &cstate->current_fh);
-	return status;
+
+	return exp_pseudoroot(rqstp, &cstate->current_fh);
 }
 
 static __be32
-- 
2.43.0



