Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA352F0C62;
	Wed, 20 May 2026 16:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295577; cv=none; b=JAl4/Flvio9bzNAY/5uJIk3IN4nrtNLvXKFf2KQrX+wS3zULw35U29Pn9Ys8XaeMDySK6Bd91T/9Zmgh9J1wG8w+b/RVipul5vCwU0iIRfi7NwjVNrf8EdGhdikwIV6c+lNvQWULn5WoA+4V8hjJXpQ0Bp+zO5uXXfM5EL7OKyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295577; c=relaxed/simple;
	bh=uwnemPZUyKhV3ML9urtJNhv6UyXEYOZJDrjk+bvcxgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XrzP7UEkNkXIa8rvoWuZOrZh+2qjEhJkUH5OpnXDa18ffI8B5DSMGmRikN1g5Px35wkSrK841qu/SiDyWt8+lDazaRz2OEn9LxmlhdeZvxBAdp/ZW1shpw4Pb9FZ+tF68Mfn5yaQmhJUyOm8RDbxV7R3ByAB2yJj31YktTWy008=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I4rvGft9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I4rvGft9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 310051F000E9;
	Wed, 20 May 2026 16:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295576;
	bh=l+VGdE06l4LIWHojv0kC+5HKGrOvODlPUda38R0hTcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I4rvGft9NqzGlo0uU1Vz5NRriO8NKGlKaF1VTYVDDRh4RoLkOePhC5N+HU23XcffC
	 5rV47qRrHIrtoy2S9MAVBw5DXO0BOJVmZ0vxyIPOa1zyLJsfqoScI+SkRCP/JmJWJJ
	 WzFOFKIEt6PrczpKPkBsJsmRiYaXF6ygSZ6kRHRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Frank Li <Frank.Li@nxp.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0470/1146] arm64: dts: imx8-apalis: Fix LEDs name collision
Date: Wed, 20 May 2026 18:12:00 +0200
Message-ID: <20260520162158.828584303@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francesco Dolcini <francesco.dolcini@toradex.com>

[ Upstream commit 92ab53b9bb2a72581c32073755077af916eb9aee ]

Ixora boards have multiple instances of status leds, to avoid a name
collision add the function-enumerator property.

This fixes the following Linux kernel warnings:

  leds-gpio leds: Led green:status renamed to green:status_1 due to name collision
  leds-gpio leds: Led red:status renamed to red:status_1 due to name collision

Fixes: c083131c9021 ("arm64: dts: freescale: add apalis imx8 aka quadmax carrier board support")
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8-apalis-ixora-v1.1.dtsi | 4 ++++
 arch/arm64/boot/dts/freescale/imx8-apalis-ixora-v1.2.dtsi | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8-apalis-ixora-v1.1.dtsi b/arch/arm64/boot/dts/freescale/imx8-apalis-ixora-v1.1.dtsi
index 7022de46b8bff..abb131d247c30 100644
--- a/arch/arm64/boot/dts/freescale/imx8-apalis-ixora-v1.1.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8-apalis-ixora-v1.1.dtsi
@@ -21,6 +21,7 @@ led-1 {
 			color = <LED_COLOR_ID_GREEN>;
 			default-state = "off";
 			function = LED_FUNCTION_STATUS;
+			function-enumerator = <1>;
 			gpios = <&lsio_gpio5 27 GPIO_ACTIVE_HIGH>;
 		};
 
@@ -29,6 +30,7 @@ led-2 {
 			color = <LED_COLOR_ID_RED>;
 			default-state = "off";
 			function = LED_FUNCTION_STATUS;
+			function-enumerator = <1>;
 			gpios = <&lsio_gpio5 29 GPIO_ACTIVE_HIGH>;
 		};
 
@@ -37,6 +39,7 @@ led-3 {
 			color = <LED_COLOR_ID_GREEN>;
 			default-state = "off";
 			function = LED_FUNCTION_STATUS;
+			function-enumerator = <2>;
 			gpios = <&lsio_gpio5 20 GPIO_ACTIVE_HIGH>;
 		};
 
@@ -45,6 +48,7 @@ led-4 {
 			color = <LED_COLOR_ID_RED>;
 			default-state = "off";
 			function = LED_FUNCTION_STATUS;
+			function-enumerator = <2>;
 			gpios = <&lsio_gpio5 21 GPIO_ACTIVE_HIGH>;
 		};
 	};
diff --git a/arch/arm64/boot/dts/freescale/imx8-apalis-ixora-v1.2.dtsi b/arch/arm64/boot/dts/freescale/imx8-apalis-ixora-v1.2.dtsi
index 12732ed7f8119..a0b452b92b3e6 100644
--- a/arch/arm64/boot/dts/freescale/imx8-apalis-ixora-v1.2.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8-apalis-ixora-v1.2.dtsi
@@ -21,6 +21,7 @@ led-1 {
 			color = <LED_COLOR_ID_GREEN>;
 			default-state = "off";
 			function = LED_FUNCTION_STATUS;
+			function-enumerator = <1>;
 			gpios = <&lsio_gpio5 27 GPIO_ACTIVE_HIGH>;
 		};
 
@@ -29,6 +30,7 @@ led-2 {
 			color = <LED_COLOR_ID_RED>;
 			default-state = "off";
 			function = LED_FUNCTION_STATUS;
+			function-enumerator = <1>;
 			gpios = <&lsio_gpio5 29 GPIO_ACTIVE_HIGH>;
 		};
 
@@ -37,6 +39,7 @@ led-3 {
 			color = <LED_COLOR_ID_GREEN>;
 			default-state = "off";
 			function = LED_FUNCTION_STATUS;
+			function-enumerator = <2>;
 			gpios = <&lsio_gpio5 20 GPIO_ACTIVE_HIGH>;
 		};
 
@@ -45,6 +48,7 @@ led-4 {
 			color = <LED_COLOR_ID_RED>;
 			default-state = "off";
 			function = LED_FUNCTION_STATUS;
+			function-enumerator = <2>;
 			gpios = <&lsio_gpio5 21 GPIO_ACTIVE_HIGH>;
 		};
 	};
-- 
2.53.0



