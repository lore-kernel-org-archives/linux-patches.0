Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831170;
	b=IYtvrGhk5kmMJ8/FVAHVX+hDKYiXwjHKNC0O8AkIBh4w2jos03sagb6eOy6yssP5nfr7
	 qJlycGD3Z3NCOEpPQVxF/HeaHdMEE2oLoPagQWPuM3rnXmnPtawUskcsDlxPPqj8yvvgr
	 ziPmSjpwEFDGKn7eUeCeDVvShSoK6HlISFVbELJvBqXOY5LfbHXGE0Jt2LZlXskAxfSrz
	 +1WBkDjl5PKzj8Ksh0DAs2j2z7NJy7qSVljdE+jy06G1vOIUVfu6T+EVyCD03K+S1nLF7
	 x8kw5vyGGxkbGD6JHTGXZaPQchZV0tp+snbccDAOkxplfm2WJU5RG3UvQaNbsnRqJoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831170;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mRaMyf1qMjSBTuDb1BioyxXKUPbLbHakwxgScxHEUAs=;
	b=OTpbGuOIeq5Xk12iCf0hp4HTYxyXsfEJ4KSScg99YbLhwis8m09Z5w5+9okjIpn837/R
	 bkk1DBTDSehRjATWa+nhhiB/ghzLf/7cXKZ52kDnMVMoY1N2+0RYhyYe9O5sxgEDxDpbk
	 15QRWmbPKhuvcbL/XpzOdmPGWBjH3Sk/WdJHGtTu5tAw7tteIVyfgMvQtIpRZTFuuW7A4
	 xKs5YgwXtRdza7eHeBYXKZNKnL66ixBNO7IWiF0yBMlSJBL+Ga2nYhCx7NXsh8atcv7MW
	 dTw+v2IURAvkvHyGZSYuwuHU6F+m1wmiBuDQZ6Q4QXcILTlCfsQxSNSHWnOvTfXF4SA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XC4MU987;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2004606A845;
	Wed,  4 Nov 2026 22:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XC4MU987
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FE6C1F00919;
	Wed,  4 Nov 2026 22:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831169;
	bh=mRaMyf1qMjSBTuDb1BioyxXKUPbLbHakwxgScxHEUAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XC4MU987Lfji0NvhoMQ8ESRzKgNc91zvw8/rkjKdm6eZWnBCBYsLGgxCFSlw4Fxvg
	 7pT28uPPpvl6Kfb6Gt+swwUITpvsq75uROlSiRRbwEzs2BKASUdHa/K60RuHXxYWAc
	 Z2i86RSmLBTTrrgMmql6lUgiFTebswWrirGQY63k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0539/1005] netfilter: ctnetlink: do not expose expectation DEAD flag
Date: Wed,  4 Nov 2026 16:04:32 -0500
Message-ID: <20261104211058.990308505@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d7c4f34f1caf0..6ccb23a640d85 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3050,7 +3050,7 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
 #endif
 	if (nla_put_be32(skb, CTA_EXPECT_TIMEOUT, htonl(timeout)) ||
 	    nla_put_be32(skb, CTA_EXPECT_ID, nf_expect_get_id(exp)) ||
-	    nla_put_be32(skb, CTA_EXPECT_FLAGS, htonl(exp->flags)) ||
+	    nla_put_be32(skb, CTA_EXPECT_FLAGS, htonl(exp->flags & NF_CT_EXPECT_MASK)) ||
 	    nla_put_be32(skb, CTA_EXPECT_CLASS, htonl(exp->class)))
 		goto nla_put_failure;
 
-- 
2.53.0



