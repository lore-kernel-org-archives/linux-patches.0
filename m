Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89193A3E90;
	Wed, 20 May 2026 16:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295756; cv=none; b=osem9D0AWABUgftyWzl/0QzxR8XPdVJnoZtpf7QG6qdnj4pNLRT22DXIoPOve7W0Fiz9tNnyYq2ikj9/1QSPybv1lj1Zla3I3rLVpQTDN7HTw2l1L1RB5Y2nkcPXcU3fELyGvinRx0k906q66YUzeCGMeEEikhJF0JaKseWeSUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295756; c=relaxed/simple;
	bh=koxleYiYkV+jgvAuoqbabCaCiQb1wnJirJKH1i58r3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lAN6vd46TyMyUjywGbYxPpiYo0jAhRHRUZhxKZcDfAX2LoOnjFEHnotnAXGLMBmlEr3QUdciOo2SQRL9Fqc7n9sziNvf0vdOS0iNMCHhf/WcEMpEHgIfIl5Ln6khJfJqHt8TBcsgHpStzUQ7pw2Fcc5GpccakS6Vl+RYtJNfV8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LrlptJql; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LrlptJql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D763F1F00893;
	Wed, 20 May 2026 16:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295753;
	bh=rjWZuHSCYSEhf+jMEb0zRUAGgwIggotaEpy6WUgFlVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LrlptJqlMm5Duo6T96lkown1K/NOnFmoOVLNA4KgUQimgo7wDij0RZauKj5aOz41s
	 Lv1zO38ew79vWdKbed9EGXIov1fZxJrYBEpdrC4OwEsdd+2o9J2GpLQVK+/YP/Hq0/
	 +EzNbjhmNtW/liEG6P1OOJM+H0qAeVZj939Btn9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0539/1146] arm64: dts: imx8dxl-evk: Use audio-graph-card2 for wm8960-2 and wm8960-3
Date: Wed, 20 May 2026 18:13:09 +0200
Message-ID: <20260520162200.378521798@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit e8341b0245736619f8d6a2cc311c9e8ad8e82390 ]

The sound card wm8960-2 and wm8960-3 only support capture mode for the
reason of connection on the EVK board. But fsl-asoc-card don't support
capture_only setting, the sound card creation will fail.

fsl-sai 59060000.sai: Missing dma channel for stream: 0
fsl-sai 59060000.sai: ASoC error (-22): at snd_soc_pcm_component_new() on 59060000.sai
fsl-sai 59070000.sai: Missing dma channel for stream: 0
fsl-sai 59070000.sai: ASoC error (-22): at snd_soc_pcm_component_new() on 59070000.sai

so switch to use audio-graph-card2 which supports 'capture_only'
property for wm8960-2 and wm8960-3 cards.

Fixes: b41c45eb990a ("arm64: dts: imx8dxl-evk: add audio nodes")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8dxl-evk.dts | 114 ++++++++++++++----
 1 file changed, 90 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts b/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts
