Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056563;
	b=iPoxD7mW45hEHdHYy9VlyQW+g+Y7rmdxtY4WPkDatRPjiHR05T1AWU4CqFwrhyYLoYxN
	 Y95tdjkqaF3Ix2PIOT5Q9Ai30wMCXDiPZ/gWUiS1KMrstuwXLxIepkuETYyOnIRgw7YFe
	 PVp/iSUmf/GMUOxsXAxf+FtyL5rwL7jd0F1gsJYcPZlfEtwSMebNvoY1MSxir6c7U+mR1
	 ODyC6qntCDdaQ0TbvG7ZexJIZTLnSKNVL5J4R1JCVRGi9XbRgBC5hRNswUNUkubuvTf0M
	 OKXDq92x2FMLSQmqEa6U+0cKd4AvqFmuFQ5kDMzGI1Q+39X8sAWW0MIqF6c1e0gIoAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056563;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xnPZOOdkHnN23RSJFkmUMuIiHYQdAMxDf2YEBpsvcHc=;
	b=1z6ULxzmuniB3J+GvcGsrWuc51a8q0wypXf1ni4R20yVpfkbkqfo0f61QNSPz0FEF+rg
	 GclKzZH7buiwjEiELyzjfR0ZTY3dX10vt56Tk0GcH5kndx+Xsh1/gkR0d2DKkQo5Lx8+c
	 +0KKvxkue5Kvw0UekkujvRRq7ZlOsETbYumVwfPOBrylq7pAWVFtAHrz0BpFECke/xIXg
	 voawnRbSa7DdyA855m/no51H4q+7pzfviGDBlkbcMxXMPTXWhoJcLB0ba5qICq2IcRkYr
	 5gjOl2cAswM2cOLd6QtNc/Yw80RoyzEyHHyDfGQH4MlM/zUteFjPaVkTh4jDUKID25g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sxyNWUMj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F067606A31C;
	Thu, 19 Nov 2026 02:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sxyNWUMj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D03531F000C4;
	Thu, 19 Nov 2026 02:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056563;
	bh=xnPZOOdkHnN23RSJFkmUMuIiHYQdAMxDf2YEBpsvcHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sxyNWUMjN5EmvohjUVRYFMn5R4r1N3A+3mA9M9/qGVAp/KSLhO4dSgqi9sMj0tZ1c
	 i0YVEjuA23hBmOPdyM+SOARd8VoWsoco4pdtZN43aP88LEGEeZtc/JTeLZh1AOw113
	 gcYKmr07VpjDf+jU/m5z8YJ41TmvB4tL8kzFmkUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2030/2214] netfilter: nft_compat: restrict raw table targets/matches
Date: Wed, 18 Nov 2026 16:01:46 +0100
Message-ID: <20261118150131.965273998@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index aee046e00bfaf..86ab67691a21b 100644
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



