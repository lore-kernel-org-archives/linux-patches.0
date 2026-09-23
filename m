Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CA22D6E64;
	Wed, 23 Sep 2026 14:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172654; cv=none; b=ND9XkJLd7+dM0OJ5hS3UxDWDX8IB0VpURcuUbPvNUe6i2vFFsSEFAFHYIz69+Jxkz0P9Djs2piT64dRpslNcX/oDUYz99BbzFv/p5BUD/RVpJrKuSlb491/FsQvXGyxPsO/7LPis0rKpZdT2+0O6wfyMGIsE+s/WPObhEgJFu1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172654; c=relaxed/simple;
	bh=ofRgz0T2HyAd1zNwkFj/eBXMHGQm7nAwydg3psA2jcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KYt6iXbDo1x8LoumqSAfFg1Hk/htLAu8KXdVJzrZSk8EV7f6c0V+F7MPVJRZB2iklIaLz39CFjly7w9aAXSfON2Dj7nAfdE7tcUVpJRv/p6hb8HF4tuFpHl7GUi2EpjSVmj0eXoNuXn1LxZLj34NVpctQ7MBkaCpyqaPQInKQj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gSOJuAt/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gSOJuAt/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 100491F000FF;
	Wed, 23 Sep 2026 14:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172653;
	bh=jrOv6DzauUp1nAjoVRmKBG7Ug1+YW0fnJkmxxdQyWjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gSOJuAt/CeCEgqgDNEZAodr0OpoxQqBQqlDZW7+M6geTTq1kiGxxF8IHaps56CvCY
	 71rES0zcM4KaQ92flaf6TR0yUsVq6QkEvNFuVSfpKeLj3BRmSsxCXyGUF2D61MpxzY
	 gZH3Rh1/KiOaVxx7PQVr37ZLJKgR0vv1lqcoL2ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Tanure <tanure@linux.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 014/438] arm64: dts: amlogic: t7: khadas-vim4: add the PWM-driven supplies
Date: Wed, 23 Sep 2026 16:00:35 +0200
Message-ID: <20260923140645.143443908@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas Tanure <tanure@linux.com>

[ Upstream commit 1e5a53bd16ac501e68463e84023d1bff543cc696 ]

The board powers its two CPU clusters, the GPU, the NPU, the memory and
the always-on domain from regulators steered by PWM outputs. None of
them were described, so Linux treated those outputs as unused and
switched them off part way through boot. The supplies then drifted away
from the levels the bootloader had set, which showed up as random hangs
and memory corruption.

Describe each supply so it has an owner and is left alone.

The voltage ranges are read off the feedback networks on the board
schematic. VDDNPU is deliberately not the range in Amlogic's own
device tree: this board fits a different feedback resistor, which
puts it about 40mV higher at both ends.

Fixes: 8c45bf9ae4ef ("arm64: dts: amlogic: t7: khadas-vim4: Add power regulators")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Lucas Tanure <tanure@linux.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260829094758.23248-4-tanure@linux.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amlogic/amlogic-t7-a311d2-khadas-vim4.dts | 110 +++++++++++++++++-
 1 file changed, 109 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/amlogic-t7-a311d2-khadas-vim4.dts b/arch/arm64/boot/dts/amlogic/amlogic-t7-a311d2-khadas-vim4.dts
index c94afaaf8826e..77abfd555ec5b 100644
--- a/arch/arm64/boot/dts/amlogic/amlogic-t7-a311d2-khadas-vim4.dts
+++ b/arch/arm64/boot/dts/amlogic/amlogic-t7-a311d2-khadas-vim4.dts
@@ -104,6 +104,66 @@ vcc5v0_usb: regulator-vcc-usb {
 		enable-active-high;
 	};
 
