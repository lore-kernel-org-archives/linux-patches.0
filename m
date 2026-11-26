Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704391;
	b=utk1J9f9mfslAA7M5u9iWp6SBJmr+yZF7dSbeoV4EhygwH0rq0Qd9PQUj6F3jeSd9Mck
	 3CsTcHpr42D2qbaU6Q1P1/vlNT8NLKO2yED2O2SPJxuN79GhFlqXDUMeewFCKanlLsiRs
	 OLnMVWDj/QK515tiNzL7lLt2pT8DWgkZkKPPYB9+kObzjxqxwjA2/bdXMGUYC7Slwi/B1
	 qQMMWHMnPxNMLjWG66JCHHKKBmaOtj41UbvEvQHsAw6R2WcyLf4GM1He4t2kxO7fipqd6
	 2GCMYE6sOEZhYRIctxRNM6LF9SXRY6YAuQn4a8TX6BmSBVHBxNL3i78S5NiHEwV0ZuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704391;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Tjmp/htOyy4oVHLtyBxPUFOrHjPdMM180Js9jVX8uJs=;
	b=slmMhQt0SmtTaeRa3P7pNflmMI0SIpu2l1CXVA16fX81UtRjweUUgRmiEwA9Y4Gtnhht
	 sud8bQghl/8Tj/DG5cvMO9Jfz9SokV1eePdmd5+cNBoIYFZG1meYsQ+ca5dXHbu/6dKZi
	 3Bu7y4pDeRPpBlivanYRNB/Wsansu5yiZQ135xNZG7A7RHDxRw4sLlnliDznMk4csDsrw
	 MgabqcVIXhAJPdPo9Sy0bSDBluyLNxbbws7fkKEhKuTAR/RMcvHkY/SLkTDl94gHJIo5C
	 BjvNpyvzhJwg68A2ZbLy2ECNkRDnmChsDOhha5iX2aM5A/IZan4gnKZ8hclQ8Rmz6ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WttkaDSg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877CF606A327;
	Thu, 26 Nov 2026 14:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WttkaDSg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1341F000C6;
	Thu, 26 Nov 2026 14:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704391;
	bh=Tjmp/htOyy4oVHLtyBxPUFOrHjPdMM180Js9jVX8uJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WttkaDSgERJK/R39eVQue6rpazN8F08GDnKDAFwdbi0u2lAQSxlZj5rNq3pUyfVfY
	 QTX9o1VYIddFzxhLB/+konXslEq6PTKyiYbJeA8GDSY18A21vVTOKcTTNj5bZmjvly
	 1JXyUScvcLANiO178RmnOOpsb8g/Otb/3wltpaU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abaci Robot <abaci@linux.alibaba.com>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Simon Horman <simon.horman@corigine.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 109/265] ipv6: ICMPV6: Use swap() instead of open coding it
Date: Thu, 26 Nov 2026 15:37:19 +0100
Message-ID: <20261126143612.660885560@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit bc61761394ce0f0cc35c6fc60426f08d83d0d488 ]

Swap is a function interface that provides exchange function. To avoid
code duplication, we can use swap function.

./net/ipv6/icmp.c:344:25-26: WARNING opportunity for swap().

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3896
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20230131063456.76302-1-jiapeng.chong@linux.alibaba.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 30c71476d842 ("ipv6: Check the Home Address option again before its address is used")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/icmp.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index e8325d9780e99..714a7792c97f0 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -335,7 +335,6 @@ static void mip6_addr_swap(struct sk_buff *skb, const struct inet6_skb_parm *opt
 {
 	struct ipv6hdr *iph = ipv6_hdr(skb);
 	struct ipv6_destopt_hao *hao;
-	struct in6_addr tmp;
 	int off;
 
 	if (opt->dsthao) {
@@ -343,9 +342,7 @@ static void mip6_addr_swap(struct sk_buff *skb, const struct inet6_skb_parm *opt
 		if (likely(off >= 0)) {
 			hao = (struct ipv6_destopt_hao *)
 					(skb_network_header(skb) + off);
-			tmp = iph->saddr;
-			iph->saddr = hao->addr;
-			hao->addr = tmp;
+			swap(iph->saddr, hao->addr);
 		}
 	}
 }
-- 
2.53.0



