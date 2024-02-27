Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD4A13DBBF;
	Tue, 27 Feb 2024 13:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041785; cv=none; b=ryMW2azbgTeFMMlS6KIBrTjypFs4ivlcK2JnbdWW1Mz0hX+LdacXTW++jkzoohA4giO2jdb+vmqFIXS0iCQPTlnR4dllaBPaf9PUzgc208nrjcB3/Xx3Hh9XXpCkMmtC5CWxQSkbjXUpkMHhcQcF30h0OTIHcAjBlgH+qRMODpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041785; c=relaxed/simple;
	bh=bbPMwciR+FUDAIVIEAsR5R+aGzfWfHsDAkHC0rSOSvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hqg8a6AHYYCq7A0tcFRF6sjhIlRYtu7/62QUa8E0rd7p7X9gmvuEYtbHIqUFhDLD3KRjAQLR0OOCf3Dhntu3n9jBUfwzBJArmtz9uGl80Y+ou5uW9hMj+vxcXZBqNAw1D3UErOqZJGSPHXyqjkD38SLjmAOPwYzBAaMQSlAZ7Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=trqqgg5T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="trqqgg5T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA49C433F1;
	Tue, 27 Feb 2024 13:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041785;
	bh=bbPMwciR+FUDAIVIEAsR5R+aGzfWfHsDAkHC0rSOSvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=trqqgg5TTYuM59gpR7DcLyxVERbBZIxc6y1qUG3kiMJ1qFCfb2ACBjBahqXNTENAm
	 0v11cKRlw1CLcjPnEHQXGToYj35aR4c4Vojn5mShfTQap3E90oMjXAbYvvGhzd1UrY
	 R96A7aZ6yIQPdSy6cJiQE+/r+h4K4DrR4sMJK1hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Patrick Williams <patrick@stwcx.xyz>,
	Tao Ren <rentao.bupt@gmail.com>,
	Bruno Thomsen <bruno.thomsen@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/299] ARM: dts: Fix TPM schema violations
Date: Tue, 27 Feb 2024 14:22:21 +0100
Message-ID: <20240227131626.797638969@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit 8412c47d68436b9f9a260039a4a773daa6824925 ]

