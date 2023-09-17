Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B68F6FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:28:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFED9C433C8;
	Sun, 17 Sep 2023 19:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694978934;
	bh=cxB7khqM1v8+lXQ80FFw43GpUjhAjgE1niTyNPcHQb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bb27iayx8C6ZPE6ZqEcGXZkP+ZWcxXPxEY1bwi6DN1k1fv6hM/kvxXODPIDWatC6Y
	 U4q9fxBTzdA5UoO6kMvLjlNIxmrDUL4yrtazylCpcc7s11mgQWCtJy70KsEz3CD+Ds
	 i3N1qDOzeTKD/0+wGrAmepib3VJ66TFmkcjZoLG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 141/406] ARM: dts: s5pv210: adjust node names to DT spec
Date: Sun, 17 Sep 2023 21:09:55 +0200
Message-ID: <20230917191104.882416951@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit b04544ac0d1f2a51e0f3234045343aa741d64e7b ]

The Devicetree specification expects device node names to have a generic
name, representing the class of a device.  Also the convention for node
names is to use hyphens, not underscores.

No functional changes.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20201027170947.132725-10-krzk@kernel.org
Stable-dep-of: 982655cb0e7f ("ARM: dts: samsung: s5pv210-smdkv210: correct ethernet reg addresses (split)")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/s5pv210-aquila.dts   | 12 ++++++------
 arch/arm/boot/dts/s5pv210-aries.dtsi   |  4 ++--
 arch/arm/boot/dts/s5pv210-goni.dts     | 14 +++++++-------
 arch/arm/boot/dts/s5pv210-smdkv210.dts | 20 ++++++++++----------
 4 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/arch/arm/boot/dts/s5pv210-aquila.dts b/arch/arm/boot/dts/s5pv210-aquila.dts
