Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD202590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:25:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16FCAC433D2;
	Sun, 22 Jan 2023 15:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674401117;
	bh=zrw4gvJxZUcXgyLe7QzFTvXZhIDKTkg54A6elqKID4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bB7GyEhhYrhe7M5XontJrGLnLUR4sWpSHoaUZ1zuxtixv7xwq2Jfke1Rlcr649sUQ
	 hi9v2vsp6dwvnOg3pr9TaSrCXOswNe16qwlmSeH2jJSQrpQU0Bf+/E893C6C7RNnqU
	 17yfazh4kLEM8G0Th1LvwencaSNYmoYuTDWnKzQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Li Jun <jun.li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.1 116/193] arm64: dts: imx8mp: correct usb clocks
Date: Sun, 22 Jan 2023 16:04:05 +0100
Message-Id: <20230122150251.636547230@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Li Jun <jun.li@nxp.com>

commit 8a1ed98fe0f2e7669f0409de0f46f317b275f8be upstream.

After commit cf7f3f4fa9e5 ("clk: imx8mp: fix usb_root_clk parent"),
usb_root_clk is no longer for suspend clock so update dts accordingly
to use right bus clock and suspend clock.

Fixes: fb8587a2c165 ("arm64: dtsi: imx8mp: add usb nodes")
Cc: stable@vger.kernel.org # ed1f4ccfe947: clk: imx: imx8mp: add shared clk gate for usb suspend clk
Cc: stable@vger.kernel.org # v5.19+
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Tested-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Li Jun <jun.li@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8mp.dtsi |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/arm64/boot/dts/freescale/imx8mp.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
@@ -1279,7 +1279,7 @@
 			reg = <0x32f10100 0x8>,
 			      <0x381f0000 0x20>;
 			clocks = <&clk IMX8MP_CLK_HSIO_ROOT>,
-				 <&clk IMX8MP_CLK_USB_ROOT>;
+				 <&clk IMX8MP_CLK_USB_SUSP>;
 			clock-names = "hsio", "suspend";
 			interrupts = <GIC_SPI 148 IRQ_TYPE_LEVEL_HIGH>;
 			power-domains = <&hsio_blk_ctrl IMX8MP_HSIOBLK_PD_USB>;
@@ -1292,9 +1292,9 @@
 			usb_dwc3_0: usb@38100000 {
 				compatible = "snps,dwc3";
 				reg = <0x38100000 0x10000>;
-				clocks = <&clk IMX8MP_CLK_HSIO_AXI>,
+				clocks = <&clk IMX8MP_CLK_USB_ROOT>,
 					 <&clk IMX8MP_CLK_USB_CORE_REF>,
-					 <&clk IMX8MP_CLK_USB_ROOT>;
+					 <&clk IMX8MP_CLK_USB_SUSP>;
 				clock-names = "bus_early", "ref", "suspend";
 				interrupts = <GIC_SPI 40 IRQ_TYPE_LEVEL_HIGH>;
 				phys = <&usb3_phy0>, <&usb3_phy0>;
@@ -1321,7 +1321,7 @@
 			reg = <0x32f10108 0x8>,
 			      <0x382f0000 0x20>;
 			clocks = <&clk IMX8MP_CLK_HSIO_ROOT>,
-				 <&clk IMX8MP_CLK_USB_ROOT>;
+				 <&clk IMX8MP_CLK_USB_SUSP>;
 			clock-names = "hsio", "suspend";
 			interrupts = <GIC_SPI 149 IRQ_TYPE_LEVEL_HIGH>;
 			power-domains = <&hsio_blk_ctrl IMX8MP_HSIOBLK_PD_USB>;
@@ -1334,9 +1334,9 @@
 			usb_dwc3_1: usb@38200000 {
 				compatible = "snps,dwc3";
 				reg = <0x38200000 0x10000>;
-				clocks = <&clk IMX8MP_CLK_HSIO_AXI>,
+				clocks = <&clk IMX8MP_CLK_USB_ROOT>,
 					 <&clk IMX8MP_CLK_USB_CORE_REF>,
-					 <&clk IMX8MP_CLK_USB_ROOT>;
+					 <&clk IMX8MP_CLK_USB_SUSP>;
 				clock-names = "bus_early", "ref", "suspend";
 				interrupts = <GIC_SPI 41 IRQ_TYPE_LEVEL_HIGH>;
 				phys = <&usb3_phy1>, <&usb3_phy1>;


