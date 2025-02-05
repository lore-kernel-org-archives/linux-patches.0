Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BDDC21CA15
	for <patches@lists.linux.dev>; Wed,  5 Feb 2025 23:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738798227; cv=none; b=dJ28v5Sm2ayNs6g12SWBC7nkbzRGxf71Y5lnB69RbwjLSOncAlqLrxwIfGwYEnXjyQe7OEyfceSSYAMAVRla6N84vCuKMuYj19Kwzij/wS7qMHTew+4FqcsVQ3/awcaSRrJm10fkZ0b6xYbCwS74kQHiUcBS1jG/B1HfUzSboeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738798227; c=relaxed/simple;
	bh=alWwRRkEAEQ8GJRKCSpw4w/FKFS5o5HIG6C/NbnK8Lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rS8K1W/mHojKLdt+TNORo+za93ciWp0viswXSEWtN5ZWclZWZFHYwiQS+nU0m5MREsH4iMWI853JuTjrlThzwriUbHeplC1vJh5czkQJngmDnQtkXTnttpKh3MwQeA+a98vZOwBIF+WL+veg7TEc29flWZ9eRAVfiwNQZQ/5tUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=E3unbh1O; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="E3unbh1O"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2f9ba87f5d4so338540a91.3
        for <patches@lists.linux.dev>; Wed, 05 Feb 2025 15:30:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1738798224; x=1739403024; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hRfb0NHDK4M5keAtz3UsUZPWnRsUe7VuiZzz1jrti1s=;
        b=E3unbh1Orn8fTki+IDT/Wwg8xM1yL/7Bp2DkEl4uD36wCsLZTCAX9BtIJTHjBP1LGA
         EVsiIghg+BMtOOv/nHpKGaAYoAkkB1K383zhgIQnUnxOqJMrAMvLnoyOtJoRk6GBCooy
         QcYZlPz/zXzyw4BFNw8Pm0LD+Ac23omIrsUd0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738798224; x=1739403024;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hRfb0NHDK4M5keAtz3UsUZPWnRsUe7VuiZzz1jrti1s=;
        b=c1PcAtQvTb1OWKdOQnorw7+BwD5xIBD/ngee5dmfwtqRWFfCkCakKoD4r0KlCm9gvE
         dDoosu/a5pHsSNfkjElWdbObJLeMirloiMu1xi6leBDXFG6+b6x4rnP7OxT+AspMiTiQ
         hD//Gx6Hho0EL5Etx+QWbZLukkVlUFtqoknsh52y3vPk2hFaWukF72O1PYZ5Sc+Nxkh/
         Y1wLExXw/7QMlzl9ydsjBva7YSqv3/8bkhhO74aEPpUn5ejHa9rsU3UKB5oIzpqil2Hs
         F5dC8kZM7Xwkcyc8CSo+BXKeFhWmu5n+/uOh5bqqU7zFcVCm6dvAFb/zezrpcUECcGJs
         F5AA==
X-Forwarded-Encrypted: i=1; AJvYcCUj6VsdsKP855KFuIHTPPP/pEAtG1b2cHrzBfCjs1accp9IjRdWz22+YQUOuIY9rN+L82IL3lW7@lists.linux.dev
X-Gm-Message-State: AOJu0Yw9DVSP09eqfeIeN6ybx4pteApYH0s+Kj1fklOsf8143tk1nNx1
	psXhJV7S0tKoNuBqHQ2acwmaQaC/htmT8V+MNy6xJPuGfZ+eTydco6VXpZ6zL+qZ1qLzn3tBCHo
	=
X-Gm-Gg: ASbGncuCFKRrigwdGfjh3B3dxljbl9K76xFwdU/vclX+OkVH+jcoza5dWvpEjdu8cvq
	hDVLjhJbf9VGAygy5TAzRb2hKRHmpe2AWkKbKbfHWe7RDUwLZ1CZwksdrr8ItWGAYjlq+xER4hl
	BKCw+isNTqlNeJLXFj6d3a6OLRn9JP/FVQDSmTT4eehfgxQO+REvji9FrBUU4LX/cTlv2C2kSeJ
	4763C06yBkr3uR8JUqMst0slx+RSvb8JsSP4OowxBIbaTyX1ph9VlxJqevFTRsZHymAI45fGtoZ
	XpSlRrV7MijiQBZaNMuz2DN8cl8dJ6p5rbh6joTP6tQbca6XenFpkmw=
