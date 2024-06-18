Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117DA13E409;
	Tue, 18 Jun 2024 12:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715497; cv=none; b=gy5UJwQ1lVf1VmaARzTOXxmOPSxLmQ4u8Pr+wNxvJkWTK8pFKDeE2l5/0Rb/Yj/CBQfhltgFn67ePCOw3yM/U3b1utHFtYE8C/fVvq8ct5JqWdYEJEiTaH/F9ypoBgeUxdKlsso+KCgwzZYSesuOtQ1uy+JZhHltuihf8Is23To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715497; c=relaxed/simple;
	bh=8Q95xdoHOCw42Qz7rxg/pIop5ZLys+CcHB44LIfvyJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kKHAQdsHWSf2xYBt+J2IcoxkKovf+TD8naYn5dQQrA5gxByJ8x5p7s84IOenG5mokRdRjxUNhNA8uYX4W3zSRxlpTZ/7VU98D5FYHdu8YgCaCLULo7jZTRikb86bHqG1kqa3YpxkrdN1gq43TSI5zVw0USRrGg1KIjijDieD6ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DDVMuEBj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DDVMuEBj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43F33C32786;
	Tue, 18 Jun 2024 12:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715496;
	bh=8Q95xdoHOCw42Qz7rxg/pIop5ZLys+CcHB44LIfvyJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DDVMuEBjrWJCscQzuehlcaJDxsXLb/QFd0xy/NKlGFb4X0G9iIfzXqsC6Qdp/dEyC
	 GJWQNJuPPU/JVxz4+1sQcaXJjTACIBz6shbuGIczx/Hyr+yUK4prq1lo7YLbKLcLut
	 gc6eU64jLKNWz0+6k2aiVpEp6rIgNRPH55EAY5yw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.king@canonical.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 328/770] nfsd: remove redundant assignment to pointer this
Date: Tue, 18 Jun 2024 14:33:01 +0200
Message-ID: <20240618123419.932256504@linuxfoundation.org>
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

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit e34c0ce9136a0fe96f0f547898d14c44f3c9f147 ]

The pointer 'this' is being initialized with a value that is never read
and it is being updated later with a new value. The initialization is
redundant and can be removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index f7ddfa204abc4..1f840c72e9780 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -3369,7 +3369,7 @@ bool nfsd4_spo_must_allow(struct svc_rqst *rqstp)
 {
 	struct nfsd4_compoundres *resp = rqstp->rq_resp;
 	struct nfsd4_compoundargs *argp = rqstp->rq_argp;
-	struct nfsd4_op *this = &argp->ops[resp->opcnt - 1];
+	struct nfsd4_op *this;
 	struct nfsd4_compound_state *cstate = &resp->cstate;
 	struct nfs4_op_map *allow = &cstate->clp->cl_spo_must_allow;
 	u32 opiter;
-- 
2.43.0