index 5c68d33e19f22..bc62ae5ca812d 100644
--- a/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8dxl-evk.dts
@@ -259,33 +259,37 @@ sound-wm8960-1 {
 	};
 
 	sound-wm8960-2 {
-		compatible = "fsl,imx-audio-wm8960";
-		model = "wm8960-audio-2";
-		audio-cpu = <&sai2>;
-		audio-codec = <&wm8960_2>;
-		audio-routing = "Headphone Jack", "HP_L",
-				"Headphone Jack", "HP_R",
-				"Ext Spk", "SPK_LP",
-				"Ext Spk", "SPK_LN",
-				"Ext Spk", "SPK_RP",
-				"Ext Spk", "SPK_RN",
-				"LINPUT1", "Mic Jack",
-				"Mic Jack", "MICB";
+		compatible = "audio-graph-card2";
+		label = "wm8960-audio-2";
+		links = <&sai2_port2>;
+		routing = "Headphones", "HP_L",
+			"Headphones", "HP_R",
+			"Ext Spk", "SPK_LP",
+			"Ext Spk", "SPK_LN",
+			"Ext Spk", "SPK_RP",
+			"Ext Spk", "SPK_RN",
+			"LINPUT1", "Mic Jack",
+			"Mic Jack", "MICB";
+		widgets = "Headphone", "Headphones",
+			"Speaker", "Ext Spk",
+			"Microphone", "Mic Jack";
 	};
 
 	sound-wm8960-3 {
-		compatible = "fsl,imx-audio-wm8960";
-		model = "wm8960-audio-3";
-		audio-cpu = <&sai3>;
-		audio-codec = <&wm8960_3>;
-		audio-routing = "Headphone Jack", "HP_L",
-				"Headphone Jack", "HP_R",
-				"Ext Spk", "SPK_LP",
-				"Ext Spk", "SPK_LN",
-				"Ext Spk", "SPK_RP",
-				"Ext Spk", "SPK_RN",
-				"LINPUT1", "Mic Jack",
-				"Mic Jack", "MICB";
+		compatible = "audio-graph-card2";
+		label = "wm8960-audio-3";
+		links = <&sai3_port2>;
+		routing = "Headphones", "HP_L",
+			"Headphones", "HP_R",
+			"Ext Spk", "SPK_LP",
+			"Ext Spk", "SPK_LN",
+			"Ext Spk", "SPK_RP",
+			"Ext Spk", "SPK_RN",
+			"LINPUT1", "Mic Jack",
+			"Mic Jack", "MICB";
+		widgets = "Headphone", "Headphones",
+			"Speaker", "Ext Spk",
+			"Microphone", "Mic Jack";
 	};
 };
 
@@ -481,6 +485,16 @@ wm8960_2: audio-codec@1a {
 				DCVDD-supply = <&reg_audio_1v8>;
 				SPKVDD1-supply = <&reg_audio_5v>;
 				SPKVDD2-supply = <&reg_audio_5v>;
+
+				port {
+					capture-only;
+
+					wm8960_2_ep: endpoint {
+						bitclock-master;
+						frame-master;
+						remote-endpoint = <&sai2_endpoint2>;
+					};
+				};
 			};
 		};
 
@@ -510,6 +524,16 @@ wm8960_3: audio-codec@1a {
 				DCVDD-supply = <&reg_audio_1v8>;
 				SPKVDD1-supply = <&reg_audio_5v>;
 				SPKVDD2-supply = <&reg_audio_5v>;
+
+				port {
+					capture-only;
+
+					wm8960_3_ep: endpoint {
+						bitclock-master;
+						frame-master;
+						remote-endpoint = <&sai3_endpoint2>;
+					};
+				};
 			};
 		};
 
@@ -700,6 +724,27 @@ &sai2 {
 	pinctrl-0 = <&pinctrl_sai2>;
 	fsl,sai-asynchronous;
 	status = "okay";
+
+	ports {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		sai2_port1: port@1 {
+			reg = <1>;
+			endpoint { /* not used */ };
+		};
+
+		sai2_port2: port@2 {
+			reg = <2>;
+			capture-only;
+
+			sai2_endpoint2: endpoint {
+				dai-format = "i2s";
+				remote-endpoint = <&wm8960_2_ep>;
+				system-clock-direction-out;
+			};
+		};
+	};
 };
 
 &sai3 {
@@ -712,6 +757,27 @@ &sai3 {
 	pinctrl-0 = <&pinctrl_sai3>;
 	fsl,sai-asynchronous;
 	status = "okay";
+
+	ports {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		sai3_port1: port@1 {
+			reg = <1>;
+			endpoint { /* not used */ };
+		};
+
+		sai3_port2: port@2 {
+			reg = <2>;
+			capture-only;
+
+			sai3_endpoint2: endpoint {
+				dai-format = "i2s";
+				remote-endpoint = <&wm8960_3_ep>;
+				system-clock-direction-out;
+			};
+		};
+	};
 };
 
 &thermal_zones {
-- 
2.53.0



