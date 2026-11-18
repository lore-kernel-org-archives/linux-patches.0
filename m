Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030665;
	b=m/1V5uf19uoZI1p17hmzgnKh8RO4WpFLKNqx6a9gwfdyOuVxR83zX/4wOr9lFWKbiqtm
	 aLQF+Sj/xxY8NCze7ZA2A6e/JHnO/P3QxYLIi8ko4sJcuaW05906yGQUp1sokOv45Pf7I
	 XkJf5JB0G6okFv1MCW0laOHI6CyAQ+COVzbfqPAJbwMOulWr19w3Ilvg9+8Djis6OJcyA
	 pU/b7Vb+lxP0M6bHrm8j3mLSJ8ffy3Hliouq77merc/v59wrnFHN0+tdndEzhfKifbNoI
	 5TduNbVC2PtNTckOC0qImrbr74qWpTpJ/kzQiuq/x1xNYSWYWMGObFfHEz73+kSD0kQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030665;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hBl9PYaRsXRH5N8zYDlyht/V0aA0HWYtyZdoLm1yMXM=;
	b=KG2GM4Y9NZ+2uA2IXWL/A7r/Kb54+mTiMjekFlSqJ5l6EQt1EPoMSvkQAo1/vo94a73h
	 xv9cguGx+LTtgMRIVzDjI0/A3EsneDu7WAbKxn1qsmPA2vLVVcRdE41wbrjwImUIc02Ek
	 +8aKe7GHZumh0kHKkE/m7JnikDaHavM17BVNgwtI7mnnL2kVDiUO6O8lscvLvriI4/fNA
	 kRKtJt9KR+hGk77rdj5ECjR0XIeft9ABZs2o1TS9nj8Xu/Sk6SFxLcRHsxCZUXa4gZsRT
	 NQnOC8iYC5qdekjgt56vJGImb5LsRrPPjsLX6bg+JiQ4vaSXVr5irrRSAJOdMH/2k+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=llM5lIzD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A957E606F518;
	Wed, 18 Nov 2026 19:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=llM5lIzD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 035A41F000C4;
	Wed, 18 Nov 2026 19:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030665;
	bh=hBl9PYaRsXRH5N8zYDlyht/V0aA0HWYtyZdoLm1yMXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=llM5lIzDPBZwPZneBjBh7+9jHM+I+tYXcCcRVszB1yxdwUSeRZlGSoGin0UhbbIK8
	 kjeLPQ9goPBQXN56E9nVTFFYc97ul1cQuR6Fam9BSsDuBqCVe8hAwHD68QUgwTpKnj
	 KkKb6APe1fD5THYSCnP55YVTfngPr4QuLNlyT4Go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Wang <frank.wang@rock-chips.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0783/1756] phy: rockchip: usbdp: add rk3576 device match data
Date: Wed, 18 Nov 2026 15:48:30 +0100
Message-ID: <20261118150040.775706607@linuxfoundation.org>
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

From: Frank Wang <frank.wang@rock-chips.com>

[ Upstream commit a76de028c619dd18f89786805bcc7bb4d379ea9f ]

This adds RK3576 device match data support.

Signed-off-by: Frank Wang <frank.wang@rock-chips.com>
Acked-by: Dragan Simic <dsimic@manjaro.org>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20241014020342.15974-2-frawang.cn@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: b1ca8de219ae ("phy: rockchip: usbdp: Properly handle TYPEC_STATE_SAFE and TYPEC_STATE_USB")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-usbdp.c | 41 +++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/drivers/phy/rockchip/phy-rockchip-usbdp.c b/drivers/phy/rockchip/phy-rockchip-usbdp.c
index fa6446c1c6c0e..b2845070231b9 100644
--- a/drivers/phy/rockchip/phy-rockchip-usbdp.c
+++ b/drivers/phy/rockchip/phy-rockchip-usbdp.c
@@ -1530,6 +1530,43 @@ static const char * const rk_udphy_rst_list[] = {
 	"init", "cmn", "lane", "pcs_apb", "pma_apb"
 };
 
+static const struct rk_udphy_cfg rk3576_udphy_cfgs = {
+	.num_phys = 1,
+	.phy_ids = { 0x2b010000 },
+	.num_rsts = ARRAY_SIZE(rk_udphy_rst_list),
+	.rst_list = rk_udphy_rst_list,
+	.grfcfg	= {
+		/* u2phy-grf */
+		.bvalid_phy_con		= RK_UDPHY_GEN_GRF_REG(0x0010, 1, 0, 0x2, 0x3),
+		.bvalid_grf_con		= RK_UDPHY_GEN_GRF_REG(0x0000, 15, 14, 0x1, 0x3),
+
+		/* usb-grf */
+		.usb3otg0_cfg		= RK_UDPHY_GEN_GRF_REG(0x0030, 15, 0, 0x1100, 0x0188),
+
+		/* usbdpphy-grf */
+		.low_pwrn		= RK_UDPHY_GEN_GRF_REG(0x0004, 13, 13, 0, 1),
+		.rx_lfps		= RK_UDPHY_GEN_GRF_REG(0x0004, 14, 14, 0, 1),
+	},
+	.vogrfcfg = {
+		{
+			.hpd_trigger	= RK_UDPHY_GEN_GRF_REG(0x0000, 11, 10, 1, 3),
+			.dp_lane_reg    = 0x0000,
+		},
+	},
+	.dp_tx_ctrl_cfg = {
+		rk3588_dp_tx_drv_ctrl_rbr_hbr_typec,
+		rk3588_dp_tx_drv_ctrl_rbr_hbr_typec,
+		rk3588_dp_tx_drv_ctrl_hbr2,
+		rk3588_dp_tx_drv_ctrl_hbr3,
+	},
+	.dp_tx_ctrl_cfg_typec = {
+		rk3588_dp_tx_drv_ctrl_rbr_hbr_typec,
+		rk3588_dp_tx_drv_ctrl_rbr_hbr_typec,
+		rk3588_dp_tx_drv_ctrl_hbr2,
+		rk3588_dp_tx_drv_ctrl_hbr3,
+	},
+};
+
 static const struct rk_udphy_cfg rk3588_udphy_cfgs = {
 	.num_phys = 2,
 	.phy_ids = {
@@ -1576,6 +1613,10 @@ static const struct rk_udphy_cfg rk3588_udphy_cfgs = {
 };
 
 static const struct of_device_id rk_udphy_dt_match[] = {
+	{
+		.compatible = "rockchip,rk3576-usbdp-phy",
+		.data = &rk3576_udphy_cfgs
+	},
 	{
 		.compatible = "rockchip,rk3588-usbdp-phy",
 		.data = &rk3588_udphy_cfgs
-- 
2.53.0



