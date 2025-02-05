Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A53818C93C;
	Wed,  5 Feb 2025 14:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766887; cv=none; b=nCCuO3OlKkHmiGCTLbHeOt1P2qV3RGxlA4AAPrZl09kigGrMYTY6Cs8QQzUZTX0BBfk3KUfuVCc6z19xBMFzFxjqEnqH+yvon3RZGUw1s0+87m/hzBMA2e+JIksALBkLLd6pZroitNx9UiDO4uhduLMV5sny5M1emYN8m0n4lXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766887; c=relaxed/simple;
	bh=2T7DlmpEORCJOQjOC1YTTWRsJLI8eRxGlF+WQjQaO4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BWhwG85G6TPkKQAEXICRPj8qoPRTvCwl3KUcyA8O1dfMNwRUAIFjJ/2ZzcC2t+uxHBMFkuKY+Ttl/iVgC6+PA52M6pd8W3UaZL71YIM2i0Iso68A/Js2VFekf6JRAhp7aWhaErodAJjli5dS2hGXFCoIfigD73qcnRin6XrrAOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X7n69LG8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X7n69LG8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97B97C4CED1;
	Wed,  5 Feb 2025 14:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766886;
	bh=2T7DlmpEORCJOQjOC1YTTWRsJLI8eRxGlF+WQjQaO4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X7n69LG8XzYgL0XO+dba8tnT9q+SbTJnQe+RTAs0tRF0FK7XwLr0x92HvZOoRpAGf
	 SqV/JH0XAe1Qo80KZWvfGlHxxdiys2xcKbn+RsATZTcAdMp+PBTGoxDtY7kGnhObgw
	 DUyG/+M+lvnl7ebCKKEYwMwjn6XYhtfD+y1hYgKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 376/590] arm64: dts: qcom: sc7180: change labels to lower-case
Date: Wed,  5 Feb 2025 14:42:11 +0100
Message-ID: <20250205134509.655939886@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit e5f90735136562c0653714b43ff1aeb331600d24 ]

DTS coding style expects labels to be lowercase.  No functional impact.
Verified with comparing decompiled DTB (dtx_diff and fdtdump+diff).

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20241022-dts-qcom-label-v3-4-0505bc7d2c56@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 092febd32a99 ("arm64: dts: qcom: sc7180: fix psci power domain node names")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/qcom/sc7180-firmware-tfa.dtsi    |  84 ++--
 .../boot/dts/qcom/sc7180-trogdor-coachz.dtsi  |   8 +-
 .../dts/qcom/sc7180-trogdor-homestar.dtsi     |   8 +-
 .../dts/qcom/sc7180-trogdor-wormdingler.dtsi  |   8 +-
 arch/arm64/boot/dts/qcom/sc7180.dtsi          | 362 +++++++++---------
 arch/arm64/boot/dts/qcom/sm7125.dtsi          |  16 +-
 6 files changed, 243 insertions(+), 243 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180-firmware-tfa.dtsi b/arch/arm64/boot/dts/qcom/sc7180-firmware-tfa.dtsi
index ee35a454dbf6f..59162b3afcb84 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-firmware-tfa.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-firmware-tfa.dtsi
@@ -6,82 +6,82 @@
  * by Qualcomm firmware.
  */
 
