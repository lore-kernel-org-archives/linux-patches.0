Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C9E1F7560;
	Tue,  3 Dec 2024 15:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238081; cv=none; b=ZiB8LNY4iARPYvMBx9bzzfUCOx5Xj0ZGZKC4IQepx2zJ0HxoNUMx3JUuB3oZVoLdPHed56AbW0IwwcYJdYt2ko8n0Gq6AvPItdpBRmEnjxuIWv2z49vDBvHhdHC99jBTpf2RmQosgclICYFTjx+4hC0/f5mk8zCeOLKthgb1oVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238081; c=relaxed/simple;
	bh=u+LcLIgfB0NTNEA/kmZWARU9KEbDN4Mx+Jv32bsqGzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fW48SDl13NaTObM3c+dgHS1hebiMhK9mHL8fIauG3Y4LBzWONA7k4aOx5NB0aEaAYCE1rViX6Cq0DSVadM9KDIXKucVgqoWeBbuY/wlD3WxqyhSgZm5+cLnbQ4taV+R4vnX3w6ISnvzICWy85c+l+Fu4VAF5I14iuKwyeEXpHlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G+8WfGIY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G+8WfGIY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B7B0C4CED6;
	Tue,  3 Dec 2024 15:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238079;
	bh=u+LcLIgfB0NTNEA/kmZWARU9KEbDN4Mx+Jv32bsqGzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G+8WfGIYYpGSCcxv+p+EXSVRsmOvUFKkLN3NsUiK0ZudPcOPTwU25qvDFTm+5Fx8V
	 r9rm1rPvoL45f0zPanRs4JGAbvuLy8lIMkXtzTIZAhnMMFgdKoCyYh7ZgfdbmpQqkD
	 Ki1ePdBWOvtIsl1EdNyaqRK3/iEQButFJlYyjumc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Andrei Simion <andrei.simion@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 154/817] ARM: dts: microchip: sam9x60: Add missing property atmel,usart-mode
Date: Tue,  3 Dec 2024 15:35:26 +0100
Message-ID: <20241203144001.737109523@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index d077afd5024db..2492cd14c4e78 100644
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
@@ -384,6 +385,7 @@ AT91_XDMAC_DT_PER_IF(1) |
 					dma-names = "tx", "rx";
 					clocks = <&pmc PMC_TYPE_PERIPHERAL 32>;
 					clock-names = "usart";
+					atmel,usart-mode = <AT91_USART_MODE_SERIAL>;
 					atmel,use-dma-rx;
 					atmel,use-dma-tx;
 					atmel,fifo-size = <16>;
@@ -433,6 +435,7 @@ AT91_XDMAC_DT_PER_IF(1) |
 					dma-names = "tx", "rx";
 					clocks = <&pmc PMC_TYPE_PERIPHERAL 33>;
 					clock-names = "usart";
+					atmel,usart-mode = <AT91_USART_MODE_SERIAL>;
 					atmel,use-dma-rx;
 					atmel,use-dma-tx;
 					atmel,fifo-size = <16>;
@@ -590,6 +593,7 @@ AT91_XDMAC_DT_PER_IF(1) |
 					dma-names = "tx", "rx";
 					clocks = <&pmc PMC_TYPE_PERIPHERAL 9>;
 					clock-names = "usart";
+					atmel,usart-mode = <AT91_USART_MODE_SERIAL>;
 					atmel,use-dma-rx;
 					atmel,use-dma-tx;
 					atmel,fifo-size = <16>;
@@ -639,6 +643,7 @@ AT91_XDMAC_DT_PER_IF(1) |
 					dma-names = "tx", "rx";
 					clocks = <&pmc PMC_TYPE_PERIPHERAL 10>;
 					clock-names = "usart";
+					atmel,usart-mode = <AT91_USART_MODE_SERIAL>;
 					atmel,use-dma-rx;
 					atmel,use-dma-tx;
 					atmel,fifo-size = <16>;
@@ -688,6 +693,7 @@ AT91_XDMAC_DT_PER_IF(1) |
 					dma-names = "tx", "rx";
 					clocks = <&pmc PMC_TYPE_PERIPHERAL 11>;
 					clock-names = "usart";
+					atmel,usart-mode = <AT91_USART_MODE_SERIAL>;
 					atmel,use-dma-rx;
 					atmel,use-dma-tx;
 					atmel,fifo-size = <16>;
@@ -737,6 +743,7 @@ AT91_XDMAC_DT_PER_IF(1) |
 					dma-names = "tx", "rx";
 					clocks = <&pmc PMC_TYPE_PERIPHERAL 5>;
 					clock-names = "usart";
+					atmel,usart-mode = <AT91_USART_MODE_SERIAL>;
 					atmel,use-dma-rx;
 					atmel,use-dma-tx;
 					atmel,fifo-size = <16>;
@@ -805,6 +812,7 @@ AT91_XDMAC_DT_PER_IF(1) |
 					dma-names = "tx", "rx";
 					clocks = <&pmc PMC_TYPE_PERIPHERAL 6>;
 					clock-names = "usart";
+					atmel,usart-mode = <AT91_USART_MODE_SERIAL>;
 					atmel,use-dma-rx;
 					atmel,use-dma-tx;
 					atmel,fifo-size = <16>;
@@ -873,6 +881,7 @@ AT91_XDMAC_DT_PER_IF(1) |
 					dma-names = "tx", "rx";
 					clocks = <&pmc PMC_TYPE_PERIPHERAL 7>;
 					clock-names = "usart";
+					atmel,usart-mode = <AT91_USART_MODE_SERIAL>;
 					atmel,use-dma-rx;
 					atmel,use-dma-tx;
 					atmel,fifo-size = <16>;
@@ -941,6 +950,7 @@ AT91_XDMAC_DT_PER_IF(1) |
 					dma-names = "tx", "rx";
 					clocks = <&pmc PMC_TYPE_PERIPHERAL 8>;
 					clock-names = "usart";
+					atmel,usart-mode = <AT91_USART_MODE_SERIAL>;
 					atmel,use-dma-rx;
 					atmel,use-dma-tx;
 					atmel,fifo-size = <16>;
@@ -1064,6 +1074,7 @@ AT91_XDMAC_DT_PER_IF(1) |
 					dma-names = "tx", "rx";
 					clocks = <&pmc PMC_TYPE_PERIPHERAL 15>;
 					clock-names = "usart";
+					atmel,usart-mode = <AT91_USART_MODE_SERIAL>;
 					atmel,use-dma-rx;
 					atmel,use-dma-tx;
 					atmel,fifo-size = <16>;
@@ -1113,6 +1124,7 @@ AT91_XDMAC_DT_PER_IF(1) |
 					dma-names = "tx", "rx";
 					clocks = <&pmc PMC_TYPE_PERIPHERAL 16>;
 					clock-names = "usart";
+					atmel,usart-mode = <AT91_USART_MODE_SERIAL>;
 					atmel,use-dma-rx;
 					atmel,use-dma-tx;
 					atmel,fifo-size = <16>;
-- 
2.43.0



