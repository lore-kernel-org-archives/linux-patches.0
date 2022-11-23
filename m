Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823C57B
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 08:55:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E97F1C433C1;
	Wed, 23 Nov 2022 08:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669193714;
	bh=zK2F6Mw2zBftqEBOqdpTfrRakmhduoWXjU7wPDMpOGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zG8OiT/B5fbUHEKyM6p2gyTIntVAErlo29Zu5YA/JMu7RQyP26qjnxm6ClqaYFZC1
	 Rzhu86nAQShK/gV+NQfiVt3ow7j0EBzkAHlqpIGPj2TnsP0B4JuuwxsxrhLK7Wlluz
	 hjwjG0nSMqRzTuvDureZ7LyQ/27jB5ULevx7DHyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@microchip.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 4.9 23/76] dmaengine: at_hdmac: Fix at_lli struct definition
Date: Wed, 23 Nov 2022 09:50:22 +0100
Message-Id: <20221123084547.486278174@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084546.742331901@linuxfoundation.org>
References: <20221123084546.742331901@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tudor Ambarus <tudor.ambarus@microchip.com>

commit f1171bbdd2ba2a50ee64bb198a78c268a5baf5f1 upstream.

Those hardware registers are all of 32 bits, while dma_addr_t ca be of
type u64 or u32 depending on CONFIG_ARCH_DMA_ADDR_T_64BIT. Force u32 to
comply with what the hardware expects.

Fixes: dc78baa2b90b ("dmaengine: at_hdmac: new driver for the Atmel AHB DMA Controller")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: stable@vger.kernel.org
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20221025090306.297886-1-tudor.ambarus@microchip.com
Link: https://lore.kernel.org/r/20221025090306.297886-2-tudor.ambarus@microchip.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/at_hdmac_regs.h |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/dma/at_hdmac_regs.h
+++ b/drivers/dma/at_hdmac_regs.h
@@ -168,13 +168,13 @@
 /* LLI == Linked List Item; aka DMA buffer descriptor */
 struct at_lli {
 	/* values that are not changed by hardware */
-	dma_addr_t	saddr;
-	dma_addr_t	daddr;
+	u32 saddr;
+	u32 daddr;
 	/* value that may get written back: */
-	u32		ctrla;
+	u32 ctrla;
 	/* more values that are not changed by hardware */
-	u32		ctrlb;
-	dma_addr_t	dscr;	/* chain to next lli */
+	u32 ctrlb;
+	u32 dscr;	/* chain to next lli */
 };
 
 /**


