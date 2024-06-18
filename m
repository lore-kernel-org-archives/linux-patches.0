Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB90813C675;
	Tue, 18 Jun 2024 12:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714681; cv=none; b=Zq6IX6n5zFELqIJtr6TkjdOrPr1AyfFw+8zpSWQCf8kjQNoTkjoyPArzL5HN8t0ZBF94l9DNvHnKfF3/zDHDTmK5D0DCafT8+2XgfUog4aQki3L4RhyK2VcT22ozddlDTMRLrPrKL6WVWxPRlUkYZBZ/XGYhozVXQAFfeNPmhmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714681; c=relaxed/simple;
	bh=UrfhxXNDKMtmFloOJXlKvHteei8YT5PqMkGo+dBm8I4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g3OOShmNTQkYkZoy5ekZAPvY9Ln0Z4URc/oN8+7nWqq8hRNcfb+hwo9FUwPcG5wNkp661//t5RX7Z7UWstJBQNe4H80h3WshXkZL9je+hSLxolvSqrTLqSKkTHwNaFDOVvnQLmgfHtTV1zMqe94Y/81MmPXa3dvOZRTUrGjKn5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MalRobmd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MalRobmd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3139AC3277B;
	Tue, 18 Jun 2024 12:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714681;
	bh=UrfhxXNDKMtmFloOJXlKvHteei8YT5PqMkGo+dBm8I4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MalRobmd+qZ8BiknCjMK4xWJXVE/IoD9+/yoit+BH1ZgC2F8hCmKDtDdsAkNWiYkt
	 cblJCEi7Br9/gsjO9HL+WZsuMLiRQF24wI4SYAlW50QOEv4P9h5g02GUnsm17xppw3
	 8SdubAAA4l6UV2CZzSJTxkV4uvCXxZ9j6ZDuF6N8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 053/770] NFSD: Replace READ* macros in nfsd4_decode_renew()
Date: Tue, 18 Jun 2024 14:28:26 +0200
Message-ID: <20240618123409.336827563@linuxfoundation.org>
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

[ Upstream commit d12f90458dc8c11734ba44ec88f109bf8de86ff0 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index adf4a6fb94d4c..51b59b369d726 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1272,15 +1272,7 @@ nfsd4_decode_rename(struct nfsd4_compoundargs *argp, struct nfsd4_rename *rename
 static __be32
 nfsd4_decode_renew(struct nfsd4_compoundargs *argp, clientid_t *clientid)
 {
-	DECODE_HEAD;
-
-	if (argp->minorversion >= 1)
-		return nfserr_notsupp;
-
-	READ_BUF(sizeof(clientid_t));
-	COPYMEM(clientid, sizeof(clientid_t));
-
-	DECODE_TAIL;
+	return nfsd4_decode_clientid4(argp, clientid);
 }
 
 static __be32
-- 
2.43.0



