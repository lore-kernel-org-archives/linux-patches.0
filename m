Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042635;
	b=H5MgBrOl0/3leuvUAHodvvek7AqMTPzJvx03sY3akmYFLcDXPNTt+6T0nSgTy1veo+TX
	 U+6V+wRkkxe99/Anh+Ag6XwxlfG2Ou1mPG8DDjBA7lh2uhyovKqufgK7kjLztmWZ049TL
	 Uon9pMHbd31T5qPcWkYTiDUtG9M3yA3AjzxvGN8HfFlIHteKYEeaBA7HxMXcW9z36Q8L/
	 ny/sT19cANNmKlNBhJ18KPYdAGs2O5yzmkRxqoxXOD6Gee+q+lyfrOwoP5KBlSENJEMmr
	 MqnmVwU2/E5pRxR7gedcJd/jd26JPX2x+bUNFfn9jyKoE/Ped4ccT2S0LTsjCKpPo8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042635;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NtBWtf507cPLCwnkSszwrHEPgQjn8m5Tg+qdqBUvX+M=;
	b=KCqvih5X9d8U6SO61qU5FTLw/kloGCGh0gfBsQkCndSM1/FmWEifMqDjWA3o+rGQOAhR
	 XvCli7xoozxgwtfDXTmkt/LskW4xDZesx3GWP4AetX64+Xy4Tg8kryrM28wpmoP5hB+bd
	 DAmJIHi1ksZMDmQobc6PKQwstDmgaCf993JB6dswbtr7zCmBk8E4Z3pXRYC3g29xawedW
	 RPYCuIWq/6qCjtUiQCKA0RAcrGAQgQUQRSe4RfHNFqGGrKg0pD6dN6pY4G99nDtbOeUWj
	 Fz1Axpxz+y8ceOVOYi0OBtjKho9fhGVVtxrebvB5bVrZKn5pgVASZrd0tI07uhpWuLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pauylrcw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93FE3606A320;
	Wed, 18 Nov 2026 22:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pauylrcw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD9F1F000C4;
	Wed, 18 Nov 2026 22:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042635;
	bh=NtBWtf507cPLCwnkSszwrHEPgQjn8m5Tg+qdqBUvX+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pauylrcwi9ikaHryYU+RCrdMvU1U0OmVdMDgTpddwd8n0loYneGtUMVQkIivJZrpL
	 pGSByOkLU4NM8nIBYM4VEjgdGzYZPlnsuA9+SFR2tDoXsAP1jrfOaCUxPAFfVkWnRr
	 Xm2KYhFncnnzTdeIrY4EX2DBc9H3ofGwrlSN6Spw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3239/3318] bridge: add bridge_flags_bit enum
Date: Wed, 18 Nov 2026 16:04:21 +0100
Message-ID: <20261118150456.851366626@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 87020def2529ec26fc9077e889fa1c34f53f1f83 ]

We want to use atomic operations for lockless p->flags changes
and reads.

