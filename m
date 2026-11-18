Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032458;
	b=Pvsn2xxUfnuRx/f30dt1wny0W4wRfPkWk5I+wHyuiP9I9IY4rZd5iWJK+aAlTPiDayma
	 50mfgsIJkz5Zzc8/E1ePglnNmfZI2o9gxt45pSIelIoh3thZoU5ZpyCo1txjuirFkOZrN
	 QVmggRIIILImuaj2OyNIajTUq1T7CwdIsCncgcLiD1n6l5Qz2xxI7ybKofWkEVkXIs5bm
	 Ozm03l/sMnl2YsJ+sunqtyNn/RCP3v/uPvqrP2IaSy6kM3vg+11T8DQPYtJuDLxZIIZSI
	 Y7EQzxRYv+q4cxdlHELUSUaf9zs1UttF3EFKQDyHF0bcUxbZqBXR60bD51FTjPHxI3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032458;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iwJkH1TBduO0TO4r8ND0ymxd+sUau0GEISDHPN/YyDE=;
	b=uwjOz32XsVVurzvABUc6ZQbpK4tP+e6/ppv33YA+N6GLUUFhHbC2QhQd2xFteb3p5FxL
	 y5f52QGLbcwukvSi6rh5Qj7EM0430/KofCWKCFcamnBdoRZRSC/RII/JuJIXzFgXrxfOi
	 yz4Xo39AUeXTm4f1CfDVJp1ezAmlqrX04aFWGMaUr1fzfNFIJwdVQtBaUyAyM09HPArv6
	 xbWW90oMvsQNGR/X6zMjVrXS29y0LCVooWiqKtxxZwD9KNIVRISXhlDp9l/l0ptq931nJ
	 i3fq0Bz22hAbQMzQf3ykhjZd74qTJfHjbUV7RNWSe34c9c9UdMXvV4QF5uDFiRe4mWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lskaRvyR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABDE4606A330;
	Wed, 18 Nov 2026 20:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lskaRvyR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E051F000CA;
	Wed, 18 Nov 2026 20:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032458;
	bh=iwJkH1TBduO0TO4r8ND0ymxd+sUau0GEISDHPN/YyDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lskaRvyR0X+yaG1cBvWbyRcfjUG/GhWTUuGgXeTDfBC3SHu14K1AhCh3iQtnu+1NX
	 uelEB8govf3bBY96+C0Iyqe6YtoFqser96o2hAgOhDLuLbPD7wqEtZi+/XT4w1Zp0f
	 MrG/N+0opJY5P4vNNQxlxf1fDD5adcFnfuStf9xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1377/1756] netfilter: nft_compat: restrict raw table targets/matches
Date: Wed, 18 Nov 2026 15:58:24 +0100
Message-ID: <20261118150104.022016858@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ba4d304a30141..2bac958f15266 100644
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



