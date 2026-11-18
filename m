Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025211;
	b=EnYuy/BZfg6gwj9wX9c5kItBquyO2LLjciyGWO/kX8cYuRq1IbGPcsSDPH6rPoJ0Ydic
	 JSmAY7ZFZrlrysEYNBgFhjo8UxgLWYBj18YB78jh/dzptjfyF9tybKZyX2fyagffcKOy4
	 M2pLZC1bHY5dX4iR+E7JQBi2zalMTHlOr2qJOcERjdY5ySimdplYQjjp47/STQgKHDxCv
	 0OYmqDYbgVze0l3nGpjv4Fh00Pj6HQfIq5aJ+o9xKyO8ZVfhwpzBavZUTJrn1rrFcJHzX
	 zRoRSPaK6WLaGP8DXGncSIQOomhb6VDoYCQAt3L5kaHEZrc4ijnS1APy6ATkkme+IVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025211;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Bgf0gLCqInqlGvmwdpupCD8Dm+C5ysdVfsFoTRB2sI8=;
	b=TpwHluNJSIXdLnwHMF/ktM9HvJofMl7zSkEG2JpKFynKPGmPpkYMprJV3nHpY2ucnxY6
	 Ohz/dBW1WKkeoCsxoJ9CH94xR1Lzem5f5+cQMg5WXGVocl+psjF3iZc8x+r7TokXLaH5u
	 RH2669cil0PshWEx/Gz+E/blQ9hK13sThfLkIEC118I0mIgw5QwLfJKh3FPzUo7OI/+fh
	 73rAjztDjrjNj5d2G1fJfhmgWYoE7QMlJpJALRIVuycqqFRjgPwE33NdcgevDQx0ifJz9
	 D+kPcx0QsMA6DhBXlyrrexwKq/B4ho5oIE5c67UeGTJu9rPZVeyOG4HN8lbb6dMs21Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="m1QMEd3/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2AC606A31C;
	Wed, 18 Nov 2026 18:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m1QMEd3/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD8F1F000C4;
	Wed, 18 Nov 2026 18:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025211;
	bh=Bgf0gLCqInqlGvmwdpupCD8Dm+C5ysdVfsFoTRB2sI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m1QMEd3/2kzW4ddXoSLrJkE+oIRE6jvlgBLNt4cH+5dil9UioqPkR20wzxnuLsYMQ
	 ZPSaHH0bIpDNlFiFAY9tcK3ycXm6545gwriQZFGuF+6Hzl/ycBr99dlkJlHOtXFfvZ
	 1CkZIsIuwfMRotfGwE4HTBe313RHNW/lsx8noBhU=
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
Subject: [PATCH 6.18 0999/2151] phy: rockchip: usbdp: Add missing mode_change update
Date: Wed, 18 Nov 2026 15:45:34 +0100
Message-ID: <20261118150158.834609440@linuxfoundation.org>
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
index ff66b88abdbd3..16a41776b2f9f 100644
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



