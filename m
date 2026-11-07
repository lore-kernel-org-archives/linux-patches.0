Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064079;
	b=VADnQ4UB8xYz1SaupimRiWPdpcfIrUdbuyHvzfBYJI/3CxaJdrmoNp7goeiyCC+UInu7
	 jWA/I2nIFxF+01Ltk4WxDy1oSHCSSAjB4h0CiljfDccgpRlVlz3PUI4PrHJWvR/oFg/je
	 B85jyl8dH27VItyuu9zlfiHa+8MJjc1gpfY3qWb05Yxaum0kjXlJIxXCdkU3az+ginaSO
	 fmHUjZuDlpVA1tRMNQ3ROP2knjaTm7/P7kuTvoayWHqANasM5X/wctZh2rTLYAWF/B4qr
	 gw++fKlScP2iBZajlbGBHBuBJ4zOJkP+yAPJ8ONR+L8nu/468ZuF+155wbEgeX2K3sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064079;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L41p5u8ZIr/PICHSndUqYp/D1PvBMLPo+a8fy86SJOY=;
	b=xzd8uEHilTsA3lQgy+GZ4Uyr9gvo1F8pKMGk4BWcaah/pKOqeFWNfUmt6R4HmarKw+FL
	 T8iVCxTZSIFlz5MurNBbCQsyWzLePoJw3pUz9tQg7HG+EI7xyyAU3LC60YEAFRGpeDYjQ
	 UnTA9UEDOmYk/iYtbMi1kGIH18+FXXnPd1/5JqEeAZBvBQba7CApLBBfo5vZEWT+2c/GZ
	 yt4vurKITIXUn53r+ZQGVJufs6b5kVs0B+qX+m5BP3yjf6eEOMgU4zyWVcpPV8/54W1zt
	 aBcYGjsI0tZEsdWcoyAxIFVyMsRTx160qGHzZngDPj/HIvfpaQhSWM1xaIQ4J43/ApA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cn5+G2CW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FA6606A9ED;
	Sat,  7 Nov 2026 15:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cn5+G2CW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A270F1F0089F;
	Sat,  7 Nov 2026 15:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064078;
	bh=L41p5u8ZIr/PICHSndUqYp/D1PvBMLPo+a8fy86SJOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cn5+G2CWF9h8LhFxUIr4IQ2ZTl0/7z9eSxcxsu8hyYuDsO9mPuiSblhB+dnmwM1Xq
	 lkNUKry3/23nkM93Q3lXYfOuY4uJpYCIcmYMsdoFXzqIrwI8GvV5vc3paC2PlUbfLi
	 AdXIjV+DkeISf8nfQ6/IwXp6rYUVVcLicJWBlHiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Wadim Egorov <w.egorov@phytec.de>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0244/1257] arm64: dts: ti: k3-am62x-phyboard-lyra: Set SD clock pin as OUTPUT
Date: Sat,  7 Nov 2026 08:42:20 -0500
Message-ID: <20261107134946.252924906@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Judith Mendez <jm@ti.com>

[ Upstream commit 1d62ef8d47b535d31fb9cf38e5c36eb55b0189a4 ]

MMC clock pins must be configured as OUTPUT-only per TRM [0] with
receiver disabled (RXACTIVE bit = 0). Change MMC CLK pins from
PIN_INPUT to PIN_OUTPUT to match documentation.

[0] https://www.ti.com/lit/pdf/spruiv7 Rev. C: Table 12-246. MMCSDi I/O Signals

Fixes: f1b3adade045 ("arm64: dts: ti: Add am62x-phyboard-lyra carrier board")
Cc: stable@vger.kernel.org
Signed-off-by: Judith Mendez <jm@ti.com>
Reviewed-by: Moteen Shah <m-shah@ti.com>
Acked-by: Wadim Egorov <w.egorov@phytec.de>
Link: https://patch.msgid.link/20260909214743.899477-16-jm@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62x-phyboard-lyra.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62x-phyboard-lyra.dtsi b/arch/arm64/boot/dts/ti/k3-am62x-phyboard-lyra.dtsi
index d6e70ee15938e..c9b3e0518faf5 100644
--- a/arch/arm64/boot/dts/ti/k3-am62x-phyboard-lyra.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62x-phyboard-lyra.dtsi
@@ -227,7 +227,7 @@ AM62X_IOPAD(0x068, PIN_INPUT, 3) /* (R21) GPMC0_AD11.MCASP2_AXR3 */
 	main_mmc1_pins_default: main-mmc1-default-pins {
 		pinctrl-single,pins = <
 			AM62X_IOPAD(0x23c, PIN_INPUT_PULLUP, 0) /* (A21) MMC1_CMD */
-			AM62X_IOPAD(0x234, PIN_INPUT_PULLDOWN, 0) /* (B22) MMC1_CLK */
+			AM62X_IOPAD(0x234, PIN_OUTPUT_PULLDOWN, 0) /* (B22) MMC1_CLK */
 			AM62X_IOPAD(0x230, PIN_INPUT_PULLUP, 0) /* (A22) MMC1_DAT0 */
 			AM62X_IOPAD(0x22c, PIN_INPUT_PULLUP, 0) /* (B21) MMC1_DAT1 */
 			AM62X_IOPAD(0x228, PIN_INPUT_PULLUP, 0) /* (C21) MMC1_DAT2 */
-- 
2.53.0



