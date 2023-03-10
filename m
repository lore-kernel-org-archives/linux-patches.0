Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54928481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:14:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49114C433D2;
	Fri, 10 Mar 2023 14:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457653;
	bh=ewqXe+se3Dtm7L/y7Q6qBL5WoYOKs4IoxjNI7ntSo1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qPYjxq0t/447etbUEJz7isRxctf3rKmFOdtvGxOuFyhSihtzD0TdDCWLXZJhvDlPV
	 TjAz5XA8tNqGNWR0g3BK+DfEmanQ1GVeW9fMfZy4Qr0zF42ibe8lbExO16k1izqV2b
	 4gybaJn3dKGvF/hLZRmKkdi9d1aBN7uGmtA9YKc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Neil Armstrong <narmstrong@baylibre.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 012/252] arm64: dts: meson-axg: enable SCPI
Date: Fri, 10 Mar 2023 14:36:22 +0100
Message-Id: <20230310133719.202007590@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 2c130695ad5265ce2eb38f55ee0cce26238f7891 ]

Enable SCPI on the axg platform, with cpu clock and hwmon
(core temperature) support

Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Stable-dep-of: 5b7069d72f03 ("arm64: dts: amlogic: meson-axg: fix SCPI clock dvfs node name")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi | 26 ++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
index 90e9cbcc891f2..8355818153775 100644
--- a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
@@ -47,6 +47,7 @@ cpu0: cpu@0 {
 			reg = <0x0 0x0>;
 			enable-method = "psci";
 			next-level-cache = <&l2>;
+			clocks = <&scpi_dvfs 0>;
 		};
 
 		cpu1: cpu@1 {
@@ -55,6 +56,7 @@ cpu1: cpu@1 {
 			reg = <0x0 0x1>;
 			enable-method = "psci";
 			next-level-cache = <&l2>;
+			clocks = <&scpi_dvfs 0>;
 		};
 
 		cpu2: cpu@2 {
@@ -63,6 +65,7 @@ cpu2: cpu@2 {
 			reg = <0x0 0x2>;
 			enable-method = "psci";
 			next-level-cache = <&l2>;
+			clocks = <&scpi_dvfs 0>;
 		};
 
 		cpu3: cpu@3 {
@@ -71,6 +74,7 @@ cpu3: cpu@3 {
 			reg = <0x0 0x3>;
 			enable-method = "psci";
 			next-level-cache = <&l2>;
+			clocks = <&scpi_dvfs 0>;
 		};
 
 		l2: l2-cache0 {
@@ -151,6 +155,28 @@ ao_alt_xtal: ao_alt_xtal-clk {
 		#clock-cells = <0>;
 	};
 
+	scpi {
+		compatible = "arm,scpi-pre-1.0";
+		mboxes = <&mailbox 1 &mailbox 2>;
+		shmem = <&cpu_scp_lpri &cpu_scp_hpri>;
+
+		scpi_clocks: clocks {
+			compatible = "arm,scpi-clocks";
+
+			scpi_dvfs: clock-controller {
+				compatible = "arm,scpi-dvfs-clocks";
+				#clock-cells = <1>;
+				clock-indices = <0>;
+				clock-output-names = "vcpu";
+			};
+		};
+
+		scpi_sensors: sensors {
+			compatible = "amlogic,meson-gxbb-scpi-sensors";
+			#thermal-sensor-cells = <1>;
+		};
+	};
+
 	soc {
 		compatible = "simple-bus";
 		#address-cells = <2>;
-- 
2.39.2



