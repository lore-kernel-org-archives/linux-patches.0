Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017044;
	b=38z8uqOvD7QU0gfomjWLUajQXE6vnxoUruBLkbAw/0xMHoW9bDgftVRkyoWxDOaKwtIB
	 ne1zSSrg0DnTsBrimZV+oQJBo/EYqs87Qm13h1g8XLthKUlCdFyws3Vi5Th/qjtg/ayre
	 30ronSApY8B3rOIdKP6gcaF1MjVZhF+4UrSbecwy/1JIK8jVrJFgO/07M/3em51RjqH+d
	 JEsQL300HxLCV++yrVa1z0ODF0t08LUifBg+qx1ALhZ1ofP4YvUjFqzVgy0EBz061erJQ
	 nAsF60EH6JhKXex7yDA+NmeKvHZEqWBSnWVBp0t372irEmdmTwkqDkLI4nPEpyP4cSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017044;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=82OmfySOyER1/Lq4tzHkJJqU0GsNtP+Lr00j7eshHjA=;
	b=GUxG3LMf/qdCd+myzvT59XSgdRr1I0RY/xIP/Fw0t2fELdkNz5S/y0kJZaGH4a621+/S
	 pkXxeWEbqvhJiZ6pBuSIL906KU40izM2+Lf004kVrF9WzGx4ZxOxXRdQ0MxxsjjMZoa+9
	 hsJE8pcXaPKKVdSuU1zY6fqDUcbtJnZ6ICGp4pAYARpdj261Tpn0x2bVTfFNM1w0qXCFp
	 bVL2JThQxhzArRsJqYHSpx2kHZ3uJuuhBcReg5f0YS9JP+kT4ywQLm3pT6Q7/4JeqEn2K
	 /w1DCp6Zuk/BS6EXL7ydcJ9n9cwN35jAxTzdJ+dhEOA751tvVmqx8VrLopwhotCDxAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pczesbbv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62953606A32F;
	Wed, 18 Nov 2026 15:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pczesbbv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A6A1F000C6;
	Wed, 18 Nov 2026 15:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017044;
	bh=82OmfySOyER1/Lq4tzHkJJqU0GsNtP+Lr00j7eshHjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pczesbbvpiCmPR38z4Au7sLZG0UtoPMIgoHp0+YL7YR0y3jR/NOeMx23D0lnOG7Zd
	 kcKdHcsc6ddyM6nUWTyfGtzz22gT5yRr+yyijvVYxuWh+3B7fQ8YHyce7RiCwlzVYg
	 prk6Ri9liJDYNiRZxboXLPoNt99uJ1ObN2TnRZzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0745/2651] ARM: dts: ux500: Convert HREF audio to audio-graph-card2
Date: Wed, 18 Nov 2026 15:33:05 +0100
Message-ID: <20261118150314.702554531@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit f9b2262d1edba1b6c0abc12118105f8fa200980a ]

Describe the HREF500 and HREF520 sound hardware with two-link audio
graph cards in their PMIC-specific HREF DTSIs, and name the card
HREF-500. Connect MSP1 to codec DAI 0 for playback and MSP3 to codec
DAI 1 for capture.

Describe the DSP_A format, codec-provided bit and frame clocks,
16-by-16-bit TDM frame and active slots on the graph endpoints. Keep the
clocks running continuously, matching the legacy machine driver's normal
one- and two-channel mode.

Keep each complete card, including its endpoint graph, connector
widgets and routes, in the existing PMIC-specific HREF DTSI. The AB8500
variant exposes six digital microphone endpoints. AB8505 has neither
the digital microphone interface nor its VDMIC regulator, so leave
these endpoints out of HREF520 and remove its stale regulator and pin
configuration nodes.

Select ULPCLK as the fixed parent of the codec audio clock in the
HREF-specific codec DTSIs. This replaces the machine driver clock
control with declarative board policy.

Fixes: 4ecae2ae9535 ("ARM: dts: ux500-href: Switch HREF520 to AB8505")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/st/ste-ab8500.dtsi      |   6 --
 arch/arm/boot/dts/st/ste-ab8505.dtsi      |   6 --
 arch/arm/boot/dts/st/ste-dbx5x0.dtsi      |   5 -
 arch/arm/boot/dts/st/ste-href-ab8500.dtsi | 104 +++++++++++++++++++
 arch/arm/boot/dts/st/ste-href-ab8505.dtsi | 118 +++++++++++++++++-----
 5 files changed, 196 insertions(+), 43 deletions(-)

