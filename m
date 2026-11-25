Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624684;
	b=oflDxCwU/dQ/yWfDZeEmMdlIpQSBr3Z9yugDqVG8lJhogns8ROoaInldfz1+ECeycu9J
	 zlSmIYXwL7Ocq+98yvYAd1O7X2op7hnnv33Pq0Xk754ie8qkOuuV1I1K3BP23lYHw/5H/
	 eBIX4KMLOnKkQHgiW2TTtRrEESpQQu0rDPet9l0uNFFJQvTYk7EkUCnWK3rEh01Ne6WJr
	 ch71iOzT5mF+KnlAYpDKrryazSvfxKYDvzVHyQBJ5in113b9P16fMPjnXr9OVhWGeCsiD
	 1U07sCCZFXydBr16vd0FLzd/bJ1JieAhlT2j9sg/dHchRMAXGj9+Opu2K5u9v3SOV7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624684;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jftNaX7CEflR0kJ+nwuj+qAqnLMNEyeLmC32NdzcXh0=;
	b=2Q9hG+3zaFJPzs7rq/mk6R2Ym4A9gzQQQKetKoVbiyTi23xP3HnhsD4HffpUg7slGJAY
	 msbECUoGin03F/aYmFRp99Rje6SpfVunyiE6cFtpvifdQ94jRJB5vIobv0DDaA14o/Xfi
	 nzev/HLtGFRnNSsoKtRHvoGRpYl8FyVB7yoirhiqhjmKeUSu3H0f/TG185vFjGMCnSbIC
	 WYEyVZooXNWkxWsug+PB/yqkgtlGLaiq4uR+LKap+yTPIx/LxkpBKx28kjy+Oi7eLHivt
	 zdQch72JD/5glT4Y54Oocg/I2Nrzeyo+HQDCneeXRLsVqUeOmoT/QrrBo7Tco2zOsRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uBlqbCOa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1E3606A338;
	Wed, 25 Nov 2026 16:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uBlqbCOa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CAF31F000C4;
	Wed, 25 Nov 2026 16:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624683;
	bh=jftNaX7CEflR0kJ+nwuj+qAqnLMNEyeLmC32NdzcXh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uBlqbCOajxkTh//w40dOYYrDIl/WqYZ2cXUDSPqQlt2mqzoIebrXVT4PBEu3+NBx2
	 O25NCYQEbJw1j2wU3O1hGBLobDze2bWTctYB6HBo3wYpxiypgvIqFG+xz2KVKR+02g
	 WZS+GHRaepWZQ8HhZ1kmbXZ4ES5LlfSGU7ova724=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Furong Xu <0x1207@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 228/816] net: stmmac: Unexport stmmac_rx_offset() from stmmac.h
Date: Wed, 25 Nov 2026 15:29:36 +0100
Message-ID: <20261125143854.484113021@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Furong Xu <0x1207@gmail.com>

[ Upstream commit e62de01008bd6581788aa155ada043cba0261332 ]

stmmac_rx_offset() is referenced in stmmac_main.c only,
let's move it to stmmac_main.c.

Drop the inline keyword by the way, it is better to let the compiler
to decide.

Compile tested only.
No functional change intended.

Signed-off-by: Furong Xu <0x1207@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250107075448.4039925-1-0x1207@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 6d9b7c85af57 ("net: stmmac: set XDP metadata length on the page_pool RX path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h      | 8 --------
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 8 ++++++++
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index 8d6507cef53a9..c087accd72726 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -423,14 +423,6 @@ static inline bool stmmac_xdp_is_enabled(struct stmmac_priv *priv)
 	return !!priv->xdp_prog;
 }
 
-static inline unsigned int stmmac_rx_offset(struct stmmac_priv *priv)
-{
-	if (stmmac_xdp_is_enabled(priv))
-		return XDP_PACKET_HEADROOM;
-
-	return 0;
-}
-
 void stmmac_disable_rx_queue(struct stmmac_priv *priv, u32 queue);
 void stmmac_enable_rx_queue(struct stmmac_priv *priv, u32 queue);
 void stmmac_disable_tx_queue(struct stmmac_priv *priv, u32 queue);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index a48c34dcbcd26..c420a449459ed 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1324,6 +1324,14 @@ static void stmmac_display_rings(struct stmmac_priv *priv,
 	stmmac_display_tx_rings(priv, dma_conf);
 }
 
+static unsigned int stmmac_rx_offset(struct stmmac_priv *priv)
+{
+	if (stmmac_xdp_is_enabled(priv))
+		return XDP_PACKET_HEADROOM;
+
+	return 0;
+}
+
 static int stmmac_set_bfsize(int mtu, int bufsize)
 {
 	int ret = bufsize;
-- 
2.53.0



