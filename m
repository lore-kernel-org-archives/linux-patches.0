Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018338;
	b=u1KrYM1kHYe6lgjCbin8GMgfAw+RNitAcds0yZqT2O4fRd1nFG72ES7C3D1VUFcFaRbU
	 t3XbmnDKDhD/G3f/164ZMOh6FiKNQ6XM4ARgObAXZm4HohOmsjcCQaXIyF0j2zB1KB0UK
	 B3FSVvPOjExkStQXJE7RL8+KqY/cezz7RuVov1F5KAVYjv+W0lVOyFbfcf23EePjNTcfK
	 ngRRWc6pRoTMmGg6ie9YwonrjB+zMWnGkA2UVKyhmgZJ5FewnWg1RnBVCZTZxaY8HT9ai
	 dJcpvl+CzHL7z7yMj0LuDctw/1jTtgDYr1Pr4fe9C4q1CX4mid3zGMcySUpXQcE5Qmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018338;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WQQRq9p6cK0pEhkRRXvwcMOrb7gkuyzXp3KQ1G2uw0k=;
	b=zbSNke5zm/EBoViBwk2HjyNvjOwgu/YeBsGRuzJ7/71OlJNA98tHUJ6Ku7Fo0nf9dWnk
	 Mpbglav5erlhar+Pcid5BbFE8NEQ0OzQE0RaJ0cP+UlBN1LNOSQ/JGLOc8oA5ywueZ0NX
	 Bhn9P6wv0Wj6gNiqM5BhvWGm8QMfui7QCqkwYc/TI4kbjk2GBgrLwRObBcx7MuNbd5ntz
	 n9+YXsEIzUmfuwYDXfQXKaX4QamDm6RtkhsiK+1vG7omxXWWA1m6SMXSd8LQ6EiwOBug2
	 WmmAUOnr/UGmyTMYaQvCI2Qhx19ZvqJQdO2HnZudegkZoPBEQOboDnFcfMyOxj93vCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qiFoHSyU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D78606A325;
	Wed, 18 Nov 2026 16:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qiFoHSyU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23DD1F000C4;
	Wed, 18 Nov 2026 16:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018338;
	bh=WQQRq9p6cK0pEhkRRXvwcMOrb7gkuyzXp3KQ1G2uw0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qiFoHSyU7XCJPVWabgVXbYmNwpTpHjl1P6dFtWOI+/i/UfBSasU+gWHQg2JHGyAoP
	 MNsPJ/FT51AhCGMa0piwUMZnDEQfN8yLXSwKkfrL69nPUuWL3eyaKNy6MQaV6hgLxk
	 2CVQYn+ZgbE/9r8hmSUQ0wnDu1uMyO8/sRSnESTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Igor Paunovic <royalnet026@gmail.com>
Subject: [PATCH 7.3 1204/2651] phy: rockchip: usbdp: Do not lose USB3 PHY status
Date: Wed, 18 Nov 2026 15:40:44 +0100
Message-ID: <20261118150331.341493556@linuxfoundation.org>
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

[ Upstream commit b322403c294b67fd6bcf6719b4fc9f8a9e313129 ]

By default (i.e. without manually enabling runtime PM) DWC3 requests the
USB3 PHY once and keeps it enabled all the time. When DisplayPort is
being requested later on, a mode change is needed. This re-initializes
the PHY. During re-initialization the status variable has incorrectly
been cleared, which means the tracking information for USB3 is lost.

This is not an immediate problem, since the DP side keeps the PHY
enabled. But once DP is toggled off, the whole PHY will be disabled.
This is a problem, because the USB side still needs it powered.

Fix things by not clearing the status flags.

Fixes: 2f70bbddeb45 ("phy: rockchip: add usbdp combo phy driver")
Tested-by: Igor Paunovic <royalnet026@gmail.com> # Orange Pi 5 Plus
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260915-rockchip-usbdp-cleanup-v15-3-80e2c11d1ce8@collabora.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-usbdp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-usbdp.c b/drivers/phy/rockchip/phy-rockchip-usbdp.c
index 13649b52e99b0..da0fa75fc9f0d 100644
--- a/drivers/phy/rockchip/phy-rockchip-usbdp.c
+++ b/drivers/phy/rockchip/phy-rockchip-usbdp.c
@@ -1007,7 +1007,6 @@ static int rk_udphy_power_on(struct rk_udphy *udphy, u8 mode)
 			rk_udphy_u3_port_disable(udphy, false);
 		udphy->mode_change = false;
 	} else if (udphy->mode_change) {
-		udphy->status = UDPHY_MODE_NONE;
 		if (udphy->mode == UDPHY_MODE_DP)
 			rk_udphy_u3_port_disable(udphy, true);
 
-- 
2.53.0



