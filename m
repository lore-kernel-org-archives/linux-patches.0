Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018291;
	b=yRX44pQPc4tG611quGmU+08UrwufR/CpWzdk+zTDNCBLKKSuEOK24qvUe9F8GhApvQdu
	 I0G6kVvO1F70E7+9gCHHuAnuAjtnRXXUHivoruvpS54zarjfYm6KcvXz1xco79O1kY0Sn
	 BuWopsAJ0MiyXXvs/UHSykHpn3VroRZ6sshtUpJ1e/Up5aZXJQng2rMuNG7hboqdlMa+H
	 i34glhlXVoX2kMxRngO5oLN5CIaPvfYBko52fqsE7odbQfZ2mn8e9WYFLoC3tdI6jYjxw
	 qaHUM/uPfkTmxX3RNc3UHBwDZniNAUpSD+WSCI5aW76KRGR7+HFLeC3wtKJrRP6tugQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018291;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q8RPruYr5apWzUqphTdIjI8j4gZTYgHwyAOijboVDNo=;
	b=v5B4wBoC1kKX6CuOLYwXw4oIWuxcPi+GK7V7Maxpvbs43CgZ92iaUe4UvSc1TBuMs4mW
	 Fhhke7S2ElZ50HqvR153tf1JjmDnm++L2PINhYgTTCCxTUJ8rwcG38XqgnhA7vZgCSyXT
	 Bx+99oLZYUfkSIyUN1Nw4QMYcgwou6mcKUb57FOaDyFK95uOu3+wvx/yM3HGYH8pV9Wsb
	 kfKgwicjQEOCfEzVQ1GhN0XTRXtvu0kuiPs3FVzGn0nhRuEWi0RTTtVCV3RBHKUF+Z+Mp
	 AABXqyOAPY1NkAv6N+iqCXu0tzEZvIGlWXHdw9XY95n74EyXMnefDJNpZEK6mssDaHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FMLQ+U6g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 674FD606A31C;
	Wed, 18 Nov 2026 16:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FMLQ+U6g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C226C1F000C5;
	Wed, 18 Nov 2026 16:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018291;
	bh=q8RPruYr5apWzUqphTdIjI8j4gZTYgHwyAOijboVDNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FMLQ+U6gC77nGIhQ83UkAaz4Kqff0AzrSSsx5OPowyDRiIoEDdm0X7+yuDDWo2vAt
	 X0Jz/wcd94YGFSlzmEs6kAkRUGklTj6+fQ53HEG+pNMGJHb2nUm8CsJm1LMOWEu9Yu
	 GZtKaHJkPkEk+BIcsdvYz86X6Vo46hDrpeFO6Cjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hal Feng <hal.feng@starfivetech.com>,
	Maud Spierings <maud_spierings@hotmail.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1189/2651] riscv: dts: starfive: Correct pwm nodes
Date: Wed, 18 Nov 2026 15:40:29 +0100
Message-ID: <20261118150330.808438969@linuxfoundation.org>
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
index a7a1c09a2c907..64de468f2c317 100644
--- a/arch/riscv/boot/dts/starfive/jh7110-common.dtsi
+++ b/arch/riscv/boot/dts/starfive/jh7110-common.dtsi
@@ -326,9 +326,14 @@ uboot@100000 {
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
@@ -528,12 +533,22 @@ GPOEN_ENABLE,
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
index 21873612d9931..54013c70f4b4e 100644
--- a/arch/riscv/boot/dts/starfive/jh7110-milkv-mars.dts
+++ b/arch/riscv/boot/dts/starfive/jh7110-milkv-mars.dts
@@ -68,7 +68,11 @@ &phy0 {
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
index 025471061d439..31afac27b86de 100644
--- a/arch/riscv/boot/dts/starfive/jh7110-milkv-marscm.dtsi
+++ b/arch/riscv/boot/dts/starfive/jh7110-milkv-marscm.dtsi
@@ -87,7 +87,11 @@ &phy0 {
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
index aec7ae3d1f5b4..a9e82f25efdec 100644
--- a/arch/riscv/boot/dts/starfive/jh7110-pine64-star64.dts
+++ b/arch/riscv/boot/dts/starfive/jh7110-pine64-star64.dts
@@ -95,7 +95,11 @@ &phy1 {
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
index edc8f45881336..35208f95cd3d7 100644
--- a/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2.dtsi
+++ b/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2.dtsi
@@ -73,7 +73,11 @@ &pcie1 {
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
index 9c3e4598747eb..82ea63f715b0e 100644
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



