Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3352715532E;
	Tue, 18 Jun 2024 12:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715420; cv=none; b=c7OlIN82DzJFsY4eE8zs/vVjgNVxjs3UdoXGiC6STCQ/Rz5mdugfS2YWvTbvJ01DPSMoCaEWdBXqLMYb/+9Sh2aOwUgJ7Dy09EU7xek94RGW9XFoa1cH6G8o0LdtgBUyOpKIWmJvfp0zIRBv4cgiAfr/bVmpYyfEUxn38tOG0VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715420; c=relaxed/simple;
	bh=QA8OIJ37gn14dEE43FftLCeuDrJ6Hrmc//SzXd3EBQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WVOUqEuuNPjoN8wGS6D+cHwmE76IotvhxD2oVNq9MmAM/mTJC5T6C9/PqHciyEvvLo+W7zJIcqFIUt8mSlHFqdB6oYUL8LbKeVBn0bI1JBVqo3pcjdhFa5YavT7aObtubJb1t+rSVjVhwNO+fprTzEbLDOIULEaLOfadTV23DXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wgYJnBgg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wgYJnBgg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C756C3277B;
	Tue, 18 Jun 2024 12:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715419;
	bh=QA8OIJ37gn14dEE43FftLCeuDrJ6Hrmc//SzXd3EBQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wgYJnBggAPwrZklYnnykV8YnQvqSOT+O4/xPgVfqIfFry2xd03R4qLQTJWWGzmSnM
	 cDl3bOTV5VDO1od/fcMpZCNPhMbxx2H8NzZ6Uz+hyh2NsXvmN8IhX9hJaBYL1EwZUH
	 WKUtdpF3u5KjQ5zNH3u0tVg7qxpb4NtZAJ9TqPAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 302/770] lockd: Update the NLMv1 void argument decoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:32:35 +0200
Message-ID: <20240618123418.921211657@linuxfoundation.org>
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

[ Upstream commit cc1029b51273da5b342683e9ae14ab4eeaa15997 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/xdr.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/lockd/xdr.c b/fs/lockd/xdr.c
index 982629f7b120a..8be42a23679e9 100644
--- a/fs/lockd/xdr.c
+++ b/fs/lockd/xdr.c
@@ -19,6 +19,8 @@
 
 #include <uapi/linux/nfs2.h>
 
+#include "svcxdr.h"
+
 #define NLMDBG_FACILITY		NLMDBG_XDR
 
 
@@ -178,8 +180,15 @@ nlm_encode_testres(__be32 *p, struct nlm_res *resp)
 
 
 /*
- * First, the server side XDR functions
+ * Decode Call arguments
  */
+
+int
+nlmsvc_decode_void(struct svc_rqst *rqstp, __be32 *p)
+{
+	return 1;
+}
+
 int
 nlmsvc_decode_testargs(struct svc_rqst *rqstp, __be32 *p)
 {
@@ -339,12 +348,6 @@ nlmsvc_decode_res(struct svc_rqst *rqstp, __be32 *p)
 	return xdr_argsize_check(rqstp, p);
 }
 
-int
-nlmsvc_decode_void(struct svc_rqst *rqstp, __be32 *p)
-{
-	return xdr_argsize_check(rqstp, p);
-}
-
 int
 nlmsvc_encode_void(struct svc_rqst *rqstp, __be32 *p)
 {
-- 
2.43.0



