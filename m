Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B741B1F75B6;
	Tue,  3 Dec 2024 15:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240369; cv=none; b=UKTFhpawJ0Wa6NQ44X9mf9J1WyzmmEeWDUs0nCIvKQqL+braVtDvQ4fH4L1UtrMM5OjeyLUXiVYgm7P2DCrR0KnBp4jZTo3yQjf/OdnjnUCYcWSOPsv9/ERB0CCr6L1oHFM75zilnrj6dBfSYdQUn/fHPl1DkuD0+hTuqcGtuHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240369; c=relaxed/simple;
	bh=16osrepvjEBUSbonblMeDkHIPwcH5T+z/r7KL6j2P6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z97MvtAHvUITj4TQGF638NByQXwurUbrFj9gbCqpzl0Uuq7WZ30CMjGNc3IVL9PYoBY+CJ2psrPm0Um13sBrSQooU1Dm6iavwRhq0LdFmmUTGOR7XX/2d6SNSt7yC0481c4jOCdfcP3yeC92mTirGFfsvYvPCld7lyCYEiqws44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=opkmhdhz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="opkmhdhz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 429C2C4CECF;
	Tue,  3 Dec 2024 15:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240366;
	bh=16osrepvjEBUSbonblMeDkHIPwcH5T+z/r7KL6j2P6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=opkmhdhz+xVySwd/uupC6pVs+/UiNvxsCZMfx1bYIAIUOCdsWpAHSMwDfNfITDz5E
	 N3v42g9MmZFUkA3nq8hdh4Ig33E8zOykCFmwRE1d9cLHnF5sxpTkhpy5pwTSSH/4Pp
	 nDTHNYX4Bv4KprJsdgeEDhfUJaQkgb+5Oq2WwkPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Andrei Simion <andrei.simion@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 115/826] ARM: dts: microchip: sam9x60: Add missing property atmel,usart-mode
Date: Tue,  3 Dec 2024 15:37:22 +0100
Message-ID: <20241203144748.227437661@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrei Simion <andrei.simion@microchip.com>

[ Upstream commit 2f9d013a0c6f1b9109ada5acb28ee26eefc77c03 ]

Add the atmel,usart-mode property to the UART nodes. This ensures
compliance with the atmel,at91-usart.yaml schema and resolves the errors
below:
serial@200: $nodename:0: 'serial@200' does not match
'^spi(@.*|-([0-9]|[1-9][0-9]+))?$'
serial@200: atmel,use-dma-rx: False schema does not allow True
serial@200: atmel,use-dma-tx: False schema does not allow True
serial@200: atmel,fifo-size: False schema does not allow [[16]]

These errors indicate that the property
atmel,usart-mode = <AT91_USART_MODE_SERIAL> is missing for
UART nodes 0, 1, 2, 3, 4, 6, 7, 8, 9, 10, 11, and 12.

Fixes: 99c808335877 ("ARM: dts: at91: sam9x60: Add missing flexcom definitions")
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Signed-off-by: Andrei Simion <andrei.simion@microchip.com>
Link: https://lore.kernel.org/r/20240912093307.40488-1-andrei.simion@microchip.com
[claudiu.beznea: move the atmel,usart-mode close to vendor specific
 properties to cope with DTS coding style]
Signed-off-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/microchip/sam9x60.dtsi | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/boot/dts/microchip/sam9x60.dtsi b/arch/arm/boot/dts/microchip/sam9x60.dtsi
index 04a6d716ecaf8..1e8fcb5d4700d 100644
--- a/arch/arm/boot/dts/microchip/sam9x60.dtsi
+++ b/arch/arm/boot/dts/microchip/sam9x60.dtsi
@@ -186,6 +186,7 @@ AT91_XDMAC_DT_PER_IF(1) |
 					dma-names = "tx", "rx";
 					clocks = <&pmc PMC_TYPE_PERIPHERAL 13>;
 					clock-names = "usart";
+					atmel,usart-mode = <AT91_USART_MODE_SERIAL>;
 					atmel,use-dma-rx;
 					atmel,use-dma-tx;
 					atmel,fifo-size = <16>;
@@ -388,6 +389,7 @@ AT91_XDMAC_DT_PER_IF(1) |
 					dma-names = "tx", "rx";
 					clocks = <&pmc PMC_TYPE_PERIPHERAL 32>;
 					clock-names = "usart";
+					atmel,usart-mode = <AT91_USART_MODE_SERIAL>;
 					atmel,use-dma-rx;
 					atmel,use-dma-tx;
 					atmel,fifo-size = <16>;
