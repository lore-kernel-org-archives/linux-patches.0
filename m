Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A89C1C69E;
	Sat,  3 Feb 2024 04:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933822; cv=none; b=C3kHdtYRL8Qw3+abbbYsajzSDd+OFZvJFNS/3VsU42ZgkVvTwWJOyXHYrOnwxCkErAyJMPjGPs5zFz4ZphEC1F6XuF0kuNkvJqSXHmepY/DcxAs/eT5PLY8hy9KUPdC1ktBLT0jXcfnsXGdvSIxBdt+5vmB4qbaULgRvMzOgv7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933822; c=relaxed/simple;
	bh=rQ+QBSr8qe/M7zsoMcorY5WELMdFcNb5G0V9rRqkDUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VOejTruu82O8IdLnw6h5Z/Vz1XHFT/bczmBhputRa5vljV9YcFyjLx7W4PQGzbiKmfpf7I76yWTej605FWikMtPyyHq1CaP0bo/t1MNBl1SlOKMV1CmENP9HOXkjRtDeqU58l+zypsdClK3CI7DcPBU+w5kcieSgwUvHBCuUEqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gohJKqhM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gohJKqhM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62CAFC433C7;
	Sat,  3 Feb 2024 04:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933822;
	bh=rQ+QBSr8qe/M7zsoMcorY5WELMdFcNb5G0V9rRqkDUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gohJKqhMU4VKZE79vIlVR4+zxLKKwSRkkXETwGlKAgEpZCJoxLbbXL//SRYjBSsqA
	 iVVZZImLjRy37Zl0xi3c0LfuquaH/C6nQi9OIZEIZnSKVAcIyHacighVxaieeQMxC4
	 K5q4on8Ugtw3MlnBGNn7+9Q7FEGV8qrFXN1ce60I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 118/353] arm64: zynqmp: Move fixed clock to / for kv260
Date: Fri,  2 Feb 2024 20:03:56 -0800
Message-ID: <20240203035407.478335773@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



