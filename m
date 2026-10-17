Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3517385D7B;
	Sat, 17 Oct 2026 16:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255660; cv=none; b=Y5VXkXK2gO3tLkkH8FqNoUBMDa4a+fEzdAWejnG73ZzIWwIlTdW2hB+BXcpq5cd4M48rMc5O3/z0gf5UixKyq3w6hM6RAfaOFdAFHgSUkCc9Xz9gwMBTbOaS1yReI97XZ6Md7kGguRzKS07VyW2s0Yfiqv6tH9iAqTQKfmSmjYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255660; c=relaxed/simple;
	bh=Mk6M0bSDv18/JD+sqV39nY3PJ+hoeBTnk0P0Nq/1mc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E+qRIyXu4KxRe7vcXiIeuQNtJUxxQHtztZgRfbscoWtI14KO5GJ/gNo8QyuylphVStdZE5m5IKgo6o1GWdYEDUuWegQyhl9BqiI5OqxmDQ9AcOoo+oRMB5iRq0/fq5fylIThVdFcQlzkhrMbH4YNXhdeM6gBBk3nMuQ0NmrMbiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZNCU4VjY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZNCU4VjY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4A41F000C4;
	Sat, 17 Oct 2026 16:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255659;
	bh=1nZBAsds+YHJeeyFdfqc8PaYM5IvgE1kLAG/rExvu6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZNCU4VjYLDjiJWRBRgSkyltZXSNPmBxsJWb30NcKn2wyQENOjyg9qMfOAtpVjC5Er
	 bPXFzKAvPy7vuHNafi8hNr/3X8JUWrIBkdOadzVqE9gsRimTSIzofueWBSCGgg6MRK
	 c5VR6v3SRQaIzR9E+B7PkEAhTrjMNPbE8Rp7fFQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 850/869] netfilter: ctnetlink: do not expose expectation DEAD flag
Date: Sat, 17 Oct 2026 18:01:31 +0200
Message-ID: <20261017160058.657322916@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 322371b09058ad10d0282a0e7ec8eaa764e6aaac ]

Expose expectation flags included in the NF_CT_EXPECT_MASK bitmask
only. The DEAD flag is internal, do not expose it.

Fixes: b8b09dc2bf35 ("netfilter: nf_conntrack_expect: use conntrack GC to reap expectations")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 1c2bb4ee84ac2..60a4fb4088963 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3045,7 +3045,7 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
 #endif
 	if (nla_put_be32(skb, CTA_EXPECT_TIMEOUT, htonl(timeout)) ||
 	    nla_put_be32(skb, CTA_EXPECT_ID, nf_expect_get_id(exp)) ||
-	    nla_put_be32(skb, CTA_EXPECT_FLAGS, htonl(exp->flags)) ||
+	    nla_put_be32(skb, CTA_EXPECT_FLAGS, htonl(exp->flags & NF_CT_EXPECT_MASK)) ||
 	    nla_put_be32(skb, CTA_EXPECT_CLASS, htonl(exp->class)))
 		goto nla_put_failure;
 
-- 
2.53.0



