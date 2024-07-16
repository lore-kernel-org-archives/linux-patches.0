Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE4419AD93;
	Tue, 16 Jul 2024 15:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145191; cv=none; b=EdgU9MzBbnMAzMV2ZThFsVQzSEbWJkHVGW5RpVV3OasGfdPjapf6vonMjIUPwkF41jcvurpmxDPG49CeWSx+iOCbfenLO2VwLIHkpMrkynf3FG+AZPjIMghUOEVpfCgayW+yCE+xPVg9xgo8cU7+l0YHyrSIDwqlZhseKqGFnH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145191; c=relaxed/simple;
	bh=2VM1wC7aIlehK0RgB8UnKAFUcegy0g56UN8lLtXFbkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sv11AiyHskztCayhWjVKABhZo2ydvkznG/CeUckn3n80E86Xu8sWfjriSX2XBmt/xciRb8NU0KLE3fJH6R5d/NUDCh21VP7JeECPyAlzi2eRTBNpKjPSuw1VLnRJE9T0v58ttG7m8MmgpLji3Uk4S5/iLD6TrgyE0JsmweptRlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EVksQQPb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EVksQQPb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B50C116B1;
	Tue, 16 Jul 2024 15:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145191;
	bh=2VM1wC7aIlehK0RgB8UnKAFUcegy0g56UN8lLtXFbkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EVksQQPb09n8mJtSIi8GzkENAkkMsOnT9+88JkUHvM0crIOszeA8JrU8UUMi/ZIZo
	 OunoJ5BbQ/ph7Lxv+ENckGXY57XUz8FqhpGJ98hzwYKl5vyddj1Qj52PZMFnKADna3
	 lXLcetPaSRFBrFIb8Cp2xCBGHnUjPIP/EEICT4gk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steev Klimaszewski <steev@kali.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.9 096/143] arm64: dts: qcom: sc8280xp-x13s: fix touchscreen power on
Date: Tue, 16 Jul 2024 17:31:32 +0200
Message-ID: <20240716152759.669211812@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit 7bfb6a4289b0a63d67ec7d4ce3018cb4a7442f6a upstream.

The Elan eKTH5015M touch controller on the X13s requires a 300 ms delay
before sending commands after having deasserted reset during power on.

Switch to the Elan specific binding so that the OS can determine the
required power-on sequence and make sure that the controller is always
detected during boot.

Note that the always-on 1.8 V supply (s10b) is not used by the
controller directly and should not be described.

Fixes: 32c231385ed4 ("arm64: dts: qcom: sc8280xp: add Lenovo Thinkpad X13s devicetree")
Cc: stable@vger.kernel.org	# 6.0
Tested-by: Steev Klimaszewski <steev@kali.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20240507144821.12275-6-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts |   15 ++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
+++ b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
@@ -618,15 +618,16 @@
 
 	status = "okay";
 
-	/* FIXME: verify */
 	touchscreen@10 {
-		compatible = "hid-over-i2c";
+		compatible = "elan,ekth5015m", "elan,ekth6915";
 		reg = <0x10>;
 
-		hid-descr-addr = <0x1>;
 		interrupts-extended = <&tlmm 175 IRQ_TYPE_LEVEL_LOW>;
-		vdd-supply = <&vreg_misc_3p3>;
-		vddl-supply = <&vreg_s10b>;
+		reset-gpios = <&tlmm 99 (GPIO_ACTIVE_LOW | GPIO_OPEN_DRAIN)>;
+		no-reset-on-power-off;
+
+		vcc33-supply = <&vreg_misc_3p3>;
+		vccio-supply = <&vreg_misc_3p3>;
 
 		pinctrl-names = "default";
 		pinctrl-0 = <&ts0_default>;
@@ -1417,8 +1418,8 @@
 		reset-n-pins {
 			pins = "gpio99";
 			function = "gpio";
-			output-high;
-			drive-strength = <16>;
+			drive-strength = <2>;
+			bias-disable;
 		};
 	};
 