+	vdd_ddr: regulator-vddddr {
+		/*
+		 * SY8003ADFC Regulator.
+		 */
+		compatible = "pwm-regulator";
+		regulator-name = "VDDDDR";
+		regulator-min-microvolt = <690000>;
+		regulator-max-microvolt = <890000>;
+		pwm-supply = <&dc_in>;
+		pwms = <&pwm_ao_gh 0 1500 0>;
+		pwm-dutycycle-range = <100 0>;
+		regulator-boot-on;
+		regulator-always-on;
+	};
+
+	vdd_ee: regulator-vddee {
+		/*
+		 * MP8756GD Regulator.
+		 */
+		compatible = "pwm-regulator";
+		regulator-name = "VDDEE";
+		regulator-min-microvolt = <700000>;
+		regulator-max-microvolt = <922000>;
+		pwm-supply = <&dc_in>;
+		pwms = <&pwm_ao_ab 0 1500 0>;
+		pwm-dutycycle-range = <100 0>;
+		regulator-boot-on;
+		regulator-always-on;
+	};
+
+	vdd_gpu: regulator-vddgpu {
+		/*
+		 * SY8003ADFC Regulator.
+		 */
+		compatible = "pwm-regulator";
+		regulator-name = "VDDGPU";
+		regulator-min-microvolt = <700000>;
+		regulator-max-microvolt = <922000>;
+		pwm-supply = <&dc_in>;
+		pwms = <&pwm_ao_ef 0 1500 0>;
+		pwm-dutycycle-range = <100 0>;
+		regulator-boot-on;
+		regulator-always-on;
+	};
+
+	vdd_npu: regulator-vddnpu {
+		/*
+		 * SY8003ADFC Regulator.
+		 */
+		compatible = "pwm-regulator";
+		regulator-name = "VDDNPU";
+		regulator-min-microvolt = <733000>;
+		regulator-max-microvolt = <933000>;
+		pwm-supply = <&dc_in>;
+		pwms = <&pwm_ao_ef 1 1500 0>;
+		pwm-dutycycle-range = <100 0>;
+		regulator-boot-on;
+		regulator-always-on;
+	};
+
 	vddao_1v8: regulator-vddao-1v8 {
 		compatible = "regulator-fixed";
 		regulator-name = "VDDAO_1V8";
@@ -122,6 +182,36 @@ vddao_3v3: regulator-vddao-3v3 {
 		regulator-always-on;
 	};
 
+	vddcpu_a: regulator-vddcpu-a {
+		/*
+		 * MP8756GD Regulator.
+		 */
+		compatible = "pwm-regulator";
+		regulator-name = "VDDCPU_A";
+		regulator-min-microvolt = <689000>;
+		regulator-max-microvolt = <1049000>;
+		pwm-supply = <&dc_in>;
+		pwms = <&pwm_ao_cd 1 1500 0>;
+		pwm-dutycycle-range = <100 0>;
+		regulator-boot-on;
+		regulator-always-on;
+	};
+
+	vddcpu_b: regulator-vddcpu-b {
+		/*
+		 * MP8756GD Regulator.
+		 */
+		compatible = "pwm-regulator";
+		regulator-name = "VDDCPU_B";
+		regulator-min-microvolt = <689000>;
+		regulator-max-microvolt = <1049000>;
+		pwm-supply = <&dc_in>;
+		pwms = <&pwm_ao_ab 1 1500 0>;
+		pwm-dutycycle-range = <100 0>;
+		regulator-boot-on;
+		regulator-always-on;
+	};
+
 	vddio_1v8: regulator-vddio-1v8 {
 		compatible = "regulator-fixed";
 		regulator-name = "VDDIO_1V8";
@@ -172,9 +262,27 @@ &pwm_ab {
 	pinctrl-names = "default";
 };
 
+&pwm_ao_ab {
+	status = "okay";
+	pinctrl-0 = <&pwm_ao_a_pins>, <&pwm_ao_b_pins>;
+	pinctrl-names = "default";
+};
+
 &pwm_ao_cd {
 	status = "okay";
-	pinctrl-0 = <&pwm_ao_c_d_pins>;
+	pinctrl-0 = <&pwm_ao_c_d_pins>, <&pwm_ao_d_pins>;
+	pinctrl-names = "default";
+};
+
+&pwm_ao_ef {
+	status = "okay";
+	pinctrl-0 = <&pwm_ao_e_pins>, <&pwm_ao_f_pins>;
+	pinctrl-names = "default";
+};
+
+&pwm_ao_gh {
+	status = "okay";
+	pinctrl-0 = <&pwm_ao_g_e_pins>;
 	pinctrl-names = "default";
 };
 
-- 
2.53.0



