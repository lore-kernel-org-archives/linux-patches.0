Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038630;
	b=mj0omisd5FGLRl5yKYNdW70Ss+OnWPCBPzx9u6UoH1ODaVAjxMZl68vH00e6aJafSgs6
	 Wl2xnc6QxWgjqNY9zLqB/YkwACCG0eWAeoG6YWxiQBWICfttmnPhf1ztyeLq8nyu1tfod
	 kqAl7maa52qcfhZ55Tjwl7mQgMCNNwg70GeXT9n4s6980ZXKo/ivSrm+hAtumkrPBOEPF
	 CjqPQ3IupBHGryRopnITbLATME0SVGFV9ZfvrvvxumXQ4iXC3XXEU5at/U8a8Ki5KE/xk
	 3yN/2kY0H9CWYJ22TYRxpinm3tXF2eYdfo8MnHV2r83Lsu+bX/cg8CwySr1O0kOmrag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038630;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f5IG87LPk/W8fzKUG6ohnZImw7zpS75KbLLhqlGYqVE=;
	b=mAdGHwuPJ/VbTohuseBZNEsZCr0A22/rDAPc6VIv2AuNB3rxF0nVICGQVXWCRI0BU5HF
	 uNPrWFRF8dOHhk96Ghdt0VfNXel6GgGw/rafKDmeUF+wk3tpxZ3q4xRC7jB7D1dglEFRR
	 3EqzbMBZmni2ptEQ5Zt+uZoZ32zS85Ljkys9Zq36j9rmKUbmHUULEWFsCNwYkxiffcHWh
	 qY96IYCTo0mAK2bFn4CXSUgBm1Ji7RWtusTLw/xijFXBYvWzBIEuOSFQBUC3dYasUO74H
	 IH5Onz3Ds/PNPZal7OdDsDw9UDtJZajWG8Vp/3DWGms2C2ukWfRubGkgusIld/FYDLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FdzrdeDG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6E8606A325;
	Wed, 18 Nov 2026 21:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FdzrdeDG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D8181F000C4;
	Wed, 18 Nov 2026 21:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038630;
	bh=f5IG87LPk/W8fzKUG6ohnZImw7zpS75KbLLhqlGYqVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FdzrdeDGIYLP5YzCNnBhrWHFXBgqT69Jj+4WcMAbNUwmFs/LQ8F/kX8kK6PaUaVJU
	 Q73nkMz9u0SBI304SHYypLLFg6yIsAGDtvQip8bSofwh0qe79Nbrd7MfV3OH+SgQT4
	 ErVXd6pnD+Y6agD4RLCtEGWoWXYo0phpOIQ4IUno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1784/3318] arm64: dts: freescale: imx8mp-verdin-yavia: fix external GPIOs
Date: Wed, 18 Nov 2026 15:40:06 +0100
Message-ID: <20261118150415.378220953@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francesco Dolcini <francesco.dolcini@toradex.com>

[ Upstream commit f377ac5999a5d045168ddd25d204691c6653c06a ]

pinctrl_gpios_ext_yavia (SODIMM 64/66) is defined but never applied to
gpio3, so those pins stay at their NAND reset function instead of GPIO.

Fix SODIMM 64 to the correct pad, MX8MP_IOMUXC_NAND_READY_B (GPIO3_IO16).

Fixes: b694fbe2ff40 ("arm64: dts: imx8mp-verdin: Add yavia carrier board")
Cc: stable@vger.kernel.org
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
[ sashal: Adjusted surrounding context to account for missing GPIO4 and HDMI blocks. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-verdin-yavia.dtsi | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-verdin-yavia.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-verdin-yavia.dtsi
index db1722f0d80ef..fa24ac10f4ddf 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-verdin-yavia.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-verdin-yavia.dtsi
@@ -100,6 +100,11 @@ &flexcan1 {
 	status = "okay";
 };
 
+&gpio3 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pinctrl_gpios_ext_yavia>;
+};
+
 &hwmon_temp {
 	status = "okay";
 };
@@ -205,7 +210,7 @@ MX8MP_IOMUXC_NAND_DATA03__GPIO3_IO09	0x106	/* SODIMM 62 */
 
 	pinctrl_gpios_ext_yavia: gpiosextyaviagrp {
 		fsl,pins = <
-			MX8MP_IOMUXC_NAND_CE1_B__GPIO3_IO02	0x106	/* SODIMM 64 */
+			MX8MP_IOMUXC_NAND_READY_B__GPIO3_IO16	0x106	/* SODIMM 64 */
 			MX8MP_IOMUXC_NAND_DQS__GPIO3_IO14	0x106	/* SODIMM 66 */
 		>;
 	};
-- 
2.53.0



