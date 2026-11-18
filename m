Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030668;
	b=EbkuJkTAOVlnR06Z7yYlAOR4mQLdRSOdVwYHLHfi4xjscQ4/ZvH/nRxEVpc/jZiCl57q
	 HO6l9MrKWcujrMy+w4axFt9jkTWH8q65/GNcfoEDIMRl5HGjNMR+gXFFMfWPIu0twGX6o
	 qzGMsyNqu90lulbUK8VPrQ9MewA9yS6DGAJb2ulbdN/u0IC6x4L97Oa4Tha1b6/Oo8S/A
	 biPU9tuxjeF0SUWnO6TzUw0cMhdap2oSKG62UGMkjhojn5G0+cGJWHPl+LnhrbpA59Qsw
	 iG8uebSNrpw2bQZjmYBhWj1mAkiKuD3Yh4oNO6RJ5eb6CuEf6lnmczAfrc3H0/WcJ3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030668;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Bhoc0fTsax51WQ3pTGQM8ZJzLnhYQqV69RuVcaJLR9E=;
	b=bftQSyu+76svIZ2bTcM2x/56vntHtzJUymOPTx4EYQaqqPOjPvKVdQrsFf84H28IIjuT
	 Uc6Q1dToLNA7W9OpmZlohcBbOpBMXsLxCBpEM46AbWpvJv09+H1+CtR0ZMnRI3c2tJTzS
	 PR/uJngoLdxlXVtT/N2ef4YJXekGnXNDNKgMY+jN99yLwOWFJTHn4J5lk1/gbrUNOETDe
	 Y2KygwLRVNJwS/TKm2lhx9Luj27RMZXyt9vPZeE13bzkDwHAOhh4pekcbiAmZQBjYk/XQ
	 dbyb6FJm5kQ6kYkw2M0eylZDNs/+dVLM9a475/4oR9+wbglClMmlXqHxwx//Ixb1j1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=idlPektm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7253C606A7C7;
	Wed, 18 Nov 2026 19:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=idlPektm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC5231F000C4;
	Wed, 18 Nov 2026 19:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030668;
	bh=Bhoc0fTsax51WQ3pTGQM8ZJzLnhYQqV69RuVcaJLR9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=idlPektmReDiz3tfMKjQov8sYvci7k3FTD96jleiJ0ZJ7uJbKTbm8s3V1jpzrCwYQ
	 lfKrWQgMkNIk61C0Kjnn5nfOf0liYWzi1gIfiYo4Ggct7LuoQb+dl/qfDO5NVXJVFd
	 3H7DmxIpnBP+B2IV8EdNtr/Rvgk74zKqoznDOaig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Igor Paunovic <royalnet026@gmail.com>
Subject: [PATCH 6.12 0784/1756] phy: rockchip: usbdp: Add missing mode_change update
Date: Wed, 18 Nov 2026 15:48:31 +0100
Message-ID: <20261118150040.812804025@linuxfoundation.org>
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

[ Upstream commit 5def5d61ea5ac6f391364f6fdcff13a27a52026e ]

rk_udphy_set_typec_default_mapping() updates the available modes,
but does not set the mode_change as required. This results in
missing re-initialization and thus non-working DisplayPort.

Fix this issue by introducing a new helper to update the available
modes.

Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Tested-by: Igor Paunovic <royalnet026@gmail.com> # Orange Pi 5 Plus
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260915-rockchip-usbdp-cleanup-v15-10-80e2c11d1ce8@collabora.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: b1ca8de219ae ("phy: rockchip: usbdp: Properly handle TYPEC_STATE_SAFE and TYPEC_STATE_USB")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-usbdp.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-usbdp.c b/drivers/phy/rockchip/phy-rockchip-usbdp.c
index b2845070231b9..d5f5ae05a5bdd 100644
--- a/drivers/phy/rockchip/phy-rockchip-usbdp.c
+++ b/drivers/phy/rockchip/phy-rockchip-usbdp.c
@@ -616,6 +616,15 @@ static void rk_udphy_dp_hpd_event_trigger(struct rk_udphy *udphy, bool hpd)
 	rk_udphy_grfreg_write(udphy->vogrf, &cfg->vogrfcfg[udphy->id].hpd_trigger, hpd);
 }
 
+static void rk_udphy_mode_set(struct rk_udphy *udphy, u8 mode)
+{
+	if (udphy->mode == mode)
+		return;
+
+	udphy->mode_change = true;
+	udphy->mode = mode;
+}
+
 static void rk_udphy_set_typec_default_mapping(struct rk_udphy *udphy)
 {
 	if (udphy->flip) {
@@ -646,7 +655,7 @@ static void rk_udphy_set_typec_default_mapping(struct rk_udphy *udphy)
 		gpiod_set_value_cansleep(udphy->sbu2_dc_gpio, 1);
 	}
 
-	udphy->mode = UDPHY_MODE_DP_USB;
+	rk_udphy_mode_set(udphy, UDPHY_MODE_DP_USB);
 }
 
 static int rk_udphy_orien_sw_set(struct typec_switch_dev *sw,
@@ -1364,10 +1373,7 @@ static int rk_udphy_typec_mux_set(struct typec_mux_dev *mux,
 			usleep_range(750, 800);
 			rk_udphy_dp_hpd_event_trigger(udphy, true);
 		} else if (data->status & DP_STATUS_HPD_STATE) {
-			if (udphy->mode != mode) {
-				udphy->mode = mode;
-				udphy->mode_change = true;
-			}
+			rk_udphy_mode_set(udphy, mode);
 			rk_udphy_dp_hpd_event_trigger(udphy, true);
 		} else {
 			rk_udphy_dp_hpd_event_trigger(udphy, false);
-- 
2.53.0



