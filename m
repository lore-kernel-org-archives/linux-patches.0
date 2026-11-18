Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041997;
	b=I9mfjr4raSVj5zgjpIF5ykYzSNaY8TaHrOzCT2JuF4lawQ0XEW9R14Ijjc6+7ebipsF2
	 eWWBRQu4gq13QEnPaJYGUZMC8cHS7pF1SBdTPU5p6HBrEEWoYH8In7nzSnHuB+TveHyn6
	 GmeE2QuN5cUCMNZQrJ7k4zBCcd9keq6DjisMRLbUm3H19axI2ZSSZ3MBtDK03SqLvxur2
	 0pG6iOczPbuVq+HLxGyT8f77Oh5rCtHB0xTSE1ExiulavgTCafIpbxOGs+Yi+C+sFsqS8
	 lF9zcJ6lKaV7+UW5OpI6r+i7WvZD8by1icxPClFSwJF/KhMyveN7bZk44v0sh2LvC0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041997;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hErVeDsGpnt14WwVHgVGKus+4yXn42j4Xl2pQcyi71I=;
	b=esxOQlP/6xhwgMTyrIXe/IfASkHkKJzTIoHY3RyAWUKq6TPQGFF5pFhSRqAPCXrPV1CR
	 iIgciCQuLlAqNu38vn3kJy1M3wpPHbPAh1wKUD/i/T/BzJ+aUSarpguUjJhzWgXKB3P93
	 /yNfFjHmGLiCmqP9y6rxoriESbbfZASm1uqNMJ6frchSjXZGK2/KcaeHc6V9bk4AvIdi5
	 9dBrypaw6aZZ00Q8WyCMPNGjP4wcLNuxd4Rwp4GzuqbY+Mg8/kfruBcW3S8WsE/+1d0sH
	 IXGhS43z8+hPXLLo7oAqKTFQej313hi+YVOV6Pm16aPCwo6nx4Nf0fjvTIHchoj8WIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=twH7EPEY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1999E606A32F;
	Wed, 18 Nov 2026 22:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=twH7EPEY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B3071F000C4;
	Wed, 18 Nov 2026 22:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041997;
	bh=hErVeDsGpnt14WwVHgVGKus+4yXn42j4Xl2pQcyi71I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=twH7EPEYf+VPEpIEpE1PgRkSMOBS8WMjlcL4Q3uXuBcW9vMZicI+Fw4z999X0v9Av
	 Ajiur0QfwF9HgWsOGY4JXDOPCVkygTibSsqyHiAbTRHYyXAHwCePGGvIswFC7zKAWs
	 nr0EmUhbgl7pmUku8dEAMCiMmQJ45uYxTGdfq+mM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3012/3318] netfilter: nft_compat: restrict raw table targets/matches
Date: Wed, 18 Nov 2026 16:00:34 +0100
Message-ID: <20261118150450.590606425@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit ac364eb4d6d747b15df17e5fc9e442c318afaaac ]

xt targets and matches declaring .table = "raw" (CT, NOTRACK) rely on
only ever running in the legacy raw table's prerouting/output chains,
ahead of conntrack. nft_compat_chain_validate_dependency() already
enforces this kind of correspondence for "nat" by requiring the chain
type to actually be NAT, but did nothing for "raw": a rule wrapping
the CT target could be loaded into any hook and any priority via
nft_compat, including after the real conntrack hook has already run.

The CT target attaches a conntrack template to the skb when none is
set yet.

Require that a "raw" table dependency actually matches what xtables
enforces via the implict/builtin table dependency.

Fixes: 0ca743a55991 ("netfilter: nf_tables: add compatibility layer for x_tables")
Assisted-by: LLM
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_compat.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 0dd3379aef164..ce3deed0240c7 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -14,6 +14,7 @@
 #include <linux/netfilter/nf_tables.h>
 #include <linux/netfilter/nf_tables_compat.h>
 #include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter_bridge/ebtables.h>
@@ -45,6 +46,20 @@ static int nft_compat_chain_validate_dependency(const struct nft_ctx *ctx,
 			type = NFT_CHAIN_T_NAT;
 		if (basechain->type->type != type)
 			return -EINVAL;
+	} else if (strcmp(tablename, "raw") == 0) {
+		/* iptables-nft emulates the legacy raw table, which only
+		 * ever has prerouting/output chains at this exact priority.
+		 */
+		if (ctx->family != NFPROTO_IPV4 &&
+		    ctx->family != NFPROTO_IPV6)
+			return -EINVAL;
+
+		if (basechain->ops.hooknum != NF_INET_PRE_ROUTING &&
+		    basechain->ops.hooknum != NF_INET_LOCAL_OUT)
+			return -EINVAL;
+
+		if (basechain->ops.priority != NF_IP_PRI_RAW)
+			return -EINVAL;
 	}
 
 	return 0;
-- 
2.53.0



