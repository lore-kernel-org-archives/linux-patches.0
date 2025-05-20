Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448812907;
	Tue, 20 May 2025 14:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750536; cv=none; b=IS3zaLdb5V11QN4fUzd0DSjFun157uRfzMLizcmSX1jemiAarzSGaXOCM3v06vx4JPKYT2GyMT9l+kM0ad0nhZ3IJdZ2pyw7PzTqS86Jkl+1W/o+9J3Dip788kC2hhfZmtHB28GXsfsSMKa3blStOrgEM8UrviNk2EYmD5FfPxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750536; c=relaxed/simple;
	bh=bd5XWma4wdvAKosyW75jDKI4hSN6sWkLtqj8lO3sagI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nFU28RRJ7NiZCE6GrVM3HxfBFfu2DkwVp/dJSbn9zsaWnmZBFWBGOpYj+fqYEVllCdUvf+ourtAbEVTmWjz5iy0SyRkQhidDVpMuUkPvBglRq6o9aecS2+e7uBNT7BHP5n6S9cH7doFeBi5gHisL1zA1VKHHQ+3goclcLy5QydU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E6EZZ9ig; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E6EZZ9ig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1599C4CEE9;
	Tue, 20 May 2025 14:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750535;
	bh=bd5XWma4wdvAKosyW75jDKI4hSN6sWkLtqj8lO3sagI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E6EZZ9igWpwiB+dxYgCBYEJaRWNXlo01kKAoi8Ky7wDo3Epv8cBmRT3f8xUzyfLE4
	 r2LHAC9ExOAK/XNu4CMPFD3sxVpZf9Cv5naoFQW8A8rjJvuZi24PqXZKVTNPl7MjgY
	 lQ86O50PwnZXSRcLkcADY5me1SwHjbBkQebmHo+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Himanshu Bhavani <himanshu.bhavani@siliconsignals.io>,
	Tarang Raval <tarang.raval@siliconsignals.io>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 012/145] arm64: dts: imx8mp-var-som: Fix LDO5 shutdown causing SD card timeout
Date: Tue, 20 May 2025 15:49:42 +0200
Message-ID: <20250520125811.027929853@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Himanshu Bhavani <himanshu.bhavani@siliconsignals.io>

[ Upstream commit c6888983134e2ccc2db8ffd2720b0d4826d952e4 ]

Fix SD card timeout issue caused by LDO5 regulator getting disabled
after boot.

The kernel log shows LDO5 being disabled, which leads to a timeout
on USDHC2:
[   33.760561] LDO5: disabling
[   81.119861] mmc1: Timeout waiting for hardware interrupt.

To prevent this, set regulator-boot-on and regulator-always-on for
LDO5. Also add the vqmmc regulator to properly support 1.8V/3.3V
signaling for USDHC2 using a GPIO-controlled regulator.

Fixes: 6c2a1f4f71258 ("arm64: dts: imx8mp-var-som-symphony: Add Variscite Symphony board and VAR-SOM-MX8MP SoM")
Signed-off-by: Himanshu Bhavani <himanshu.bhavani@siliconsignals.io>
Acked-by: Tarang Raval <tarang.raval@siliconsignals.io>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-var-som.dtsi | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-var-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-var-som.dtsi
index b2ac2583a5929..b59da91fdd041 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-var-som.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-var-som.dtsi
@@ -35,7 +35,6 @@
 		      <0x1 0x00000000 0 0xc0000000>;
 	};
 
-
 	reg_usdhc2_vmmc: regulator-usdhc2-vmmc {
 	        compatible = "regulator-fixed";
 	        regulator-name = "VSD_3V3";
@@ -46,6 +45,16 @@
 	        startup-delay-us = <100>;
 	        off-on-delay-us = <12000>;
 	};
+
+	reg_usdhc2_vqmmc: regulator-usdhc2-vqmmc {
+		compatible = "regulator-gpio";
+		regulator-name = "VSD_VSEL";
+		regulator-min-microvolt = <1800000>;
+		regulator-max-microvolt = <3300000>;
+		gpios = <&gpio2 12 GPIO_ACTIVE_HIGH>;
+		states = <3300000 0x0 1800000 0x1>;
+		vin-supply = <&ldo5>;
+	};
 };
 
 &A53_0 {
@@ -205,6 +214,7 @@
         pinctrl-2 = <&pinctrl_usdhc2_200mhz>, <&pinctrl_usdhc2_gpio>;
         cd-gpios = <&gpio1 14 GPIO_ACTIVE_LOW>;
         vmmc-supply = <&reg_usdhc2_vmmc>;
+	vqmmc-supply = <&reg_usdhc2_vqmmc>;
         bus-width = <4>;
         status = "okay";
 };
-- 
2.39.5



