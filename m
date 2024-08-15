Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687F1198E78;
	Thu, 15 Aug 2024 13:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729323; cv=none; b=GQdSeFDbSRr+s1i8cvlbkmOy4oHYTD2ufs1CNwvUP5TVC64GO1ApKYHIR+YfZKs/Y3FTzGDU5gMB3hZV8TeePkaLwR+kX1aKjYWLObtZdsYogEUC1kVwVq0S4CufOk5nYDEdIs8aQJ5AJ0H/bocvT1weuFBYqIRczVuJPyTEB7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729323; c=relaxed/simple;
	bh=hUbJf+DLmgsvFmAZ8B3smHqpU0e7pzMFakW+7ZAL6vM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XPnfewLEWhAyOdMuY327Wi73vwQFkyk63uTdrhwt2aOAS7mwd0WFF9BAsFwvqv3Q4poCoGTkSLta0Wa83UjL6EQyQpI6MOODIbULjzANG3OlWC3ayLrEDctiuBLBZ+MYvb+qly6fiUfp6nkPuIeY7YFDi16WR0S7j1Vk2GzWrK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b6yBWNtt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b6yBWNtt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89FFEC32786;
	Thu, 15 Aug 2024 13:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729322;
	bh=hUbJf+DLmgsvFmAZ8B3smHqpU0e7pzMFakW+7ZAL6vM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b6yBWNttKVY9/UUYCGLRjOwnaD6FmW2WD8ZS4+V1fy7Jm0dDBO1VOjfNy0qCnb6oZ
	 MSoqfReGdSaOIl4vRs4itiBQvaAsBT0V2VnUmK3P2WqdB2cb8dYkcDO8vnuuPDWezx
	 GXXy3WQ6+zDe7CuS8svqalNsvjxpQ8yqhw5rh7lY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 030/484] ARM: dts: imx6qdl-kontron-samx6i: fix SPI0 chip selects
Date: Thu, 15 Aug 2024 15:18:08 +0200
Message-ID: <20240815131942.440262154@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/boot/dts/imx6q-kontron-samx6i.dtsi   | 23 -------------------
 arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi |  5 +++-
 2 files changed, 4 insertions(+), 24 deletions(-)

diff --git a/arch/arm/boot/dts/imx6q-kontron-samx6i.dtsi b/arch/arm/boot/dts/imx6q-kontron-samx6i.dtsi
index 4d6a0c3e8455f..ff062f4fd726e 100644
--- a/arch/arm/boot/dts/imx6q-kontron-samx6i.dtsi
+++ b/arch/arm/boot/dts/imx6q-kontron-samx6i.dtsi
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
diff --git a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
index c420a3b80943e..d9f4321055165 100644
--- a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
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



