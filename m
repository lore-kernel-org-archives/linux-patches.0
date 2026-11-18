Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050130;
	b=KBEWjvLcIkBBSdUnl+ubKJJt20lj3Qbndo9qUVmkDx/hAt5gXf1aD00JfeKQ3NX0nLA4
	 znVBapLMgwN0KN9ZvYHtZKGioPq6G8lJTDqI6qaycCETLwtk5B1R//82YMBNSxipL+rP4
	 ktWB96A+NvMZ5qtzdSIduLi8h4DBzSSrkJ5ryV4oEtCJLe2pCB+5C6pHs9AKULDOlxPHx
	 vActHHLaKlyngFvlqYsvJ4Kw9FN3eQRwyMsOV48IH2598aNqH7VkIwyAz7HAYpcY+uA2v
	 Oxjd6McdcifAeMh0e+jKt3Ui9YmH1v5VE/doFUXnVuOkyldRXkDAC5OpXki72jDm+DA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050130;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Pnp3X07TNofClwZM+dJosiqIW9t0WjKuJsItcCUxa8k=;
	b=5gU85G0eMRTLSmj4iPMiFYYWnD5kkJA1HnN2R+PON6Uc0YBzmOhkMF3JJ/YqiZSZg4Oa
	 j41OejsqHuRx/mQV2xX7d5uccA1kIGFyUmi7rBxyudgCdW8CzkcIQImLErbnUmdWs1tF5
	 oWqCw74fZZbwm9Mp8BDG/QUmc6I0Hh7keJ27NgAISqKShKFNog9tFJGuRsXUlY6qh/KDA
	 UDXbRFPO9m61WE7sQ6K2AVguTim7BM3XOJ5YTtGq7Yo/T8ya7QzLkYWM0VQlhHXCeoe4M
	 cSr2YqmlxbKe1+ZdsA7zamku+6owVjEAQP5JfySjtr38d3oI9ImIv2NEKxKYxjuvcxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uruLj+Oy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0A0606A31C;
	Thu, 19 Nov 2026 01:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uruLj+Oy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B26E71F000C4;
	Thu, 19 Nov 2026 01:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050130;
	bh=Pnp3X07TNofClwZM+dJosiqIW9t0WjKuJsItcCUxa8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uruLj+OysEuyljyjk4cOzhD5XphZPBDynUYc7mS4lOH+XgLMv/8+qyYWBKaJAM7dr
	 VXJi6JBhwJ0ZoZ5zS5oH9o8uiSI+IFlgFehf01W9j5HqE270SN1SgVADKWLuWJnzgs
	 2lg/GAxUtlk05hAXqQbRhjX9OJ4F+bhIVlj2pCNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2598/2857] netfilter: nft_compat: restrict raw table targets/matches
Date: Wed, 18 Nov 2026 16:00:32 +0100
Message-ID: <20261118150335.083669742@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 67a138b9be3a6..247d9229e30e6 100644
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



