Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A16A29D26E;
	Wed, 20 May 2026 17:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298361; cv=none; b=KSvZ8+d6WbdvpHuOl+anqdJ9bz9emIZR4vHVti3cIShM7luoDf5WFH3CGbGeMNT33WqXh/LRSIsuA4SVZW8bPuSBrlwcw5FyTYmvrHTeGpZT18nSwAEAbMPnI/g5wOtqVA1WI3BxAJS9DdPaXIm7aAvqLX+dC/n0Eib8jfdnl9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298361; c=relaxed/simple;
	bh=utxKUp6pvkf1aVMus1QHg2eNnieKQCIdsCv5hJUnYCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=USFTDMDkOFhUf/pyEGc98jl1AWJPinQph/t0VSp2OPQMCtasYs0kRkhA3VYgtVNs96u288/niLfMBopTr7ksAVRYyAts4LTfdcHoIdi0OoYsMxnr8ZnbqjTFoFInGmtNmFtGQuxo11B3mVscnZPXY/hyBlmnGxjQ4Urmy8a0M38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wWjxOAl6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wWjxOAl6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A18701F000E9;
	Wed, 20 May 2026 17:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298360;
	bh=KKwuQRRG9iOPOLX+YYdmGkzEPrzyo1+UsVArSZUXuNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wWjxOAl6/qkUb3aodXn2LQgFdNDJZXLDwyC31vjvjWn5tb5inJv+I6DeOm4t397fz
	 r2II7mknbGaSO5Nj5SREJqIY5/uMnsxj8drCEC+uT1GOHU+NrfBDNnPM9Lpb8hkYxP
	 uyrihuNd+eB41FW9Q5K3HUjb72Td/tQhdTDIi+wE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 380/957] arm64: dts: imx8mp-kontron: Fix touch reset configuration on DL devices
Date: Wed, 20 May 2026 18:14:23 +0200
Message-ID: <20260520162142.769620057@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frieder Schrempf <frieder.schrempf@kontron.de>

[ Upstream commit 058c53476dde9937877e93d964a283bbb5e1e4c7 ]

The reset signal needs a pullup, but there is no hardware pullup.
As a workaround, enable the internal pullup to fix the touchscreen.

As this deviates from the default generic GPIO settings in the OSM
devicetree, add a new node for the touch pinctrl and redefine the
generic gpio1 pinctrl.

Fixes: 946ab10e3f40f ("arm64: dts: Add support for Kontron OSM-S i.MX8MP SoM and BL carrier board")
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/freescale/imx8mp-kontron-dl.dtso | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-kontron-dl.dtso b/arch/arm64/boot/dts/freescale/imx8mp-kontron-dl.dtso
index a3cba41d2b531..7131e9a499ae1 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-kontron-dl.dtso
+++ b/arch/arm64/boot/dts/freescale/imx8mp-kontron-dl.dtso
@@ -77,6 +77,8 @@
 	touchscreen@5d {
 		compatible = "goodix,gt928";
 		reg = <0x5d>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&pinctrl_touch>;
 		interrupt-parent = <&gpio1>;
 		interrupts = <6 8>;
 		irq-gpios = <&gpio1 6 0>;
@@ -98,6 +100,16 @@
 	status = "okay";
 };
 
+/* redefine to remove touch controller GPIOs */
+&pinctrl_gpio1 {
+	fsl,pins = <
+		MX8MP_IOMUXC_GPIO1_IO00__GPIO1_IO00		0x19 /* GPIO_A_0 */
+		MX8MP_IOMUXC_GPIO1_IO01__GPIO1_IO01		0x19 /* GPIO_A_1 */
+		MX8MP_IOMUXC_GPIO1_IO05__GPIO1_IO05		0x19 /* GPIO_A_2 */
+		MX8MP_IOMUXC_GPIO1_IO08__GPIO1_IO08		0x19 /* GPIO_A_5 */
+	>;
+};
+
 &pwm1 {
 	status = "okay";
 };
@@ -108,4 +120,11 @@
 			MX8MP_IOMUXC_SAI3_RXFS__GPIO4_IO28		0x19
 		>;
 	};
+
+	pinctrl_touch: touchgrp {
+		fsl,pins = <
+			MX8MP_IOMUXC_GPIO1_IO06__GPIO1_IO06		0x19
+			MX8MP_IOMUXC_GPIO1_IO07__GPIO1_IO07		0x150
+		>;
+	};
 };
-- 
2.53.0