@@ -439,6 +441,7 @@ AT91_XDMAC_DT_PER_IF(1) |
 					dma-names = "tx", "rx";
 					clocks = <&pmc PMC_TYPE_PERIPHERAL 33>;
 					clock-names = "usart";
+					atmel,usart-mode = <AT91_USART_MODE_SERIAL>;
 					atmel,use-dma-rx;
 					atmel,use-dma-tx;
 					atmel,fifo-size = <16>;
@@ -598,6 +601,7 @@ AT91_XDMAC_DT_PER_IF(1) |
 					dma-names = "tx", "rx";
 					clocks = <&pmc PMC_TYPE_PERIPHERAL 9>;
 					clock-names = "usart";
+					atmel,usart-mode = <AT91_USART_MODE_SERIAL>;
 					atmel,use-dma-rx;
 					atmel,use-dma-tx;
 					atmel,fifo-size = <16>;
@@ -649,6 +653,7 @@ AT91_XDMAC_DT_PER_IF(1) |
 					dma-names = "tx", "rx";
 					clocks = <&pmc PMC_TYPE_PERIPHERAL 10>;
 					clock-names = "usart";
+					atmel,usart-mode = <AT91_USART_MODE_SERIAL>;
 					atmel,use-dma-rx;
 					atmel,use-dma-tx;
 					atmel,fifo-size = <16>;
@@ -700,6 +705,7 @@ AT91_XDMAC_DT_PER_IF(1) |
 					dma-names = "tx", "rx";
 					clocks = <&pmc PMC_TYPE_PERIPHERAL 11>;
 					clock-names = "usart";
+					atmel,usart-mode = <AT91_USART_MODE_SERIAL>;
 					atmel,use-dma-rx;
 					atmel,use-dma-tx;
 					atmel,fifo-size = <16>;
@@ -751,6 +757,7 @@ AT91_XDMAC_DT_PER_IF(1) |
 					dma-names = "tx", "rx";
 					clocks = <&pmc PMC_TYPE_PERIPHERAL 5>;
 					clock-names = "usart";
+					atmel,usart-mode = <AT91_USART_MODE_SERIAL>;
 					atmel,use-dma-rx;
 					atmel,use-dma-tx;
 					atmel,fifo-size = <16>;
@@ -821,6 +828,7 @@ AT91_XDMAC_DT_PER_IF(1) |
 					dma-names = "tx", "rx";
 					clocks = <&pmc PMC_TYPE_PERIPHERAL 6>;
 					clock-names = "usart";
+					atmel,usart-mode = <AT91_USART_MODE_SERIAL>;
 					atmel,use-dma-rx;
 					atmel,use-dma-tx;
 					atmel,fifo-size = <16>;
@@ -891,6 +899,7 @@ AT91_XDMAC_DT_PER_IF(1) |
 					dma-names = "tx", "rx";
 					clocks = <&pmc PMC_TYPE_PERIPHERAL 7>;
 					clock-names = "usart";
+					atmel,usart-mode = <AT91_USART_MODE_SERIAL>;
 					atmel,use-dma-rx;
 					atmel,use-dma-tx;
 					atmel,fifo-size = <16>;
@@ -961,6 +970,7 @@ AT91_XDMAC_DT_PER_IF(1) |
 					dma-names = "tx", "rx";
 					clocks = <&pmc PMC_TYPE_PERIPHERAL 8>;
 					clock-names = "usart";
+					atmel,usart-mode = <AT91_USART_MODE_SERIAL>;
 					atmel,use-dma-rx;
 					atmel,use-dma-tx;
 					atmel,fifo-size = <16>;
@@ -1086,6 +1096,7 @@ AT91_XDMAC_DT_PER_IF(1) |
 					dma-names = "tx", "rx";
 					clocks = <&pmc PMC_TYPE_PERIPHERAL 15>;
 					clock-names = "usart";
+					atmel,usart-mode = <AT91_USART_MODE_SERIAL>;
 					atmel,use-dma-rx;
 					atmel,use-dma-tx;
 					atmel,fifo-size = <16>;
@@ -1137,6 +1148,7 @@ AT91_XDMAC_DT_PER_IF(1) |
 					dma-names = "tx", "rx";
 					clocks = <&pmc PMC_TYPE_PERIPHERAL 16>;
 					clock-names = "usart";
+					atmel,usart-mode = <AT91_USART_MODE_SERIAL>;
 					atmel,use-dma-rx;
 					atmel,use-dma-tx;
 					atmel,fifo-size = <16>;
-- 
2.43.0



