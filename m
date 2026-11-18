Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030814;
	b=jf9AaO2Zo7q0UsIizX0MqtGP2WALs3dheSTFQoqVDwJQhyIPV3J1N7Hx3nA25ErQ+Lj4
	 w4vt0dshqATte9ehUJcaG4GR0LYg2WyqsJH0sqqG3wrv9yrUXIpBDlF7oP8hKYuqK1p+4
	 v4g1X86D56HBkLlMwwjedBfcj7fU2hB+LJaBz2wG8zRpwVBy3CK9xxpZdh9s6/KNaJq1a
	 5hLRr4VMoCYU/a5aVo/5oxLuU+woTUkdAZj6GCv2H/pRfui8UhuYxGcC9Eic8X7AQ6lsH
	 HpZZDKK0pogET8WfpFfHLtqthNYoviXxCoLuo9nYHJqoQmTZF9lQBtktsYaTuT4LnWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030814;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mi3qj1scnhLI75NeVm8W480wdL95L913YPe0Pr6Mans=;
	b=4Xf0TxSS9r/+zKYDIlNtFwea5kso8M9jUQlt+BUaH4IWTD2bAQ1hf8HI8OQNLfZplG5u
	 PAKFLCfEActFgNJEJnm60nU1kxtVkStwXiiM0ldx4zUd5QM+mzFK9UAGcBg5sIxpUlZKB
	 aTe0rbxiRrP82LWCeQGbXuziaheapKvkk322NQNxaPXmnPLWIhJUQkYGGmT88VC5CKZd2
	 hDro9M13whKw81p6hrBg1wADwsu49pADZOu1oI2EW2H0ZoFlhF2YV9zDvrP2iGsrcX+GN
	 lwuFIAFVauWHsmcruJoglw97K1GffOuOIif/2ZwOu7wIgW8dzO2toDqGTCd2g/r3+WA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lBQFj7SE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93AA606A92E;
	Wed, 18 Nov 2026 19:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lBQFj7SE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09ED21F000C4;
	Wed, 18 Nov 2026 19:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030814;
	bh=Mi3qj1scnhLI75NeVm8W480wdL95L913YPe0Pr6Mans=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lBQFj7SEftj6pc+0YHfTenVIOXZyM8jqwz4gqOHQqYveZh8guPmCuJP9a/8ywUqdz
	 F2pVGv/ZyWaxppbEATqp2GGP1KTwDDSRREH3z6SA7L4hlze3F8Uewx++cqOoa3w7xe
	 YUECvGuqK4GRHg20kg2iX0Z6psSsjiDZZ0fu1qVI=
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
Subject: [PATCH 6.12 0787/1756] phy: rockchip: usbdp: Properly handle TYPEC_STATE_SAFE and TYPEC_STATE_USB
Date: Wed, 18 Nov 2026 15:48:34 +0100
Message-ID: <20261118150041.046777078@linuxfoundation.org>
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
index 71d144af18a76..05edd03761c37 100644
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



