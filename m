Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC05C221DB6;
	Mon,  2 Jun 2025 13:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872221; cv=none; b=WpjoKqHMgO6IIM+pecjx4CbG5YPqTtCU1vrB0uQFEy5Rge6Q5czQM8giAUf8MSqDYYYRqY4o4g53rM0Cke3PYLyw3Pu/y+QpZW7hOx2vIg9bZFJB/zC/1p1vD9CkYbb3dk74MBdewDyUGaF3rM7yZK4wPB64PXZhXfw5cZQzb2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872221; c=relaxed/simple;
	bh=EIVofoz7x0vOAwfFGo9BH4wU6logjK88mYfdN8Q6j98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UikHlzpXZ4neRyKhqHuGbxIRf1NeBrsw9VlXDFPdfnucrgYNYarNzb+V8rjG+FbBn8ZaciiGFD8g0dSHsG7R1S0wAPMCROSmMSdeksgSBzIcYYRaBTCS2teyryHzXoJay1PWCoRJh87C/lUvqlGHbblMycKOaaQuoBmAgcuG4KU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GZ8JCh/Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GZ8JCh/Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B7D1C4CEEB;
	Mon,  2 Jun 2025 13:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872221;
	bh=EIVofoz7x0vOAwfFGo9BH4wU6logjK88mYfdN8Q6j98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GZ8JCh/Qe69+sqGDpiX16wCdCrlhSJzT2cg+uloRdZCPgozRoif06nVabZKH+xppl
	 tqKCCSYwrnqEpIiy3uAG+nH3aUxtFlu8+8kkOkR3Dl/OUoe8n6WMrdaxutotjcnMN8
	 AyEBvcjQqy3ySTfSZCHz6zlUpV+pdGscJ+qEuJ7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yemike Abhilash Chandra <y-abhilashchandra@ti.com>,
	Nishanth Menon <nm@ti.com>
Subject: [PATCH 6.15 37/49] arm64: dts: ti: k3-j721e-sk: Add requiried voltage supplies for IMX219
Date: Mon,  2 Jun 2025 15:47:29 +0200
Message-ID: <20250602134239.395867866@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134237.940995114@linuxfoundation.org>
References: <20250602134237.940995114@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yemike Abhilash Chandra <y-abhilashchandra@ti.com>

commit c6a20a250200da6fcaf80fe945b7b92cba8cfe0f upstream.

The device tree overlay for the IMX219 sensor requires three voltage
supplies to be defined: VANA (analog), VDIG (digital core), and VDDL
(digital I/O). Add the corresponding voltage supply definitions to
avoid dtbs_check warnings.

Fixes: f767eb918096 ("arm64: dts: ti: k3-j721e-sk: Add overlay for IMX219")
Cc: stable@vger.kernel.org
Signed-off-by: Yemike Abhilash Chandra <y-abhilashchandra@ti.com>
Link: https://lore.kernel.org/r/20250415111328.3847502-5-y-abhilashchandra@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-j721e-sk-csi2-dual-imx219.dtso |   33 +++++++++++++++
 1 file changed, 33 insertions(+)

--- a/arch/arm64/boot/dts/ti/k3-j721e-sk-csi2-dual-imx219.dtso
+++ b/arch/arm64/boot/dts/ti/k3-j721e-sk-csi2-dual-imx219.dtso
@@ -19,6 +19,33 @@
 		#clock-cells = <0>;
 		clock-frequency = <24000000>;
 	};
+
+	reg_2p8v: regulator-2p8v {
+		compatible = "regulator-fixed";
+		regulator-name = "2P8V";
+		regulator-min-microvolt = <2800000>;
+		regulator-max-microvolt = <2800000>;
+		vin-supply = <&vdd_sd_dv>;
+		regulator-always-on;
+	};
+
+	reg_1p8v: regulator-1p8v {
+		compatible = "regulator-fixed";
+		regulator-name = "1P8V";
+		regulator-min-microvolt = <1800000>;
+		regulator-max-microvolt = <1800000>;
+		vin-supply = <&vdd_sd_dv>;
+		regulator-always-on;
+	};
+
+	reg_1p2v: regulator-1p2v {
+		compatible = "regulator-fixed";
+		regulator-name = "1P2V";
+		regulator-min-microvolt = <1200000>;
+		regulator-max-microvolt = <1200000>;
+		vin-supply = <&vdd_sd_dv>;
+		regulator-always-on;
+	};
 };
 
 &csi_mux {
@@ -34,6 +61,9 @@
 		reg = <0x10>;
 
 		clocks = <&clk_imx219_fixed>;
+		VANA-supply = <&reg_2p8v>;
+		VDIG-supply = <&reg_1p8v>;
+		VDDL-supply = <&reg_1p2v>;
 
 		port {
 			csi2_cam0: endpoint {
@@ -55,6 +85,9 @@
 		reg = <0x10>;
 
 		clocks = <&clk_imx219_fixed>;
+		VANA-supply = <&reg_2p8v>;
+		VDIG-supply = <&reg_1p8v>;
+		VDDL-supply = <&reg_1p2v>;
 
 		port {
 			csi2_cam1: endpoint {


