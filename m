Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B90C335073;
	Mon, 29 Dec 2025 16:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767026033; cv=none; b=aFJ0VdLjrdKdd7+tZtl0rdWIJM6uHIIj7eLmmuStBIUFwFlqY6WHLxmfgF5T4PyG8l8E3r9eqJPtByfbEHc8BYbMXiTvHb5qnExibF2T9gDzsf5RtOdVc3FcV0n2Azxr9NpVo4SX6ei6zXRH76dF3H6tnofLZibFlzAijcuWlCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767026033; c=relaxed/simple;
	bh=MCFvaPmLgfZ/vG4pZWWnBpOHaPi7v96yv+EjOVgZX4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jq0ZS5BXolOmzY/pipIh6hWBpOYsbsANaVbmmrYr4QGGAks7JzjTaOlCzBBn3t6bBhdZwIoLxYze4XW+lEPCSR0VF1KdH3LPFF09UKVlSTl+z4+EQikaa/MrZg4kpL3yG8ajR1yeqXM19pjMSI13hV+it29QwFz7/hbi4dKvIr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AirFdX/E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AirFdX/E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C486C4CEF7;
	Mon, 29 Dec 2025 16:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767026033;
	bh=MCFvaPmLgfZ/vG4pZWWnBpOHaPi7v96yv+EjOVgZX4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AirFdX/EEGNF9bgZv1+sPqYpxGFWpouwk+1plAJm9QQsMFnXza12mvgg7M/xVDNXN
	 1ahMAMguNJclTBwFQZHH55hlQYJ8Jeeq6gng9pCSPDThYGIkIWl+4pvHn+oXrypIxm
	 q1Yh2BZJp+JJkemWg0GHjcl6ZD3uBZJC+n4P2Xyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>
Subject: [PATCH 6.18 424/430] ARM: dts: microchip: sama7d65: fix uart fifo size to 32
Date: Mon, 29 Dec 2025 17:13:46 +0100
Message-ID: <20251229160739.915498165@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Nicolas Ferre <nicolas.ferre@microchip.com>

commit 1f591be0a02c697f65a21be35f1d74117bbf4be2 upstream.

On some flexcom nodes related to uart, the fifo sizes were wrong: fix
them to 32 data.  Note that product datasheet is being reviewed to fix
inconsistency, but this value is validated by product's designers.

Fixes: 261dcfad1b59 ("ARM: dts: microchip: add sama7d65 SoC DT")
Fixes: b51e4aea3ecf ("ARM: dts: microchip: sama7d65: Add FLEXCOMs to sama7d65 SoC")
Cc: stable@vger.kernel.org # 6.16+
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20251114103313.20220-1-nicolas.ferre@microchip.com
Signed-off-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/microchip/sama7d65.dtsi |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm/boot/dts/microchip/sama7d65.dtsi
+++ b/arch/arm/boot/dts/microchip/sama7d65.dtsi
@@ -557,7 +557,7 @@
 				dma-names = "tx", "rx";
 				atmel,use-dma-rx;
 				atmel,use-dma-tx;
-				atmel,fifo-size = <16>;
+				atmel,fifo-size = <32>;
 				atmel,usart-mode = <AT91_USART_MODE_SERIAL>;
 				status = "disabled";
 			};
@@ -618,7 +618,7 @@
 				clocks = <&pmc PMC_TYPE_PERIPHERAL 40>;
 				clock-names = "usart";
 				atmel,usart-mode = <AT91_USART_MODE_SERIAL>;
-				atmel,fifo-size = <16>;
+				atmel,fifo-size = <32>;
 				status = "disabled";
 			};
 		};
@@ -643,7 +643,7 @@
 				dma-names = "tx", "rx";
 				atmel,use-dma-rx;
 				atmel,use-dma-tx;
-				atmel,fifo-size = <16>;
+				atmel,fifo-size = <32>;
 				atmel,usart-mode = <AT91_USART_MODE_SERIAL>;
 				status = "disabled";
 			};


