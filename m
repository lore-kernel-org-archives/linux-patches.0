Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91A8768EA;
	Mon,  8 Apr 2024 13:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584031; cv=none; b=aKu+v0GF33QFr3FIhRZ0tUGQnJB5VIo261VwcjaXRac1hKdRRQnZ/AG+/M8yfuNncqeRu2603iIAR+A3EXP4oCKDjWjlQvHHSw8eHVAfVs+r4D2WcZ4HKEpKwJDqoSKUzQOynDo9RiGtC7627I9BTygtqf9LQfC/dYVxq6CCxG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584031; c=relaxed/simple;
	bh=kVe0jQYd8FHHfL53lb/cTSpMyZoSd5TibzMKguiMcY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hTrDom3lZFjw08OFh051l27e8wwnIYXlr9FH2DMI02f/SO9U3BR8Akfm8Ua5Q+MyC9quvZhQxV4pbZ+tLVQPbeanX+QGpcjlGIgvvvzCQT2RDAbcUiZs5xCjI9hWppNDBv9LAfjp3Q4RLSBP75hwSbW9SXaZ8yPm1pQH5nIDpDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IhdvCCjO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IhdvCCjO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA6AC43390;
	Mon,  8 Apr 2024 13:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584030;
	bh=kVe0jQYd8FHHfL53lb/cTSpMyZoSd5TibzMKguiMcY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IhdvCCjOMita8f02e6+wjS87Cp3q9vn2EkRaTkZV+PJF6rKaSLKDzauuiIn1l87UW
	 h7FQQFGcVjrxBC0EpGyueJ0q8QqOwi5+GNEDsV314Bee+4JgdfvAA9Qkz3gTa/NTLI
	 QzfgDeNzRJaJkh1xarpviaNThTQbu4gObKw7XXs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 323/690] NFSD: Fix whitespace
Date: Mon,  8 Apr 2024 14:53:09 +0200
Message-ID: <20240408125411.325497911@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 26320d7e317c37404c811603d50d811132aef78c ]

Clean up: Pull case arms back one tab stop to conform every other
switch statement in fs/nfsd/nfs4proc.c.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4proc.c | 50 +++++++++++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 611aedeab406b..6a9c7e6a23ba5 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -600,33 +600,33 @@ nfsd4_open(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		goto out;
 
 	switch (open->op_claim_type) {
-		case NFS4_OPEN_CLAIM_DELEGATE_CUR:
-		case NFS4_OPEN_CLAIM_NULL:
-			status = do_open_lookup(rqstp, cstate, open, &resfh);
-			if (status)
-				goto out;
-			break;
-		case NFS4_OPEN_CLAIM_PREVIOUS:
-			status = nfs4_check_open_reclaim(cstate->clp);
-			if (status)
-				goto out;
-			open->op_openowner->oo_flags |= NFS4_OO_CONFIRMED;
-			reclaim = true;
-			fallthrough;
-		case NFS4_OPEN_CLAIM_FH:
-		case NFS4_OPEN_CLAIM_DELEG_CUR_FH:
-			status = do_open_fhandle(rqstp, cstate, open);
-			if (status)
-				goto out;
-			resfh = &cstate->current_fh;
-			break;
-		case NFS4_OPEN_CLAIM_DELEG_PREV_FH:
-             	case NFS4_OPEN_CLAIM_DELEGATE_PREV:
-			status = nfserr_notsupp;
+	case NFS4_OPEN_CLAIM_DELEGATE_CUR:
+	case NFS4_OPEN_CLAIM_NULL:
+		status = do_open_lookup(rqstp, cstate, open, &resfh);
+		if (status)
 			goto out;
-		default:
-			status = nfserr_inval;
+		break;
+	case NFS4_OPEN_CLAIM_PREVIOUS:
+		status = nfs4_check_open_reclaim(cstate->clp);
+		if (status)
 			goto out;
+		open->op_openowner->oo_flags |= NFS4_OO_CONFIRMED;
+		reclaim = true;
+		fallthrough;
+	case NFS4_OPEN_CLAIM_FH:
+	case NFS4_OPEN_CLAIM_DELEG_CUR_FH:
+		status = do_open_fhandle(rqstp, cstate, open);
+		if (status)
+			goto out;
+		resfh = &cstate->current_fh;
+		break;
+	case NFS4_OPEN_CLAIM_DELEG_PREV_FH:
+	case NFS4_OPEN_CLAIM_DELEGATE_PREV:
+		status = nfserr_notsupp;
+		goto out;
+	default:
+		status = nfserr_inval;
+		goto out;
 	}
 	/*
 	 * nfsd4_process_open2() does the actual opening of the file.  If
-- 
2.43.0



