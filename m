Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018336;
	b=BqOf3bfFDp0ln1l4NW+getU1qDIqY20ljUrCRUd97o8p4T0qQgexTyZsg6Sca9emaKJU
	 xE/TD2+46EmM0Z0kPISzMLFHZuFY+RJtn6pFH2kSdCZ11bK6qEMK2otaL37Qm4X5+PHuM
	 LrmG6KFfzCyBEOcTrtR51vpCo1lT6hAeOTI/k1WEc0m1mrpro3HVDfUlpVEQTGE5goKoI
	 0fxThC3fwH3xerJvfd0E1QmDqe/5NixvmYqhszqilICnuGUEDvk91U6hlSh2zf79TNClH
	 Jvd6a2wnCrzs2BK9UkbGrBSmLO7TJ23xMTLzZor5MNgtJsXM2myS4xownqvjKu8y7pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018336;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ejzJVPcd8XMrtrMnE6pOm9PepiFwgTBi+lEXj+eHOJw=;
	b=B1RyKSpHYCSYAaE44DQqvFH5R/5pGkhctld1GUOB3/6XQgEKwo+5au3Jj7Y/UGK99EIS
	 j2XKTDyOR81uH2AL+r4xMxEOf7JU3gNnYsY8g44+EXm26h0WuQgIlby2Y3C/mq+Xlhwah
	 9FRvKyiQrXPc6UNADTBmrhUsNqzXrJ86w3QjYqp12plmtfXJpx2QByPnejX3WZCz2HfRK
	 /rqzS0kQrln3pFF8Fdq8noQ7v5AoFXYEcPTytetc0lPOgzgLGJ2dxnYoQa1/NaCAwqjen
	 j9CfdIFZUMvzlXCrmv7MVqn1t2n7hBtGspVGvIND9eBemH97+Yjpc2aywjZvRCX6IQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CGvVv0K4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78B5606A32A;
	Wed, 18 Nov 2026 16:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CGvVv0K4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 182971F000C4;
	Wed, 18 Nov 2026 16:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018335;
	bh=ejzJVPcd8XMrtrMnE6pOm9PepiFwgTBi+lEXj+eHOJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CGvVv0K4F763foG+WvxROyXiYA7a6Cy+38SszbIVaSECdqqE9UWILHEqhM+f8hbkk
	 /Plm9eZ8oRnHF066ffoDN4dwfMt59XwaIoh3Qr87CuUYKxT/XsmqGHlxFG9dw8xfTm
	 tV1LPM+U4WEVdMG4cvPR49RihmFJG95fj9isDTcU=
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
Subject: [PATCH 7.3 1203/2651] phy: rockchip: usbdp: Update mode_change after error handling
Date: Wed, 18 Nov 2026 15:40:43 +0100
Message-ID: <20261118150331.303576018@linuxfoundation.org>
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

[ Upstream commit 3f2181226d7708349c69cd4a4b21372a8049576b ]

If rk_udphy_init() or rk_udphy_setup() fails, the reinit will not be
tried again. Fix this by only updating the variable after all potential
errors have been handled.

Note, that no errors have been seen on real hardware and failures would
most likely be fatal and require at least a full reboot as the function
already asserts the PHY reset lines. So this is more of a theoretical
issue.

Fixes: 2f70bbddeb45 ("phy: rockchip: add usbdp combo phy driver")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-phy/20260612163835.8D5471F000E9@smtp.kernel.org/
Tested-by: Igor Paunovic <royalnet026@gmail.com> # Orange Pi 5 Plus
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://lore.kernel.org/linux-phy/20260612163835.8D5471F000E9@smtp.kernel.org/
Link: https://patch.msgid.link/20260915-rockchip-usbdp-cleanup-v15-2-80e2c11d1ce8@collabora.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-usbdp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-usbdp.c b/drivers/phy/rockchip/phy-rockchip-usbdp.c
index 07a839e41db71..13649b52e99b0 100644
--- a/drivers/phy/rockchip/phy-rockchip-usbdp.c
+++ b/drivers/phy/rockchip/phy-rockchip-usbdp.c
@@ -999,15 +999,14 @@ static int rk_udphy_power_on(struct rk_udphy *udphy, u8 mode)
 	}
 
 	if (udphy->status == UDPHY_MODE_NONE) {
-		udphy->mode_change = false;
 		ret = rk_udphy_setup(udphy);
 		if (ret)
 			return ret;
 
 		if (udphy->mode & UDPHY_MODE_USB)
 			rk_udphy_u3_port_disable(udphy, false);
-	} else if (udphy->mode_change) {
 		udphy->mode_change = false;
+	} else if (udphy->mode_change) {
 		udphy->status = UDPHY_MODE_NONE;
 		if (udphy->mode == UDPHY_MODE_DP)
 			rk_udphy_u3_port_disable(udphy, true);
@@ -1016,6 +1015,7 @@ static int rk_udphy_power_on(struct rk_udphy *udphy, u8 mode)
 		ret = rk_udphy_setup(udphy);
 		if (ret)
 			return ret;
+		udphy->mode_change = false;
 	}
 
 	udphy->status |= mode;
-- 
2.53.0



