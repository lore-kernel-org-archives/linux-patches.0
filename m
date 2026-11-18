Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025222;
	b=joDp1tEKMjYsdel651rfvNvZF77sk3vxvKwuuvqGC5SIxXyVYWgH9qk/vwC0BnWROg4O
	 Av3RN0ccNo7W53FrQ2bsTUrpgXpQU7Bm2GwpVB41t4sKJuWMU6vngbenbZpaadRt3Tvvt
	 nWaKaXfwWtDvD/6SWbTSCmKT55roNtHw/CUASZTccMm4tx5IS43DPQLapfdlncM46ntKO
	 VgH87WFTrJbAX3JsShW0UvokW7inZgXL8mY5WfrTAcFSW7XZpttjrv8TJ8xOT8TEfLNLB
	 JVBlxeSr/wNfSOz+jf+hP1Da5BVAxNhsEEVeGPvsGL8Uaigclf9gf6s9Ez3LgPLBQvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025222;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1vKg8oiB1uYsWprYAJ65f+HCk0p4OtwKpHlrvN2GQ34=;
	b=MqNzkoJzT8H+/oI9pRHZe4ntX0YIFolTVBm+iopuFU+EBRElyZhVa57GJXF/QOhGdmgy
	 vdtbaQqIEfZj8LASM9d6ZBR29sNCOXNGId9eAg7WaUGFGS0n9HZTFIES8AeM3ymxPL7Ww
	 pL1QMsdCgsFfMzwf8CZIWFN7QkAyNO1qOj+xsX4f0+eQc9ccgEK3I+D09Pl6cSAVx69Je
	 SFGqMlBiGv6uTE90N8DTf7D2HwnWxr2avYGl3BFYRQoKQXjFv6DNjgLvNSlMWZTwzkMNo
	 FoT8KtT9v2UAfsYuKKsyxfW3Kv/Y0H7i7x+HIXEe7ePrDh5cjcjsh25H5PTCnpoNv+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=idTfMUCN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D642E606A31C;
	Wed, 18 Nov 2026 18:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=idTfMUCN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C891F000C4;
	Wed, 18 Nov 2026 18:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025222;
	bh=1vKg8oiB1uYsWprYAJ65f+HCk0p4OtwKpHlrvN2GQ34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=idTfMUCN1xWCDF1x5ZDWu2Oq2H+A8fJYgxHgQdhIk7dYKGwASJWH4epqguFEnHyud
	 jduWjfh1Q0oP3jSPwUuir90VrSdl+tm9UNJA5ITIFUTjWIchY8zKClzP4kp8iWpz+f
	 PgkxsEgW0yoQxyvk1LkGmKylM3XNQYy4yolN3AZg=
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
Subject: [PATCH 6.18 1002/2151] phy: rockchip: usbdp: Properly handle TYPEC_STATE_SAFE and TYPEC_STATE_USB
Date: Wed, 18 Nov 2026 15:45:37 +0100
Message-ID: <20261118150158.939647579@linuxfoundation.org>
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

[ Upstream commit b1ca8de219ae6e4d9eec22acfbe4357d8addd94c ]

Handle TYPEC_STATE_SAFE and TYPEC_STATE_USB Type-C state events,
so that the muxing is properly updated when exiting DP AltMode.

Fixes: 2f70bbddeb45 ("phy: rockchip: add usbdp combo phy driver")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/message/20260619155020.CC7361F000E9%40smtp.kernel.org
Tested-by: Igor Paunovic <royalnet026@gmail.com> # Orange Pi 5 Plus
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260915-rockchip-usbdp-cleanup-part2-v15-5-8d507cb1174f@collabora.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-usbdp.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-usbdp.c b/drivers/phy/rockchip/phy-rockchip-usbdp.c
index cde90d0c44430..d1d78d9f7b096 100644
--- a/drivers/phy/rockchip/phy-rockchip-usbdp.c
+++ b/drivers/phy/rockchip/phy-rockchip-usbdp.c
@@ -1274,18 +1274,27 @@ static const struct phy_ops rk_udphy_usb3_phy_ops = {
 	.owner		= THIS_MODULE,
 };
 
+static bool rk_udphy_is_supported_mode(struct typec_mux_state *state)
+{
+	/* Handle Safe State and USB State */
+	if (state->mode < TYPEC_STATE_MODAL)
+		return true;
+
+	/* Handle DP AltMode */
+	if (state->alt && state->alt->svid == USB_TYPEC_DP_SID)
+		return true;
+
+	return false;
+}
+
 static int rk_udphy_typec_mux_set(struct typec_mux_dev *mux,
 				  struct typec_mux_state *state)
 {
 	struct rk_udphy *udphy = typec_mux_get_drvdata(mux);
 	u8 mode;
 
-	/*
-	 * Ignore mux events not involving DP AltMode, because
-	 * the mode field is being reused, e.g. state->mode == 4
-	 * could be either TYPEC_MODE_USB4 or TYPEC_DP_STATE_C.
-	 */
-	if (!state->alt || state->alt->svid != USB_TYPEC_DP_SID)
+	/* Ignore mux events not involving USB or DP */
+	if (!rk_udphy_is_supported_mode(state))
 		return 0;
 
 	mutex_lock(&udphy->mutex);
-- 
2.53.0