X-Google-Smtp-Source: AGHT+IHGo+5oR7YFLEOa9NhDE36gOmN6UEPyPplHlntupTRoMaad1fdZi0pC6yuQrlg0DK93euioTg==
X-Received: by 2002:a05:6a00:3e13:b0:725:322a:922c with SMTP id d2e1a72fcca58-73035103a92mr9704003b3a.3.1738798223695;
        Wed, 05 Feb 2025 15:30:23 -0800 (PST)
Received: from localhost (129.135.125.34.bc.googleusercontent.com. [34.125.135.129])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-73048e1e7bcsm4725b3a.158.2025.02.05.15.30.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2025 15:30:23 -0800 (PST)
From: Stephen Boyd <swboyd@chromium.org>
To: Konrad Dybcio <konradybcio@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	patches@lists.linux.dev,
	cros-qcom-dts-watchers@chromium.org,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	devicetree@vger.kernel.org,
	Pin-yen Lin <treapking@chromium.org>
Subject: [PATCH v2 2/2] arm64: dts: qcom: sc7180-trogdor: Wire up USB to usb-c-connectors
Date: Wed,  5 Feb 2025 15:30:15 -0800
Message-ID: <20250205233016.1600517-3-swboyd@chromium.org>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
In-Reply-To: <20250205233016.1600517-1-swboyd@chromium.org>
References: <20250205233016.1600517-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fully describe the USB type-c on sc7180 Trogdor devices. Most Trogdor
devices have two USB type-c ports (i.e. usb-c-connector nodes), but
Quackingstick only has one. Also, clamshell devices such as Lazor have a
USB webcam connected to the USB hub, while detachable devices such as
Wormdingler don't have a webcam, or a USB type-a connector. Instead they
have the pogo pins for the detachable keyboard.

Fully describing the topology like this will let us expose information
about what devices are connected to which physical USB connector (type-A
or type-C).

Cc: <cros-qcom-dts-watchers@chromium.org>
Cc: Bjorn Andersson <andersson@kernel.org>
Cc: Konrad Dybcio <konradybcio@kernel.org>
Cc: Rob Herring <robh@kernel.org>
Cc: Krzysztof Kozlowski <krzk+dt@kernel.org>
Cc: Conor Dooley <conor+dt@kernel.org>
Cc: <linux-arm-msm@vger.kernel.org>
Cc: <devicetree@vger.kernel.org>
Cc: Pin-yen Lin <treapking@chromium.org>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
---
 .../dts/qcom/sc7180-trogdor-clamshell.dtsi    |  21 ++++
 .../boot/dts/qcom/sc7180-trogdor-coachz.dtsi  |  47 ++++++++
 .../dts/qcom/sc7180-trogdor-detachable.dtsi   |  15 +++
 .../dts/qcom/sc7180-trogdor-homestar.dtsi     |  47 ++++++++
 .../dts/qcom/sc7180-trogdor-kingoftown.dts    |  55 +++++++++
 .../boot/dts/qcom/sc7180-trogdor-lazor.dtsi   |  55 +++++++++
 .../boot/dts/qcom/sc7180-trogdor-pazquel.dtsi |  55 +++++++++
 .../boot/dts/qcom/sc7180-trogdor-pompom.dtsi  |  44 +++++++
 .../qcom/sc7180-trogdor-quackingstick.dtsi    |  31 +++++
 .../arm64/boot/dts/qcom/sc7180-trogdor-r1.dts |  56 ++++++++-
 .../dts/qcom/sc7180-trogdor-wormdingler.dtsi  |  47 ++++++++
 arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi  | 109 ++++++++++++++++++
 12 files changed, 580 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-clamshell.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-clamshell.dtsi
index d91533b80e76..4e4f0b239f3c 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-clamshell.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-clamshell.dtsi
@@ -7,3 +7,24 @@
 
 /* This file must be included after sc7180-trogdor.dtsi to modify cros_ec */
 #include <arm/cros-ec-keyboard.dtsi>
