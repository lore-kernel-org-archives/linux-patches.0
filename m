Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713B02EE97A;
	Thu,  3 Jul 2025 14:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554497; cv=none; b=Qtq2pIWQFRhkvBYt812RgWk1azHs96kz2ZawkhFPj/84I9xvhntdEHhr+FukdiW7B60s3CSG7zQiTk1/SlNtpwlYbKPxRs1Xamo2NSstJhjlLh9jFDzi9ZCA/iN8PDqmGwdbpoxdv9APMfh1mGSfkVblGlMU76IHdA2/QE0IbiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554497; c=relaxed/simple;
	bh=bPBLXrClSG8E6aKg3UykpB24hDtCQgHwBsb+iy8btaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qB7TKekn6rpsm+SRyJbmNwG5muuPfwqkTgR8J1pI2wRaGJLpzeHkAXziiUKk9qVbQmZKAfMDQT39PFDSuX4KSYN0w8P1320p7GTe1cCPTwoxkxPTlBM+XsOKa65ndsE/ZhIIOAIr++Bktj/S8JNNHcADZ3Pn0JkGvOHrd2wilVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xzYza3dC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xzYza3dC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79819C4CEE3;
	Thu,  3 Jul 2025 14:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554497;
	bh=bPBLXrClSG8E6aKg3UykpB24hDtCQgHwBsb+iy8btaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xzYza3dC8uu0BnvPpOCJaCp7MKVgvan15gyB3A/PxSY/yRsM2B/C7HEopzpUJzfqR
	 bV1nhJ4ua0x/oWi6RMJu9GMCJ1slZAjgXt+t+qs6w4ZQddZmt9S7Z+2tterAnv421n
	 Uv65ksNzrUAp969fXXshhBuJ9fiJMK3AhNVotiiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diederik de Haas <didi.debian@cknow.org>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 207/218] arm64: dts: rockchip: Add avdd HDMI supplies to RockPro64 board dtsi
Date: Thu,  3 Jul 2025 16:42:35 +0200
Message-ID: <20250703144004.497653124@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dragan Simic <dsimic@manjaro.org>

[ Upstream commit bd1c959f37f384b477f51572331b0dc828bd009a ]

Add missing "avdd-0v9-supply" and "avdd-1v8-supply" properties to the "hdmi"
node in the Pine64 RockPro64 board dtsi file.  To achieve this, also add the
associated "vcca_0v9" regulator that produces the 0.9 V supply, [1][2] which
hasn't been defined previously in the board dtsi file.

This also eliminates the following warnings from the kernel log:

  dwhdmi-rockchip ff940000.hdmi: supply avdd-0v9 not found, using dummy regulator
  dwhdmi-rockchip ff940000.hdmi: supply avdd-1v8 not found, using dummy regulator

There are no functional changes to the way board works with these additions,
because the "vcc1v8_dvp" and "vcca_0v9" regulators are always enabled, [1][2]
but these additions improve the accuracy of hardware description.

These changes apply to the both supported hardware revisions of the Pine64
RockPro64, i.e. to the production-run revisions 2.0 and 2.1. [1][2]

[1] https://files.pine64.org/doc/rockpro64/rockpro64_v21-SCH.pdf
[2] https://files.pine64.org/doc/rockpro64/rockpro64_v20-SCH.pdf

Fixes: e4f3fb490967 ("arm64: dts: rockchip: add initial dts support for Rockpro64")
Cc: stable@vger.kernel.org
Suggested-by: Diederik de Haas <didi.debian@cknow.org>
Signed-off-by: Dragan Simic <dsimic@manjaro.org>
Tested-by: Diederik de Haas <didi.debian@cknow.org>
Link: https://lore.kernel.org/r/df3d7e8fe74ed5e727e085b18c395260537bb5ac.1740941097.git.dsimic@manjaro.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dtsi | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dtsi
index 11d99d8b34a2b..66d010a9e8c31 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-rockpro64.dtsi
@@ -227,6 +227,16 @@ vcc5v0_usb: vcc5v0-usb {
 		vin-supply = <&vcc12v_dcin>;
 	};
 
+	vcca_0v9: vcca-0v9 {
+		compatible = "regulator-fixed";
+		regulator-name = "vcca_0v9";
+		regulator-always-on;
+		regulator-boot-on;
+		regulator-min-microvolt = <900000>;
+		regulator-max-microvolt = <900000>;
+		vin-supply = <&vcc3v3_sys>;
+	};
+
 	vdd_log: vdd-log {
 		compatible = "pwm-regulator";
 		pwms = <&pwm2 0 25000 1>;
@@ -312,6 +322,8 @@ &gmac {
 };
 
 &hdmi {
+	avdd-0v9-supply = <&vcca_0v9>;
+	avdd-1v8-supply = <&vcc1v8_dvp>;
 	ddc-i2c-bus = <&i2c3>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&hdmi_cec>;
-- 
2.39.5



