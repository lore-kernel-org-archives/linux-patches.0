Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030756;
	b=LGM3zE9lLMePNKydaNmrAiriUptZLlpM4VLMchsygbypQ1L6lgbFj8XSD0UwiJ3agDsg
	 q74+1OYTMKTpxMxdk3zT5GpbgEQqZd14bQEOjKS6lH5f0mzOU8Rl4NZOjn+SQKDBFHXZn
	 bgj1qOwY9OAnTvP/MVGdwAaSmJhBs0w7KEy1iMj1ds5b0lEftfnC5tOI1/jxRHeD8QCoV
	 BjF/aszuWsXLWCM5jf2ARZt8/paNFoT0rJInII+4Bg3rJW0SHkYXlbYjtm4iTgQKbJ14d
	 E7EF5JKqCy7am6llTFoyffESWhJI9BWRyblXXASC4pQIYYvNLd9f1700PyCobLxqx2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030756;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QYoIVkGnPPClvQU0k8W6zGhP0wYsBvhS0xCnZAimhOE=;
	b=a491D9G7hcLdEakn8TuoXwMqoZvFw5oH+PcrdEjp574wBAq2OshgJEmOpaLbo7Ost9iS
	 lPdZzTM/cnCu1Aj0bWiCPXvu5SL57LFhB0AaYKKgz+y2yTf8Wa2+EKBVaz8er87T7lJDC
	 4snm9rh4yS0CDGgb5HqwtfSFy7L/PC3AJgK1DCRuyMwwffWNoby5M4O/xUaO3Iqv1xj6X
	 JEpvfFKpfTxxKXM4zj80S04eiTCcGQf4bMntgf0qPR+S7pl2DNLfww1ZL88hst5VG4BGZ
	 cqCi5BzHrw4r2hGD1JFBa+SCzIoLlfZJBffSjyS+rN9t00Vn0cuiHqXHVwV/SFUnBNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NP3PJq5p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A329606A918;
	Wed, 18 Nov 2026 19:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NP3PJq5p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62DE81F000C4;
	Wed, 18 Nov 2026 19:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030755;
	bh=QYoIVkGnPPClvQU0k8W6zGhP0wYsBvhS0xCnZAimhOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NP3PJq5pbrAgLGmCtUtPGoKnS3TLKO00p9SD9Gr3XLZkSDCTVSFc2CYX+h/5Am8cg
	 01+ehv8h70ag1YXrsKUC5sam28ayMILqgSh0JjAeyeaGToQsZHI1UH4/rPt6j6myOM
	 RsOH8JbXWkMk4f2i9R7nfyKpfK6aT1zNv9bD3SjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Igor Paunovic <royalnet026@gmail.com>
Subject: [PATCH 6.12 0790/1756] phy: rockchip: usbdp: Avoid xHCI SErrors
Date: Wed, 18 Nov 2026 15:48:37 +0100
Message-ID: <20261118150041.162071197@linuxfoundation.org>
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
index b256672b3405b..ce39a2d828716 100644
--- a/drivers/phy/rockchip/phy-rockchip-usbdp.c
+++ b/drivers/phy/rockchip/phy-rockchip-usbdp.c
@@ -965,13 +965,16 @@ static int rk_udphy_power_on(struct rk_udphy *udphy, u8 mode)
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



