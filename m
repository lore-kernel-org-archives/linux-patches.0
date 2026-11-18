Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029106;
	b=yaeRaY7xHYzJuHNDrhBZ/3gANCt59UxRRAWmWtkqAO4W70ScqASKdscyT6VnTTZjYqas
	 UBV9NJascxdAZ9Hf+aP2wzxRkYUnxx+7rnGLkVPNwx+UjZq9ohd5FI2KLxdO9HzijSWec
	 0OCFDGyUIgPxiuxSQ3MixHI0AJySkCX1t1LjgbMl72KTigS3uXtTH6dnuo4s17y7rLU+U
	 dFgxjY6H/UyC8Ct+4ZZeBYS7juJM5+vaUActoa+jZDBFQgM/n/gNUNtA9UNtgs86wSaXi
	 0YvSv+tXiA5zX1kCWtqXzxjYQq7T8bEa5HnGJ44CE1PDw00AEmbqvZ4P4tAxqWDvZsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029106;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eUo5yznZ1jl20YwuveuN4Jr+lxfJvu78LLf+ykA4KXw=;
	b=IbwPmZ8Cf9RGugtQV9Sf0Rz4+PtVfaE9URIPqtIcRH/Hik51o0N5cDgZVZjGLiMF6sRI
	 INkVYPxXZNoPKk6a4LiICKzI52eKrQ5rITTlBOTXcHiW77DuceFVpnxCipTqoy4oSZR+V
	 cTHVy5bg5WDchx3pmZLhPT+tpqekTa1lMOn6iPT7KmAAu5P05P8ppNB8Vm4t7OwUULLOA
	 pzKMVsC1yzVTDlWc+EUgobBFQN9njufwyiSH+qm7Y9VCK6ewp8oWXrTWpuVoFllWBKF31
	 d1FVY0b3+eEhVR7/sECvRN8CZzGhCME8LcaHa0FIXj7voEpKHAJ8+NbRgImW97yAZiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DkIxwed4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E96A606A320;
	Wed, 18 Nov 2026 19:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DkIxwed4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 019201F000C4;
	Wed, 18 Nov 2026 19:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029106;
	bh=eUo5yznZ1jl20YwuveuN4Jr+lxfJvu78LLf+ykA4KXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DkIxwed4ZDopXHVfgZNjyGx8nncoa/DVv0spVQ5c1nqGwAMzGbc6uV0aMGIG+e2t/
	 dS6K/fyD10rostG5pLsN6LP74oAxpjXGOIyDBxwo2xfwu1bEJUevdAqyFPS2KhLrko
	 vLV3tZ6TdUPoqnvliNaY+e9noPLuIr9Uwj+xwPFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Udit Kumar <u-kumar1@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0232/1756] arm64: dts: ti: k3-j722s-evm: Enable PMIC
Date: Wed, 18 Nov 2026 15:39:19 +0100
Message-ID: <20261118150017.501925794@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Udit Kumar <u-kumar1@ti.com>

[ Upstream commit 998ad09ad3b0ef1776fcb988af4916a062b92cc1 ]

Add support for TPS6522x PMIC family on wakeup I2C0 bus.
This device provides regulators (bucks and LDOs), along with
GPIOs, and monitors SOC's MCU error signal.

Signed-off-by: Udit Kumar <u-kumar1@ti.com>
Link: https://lore.kernel.org/r/20250102103814.102499-1-u-kumar1@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Stable-dep-of: 432bfc86fe62 ("arm64: dts: ti: k3-j722s-evm: Switch audio codec clock from audio_refclk1 to external clock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j722s-evm.dts | 88 +++++++++++++++++++++++++
 1 file changed, 88 insertions(+)

diff --git a/arch/arm64/boot/dts/ti/k3-j722s-evm.dts b/arch/arm64/boot/dts/ti/k3-j722s-evm.dts
index 98fc1c0f86a42..4504912512b41 100644
--- a/arch/arm64/boot/dts/ti/k3-j722s-evm.dts
+++ b/arch/arm64/boot/dts/ti/k3-j722s-evm.dts
@@ -359,6 +359,13 @@ audio_ext_refclk1_pins_default: audio-ext-refclk1-default-pins {
 			J722S_IOPAD(0x00a0, PIN_OUTPUT, 1) /* (N24) GPMC0_WPn.AUDIO_EXT_REFCLK1 */
 		>;
 	};
+
+	pmic_irq_pins_default: pmic-irq-default-pins {
+		pinctrl-single,pins = <
+			J722S_IOPAD(0x030, PIN_INPUT, 7) /* (K23) GPIO0_12 */
+		>;
+	};
+
 };
 
 &cpsw3g {
@@ -459,6 +466,87 @@ &wkup_i2c0 {
 	clock-frequency = <400000>;
 	status = "okay";
 	bootph-all;
+
+	tps65224: pmic@48 {
+		compatible = "ti,tps65224-q1";
+		reg = <0x48>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&pmic_irq_pins_default>;
+		interrupt-parent = <&main_gpio0>;
+		interrupts = <0 IRQ_TYPE_EDGE_FALLING>;
+		ti,primary-pmic;
+
+		gpio-controller;
+		#gpio-cells = <2>;
+
+		buck12-supply = <&vsys_io_3v3>;
+		buck3-supply = <&vsys_io_3v3>;
+		buck4-supply = <&vsys_io_3v3>;
+
+		ldo1-supply = <&vsys_io_3v3>;
+		ldo2-supply = <&vsys_io_3v3>;
+		ldo3-supply = <&vsys_io_3v3>;
+
+		regulators {
+
+			buck1: buck1 {
+				regulator-name = "vcc1v8_io_buck1";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-boot-on;
+				regulator-always-on;
+				bootph-all;
+			};
+
+			buck2: buck2 {
+				regulator-name = "vcc1v1_ddr_buck2";
+				regulator-min-microvolt = <1100000>;
+				regulator-max-microvolt = <1100000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+
+			buck3: buck3 {
+				regulator-name = "vcc0v85_ram_buck3";
+				regulator-min-microvolt = <850000>;
+				regulator-max-microvolt = <850000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+
+			buck4: buck4 {
+				regulator-name = "vcc0v75_ioret_buck4";
+				regulator-min-microvolt = <750000>;
+				regulator-max-microvolt = <750000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+
+			ldo1: ldo1 {
+				regulator-name = "vdda1v8_pll_ldo1";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+
+			ldo2: ldo2 {
+				regulator-name = "dvdd3v3_ldo2";
+				regulator-min-microvolt = <3300000>;
+				regulator-max-microvolt = <3300000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+
+			ldo3: ldo3 {
+				regulator-name = "vdd1v85_phy_ldo3";
+				regulator-min-microvolt = <1800000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-boot-on;
+				regulator-always-on;
+			};
+	       };
+	};
 };
 
 &k3_clks {
-- 
2.53.0