Add definitions for bits in addition of masks so that we can use
test_bit(), clear_bit() and set_bit() in subsequent patches.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20260604141343.2124500-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: fcc00b15cb21 ("net: bridge: netlink: do not clear the vlan info dump error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/if_bridge.h | 78 ++++++++++++++++++++++++++-------------
 1 file changed, 53 insertions(+), 25 deletions(-)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index ec9ffea1e46ed..75673b8bffcb8 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -36,32 +36,60 @@ struct br_ip_list {
 	struct br_ip addr;
 };
 
-#define BR_HAIRPIN_MODE		BIT(0)
-#define BR_BPDU_GUARD		BIT(1)
-#define BR_ROOT_BLOCK		BIT(2)
-#define BR_MULTICAST_FAST_LEAVE	BIT(3)
-#define BR_ADMIN_COST		BIT(4)
-#define BR_LEARNING		BIT(5)
-#define BR_FLOOD		BIT(6)
+enum bridge_flags_bit {
+	BR_HAIRPIN_MODE_BIT,
+	BR_BPDU_GUARD_BIT,
+	BR_ROOT_BLOCK_BIT,
+	BR_MULTICAST_FAST_LEAVE_BIT,
+	BR_ADMIN_COST_BIT,
+	BR_LEARNING_BIT,
+	BR_FLOOD_BIT,
+	BR_PROMISC_BIT,
+	BR_PROXYARP_BIT,
+	BR_LEARNING_SYNC_BIT,
+	BR_PROXYARP_WIFI_BIT,
+	BR_MCAST_FLOOD_BIT,
+	BR_MULTICAST_TO_UNICAST_BIT,
+	BR_VLAN_TUNNEL_BIT,
+	BR_BCAST_FLOOD_BIT,
+	BR_NEIGH_SUPPRESS_BIT,
+	BR_ISOLATED_BIT,
+	BR_MRP_AWARE_BIT,
+	BR_MRP_LOST_CONT_BIT,
+	BR_MRP_LOST_IN_CONT_BIT,
+	BR_TX_FWD_OFFLOAD_BIT,
+	BR_PORT_LOCKED_BIT,
+	BR_PORT_MAB_BIT,
+	BR_NEIGH_VLAN_SUPPRESS_BIT,
+	BR_NEIGH_FORWARD_GRAT_BIT,
+};
+
+#define BR_HAIRPIN_MODE		BIT(BR_HAIRPIN_MODE_BIT)
+#define BR_BPDU_GUARD		BIT(BR_BPDU_GUARD_BIT)
+#define BR_ROOT_BLOCK		BIT(BR_ROOT_BLOCK_BIT)
+#define BR_MULTICAST_FAST_LEAVE	BIT(BR_MULTICAST_FAST_LEAVE_BIT)
+#define BR_ADMIN_COST		BIT(BR_ADMIN_COST_BIT)
+#define BR_LEARNING		BIT(BR_LEARNING_BIT)
+#define BR_FLOOD		BIT(BR_FLOOD_BIT)
 #define BR_AUTO_MASK		(BR_FLOOD | BR_LEARNING)
-#define BR_PROMISC		BIT(7)
-#define BR_PROXYARP		BIT(8)
-#define BR_LEARNING_SYNC	BIT(9)
-#define BR_PROXYARP_WIFI	BIT(10)
-#define BR_MCAST_FLOOD		BIT(11)
-#define BR_MULTICAST_TO_UNICAST	BIT(12)
-#define BR_VLAN_TUNNEL		BIT(13)
-#define BR_BCAST_FLOOD		BIT(14)
-#define BR_NEIGH_SUPPRESS	BIT(15)
-#define BR_ISOLATED		BIT(16)
-#define BR_MRP_AWARE		BIT(17)
-#define BR_MRP_LOST_CONT	BIT(18)
-#define BR_MRP_LOST_IN_CONT	BIT(19)
-#define BR_TX_FWD_OFFLOAD	BIT(20)
-#define BR_PORT_LOCKED		BIT(21)
-#define BR_PORT_MAB		BIT(22)
-#define BR_NEIGH_VLAN_SUPPRESS	BIT(23)
-#define BR_NEIGH_FORWARD_GRAT	BIT(24)
+#define BR_PROMISC		BIT(BR_PROMISC_BIT)
+#define BR_PROXYARP		BIT(BR_PROXYARP_BIT)
+#define BR_LEARNING_SYNC	BIT(BR_LEARNING_SYNC_BIT)
+#define BR_PROXYARP_WIFI	BIT(BR_PROXYARP_WIFI_BIT)
+#define BR_MCAST_FLOOD		BIT(BR_MCAST_FLOOD_BIT)
+#define BR_MULTICAST_TO_UNICAST	BIT(BR_MULTICAST_TO_UNICAST_BIT)
+#define BR_VLAN_TUNNEL		BIT(BR_VLAN_TUNNEL_BIT)
+#define BR_BCAST_FLOOD		BIT(BR_BCAST_FLOOD_BIT)
+#define BR_NEIGH_SUPPRESS	BIT(BR_NEIGH_SUPPRESS_BIT)
+#define BR_ISOLATED		BIT(BR_ISOLATED_BIT)
+#define BR_MRP_AWARE		BIT(BR_MRP_AWARE_BIT)
+#define BR_MRP_LOST_CONT	BIT(BR_MRP_LOST_CONT_BIT)
+#define BR_MRP_LOST_IN_CONT	BIT(BR_MRP_LOST_IN_CONT_BIT)
+#define BR_TX_FWD_OFFLOAD	BIT(BR_TX_FWD_OFFLOAD_BIT)
+#define BR_PORT_LOCKED		BIT(BR_PORT_LOCKED_BIT)
+#define BR_PORT_MAB		BIT(BR_PORT_MAB_BIT)
+#define BR_NEIGH_VLAN_SUPPRESS	BIT(BR_NEIGH_VLAN_SUPPRESS_BIT)
+#define BR_NEIGH_FORWARD_GRAT	BIT(BR_NEIGH_FORWARD_GRAT_BIT)
 
 #define BR_DEFAULT_AGEING_TIME	(300 * HZ)
 
-- 
2.53.0



