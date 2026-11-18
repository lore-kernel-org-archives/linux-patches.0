Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018393;
	b=CC7claaJirFCVYAR4XfvjRxdc8W6WqTh65p+1z4bQfd4BIpTbXx+X/KX8jqxAsB8CjHf
	 ifDJbR0SnmBygRchsEJIsUvpJXfe0Z0SZ6b6G1YzTYDjYFbhhup6n4un0WGBdGYix/XjC
	 a5Gts4Scvnqg7LfDMDBJwZ2NzK1Z+T9CyDtWeXoNCLPNKKBOctS6hqDJICh1PZgLBVDtg
	 F+f96QXIqWq61en60ejz755SDl288b/aHNJcZxOTMw0GtmazL8ZOHMDUIjsU3fpDx/TU4
	 n4ncmcQtlZmEZZ/mzGxCpRL7QJ6GjFf5YxwfYVYAibTxARK05fbCxmXTUWamVAxURXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018393;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qTBqNFsBICW7hp4mpg1P55dAcWvV7k91Ya5KrDFuskA=;
	b=fRTdN3/ELb67GYiNBZFb6v3sDQiiA2gALiTW3ZPLAfBX3Kme4qgqqLMjRIkH6JYSeatZ
	 IlKAc8pt0xMJFS03jt0HAWisji8S7o9RLfpHm35cKMMfRDtgUS/2zwDpoV0igrTGGAKya
	 ND2VPWe8Ki0/qozsgHruOipflrdFEAxtJnLKgrSLM03CvVTViSrUYZYibD7pCEFqsWW3J
	 MUP2BpmSPkt/RLd3+OJLjS8LbDONhTVCRHuzOOUI+p33qahLq7FqMK6ZLUktp7Pn+DHl4
	 J4syfMsXSs3pOBfcHZmtKsmaGAUj+XMc6/fN10ygTyDy31sX0Gvqf4tZ7qa0VB02v7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xp4KnqCT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D0A606A331;
	Wed, 18 Nov 2026 16:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xp4KnqCT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E327E1F000C4;
	Wed, 18 Nov 2026 16:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018393;
	bh=qTBqNFsBICW7hp4mpg1P55dAcWvV7k91Ya5KrDFuskA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xp4KnqCT71oBYBmADxYanPkjWknDWkCpLh9S9qsjH0kbbvW4na/4CtQhKLUR+Y7Jc
	 aGTN3FZU14rgyfRHbuxWurMus6aFEcq+A1AuEIdbowrSYTRPGkZkOsRLT0uR/z+pOY
	 y13w36ddFOU1HNpfJea9cJjdLnO9HVP4+mIViJbM=
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
Subject: [PATCH 7.3 1217/2651] phy: rockchip: usbdp: Only enable USB3 when not in high-speed mode
Date: Wed, 18 Nov 2026 15:40:57 +0100
Message-ID: <20261118150331.816336459@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 80a2ea46c650a..1d6ea291dbfed 100644
--- a/drivers/phy/rockchip/phy-rockchip-usbdp.c
+++ b/drivers/phy/rockchip/phy-rockchip-usbdp.c
@@ -973,7 +973,7 @@ static int rk_udphy_power_on(struct rk_udphy *udphy, u8 mode)
 		if (ret)
 			return ret;
 
-		if (udphy->mode & UDPHY_MODE_USB)
+		if (!udphy->hs && udphy->mode & UDPHY_MODE_USB)
 			rk_udphy_u3_port_disable(udphy, false);
 		udphy->phy_needs_reinit = false;
 	} else if (udphy->phy_needs_reinit) {
-- 
2.53.0



