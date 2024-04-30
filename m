Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688AF12C462;
	Tue, 30 Apr 2024 11:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475171; cv=none; b=HJdPWM9krAbfQPC1flZ3S8kbmDc/2Rn2ZKZjI7C4UEY8o1nIhoOguwMEttOmTtbdvhAdl39/fVaJ2+iE634fWHFpWH0eo7bsqPBmy1ud3FdkiyLg5GNBnC1C1y6bXhso1BLhiO/tuAofBip/MH7boy4rg+PU45dN0x3TZF00e+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475171; c=relaxed/simple;
	bh=7w6ONEjZQTbAqWSLmluxYTirRdlfjaZDoKJScZO+oe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E8Qg1x46BOUpwOoJbp/iuoI8NDNYnL8x0beINKJEdvO52eXVsrmjPZKjVcIZ/0dbGG5gLIFVqbGVr70ghHR5rt8vg2Q6jPXtL7AEVoWW+znvkqKIBKjrMgGmaGVuR1F0s00G1nL0O3B/BSUPfBCjngawZtma4kdfpWD3s680zhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wwY4DMII; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wwY4DMII"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E55F1C2BBFC;
	Tue, 30 Apr 2024 11:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475171;
	bh=7w6ONEjZQTbAqWSLmluxYTirRdlfjaZDoKJScZO+oe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wwY4DMIIUeNddMYa78HsqVP0qFmkVmtdwaarn2GdjerJFUbG3Zp4gCs7vurEGC91V
	 u/+VdO287PIozk9XBOp01dqUpiara1yLu1898sWuacksy+bP5tCfz5SrZPW0qxkQc8
	 hYA5PmCcSrNTQiAAZy4obJqByRS1I82OrjdSeLgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Alexandre Mergnat <amergnat@baylibre.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 016/186] arm64: dts: mediatek: cherry: Add platform thermal configuration
Date: Tue, 30 Apr 2024 12:37:48 +0200
Message-ID: <20240430103058.492161590@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 729f30eac8bce6783f889cf8390ea869d03407e6 ]

This platform has three auxiliary NTC thermistors, connected to the
SoC's ADC pins. Enable the auxadc in order to be able to read the
ADC values, add a generic-adc-thermal LUT for each and finally assign
them to the SoC's thermal zones.

Tested-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Alexandre Mergnat <amergnat@baylibre.com>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20230424112523.1436926-2-angelogioacchino.delregno@collabora.com
Stable-dep-of: 17b33dd9e4a3 ("arm64: dts: mediatek: cherry: Describe CPU supplies")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/mediatek/mt8195-cherry.dtsi      | 105 ++++++++++++++++++
 1 file changed, 105 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi b/arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi
index 3f508e5c18434..d721ddb230747 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi
@@ -114,6 +114,77 @@
 		regulator-boot-on;
 	};
 
+	/* Murata NCP03WF104F05RL */
+	tboard_thermistor1: thermal-sensor-t1 {
+		compatible = "generic-adc-thermal";
+		#thermal-sensor-cells = <0>;
+		io-channels = <&auxadc 0>;
+		io-channel-names = "sensor-channel";
+		temperature-lookup-table = <	(-10000) 1553
+						(-5000) 1485
+						0 1406
+						5000 1317
+						10000 1219
+						15000 1115
+						20000 1007
+						25000 900
+						30000 796
+						35000 697
+						40000 605
+						45000 523
+						50000 449
+						55000 384
+						60000 327
+						65000 279
+						70000 237
+						75000 202
+						80000 172
+						85000 147
+						90000 125
+						95000 107
+						100000 92
+						105000 79
+						110000 68
+						115000 59
+						120000 51
+						125000 44>;
+	};
+
+	tboard_thermistor2: thermal-sensor-t2 {
+		compatible = "generic-adc-thermal";
+		#thermal-sensor-cells = <0>;
+		io-channels = <&auxadc 1>;
+		io-channel-names = "sensor-channel";
+		temperature-lookup-table = <	(-10000) 1553
+						(-5000) 1485
+						0 1406
+						5000 1317
+						10000 1219
+						15000 1115
+						20000 1007
+						25000 900
+						30000 796
+						35000 697
+						40000 605
+						45000 523
+						50000 449
+						55000 384
+						60000 327
+						65000 279
+						70000 237
+						75000 202
+						80000 172
+						85000 147
+						90000 125
+						95000 107
+						100000 92
+						105000 79
+						110000 68
+						115000 59
+						120000 51
+						125000 44>;
+	};
+
 	usb_vbus: regulator-5v0-usb-vbus {
 		compatible = "regulator-fixed";
 		regulator-name = "usb-vbus";
@@ -176,6 +247,10 @@
 	memory-region = <&afe_mem>;
 };
 
+&auxadc {
+	status = "okay";
+};
+
 &dp_intf0 {
 	status = "okay";
 
@@ -1127,6 +1202,36 @@
 	};
 };
 
+&thermal_zones {
+	soc-area-thermal {
+		polling-delay = <1000>;
+		polling-delay-passive = <250>;
+		thermal-sensors = <&tboard_thermistor1>;
+
+		trips {
+			trip-crit {
+				temperature = <84000>;
+				hysteresis = <1000>;
+				type = "critical";
+			};
+		};
+	};
+
+	pmic-area-thermal {
+		polling-delay = <1000>;
+		polling-delay-passive = <0>;
+		thermal-sensors = <&tboard_thermistor2>;
+
+		trips {
+			trip-crit {
+				temperature = <84000>;
+				hysteresis = <1000>;
+				type = "critical";
+			};
+		};
+	};
+};
+
 &u3phy0 {
 	status = "okay";
 };
-- 
2.43.0



