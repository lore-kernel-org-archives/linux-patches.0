Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018344;
	b=VP+QJ3qlwFqeUgh4SeA3D49GOP7Ack7Oey6HehXbOSwR1h2RtbjRaRsRcKDVszMqHJMR
	 L5mnSFuwRW7HPU4QIX0ry0on6OsTPE0llcqo0euUC9+qBMfe7WmEZSNqorYrmpCEClHJC
	 C6FtR9kEPDosigLAq3OSAgO5FxEEARuBKEG/+vq4gXdimnepx27UlMRVao3YLRhj4rMvy
	 FW0aTllU3KOioMAPm+6DfhCpWuTUqvuINdMqus2JGEqAOXcsVBMNbCjs1t9eNlzY+kJgy
	 3ywKEdcmMxrzAd2DRxh8NHMEOfS3H6cutH7478FaoYl6yDtp1OCl7aW+pn/LLXR9ZYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018344;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UGvBY8pMvP+5M8zxTYsPWS7UvqMm5Z6CG2M6k7xnS7s=;
	b=qy7zLf4e/fGfFwopL8faTLWPZzq/chLRiuF5WtQrdNTMqq8d5RiRPdlCLSQe725W8SPV
	 iDf/tA1OIPtFmzo5nE/LQseQRVcqsmsFcBsv0kdYAdTkox/lMlTol+Ew0zjktzrWVz8+J
	 l5RdiU4N1UvCCAMl4elhFzFruQe2kfEt6sv9J4seVoDcEjKdf95lDAsvt99Viqqm8WvQA
	 ZT/tKt6SX2BunoZp/1Ur8oU9Vr0s4UFiTIGkGGch4UZQcR19evr50iY1srzfqB6Fwbh4y
	 +csIr8+JnUhS7T1Dq8bmMhNGOc8h1PYXsiZxe2Ywh89fnhb++cpi/NLPiQNBIAxUAOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zJaDugKa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9AE606A325;
	Wed, 18 Nov 2026 16:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zJaDugKa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC8C81F000C4;
	Wed, 18 Nov 2026 16:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018344;
	bh=UGvBY8pMvP+5M8zxTYsPWS7UvqMm5Z6CG2M6k7xnS7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zJaDugKajcXQmNwVgF0R//Y9ED5WoimtOgq0eiQWhiJLCQQ5kv1bpiauOGnXpVy+M
	 dGATCf7jtyToxSb6YFsEOzdC6TIh9ET8VmIRL0wdiPdw4oh63NCMjfHR0qbCIEhfqK
	 T98dwYJ/SeHXhciD+vblfeXgn4EtYK9/0JL190GY=
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
Subject: [PATCH 7.3 1206/2651] phy: rockchip: usbdp: Handle missing clock-names DT property gracefully
Date: Wed, 18 Nov 2026 15:40:46 +0100
Message-ID: <20261118150331.413686232@linuxfoundation.org>
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

[ Upstream commit 17cd5e026a6e806b811f915b8e02a8b9d14f6f41 ]

The rk_udphy_clk_init() function would currently try to do a strncmp for
a NULL pointer, if DT specifies 'clocks' property, but no 'clock-names'
property. Fix this by making sure the clock has an id string set.

Note that DT binding requires setting clock-names, so this is only a
problem when booting a non-compliant device tree.

Fixes: 2f70bbddeb45 ("phy: rockchip: add usbdp combo phy driver")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/message/20260619154349.071321F000E9%40smtp.kernel.org
Tested-by: Igor Paunovic <royalnet026@gmail.com> # Orange Pi 5 Plus
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260915-rockchip-usbdp-cleanup-v15-5-80e2c11d1ce8@collabora.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-usbdp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/phy/rockchip/phy-rockchip-usbdp.c b/drivers/phy/rockchip/phy-rockchip-usbdp.c
index c6cda0b80bfac..93364728bca43 100644
--- a/drivers/phy/rockchip/phy-rockchip-usbdp.c
+++ b/drivers/phy/rockchip/phy-rockchip-usbdp.c
@@ -431,6 +431,9 @@ static int rk_udphy_clk_init(struct rk_udphy *udphy, struct device *dev)
 
 	/* used for configure phy reference clock frequency */
 	for (i = 0; i < udphy->num_clks; i++) {
+		if (!udphy->clks[i].id)
+			continue;
+
 		if (!strncmp(udphy->clks[i].id, "refclk", 6)) {
 			udphy->refclk = udphy->clks[i].clk;
 			break;
-- 
2.53.0



