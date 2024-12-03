Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026F41E3DED;
	Tue,  3 Dec 2024 15:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239789; cv=none; b=hRkfIBJQK0bp8IQLa/iY+TyHUoOu1kRL4r6+p7230vkj60ULfkLAF1Uo99YrOBX5K9pQXgxOHzQ10ZocwbzNBxvQ+uDNDu35AIc55y8xBw3tqBJEvej0mv3MlM6ATmPbOnZkCbdOTfB6CCZHABMHQ6yX2KSNBVmaCDL5PftyEGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239789; c=relaxed/simple;
	bh=q1TaoJjEBE1aoArFdkovdaXNF/zzYkDPap7NdnntcZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=baUvZg7C9TrtFIs6rdkxN4fTbnmPIAQWe5bVOif1f7QGmtWD0TiS99jCsJu5FPoSS1J9xGGVe5IKEqvUxCwgjm7CSAJfWOG5TQ8YnRjmsSc3hus1G1XilaGzGST362kBIEHEhecrK8WPNx3P2ccphkhAlLdFYqLh4k8VfynwbuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iMKD2Zgb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iMKD2Zgb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5D0C4CECF;
	Tue,  3 Dec 2024 15:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239788;
	bh=q1TaoJjEBE1aoArFdkovdaXNF/zzYkDPap7NdnntcZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iMKD2Zgbi9HGD+zGqU9bILZOZvow42XZl2WoGSlbUVIOTxLoiNfwrK0VwmN+hLQri
	 qEDRFrfdaLnVdDS9+4aJUB97mKFoyFKZ1dwY+GH+8DWvKhQOagYJ7kwLoK83gc9n6R
	 ThAo50yi56UYT2vvPsQUOTMjelsoCIEMvMBF3SYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 6.11 734/817] arm64: dts: mediatek: mt8186-corsola-voltorb: Merge speaker codec nodes
Date: Tue,  3 Dec 2024 15:45:06 +0100
Message-ID: <20241203144024.649554755@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

commit 26ea2459d1724406bf0b342df6b4b1f002d7f8e3 upstream.

The Voltorb device uses a speaker codec different from the original
Corsola device. When the Voltorb device tree was first added, the new
codec was added as a separate node when it should have just replaced the
existing one.

Merge the two nodes. The only differences are the compatible string and
the GPIO line property name. This keeps the device node path for the
speaker codec the same across the MT8186 Chromebook line. Also rename
the related labels and node names from having rt1019p to speaker codec.

Cc: stable@vger.kernel.org # v6.11+
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20241018082113.1297268-1-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../dts/mediatek/mt8186-corsola-voltorb.dtsi  | 21 +++++--------------
 .../boot/dts/mediatek/mt8186-corsola.dtsi     |  8 +++----
 2 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8186-corsola-voltorb.dtsi b/arch/arm64/boot/dts/mediatek/mt8186-corsola-voltorb.dtsi
index 52ec58128d56..b495a241b443 100644
--- a/arch/arm64/boot/dts/mediatek/mt8186-corsola-voltorb.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8186-corsola-voltorb.dtsi
@@ -10,12 +10,6 @@
 
 / {
 	chassis-type = "laptop";
-
-	max98360a: max98360a {
-		compatible = "maxim,max98360a";
-		sdmode-gpios = <&pio 150 GPIO_ACTIVE_HIGH>;
-		#sound-dai-cells = <0>;
-	};
 };
 
 &cpu6 {
@@ -59,19 +53,14 @@ &cluster1_opp_15 {
 	opp-hz = /bits/ 64 <2200000000>;
 };
 
-&rt1019p{
-	status = "disabled";
-};
-
 &sound {
 	compatible = "mediatek,mt8186-mt6366-rt5682s-max98360-sound";
-	status = "okay";
+};
 
-	spk-hdmi-playback-dai-link {
-		codec {
-			sound-dai = <&it6505dptx>, <&max98360a>;
-		};
-	};
+&speaker_codec {
+	compatible = "maxim,max98360a";
+	sdmode-gpios = <&pio 150 GPIO_ACTIVE_HIGH>;
+	/delete-property/ sdb-gpios;
 };
 
 &spmi {
diff --git a/arch/arm64/boot/dts/mediatek/mt8186-corsola.dtsi b/arch/arm64/boot/dts/mediatek/mt8186-corsola.dtsi
index 682c6ad2574d..0c0b3ac59745 100644
--- a/arch/arm64/boot/dts/mediatek/mt8186-corsola.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8186-corsola.dtsi
@@ -259,15 +259,15 @@ spk-hdmi-playback-dai-link {
 			mediatek,clk-provider = "cpu";
 			/* RT1019P and IT6505 connected to the same I2S line */
 			codec {
-				sound-dai = <&it6505dptx>, <&rt1019p>;
+				sound-dai = <&it6505dptx>, <&speaker_codec>;
 			};
 		};
 	};
 
-	rt1019p: speaker-codec {
+	speaker_codec: speaker-codec {
 		compatible = "realtek,rt1019p";
 		pinctrl-names = "default";
-		pinctrl-0 = <&rt1019p_pins_default>;
+		pinctrl-0 = <&speaker_codec_pins_default>;
 		#sound-dai-cells = <0>;
 		sdb-gpios = <&pio 150 GPIO_ACTIVE_HIGH>;
 	};
@@ -1179,7 +1179,7 @@ pins {
 		};
 	};
 
-	rt1019p_pins_default: rt1019p-default-pins {
+	speaker_codec_pins_default: speaker-codec-default-pins {
 		pins-sdb {
 			pinmux = <PINMUX_GPIO150__FUNC_GPIO150>;
 			output-low;
-- 
2.47.1



