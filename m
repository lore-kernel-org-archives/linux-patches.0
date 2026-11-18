Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018363;
	b=fuffSAM+orsxg4OwIRrrAWUsL7nPYFADuDsZy9Secmcy6GA71+GV+7opZ//1nSLiQRL7
	 PyBL6OZiWgnEAMJJrqT4Sp7STCXBCa+OEGDSW4d466opjORscvtJlyP/X9oGR4ZsUXiSz
	 eu0t4Qh6S2yjUH+dNTPMaHJR5dJvf1j5DbrJAvYaEtcKvrd0fzq22QlMLL+El9171EAqj
	 ACwH/5T8sTJubTkTrBLs82FPwbbcrBdsP3lHRBWyuwb/DtDYGEyWSuqfhElI+c1maY546
	 WBgSXKdc9lW//5zL4xQUwn118jkzQS8xXf+FqGcxKNTqQHMn8Lew9uFnEaAiAuNYG8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018363;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iwuodzZXBuW0tbbCEJ2n0KwYU3SseRyRuXgrXyg5J9k=;
	b=hiCu8k+6M25rBywH/1PVvkerznr4mZuM4NCCz1tv+7ZmIuFXP/0VaynSgibQApDiC8SS
	 QqFZyKkGiJFN42Or/lWdBrVUI9cahhpYUaE7ttQ1zqW62TzxKQmWWTMVLteDKYW0IwC7Y
	 B/9vWApQBFehR4fQM79dHwREWRELLpdHlwJNB459rtaGAyOFSBD7adFhIpJxvyU3mwaJc
	 fd9cvXRzxkaSx1yhryLBzIMtX98ml8FL23QsgaIOdbFddGI1FfXSH0fn2HAbzkQBJhEut
	 U7KY+xpVl61D5b36OCBD+9umkNkI/Xi+ma6BY76m+Tkmd6BGLrhL9N+PtfPrLNCFstA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pm0LpJCk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B63606A337;
	Wed, 18 Nov 2026 16:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pm0LpJCk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 089AA1F000C4;
	Wed, 18 Nov 2026 16:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018362;
	bh=iwuodzZXBuW0tbbCEJ2n0KwYU3SseRyRuXgrXyg5J9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pm0LpJCkN9BiPWbBRcUavSipL2cQAsD7ng7xybppy0yxS0yNomN6o4NybqULdR52A
	 ts/OCw5r+e5lkot5KwVsl6lygD/y0E5cfu+9hKX8HFBHZXT3XuOPFOEmmNtdaVRcfT
	 6A1rflOANAGbqUkTeAlyXZiAorscO9/22Wyih0ug=
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
Subject: [PATCH 7.3 1212/2651] phy: rockchip: usbdp: Properly handle TYPEC_STATE_SAFE and TYPEC_STATE_USB
Date: Wed, 18 Nov 2026 15:40:52 +0100
Message-ID: <20261118150331.631168171@linuxfoundation.org>
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
index 611c24030f33f..572c76f2c2126 100644
--- a/drivers/phy/rockchip/phy-rockchip-usbdp.c
+++ b/drivers/phy/rockchip/phy-rockchip-usbdp.c
@@ -1273,18 +1273,27 @@ static const struct phy_ops rk_udphy_usb3_phy_ops = {
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