+
+/ {
+	usb-a-connector {
+		compatible = "usb-a-connector";
+
+		port {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			usb_a0_hs: endpoint@0 {
+				reg = <0>;
+				/* Endpoint filled in by board */
+			};
+
+			usb_a0_ss: endpoint@1 {
+				reg = <1>;
+				/* Endpoint filled in by board */
+			};
+		};
+	};
+};
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi
index 25b17b0425f2..548d6c1ee050 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-coachz.dtsi
@@ -134,6 +134,17 @@ skin-temp-thermistor@1 {
 	};
 };
 
+&pogo_pins {
+	keyboard@4 {
+		compatible = "usb18d1,504c";
+		reg = <4>;
+	};
+};
+
+&pogo_pins_in {
+	remote-endpoint = <&usb_hub_dfp4_hs>;
+};
+
 &pp1800_uf_cam {
 	status = "okay";
 };
@@ -175,6 +186,42 @@ &sound_multimedia0_codec {
 	sound-dai = <&adau7002>;
 };
 
+&usb_c0_hs {
+	remote-endpoint = <&usb_hub_dfp1_hs>;
+};
+
+&usb_c0_ss {
+	remote-endpoint = <&usb_hub_dfp1_ss>;
+};
+
+&usb_c1_hs {
+	remote-endpoint = <&usb_hub_dfp2_hs>;
+};
+
+&usb_c1_ss {
+	remote-endpoint = <&usb_hub_dfp2_ss>;
+};
+
+&usb_hub_dfp1_hs {
+	remote-endpoint = <&usb_c0_hs>;
+};
+
+&usb_hub_dfp1_ss {
+	remote-endpoint = <&usb_c0_ss>;
+};
+
+&usb_hub_dfp2_hs {
+	remote-endpoint = <&usb_c1_hs>;
+};
+
+&usb_hub_dfp2_ss {
+	remote-endpoint = <&usb_c1_ss>;
+};
+
+&usb_hub_dfp4_hs {
+	remote-endpoint = <&pogo_pins_in>;
+};
+
 /* PINCTRL - modifications to sc7180-trogdor.dtsi */
 
 &en_pp3300_dx_edp {
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-detachable.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-detachable.dtsi
index 7c5d8a57ef7f..a863295356e9 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-detachable.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-detachable.dtsi
@@ -6,6 +6,21 @@
  */
 
 /* This file must be included after sc7180-trogdor.dtsi to modify cros_ec */
+
+/ {
+	pogo_pins: pogo-pin-connector {
+		compatible = "google,pogo-pin-connector";
+		#address-cells = <1>;
+		#size-cells = <0>;
+		/* Detachable keyboard populated for each board */
+		port {
+			pogo_pins_in: endpoint {
+				/* Endpoint filled in by board */
+			};
+		};
+	};
+};
+
 &cros_ec {
 	keyboard-controller {
 		compatible = "google,cros-ec-keyb-switches";
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi
index f57976906d63..09c4a30d96ef 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-homestar.dtsi
@@ -159,6 +159,17 @@ skin-temp-thermistor@1 {
 	};
 };
 
+&pogo_pins {
+	keyboard@3 {
+		compatible = "usb18d1,5052";
+		reg = <3>;
+	};
+};
+
+&pogo_pins_in {
+	remote-endpoint = <&usb_hub_dfp3_hs>;
+};
+
 &pp1800_uf_cam {
 	status = "okay";
 };
@@ -187,6 +198,42 @@ &sound_multimedia1_codec {
 	sound-dai = <&max98360a>, <&max98360a_1>, <&max98360a_2>, <&max98360a_3> ;
 };
 
+&usb_c0_hs {
+	remote-endpoint = <&usb_hub_dfp2_hs>;
+};
+
+&usb_c0_ss {
+	remote-endpoint = <&usb_hub_dfp2_ss>;
+};
+
+&usb_c1_hs {
+	remote-endpoint = <&usb_hub_dfp4_hs>;
+};
+
+&usb_c1_ss {
+	remote-endpoint = <&usb_hub_dfp4_ss>;
+};
+
+&usb_hub_dfp2_hs {
+	remote-endpoint = <&usb_c0_hs>;
+};
+
+&usb_hub_dfp2_ss {
+	remote-endpoint = <&usb_c0_ss>;
+};
+
+&usb_hub_dfp3_hs {
+	remote-endpoint = <&pogo_pins_in>;
+};
+
+&usb_hub_dfp4_hs {
+	remote-endpoint = <&usb_c1_hs>;
+};
+
+&usb_hub_dfp4_ss {
+	remote-endpoint = <&usb_c1_ss>;
+};
+
 &wifi {
 	qcom,ath10k-calibration-variant = "GO_HOMESTAR";
 };
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-kingoftown.dts b/arch/arm64/boot/dts/qcom/sc7180-trogdor-kingoftown.dts
index 655bea928e52..d4ff26fba3be 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-kingoftown.dts
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-kingoftown.dts
@@ -78,6 +78,61 @@ &pp3300_dx_edp {
 	gpio = <&tlmm 67 GPIO_ACTIVE_HIGH>;
 };
 
+&usb_a0_hs {
+	remote-endpoint = <&usb_hub_dfp3_hs>;
+};
+
+&usb_a0_ss {
+	remote-endpoint = <&usb_hub_dfp3_ss>;
+};
+
+&usb_c0_hs {
+	remote-endpoint = <&usb_hub_dfp1_hs>;
+};
+
+&usb_c0_ss {
+	remote-endpoint = <&usb_hub_dfp1_ss>;
+};
+
+&usb_c1_hs {
+	remote-endpoint = <&usb_hub_dfp2_hs>;
+};
+
+&usb_c1_ss {
+	remote-endpoint = <&usb_hub_dfp2_ss>;
+};
+
+&usb_hub_2_x {
+	camera@4 {
+		compatible = "usb4f2,b75a";
+		reg = <4>;
+	};
+};
+
+&usb_hub_dfp1_hs {
+	remote-endpoint = <&usb_c0_hs>;
+};
+
+&usb_hub_dfp1_ss {
+	remote-endpoint = <&usb_c0_ss>;
+};
+
+&usb_hub_dfp2_hs {
+	remote-endpoint = <&usb_c1_hs>;
+};
+
+&usb_hub_dfp2_ss {
+	remote-endpoint = <&usb_c1_ss>;
+};
+
+&usb_hub_dfp3_hs {
+	remote-endpoint = <&usb_a0_hs>;
+};
+
+&usb_hub_dfp3_ss {
+	remote-endpoint = <&usb_a0_ss>;
+};
+
 &wifi {
 	qcom,ath10k-calibration-variant = "GO_KINGOFTOWN";
 };
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi
index c3fd6760de7a..7b545ae5791b 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-lazor.dtsi
@@ -68,6 +68,61 @@ &trackpad {
 	interrupts = <58 IRQ_TYPE_EDGE_FALLING>;
 };
 
+&usb_a0_hs {
+	remote-endpoint = <&usb_hub_dfp3_hs>;
+};
+
+&usb_a0_ss {
+	remote-endpoint = <&usb_hub_dfp3_ss>;
+};
+
+&usb_c0_hs {
+	remote-endpoint = <&usb_hub_dfp2_hs>;
+};
+
+&usb_c0_ss {
+	remote-endpoint = <&usb_hub_dfp2_ss>;
+};
+
+&usb_c1_hs {
+	remote-endpoint = <&usb_hub_dfp4_hs>;
+};
+
+&usb_c1_ss {
+	remote-endpoint = <&usb_hub_dfp4_ss>;
+};
+
+&usb_hub_2_x {
+	camera@1 {
+		compatible = "usb408,a092";
+		reg = <1>;
+	};
+};
+
+&usb_hub_dfp2_hs {
+	remote-endpoint = <&usb_c0_hs>;
+};
+
+&usb_hub_dfp2_ss {
+	remote-endpoint = <&usb_c0_ss>;
+};
+
+&usb_hub_dfp3_hs {
+	remote-endpoint = <&usb_a0_hs>;
+};
+
+&usb_hub_dfp3_ss {
+	remote-endpoint = <&usb_a0_ss>;
+};
+
+&usb_hub_dfp4_hs {
+	remote-endpoint = <&usb_c1_hs>;
+};
+
+&usb_hub_dfp4_ss {
+	remote-endpoint = <&usb_c1_ss>;
+};
+
 &wifi {
 	qcom,ath10k-calibration-variant = "GO_LAZOR";
 };
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-pazquel.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-pazquel.dtsi
index cc2c5610a279..9523843f06ab 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-pazquel.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-pazquel.dtsi
@@ -82,6 +82,61 @@ &pp3300_dx_edp {
 	gpio = <&tlmm 67 GPIO_ACTIVE_HIGH>;
 };
 
+&usb_a0_hs {
+	remote-endpoint = <&usb_hub_dfp3_hs>;
+};
+
+&usb_a0_ss {
+	remote-endpoint = <&usb_hub_dfp3_ss>;
+};
+
+&usb_c0_hs {
+	remote-endpoint = <&usb_hub_dfp1_hs>;
+};
+
+&usb_c0_ss {
+	remote-endpoint = <&usb_hub_dfp1_ss>;
+};
+
+&usb_c1_hs {
+	remote-endpoint = <&usb_hub_dfp2_hs>;
+};
+
+&usb_c1_ss {
+	remote-endpoint = <&usb_hub_dfp2_ss>;
+};
+
+&usb_hub_2_x {
+	camera@4 {
+		compatible = "usb5c8,b03";
+		reg = <4>;
+	};
+};
+
+&usb_hub_dfp1_hs {
+	remote-endpoint = <&usb_c0_hs>;
+};
+
+&usb_hub_dfp1_ss {
+	remote-endpoint = <&usb_c0_ss>;
+};
+
+&usb_hub_dfp2_hs {
+	remote-endpoint = <&usb_c1_hs>;
+};
+
+&usb_hub_dfp2_ss {
+	remote-endpoint = <&usb_c1_ss>;
+};
+
+&usb_hub_dfp3_hs {
+	remote-endpoint = <&usb_a0_hs>;
+};
+
+&usb_hub_dfp3_ss {
+	remote-endpoint = <&usb_a0_ss>;
+};
+
 /* PINCTRL - modifications to sc7180-trogdor.dtsi */
 
 &en_pp3300_dx_edp {
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-pompom.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-pompom.dtsi
index f7300ffbb451..4cc1a155d999 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-pompom.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-pompom.dtsi
@@ -176,10 +176,54 @@ &sound {
 	dmic-gpios = <&tlmm 86 GPIO_ACTIVE_HIGH>;
 };
 
+&usb_a0_hs {
+	remote-endpoint = <&usb_hub_dfp4_hs>;
+};
+
+&usb_a0_ss {
+	remote-endpoint = <&usb_hub_dfp4_ss>;
+};
+
+&usb_c0_hs {
+	remote-endpoint = <&usb_hub_dfp3_hs>;
+};
+
+&usb_c0_ss {
+	remote-endpoint = <&usb_hub_dfp3_ss>;
+};
+
 &usb_c1 {
 	status = "disabled";
 };
 
+&usb_hub_2_x {
+	camera@1 {
+		compatible = "usb4f2,b718";
+		reg = <1>;
+	};
+
+	camera@2 {
+		compatible = "usb13d3,56e9";
+		reg = <2>;
+	};
+};
+
+&usb_hub_dfp3_hs {
+	remote-endpoint = <&usb_c0_hs>;
+};
+
+&usb_hub_dfp3_ss {
+	remote-endpoint = <&usb_c0_ss>;
+};
+
+&usb_hub_dfp4_hs {
+	remote-endpoint = <&usb_a0_hs>;
+};
+
+&usb_hub_dfp4_ss {
+	remote-endpoint = <&usb_a0_ss>;
+};
+
 &wifi {
 	qcom,ath10k-calibration-variant = "GO_POMPOM";
 };
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-quackingstick.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-quackingstick.dtsi
index ff8996b4de4e..174efd3abfa5 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-quackingstick.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-quackingstick.dtsi
@@ -105,6 +105,17 @@ &sdhc_2 {
 	status = "okay";
 };
 
+&pogo_pins {
+	keyboard@1 {
+		compatible = "usb18d1,505b";
+		reg = <1>;
+	};
+};
+
+&pogo_pins_in {
+	remote-endpoint = <&usb_hub_dfp1_hs>;
+};
+
 &pp1800_uf_cam {
 	status = "okay";
 };
@@ -129,11 +140,31 @@ pp3300_disp_on: &pp3300_dx_edp {
 	gpio = <&tlmm 67 GPIO_ACTIVE_HIGH>;
 };
 
+&usb_c0_hs {
+	remote-endpoint = <&usb_hub_dfp2_hs>;
+};
+
+&usb_c0_ss {
+	remote-endpoint = <&usb_hub_dfp2_ss>;
+};
+
 /* This board only has 1 USB Type-C port. */
 &usb_c1 {
 	status = "disabled";
 };
 
+&usb_hub_dfp2_hs {
+	remote-endpoint = <&usb_c0_hs>;
+};
+
+&usb_hub_dfp2_ss {
+	remote-endpoint = <&usb_c0_ss>;
+};
+
+&usb_hub_dfp1_hs {
+	remote-endpoint = <&pogo_pins_in>;
+};
+
 /* PINCTRL - modifications to sc7180-trogdor.dtsi */
 
 /*
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-r1.dts b/arch/arm64/boot/dts/qcom/sc7180-trogdor-r1.dts
index d393a2712ce6..dddf92c04c4d 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-r1.dts
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-r1.dts
@@ -52,12 +52,64 @@ &trackpad {
 	interrupts = <58 IRQ_TYPE_EDGE_FALLING>;
 };
 
+&usb_a0_hs {
+	remote-endpoint = <&usb_hub_dfp3_hs>;
+};
+
+&usb_a0_ss {
+	remote-endpoint = <&usb_hub_dfp3_ss>;
+};
+
+&usb_c0_hs {
+	remote-endpoint = <&usb_hub_dfp2_hs>;
+};
+
+&usb_c0_ss {
+	remote-endpoint = <&usb_hub_dfp2_ss>;
+};
+
+&usb_c1_hs {
+	remote-endpoint = <&usb_hub_dfp4_hs>;
+};
+
+&usb_c1_ss {
+	remote-endpoint = <&usb_hub_dfp4_ss>;
+};
+
 &usb_hub_2_x {
-	 vdd-supply = <&pp3300_l7c>;
+	vdd-supply = <&pp3300_l7c>;
+	camera@1 {
+		compatible = "usb4f2,b567";
+		reg = <1>;
+	};
 };
 
 &usb_hub_3_x {
-	 vdd-supply = <&pp3300_l7c>;
+	vdd-supply = <&pp3300_l7c>;
+};
+
+&usb_hub_dfp2_hs {
+	remote-endpoint = <&usb_c0_hs>;
+};
+
+&usb_hub_dfp2_ss {
+	remote-endpoint = <&usb_c0_ss>;
+};
+
+&usb_hub_dfp3_hs {
+	remote-endpoint = <&usb_a0_hs>;
+};
+
+&usb_hub_dfp3_ss {
+	remote-endpoint = <&usb_a0_ss>;
+};
+
+&usb_hub_dfp4_hs {
+	remote-endpoint = <&usb_c1_hs>;
+};
+
+&usb_hub_dfp4_ss {
+	remote-endpoint = <&usb_c1_ss>;
 };
 
 /* PINCTRL - modifications to sc7180-trogdor.dtsi */
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor-wormdingler.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor-wormdingler.dtsi
index d4925be3b1fc..59cdf8eea647 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor-wormdingler.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor-wormdingler.dtsi
@@ -179,6 +179,17 @@ skin-temp-thermistor@1 {
 	};
 };
 
+&pogo_pins {
+	keyboard@3 {
+		compatible = "usb18d1,5057";
+		reg = <3>;
+	};
+};
+
+&pogo_pins_in {
+	remote-endpoint = <&usb_hub_dfp3_hs>;
+};
+
 &pp1800_uf_cam {
 	status = "okay";
 };
@@ -195,6 +206,42 @@ &pp2800_wf_cam {
 	status = "okay";
 };
 
+&usb_c0_hs {
+	remote-endpoint = <&usb_hub_dfp2_hs>;
+};
+
+&usb_c0_ss {
+	remote-endpoint = <&usb_hub_dfp2_ss>;
+};
+
+&usb_c1_hs {
+	remote-endpoint = <&usb_hub_dfp4_hs>;
+};
+
+&usb_c1_ss {
+	remote-endpoint = <&usb_hub_dfp3_ss>;
+};
+
+&usb_hub_dfp2_hs {
+	remote-endpoint = <&usb_c0_hs>;
+};
+
+&usb_hub_dfp2_ss {
+	remote-endpoint = <&usb_c0_ss>;
+};
+
+&usb_hub_dfp4_hs {
+	remote-endpoint = <&usb_c1_hs>;
+};
+
+&usb_hub_dfp3_ss {
+	remote-endpoint = <&usb_c1_ss>;
+};
+
+&usb_hub_dfp3_hs {
+	remote-endpoint = <&pogo_pins_in>;
+};
+
 &wifi {
 	qcom,ath10k-calibration-variant = "GO_WORMDINGLER";
 };
diff --git a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
index 74ab321d3333..af866cdd4fef 100644
--- a/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi
@@ -673,6 +673,25 @@ usb_c0: connector@0 {
 				power-role = "dual";
 				data-role = "host";
 				try-power-role = "source";
+
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
+
+					port@0 {
+						reg = <0>;
+						usb_c0_hs: endpoint {
+							/* Endpoint filled in by board */
+						};
+					};
+
+					port@1 {
+						reg = <1>;
+						usb_c0_ss: endpoint {
+							/* Endpoint filled in by board */
+						};
+					};
+				};
 			};
 
 			usb_c1: connector@1 {
@@ -682,6 +701,25 @@ usb_c1: connector@1 {
 				power-role = "dual";
 				data-role = "host";
 				try-power-role = "source";
+
+				ports {
+					#address-cells = <1>;
+					#size-cells = <0>;
+
+					port@0 {
+						reg = <0>;
+						usb_c1_hs: endpoint {
+							/* Endpoint filled in by board */
+						};
+					};
+
+					port@1 {
+						reg = <1>;
+						usb_c1_ss: endpoint {
+							/* Endpoint filled in by board */
+						};
+					};
+				};
 			};
 		};
 	};
