Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033398;
	b=5epVrRxwSUlf/4a0rOVJLOpaoxf+5j072uF0mHi88rSCPPQfgfJLEoYq1t1MAIrd+L8G
	 b3zRqlOU2P0h/3cXKthwmnTea4iove2THWaY+mTB3W2e8Uiz5kCxU6Nal/73jcoFTYrx6
	 3FkapkPkX6dcC3abchjHN++J2WfMgesnL6/P0nXCNnkr1sDuTx+mBd3IEqKLiFFjfdB47
	 OPOCIbrBgiI3xTPLZnknbzsKaeclEpW8M6Gri7kRbL/Fhs01rH8rKz/9G67+NIUCXxbts
	 Zcm56AOtML3RJ3fKYQx3kiTP27h+PmzT8noc2hcEnr+xeq9m4dH9Dqu+XjuIw/TJxAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033398;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kjv/snz8TGiwe3omPLc7BdiAcc5YA+/G+hIF6DnYnG4=;
	b=p9QHpVW7CA0qJptasF/emLCnOrJ3Xr8CqpseV8ZXEZP47mcnwWcN8aw3vs6uMlkvmDdQ
	 FYH5wsD8ei2x0pC9NER5UHbJ11n2MRZ5k751Ar+YsIyqmYOa/YZb9P8VTlWy5gP9jMHmt
	 OOGUSxx1fo8cgfvT5Fkx6AVbcpGYKNaHa9jT5BcehHrcb19OthPcjhiEFJjauD/iv4Ep6
	 GtOZvDDTlypEs6FsvZDGBNwbaWF60lnjR0UC1R+ZG6u4+tts7a5FslmEk192vMEUIAGvk
	 RyvtTBSHAgz8sEDuHnOdeMq+d0tesNXO9GMGHf14k4dQhPxKv+eYTWVrn5QZw4qWUHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ujzqr0un;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA33606A32A;
	Wed, 18 Nov 2026 20:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ujzqr0un
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47B0F1F000C8;
	Wed, 18 Nov 2026 20:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033397;
	bh=kjv/snz8TGiwe3omPLc7BdiAcc5YA+/G+hIF6DnYnG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ujzqr0unO0xEhmCaObC0vIqPn8miYVdPrncYW7bTVTHl9yLeG+A1+O/oGr1S+WIo1
	 KvNEpn2ObXbpkxB8h140Z/ylD0YMlmtd7BD/V8iwIeTcrzu6//uhpUisHdH2u2fbrT
	 E3Z8MpK0mYPS6XL2Ao5fuR6fpT32n8XEKkewN4s4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 1755/1756] net: bcmgenet: if UMAC was suspended in SW_RESET, restore it to SW_RESET
Date: Wed, 18 Nov 2026 16:04:42 +0100
Message-ID: <20261118150119.393684644@linuxfoundation.org>
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

From: Justin Chen <justin.chen@broadcom.com>

commit 5857e5a196b069766a39ceb754736326a43bc6bc upstream.

When the revised suspend/resume sequence was introduced this led to an edge
case where the TX is left disabled in the following sequence.

1. phy link is down, so UMAC is held in reset and then network interface
   is WoL enabled
2. Enter suspend, bcmgenet_wol_power_down_cfg() enables UMAC_RX since MAC
   is in SW_RESET
4. Enter resume, UMAC_RX is left enabled. Since we only enable UMAC_TX
   and UMAC_RX in SW_RESET. The UMAC_TX is never enabled again on link up.

The issue was hit in production and I verified the sequence keeps
the TX  disabled in my standalone test. I tested on an internal
development board with bcm77122, but should be reproducible
on any genet HW that supports power management.

Fixes: 254f3239dd07 ("net: bcmgenet: revise suspend/resume")
Signed-off-by: Justin Chen <justin.chen@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Link: https://patch.msgid.link/20260930230634.3132729-1-justin.chen@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c
@@ -253,6 +253,17 @@ int bcmgenet_wol_power_up_cfg(struct bcm
 	reg = bcmgenet_umac_readl(priv, UMAC_CMD);
 	reg &= ~CMD_CRC_FWD;
 	bcmgenet_umac_writel(priv, reg, UMAC_CMD);
+
+	/*
+	 * Mirror wol_power_down_cfg(). If only UMAC_RX
+	 * is enabled, then we must place the UMAC back
+	 * into SW_RESET.
+	 */
+	reg = bcmgenet_umac_readl(priv, UMAC_CMD);
+	if ((reg & CMD_RX_EN) && !(reg & CMD_TX_EN)) {
+		reg |= CMD_SW_RESET;
+		bcmgenet_umac_writel(priv, reg, UMAC_CMD);
+	}
 	spin_unlock_bh(&priv->reg_lock);
 
 	/* Resume link status tracking */


