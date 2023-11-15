Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2CCC3A8FA
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vzi585yO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C1FC433C7;
	Wed, 15 Nov 2023 19:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076441;
	bh=GyP+/5pEXj0PyW1wkWj/vDsjnR4YoGenG6CmAZgkWBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vzi585yOgl1taPwqHqoEcS9s7hFG+3H6HCx8hbC4EMKdJZw38ShwGxC7CkFVqf2RP
	 FU+j+gPIS3SiYV5SIyPl7WaDrM6l2Jl536qGEp9jLMVXNk1+rPhfcFQYQkxUebPuya
	 Wj9TYbbVRF33xfCFCI4OHfQFMwliqwvne3Bv9iLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 291/550] arm64: dts: imx8mp-debix-model-a: Remove USB hub reset-gpios
Date: Wed, 15 Nov 2023 14:14:35 -0500
Message-ID: <20231115191620.975131241@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit 0ce9a2c121e3ab354cf66aeecd3ed0758f3c5067 ]

The SAI2_TXC pin is left unconnected per the imx8mp-debix-model-a
schematics:

https://debix.io/Uploads/Temp/file/20230331/DEBIX%20Model%20A%20Schematics.pdf

Also, the RTS5411E USB hub chip does not have a reset pin.

Remove this pin description to properly describe the hardware.

This also fixes the following schema warning:

hub@1: 'reset-gpios' does not match any of the regexes: 'pinctrl-[0-9]+'
from schema $id: http://devicetree.org/schemas/usb/realtek,rts5411.yaml#

Fixes: 0253e1cb6300 ("arm64: dts: imx8mp-debix: add USB host support")
Signed-off-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-debix-model-a.dts | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-debix-model-a.dts b/arch/arm64/boot/dts/freescale/imx8mp-debix-model-a.dts
index 1004ab0abb131..b9573fc36e6f7 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-debix-model-a.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mp-debix-model-a.dts
@@ -285,7 +285,6 @@ &usb_dwc3_1 {
 	usb_hub_2_x: hub@1 {
 		compatible = "usbbda,5411";
 		reg = <1>;
-		reset-gpios = <&gpio4 25 GPIO_ACTIVE_LOW>;
 		vdd-supply = <&reg_usb_hub>;
 		peer-hub = <&usb_hub_3_x>;
 	};
@@ -294,7 +293,6 @@ usb_hub_2_x: hub@1 {
 	usb_hub_3_x: hub@2 {
 		compatible = "usbbda,411";
 		reg = <2>;
-		reset-gpios = <&gpio4 25 GPIO_ACTIVE_LOW>;
 		vdd-supply = <&reg_usb_hub>;
 		peer-hub = <&usb_hub_2_x>;
 	};
@@ -444,7 +442,6 @@ MX8MP_IOMUXC_UART4_TXD__UART4_DCE_TX				0x49
 	pinctrl_usb1: usb1grp {
 		fsl,pins = <
 			MX8MP_IOMUXC_GPIO1_IO14__USB2_OTG_PWR				0x10
-			MX8MP_IOMUXC_SAI2_TXC__GPIO4_IO25				0x19
 		>;
 	};
 
-- 
2.42.0



