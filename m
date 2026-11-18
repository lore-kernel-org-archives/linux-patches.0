Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018373;
	b=LCUNB6i9JyY62Rh2moXVnXnHv2B3TQPNF6E4zXQ/G4X9N5cicrA4YdQcpk95m35XmYsJ
	 2Gdv7TFutGUHL/jjUP6NcgDXOjW+o/q+qGgOSF5eJJZf9lZiBABuTCxFd3WxeVeFnOSzE
	 3YtN0GaxZM7Cx+aYEmn82V0UcPOB/qJWBkSsITjwFnqa/q6Orq/wq90O2FYBpwS7MyjB4
	 kkyeE89/9gRmLipl6r5ZCcCzaVKrQJM1lObR7oMRv8XWW3r6f/4O6kgfJfrqdekt1LlR2
	 Pd/tVYyin9CJehvA85XwHK/4yxTK4+L6AKiBtq9zSALRUTajmYKYCuY+XVkIxuhW6Og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018373;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z4qiA6j5Xu3gtue5e2yn+om1F8wTCnU4yBoa54sztC8=;
	b=c7ybZ+T2mSWWgTiYjIS7N2p0e8XHWrj0Dhl1CmrQuU6BPbcNY7isrL98G93fCOufp+jr
	 EkTsBS9HxBsbunptNKaj60fu9wvqt6siz5cRNcGth582wy8KK1S2XJIhPQMQVV/MjmeEl
	 EWEQit0HupLVebV+2Aau475dtWJueGasFRgIQE7QElKw6Wl9r58bC50Vm+PSGze49KIGv
	 BrxnS8gKh736rTDnGglipfTttlJxag+707lGv+fCd1nQRx2a+W/W9rq982XTqC4eK3E8h
	 tTkI09eCNhcsistUfdJgvrRJJgTXoUcAJwfbHx9F+KJLRz9I6CYMjviBjUoKXsSfC0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=COudGF81;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D142E606A331;
	Wed, 18 Nov 2026 16:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=COudGF81
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C5261F000C5;
	Wed, 18 Nov 2026 16:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018373;
	bh=Z4qiA6j5Xu3gtue5e2yn+om1F8wTCnU4yBoa54sztC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=COudGF81/TD9yiyaA33sbUGYRxP8gZHold8HgOAyc0vcz86aF1bGpyitB8TPAIKee
	 A6WF1e9pA5mh8ZAjPCWdIZI+gXxdMe0m6P43OvdeQx08EB3/ibrV1+KTz8ydtTJJqe
	 J7kTCzLopGYBakJ5WDfKLlWPdTD8vMUZU56EjIRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Igor Paunovic <royalnet026@gmail.com>
Subject: [PATCH 7.3 1215/2651] phy: rockchip: usbdp: Avoid xHCI SErrors
Date: Wed, 18 Nov 2026 15:40:55 +0100
Message-ID: <20261118150331.741405193@linuxfoundation.org>
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

[ Upstream commit cf3aa34e6f0798544c26ad93a6c3c2231ab09738 ]

The USBDP PHY provides the PIPE clock to the USB3 controller, which
means the PHY must be fully running when anything tries to access
the xHCI registers.

When switching between USB3-only, USB3 + DP and DP-only mode, the
PHY must be re-initialized resulting in a short period of the PHY
being disabled. If the DWC3 driver decides to access the xHCI at
this point the system will fail with an SError.

This patch avoids the problems by disabling the USB3 port before
re-initializing it. This does a couple of things:

- forces phystatus to 0 from GRF (not from PHY)
- switches PIPE clock source from PHY to UTMI (safe fallback clock)
- num_u3_port=0

The last part will be ignored, as DWC3 already probed, but the
clock re-routing will avoid the SError. There is a small delay
afterwards to make sure the mux happened. The datasheet gives
no hints how long it takes, so delay time is a guess.

Fixes: 2f70bbddeb45 ("phy: rockchip: add usbdp combo phy driver")
Tested-by: Igor Paunovic <royalnet026@gmail.com> # Orange Pi 5 Plus
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260915-rockchip-usbdp-cleanup-part2-v15-9-8d507cb1174f@collabora.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-usbdp.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-usbdp.c b/drivers/phy/rockchip/phy-rockchip-usbdp.c
index 794f7112c1f15..b4739ab6a015f 100644
--- a/drivers/phy/rockchip/phy-rockchip-usbdp.c
+++ b/drivers/phy/rockchip/phy-rockchip-usbdp.c
@@ -964,13 +964,16 @@ static int rk_udphy_power_on(struct rk_udphy *udphy, u8 mode)
 			rk_udphy_u3_port_disable(udphy, false);
 		udphy->phy_needs_reinit = false;
 	} else if (udphy->phy_needs_reinit) {
-		if (udphy->mode == UDPHY_MODE_DP)
-			rk_udphy_u3_port_disable(udphy, true);
+		rk_udphy_u3_port_disable(udphy, true);
+		udelay(10);
 
 		rk_udphy_disable(udphy);
 		ret = rk_udphy_setup(udphy);
 		if (ret)
 			return ret;
+
+		if (!udphy->hs && udphy->mode & UDPHY_MODE_USB)
+			rk_udphy_u3_port_disable(udphy, false);
 		udphy->phy_needs_reinit = false;
 	}
 
-- 
2.53.0