Since commit 26c9d152ebf3 ("dt-bindings: tpm: Consolidate TCG TIS
bindings"), several issues are reported by "make dtbs_check" for ARM
devicetrees:

The nodename needs to be "tpm@0" rather than "tpmdev@0" and the
compatible property needs to contain the chip's name in addition to the
generic "tcg,tpm_tis-spi" or "tcg,tpm-tis-i2c":

  tpmdev@0: $nodename:0: 'tpmdev@0' does not match '^tpm(@[0-9a-f]+)?$'
        from schema $id: http://devicetree.org/schemas/tpm/tcg,tpm_tis-spi.yaml#

  tpm@2e: compatible: 'oneOf' conditional failed, one must be fixed:
        ['tcg,tpm-tis-i2c'] is too short
        from schema $id: http://devicetree.org/schemas/tpm/tcg,tpm-tis-i2c.yaml#

Fix these schema violations.

Aspeed Facebook BMCs use an Infineon SLB9670:
https://lore.kernel.org/all/ZZSmMJ%2F%2Fl972Qbxu@fedora/
https://lore.kernel.org/all/ZZT4%2Fw2eVzMhtsPx@fedora/
https://lore.kernel.org/all/ZZTS0p1hdAchIbKp@heinlein.vulture-banana.ts.net/

Aspeed Tacoma uses a Nuvoton NPCT75X per commit 39d8a73c53a2 ("ARM: dts:
aspeed: tacoma: Add TPM").

phyGATE-Tauri uses an Infineon SLB9670:
https://lore.kernel.org/all/ab45c82485fa272f74adf560cbb58ee60cc42689.camel@phytec.de/

A single schema violation remains in am335x-moxa-uc-2100-common.dtsi
because it is unknown which chip is used on the board.  The devicetree's
author has been asked for clarification but has not responded so far:
https://lore.kernel.org/all/20231220090910.GA32182@wunner.de/

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Patrick Williams <patrick@stwcx.xyz>
Reviewed-by: Tao Ren <rentao.bupt@gmail.com>
Reviewed-by: Bruno Thomsen <bruno.thomsen@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/aspeed/aspeed-bmc-facebook-bletchley.dts   | 4 ++--
 arch/arm/boot/dts/aspeed/aspeed-bmc-facebook-wedge400.dts    | 4 ++--
 arch/arm/boot/dts/aspeed/aspeed-bmc-opp-tacoma.dts           | 2 +-
 arch/arm/boot/dts/aspeed/ast2600-facebook-netbmc-common.dtsi | 4 ++--
 arch/arm/boot/dts/nxp/imx/imx6ull-phytec-tauri.dtsi          | 2 +-
 arch/arm/boot/dts/nxp/imx/imx7d-flex-concentrator.dts        | 2 +-
 arch/arm/boot/dts/ti/omap/am335x-moxa-uc-2100-common.dtsi    | 2 +-
 7 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm/boot/dts/aspeed/aspeed-bmc-facebook-bletchley.dts b/arch/arm/boot/dts/aspeed/aspeed-bmc-facebook-bletchley.dts
index e899de681f475..5be0e8fd2633c 100644
--- a/arch/arm/boot/dts/aspeed/aspeed-bmc-facebook-bletchley.dts
+++ b/arch/arm/boot/dts/aspeed/aspeed-bmc-facebook-bletchley.dts
@@ -45,8 +45,8 @@
 		num-chipselects = <1>;
 		cs-gpios = <&gpio0 ASPEED_GPIO(Z, 0) GPIO_ACTIVE_LOW>;
 
-		tpmdev@0 {
-			compatible = "tcg,tpm_tis-spi";
+		tpm@0 {
+			compatible = "infineon,slb9670", "tcg,tpm_tis-spi";
 			spi-max-frequency = <33000000>;
 			reg = <0>;
 		};
diff --git a/arch/arm/boot/dts/aspeed/aspeed-bmc-facebook-wedge400.dts b/arch/arm/boot/dts/aspeed/aspeed-bmc-facebook-wedge400.dts
index a677c827e758f..5a8169bbda879 100644
--- a/arch/arm/boot/dts/aspeed/aspeed-bmc-facebook-wedge400.dts
+++ b/arch/arm/boot/dts/aspeed/aspeed-bmc-facebook-wedge400.dts
@@ -80,8 +80,8 @@
 		gpio-miso = <&gpio ASPEED_GPIO(R, 5) GPIO_ACTIVE_HIGH>;
 		num-chipselects = <1>;
 
-		tpmdev@0 {
-			compatible = "tcg,tpm_tis-spi";
+		tpm@0 {
+			compatible = "infineon,slb9670", "tcg,tpm_tis-spi";
 			spi-max-frequency = <33000000>;
 			reg = <0>;
 		};
diff --git a/arch/arm/boot/dts/aspeed/aspeed-bmc-opp-tacoma.dts b/arch/arm/boot/dts/aspeed/aspeed-bmc-opp-tacoma.dts
index 3f6010ef2b86f..213023bc5aec4 100644
--- a/arch/arm/boot/dts/aspeed/aspeed-bmc-opp-tacoma.dts
+++ b/arch/arm/boot/dts/aspeed/aspeed-bmc-opp-tacoma.dts
@@ -456,7 +456,7 @@
 	status = "okay";
 
 	tpm: tpm@2e {
-		compatible = "tcg,tpm-tis-i2c";
+		compatible = "nuvoton,npct75x", "tcg,tpm-tis-i2c";
 		reg = <0x2e>;
 	};
 };
diff --git a/arch/arm/boot/dts/aspeed/ast2600-facebook-netbmc-common.dtsi b/arch/arm/boot/dts/aspeed/ast2600-facebook-netbmc-common.dtsi
index 31590d3186a2e..00e5887c926f1 100644
--- a/arch/arm/boot/dts/aspeed/ast2600-facebook-netbmc-common.dtsi
+++ b/arch/arm/boot/dts/aspeed/ast2600-facebook-netbmc-common.dtsi
@@ -35,8 +35,8 @@
 		gpio-mosi = <&gpio0 ASPEED_GPIO(X, 4) GPIO_ACTIVE_HIGH>;
 		gpio-miso = <&gpio0 ASPEED_GPIO(X, 5) GPIO_ACTIVE_HIGH>;
 
-		tpmdev@0 {
-			compatible = "tcg,tpm_tis-spi";
+		tpm@0 {
+			compatible = "infineon,slb9670", "tcg,tpm_tis-spi";
 			spi-max-frequency = <33000000>;
 			reg = <0>;
 		};
diff --git a/arch/arm/boot/dts/nxp/imx/imx6ull-phytec-tauri.dtsi b/arch/arm/boot/dts/nxp/imx/imx6ull-phytec-tauri.dtsi
index ea627638e40cf..7dd1fe5a2fb76 100644
--- a/arch/arm/boot/dts/nxp/imx/imx6ull-phytec-tauri.dtsi
+++ b/arch/arm/boot/dts/nxp/imx/imx6ull-phytec-tauri.dtsi
@@ -121,7 +121,7 @@
 	tpm_tis: tpm@1 {
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_tpm>;
-		compatible = "tcg,tpm_tis-spi";
+		compatible = "infineon,slb9670", "tcg,tpm_tis-spi";
 		reg = <1>;
 		spi-max-frequency = <20000000>;
 		interrupt-parent = <&gpio5>;
diff --git a/arch/arm/boot/dts/nxp/imx/imx7d-flex-concentrator.dts b/arch/arm/boot/dts/nxp/imx/imx7d-flex-concentrator.dts
index 3a723843d5626..9984b343cdf0c 100644
--- a/arch/arm/boot/dts/nxp/imx/imx7d-flex-concentrator.dts
+++ b/arch/arm/boot/dts/nxp/imx/imx7d-flex-concentrator.dts
@@ -130,7 +130,7 @@
 	 * TCG specification - Section 6.4.1 Clocking:
 	 * TPM shall support a SPI clock frequency range of 10-24 MHz.
 	 */
-	st33htph: tpm-tis@0 {
+	st33htph: tpm@0 {
 		compatible = "st,st33htpm-spi", "tcg,tpm_tis-spi";
 		reg = <0>;
 		spi-max-frequency = <24000000>;
diff --git a/arch/arm/boot/dts/ti/omap/am335x-moxa-uc-2100-common.dtsi b/arch/arm/boot/dts/ti/omap/am335x-moxa-uc-2100-common.dtsi
index b8730aa52ce6f..a59331aa58e55 100644
--- a/arch/arm/boot/dts/ti/omap/am335x-moxa-uc-2100-common.dtsi
+++ b/arch/arm/boot/dts/ti/omap/am335x-moxa-uc-2100-common.dtsi
@@ -217,7 +217,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&spi1_pins>;
 
-	tpm_spi_tis@0 {
+	tpm@0 {
 		compatible = "tcg,tpm_tis-spi";
 		reg = <0>;
 		spi-max-frequency = <500000>;
-- 
2.43.0