-&CPU0 {
+&cpu0 {
 	/delete-property/ power-domains;
 	/delete-property/ power-domain-names;
 
-	cpu-idle-states = <&LITTLE_CPU_SLEEP_0
-			   &LITTLE_CPU_SLEEP_1
-			   &CLUSTER_SLEEP_0>;
+	cpu-idle-states = <&little_cpu_sleep_0
+			   &little_cpu_sleep_1
+			   &cluster_sleep_0>;
 };
 
-&CPU1 {
+&cpu1 {
 	/delete-property/ power-domains;
 	/delete-property/ power-domain-names;
 
-	cpu-idle-states = <&LITTLE_CPU_SLEEP_0
-			   &LITTLE_CPU_SLEEP_1
-			   &CLUSTER_SLEEP_0>;
+	cpu-idle-states = <&little_cpu_sleep_0
+			   &little_cpu_sleep_1
+			   &cluster_sleep_0>;
 };
 
-&CPU2 {
+&cpu2 {
 	/delete-property/ power-domains;
 	/delete-property/ power-domain-names;
 
-	cpu-idle-states = <&LITTLE_CPU_SLEEP_0
-			   &LITTLE_CPU_SLEEP_1
-			   &CLUSTER_SLEEP_0>;
+	cpu-idle-states = <&little_cpu_sleep_0
+			   &little_cpu_sleep_1
+			   &cluster_sleep_0>;
 };
 
-&CPU3 {
+&cpu3 {
 	/delete-property/ power-domains;
 	/delete-property/ power-domain-names;
 
-	cpu-idle-states = <&LITTLE_CPU_SLEEP_0
-			   &LITTLE_CPU_SLEEP_1
-			   &CLUSTER_SLEEP_0>;
+	cpu-idle-states = <&little_cpu_sleep_0
+			   &little_cpu_sleep_1
+			   &cluster_sleep_0>;
 };
 
-&CPU4 {
+&cpu4 {
 	/delete-property/ power-domains;
 	/delete-property/ power-domain-names;
 
-	cpu-idle-states = <&LITTLE_CPU_SLEEP_0
-			   &LITTLE_CPU_SLEEP_1
-			   &CLUSTER_SLEEP_0>;
+	cpu-idle-states = <&little_cpu_sleep_0
+			   &little_cpu_sleep_1
+			   &cluster_sleep_0>;
 };
 
-&CPU5 {
+&cpu5 {
 	/delete-property/ power-domains;
 	/delete-property/ power-domain-names;
 
-	cpu-idle-states = <&LITTLE_CPU_SLEEP_0
-			   &LITTLE_CPU_SLEEP_1
-			   &CLUSTER_SLEEP_0>;
+	cpu-idle-states = <&little_cpu_sleep_0
+			   &little_cpu_sleep_1
+			   &cluster_sleep_0>;
 };
 
-&CPU6 {
+&cpu6 {
 	/delete-property/ power-domains;
 	/delete-property/ power-domain-names;
 
-	cpu-idle-states = <&BIG_CPU_SLEEP_0
-			   &BIG_CPU_SLEEP_1
-			   &CLUSTER_SLEEP_0>;
+	cpu-idle-states = <&big_cpu_sleep_0
+			   &big_cpu_sleep_1
+			   &cluster_sleep_0>;
 };
 
-&CPU7 {
+&cpu7 {
 	/delete-property/ power-domains;
 	/delete-property/ power-domain-names;
 
-	cpu-idle-states = <&BIG_CPU_SLEEP_0
-			   &BIG_CPU_SLEEP_1
-			   &CLUSTER_SLEEP_0>;
+	cpu-idle-states = <&big_cpu_sleep_0
+			   &big_cpu_sleep_1
+			   &cluster_sleep_0>;
 };
 
 /delete-node/ &domain_idle_states;
 
 &idle_states {
-	CLUSTER_SLEEP_0: cluster-sleep-0 {
+	cluster_sleep_0: cluster-sleep-0 {
 		compatible = "arm,idle-state";
 		idle-state-name = "cluster-power-down";
 		arm,psci-suspend-param = <0x40003444>;
@@ -92,15 +92,15 @@
 	};
 };
 
-/delete-node/ &CPU_PD0;
-/delete-node/ &CPU_PD1;
-/delete-node/ &CPU_PD2;
-/delete-node/ &CPU_PD3;
-/delete-node/ &CPU_PD4;
-/delete-node/ &CPU_PD5;
-/delete-node/ &CPU_PD6;
-/delete-node/ &CPU_PD7;
-/delete-node/ &CLUSTER_PD;
+/delete-node/ &cpu_pd0;
+/delete-node/ &cpu_pd1;
+/delete-node/ &cpu_pd2;
+/delete-node/ &cpu_pd3;
+/delete-node/ &cpu_pd4;
+/delete-node/ &cpu_pd5;
+/delete-node/ &cpu_pd6;
+/delete-node/ &cpu_pd7;
+/delete-node/ &cluster_pd;
 
 &apps_rsc {
 	/delete-property/ power-domains;
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi
index 3c124bbe2f4c9..25b17b0425f24 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi
@@ -53,14 +53,14 @@
 			cooling-maps {
 				map0 {
 					trip = <&skin_temp_alert0>;
-					cooling-device = <&CPU6 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU7 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
+					cooling-device = <&cpu6 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu7 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 				};
 
 				map1 {
 					trip = <&skin_temp_alert1>;
-					cooling-device = <&CPU6 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU7 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
+					cooling-device = <&cpu6 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu7 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 				};
 			};
 		};
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi
index b2df22faafe88..f57976906d630 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi
@@ -71,14 +71,14 @@
 			cooling-maps {
 				map0 {
 					trip = <&skin_temp_alert0>;
-					cooling-device = <&CPU6 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU7 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
+					cooling-device = <&cpu6 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu7 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 				};
 
 				map1 {
 					trip = <&skin_temp_alert1>;
-					cooling-device = <&CPU6 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU7 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
+					cooling-device = <&cpu6 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu7 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 				};
 			};
 		};
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-wormdingler.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-wormdingler.dtsi
index af89d80426abb..d4925be3b1fcf 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-wormdingler.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-wormdingler.dtsi
@@ -78,14 +78,14 @@
 			cooling-maps {
 				map0 {
 					trip = <&skin_temp_alert0>;
-					cooling-device = <&CPU6 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU7 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
+					cooling-device = <&cpu6 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu7 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 				};
 
 				map1 {
 					trip = <&skin_temp_alert1>;
-					cooling-device = <&CPU6 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU7 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
+					cooling-device = <&cpu6 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu7 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 				};
 			};
 		};
diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
index b5ebf89803251..19df1c8f7891b 100644
--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -77,28 +77,28 @@
 		#address-cells = <2>;
 		#size-cells = <0>;
 
-		CPU0: cpu@0 {
+		cpu0: cpu@0 {
 			device_type = "cpu";
 			compatible = "qcom,kryo468";
 			reg = <0x0 0x0>;
 			clocks = <&cpufreq_hw 0>;
 			enable-method = "psci";
-			power-domains = <&CPU_PD0>;
+			power-domains = <&cpu_pd0>;
 			power-domain-names = "psci";
 			capacity-dmips-mhz = <415>;
 			dynamic-power-coefficient = <137>;
 			operating-points-v2 = <&cpu0_opp_table>;
 			interconnects = <&gem_noc MASTER_APPSS_PROC 3 &mc_virt SLAVE_EBI1 3>,
 					<&osm_l3 MASTER_OSM_L3_APPS &osm_l3 SLAVE_OSM_L3>;
-			next-level-cache = <&L2_0>;
+			next-level-cache = <&l2_0>;
 			#cooling-cells = <2>;
 			qcom,freq-domain = <&cpufreq_hw 0>;
-			L2_0: l2-cache {
+			l2_0: l2-cache {
 				compatible = "cache";
 				cache-level = <2>;
 				cache-unified;
-				next-level-cache = <&L3_0>;
-				L3_0: l3-cache {
+				next-level-cache = <&l3_0>;
+				l3_0: l3-cache {
 					compatible = "cache";
 					cache-level = <3>;
 					cache-unified;
@@ -106,206 +106,206 @@
 			};
 		};
 
-		CPU1: cpu@100 {
+		cpu1: cpu@100 {
 			device_type = "cpu";
 			compatible = "qcom,kryo468";
 			reg = <0x0 0x100>;
 			clocks = <&cpufreq_hw 0>;
 			enable-method = "psci";
-			power-domains = <&CPU_PD1>;
+			power-domains = <&cpu_pd1>;
 			power-domain-names = "psci";
 			capacity-dmips-mhz = <415>;
 			dynamic-power-coefficient = <137>;
-			next-level-cache = <&L2_100>;
+			next-level-cache = <&l2_100>;
 			operating-points-v2 = <&cpu0_opp_table>;
 			interconnects = <&gem_noc MASTER_APPSS_PROC 3 &mc_virt SLAVE_EBI1 3>,
 					<&osm_l3 MASTER_OSM_L3_APPS &osm_l3 SLAVE_OSM_L3>;
 			#cooling-cells = <2>;
 			qcom,freq-domain = <&cpufreq_hw 0>;
-			L2_100: l2-cache {
+			l2_100: l2-cache {
 				compatible = "cache";
 				cache-level = <2>;
 				cache-unified;
-				next-level-cache = <&L3_0>;
+				next-level-cache = <&l3_0>;
 			};
 		};
 
-		CPU2: cpu@200 {
+		cpu2: cpu@200 {
 			device_type = "cpu";
 			compatible = "qcom,kryo468";
 			reg = <0x0 0x200>;
 			clocks = <&cpufreq_hw 0>;
 			enable-method = "psci";
-			power-domains = <&CPU_PD2>;
+			power-domains = <&cpu_pd2>;
 			power-domain-names = "psci";
 			capacity-dmips-mhz = <415>;
 			dynamic-power-coefficient = <137>;
-			next-level-cache = <&L2_200>;
+			next-level-cache = <&l2_200>;
 			operating-points-v2 = <&cpu0_opp_table>;
 			interconnects = <&gem_noc MASTER_APPSS_PROC 3 &mc_virt SLAVE_EBI1 3>,
 					<&osm_l3 MASTER_OSM_L3_APPS &osm_l3 SLAVE_OSM_L3>;
 			#cooling-cells = <2>;
 			qcom,freq-domain = <&cpufreq_hw 0>;
-			L2_200: l2-cache {
+			l2_200: l2-cache {
 				compatible = "cache";
 				cache-level = <2>;
 				cache-unified;
-				next-level-cache = <&L3_0>;
+				next-level-cache = <&l3_0>;
 			};
 		};
 
-		CPU3: cpu@300 {
+		cpu3: cpu@300 {
 			device_type = "cpu";
 			compatible = "qcom,kryo468";
 			reg = <0x0 0x300>;
 			clocks = <&cpufreq_hw 0>;
 			enable-method = "psci";
-			power-domains = <&CPU_PD3>;
+			power-domains = <&cpu_pd3>;
 			power-domain-names = "psci";
 			capacity-dmips-mhz = <415>;
 			dynamic-power-coefficient = <137>;
-			next-level-cache = <&L2_300>;
+			next-level-cache = <&l2_300>;
 			operating-points-v2 = <&cpu0_opp_table>;
 			interconnects = <&gem_noc MASTER_APPSS_PROC 3 &mc_virt SLAVE_EBI1 3>,
 					<&osm_l3 MASTER_OSM_L3_APPS &osm_l3 SLAVE_OSM_L3>;
 			#cooling-cells = <2>;
 			qcom,freq-domain = <&cpufreq_hw 0>;
-			L2_300: l2-cache {
+			l2_300: l2-cache {
 				compatible = "cache";
 				cache-level = <2>;
 				cache-unified;
-				next-level-cache = <&L3_0>;
+				next-level-cache = <&l3_0>;
 			};
 		};
 
-		CPU4: cpu@400 {
+		cpu4: cpu@400 {
 			device_type = "cpu";
 			compatible = "qcom,kryo468";
 			reg = <0x0 0x400>;
 			clocks = <&cpufreq_hw 0>;
 			enable-method = "psci";
-			power-domains = <&CPU_PD4>;
+			power-domains = <&cpu_pd4>;
 			power-domain-names = "psci";
 			capacity-dmips-mhz = <415>;
 			dynamic-power-coefficient = <137>;
-			next-level-cache = <&L2_400>;
+			next-level-cache = <&l2_400>;
 			operating-points-v2 = <&cpu0_opp_table>;
 			interconnects = <&gem_noc MASTER_APPSS_PROC 3 &mc_virt SLAVE_EBI1 3>,
 					<&osm_l3 MASTER_OSM_L3_APPS &osm_l3 SLAVE_OSM_L3>;
 			#cooling-cells = <2>;
 			qcom,freq-domain = <&cpufreq_hw 0>;
-			L2_400: l2-cache {
+			l2_400: l2-cache {
 				compatible = "cache";
 				cache-level = <2>;
 				cache-unified;
-				next-level-cache = <&L3_0>;
+				next-level-cache = <&l3_0>;
 			};
 		};
 
-		CPU5: cpu@500 {
+		cpu5: cpu@500 {
 			device_type = "cpu";
 			compatible = "qcom,kryo468";
 			reg = <0x0 0x500>;
 			clocks = <&cpufreq_hw 0>;
 			enable-method = "psci";
-			power-domains = <&CPU_PD5>;
+			power-domains = <&cpu_pd5>;
 			power-domain-names = "psci";
 			capacity-dmips-mhz = <415>;
 			dynamic-power-coefficient = <137>;
-			next-level-cache = <&L2_500>;
+			next-level-cache = <&l2_500>;
 			operating-points-v2 = <&cpu0_opp_table>;
 			interconnects = <&gem_noc MASTER_APPSS_PROC 3 &mc_virt SLAVE_EBI1 3>,
 					<&osm_l3 MASTER_OSM_L3_APPS &osm_l3 SLAVE_OSM_L3>;
 			#cooling-cells = <2>;
 			qcom,freq-domain = <&cpufreq_hw 0>;
-			L2_500: l2-cache {
+			l2_500: l2-cache {
 				compatible = "cache";
 				cache-level = <2>;
 				cache-unified;
-				next-level-cache = <&L3_0>;
+				next-level-cache = <&l3_0>;
 			};
 		};
 
-		CPU6: cpu@600 {
+		cpu6: cpu@600 {
 			device_type = "cpu";
 			compatible = "qcom,kryo468";
 			reg = <0x0 0x600>;
 			clocks = <&cpufreq_hw 1>;
 			enable-method = "psci";
-			power-domains = <&CPU_PD6>;
+			power-domains = <&cpu_pd6>;
 			power-domain-names = "psci";
 			capacity-dmips-mhz = <1024>;
 			dynamic-power-coefficient = <480>;
-			next-level-cache = <&L2_600>;
+			next-level-cache = <&l2_600>;
 			operating-points-v2 = <&cpu6_opp_table>;
 			interconnects = <&gem_noc MASTER_APPSS_PROC 3 &mc_virt SLAVE_EBI1 3>,
 					<&osm_l3 MASTER_OSM_L3_APPS &osm_l3 SLAVE_OSM_L3>;
 			#cooling-cells = <2>;
 			qcom,freq-domain = <&cpufreq_hw 1>;
-			L2_600: l2-cache {
+			l2_600: l2-cache {
 				compatible = "cache";
 				cache-level = <2>;
 				cache-unified;
-				next-level-cache = <&L3_0>;
+				next-level-cache = <&l3_0>;
 			};
 		};
 
-		CPU7: cpu@700 {
+		cpu7: cpu@700 {
 			device_type = "cpu";
 			compatible = "qcom,kryo468";
 			reg = <0x0 0x700>;
 			clocks = <&cpufreq_hw 1>;
 			enable-method = "psci";
-			power-domains = <&CPU_PD7>;
+			power-domains = <&cpu_pd7>;
 			power-domain-names = "psci";
 			capacity-dmips-mhz = <1024>;
 			dynamic-power-coefficient = <480>;
-			next-level-cache = <&L2_700>;
+			next-level-cache = <&l2_700>;
 			operating-points-v2 = <&cpu6_opp_table>;
 			interconnects = <&gem_noc MASTER_APPSS_PROC 3 &mc_virt SLAVE_EBI1 3>,
 					<&osm_l3 MASTER_OSM_L3_APPS &osm_l3 SLAVE_OSM_L3>;
 			#cooling-cells = <2>;
 			qcom,freq-domain = <&cpufreq_hw 1>;
-			L2_700: l2-cache {
+			l2_700: l2-cache {
 				compatible = "cache";
 				cache-level = <2>;
 				cache-unified;
-				next-level-cache = <&L3_0>;
+				next-level-cache = <&l3_0>;
 			};
 		};
 
 		cpu-map {
 			cluster0 {
 				core0 {
-					cpu = <&CPU0>;
+					cpu = <&cpu0>;
 				};
 
 				core1 {
-					cpu = <&CPU1>;
+					cpu = <&cpu1>;
 				};
 
 				core2 {
-					cpu = <&CPU2>;
+					cpu = <&cpu2>;
 				};
 
 				core3 {
-					cpu = <&CPU3>;
+					cpu = <&cpu3>;
 				};
 
 				core4 {
-					cpu = <&CPU4>;
+					cpu = <&cpu4>;
 				};
 
 				core5 {
-					cpu = <&CPU5>;
+					cpu = <&cpu5>;
 				};
 
 				core6 {
-					cpu = <&CPU6>;
+					cpu = <&cpu6>;
 				};
 
 				core7 {
-					cpu = <&CPU7>;
+					cpu = <&cpu7>;
 				};
 			};
 		};
@@ -313,7 +313,7 @@
 		idle_states: idle-states {
 			entry-method = "psci";
 
-			LITTLE_CPU_SLEEP_0: cpu-sleep-0-0 {
+			little_cpu_sleep_0: cpu-sleep-0-0 {
 				compatible = "arm,idle-state";
 				idle-state-name = "little-power-down";
 				arm,psci-suspend-param = <0x40000003>;
@@ -323,7 +323,7 @@
 				local-timer-stop;
 			};
 
-			LITTLE_CPU_SLEEP_1: cpu-sleep-0-1 {
+			little_cpu_sleep_1: cpu-sleep-0-1 {
 				compatible = "arm,idle-state";
 				idle-state-name = "little-rail-power-down";
 				arm,psci-suspend-param = <0x40000004>;
@@ -333,7 +333,7 @@
 				local-timer-stop;
 			};
 
-			BIG_CPU_SLEEP_0: cpu-sleep-1-0 {
+			big_cpu_sleep_0: cpu-sleep-1-0 {
 				compatible = "arm,idle-state";
 				idle-state-name = "big-power-down";
 				arm,psci-suspend-param = <0x40000003>;
@@ -343,7 +343,7 @@
 				local-timer-stop;
 			};
 
-			BIG_CPU_SLEEP_1: cpu-sleep-1-1 {
+			big_cpu_sleep_1: cpu-sleep-1-1 {
 				compatible = "arm,idle-state";
 				idle-state-name = "big-rail-power-down";
 				arm,psci-suspend-param = <0x40000004>;
@@ -355,7 +355,7 @@
 		};
 
 		domain_idle_states: domain-idle-states {
-			CLUSTER_SLEEP_PC: cluster-sleep-0 {
+			cluster_sleep_pc: cluster-sleep-0 {
 				compatible = "domain-idle-state";
 				idle-state-name = "cluster-l3-power-collapse";
 				arm,psci-suspend-param = <0x41000044>;
@@ -364,7 +364,7 @@
 				min-residency-us = <6118>;
 			};
 
-			CLUSTER_SLEEP_CX_RET: cluster-sleep-1 {
+			cluster_sleep_cx_ret: cluster-sleep-1 {
 				compatible = "domain-idle-state";
 				idle-state-name = "cluster-cx-retention";
 				arm,psci-suspend-param = <0x41001244>;
@@ -373,7 +373,7 @@
 				min-residency-us = <8467>;
 			};
 
-			CLUSTER_AOSS_SLEEP: cluster-sleep-2 {
+			cluster_aoss_sleep: cluster-sleep-2 {
 				compatible = "domain-idle-state";
 				idle-state-name = "cluster-power-down";
 				arm,psci-suspend-param = <0x4100b244>;
@@ -583,59 +583,59 @@
 		compatible = "arm,psci-1.0";
 		method = "smc";
 
-		CPU_PD0: cpu0 {
+		cpu_pd0: cpu0 {
 			#power-domain-cells = <0>;
-			power-domains = <&CLUSTER_PD>;
-			domain-idle-states = <&LITTLE_CPU_SLEEP_0 &LITTLE_CPU_SLEEP_1>;
+			power-domains = <&cluster_pd>;
+			domain-idle-states = <&little_cpu_sleep_0 &little_cpu_sleep_1>;
 		};
 
-		CPU_PD1: cpu1 {
+		cpu_pd1: cpu1 {
 			#power-domain-cells = <0>;
-			power-domains = <&CLUSTER_PD>;
-			domain-idle-states = <&LITTLE_CPU_SLEEP_0 &LITTLE_CPU_SLEEP_1>;
+			power-domains = <&cluster_pd>;
+			domain-idle-states = <&little_cpu_sleep_0 &little_cpu_sleep_1>;
 		};
 
-		CPU_PD2: cpu2 {
+		cpu_pd2: cpu2 {
 			#power-domain-cells = <0>;
-			power-domains = <&CLUSTER_PD>;
-			domain-idle-states = <&LITTLE_CPU_SLEEP_0 &LITTLE_CPU_SLEEP_1>;
+			power-domains = <&cluster_pd>;
+			domain-idle-states = <&little_cpu_sleep_0 &little_cpu_sleep_1>;
 		};
 
-		CPU_PD3: cpu3 {
+		cpu_pd3: cpu3 {
 			#power-domain-cells = <0>;
-			power-domains = <&CLUSTER_PD>;
-			domain-idle-states = <&LITTLE_CPU_SLEEP_0 &LITTLE_CPU_SLEEP_1>;
+			power-domains = <&cluster_pd>;
+			domain-idle-states = <&little_cpu_sleep_0 &little_cpu_sleep_1>;
 		};
 
-		CPU_PD4: cpu4 {
+		cpu_pd4: cpu4 {
 			#power-domain-cells = <0>;
-			power-domains = <&CLUSTER_PD>;
-			domain-idle-states = <&LITTLE_CPU_SLEEP_0 &LITTLE_CPU_SLEEP_1>;
+			power-domains = <&cluster_pd>;
+			domain-idle-states = <&little_cpu_sleep_0 &little_cpu_sleep_1>;
 		};
 
-		CPU_PD5: cpu5 {
+		cpu_pd5: cpu5 {
 			#power-domain-cells = <0>;
-			power-domains = <&CLUSTER_PD>;
-			domain-idle-states = <&LITTLE_CPU_SLEEP_0 &LITTLE_CPU_SLEEP_1>;
+			power-domains = <&cluster_pd>;
+			domain-idle-states = <&little_cpu_sleep_0 &little_cpu_sleep_1>;
 		};
 
-		CPU_PD6: cpu6 {
+		cpu_pd6: cpu6 {
 			#power-domain-cells = <0>;
-			power-domains = <&CLUSTER_PD>;
-			domain-idle-states = <&BIG_CPU_SLEEP_0 &BIG_CPU_SLEEP_1>;
+			power-domains = <&cluster_pd>;
+			domain-idle-states = <&big_cpu_sleep_0 &big_cpu_sleep_1>;
 		};
 
-		CPU_PD7: cpu7 {
+		cpu_pd7: cpu7 {
 			#power-domain-cells = <0>;
-			power-domains = <&CLUSTER_PD>;
-			domain-idle-states = <&BIG_CPU_SLEEP_0 &BIG_CPU_SLEEP_1>;
+			power-domains = <&cluster_pd>;
+			domain-idle-states = <&big_cpu_sleep_0 &big_cpu_sleep_1>;
 		};
 
-		CLUSTER_PD: cpu-cluster0 {
+		cluster_pd: cpu-cluster0 {
 			#power-domain-cells = <0>;
-			domain-idle-states = <&CLUSTER_SLEEP_PC
-					      &CLUSTER_SLEEP_CX_RET
-					      &CLUSTER_AOSS_SLEEP>;
+			domain-idle-states = <&cluster_sleep_pc
+					      &cluster_sleep_cx_ret
+					      &cluster_aoss_sleep>;
 		};
 	};
 
@@ -2546,7 +2546,7 @@
 			compatible = "arm,coresight-etm4x", "arm,primecell";
 			reg = <0 0x07040000 0 0x1000>;
 
-			cpu = <&CPU0>;
+			cpu = <&cpu0>;
 
 			clocks = <&aoss_qmp>;
 			clock-names = "apb_pclk";
@@ -2566,7 +2566,7 @@
 			compatible = "arm,coresight-etm4x", "arm,primecell";
 			reg = <0 0x07140000 0 0x1000>;
 
-			cpu = <&CPU1>;
+			cpu = <&cpu1>;
 
 			clocks = <&aoss_qmp>;
 			clock-names = "apb_pclk";
@@ -2586,7 +2586,7 @@
 			compatible = "arm,coresight-etm4x", "arm,primecell";
 			reg = <0 0x07240000 0 0x1000>;
 
-			cpu = <&CPU2>;
+			cpu = <&cpu2>;
 
 			clocks = <&aoss_qmp>;
 			clock-names = "apb_pclk";
@@ -2606,7 +2606,7 @@
 			compatible = "arm,coresight-etm4x", "arm,primecell";
 			reg = <0 0x07340000 0 0x1000>;
 
-			cpu = <&CPU3>;
+			cpu = <&cpu3>;
 
 			clocks = <&aoss_qmp>;
 			clock-names = "apb_pclk";
@@ -2626,7 +2626,7 @@
 			compatible = "arm,coresight-etm4x", "arm,primecell";
 			reg = <0 0x07440000 0 0x1000>;
 
-			cpu = <&CPU4>;
+			cpu = <&cpu4>;
 
 			clocks = <&aoss_qmp>;
 			clock-names = "apb_pclk";
@@ -2646,7 +2646,7 @@
 			compatible = "arm,coresight-etm4x", "arm,primecell";
 			reg = <0 0x07540000 0 0x1000>;
 
-			cpu = <&CPU5>;
+			cpu = <&cpu5>;
 
 			clocks = <&aoss_qmp>;
 			clock-names = "apb_pclk";
@@ -2666,7 +2666,7 @@
 			compatible = "arm,coresight-etm4x", "arm,primecell";
 			reg = <0 0x07640000 0 0x1000>;
 
-			cpu = <&CPU6>;
+			cpu = <&cpu6>;
 
 			clocks = <&aoss_qmp>;
 			clock-names = "apb_pclk";
@@ -2686,7 +2686,7 @@
 			compatible = "arm,coresight-etm4x", "arm,primecell";
 			reg = <0 0x07740000 0 0x1000>;
 
-			cpu = <&CPU7>;
+			cpu = <&cpu7>;
 
 			clocks = <&aoss_qmp>;
 			clock-names = "apb_pclk";
@@ -3734,7 +3734,7 @@
 					  <SLEEP_TCS   3>,
 					  <WAKE_TCS    3>,
 					  <CONTROL_TCS 1>;
-			power-domains = <&CLUSTER_PD>;
+			power-domains = <&cluster_pd>;
 
 			rpmhcc: clock-controller {
 				compatible = "qcom,sc7180-rpmh-clk";
@@ -4063,21 +4063,21 @@
 			cooling-maps {
 				map0 {
 					trip = <&cpu0_alert0>;
-					cooling-device = <&CPU0 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU1 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU2 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU3 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU4 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU5 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
+					cooling-device = <&cpu0 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu1 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu2 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu3 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu4 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu5 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 				};
 				map1 {
 					trip = <&cpu0_alert1>;
-					cooling-device = <&CPU0 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU1 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU2 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU3 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU4 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU5 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
+					cooling-device = <&cpu0 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu1 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu2 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu3 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu4 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu5 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 				};
 			};
 		};
@@ -4111,21 +4111,21 @@
 			cooling-maps {
 				map0 {
 					trip = <&cpu1_alert0>;
-					cooling-device = <&CPU0 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU1 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU2 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU3 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU4 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU5 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
+					cooling-device = <&cpu0 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu1 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu2 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu3 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu4 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu5 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 				};
 				map1 {
 					trip = <&cpu1_alert1>;
-					cooling-device = <&CPU0 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU1 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU2 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU3 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU4 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU5 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
+					cooling-device = <&cpu0 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu1 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu2 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu3 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu4 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu5 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 				};
 			};
 		};
@@ -4159,21 +4159,21 @@
 			cooling-maps {
 				map0 {
 					trip = <&cpu2_alert0>;
-					cooling-device = <&CPU0 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU1 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU2 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU3 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU4 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU5 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
+					cooling-device = <&cpu0 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu1 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu2 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu3 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu4 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu5 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 				};
 				map1 {
 					trip = <&cpu2_alert1>;
-					cooling-device = <&CPU0 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU1 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU2 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU3 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU4 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU5 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
+					cooling-device = <&cpu0 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu1 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu2 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu3 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu4 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu5 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 				};
 			};
 		};
@@ -4207,21 +4207,21 @@
 			cooling-maps {
 				map0 {
 					trip = <&cpu3_alert0>;
-					cooling-device = <&CPU0 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU1 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU2 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU3 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU4 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU5 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
+					cooling-device = <&cpu0 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu1 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu2 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu3 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu4 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu5 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 				};
 				map1 {
 					trip = <&cpu3_alert1>;
-					cooling-device = <&CPU0 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU1 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU2 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU3 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU4 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU5 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
+					cooling-device = <&cpu0 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu1 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu2 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu3 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu4 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu5 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 				};
 			};
 		};
@@ -4255,21 +4255,21 @@
 			cooling-maps {
 				map0 {
 					trip = <&cpu4_alert0>;
-					cooling-device = <&CPU0 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU1 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU2 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU3 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU4 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU5 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
+					cooling-device = <&cpu0 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu1 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu2 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu3 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu4 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu5 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 				};
 				map1 {
 					trip = <&cpu4_alert1>;
-					cooling-device = <&CPU0 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU1 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU2 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU3 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU4 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU5 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
+					cooling-device = <&cpu0 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu1 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu2 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu3 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu4 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu5 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 				};
 			};
 		};
@@ -4303,21 +4303,21 @@
 			cooling-maps {
 				map0 {
 					trip = <&cpu5_alert0>;
-					cooling-device = <&CPU0 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU1 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU2 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU3 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU4 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU5 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
+					cooling-device = <&cpu0 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu1 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu2 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu3 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu4 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu5 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 				};
 				map1 {
 					trip = <&cpu5_alert1>;
-					cooling-device = <&CPU0 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU1 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU2 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU3 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU4 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU5 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
+					cooling-device = <&cpu0 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu1 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu2 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu3 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu4 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu5 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 				};
 			};
 		};
@@ -4351,13 +4351,13 @@
 			cooling-maps {
 				map0 {
 					trip = <&cpu6_alert0>;
-					cooling-device = <&CPU6 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU7 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
+					cooling-device = <&cpu6 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu7 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 				};
 				map1 {
 					trip = <&cpu6_alert1>;
-					cooling-device = <&CPU6 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU7 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
+					cooling-device = <&cpu6 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu7 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 				};
 			};
 		};
@@ -4391,13 +4391,13 @@
 			cooling-maps {
 				map0 {
 					trip = <&cpu7_alert0>;
-					cooling-device = <&CPU6 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU7 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
+					cooling-device = <&cpu6 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu7 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 				};
 				map1 {
 					trip = <&cpu7_alert1>;
-					cooling-device = <&CPU6 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU7 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
+					cooling-device = <&cpu6 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu7 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 				};
 			};
 		};
@@ -4431,13 +4431,13 @@
 			cooling-maps {
 				map0 {
 					trip = <&cpu8_alert0>;
-					cooling-device = <&CPU6 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU7 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
+					cooling-device = <&cpu6 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu7 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 				};
 				map1 {
 					trip = <&cpu8_alert1>;
-					cooling-device = <&CPU6 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU7 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
+					cooling-device = <&cpu6 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu7 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 				};
 			};
 		};
@@ -4471,13 +4471,13 @@
 			cooling-maps {
 				map0 {
 					trip = <&cpu9_alert0>;
-					cooling-device = <&CPU6 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU7 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
+					cooling-device = <&cpu6 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu7 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 				};
 				map1 {
 					trip = <&cpu9_alert1>;
-					cooling-device = <&CPU6 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
-							 <&CPU7 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
+					cooling-device = <&cpu6 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>,
+							 <&cpu7 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 				};
 			};
 		};
diff --git a/arch/arm64/boot/dts/qcom/sm7125.dtsi b/arch/arm64/boot/dts/qcom/sm7125.dtsi
index 12dd72859a433..a53145a610a3c 100644
--- a/arch/arm64/boot/dts/qcom/sm7125.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm7125.dtsi
@@ -6,11 +6,11 @@
 #include "sc7180.dtsi"
 
 /* SM7125 uses Kryo 465 instead of Kryo 468 */
-&CPU0 { compatible = "qcom,kryo465"; };
-&CPU1 { compatible = "qcom,kryo465"; };
-&CPU2 { compatible = "qcom,kryo465"; };
-&CPU3 { compatible = "qcom,kryo465"; };
-&CPU4 { compatible = "qcom,kryo465"; };
-&CPU5 { compatible = "qcom,kryo465"; };
-&CPU6 { compatible = "qcom,kryo465"; };
-&CPU7 { compatible = "qcom,kryo465"; };
+&cpu0 { compatible = "qcom,kryo465"; };
+&cpu1 { compatible = "qcom,kryo465"; };
+&cpu2 { compatible = "qcom,kryo465"; };
+&cpu3 { compatible = "qcom,kryo465"; };
+&cpu4 { compatible = "qcom,kryo465"; };
+&cpu5 { compatible = "qcom,kryo465"; };
+&cpu6 { compatible = "qcom,kryo465"; };
+&cpu7 { compatible = "qcom,kryo465"; };
-- 
2.39.5



