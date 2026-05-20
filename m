Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C86A73FA5FC;
	Wed, 20 May 2026 18:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300679; cv=none; b=JmnH8kRb6FZbU2SEA6pYVEbvJC1decfTN9zgjKTTmBGdYD11In+sCbp9rCVWapzeYNGLwAmloxTX2QaNyVsdv7wJgII08phdMhyhKkoQrZ31UFtiRb0bOA/MPPFqpGgWFDYuYsYrWZ9uUSzXEkVJQDr/5GSMJxwAjQ/X5y4r1gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300679; c=relaxed/simple;
	bh=KhqI9VNqImHEwSSsphC6nXDyN4HzosmaiUced3VUQZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Suqs0V5NT5K24U9TYDQDqRAK4pTikZLLkYo04ZgXMYqU+4IaY8WzSK43j+8AmdDxknGJD2e73kuQaW6HWHBtcvv+/wbxvLuIoAE9HG9Ct0keX4fmVjaNNpB11S9zPmAl4Dosljdhl71dX/GKwsku6WGac6cA8aDya0DutI9P7gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gsbtyzK1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gsbtyzK1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39CDD1F000E9;
	Wed, 20 May 2026 18:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300677;
	bh=bl9Mg/pq+MJsTTUPK5+C74jLLvmAQ+qE8bycPlAxXQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gsbtyzK1nYmt7o3ZjwF5bfWNQh9dsxrLV7wvlFPTBiOmnSqIoOsNoZ2+JLQAkqyZ1
	 ajUUcXZOiIngg9jKmlYjD5Ndeu3yxQcACElNYeizsbLGv3XSKuz70B9GC2k9le0aao
	 Yay5iWou1L2cvNB4b4yf8lK6Ezt8GoaIPH+qs5js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Frank Li <Frank.Li@nxp.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 267/666] arm64: dts: imx8-apalis: Fix LEDs name collision
Date: Wed, 20 May 2026 18:17:58 +0200
Message-ID: <20260520162117.003723108@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5438923a905ce..5dc12da72dd2e 100644
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
index f6654fdcb1478..f3111bf03a4de 100644
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