diff --git a/arch/arm/boot/dts/st/ste-ab8500.dtsi b/arch/arm/boot/dts/st/ste-ab8500.dtsi
index dd30d08ccb9b9..a55f365ea0200 100644
--- a/arch/arm/boot/dts/st/ste-ab8500.dtsi
+++ b/arch/arm/boot/dts/st/ste-ab8500.dtsi
@@ -364,12 +364,6 @@ ab8500_ldo_ana_reg: ab8500_ldo_ana {
 			};
 		};
 
-		sound {
-			stericsson,audio-codec = <&codec>;
-			clocks = <&prcmu_clk PRCMU_SYSCLK>, <&ab8500_clock AB8500_SYSCLK_ULP>, <&ab8500_clock AB8500_SYSCLK_INT>;
-			clock-names = "sysclk", "ulpclk", "intclk";
-		};
-
 		mcde@a0350000 {
 			vana-supply = <&ab8500_ldo_ana_reg>;
 
diff --git a/arch/arm/boot/dts/st/ste-ab8505.dtsi b/arch/arm/boot/dts/st/ste-ab8505.dtsi
index 131c82508e820..24b12f0cf322f 100644
--- a/arch/arm/boot/dts/st/ste-ab8505.dtsi
+++ b/arch/arm/boot/dts/st/ste-ab8505.dtsi
@@ -301,12 +301,6 @@ ab8500_ldo_ana_reg: ab8500_ldo_ana {
 			};
 		};
 
