Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214518;
	b=tMWOpCPBbBM76EC1fYX8WGokgrtxTYymV5bvJTDY9RHTSnOPxBBI/bx+DqUo9eYdx/Z9
	 vFD64bORVsDzNqjnzRwdgS4la7dTiinLV2T8FGvHYGy78Fam46CFXYdeHp4ji2Wa5Rlgw
	 nYM59cWyI0cjCwSGqXId14N6YHTbOxU0Z84FgSTmN//4B3OYmWMhlVFdiVVCfV6cMGH8b
	 sd1WKR69PUr39OUTL0O+ILO8LKvng9xP9OyX8Twjc33pJs+ONlGwr3XZyrOcOWqT4gjgI
	 OA07KRKQCDCCRSD0CY83S08raV/o6LkSX4k7JmtohpbRTkJ34VoEpcdSoRDfI8YEesg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214518;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jgsPSKBRJrgSR59vYDn0senltEouy4MLUYmBaIWJbYw=;
	b=WJ2UfloH/PcahWffkejmPMKWjlgk7+/fHihH7xSK/f4VfxUND0n+YRQnuXFKtpdCHMoQ
	 MoyHMOE5XLcUz+K85X2sbYTAR2RtP7DTJiRl8IokHr3Tw/RuHwEDDaugST9KbiDuSrnBi
	 Wnh+zRfggqJxqyBKoenw1OOqxCrsDpn7MGdbjv5CwM44BIGPe8ggcHwOcKM1GgJ8ixuBK
	 Go0n+kJ+Y5j0ClxQXRCBF+ukusq0QySNn3bwGmtFfsAHaQUrbsIq+ERkJ4dIcmm64WJJ+
	 kkCNba5/i+mHcwZdIOCoVnj03CbHF3r1XYjh4grjFWCFz4XkaQ2VUWqUBKe2+KaNHuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VbIrgJmQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB3060A2618;
	Wed, 28 Oct 2026 19:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VbIrgJmQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC46F1F031EF;
	Wed, 28 Oct 2026 19:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214518;
	bh=jgsPSKBRJrgSR59vYDn0senltEouy4MLUYmBaIWJbYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VbIrgJmQbkjX9q+K+Mc1suOeUFnYX2DtjRfeK7lFzH5ENsJY3mLbjwKw861EzWAjf
	 FUHiGRPlJBd/kAMOPTKTGI/KHalioDtDPg0xdKmt8xk/MJu+FVFko990DJKOicz4u4
	 Ud6uOAMPYguR2fLX7796bCpZTIkzxmA+BPVmzTl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0886/1887] net: stmmac: Correctly handle Rx checksum offload errors
Date: Wed, 28 Oct 2026 17:49:42 +0100
Message-ID: <20261028170519.582600717@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit ee0aace5f844ef59335148875d05bec8764e71e8 ]

The stmmac_rx function would previously set skb->ip_summed to
CHECKSUM_UNNECESSARY if hardware checksum offload (CoE) was enabled
and the packet was of a known IP ethertype.

However, this logic failed to check if the hardware had actually
reported a checksum error. The hardware status, indicating a header or
payload checksum failure, was being ignored at this stage. This could
cause corrupt packets to be passed up the network stack as valid.

This patch corrects the logic by checking the `csum_none` status flag,
which is set when the hardware reports a checksum error. If this flag
is set, skb->ip_summed is now correctly set to CHECKSUM_NONE,
ensuring the kernel's network stack will perform its own validation and
properly handle the corrupt packet.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/20250818090217.2789521-2-o.rempel@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index e641739efe29c..e75a05bd5fd0d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5491,7 +5491,8 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 		stmmac_rx_vlan(priv->dev, skb);
 		skb->protocol = eth_type_trans(skb, priv->dev);
 
-		if (unlikely(!coe) || !stmmac_has_ip_ethertype(skb))
+		if (unlikely(!coe) || !stmmac_has_ip_ethertype(skb) ||
+		    (status & csum_none))
 			skb_checksum_none_assert(skb);
 		else
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
-- 
2.53.0



