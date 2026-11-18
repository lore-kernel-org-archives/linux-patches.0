Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018354;
	b=WCLzDoTGD96zID3ONTzBPvBIk5vq/uwODXN7dAVNhGJjkmcCwivVcUsi/J2CIiIoMhMX
	 nWpwhcMe2Pf/99uDFDsv/9Z+Z4qa8udsNVrwZ4p1XjH1nYt9j89pAzsodkNjOKxg7oI6A
	 qEuu2tB7t5rw3t8ApP29NxCUl/fZlbHFR++j3ol0Ea18QwxvnPVcxNk+JMlVPV5LF4yy+
	 MgFqI4UqKfvV5PszeL9ncUpKT5kukIfMAJoN4YRHvFObkQahNqnzneiEqqyb6Ip14BBG8
	 eDyfKgxrYYFTD4EpxFBZIOFSKBfb3PCidUrRxQm/x6f822YvkmKikJs4vZC5nB2aAjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018354;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NrEq7CssJenvXRakUQvt0FTUFT8ddIt2cv5QNQXrjxY=;
	b=XoCs8TzY1qbFOCeWJ6j3GIgqIBvbi/tPzqaaQiCXqiS08Ej+oksRSeK3weQDAbHg4HxK
	 FJ9U7ZdDtMbOaK9kV5NrCvWXpZrmnBFuOeY8V4udM2RfBB/8s+qyCVrEy1UfNOLVQgM4f
	 9BVchsABbMktQ5Re4lADS7dv13/PiRLr2ic0LW6Uz8rvnaCnyd6gUl4yjEUoAxACNVANY
	 sJ84OacZyO1tepXgQ8QLjJxj9f/rs8qHJymDDeN+OkEwGPmj9L7ONiQDS5DNLEUS95rT0
	 JQp/IS3esQstv7Q8SCnAaUoqz2HA+x0htzkBGoNNf8i81Cmp8Cz9lOFvB6i61+/uSPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2HC6lBLw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8434C606A325;
	Wed, 18 Nov 2026 16:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2HC6lBLw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973141F000C4;
	Wed, 18 Nov 2026 16:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018354;
	bh=NrEq7CssJenvXRakUQvt0FTUFT8ddIt2cv5QNQXrjxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2HC6lBLwH/CSISxGHnH9cl1W4taCy6GIwsNVD3s8+EOtKatlh15CdEgoF14GKdD5E
	 nFKjP0eldOsjNVzXtCcC6DuXOWqrgrtNjqYGB0F2EAnCqU+YHmoVhmxyWcTtclMuYU
	 baBtw2ZMJ0qVcE8nLcbPcX+tAn2tjkGDqI7/CFGA=
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
Subject: [PATCH 7.3 1209/2651] phy: rockchip: usbdp: Add missing mode_change update
Date: Wed, 18 Nov 2026 15:40:49 +0100
Message-ID: <20261118150331.518610514@linuxfoundation.org>
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
index d3ebd9ed56dde..fd11f294be074 100644
--- a/drivers/phy/rockchip/phy-rockchip-usbdp.c
+++ b/drivers/phy/rockchip/phy-rockchip-usbdp.c
@@ -615,6 +615,15 @@ static void rk_udphy_dp_hpd_event_trigger(struct rk_udphy *udphy, bool hpd)
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
@@ -645,7 +654,7 @@ static void rk_udphy_set_typec_default_mapping(struct rk_udphy *udphy)
 		gpiod_set_value_cansleep(udphy->sbu2_dc_gpio, 1);
 	}
 
-	udphy->mode = UDPHY_MODE_DP_USB;
+	rk_udphy_mode_set(udphy, UDPHY_MODE_DP_USB);
 }
 
 static int rk_udphy_orien_sw_set(struct typec_switch_dev *sw,
@@ -1363,10 +1372,7 @@ static int rk_udphy_typec_mux_set(struct typec_mux_dev *mux,
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



