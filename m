Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3235F3242BD;
	Fri,  4 Sep 2026 05:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501168; cv=none; b=Rev5XrgmQmYR8XWpLi39qVul4DE/NiozHgQwKVgVc0H+7Nj0cHdVGT8jCPxKsZuWF/+tgYlRSHLpzKLkTbSiMZAeXZIAknhtktlZJ/JOfoisvtr219zOFWBFdmT45G0w7avwvCfN/CJcCY+0ThmaR4Y5CVTTKStBnI/tKxe4HAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501168; c=relaxed/simple;
	bh=hw4ZTGO++ntg1uIyIaOK7HC8zLGAVqupyGm+TPzvxb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WP/HhXF0tdrxv1wP9qkVM1LWyC2Cf8j1A+mvrzThU1kPakGPSO8qZMpyIUHvegkUife+IX35KNB9clNPLODAgjj2sS8c40UuwLDNtN+ltpydDDXxxHTpDZgt2SATBaNsf2dolhoP8aXbPfFRuq+rxr7qL1E7zGGq6dZmogR57HE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BEqq+e8w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BEqq+e8w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8021F00A3D;
	Fri,  4 Sep 2026 05:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501167;
	bh=4T8lBrhl7rNBfGLF2TMoEcs7H4EH+AKGm0oZ2Sui+KI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BEqq+e8wgB6tk1vUUbcz+6HNxSy0BIzvzySmSWF+W61HT843rKPyDT6NfFcJILlGm
	 V90eMZ181nD0fgGyjxtz05ZfxbwUmyL5tCEdrtPTwPTlsi2nidsSWjvkSr9CK0kfM6
	 dr/KwT+XaIOOdShiKUn5l3YLZ74S8n6sK+yRb+8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@nabladev.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.18 315/552] arm64: dts: rockchip: Fix rk3588s-roc-pc audio description
Date: Fri,  4 Sep 2026 06:57:52 +0200
Message-ID: <20260904045757.419504732@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <festevam@nabladev.com>

commit b4db45b3ec97a9d0d23446084f45e095b2ba2020 upstream.

The rk3588s-roc-pc ES8388 codec is connected to the i2s0_8ch audio
interface.  Use the matching I2S0 MCLK output for the codec clock
instead of I2S1.

Using the I2S1 MCLK can leave the ALSA PCM running while the codec has
no usable master clock for the active audio path, resulting in silent
headphone output.

Also make the CPU DAI provide bitclock and frame clock.  This matches
the active Rockchip I2S controller side and avoids relying on the codec
to drive the bus clocks.

Route the headphone output to LOUT2 and ROUT2, matching the old 5.10
BSP device tree.  LOUT1 and ROUT1 are used for the speaker route there,
so using them for the headphone widget can leave the headphone jack
silent even while the ALSA path is active.

The old BSP also used hp-con-gpio on GPIO1_A4.  Model that GPIO as a
simple audio amplifier so DAPM enables the headphone connection when the
headphone path is active.

Cc: stable@vger.kernel.org
Fixes: 7f9509791507 ("arm64: dts: rockchip: add DTs for Firefly ROC-RK3588S-PC")
Signed-off-by: Fabio Estevam <festevam@nabladev.com>
Link: https://patch.msgid.link/20260703025648.180135-1-festevam@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3588s-roc-pc.dts |   23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

--- a/arch/arm64/boot/dts/rockchip/rk3588s-roc-pc.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588s-roc-pc.dts
@@ -23,16 +23,19 @@
 		compatible = "simple-audio-card";
 		pinctrl-names = "default";
 		pinctrl-0 = <&hp_detect>;
+		simple-audio-card,aux-devs = <&headphones_amp>;
 		simple-audio-card,name = "rockchip,es8388";
-		simple-audio-card,bitclock-master = <&masterdai>;
+		simple-audio-card,bitclock-master = <&cpudai>;
 		simple-audio-card,format = "i2s";
-		simple-audio-card,frame-master = <&masterdai>;
+		simple-audio-card,frame-master = <&cpudai>;
 		simple-audio-card,hp-det-gpios = <&gpio1 RK_PA6 GPIO_ACTIVE_LOW>;
 		simple-audio-card,mclk-fs = <256>;
 		simple-audio-card,pin-switches = "Headphones";
 		simple-audio-card,routing =
-			"Headphones", "LOUT1",
-			"Headphones", "ROUT1",
+			"Headphones", "Headphone Amp OUTL",
+			"Headphones", "Headphone Amp OUTR",
+			"Headphone Amp INL", "LOUT2",
+			"Headphone Amp INR", "ROUT2",
 			"LINPUT1", "Microphone Jack",
 			"RINPUT1", "Microphone Jack",
 			"LINPUT2", "Onboard Microphone",
@@ -47,11 +50,17 @@
 			system-clock-frequency = <12288000>;
 		};
 
-		simple-audio-card,cpu {
+		cpudai: simple-audio-card,cpu {
 			sound-dai = <&i2s0_8ch>;
 		};
 	};
 
+	headphones_amp: audio-amplifier-headphones {
+		compatible = "simple-audio-amplifier";
+		enable-gpios = <&gpio1 RK_PA4 GPIO_ACTIVE_HIGH>;
+		sound-name-prefix = "Headphone Amp";
+	};
+
 	chosen {
 		stdout-path = "serial2:1500000n8";
 	};
@@ -323,12 +332,12 @@
 	es8388: audio-codec@11 {
 		compatible = "everest,es8388", "everest,es8328";
 		reg = <0x11>;
-		clocks = <&cru I2S1_8CH_MCLKOUT>;
+		clocks = <&cru I2S0_8CH_MCLKOUT>;
 		AVDD-supply = <&vcc_3v3_s0>;
 		DVDD-supply = <&vcc_1v8_s0>;
 		HPVDD-supply = <&vcc_3v3_s0>;
 		PVDD-supply = <&vcc_3v3_s0>;
-		assigned-clocks = <&cru I2S1_8CH_MCLKOUT>;
+		assigned-clocks = <&cru I2S0_8CH_MCLKOUT>;
 		assigned-clock-rates = <12288000>;
 		#sound-dai-cells = <0>;
 	};


