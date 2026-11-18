Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025237;
	b=Gk7uiXqqa9+uVJQErUdC4g9xevSJfkq0PRjD6MTWJUIyfqslW15PiDVvYMAk0am+syvM
	 wU3iHD3/9oIEPAEKfP8crT0R82H8HZRHkrKBTRoygoRMvM9/Ecn9m8Xtt2NrYfmsUUaax
	 CrfOdXD4M1L5XiW1snEJpy37OMdDCgY8AJuO3+wGUUs4qJco0z2PIv07P1vQoq9SCeO/3
	 Kfwi93XTpTy7KdDeL7O3nrGhkyZ1cBVzP0FRMLOf6Y61/H/JlxC9PehtPHa2dhXqs4KRi
	 pa5sCgf6h8OVustxNbsn8I0nhCWjwkZYJ+IIj59Kl0lJjmNGsCS9WV+7jfHAOrUqQHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025237;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lFfIvl3+8civuDrxrFd5t97WNGRk+Z0DcKZ6/N5Jj+c=;
	b=LN1iXGLrTTmzukN2L3yKtP1YDlPcK6LbzgYzcE8hJCKUevJ/rBWiXbJciUU175FJSX9D
	 e2soofgFMuzrPQUR5Hx+1GzXnQRKeaMYJ3POr3/MJ1rKr7m1aM33ypj8qwY6XzDUuSsSZ
	 4/pS02sunlDnwu14M2Om0IDruVieauRTtDwqdUKW+Pu+5PE7MwGbiEqw4MPpiQki35sTX
	 Pe4FRSdUxOq9pFv2kXHGj8pvrMJVz2ijyIeFJFqdHMbIXvD26ie5cMiwmZzIHxg2rKhMw
	 UuFvFfpgzWYMej130IRCO1KceNP5eJfdvU36U6IOmOWNdF+2QtJpRutTSkH/1oKoecw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yKyCL+2S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E33606A32A;
	Wed, 18 Nov 2026 18:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yKyCL+2S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 929041F000C5;
	Wed, 18 Nov 2026 18:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025237;
	bh=lFfIvl3+8civuDrxrFd5t97WNGRk+Z0DcKZ6/N5Jj+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yKyCL+2SPXbokaqaVDi3ihOa0LeNC2uYoo5B0aBK1cE0X4hMPcwnWsyk5rpxtMK1+
	 mg02cxaD/v7aSbaA13zOX96wxXviDfcvhbtgupUXQc1jLSk0ATDQz0R6KnJpB6ewri
	 I/bODRsLmuxorTXno7+W59EnX89o7bYyteaqVDJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Igor Paunovic <royalnet026@gmail.com>
Subject: [PATCH 6.18 1007/2151] phy: rockchip: usbdp: Only enable USB3 when not in high-speed mode
Date: Wed, 18 Nov 2026 15:45:42 +0100
Message-ID: <20261118150159.118140899@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Reichel <sebastian.reichel@collabora.com>

[ Upstream commit fbbf6c85b08008bf68ef49931175edeaa36ba82f ]

Ensure that USB3 mode is not accidently enabled during PHY re-init
for systems that are configured as high-speed only via DT.

Fixes: 2f70bbddeb45 ("phy: rockchip: add usbdp combo phy driver")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/message/20260626212424.C215E1F000E9%40smtp.kernel.org
Tested-by: Igor Paunovic <royalnet026@gmail.com> # Orange Pi 5 Plus
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260915-rockchip-usbdp-cleanup-part2-v15-11-8d507cb1174f@collabora.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-usbdp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-usbdp.c b/drivers/phy/rockchip/phy-rockchip-usbdp.c
index f50346a16ba7b..b605535271d83 100644
--- a/drivers/phy/rockchip/phy-rockchip-usbdp.c
+++ b/drivers/phy/rockchip/phy-rockchip-usbdp.c
@@ -974,7 +974,7 @@ static int rk_udphy_power_on(struct rk_udphy *udphy, u8 mode)
 		if (ret)
 			return ret;
 
-		if (udphy->mode & UDPHY_MODE_USB)
+		if (!udphy->hs && udphy->mode & UDPHY_MODE_USB)
 			rk_udphy_u3_port_disable(udphy, false);
 		udphy->phy_needs_reinit = false;
 	} else if (udphy->phy_needs_reinit) {
-- 
2.53.0



