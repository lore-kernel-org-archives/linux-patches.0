Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E937E13C66F;
	Tue, 18 Jun 2024 13:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716077; cv=none; b=TBczNnYvmHKXGyG55qie/UmitFaa5AIXhITtS2aPB/g6v8gRhM6k0difCv8Jw8VVbykrTCw6A5Ux4mn9CxUXcysQYhc2t41L8t3UhvpHPglpmR5vZ3t31MechOk7wat2OSxc4G+pZ1qNaeqcsvKOser6WkeqFWJfXoKLQSX4ekE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716077; c=relaxed/simple;
	bh=rRO/hW9PNWFOQKDkVPNF92yyKUEqk6QMT4tYOq0AH9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Er8iVRqho9Dbm49J5ktM2JSU8t7FUEkKZejFnbFewYmjR2h0MMnTg2jXl5ubq0mjrLnAiL3GVA/+kPU57fg0+rcCFgEf8j/9n00JiQB3S6pp5CQrXHQAt5bXUnKbbKvCmac8PKxOGAiguyCDNB3MYgmyH6SDHqwRnzy0aVQCZIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ul765bgq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ul765bgq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C3BC3277B;
	Tue, 18 Jun 2024 13:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716076;
	bh=rRO/hW9PNWFOQKDkVPNF92yyKUEqk6QMT4tYOq0AH9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ul765bgq1oS8cad/XFwkC8YPzFCMqqVSZc914nfMmxUhyNKZ3Wp0/vnvelvgbAenD
	 Nukvm1cCaVBbCuzPUNak59ZpqpQF/hgVOb07aSzwUX2zG/jrQroWhuinrZ6Cd/QKDD
	 Uxuf/vea2Rgm+PnZUcI66o5HL5SgB1i/Y2NKgUdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 525/770] NFSD: Remove dprintk call sites from tail of nfsd4_open()
Date: Tue, 18 Jun 2024 14:36:18 +0200
Message-ID: <20240618123427.576288789@linuxfoundation.org>
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

[ Upstream commit f67a16b147045815b6aaafeef8663e5faeb6d569 ]

Clean up: These relics are not likely to benefit server
administrators.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 166ebb126d37b..c21cfaabf873a 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -622,13 +622,9 @@ nfsd4_open(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 			break;
 		case NFS4_OPEN_CLAIM_DELEG_PREV_FH:
              	case NFS4_OPEN_CLAIM_DELEGATE_PREV:
-			dprintk("NFSD: unsupported OPEN claim type %d\n",
-				open->op_claim_type);
 			status = nfserr_notsupp;
 			goto out;
 		default:
-			dprintk("NFSD: Invalid OPEN claim type %d\n",
-				open->op_claim_type);
 			status = nfserr_inval;
 			goto out;
 	}
-- 
2.43.0



