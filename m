Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212669;
	b=CkTD3mnGcDgk3/HkpaB6WbbK3XWdAQRz1KyVMM10XFj43QkL++NevFzy9f+lVNiaobOe
	 KovrRPWlkvmnAVhl6fCDY6Z5Z11H2g+GADzbnS/HKCyXSyylXagx2ihtfaJw2QrbV1GRs
	 FhtMXSyKeoezT4f6tpdjtHGMOotdUlWGYC81hcnUFjtie/AaFmvzdnzpNWOzK30mtlDPu
	 Ax/SCkY0G4ATqN6gPtUlJQ8b6yYNrid2Ba8PvKMmco2GkMab2e8wxjp3XBFMYJwmtJ8kF
	 Tggk71DNRlYHx8SrUCUokjVJ/KqqLF7pH6fnILQDj3w9tOmX+jyK75BzyFWmvfEvW1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212669;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aIz7SMTPEd5bTXAZD/10CfF0CuGQpV2eSsDJZ9Nyz8c=;
	b=ptA322Jnlin+S+l07vbSzMZP65HJ1Wcro/DRL1sQtZ5uUQRBnAP5owt+gbKi0ATbjdER
	 r+hmd7GjexFBxoHGwds26cVcHyN2/r4OBZwtyouHGZN6n+nlCgdZ1HFS6mti6RlDuud7t
	 gBmEManWHo+q+0UGcL29rJkEuSRQwba56TbeRY+OCzJ0bxHUsSL8mXSwHt8FUtk2/rTwX
	 YHHUXargnvVi5X4vqTDEYyLmPtuqyRTVkmndZ4H6Ai57KUouz615UdjoLzV5w9NImEdwj
	 IoiS64/jxwDzwaiCX9RTXEDiz4Ny3+86ddB99fIcwfohP2CRY0O/0qT43HNV5BRSD9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Izyu01uW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82BEE606A320;
	Wed, 28 Oct 2026 18:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Izyu01uW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A274A1F01828;
	Wed, 28 Oct 2026 18:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212669;
	bh=aIz7SMTPEd5bTXAZD/10CfF0CuGQpV2eSsDJZ9Nyz8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Izyu01uWwQFhlfMAMELioyYQs2BKe8BSveoRUuQY1mzvyCewX2X/mwgAOTlh2KESk
	 PHbrRYSQnS7zFI9D3dBsr46wldVJfZn8DdEKh03D2VO6OfOr7sjwANT6a+YY5+dD6P
	 eKqZBs8zkrsYlUbu1/z/6t19Z2CYXg/m6AowOsYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0234/1887] net: systemport: Fix RUNT MIB counter register offset calculation
Date: Wed, 28 Oct 2026 17:38:50 +0100
Message-ID: <20261028170504.556935087@linuxfoundation.org>
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

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit 242935adfeb096f09b29fb2cfcf12f9eb2911fc6 ]

In UniMAC hardware, there is a 0xC byte gap between the RX MIB counters
and the TX MIB counters, and a second 0xC byte gap between the TX MIB
counters and the RX RUNT MIB counters.

In bcm_sysport_update_mib_counters(), 'offset' was only set to
UMAC_MIB_STAT_OFFSET (0xC) for all non-RX counters, omitting the second
0xC gap for BCM_SYSPORT_STAT_RUNT counters. As a result, all 4 RUNT MIB
counters were read from unmapped gap register space.

Fix this by setting offset to 2 * UMAC_MIB_STAT_OFFSET (0x18) when
reading BCM_SYSPORT_STAT_RUNT counters.

Fixes: 80105befdb4b ("net: systemport: add Broadcom SYSTEMPORT Ethernet MAC driver")
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260922232440.598918-6-florian.fainelli@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bcmsysport.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index e53ab9b5482e1..c9e6a3583f2aa 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -422,8 +422,10 @@ static void bcm_sysport_update_mib_counters(struct bcm_sysport_priv *priv)
 			if (priv->is_lite)
 				continue;
 
-			if (s->type != BCM_SYSPORT_STAT_MIB_RX)
+			if (s->type == BCM_SYSPORT_STAT_MIB_TX)
 				offset = UMAC_MIB_STAT_OFFSET;
+			else if (s->type == BCM_SYSPORT_STAT_RUNT)
+				offset = 2 * UMAC_MIB_STAT_OFFSET;
 			val = umac_readl(priv, UMAC_MIB_START + j + offset);
 			break;
 		case BCM_SYSPORT_STAT_RXCHK:
-- 
2.53.0



