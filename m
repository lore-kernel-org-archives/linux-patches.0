Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049092;
	b=zYcNMeaDv8qRH6cmpicsxur44sopPbWRcpH7NugxsVilDcVTkYY3tmrH5zc2HW4DWjrK
	 I2kMHmc9SaWREdBhg6O4fMWIBbLgEainFxmuyIvWrSZHcauVj7qybm52/BAnt8TW9fSBI
	 alF/bSVS6eywiZA4bRS05iXZdkrmCjeWqgdsX1SbzUUNHyyslZAeUzFHFv3JN2xJmrOqk
	 jQgj1Dl+os1HFjdWB5J73/AWkX+0Os1WayQlHJf05TQzRur6AGP4o+g/eTSUBQq2tXckO
	 YPm66t7Oq9pANMKGFraLghHth31iQ20xkbJYh0Lp85f7LRd7FXcOT6fsFSbJ2WKNE4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049092;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Radbz3KzqIYhZvwKmgQlrG6q9VQvZ9sjef9Wn4aYK1s=;
	b=o7VGn4e/mttyMAEnpuUYtTOEYTaJXzYZVyubq3dSKLsgn9yZBfh1wHLu6eFvJbHQhEby
	 XaGcGghAxo9k8gdPYm0ysl7pjSSv/DESrJG9fPD5sDS+nl0T2DVuFclkqAlDl212sN+kE
	 VPU/mhUYo7Onua4eZocVotAj5V3pH5CDqIuQCYwcIJveaZ1jMg8Mr3zSyF245Y8csnzaz
	 H+SFm+ifhxN4w5OIH5lQ9NATwHVoXZDKHtEU26knBTcPgBkzuHyYGpzruCZ32mCUU6at4
	 JjL4kXdmR7fBO4W4D/PfISveRHAs/BZi2q9iOuswyV91+xAvXC2zNHyx57tYYfJC55w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SJ1B1g75;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F04606A31C;
	Thu, 19 Nov 2026 00:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SJ1B1g75
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 701CD1F000C4;
	Thu, 19 Nov 2026 00:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049092;
	bh=Radbz3KzqIYhZvwKmgQlrG6q9VQvZ9sjef9Wn4aYK1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SJ1B1g75GLnNFaIcTwyJMxBTVoxI95Jg2QJxC/GVi1NYIgoxMN13oSsfTTOOHZgjh
	 ufUgUnNY2CS5hd92iQJuvprqNh722kX85hywmOq+wni289IhAD+jouiczKFCJm+SJo
	 eNOawT0QF4xkO3xNbqoQt7RXFiGa+bdff/odeK+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2226/2857] arm64: dts: rockchip: Prepare RK356x SoC dtsi files for per-variant OPPs
Date: Wed, 18 Nov 2026 15:54:20 +0100
Message-ID: <20261118150321.567103062@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dragan Simic <dsimic@manjaro.org>

[ Upstream commit 853f9632a17624e9264c68be5c9587f13d04be54 ]

Rename the Rockchip RK356x SoC dtsi files and, consequently, adjust their
contents appropriately, to prepare them for the ability to specify different
CPU and GPU OPPs for each of the supported RK356x SoC variants.

The first new RK356x SoC variant to be introduced is the RK3566T, which the
Pine64 Quartz64 Zero SBC is officially based on. [1]  Some other SBCs are
also based on the RK3566T variant, including Radxa ROCK 3C and ZERO 3E/3W,
but the slight trouble is that Radxa doesn't state that officially.  Though,
it's rather easy to spot the RK3566T on such boards, because their official
specifications state that the maximum frequency for the Cortex-A55 cores is
lower than the "full-fat" RK3566's 1.8 GHz. [2][3][4]

