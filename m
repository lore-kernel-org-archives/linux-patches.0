Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7AF1D0412;
	Wed,  2 Oct 2024 14:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878952; cv=none; b=Te9pu2EAneUbas8YvvT2w+oEAVUc9MMzTiP5UofcVGoFH+Hxz4bGaFp6a6phrXpi7RAXK9EjHzKQyWTaO5NYVk6V0VEhwoJca8E8Ek9PwGW9k9JKQIF/3/olKV1VTymFL5gCN+Mu7ym08ylmuWJsBcd9Sy5ZADWeg80r305zhSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878952; c=relaxed/simple;
	bh=ebdABd7XazoCiDK4pfQdqxjvKOCf0HbORPfi6bIMmGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B1VtyYXSqZGFxZhVIaxuvVCrgY8GquKdF5Tnn8/sJmwmcTxa9xVyO52R7ZZzN5Kprp04wT5GHxCfGKRBLl1hvO+JnImalvz4medleMeVCotOb2URdz7a1yATmSgubrUmZO7E7HO9U/1ApfrZqoNKmAy9Uzf+iKjEV+5967t3CVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c1SjI+/N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c1SjI+/N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1387EC4CEC2;
	Wed,  2 Oct 2024 14:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878952;
	bh=ebdABd7XazoCiDK4pfQdqxjvKOCf0HbORPfi6bIMmGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c1SjI+/NRKFtjXdtSLKum2Hblc4Cn06YQ0Nbk6TtKfesUgHCWEsMKpvU0v34ITnxL
	 FsYBzueRvUtU7xjsg/zVinM6abTN2jrheg9xLBrSHS4W66O3r/xlwxFDJYUY95IPdN
	 u0uadxC8wSk2DViSoa98rgs2rhcRvxcJRDpeGaz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Parthiban Nallathambi <parthiban@linumiz.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.10 589/634] ARM: dts: imx6ull-seeed-npi: fix fsl,pins property in tscgrp pinctrl
Date: Wed,  2 Oct 2024 15:01:29 +0200
Message-ID: <20241002125834.364080177@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 3dedd4889cfc2851444a1f7626b293c0bfd1e42c upstream.

The property is "fsl,pins", not "fsl,pin".  Wrong property means the pin
configuration was not applied.  Fixes dtbs_check warnings:

  imx6ull-seeed-npi-dev-board-emmc.dtb: pinctrl@20e0000: uart1grp: 'fsl,pins' is a required property
  imx6ull-seeed-npi-dev-board-emmc.dtb: pinctrl@20e0000: uart1grp: 'fsl,pin' does not match any of the regexes: 'pinctrl-[0-9]+'

Cc: stable@vger.kernel.org
Fixes: e3b5697195c8 ("ARM: dts: imx6ull: add seeed studio NPi dev board")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Parthiban Nallathambi <parthiban@linumiz.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../dts/nxp/imx/imx6ull-seeed-npi-dev-board.dtsi     | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/nxp/imx/imx6ull-seeed-npi-dev-board.dtsi b/arch/arm/boot/dts/nxp/imx/imx6ull-seeed-npi-dev-board.dtsi
index 6bb12e0bbc7e..50654dbf62e0 100644
--- a/arch/arm/boot/dts/nxp/imx/imx6ull-seeed-npi-dev-board.dtsi
+++ b/arch/arm/boot/dts/nxp/imx/imx6ull-seeed-npi-dev-board.dtsi
@@ -339,14 +339,14 @@ MX6UL_PAD_JTAG_TRST_B__SAI2_TX_DATA	0x120b0
 	};
 
 	pinctrl_uart1: uart1grp {
-		fsl,pin = <
+		fsl,pins = <
 			MX6UL_PAD_UART1_TX_DATA__UART1_DCE_TX	0x1b0b1
 			MX6UL_PAD_UART1_RX_DATA__UART1_DCE_RX	0x1b0b1
 		>;
 	};
 
 	pinctrl_uart2: uart2grp {
-		fsl,pin = <
+		fsl,pins = <
 			MX6UL_PAD_UART2_TX_DATA__UART2_DCE_TX	0x1b0b1
 			MX6UL_PAD_UART2_RX_DATA__UART2_DCE_RX	0x1b0b1
 			MX6UL_PAD_UART2_CTS_B__UART2_DCE_CTS	0x1b0b1
@@ -355,7 +355,7 @@ MX6UL_PAD_UART2_RTS_B__UART2_DCE_RTS	0x1b0b1
 	};
 
 	pinctrl_uart3: uart3grp {
-		fsl,pin = <
+		fsl,pins = <
 			MX6UL_PAD_UART3_TX_DATA__UART3_DCE_TX	0x1b0b1
 			MX6UL_PAD_UART3_RX_DATA__UART3_DCE_RX	0x1b0b1
 			MX6UL_PAD_UART3_CTS_B__UART3_DCE_CTS	0x1b0b1
@@ -364,21 +364,21 @@ MX6UL_PAD_UART3_RTS_B__UART3_DCE_RTS	0x1b0b1
 	};
 
 	pinctrl_uart4: uart4grp {
-		fsl,pin = <
+		fsl,pins = <
 			MX6UL_PAD_UART4_TX_DATA__UART4_DCE_TX	0x1b0b1
 			MX6UL_PAD_UART4_RX_DATA__UART4_DCE_RX	0x1b0b1
 		>;
 	};
 
 	pinctrl_uart5: uart5grp {
-		fsl,pin = <
+		fsl,pins = <
 			MX6UL_PAD_UART5_TX_DATA__UART5_DCE_TX	0x1b0b1
 			MX6UL_PAD_UART5_RX_DATA__UART5_DCE_RX	0x1b0b1
 		>;
 	};
 
 	pinctrl_usb_otg1_id: usbotg1idgrp {
-		fsl,pin = <
+		fsl,pins = <
 			MX6UL_PAD_GPIO1_IO00__ANATOP_OTG1_ID	0x17059
 		>;
 	};
-- 
2.46.2



