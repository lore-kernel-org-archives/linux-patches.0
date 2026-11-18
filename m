Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025278;
	b=mb7WjUpd18V+D/VkbYDBXBRBvS+lf8rgS/4hyaNrE94ITw+IGM8HQY2TkBcbGbMzjzt+
	 Vji8hMU7mQi1FExjpzYBhIekjpijOzoq+SO4zpL6/OR8Y80TyUCTCdKjDz2Lfn8VOwU/b
	 BhWXjkguXlTbYCugt7dVxjihMfcD3+4bmlBZ5QLvV6yLtJw8rMPc7WuUNlZsXtQZvGKxq
	 CeB+FZgFNZCRB8NR7kfQ7qyPND6PRo+iNyvHB2ghZdvXjsnE3TMFpVob0PWLkuVXkESq9
	 N2Tei+/UhKd8ew1r7pWGuV+WJRCB0sYeZ3eVbW3j4B8DUUn7TCvxPKcZCaqGmYkRbsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025278;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NVPOXqrUyDvUu5oXhQdYWVX1aSHA0aapnL8guLKDuB4=;
	b=k4Xg4za9pDSdRKyPP1XY0LcqyhBiJuBoGGSTAKHya0kqs/aYzvpKLveVsHdA1GdRN9/d
	 /jnxGxTliJfI/qJrbbLHyLAVHETF9cIUkXz99f2qa0Fgg3NjPcsK06UAl9O3oNw0a8Ihq
	 JBoHgMaoh5e5jzKePiD66jLSQ10wpwCis7qJgZ/0GqWJ1bFCZBBQ9Ts96gJSQWu0QKgqs
	 eX30jgG6t39gn1q4NurkQOHlcOB9E2+PbPMkDItgwjKgLtVcUeuGxOCgLBWd8fgbvW3GN
	 cbBFf4TlR+1dNSMyclcy0+1AuNkhiHA8VtQeSaoMSuho2EyxI8mDLcnqd+puPNnZnug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="GZUi/ak+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE823606A33A;
	Wed, 18 Nov 2026 18:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GZUi/ak+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D64A1F000C7;
	Wed, 18 Nov 2026 18:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025278;
	bh=NVPOXqrUyDvUu5oXhQdYWVX1aSHA0aapnL8guLKDuB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GZUi/ak+X8D5JaBYWgR7ebU1NoVH/3Fjr18QJorOvFKKP63F6HQPh5lYR8DT11uo5
	 ewf3emkBvl8ZrJ+n6ODCSG13abCzCFrADGpjr7Uynm2kyQ+6ma+7H4fcwTDgpQ8rwf
	 Dcp1Xsjt8kLhaZV2ywPfXg3ZgY+w5hzeSMODC9/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hal Feng <hal.feng@starfivetech.com>,
	Maud Spierings <maud_spierings@hotmail.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0981/2151] riscv: dts: starfive: Correct pwm nodes
Date: Wed, 18 Nov 2026 15:45:16 +0100
Message-ID: <20261118150158.218406758@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hal Feng <hal.feng@starfivetech.com>

[ Upstream commit 2186ec5f59c23fcf0bf896ca0543b6a1135d7bb5 ]

Each of the StarFive JH7100/JH7110 SoCs has 8 OpenCores PTC IP
cores. One OpenCores PTC IP core can output one PWM channel.
Change the register size to 0x10, since an OpenCores PTC IP
has only 4 32-bit registers: CNTR, HRC, LRC and CTRL.

Fixes: 8d01f741a046 ("riscv: dts: starfive: jh7110: Add PWM node and pins configuration")
Fixes: 5e598b99fedf ("riscv: dts: starfive: jh7100: Add PWM node and pins configuration")
Signed-off-by: Hal Feng <hal.feng@starfivetech.com>
Tested-by: Maud Spierings <maud_spierings@hotmail.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/starfive/jh7100-common.dtsi      | 28 ++++++--
 arch/riscv/boot/dts/starfive/jh7100.dtsi      | 67 ++++++++++++++++++-
 .../boot/dts/starfive/jh7110-common.dtsi      | 27 ++++++--
 .../boot/dts/starfive/jh7110-milkv-mars.dts   |  6 +-
 .../dts/starfive/jh7110-milkv-marscm.dtsi     |  6 +-
 .../dts/starfive/jh7110-pine64-star64.dts     |  6 +-
 .../jh7110-starfive-visionfive-2-lite.dtsi    |  6 +-
 .../jh7110-starfive-visionfive-2.dtsi         |  6 +-
 arch/riscv/boot/dts/starfive/jh7110.dtsi      | 67 ++++++++++++++++++-
 9 files changed, 198 insertions(+), 21 deletions(-)