These changes follow the approach used for the Rockchip RK3588 SoC variants,
which was introduced and described further in commit def88eb4d836 ("arm64:
dts: rockchip: Prepare RK3588 SoC dtsi files for per-variant OPPs").  Please
see that commit for a more detailed explanation.

No functional changes are introduced, which was validated by decompiling and
comparing all affected board dtb files before and after these changes.  In
more detail, the affected dtb files have some of their blocks shuffled around
a bit and some of their phandles have different values, as a result of the
changes to the order in which the building blocks from the parent dtsi files
are included, but they effectively remain the same as the originals.

As a side note, due to the nature of introduced changes, this commit is a bit
more readable when viewed using the --break-rewrites option for git-log(1).

[1] https://wiki.pine64.org/wiki/Quartz64
[2] https://dl.radxa.com/rock3/docs/hw/3c/radxa_rock3c_product_brief.pdf
[3] https://dl.radxa.com/zero3/docs/hw/3e/radxa_zero_3e_product_brief.pdf
[4] https://dl.radxa.com/zero3/docs/hw/3w/radxa_zero_3w_product_brief.pdf

Related-to: def88eb4d836 ("arm64: dts: rockchip: Prepare RK3588 SoC dtsi files for per-variant OPPs")
Signed-off-by: Dragan Simic <dsimic@manjaro.org>
Link: https://lore.kernel.org/r/77e7450b8280bbdf4e2dc47366c9da85d4d8d1de.1730516702.git.dsimic@manjaro.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Stable-dep-of: 8043ed0f40fe ("arm64: dts: rockchip: Rename rk3566 and rk3568 HDMI audio cards")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3566-base.dtsi |  35 ++++++
 arch/arm64/boot/dts/rockchip/rk3566.dtsi      | 116 ++++++++++++++----
 arch/arm64/boot/dts/rockchip/rk3568.dtsi      | 114 +++++++++++++++--
 .../{rk356x.dtsi => rk356x-base.dtsi}         |  87 -------------
 4 files changed, 236 insertions(+), 116 deletions(-)
 create mode 100644 arch/arm64/boot/dts/rockchip/rk3566-base.dtsi
 rename arch/arm64/boot/dts/rockchip/{rk356x.dtsi => rk356x-base.dtsi} (96%)

diff --git a/arch/arm64/boot/dts/rockchip/rk3566-base.dtsi b/arch/arm64/boot/dts/rockchip/rk3566-base.dtsi
new file mode 100644
index 0000000000000..e56e0b6ba9411
--- /dev/null
+++ b/arch/arm64/boot/dts/rockchip/rk3566-base.dtsi
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: (GPL-2.0+ OR MIT)
+
+#include "rk356x-base.dtsi"
+
+/ {
+	compatible = "rockchip,rk3566";
+};
+
+&pipegrf {
+	compatible = "rockchip,rk3566-pipe-grf", "syscon";
+};
+
+&power {
+	power-domain@RK3568_PD_PIPE {
+		reg = <RK3568_PD_PIPE>;
+		clocks = <&cru PCLK_PIPE>;
+		pm_qos = <&qos_pcie2x1>,
+			 <&qos_sata1>,
+			 <&qos_sata2>,
+			 <&qos_usb3_0>,
+			 <&qos_usb3_1>;
+		#power-domain-cells = <0>;
+	};
+};
+
+&usb_host0_xhci {
+	phys = <&usb2phy0_otg>;
+	phy-names = "usb2-phy";
+	extcon = <&usb2phy0>;
+	maximum-speed = "high-speed";
+};
+
+&vop {
+	compatible = "rockchip,rk3566-vop";
+};
diff --git a/arch/arm64/boot/dts/rockchip/rk3566.dtsi b/arch/arm64/boot/dts/rockchip/rk3566.dtsi
index 6c4b17d27bdc5..3fcca79279f7c 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3566.dtsi
@@ -1,35 +1,107 @@
 // SPDX-License-Identifier: (GPL-2.0+ OR MIT)
 
-#include "rk356x.dtsi"
+#include "rk3566-base.dtsi"
 
 / {
-	compatible = "rockchip,rk3566";
+	cpu0_opp_table: opp-table-0 {
+		compatible = "operating-points-v2";
+		opp-shared;
+
+		opp-408000000 {
+			opp-hz = /bits/ 64 <408000000>;
+			opp-microvolt = <850000 850000 1150000>;
+			clock-latency-ns = <40000>;
+		};
+
+		opp-600000000 {
+			opp-hz = /bits/ 64 <600000000>;
+			opp-microvolt = <850000 850000 1150000>;
+			clock-latency-ns = <40000>;
+		};
+
+		opp-816000000 {
+			opp-hz = /bits/ 64 <816000000>;
+			opp-microvolt = <850000 850000 1150000>;
+			clock-latency-ns = <40000>;
+			opp-suspend;
+		};
+
+		opp-1104000000 {
+			opp-hz = /bits/ 64 <1104000000>;
+			opp-microvolt = <900000 900000 1150000>;
+			clock-latency-ns = <40000>;
+		};
+
+		opp-1416000000 {
+			opp-hz = /bits/ 64 <1416000000>;
+			opp-microvolt = <1025000 1025000 1150000>;
+			clock-latency-ns = <40000>;
+		};
+
+		opp-1608000000 {
+			opp-hz = /bits/ 64 <1608000000>;
+			opp-microvolt = <1100000 1100000 1150000>;
+			clock-latency-ns = <40000>;
+		};
+
+		opp-1800000000 {
+			opp-hz = /bits/ 64 <1800000000>;
+			opp-microvolt = <1150000 1150000 1150000>;
+			clock-latency-ns = <40000>;
+		};
+	};
+
+	gpu_opp_table: opp-table-1 {
+		compatible = "operating-points-v2";
+
+		opp-200000000 {
+			opp-hz = /bits/ 64 <200000000>;
+			opp-microvolt = <850000 850000 1000000>;
+		};
+
+		opp-300000000 {
+			opp-hz = /bits/ 64 <300000000>;
+			opp-microvolt = <850000 850000 1000000>;
+		};
+
+		opp-400000000 {
+			opp-hz = /bits/ 64 <400000000>;
+			opp-microvolt = <850000 850000 1000000>;
+		};
+
+		opp-600000000 {
+			opp-hz = /bits/ 64 <600000000>;
+			opp-microvolt = <900000 900000 1000000>;
+		};
+
+		opp-700000000 {
+			opp-hz = /bits/ 64 <700000000>;
+			opp-microvolt = <950000 950000 1000000>;
+		};
+
+		opp-800000000 {
+			opp-hz = /bits/ 64 <800000000>;
+			opp-microvolt = <1000000 1000000 1000000>;
+		};
+	};
 };
 
-&pipegrf {
-	compatible = "rockchip,rk3566-pipe-grf", "syscon";
+&cpu0 {
+	operating-points-v2 = <&cpu0_opp_table>;
 };
 
-&power {
-	power-domain@RK3568_PD_PIPE {
-		reg = <RK3568_PD_PIPE>;
-		clocks = <&cru PCLK_PIPE>;
-		pm_qos = <&qos_pcie2x1>,
-			 <&qos_sata1>,
-			 <&qos_sata2>,
-			 <&qos_usb3_0>,
-			 <&qos_usb3_1>;
-		#power-domain-cells = <0>;
-	};
+&cpu1 {
+	operating-points-v2 = <&cpu0_opp_table>;
+};
+
+&cpu2 {
+	operating-points-v2 = <&cpu0_opp_table>;
 };
 
-&usb_host0_xhci {
-	phys = <&usb2phy0_otg>;
-	phy-names = "usb2-phy";
-	extcon = <&usb2phy0>;
-	maximum-speed = "high-speed";
+&cpu3 {
+	operating-points-v2 = <&cpu0_opp_table>;
 };
 
-&vop {
-	compatible = "rockchip,rk3566-vop";
+&gpu {
+	operating-points-v2 = <&gpu_opp_table>;
 };
diff --git a/arch/arm64/boot/dts/rockchip/rk3568.dtsi b/arch/arm64/boot/dts/rockchip/rk3568.dtsi
index 5f0660d4397db..5919d041f4d05 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3568.dtsi
@@ -3,11 +3,99 @@
  * Copyright (c) 2021 Rockchip Electronics Co., Ltd.
  */
 
-#include "rk356x.dtsi"
+#include "rk356x-base.dtsi"
 
 / {
 	compatible = "rockchip,rk3568";
 
+	cpu0_opp_table: opp-table-0 {
+		compatible = "operating-points-v2";
+		opp-shared;
+
+		opp-408000000 {
+			opp-hz = /bits/ 64 <408000000>;
+			opp-microvolt = <850000 850000 1150000>;
+			clock-latency-ns = <40000>;
+		};
+
+		opp-600000000 {
+			opp-hz = /bits/ 64 <600000000>;
+			opp-microvolt = <850000 850000 1150000>;
+			clock-latency-ns = <40000>;
+		};
+
+		opp-816000000 {
+			opp-hz = /bits/ 64 <816000000>;
+			opp-microvolt = <850000 850000 1150000>;
+			clock-latency-ns = <40000>;
+			opp-suspend;
+		};
+
+		opp-1104000000 {
+			opp-hz = /bits/ 64 <1104000000>;
+			opp-microvolt = <900000 900000 1150000>;
+			clock-latency-ns = <40000>;
+		};
+
+		opp-1416000000 {
+			opp-hz = /bits/ 64 <1416000000>;
+			opp-microvolt = <1025000 1025000 1150000>;
+			clock-latency-ns = <40000>;
+		};
+
+		opp-1608000000 {
+			opp-hz = /bits/ 64 <1608000000>;
+			opp-microvolt = <1100000 1100000 1150000>;
+			clock-latency-ns = <40000>;
+		};
+
+		opp-1800000000 {
+			opp-hz = /bits/ 64 <1800000000>;
+			opp-microvolt = <1150000 1150000 1150000>;
+			clock-latency-ns = <40000>;
+		};
+
+		opp-1992000000 {
+			opp-hz = /bits/ 64 <1992000000>;
+			opp-microvolt = <1150000 1150000 1150000>;
+			clock-latency-ns = <40000>;
+		};
+	};
+
+	gpu_opp_table: opp-table-1 {
+		compatible = "operating-points-v2";
+
+		opp-200000000 {
+			opp-hz = /bits/ 64 <200000000>;
+			opp-microvolt = <850000 850000 1000000>;
+		};
+
+		opp-300000000 {
+			opp-hz = /bits/ 64 <300000000>;
+			opp-microvolt = <850000 850000 1000000>;
+		};
+
+		opp-400000000 {
+			opp-hz = /bits/ 64 <400000000>;
+			opp-microvolt = <850000 850000 1000000>;
+		};
+
+		opp-600000000 {
+			opp-hz = /bits/ 64 <600000000>;
+			opp-microvolt = <900000 900000 1000000>;
+		};
+
+		opp-700000000 {
+			opp-hz = /bits/ 64 <700000000>;
+			opp-microvolt = <950000 950000 1000000>;
+		};
+
+		opp-800000000 {
+			opp-hz = /bits/ 64 <800000000>;
+			opp-microvolt = <1000000 1000000 1000000>;
+		};
+	};
+
 	sata0: sata@fc000000 {
 		compatible = "rockchip,rk3568-dwc-ahci", "snps,dwc-ahci";
 		reg = <0 0xfc000000 0 0x1000>;
@@ -230,12 +318,24 @@ combphy0: phy@fe820000 {
 	};
 };
 
-&cpu0_opp_table {
-	opp-1992000000 {
-		opp-hz = /bits/ 64 <1992000000>;
-		opp-microvolt = <1150000 1150000 1150000>;
-		clock-latency-ns = <40000>;
-	};
+&cpu0 {
+	operating-points-v2 = <&cpu0_opp_table>;
+};
+
+&cpu1 {
+	operating-points-v2 = <&cpu0_opp_table>;
+};
+
+&cpu2 {
+	operating-points-v2 = <&cpu0_opp_table>;
+};
+
+&cpu3 {
+	operating-points-v2 = <&cpu0_opp_table>;
+};
+
+&gpu {
+	operating-points-v2 = <&gpu_opp_table>;
 };
 
 &pipegrf {
diff --git a/arch/arm64/boot/dts/rockchip/rk356x.dtsi b/arch/arm64/boot/dts/rockchip/rk356x-base.dtsi
similarity index 96%
rename from arch/arm64/boot/dts/rockchip/rk356x.dtsi
rename to arch/arm64/boot/dts/rockchip/rk356x-base.dtsi
index afcd53550d35e..ee5507459d37b 100644
--- a/arch/arm64/boot/dts/rockchip/rk356x.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk356x-base.dtsi
@@ -56,7 +56,6 @@ cpu0: cpu@0 {
 			clocks = <&scmi_clk 0>;
 			#cooling-cells = <2>;
 			enable-method = "psci";
-			operating-points-v2 = <&cpu0_opp_table>;
 			i-cache-size = <0x8000>;
 			i-cache-line-size = <64>;
 			i-cache-sets = <128>;
@@ -72,7 +71,6 @@ cpu1: cpu@100 {
 			reg = <0x0 0x100>;
 			#cooling-cells = <2>;
 			enable-method = "psci";
-			operating-points-v2 = <&cpu0_opp_table>;
 			i-cache-size = <0x8000>;
 			i-cache-line-size = <64>;
 			i-cache-sets = <128>;
@@ -88,7 +86,6 @@ cpu2: cpu@200 {
 			reg = <0x0 0x200>;
 			#cooling-cells = <2>;
 			enable-method = "psci";
-			operating-points-v2 = <&cpu0_opp_table>;
 			i-cache-size = <0x8000>;
 			i-cache-line-size = <64>;
 			i-cache-sets = <128>;
@@ -104,7 +101,6 @@ cpu3: cpu@300 {
 			reg = <0x0 0x300>;
 			#cooling-cells = <2>;
 			enable-method = "psci";
-			operating-points-v2 = <&cpu0_opp_table>;
 			i-cache-size = <0x8000>;
 			i-cache-line-size = <64>;
 			i-cache-sets = <128>;
@@ -128,54 +124,6 @@ l3_cache: l3-cache {
 		cache-sets = <512>;
 	};
 
-	cpu0_opp_table: opp-table-0 {
-		compatible = "operating-points-v2";
-		opp-shared;
-
-		opp-408000000 {
-			opp-hz = /bits/ 64 <408000000>;
-			opp-microvolt = <850000 850000 1150000>;
-			clock-latency-ns = <40000>;
-		};
-
-		opp-600000000 {
-			opp-hz = /bits/ 64 <600000000>;
-			opp-microvolt = <850000 850000 1150000>;
-			clock-latency-ns = <40000>;
-		};
-
-		opp-816000000 {
-			opp-hz = /bits/ 64 <816000000>;
-			opp-microvolt = <850000 850000 1150000>;
-			clock-latency-ns = <40000>;
-			opp-suspend;
-		};
-
-		opp-1104000000 {
-			opp-hz = /bits/ 64 <1104000000>;
-			opp-microvolt = <900000 900000 1150000>;
-			clock-latency-ns = <40000>;
-		};
-
-		opp-1416000000 {
-			opp-hz = /bits/ 64 <1416000000>;
-			opp-microvolt = <1025000 1025000 1150000>;
-			clock-latency-ns = <40000>;
-		};
-
-		opp-1608000000 {
-			opp-hz = /bits/ 64 <1608000000>;
-			opp-microvolt = <1100000 1100000 1150000>;
-			clock-latency-ns = <40000>;
-		};
-
-		opp-1800000000 {
-			opp-hz = /bits/ 64 <1800000000>;
-			opp-microvolt = <1150000 1150000 1150000>;
-			clock-latency-ns = <40000>;
-		};
-	};
-
 	display_subsystem: display-subsystem {
 		compatible = "rockchip,display-subsystem";
 		ports = <&vop_out>;
@@ -196,40 +144,6 @@ scmi_clk: protocol@14 {
 		};
 	};
 
-	gpu_opp_table: opp-table-1 {
-		compatible = "operating-points-v2";
-
-		opp-200000000 {
-			opp-hz = /bits/ 64 <200000000>;
-			opp-microvolt = <850000 850000 1000000>;
-		};
-
-		opp-300000000 {
-			opp-hz = /bits/ 64 <300000000>;
-			opp-microvolt = <850000 850000 1000000>;
-		};
-
-		opp-400000000 {
-			opp-hz = /bits/ 64 <400000000>;
-			opp-microvolt = <850000 850000 1000000>;
-		};
-
-		opp-600000000 {
-			opp-hz = /bits/ 64 <600000000>;
-			opp-microvolt = <900000 900000 1000000>;
-		};
-
-		opp-700000000 {
-			opp-hz = /bits/ 64 <700000000>;
-			opp-microvolt = <950000 950000 1000000>;
-		};
-
-		opp-800000000 {
-			opp-hz = /bits/ 64 <800000000>;
-			opp-microvolt = <1000000 1000000 1000000>;
-		};
-	};
-
 	hdmi_sound: hdmi-sound {
 		compatible = "simple-audio-card";
 		simple-audio-card,name = "HDMI";
@@ -634,7 +548,6 @@ gpu: gpu@fde60000 {
 		clocks = <&scmi_clk 1>, <&cru CLK_GPU>;
 		clock-names = "gpu", "bus";
 		#cooling-cells = <2>;
-		operating-points-v2 = <&gpu_opp_table>;
 		power-domains = <&power RK3568_PD_GPU>;
 		status = "disabled";
 	};
-- 
2.53.0



