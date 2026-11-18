Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061864;
	b=wQ9Uk6LV9fkcOzvGh5C+8/UBSEvEphBn40Q+ok2imfuP/dv2bx3g5INMFYzyYgt8z/J4
	 XzWrQpQoJXjNV8WVawUPDlr/PaENrOHf9LE02YD0RiwVugG+nMivaSnoj8OuUtkZBeO6W
	 EFXSaDjgzAX7hffVNAwWS96hVbxKfogbV6ftZLftygtEnp4C5xVkckn7fI3Hgq9BU1uc5
	 xtRn/5YtTW85YVuk9hJri+KFGbxYMy9PkXsLRl0ZltfjKAWs5kyLhl6P3uvvghXYXTIzD
	 8cPDCmKKd4vqkqkBurEToD7Bf+/pCzKd+UyEHy15SliXW/mFzlv2m9NgkJE/GefKG/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061864;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q4RNeizIq4ckdVsabUEGbQA3om+mNEhi4tjS89ldc9Q=;
	b=Ifv8sm6IjIAKS4SnK6if6o2IpgFNHrVuzolc2W3laVujpgPWGS0PJjrhYRu+i9E3pzfE
	 dy/Vut6PCd8riX3lTmRS+Y1ukpVABgF74pwe4jgg6oi+WDbItUNhbmgr+lRw9zJXmwEoQ
	 INavYvO57g+bONWTkGVXTSrjSWwFEzOtBeXMB35vqyjG7FGKcXLyWEqHxSYHAmz6qKwfg
	 TL70v6bYvKgc0lqDQSVFMI6obwR4qf0kk5H8wU3ag9vF5GRLQ0ERw/OlNcELrSFFoJiNM
	 dGFUExun2gygxQp24XmctBYTrdynPMGcliAV89Q0Ht4CuYTfMjXqeympklEs1yf8EeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="DF8/yN00";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CAB8606A320;
	Thu, 19 Nov 2026 04:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DF8/yN00
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B61A1F000C4;
	Thu, 19 Nov 2026 04:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061864;
	bh=Q4RNeizIq4ckdVsabUEGbQA3om+mNEhi4tjS89ldc9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DF8/yN00CW7ssBzWlkZpZ9PZuw+5bBunmTb6GOotpLBIo5uwzgFL5YHsROj7pg1tA
	 CbM7I3S1CHMfWZEl5V0oKJISVt22JgmHM5aJ2gmd/VMd4uYeFNISDd/xLJqLF98KVb
	 uEm9He4FpHDtsKtgFHsQdnk00A8IweyPAZs9b4MM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1705/1848] netfilter: nft_compat: restrict raw table targets/matches
Date: Wed, 18 Nov 2026 16:02:23 +0100
Message-ID: <20261118150031.102256479@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
index 3e0a6e7930c6c..73c769560d4e9 100644
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
@@ -44,6 +45,20 @@ static int nft_compat_chain_validate_dependency(const struct nft_ctx *ctx,
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