diff --git a/arch/riscv/boot/dts/starfive/jh7100-common.dtsi b/arch/riscv/boot/dts/starfive/jh7100-common.dtsi
index ae1a6aeb0aeaa..85106545090ea 100644
--- a/arch/riscv/boot/dts/starfive/jh7100-common.dtsi
+++ b/arch/riscv/boot/dts/starfive/jh7100-common.dtsi
@@ -199,13 +199,23 @@ GPO_I2C2_PAD_SDA_OEN,
 		};
 	};
 
-	pwm_pins: pwm-0 {
-		pwm-pins {
+	pwm0_pins: pwm0-0 {
+		pwm0-pins {
 			pinmux = <GPIOMUX(7,
 				  GPO_PWM_PAD_OUT_BIT0,
 				  GPO_PWM_PAD_OE_N_BIT0,
-				  GPI_NONE)>,
-				 <GPIOMUX(5,
+				  GPI_NONE)>;
+			bias-disable;
+			drive-strength = <35>;
+			input-disable;
+			input-schmitt-disable;
+			slew-rate = <0>;
+		};
+	};
+
+	pwm1_pins: pwm1-0 {
+		pwm1-pins {
+			pinmux =  <GPIOMUX(5,
 				  GPO_PWM_PAD_OUT_BIT1,
 				  GPO_PWM_PAD_OE_N_BIT1,
 				  GPI_NONE)>;
@@ -359,9 +369,15 @@ &osc_aud {
 	clock-frequency = <27000000>;
 };
 
-&pwm {
+&pwm0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pwm0_pins>;
+	status = "okay";
+};
+
+&pwm1 {
 	pinctrl-names = "default";
-	pinctrl-0 = <&pwm_pins>;
+	pinctrl-0 = <&pwm1_pins>;
 	status = "okay";
 };
 
diff --git a/arch/riscv/boot/dts/starfive/jh7100.dtsi b/arch/riscv/boot/dts/starfive/jh7100.dtsi
index 7de0732b8eabe..90438df1f74d3 100644
--- a/arch/riscv/boot/dts/starfive/jh7100.dtsi
+++ b/arch/riscv/boot/dts/starfive/jh7100.dtsi
@@ -360,9 +360,72 @@ watchdog@12480000 {
 				 <&rstgen JH7100_RSTN_WDT>;
 		};
 
-		pwm: pwm@12490000 {
+		pwm0: pwm@12490000 {
 			compatible = "starfive,jh7100-pwm", "opencores,pwm-v1";
-			reg = <0x0 0x12490000 0x0 0x10000>;
+			reg = <0x0 0x12490000 0x0 0x10>;
+			clocks = <&clkgen JH7100_CLK_PWM_APB>;
+			resets = <&rstgen JH7100_RSTN_PWM_APB>;
+			#pwm-cells = <3>;
+			status = "disabled";
+		};
+
+		pwm1: pwm@12490010 {
+			compatible = "starfive,jh7100-pwm", "opencores,pwm-v1";
+			reg = <0x0 0x12490010 0x0 0x10>;
+			clocks = <&clkgen JH7100_CLK_PWM_APB>;
+			resets = <&rstgen JH7100_RSTN_PWM_APB>;
+			#pwm-cells = <3>;
+			status = "disabled";
+		};
+
+		pwm2: pwm@12490020 {
+			compatible = "starfive,jh7100-pwm", "opencores,pwm-v1";
+			reg = <0x0 0x12490020 0x0 0x10>;
+			clocks = <&clkgen JH7100_CLK_PWM_APB>;
+			resets = <&rstgen JH7100_RSTN_PWM_APB>;
+			#pwm-cells = <3>;
+			status = "disabled";
+		};
+
+		pwm3: pwm@12490030 {
+			compatible = "starfive,jh7100-pwm", "opencores,pwm-v1";
+			reg = <0x0 0x12490030 0x0 0x10>;
+			clocks = <&clkgen JH7100_CLK_PWM_APB>;
+			resets = <&rstgen JH7100_RSTN_PWM_APB>;
+			#pwm-cells = <3>;
+			status = "disabled";
+		};
+
+		pwm4: pwm@12498000 {
+			compatible = "starfive,jh7100-pwm", "opencores,pwm-v1";
+			reg = <0x0 0x12498000 0x0 0x10>;
+			clocks = <&clkgen JH7100_CLK_PWM_APB>;
+			resets = <&rstgen JH7100_RSTN_PWM_APB>;
+			#pwm-cells = <3>;
+			status = "disabled";
+		};
+
+		pwm5: pwm@12498010 {
+			compatible = "starfive,jh7100-pwm", "opencores,pwm-v1";
+			reg = <0x0 0x12498010 0x0 0x10>;
+			clocks = <&clkgen JH7100_CLK_PWM_APB>;
+			resets = <&rstgen JH7100_RSTN_PWM_APB>;
+			#pwm-cells = <3>;
+			status = "disabled";
+		};
+
+		pwm6: pwm@12498020 {
+			compatible = "starfive,jh7100-pwm", "opencores,pwm-v1";
+			reg = <0x0 0x12498020 0x0 0x10>;
+			clocks = <&clkgen JH7100_CLK_PWM_APB>;
+			resets = <&rstgen JH7100_RSTN_PWM_APB>;
+			#pwm-cells = <3>;
+			status = "disabled";
+		};
+
+		pwm7: pwm@12498030 {
+			compatible = "starfive,jh7100-pwm", "opencores,pwm-v1";
+			reg = <0x0 0x12498030 0x0 0x10>;
 			clocks = <&clkgen JH7100_CLK_PWM_APB>;
 			resets = <&rstgen JH7100_RSTN_PWM_APB>;
 			#pwm-cells = <3>;
diff --git a/arch/riscv/boot/dts/starfive/jh7110-common.dtsi b/arch/riscv/boot/dts/starfive/jh7110-common.dtsi
index 5dc15e48b74b1..d91672a0478dd 100644
--- a/arch/riscv/boot/dts/starfive/jh7110-common.dtsi
+++ b/arch/riscv/boot/dts/starfive/jh7110-common.dtsi
@@ -359,9 +359,14 @@ uboot@100000 {
 	};
 };
 
-&pwm {
+&pwm0 {
 	pinctrl-names = "default";
-	pinctrl-0 = <&pwm_pins>;
+	pinctrl-0 = <&pwm0_pins>;
+};
+
+&pwm1 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&pwm1_pins>;
 };
 
 &spi0 {
@@ -572,12 +577,22 @@ GPOEN_ENABLE,
 		};
 	};
 
-	pwm_pins: pwm-0 {
-		pwm-pins {
+	pwm0_pins: pwm0-0 {
+		pwm0-pins {
 			pinmux = <GPIOMUX(46, GPOUT_SYS_PWM_CHANNEL0,
 					      GPOEN_SYS_PWM0_CHANNEL0,
-					      GPI_NONE)>,
-				 <GPIOMUX(59, GPOUT_SYS_PWM_CHANNEL1,
+					      GPI_NONE)>;
+			bias-disable;
+			drive-strength = <12>;
+			input-disable;
+			input-schmitt-disable;
+			slew-rate = <0>;
+		};
+	};
+
+	pwm1_pins: pwm1-0 {
+		pwm1-pins {
+			pinmux = <GPIOMUX(59, GPOUT_SYS_PWM_CHANNEL1,
 					      GPOEN_SYS_PWM0_CHANNEL1,
 					      GPI_NONE)>;
 			bias-disable;
diff --git a/arch/riscv/boot/dts/starfive/jh7110-milkv-mars.dts b/arch/riscv/boot/dts/starfive/jh7110-milkv-mars.dts
index fdaf6b4557da9..58da60edc18ae 100644
--- a/arch/riscv/boot/dts/starfive/jh7110-milkv-mars.dts
+++ b/arch/riscv/boot/dts/starfive/jh7110-milkv-mars.dts
@@ -41,7 +41,11 @@ &phy0 {
 	motorcomm,tx-clk-adj-enabled;
 };
 
-&pwm {
+&pwm0 {
+	status = "okay";
+};
+
+&pwm1 {
 	status = "okay";
 };
 
diff --git a/arch/riscv/boot/dts/starfive/jh7110-milkv-marscm.dtsi b/arch/riscv/boot/dts/starfive/jh7110-milkv-marscm.dtsi
index 25b70af564eea..e7a318f1f1757 100644
--- a/arch/riscv/boot/dts/starfive/jh7110-milkv-marscm.dtsi
+++ b/arch/riscv/boot/dts/starfive/jh7110-milkv-marscm.dtsi
@@ -74,7 +74,11 @@ &phy0 {
 	motorcomm,tx-clk-adj-enabled;
 };
 
-&pwm {
+&pwm0 {
+	status = "okay";
+};
+
+&pwm1 {
 	status = "okay";
 };
 
diff --git a/arch/riscv/boot/dts/starfive/jh7110-pine64-star64.dts b/arch/riscv/boot/dts/starfive/jh7110-pine64-star64.dts
index 31e825be2065a..160b2d6e4b3c2 100644
--- a/arch/riscv/boot/dts/starfive/jh7110-pine64-star64.dts
+++ b/arch/riscv/boot/dts/starfive/jh7110-pine64-star64.dts
@@ -68,7 +68,11 @@ &phy1 {
 	motorcomm,tx-clk-100-inverted;
 };
 
-&pwm {
+&pwm0 {
+	status = "okay";
+};
+
+&pwm1 {
 	status = "okay";
 };
 
diff --git a/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2-lite.dtsi b/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2-lite.dtsi
index f8797a666dbf5..85b56a72dff7a 100644
--- a/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2-lite.dtsi
+++ b/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2-lite.dtsi
@@ -74,7 +74,11 @@ &phy0 {
 	tx-internal-delay-ps = <1500>;
 };
 
-&pwm {
+&pwm0 {
+	status = "okay";
+};
+
+&pwm1 {
 	status = "okay";
 };
 
diff --git a/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2.dtsi b/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2.dtsi
index 5f14afb2c24dc..5296175b869c0 100644
--- a/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2.dtsi
+++ b/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2.dtsi
@@ -49,7 +49,11 @@ &pcie1 {
 	status = "okay";
 };
 
-&pwm {
+&pwm0 {
+	status = "okay";
+};
+
+&pwm1 {
 	status = "okay";
 };
 
diff --git a/arch/riscv/boot/dts/starfive/jh7110.dtsi b/arch/riscv/boot/dts/starfive/jh7110.dtsi
index 6e56e9d20bb06..f4868c2c476db 100644
--- a/arch/riscv/boot/dts/starfive/jh7110.dtsi
+++ b/arch/riscv/boot/dts/starfive/jh7110.dtsi
@@ -846,9 +846,72 @@ i2stx1: i2s@120c0000 {
 			status = "disabled";
 		};
 
-		pwm: pwm@120d0000 {
+		pwm0: pwm@120d0000 {
 			compatible = "starfive,jh7110-pwm", "opencores,pwm-v1";
-			reg = <0x0 0x120d0000 0x0 0x10000>;
+			reg = <0x0 0x120d0000 0x0 0x10>;
+			clocks = <&syscrg JH7110_SYSCLK_PWM_APB>;
+			resets = <&syscrg JH7110_SYSRST_PWM_APB>;
+			#pwm-cells = <3>;
+			status = "disabled";
+		};
+
+		pwm1: pwm@120d0010 {
+			compatible = "starfive,jh7110-pwm", "opencores,pwm-v1";
+			reg = <0x0 0x120d0010 0x0 0x10>;
+			clocks = <&syscrg JH7110_SYSCLK_PWM_APB>;
+			resets = <&syscrg JH7110_SYSRST_PWM_APB>;
+			#pwm-cells = <3>;
+			status = "disabled";
+		};
+
+		pwm2: pwm@120d0020 {
+			compatible = "starfive,jh7110-pwm", "opencores,pwm-v1";
+			reg = <0x0 0x120d0020 0x0 0x10>;
+			clocks = <&syscrg JH7110_SYSCLK_PWM_APB>;
+			resets = <&syscrg JH7110_SYSRST_PWM_APB>;
+			#pwm-cells = <3>;
+			status = "disabled";
+		};
+
+		pwm3: pwm@120d0030 {
+			compatible = "starfive,jh7110-pwm", "opencores,pwm-v1";
+			reg = <0x0 0x120d0030 0x0 0x10>;
+			clocks = <&syscrg JH7110_SYSCLK_PWM_APB>;
+			resets = <&syscrg JH7110_SYSRST_PWM_APB>;
+			#pwm-cells = <3>;
+			status = "disabled";
+		};
+
+		pwm4: pwm@120d8000 {
+			compatible = "starfive,jh7110-pwm", "opencores,pwm-v1";
+			reg = <0x0 0x120d8000 0x0 0x10>;
+			clocks = <&syscrg JH7110_SYSCLK_PWM_APB>;
+			resets = <&syscrg JH7110_SYSRST_PWM_APB>;
+			#pwm-cells = <3>;
+			status = "disabled";
+		};
+
+		pwm5: pwm@120d8010 {
+			compatible = "starfive,jh7110-pwm", "opencores,pwm-v1";
+			reg = <0x0 0x120d8010 0x0 0x10>;
+			clocks = <&syscrg JH7110_SYSCLK_PWM_APB>;
+			resets = <&syscrg JH7110_SYSRST_PWM_APB>;
+			#pwm-cells = <3>;
+			status = "disabled";
+		};
+
+		pwm6: pwm@120d8020 {
+			compatible = "starfive,jh7110-pwm", "opencores,pwm-v1";
+			reg = <0x0 0x120d8020 0x0 0x10>;
+			clocks = <&syscrg JH7110_SYSCLK_PWM_APB>;
+			resets = <&syscrg JH7110_SYSRST_PWM_APB>;
+			#pwm-cells = <3>;
+			status = "disabled";
+		};
+
+		pwm7: pwm@120d8030 {
+			compatible = "starfive,jh7110-pwm", "opencores,pwm-v1";
+			reg = <0x0 0x120d8030 0x0 0x10>;
 			clocks = <&syscrg JH7110_SYSCLK_PWM_APB>;
 			resets = <&syscrg JH7110_SYSRST_PWM_APB>;
 			#pwm-cells = <3>;
-- 
2.53.0



