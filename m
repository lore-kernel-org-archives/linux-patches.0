Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B4F13C66F;
	Tue, 18 Jun 2024 13:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716079; cv=none; b=J08CBOj5zczH3Br2alkXWJZ9OImSGy0YoDx4fAV7MEBpShaQAstcC/SxllRZHWME1lOEcUakebScZbFvrp3uRNpxiIYpBKkVs2iDgYkcfn22kHrWH52ktVyxJ0iBCu7iRFnkhFj+RefwrC1/SSz/J+y4ierVnQ4kIPHl2ITT0mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716079; c=relaxed/simple;
	bh=0QuRWDCWH78NWG+e30gw93zG2Ei8VYoValVG5zRfL8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n/1shXUUX8CP4TepjvdVCchATDBsgqR7ewGGpL4+Zi1gb1Mc74dnhfRXw08h+m3zcvP3LVUvQrdHq497Fb98zFF2zg8DU91ZifhInMX8Wf6Ct0J1pDA4bOPtEokIsqkMfc6pMd7dy9UYkMsSQPj4215laeQGzQL2Dk9fk6gLPAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I6+nsTVX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I6+nsTVX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 210B2C3277B;
	Tue, 18 Jun 2024 13:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716079;
	bh=0QuRWDCWH78NWG+e30gw93zG2Ei8VYoValVG5zRfL8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I6+nsTVXGWMfkhKPKkqgfuk28kO2fxOl8h/pTwi9aX5mF8UsL6DvZg349ezQ+ID4X
	 36ssnYU9kiq2Z0ofRuoPrsID/crr2IMcjQ2QZKOTt8Uya3R4jlwae0N9RkJzc7gCHj
	 dOmmfYvIUh5RSn3vv6aOaY2LBPzaBKpr7enzapCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 526/770] NFSD: Fix whitespace
Date: Tue, 18 Jun 2024 14:36:19 +0200
Message-ID: <20240618123427.620456664@linuxfoundation.org>
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

[ Upstream commit 26320d7e317c37404c811603d50d811132aef78c ]

Clean up: Pull case arms back one tab stop to conform every other
switch statement in fs/nfsd/nfs4proc.c.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 50 +++++++++++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index c21cfaabf873a..90a12ccf96713 100644
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