index 8e57e5a1f0c51..6423348034b68 100644
--- a/arch/arm/boot/dts/s5pv210-aquila.dts
+++ b/arch/arm/boot/dts/s5pv210-aquila.dts
@@ -277,37 +277,37 @@ &keypad {
 			<&keypad_col0>, <&keypad_col1>, <&keypad_col2>;
 	status = "okay";
 
-	key_1 {
+	key-1 {
 		keypad,row = <0>;
 		keypad,column = <1>;
 		linux,code = <KEY_CONNECT>;
 	};
 
-	key_2 {
+	key-2 {
 		keypad,row = <0>;
 		keypad,column = <2>;
 		linux,code = <KEY_BACK>;
 	};
 
-	key_3 {
+	key-3 {
 		keypad,row = <1>;
 		keypad,column = <1>;
 		linux,code = <KEY_CAMERA_FOCUS>;
 	};
 
-	key_4 {
+	key-4 {
 		keypad,row = <1>;
 		keypad,column = <2>;
 		linux,code = <KEY_VOLUMEUP>;
 	};
 
-	key_5 {
+	key-5 {
 		keypad,row = <2>;
 		keypad,column = <1>;
 		linux,code = <KEY_CAMERA>;
 	};
 
-	key_6 {
+	key-6 {
 		keypad,row = <2>;
 		keypad,column = <2>;
 		linux,code = <KEY_VOLUMEDOWN>;
diff --git a/arch/arm/boot/dts/s5pv210-aries.dtsi b/arch/arm/boot/dts/s5pv210-aries.dtsi
index 984bc8dc5e4bd..8f7dcd7af0bc9 100644
--- a/arch/arm/boot/dts/s5pv210-aries.dtsi
+++ b/arch/arm/boot/dts/s5pv210-aries.dtsi
@@ -54,7 +54,7 @@ pmic_ap_clk: clock-0 {
 		clock-frequency = <32768>;
 	};
 
-	bt_codec: bt_sco {
+	bt_codec: bt-sco {
 		compatible = "linux,bt-sco";
 		#sound-dai-cells = <0>;
 	};
@@ -113,7 +113,7 @@ i2c_sound: i2c-gpio-0 {
 		pinctrl-names = "default";
 		pinctrl-0 = <&sound_i2c_pins>;
 
-		wm8994: wm8994@1a {
+		wm8994: audio-codec@1a {
 			compatible = "wlf,wm8994";
 			reg = <0x1a>;
 
diff --git a/arch/arm/boot/dts/s5pv210-goni.dts b/arch/arm/boot/dts/s5pv210-goni.dts
index ad8d5d2fa32d7..5c1e12d39747b 100644
--- a/arch/arm/boot/dts/s5pv210-goni.dts
+++ b/arch/arm/boot/dts/s5pv210-goni.dts
@@ -259,37 +259,37 @@ &keypad {
 			<&keypad_col0>, <&keypad_col1>, <&keypad_col2>;
 	status = "okay";
 
-	key_1 {
+	key-1 {
 		keypad,row = <0>;
 		keypad,column = <1>;
 		linux,code = <KEY_CONNECT>;
 	};
 
-	key_2 {
+	key-2 {
 		keypad,row = <0>;
 		keypad,column = <2>;
 		linux,code = <KEY_BACK>;
 	};
 
-	key_3 {
+	key-3 {
 		keypad,row = <1>;
 		keypad,column = <1>;
 		linux,code = <KEY_CAMERA_FOCUS>;
 	};
 
-	key_4 {
+	key-4 {
 		keypad,row = <1>;
 		keypad,column = <2>;
 		linux,code = <KEY_VOLUMEUP>;
 	};
 
-	key_5 {
+	key-5 {
 		keypad,row = <2>;
 		keypad,column = <1>;
 		linux,code = <KEY_CAMERA>;
 	};
 
-	key_6 {
+	key-6 {
 		keypad,row = <2>;
 		keypad,column = <2>;
 		linux,code = <KEY_VOLUMEDOWN>;
@@ -353,7 +353,7 @@ &i2c2 {
 	samsung,i2c-slave-addr = <0x10>;
 	status = "okay";
 
-	tsp@4a {
+	touchscreen@4a {
 		compatible = "atmel,maxtouch";
 		reg = <0x4a>;
 		interrupt-parent = <&gpj0>;
diff --git a/arch/arm/boot/dts/s5pv210-smdkv210.dts b/arch/arm/boot/dts/s5pv210-smdkv210.dts
index 7459e41e8ef13..fbae768d65e27 100644
--- a/arch/arm/boot/dts/s5pv210-smdkv210.dts
+++ b/arch/arm/boot/dts/s5pv210-smdkv210.dts
@@ -76,61 +76,61 @@ &keypad {
 			<&keypad_col6>, <&keypad_col7>;
 	status = "okay";
 
-	key_1 {
+	key-1 {
 		keypad,row = <0>;
 		keypad,column = <3>;
 		linux,code = <KEY_1>;
 	};
 
-	key_2 {
+	key-2 {
 		keypad,row = <0>;
 		keypad,column = <4>;
 		linux,code = <KEY_2>;
 	};
 
-	key_3 {
+	key-3 {
 		keypad,row = <0>;
 		keypad,column = <5>;
 		linux,code = <KEY_3>;
 	};
 
-	key_4 {
+	key-4 {
 		keypad,row = <0>;
 		keypad,column = <6>;
 		linux,code = <KEY_4>;
 	};
 
-	key_5 {
+	key-5 {
 		keypad,row = <0
 		>;
 		keypad,column = <7>;
 		linux,code = <KEY_5>;
 	};
 
-	key_6 {
+	key-6 {
 		keypad,row = <1>;
 		keypad,column = <3>;
 		linux,code = <KEY_A>;
 	};
-	key_7 {
+	key-7 {
 		keypad,row = <1>;
 		keypad,column = <4>;
 		linux,code = <KEY_B>;
 	};
 
-	key_8 {
+	key-8 {
 		keypad,row = <1>;
 		keypad,column = <5>;
 		linux,code = <KEY_C>;
 	};
 
-	key_9 {
+	key-9 {
 		keypad,row = <1>;
 		keypad,column = <6>;
 		linux,code = <KEY_D>;
 	};
 
-	key_10 {
+	key-10 {
 		keypad,row = <1>;
 		keypad,column = <7>;
 		linux,code = <KEY_E>;
-- 
2.40.1



