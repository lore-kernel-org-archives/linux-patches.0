Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CFA61756F;
	Sat,  3 Feb 2024 04:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933565; cv=none; b=IK2rZ5sjb7XUfWboK3+ziD6MTYSXj9kXb+sUGcMwkiWXCNFLuRAKguFB/8OMXYIGTlFX28sgkTrg0spXDsD/9UFFw4wwZAoqOOrFgcRf46DdkA1M49f4r3zo4H8nWqrm2nIN1IkfYkcEKE1XiDeOOP+JXiko5q+GlqlpeZIWsxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933565; c=relaxed/simple;
	bh=8GCY7dEmuSKx8CBfJ4MabXebYN1qtMinsf4tOfUeXNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fwhBwY8ILypzMfCkCZVc0RHAZV2UHXhUYBhnp3KA5phomnBMDJYnKDUI4hd9ETH2elQBXvd9PZMTljL3ooqSzkED3GgvMmQbcE920G+RPNHGmxudcbJ2CMTXMPE2Fzzap+LrUYYLweqtZA4ezdijlx3aGfpKcdFqzAfCXWvonwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EOUHzEG0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EOUHzEG0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8863C433C7;
	Sat,  3 Feb 2024 04:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933564;
	bh=8GCY7dEmuSKx8CBfJ4MabXebYN1qtMinsf4tOfUeXNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EOUHzEG0g4knA4R4VfURJTzUO3hZi39zHTjnU501IczQEAdpUalD7+K1jznkuf0Gg
	 hUvDPFEfa3NxcIoHqF2v/gCHck6tLJNmk2YtRkSoKV3Iy+i4/lnwWBTpOmpjM2S0zX
	 Am8wRh0arDnu4bq40tNvhLWPmuMwq/e40oC7b3w8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 119/322] arm64: zynqmp: Move fixed clock to / for kv260
Date: Fri,  2 Feb 2024 20:03:36 -0800
Message-ID: <20240203035402.987638435@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

From: Michal Simek <michal.simek@amd.com>

[ Upstream commit 6a10a19a6bd2fd8d27a510678bf87bd9408f51d8 ]

fixed clock nodes can't be on the bus because they are missing reg
property. That's why move them to root.
And because it is root it is good to have it as the first node in a file.

Signed-off-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/xilinx/zynqmp-sck-kv-g-revA.dtso | 28 ++++++++---------
 .../boot/dts/xilinx/zynqmp-sck-kv-g-revB.dtso | 30 +++++++++----------
 2 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/boot/dts/xilinx/zynqmp-sck-kv-g-revA.dtso b/arch/arm64/boot/dts/xilinx/zynqmp-sck-kv-g-revA.dtso
index ae1b9b2bdbee..dee238739290 100644
--- a/arch/arm64/boot/dts/xilinx/zynqmp-sck-kv-g-revA.dtso
+++ b/arch/arm64/boot/dts/xilinx/zynqmp-sck-kv-g-revA.dtso
@@ -21,20 +21,7 @@
 /dts-v1/;
 /plugin/;
 
-&i2c1 { /* I2C_SCK C23/C24 - MIO from SOM */
-	#address-cells = <1>;
-	#size-cells = <0>;
-	pinctrl-names = "default", "gpio";
-	pinctrl-0 = <&pinctrl_i2c1_default>;
-	pinctrl-1 = <&pinctrl_i2c1_gpio>;
-	scl-gpios = <&gpio 24 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
-	sda-gpios = <&gpio 25 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
-
-	/* u14 - 0x40 - ina260 */
-	/* u27 - 0xe0 - STDP4320 DP/HDMI splitter */
-};
-
-&amba {
+&{/} {
 	si5332_0: si5332_0 { /* u17 */
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
@@ -72,6 +59,19 @@
 	};
 };
 
+&i2c1 { /* I2C_SCK C23/C24 - MIO from SOM */
+	#address-cells = <1>;
+	#size-cells = <0>;
+	pinctrl-names = "default", "gpio";
+	pinctrl-0 = <&pinctrl_i2c1_default>;
+	pinctrl-1 = <&pinctrl_i2c1_gpio>;
+	scl-gpios = <&gpio 24 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
+	sda-gpios = <&gpio 25 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
+
+	/* u14 - 0x40 - ina260 */
+	/* u27 - 0xe0 - STDP4320 DP/HDMI splitter */
+};
+
 /* DP/USB 3.0 and SATA */
 &psgtr {
 	status = "okay";
diff --git a/arch/arm64/boot/dts/xilinx/zynqmp-sck-kv-g-revB.dtso b/arch/arm64/boot/dts/xilinx/zynqmp-sck-kv-g-revB.dtso
index b59e48be6465..73c5cb156caf 100644
--- a/arch/arm64/boot/dts/xilinx/zynqmp-sck-kv-g-revB.dtso
+++ b/arch/arm64/boot/dts/xilinx/zynqmp-sck-kv-g-revB.dtso
@@ -16,21 +16,7 @@
 /dts-v1/;
 /plugin/;
 
-&i2c1 { /* I2C_SCK C23/C24 - MIO from SOM */
-	#address-cells = <1>;
-	#size-cells = <0>;
-	pinctrl-names = "default", "gpio";
-	pinctrl-0 = <&pinctrl_i2c1_default>;
-	pinctrl-1 = <&pinctrl_i2c1_gpio>;
-	scl-gpios = <&gpio 24 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
-	sda-gpios = <&gpio 25 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
-
-	/* u14 - 0x40 - ina260 */
-	/* u43 - 0x2d - usb5744 */
-	/* u27 - 0xe0 - STDP4320 DP/HDMI splitter */
-};
-
-&amba {
+&{/} {
 	si5332_0: si5332_0 { /* u17 */
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
@@ -68,6 +54,20 @@
 	};
 };
 
+&i2c1 { /* I2C_SCK C23/C24 - MIO from SOM */
+	#address-cells = <1>;
+	#size-cells = <0>;
+	pinctrl-names = "default", "gpio";
+	pinctrl-0 = <&pinctrl_i2c1_default>;
+	pinctrl-1 = <&pinctrl_i2c1_gpio>;
+	scl-gpios = <&gpio 24 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
+	sda-gpios = <&gpio 25 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
+
+	/* u14 - 0x40 - ina260 */
+	/* u43 - 0x2d - usb5744 */
+	/* u27 - 0xe0 - STDP4320 DP/HDMI splitter */
+};
+
 /* DP/USB 3.0 */
 &psgtr {
 	status = "okay";
-- 
2.43.0



