Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF96189900;
	Tue, 30 Jul 2024 16:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355563; cv=none; b=UY6U1bUtAnb3pfFAPWZXfgvgsvbAKZmvSOlxvfDy0X3HBQHS36GSvhW2948RINceUIzjcHVkThcMuwtdOTKi2+xQm0Hk6fuXY5VIKX+Jzeo50rkpVgZRnqJaHUrERNYf7maJHthlLuTDgxU5A2vpQJuLUnOlkwQUXYYGBlQYHOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355563; c=relaxed/simple;
	bh=w6vlrWJk8tw9/cJrMxjicLEGExLIoDA8qh1o+jq9B/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LYrXqT2i5JQL0qIzUbI7shkhRhNSIc9w4eDdNTRMuYBh38oAFYKdGeoqM8FYkRfy578HXK3pZq9xnKlMTvn8tOV/iFt+sT9Nngc8rzFBlhhUQ6IIRXogjjrwL3YMRQDaDVJMP2kLmwTsWw33tTX4M/wNGVsbAdMf0She4ckwUtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lF4S1Mn0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lF4S1Mn0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC92C4AF0A;
	Tue, 30 Jul 2024 16:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355563;
	bh=w6vlrWJk8tw9/cJrMxjicLEGExLIoDA8qh1o+jq9B/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lF4S1Mn0Ujr9GAZljKaXOkAIlN2QVrG/I/JTrib46YlgzigtqE3H5MXr9b+RxzRw/
	 HsjIwiQoarkz4FcY1+kTJF86t3tXIis/fYSMXIH8oBEXRDB+s/wHT4yWELABrDhbcl
	 tgYCLb++aHmj4dpjvYuNMD1vj8jkFrd7OmcXR5sA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 069/568] ARM: dts: imx6qdl-kontron-samx6i: fix SPI0 chip selects
Date: Tue, 30 Jul 2024 17:42:56 +0200
Message-ID: <20240730151642.556551635@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



