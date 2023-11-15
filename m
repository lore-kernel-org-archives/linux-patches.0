Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EED3D96E
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="opbnBpIl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BBD1C433C9;
	Wed, 15 Nov 2023 19:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078231;
	bh=BEKH1LSG8SGmxmNVprU2cBy2jgR7vUfaJ8FDOJK8RZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=opbnBpIlarZMYLgHCU+jA/r2AhqI5DFSTEqa2YdfW8ew05qUbQgFa+VaXPxrHoZGJ
	 nkyVmR8ALv8UGSgT+H+NKY/Vglho3Gd1kk9EsIaSVIUbLlkKZHv63CAKASeRI2Nb8P
	 9SOaO3rK+Ys/2kfI2otq5r4NbLYitdT8rL3hUFoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Packham <chris.packham@alliedtelesis.co.nz>,
	Andrew Lunn <andrew@lunn.ch>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 168/379] ARM64: dts: marvell: cn9310: Use appropriate label for spi1 pins
Date: Wed, 15 Nov 2023 14:24:03 -0500
Message-ID: <20231115192655.056296527@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Packham <chris.packham@alliedtelesis.co.nz>

[ Upstream commit 0878fd86f554ab98aa493996c7e0c72dff58437f ]

Both the CN9130-CRB and CN9130-DB use the SPI1 interface but had the
pinctrl node labelled as "cp0_spi0_pins". Use the label "cp0_spi1_pins"
and update the node name to "cp0-spi-pins-1" to avoid confusion with the
pinctrl options for SPI0.

Fixes: 4c43a41e5b8c ("arm64: dts: cn913x: add device trees for topology B boards")
Fixes: 5c0ee54723f3 ("arm64: dts: add support for Marvell cn9130-crb platform")
Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/marvell/cn9130-crb.dtsi | 4 ++--
 arch/arm64/boot/dts/marvell/cn9130-db.dtsi  | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/marvell/cn9130-crb.dtsi b/arch/arm64/boot/dts/marvell/cn9130-crb.dtsi
index 8e4ec243fb8fc..e5fc6cca50e74 100644
--- a/arch/arm64/boot/dts/marvell/cn9130-crb.dtsi
+++ b/arch/arm64/boot/dts/marvell/cn9130-crb.dtsi
@@ -120,7 +120,7 @@ cp0_sdhci_pins: cp0-sdhi-pins-0 {
 				       "mpp59", "mpp60", "mpp61";
 			marvell,function = "sdio";
 		};
-		cp0_spi0_pins: cp0-spi-pins-0 {
+		cp0_spi1_pins: cp0-spi-pins-1 {
 			marvell,pins = "mpp13", "mpp14", "mpp15", "mpp16";
 			marvell,function = "spi1";
 		};
@@ -170,7 +170,7 @@ &cp0_sdhci0 {
 
 &cp0_spi1 {
 	pinctrl-names = "default";
-	pinctrl-0 = <&cp0_spi0_pins>;
+	pinctrl-0 = <&cp0_spi1_pins>;
 	reg = <0x700680 0x50>,		/* control */
 	      <0x2000000 0x1000000>;	/* CS0 */
 	status = "okay";
diff --git a/arch/arm64/boot/dts/marvell/cn9130-db.dtsi b/arch/arm64/boot/dts/marvell/cn9130-db.dtsi
index c7de1ea0d470a..6eb6a175de38d 100644
--- a/arch/arm64/boot/dts/marvell/cn9130-db.dtsi
+++ b/arch/arm64/boot/dts/marvell/cn9130-db.dtsi
@@ -307,7 +307,7 @@ &cp0_sdhci0 {
 &cp0_spi1 {
 	status = "disabled";
 	pinctrl-names = "default";
-	pinctrl-0 = <&cp0_spi0_pins>;
+	pinctrl-0 = <&cp0_spi1_pins>;
 	reg = <0x700680 0x50>;
 
 	flash@0 {
@@ -371,7 +371,7 @@ cp0_sdhci_pins: cp0-sdhi-pins-0 {
 				       "mpp59", "mpp60", "mpp61";
 			marvell,function = "sdio";
 		};
-		cp0_spi0_pins: cp0-spi-pins-0 {
+		cp0_spi1_pins: cp0-spi-pins-1 {
 			marvell,pins = "mpp13", "mpp14", "mpp15", "mpp16";
 			marvell,function = "spi1";
 		};
-- 
2.42.0



