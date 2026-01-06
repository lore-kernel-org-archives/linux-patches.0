Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7763659E2;
	Tue,  6 Jan 2026 17:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722030; cv=none; b=aFKwgm5OZZoWCA5rnra/HREek1nqEfFrHjEYs7aXiAAQEVk44uZeHPOx729bbSSD4sCYvm92J21S8yMTLhnLJJg+gKRm4J7XC6XarmnZF6YXoCLYxyLmyXqJktGZMxS5xwNvSvBmUlvpo2GTjEeXMP2ZGOhvzrBiH9sTQDLTEss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722030; c=relaxed/simple;
	bh=NusFh8b0xrOr2U5C9o8GTEgkcWrGk2k6U+xJ58seJHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oF23kcd+c75sXYlKSJomxFpXhNsF7IU5BHCTbpRbANjE+rv/qcA/4ibumQxlqF3+jTSqvN/sXlFtvQKbHMS24JQitpVz/9t/MwFH6IB1QJhv3WqeeAGsqKUObYzpSc97Vkdg8HqsXNybD3BlH9ClyCwybcZ4Oa5lSA7/hMXEu9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qL2LzoTJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qL2LzoTJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 129CAC116C6;
	Tue,  6 Jan 2026 17:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722030;
	bh=NusFh8b0xrOr2U5C9o8GTEgkcWrGk2k6U+xJ58seJHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qL2LzoTJamKXYpF9PisbwsuObO8f2v2N/G4n+oCQhCsUBOIyvkuZmYdpiLb5xmJaq
	 EssQ6LEu0Ar5D04aegAlOSuf4pt12LC8fdCEu3phosJAmdexAHmC73qDSPxhodXkYI
	 9IQINeESXlakJiR3ZN4KXUjn7HENT3QaezEKho1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paresh Bhagat <p-bhagat@ti.com>,
	Shree Ramamoorthy <s-ramamoorthy@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH 6.18 144/312] arm64: dts: ti: k3-am62d2-evm: Fix regulator properties
Date: Tue,  6 Jan 2026 18:03:38 +0100
Message-ID: <20260106170553.051210142@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paresh Bhagat <p-bhagat@ti.com>

commit 0103435072bf5c54bb43d1a9376d08396c825827 upstream.

Fix missing supply for regulators TLV7103318QDSERQ1 and TPS22918DBVR.
Correct padconfig and gpio for TLV7103318QDSERQ1.

Reference Docs
Datasheet - https://www.ti.com/lit/ug/sprujd4/sprujd4.pdf
Schematics - https://www.ti.com/lit/zip/sprcal5

Fixes: 1544bca2f188e ("arm64: dts: ti: Add support for AM62D2-EVM")
Cc: stable@vger.kernel.org
Signed-off-by: Paresh Bhagat <p-bhagat@ti.com>
Reviewed-by: Shree Ramamoorthy <s-ramamoorthy@ti.com>
Link: https://patch.msgid.link/20251028210153.420473-1-p-bhagat@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-am62d2-evm.dts | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62d2-evm.dts b/arch/arm64/boot/dts/ti/k3-am62d2-evm.dts
index 83af889e790a..d202484eec3f 100644
--- a/arch/arm64/boot/dts/ti/k3-am62d2-evm.dts
+++ b/arch/arm64/boot/dts/ti/k3-am62d2-evm.dts
@@ -146,6 +146,7 @@
 		regulator-name = "vdd_mmc1";
 		regulator-min-microvolt = <3300000>;
 		regulator-max-microvolt = <3300000>;
+		vin-supply = <&vcc_3v3_sys>;
 		regulator-boot-on;
 		enable-active-high;
 		gpio = <&exp1 3 GPIO_ACTIVE_HIGH>;
@@ -165,14 +166,16 @@
 	};
 
 	vddshv_sdio: regulator-6 {
+		/* output of TLV7103318QDSERQ1 */
 		compatible = "regulator-gpio";
 		regulator-name = "vddshv_sdio";
 		pinctrl-names = "default";
 		pinctrl-0 = <&vddshv_sdio_pins_default>;
 		regulator-min-microvolt = <1800000>;
 		regulator-max-microvolt = <3300000>;
+		vin-supply = <&vcc_5v0>;
 		regulator-boot-on;
-		gpios = <&main_gpio1 31 GPIO_ACTIVE_HIGH>;
+		gpios = <&main_gpio0 59 GPIO_ACTIVE_HIGH>;
 		states = <1800000 0x0>,
 			 <3300000 0x1>;
 		bootph-all;
@@ -334,7 +337,7 @@
 
 	vddshv_sdio_pins_default: vddshv-sdio-default-pins {
 		pinctrl-single,pins = <
-			AM62DX_IOPAD(0x1f4, PIN_OUTPUT, 7) /* (M19) GPMC0_CLK.GPIO1_31 */
+			AM62DX_IOPAD(0x00f0, PIN_INPUT, 7) /* (Y21) GPIO0_59 */
 		>;
 		bootph-all;
 	};
-- 
2.52.0