-		sound {
-			stericsson,audio-codec = <&codec>;
-			clocks = <&prcmu_clk PRCMU_SYSCLK>, <&ab8500_clock AB8500_SYSCLK_ULP>, <&ab8500_clock AB8500_SYSCLK_INT>;
-			clock-names = "sysclk", "ulpclk", "intclk";
-		};
-
 		mcde@a0350000 {
 			vana-supply = <&ab8500_ldo_ana_reg>;
 
diff --git a/arch/arm/boot/dts/st/ste-dbx5x0.dtsi b/arch/arm/boot/dts/st/ste-dbx5x0.dtsi
index 25a20fafc6b96..32ef115a243c9 100644
--- a/arch/arm/boot/dts/st/ste-dbx5x0.dtsi
+++ b/arch/arm/boot/dts/st/ste-dbx5x0.dtsi
@@ -1071,11 +1071,6 @@ mmc@80008000 {
 			status = "disabled";
 		};
 
-		sound {
-			compatible = "stericsson,snd-soc-mop500";
-			stericsson,cpu-dai = <&msp1 &msp3>;
-		};
-
 		msp0: msp@80123000 {
 			compatible = "stericsson,ux500-msp-i2s";
 			reg = <0x80123000 0x1000>;
diff --git a/arch/arm/boot/dts/st/ste-href-ab8500.dtsi b/arch/arm/boot/dts/st/ste-href-ab8500.dtsi
index 5eeb44c5e9323..ff72f5f6d6525 100644
--- a/arch/arm/boot/dts/st/ste-href-ab8500.dtsi
+++ b/arch/arm/boot/dts/st/ste-href-ab8500.dtsi
@@ -6,6 +6,48 @@
 #include "ste-ab8500.dtsi"
 
 / {
+	href_sound: sound {
+		compatible = "audio-graph-card2";
+		label = "HREF-500";
+		widgets =
+			"Headphone", "Headset",
+			"Speaker", "Earpiece Speaker",
+			"Speaker", "Loudspeaker",
+			"Line", "Line Out",
+			"Speaker", "Vibra 1 Motor",
+			"Speaker", "Vibra 2 Motor",
+			"Microphone", "Mic 1 Jack",
+			"Microphone", "Mic 2 Jack",
+			"Line", "Line In",
+			"Microphone", "Digital Mic 1",
+			"Microphone", "Digital Mic 2",
+			"Microphone", "Digital Mic 3",
+			"Microphone", "Digital Mic 4",
+			"Microphone", "Digital Mic 5",
+			"Microphone", "Digital Mic 6";
+		routing =
+			"Headset", "Headset Left",
+			"Headset", "Headset Right",
+			"Earpiece Speaker", "Earpiece",
+			"Loudspeaker", "Speaker Left",
+			"Loudspeaker", "Speaker Right",
+			"Line Out", "LineOut Left",
+			"Line Out", "LineOut Right",
+			"Vibra 1 Motor", "Vibra 1",
+			"Vibra 2 Motor", "Vibra 2",
+			"Mic 1", "Mic 1 Jack",
+			"Mic 2", "Mic 2 Jack",
+			"LineIn Left", "Line In",
+			"LineIn Right", "Line In",
+			"DMic 1", "Digital Mic 1",
+			"DMic 2", "Digital Mic 2",
+			"DMic 3", "Digital Mic 3",
+			"DMic 4", "Digital Mic 4",
+			"DMic 5", "Digital Mic 5",
+			"DMic 6", "Digital Mic 6";
+		links = <&href_msp1_port &href_msp3_port>;
+	};
+
 	soc {
 		prcmu@80157000 {
 			ab8500 {
@@ -488,3 +530,65 @@ ab8500_chargalg {
 		};
 	};
 };
+
+&codec {
+	assigned-clocks = <&ab8500_clock AB8500_SYSCLK_INT>;
+	assigned-clock-parents = <&ab8500_clock AB8500_SYSCLK_ULP>;
+
+	ports {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		port@0 {
+			reg = <0>;
+
+			href_codec_playback: endpoint {
+				remote-endpoint = <&href_msp1_endpoint>;
+				bitclock-master;
+				frame-master;
+				dai-tdm-slot-num = <16>;
+				dai-tdm-slot-width = <16>;
+				dai-tdm-slot-tx-mask = <0 1 0 1>;
+			};
+		};
+
+		port@1 {
+			reg = <1>;
+
+			href_codec_capture: endpoint {
+				remote-endpoint = <&href_msp3_endpoint>;
+				bitclock-master;
+				frame-master;
+				dai-tdm-slot-num = <16>;
+				dai-tdm-slot-width = <16>;
+				dai-tdm-slot-rx-mask = <1>;
+			};
+		};
+	};
+};
+
+&msp1 {
+	href_msp1_port: port {
+		href_msp1_endpoint: endpoint {
+			continuous-clock;
+			remote-endpoint = <&href_codec_playback>;
+			dai-format = "dsp_a";
+			dai-tdm-slot-num = <16>;
+			dai-tdm-slot-width = <16>;
+			dai-tdm-slot-tx-mask = <0 1 0 1>;
+		};
+	};
+};
+
+&msp3 {
+	href_msp3_port: port {
+		href_msp3_endpoint: endpoint {
+			continuous-clock;
+			remote-endpoint = <&href_codec_capture>;
+			dai-format = "dsp_a";
+			dai-tdm-slot-num = <16>;
+			dai-tdm-slot-width = <16>;
+			dai-tdm-slot-rx-mask = <1>;
+		};
+	};
+};
diff --git a/arch/arm/boot/dts/st/ste-href-ab8505.dtsi b/arch/arm/boot/dts/st/ste-href-ab8505.dtsi
index 268db68ccf87b..eba6f674c6911 100644
--- a/arch/arm/boot/dts/st/ste-href-ab8505.dtsi
+++ b/arch/arm/boot/dts/st/ste-href-ab8505.dtsi
@@ -6,6 +6,36 @@
 #include "ste-ab8505.dtsi"
 
 / {
+	href_sound: sound {
+		compatible = "audio-graph-card2";
+		label = "HREF-500";
+		widgets =
+			"Headphone", "Headset",
+			"Speaker", "Earpiece Speaker",
+			"Speaker", "Loudspeaker",
+			"Line", "Line Out",
+			"Speaker", "Vibra 1 Motor",
+			"Speaker", "Vibra 2 Motor",
+			"Microphone", "Mic 1 Jack",
+			"Microphone", "Mic 2 Jack",
+			"Line", "Line In";
+		routing =
+			"Headset", "Headset Left",
+			"Headset", "Headset Right",
+			"Earpiece Speaker", "Earpiece",
+			"Loudspeaker", "Speaker Left",
+			"Loudspeaker", "Speaker Right",
+			"Line Out", "LineOut Left",
+			"Line Out", "LineOut Right",
+			"Vibra 1 Motor", "Vibra 1",
+			"Vibra 2 Motor", "Vibra 2",
+			"Mic 1", "Mic 1 Jack",
+			"Mic 2", "Mic 2 Jack",
+			"LineIn Left", "Line In",
+			"LineIn Right", "Line In";
+		links = <&href_msp1_port &href_msp3_port>;
+	};
+
 	soc {
 		prcmu@80157000 {
 			ab8505 {
@@ -48,10 +78,6 @@ ab8500_ldo_anamic2_reg: ab8500_ldo_anamic2 {
 						regulator-name = "V-AMIC2";
 					};
 
-					ab8500_ldo_dmic_reg: ab8500_ldo_dmic {
-						regulator-name = "V-DMIC";
-					};
-
 					ab8500_ldo_ana_reg: ab8500_ldo_ana {
 						regulator-name = "V-CSI/DSI";
 					};
@@ -80,7 +106,6 @@ gpio {
 						    <&pwm_default_mode>,
 						    <&adi1_default_mode>,
 						    <&usbuicc_default_mode>,
-						    <&dmic_default_mode>,
 						    <&extcpena_default_mode>,
 						    <&modsclsda_default_mode>;
 
@@ -365,27 +390,6 @@ default_cfg {
 							};
 						};
 					};
-					/* This sets up the microphone pins */
-					dmic {
-						dmic_default_mode: dmic_default {
-							default_mux {
-								function = "dmic";
-								groups = "dmic12_d_1",
-									 "dmic34_d_1",
-									 "dmic56_d_1";
-							};
-							default_cfg {
-								pins = "GPIO27_J6",
-									 "GPIO28_K6",
-									 "GPIO29_G6",
-									 "GPIO30_H6",
-									 "GPIO31_F5",
-									 "GPIO32_G5";
-								input-enable;
-								bias-pull-down;
-							};
-						};
-					};
 					extcpena {
 						extcpena_default_mode: extcpena_default {
 							default_mux {
@@ -488,3 +492,65 @@ ab8500_chargalg {
 		};
 	};
 };
+
+&codec {
+	assigned-clocks = <&ab8500_clock AB8500_SYSCLK_INT>;
+	assigned-clock-parents = <&ab8500_clock AB8500_SYSCLK_ULP>;
+
+	ports {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		port@0 {
+			reg = <0>;
+
+			href_codec_playback: endpoint {
+				remote-endpoint = <&href_msp1_endpoint>;
+				bitclock-master;
+				frame-master;
+				dai-tdm-slot-num = <16>;
+				dai-tdm-slot-width = <16>;
+				dai-tdm-slot-tx-mask = <0 1 0 1>;
+			};
+		};
+
+		port@1 {
+			reg = <1>;
+
+			href_codec_capture: endpoint {
+				remote-endpoint = <&href_msp3_endpoint>;
+				bitclock-master;
+				frame-master;
+				dai-tdm-slot-num = <16>;
+				dai-tdm-slot-width = <16>;
+				dai-tdm-slot-rx-mask = <1>;
+			};
+		};
+	};
+};
+
+&msp1 {
+	href_msp1_port: port {
+		href_msp1_endpoint: endpoint {
+			continuous-clock;
+			remote-endpoint = <&href_codec_playback>;
+			dai-format = "dsp_a";
+			dai-tdm-slot-num = <16>;
+			dai-tdm-slot-width = <16>;
+			dai-tdm-slot-tx-mask = <0 1 0 1>;
+		};
+	};
+};
+
+&msp3 {
+	href_msp3_port: port {
+		href_msp3_endpoint: endpoint {
+			continuous-clock;
+			remote-endpoint = <&href_codec_capture>;
+			dai-format = "dsp_a";
+			dai-tdm-slot-num = <16>;
+			dai-tdm-slot-width = <16>;
+			dai-tdm-slot-rx-mask = <1>;
+		};
+	};
+};
-- 
2.53.0



