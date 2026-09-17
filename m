Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD465547041;
	Thu, 17 Sep 2026 18:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671572; cv=none; b=eXcmFCxu8W40spDZuirVJ9JDRsgL8MBoXZFEVNq8cN7grotxfd3N4dmg6Zqs5k324+RudZoUepmshlhgLuJ/6CLRZQM33gYw/+uct1tdjZ7xtOALPoGr0CujhAwrguwfxj+MLgyoDKWCYVnTye7ILqnM913NhTp287mLgzge46k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671572; c=relaxed/simple;
	bh=ApHs6VoKvIILHPE79ZDRh6ktgzShyEXpXIPtOOp3dhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jCXU8iahOpiaop84T8asbycxi49RXFjeZd7AnJ7mH302bpLNC70zwlHCIKsEU4fQcqWwgHjdZ/iWU4Atoyc/QWIpIM4VylcjKk8eRgkKUKikNswes9UzuVX5xec6I0kE0tWORZ/F5erQpxyQpfz4J/Gwf2qCJVPpT+yyTaKz/V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Um83DH1k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Um83DH1k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F166E1F000FF;
	Thu, 17 Sep 2026 18:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671570;
	bh=CaNDclD/kQABpR2J+nqvR8rS5mir2zVfXFk5HFDM8CI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Um83DH1kbVR286l2n8Y0dImZ0NgVGUbJMa0TCwd9Mjcg/yuop+0O4xpIPfkbKrR2H
	 6meApVxchhzn01REr2f/44F/nCImtGftI5Fejw0M+gTCTXi3i5tseRpyHHFjOe9gBH
	 DG1MX+qzhmk39GVgJuS1nU/OTxznWE4gjnQFxUzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1021/1102] NFSD: Rename a function parameter
Date: Thu, 17 Sep 2026 16:16:04 +0100
Message-ID: <20260917151606.390650278@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 71bc2c6c413b78e5a47b4a62284f712d9f719007 ]

Clean up: A function parameter called "rqstp" typically refers to an
object of type "struct svc_rqst", so it's confusing when such an
parameter refers to a different struct type with field names that are
very similar to svc_rqst.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: a99d720ed2a5 ("nfsd: widen nfsd_genl_rqstp address fields to sockaddr_storage")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsctl.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1494,7 +1494,7 @@ unsigned int nfsd_net_id;
 
 static int nfsd_genl_rpc_status_compose_msg(struct sk_buff *skb,
 					    struct netlink_callback *cb,
-					    struct nfsd_genl_rqstp *rqstp)
+					    struct nfsd_genl_rqstp *genl_rqstp)
 {
 	void *hdr;
 	u32 i;
@@ -1504,22 +1504,22 @@ static int nfsd_genl_rpc_status_compose_
 	if (!hdr)
 		return -ENOBUFS;
 
-	if (nla_put_be32(skb, NFSD_A_RPC_STATUS_XID, rqstp->rq_xid) ||
-	    nla_put_u32(skb, NFSD_A_RPC_STATUS_FLAGS, rqstp->rq_flags) ||
-	    nla_put_u32(skb, NFSD_A_RPC_STATUS_PROG, rqstp->rq_prog) ||
-	    nla_put_u32(skb, NFSD_A_RPC_STATUS_PROC, rqstp->rq_proc) ||
-	    nla_put_u8(skb, NFSD_A_RPC_STATUS_VERSION, rqstp->rq_vers) ||
+	if (nla_put_be32(skb, NFSD_A_RPC_STATUS_XID, genl_rqstp->rq_xid) ||
+	    nla_put_u32(skb, NFSD_A_RPC_STATUS_FLAGS, genl_rqstp->rq_flags) ||
+	    nla_put_u32(skb, NFSD_A_RPC_STATUS_PROG, genl_rqstp->rq_prog) ||
+	    nla_put_u32(skb, NFSD_A_RPC_STATUS_PROC, genl_rqstp->rq_proc) ||
+	    nla_put_u8(skb, NFSD_A_RPC_STATUS_VERSION, genl_rqstp->rq_vers) ||
 	    nla_put_s64(skb, NFSD_A_RPC_STATUS_SERVICE_TIME,
-			ktime_to_us(rqstp->rq_stime),
+			ktime_to_us(genl_rqstp->rq_stime),
 			NFSD_A_RPC_STATUS_PAD))
 		return -ENOBUFS;
 
-	switch (rqstp->rq_saddr.sa_family) {
+	switch (genl_rqstp->rq_saddr.sa_family) {
 	case AF_INET: {
 		const struct sockaddr_in *s_in, *d_in;
 
-		s_in = (const struct sockaddr_in *)&rqstp->rq_saddr;
-		d_in = (const struct sockaddr_in *)&rqstp->rq_daddr;
+		s_in = (const struct sockaddr_in *)&genl_rqstp->rq_saddr;
+		d_in = (const struct sockaddr_in *)&genl_rqstp->rq_daddr;
 		if (nla_put_in_addr(skb, NFSD_A_RPC_STATUS_SADDR4,
 				    s_in->sin_addr.s_addr) ||
 		    nla_put_in_addr(skb, NFSD_A_RPC_STATUS_DADDR4,
@@ -1534,8 +1534,8 @@ static int nfsd_genl_rpc_status_compose_
 	case AF_INET6: {
 		const struct sockaddr_in6 *s_in, *d_in;
 
-		s_in = (const struct sockaddr_in6 *)&rqstp->rq_saddr;
-		d_in = (const struct sockaddr_in6 *)&rqstp->rq_daddr;
+		s_in = (const struct sockaddr_in6 *)&genl_rqstp->rq_saddr;
+		d_in = (const struct sockaddr_in6 *)&genl_rqstp->rq_daddr;
 		if (nla_put_in6_addr(skb, NFSD_A_RPC_STATUS_SADDR6,
 				     &s_in->sin6_addr) ||
 		    nla_put_in6_addr(skb, NFSD_A_RPC_STATUS_DADDR6,
@@ -1549,9 +1549,9 @@ static int nfsd_genl_rpc_status_compose_
 	}
 	}
 
-	for (i = 0; i < rqstp->rq_opcnt; i++)
+	for (i = 0; i < genl_rqstp->rq_opcnt; i++)
 		if (nla_put_u32(skb, NFSD_A_RPC_STATUS_COMPOUND_OPS,
-				rqstp->rq_opnum[i]))
+				genl_rqstp->rq_opnum[i]))
 			return -ENOBUFS;
 
 	genlmsg_end(skb, hdr);


