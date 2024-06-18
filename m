Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 084C717CA1D;
	Tue, 18 Jun 2024 12:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715551; cv=none; b=HR563JRwXvoaegrMIjaoBBCOTs2fD0n0R16dffyJni/ahN3mEbbzDVJ8CZILmBKg8cBVk74vsD9/wtEuZW5rE2adBevnPsxuwk6RSn+w9Qm/GOZPUsiX79KM9vD45wxUeguHQlE9lBKdUOJYycU8U4JLmmEmRD51ieZW16uPJ5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715551; c=relaxed/simple;
	bh=GlC20mb/ib11VXcLu7Xcfv/nt7hcGX1zn2K7THOGMNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OkjUmA8VMTY7XxbIr7dd4T7bTxIiKOdCBbA4FS+ZUXj6pgzH3aZeuvQS6Sht+2Jrb+uwPrZCzWaZ5q3i9KD+wRZ9sy3I+rdmOH72J+Eey6kDWe8pVUR4dLH0oqkzZ0Jaw0BFTyITjZATSMzhJgAWvSxaIrmoo53Q5wS7xz2fTP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q9e1MVvd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q9e1MVvd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B67CC3277B;
	Tue, 18 Jun 2024 12:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715550;
	bh=GlC20mb/ib11VXcLu7Xcfv/nt7hcGX1zn2K7THOGMNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q9e1MVvdeDRfJ2ne7Z5UO+CpyyYuN04LM/GWXGdL0TCkCynY2s8czn69i7p9Ucajr
	 Jt99etueP5EiRlZzyuVU+SjwXNl62Ypo9a8S5F40Hj9eaSCAI7N6PGn7xVBctOnS3Q
	 APjxEaeJvEVgGqFbZep0AMBUHnkb92LCJVj0f1Uk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 315/770] lockd: Update the NLMv4 void arguments decoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:32:48 +0200
Message-ID: <20240618123419.415682159@linuxfoundation.org>
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

[ Upstream commit 7956521aac58e434a05cf3c68c1b66c1312e5649 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/xdr4.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/lockd/xdr4.c b/fs/lockd/xdr4.c
index 5fa9f48a9dba7..d0960a8551f8b 100644
--- a/fs/lockd/xdr4.c
+++ b/fs/lockd/xdr4.c
@@ -18,6 +18,8 @@
 #include <linux/sunrpc/stats.h>
 #include <linux/lockd/lockd.h>
 
+#include "svcxdr.h"
+
 #define NLMDBG_FACILITY		NLMDBG_XDR
 
 static inline loff_t
@@ -175,8 +177,15 @@ nlm4_encode_testres(__be32 *p, struct nlm_res *resp)
 
 
 /*
- * First, the server side XDR functions
+ * Decode Call arguments
  */
+
+int
+nlm4svc_decode_void(struct svc_rqst *rqstp, __be32 *p)
+{
+	return 1;
+}
+
 int
 nlm4svc_decode_testargs(struct svc_rqst *rqstp, __be32 *p)
 {
@@ -336,12 +345,6 @@ nlm4svc_decode_res(struct svc_rqst *rqstp, __be32 *p)
 	return xdr_argsize_check(rqstp, p);
 }
 
-int
-nlm4svc_decode_void(struct svc_rqst *rqstp, __be32 *p)
-{
-	return xdr_argsize_check(rqstp, p);
-}
-
 int
 nlm4svc_encode_void(struct svc_rqst *rqstp, __be32 *p)
 {
-- 
2.43.0



