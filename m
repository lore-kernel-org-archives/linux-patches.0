Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025206;
	b=dhNlDuY1u5yqI+8iun/McCOw9DrOtVaMvloKxdD+bvg059DtLS/P6RBXj8yotojaEQCU
	 2ZUgeZP7yWoU0DaKuqGKE4l5Obi6Y4pj1bKuQyvurJn+EgRpGs/P2c21JmjgnvxbJCujS
	 11xJJ3iBkWauiYyY/pTKWT12is9pL8wNDOZnEj+vin/4pet1eBEqbO3ECk3RFhFfA07DN
	 O/7BrFHfljkUEu2j9994tB+4B0VnpwkEiBMlXcu0xJzeZ2XflTjK2ZW5ODCXAw9yxXyxr
	 UZZA1dXurxB1oBArJiSXEdaWiup6P4Bx35HhvUgSw/jEp2waGe7pgpSCGNlbENDsH6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025206;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZXgn2z824f2pmNnje7aBxRNydw4W8+PRUVx61739rRw=;
	b=fn4cvYvUUEFzTmazcVBK8OKO4jfWFQRa6hcvHVElekeM26OardKYgxpgvnSn5Cie7CYR
	 FUVKUv6lmXTUwzCAaIzvy8kuZhIuhy4YpXqSVSCluGTGMWG7QOlLQsU0Ho3qXqUomCSRN
	 vQIsOcRAK68osBeZgcHrkHsZLqrpRnFPXSA75INcR8yA2HCZVkGOs653Ylo1rZzGFKLJz
	 AqpdiH0FvNlcXB1Yab8CuOYZW/RItD0va52mdcmOWodJs0Vlvi2jqp9zC84jG5wF7Ks9Q
	 e6exwFYR1z9KL81FU2csesqL6FD6i48wqJE71JrtHdjsq8y8GAAY5QLtD2uAGhutLeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=msUepl70;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279F0606A31C;
	Wed, 18 Nov 2026 18:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=msUepl70
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C8B81F000C4;
	Wed, 18 Nov 2026 18:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025206;
	bh=ZXgn2z824f2pmNnje7aBxRNydw4W8+PRUVx61739rRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=msUepl70R2L9r1F85i1kNr3wD7K1WXWPzYeRUw2tOXQaBEh5j8JoEz1pwI3dZY67s
	 PeMyRUSPdSk7s6cVzFGaCBNTuIadbVKgjVuhQts4vGok6X2wdI2tB6HHVEwgJctUGv
	 mOmis1bGuThd0hlv/6j6U2l7eDD3NTh71//6v9pA=
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
Subject: [PATCH 6.18 0997/2151] phy: rockchip: usbdp: Drop seamless DP takeover
Date: Wed, 18 Nov 2026 15:45:32 +0100
Message-ID: <20261118150158.766904903@linuxfoundation.org>
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

[ Upstream commit 1ab628ce8f3ab694c28dcfcd5b1eec0cf9f499b8 ]

Right now the DRM drivers do not support seamless DP takeover and I'm
I'm not aware of any bootloader implementing this feature either.

In any case this feature would be limited to boards using the USBDP PHY
for a DP or eDP connection instead of the more commonly USB-C connector.
With USB-C's DP AltMode a seamless DP takeover requires handing over the
state of the TCPM state machine from the bootloader to the kernel. This
in turn requires a huge amount of work to keep the state machine
implementations synchronized. It's very unlikely we will see somebody
implementing that in the foreseeable future.

As the current code is obviously buggy and untested, let's simply drop
support for seamless DP takeover. It can be re-implemented cleanly once
somebody adds all missing bits.

Fixes: 2f70bbddeb45 ("phy: rockchip: add usbdp combo phy driver")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-phy/20260612164107.C7DB21F000E9@smtp.kernel.org/
Tested-by: Igor Paunovic <royalnet026@gmail.com> # Orange Pi 5 Plus
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260915-rockchip-usbdp-cleanup-v15-6-80e2c11d1ce8@collabora.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-usbdp.c | 31 -----------------------
 1 file changed, 31 deletions(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-usbdp.c b/drivers/phy/rockchip/phy-rockchip-usbdp.c
index 3fc8222fcaec2..6cb9f6b4dbf6d 100644
--- a/drivers/phy/rockchip/phy-rockchip-usbdp.c
+++ b/drivers/phy/rockchip/phy-rockchip-usbdp.c
@@ -452,11 +452,6 @@ static int rk_udphy_reset_assert_all(struct rk_udphy *udphy)
 	return reset_control_bulk_assert(udphy->num_rsts, udphy->rsts);
 }
 
-static int rk_udphy_reset_deassert_all(struct rk_udphy *udphy)
-{
-	return reset_control_bulk_deassert(udphy->num_rsts, udphy->rsts);
-}
-
 static int rk_udphy_reset_deassert(struct rk_udphy *udphy, char *name)
 {
 	struct reset_control_bulk_data *list = udphy->rsts;
@@ -924,28 +919,6 @@ static int rk_udphy_parse_lane_mux_data(struct rk_udphy *udphy)
 	return 0;
 }
 
-static int rk_udphy_get_initial_status(struct rk_udphy *udphy)
-{
-	int ret;
-	u32 value;
-
-	ret = clk_bulk_prepare_enable(udphy->num_clks, udphy->clks);
-	if (ret) {
-		dev_err(udphy->dev, "failed to enable clk\n");
-		return ret;
-	}
-
-	rk_udphy_reset_deassert_all(udphy);
-
-	regmap_read(udphy->pma_regmap, CMN_LANE_MUX_AND_EN_OFFSET, &value);
-	if (FIELD_GET(CMN_DP_LANE_MUX_ALL, value) && FIELD_GET(CMN_DP_LANE_EN_ALL, value))
-		udphy->status = UDPHY_MODE_DP;
-	else
-		rk_udphy_disable(udphy);
-
-	return 0;
-}
-
 static int rk_udphy_parse_dt(struct rk_udphy *udphy)
 {
 	struct device *dev = udphy->dev;
@@ -1495,10 +1468,6 @@ static int rk_udphy_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	ret = rk_udphy_get_initial_status(udphy);
-	if (ret)
-		return ret;
-
 	mutex_init(&udphy->mutex);
 	platform_set_drvdata(pdev, udphy);
 
-- 
2.53.0



