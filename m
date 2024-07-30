Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B1931A616E;
	Tue, 30 Jul 2024 16:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356021; cv=none; b=IqC6TojxajtgOqduNvsRwcbwQnEB2Vk/p8BdAntvCbeDPoJc/SzEqKNDpRQrm6HiDFB0WHManar2rVmIC/1ydIvhEmSuHKpPklmQ6bTgs45EYlTRkYK6K09VjXCMYYy3uEoWMevLId0lXiR/qIgXu74d2fDjMqwfz5/Oe2bJ1nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356021; c=relaxed/simple;
	bh=iWxsWvTTzahwajsftmspzuof5cDByJTxnx64WREC1Ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lKmTxhucmoaG68LhwakgKaMoLz3tFKL0fh8KkBsB2qA0IUaOD0sL2TlXpeIESvrWoxHXAY9IrC8QRlrRllR4xT7Y37JiMhrrSdPoa02XBx+Ht+V31f6zP1SYtCnwhXux2RE0ih/PBn9rrm12C8zThgNMe8zxobISLi8iAPGxYIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1dnGKgSi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1dnGKgSi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE38C4AF0A;
	Tue, 30 Jul 2024 16:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356021;
	bh=iWxsWvTTzahwajsftmspzuof5cDByJTxnx64WREC1Ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1dnGKgSiTNc4MGzNe7Cy4t1XobX5F7biiIU2wmIYZWjU3VFzSB5Cu708F58PTK7lQ
	 UcVaeP4J4ysYHZxTkuF5cIKRSXXSnOzwG1MErqpgEneiJgvbbEdBNKRC6iPYq/O4eQ
	 bcJBqwQLehnG2YwUTJOOmBsV5eKI9myPrqvgIAF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 097/809] ARM: dts: imx6qdl-kontron-samx6i: fix SPI0 chip selects
Date: Tue, 30 Jul 2024 17:39:33 +0200
Message-ID: <20240730151728.465393183@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit 74e1c956a68a65d642447d852e95b3fbb69bebaa ]

There is a comment in the imx6q variant dtsi claiming that these
modules will have one more chip select than the imx6dl variant.
This is wrong. Ordinary GPIOs are used for chip selects and both
variants of the module share the very same PCB and both have this
GPIO routed to the SPI0_CS1# pin of the SMARC connector.

Fix it by moving the third chip select description to the common dtsi.

Fixes: 2125212785c9 ("ARM: dts: imx6qdl-kontron-samx6i: add Kontron SMARC SoM Support")
Signed-off-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/nxp/imx/imx6q-kontron-samx6i.dtsi     | 23 -------------------
 .../dts/nxp/imx/imx6qdl-kontron-samx6i.dtsi   |  5 +++-
 2 files changed, 4 insertions(+), 24 deletions(-)

diff --git a/arch/arm/boot/dts/nxp/imx/imx6q-kontron-samx6i.dtsi b/arch/arm/boot/dts/nxp/imx/imx6q-kontron-samx6i.dtsi
index 4d6a0c3e8455f..ff062f4fd726e 100644
--- a/arch/arm/boot/dts/nxp/imx/imx6q-kontron-samx6i.dtsi
+++ b/arch/arm/boot/dts/nxp/imx/imx6q-kontron-samx6i.dtsi
@@ -5,31 +5,8 @@
 
 #include "imx6q.dtsi"
 #include "imx6qdl-kontron-samx6i.dtsi"
-#include <dt-bindings/gpio/gpio.h>
 
 / {
 	model = "Kontron SMARC sAMX6i Quad/Dual";
 	compatible = "kontron,imx6q-samx6i", "fsl,imx6q";
 };
-
-/* Quad/Dual SoMs have 3 chip-select signals */
-&ecspi4 {
-	cs-gpios = <&gpio3 24 GPIO_ACTIVE_LOW>,
-		   <&gpio3 29 GPIO_ACTIVE_LOW>,
-		   <&gpio3 25 GPIO_ACTIVE_LOW>;
-};
-
-&pinctrl_ecspi4 {
-	fsl,pins = <
-		MX6QDL_PAD_EIM_D21__ECSPI4_SCLK 0x100b1
-		MX6QDL_PAD_EIM_D28__ECSPI4_MOSI 0x100b1
-		MX6QDL_PAD_EIM_D22__ECSPI4_MISO 0x100b1
-
-		/* SPI4_IMX_CS2# - connected to internal flash */
-		MX6QDL_PAD_EIM_D24__GPIO3_IO24 0x1b0b0
-		/* SPI4_IMX_CS0# - connected to SMARC SPI0_CS0# */
-		MX6QDL_PAD_EIM_D29__GPIO3_IO29 0x1b0b0
-		/* SPI4_CS3# - connected to  SMARC SPI0_CS1# */
-		MX6QDL_PAD_EIM_D25__GPIO3_IO25 0x1b0b0
-	>;
-};
diff --git a/arch/arm/boot/dts/nxp/imx/imx6qdl-kontron-samx6i.dtsi b/arch/arm/boot/dts/nxp/imx/imx6qdl-kontron-samx6i.dtsi
index 700780bf64f58..78cbc2df279e6 100644
--- a/arch/arm/boot/dts/nxp/imx/imx6qdl-kontron-samx6i.dtsi
+++ b/arch/arm/boot/dts/nxp/imx/imx6qdl-kontron-samx6i.dtsi
@@ -244,7 +244,8 @@ &ecspi4 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_ecspi4>;
 	cs-gpios = <&gpio3 24 GPIO_ACTIVE_LOW>,
-		   <&gpio3 29 GPIO_ACTIVE_LOW>;
+		   <&gpio3 29 GPIO_ACTIVE_LOW>,
+		   <&gpio3 25 GPIO_ACTIVE_LOW>;
 	status = "okay";
 
 	/* default boot source: workaround #1 for errata ERR006282 */
@@ -464,6 +465,8 @@ MX6QDL_PAD_EIM_D22__ECSPI4_MISO 0x100b1
 			MX6QDL_PAD_EIM_D24__GPIO3_IO24 0x1b0b0
 			/* SPI_IMX_CS0# - connected to SMARC SPI0_CS0# */
 			MX6QDL_PAD_EIM_D29__GPIO3_IO29 0x1b0b0
+			/* SPI4_CS3# - connected to SMARC SPI0_CS1# */
+			MX6QDL_PAD_EIM_D25__GPIO3_IO25 0x1b0b0
 		>;
 	};
 
-- 
2.43.0