@@ -966,6 +1004,41 @@ usb_hub_2_x: hub@1 {
 		reg = <1>;
 		vdd-supply = <&pp3300_hub>;
 		peer-hub = <&usb_hub_3_x>;
+
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		usb_hub_2_x_ports: ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			port@1 {
+				reg = <1>;
+				usb_hub_dfp1_hs: endpoint {
+					/* Endpoint filled in by board */
+				};
+			};
+			port@2 {
+				reg = <2>;
+				usb_hub_dfp2_hs: endpoint {
+					/* Endpoint filled in by board */
+				};
+			};
+
+			port@3 {
+				reg = <3>;
+				usb_hub_dfp3_hs: endpoint {
+					/* Endpoint filled in by board */
+				};
+			};
+
+			port@4 {
+				reg = <4>;
+				usb_hub_dfp4_hs: endpoint {
+					/* Endpoint filled in by board */
+				};
+			};
+		};
 	};
 
 	/* 3.x hub on port 2 */
@@ -974,6 +1047,42 @@ usb_hub_3_x: hub@2 {
 		reg = <2>;
 		vdd-supply = <&pp3300_hub>;
 		peer-hub = <&usb_hub_2_x>;
+
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		usb_hub_3_x_ports: ports {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			port@1 {
+				reg = <1>;
+				usb_hub_dfp1_ss: endpoint {
+					/* Endpoint filled in by board */
+				};
+			};
+
+			port@2 {
+				reg = <2>;
+				usb_hub_dfp2_ss: endpoint {
+					/* Endpoint filled in by board */
+				};
+			};
+
+			port@3 {
+				reg = <3>;
+				usb_hub_dfp3_ss: endpoint {
+					/* Endpoint filled in by board */
+				};
+			};
+
+			port@4 {
+				reg = <4>;
+				usb_hub_dfp4_ss: endpoint {
+					/* Endpoint filled in by board */
+				};
+			};
+		};
 	};
 };
 
-- 
https://chromeos.dev

