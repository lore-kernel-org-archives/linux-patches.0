Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812473AE74
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:30:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 025F5C433D2;
	Wed,  7 Jun 2023 20:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169858;
	bh=nWN8z/d4GJCgWuafYCOHvx1gY5KP2aGcIw2VeB8LUl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mJ1kitt0TZF3JAg736RI2+nKeO6/rSjIe1yiMubXLCXHxSPDypJq34zrsmZpi2RmU
	 8Kyt0mup1E84So5qH3HnZtWuonwL06ZiIuBwY5nLW6EiKNLpwQZYZA73uZDxomvTh1
	 FHENGJK/+nfjgKjeGjCq6q1d3fbCHL9FqSYEESfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Peter Rosin <peda@axentia.se>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.3 241/286] dmaengine: at_hdmac: Extend the Flow Controller bitfield to three bits
Date: Wed,  7 Jun 2023 22:15:40 +0200
Message-ID: <20230607200931.160192024@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Peter Rosin <peda@axentia.se>

commit e14fd2af7a1d621c167dad761f729135a7a76ff4 upstream.

Some chips have two bits (e.g SAMA5D3), and some have three (e.g.
SAM9G45). A field width of three is compatible as long as valid
values are used for the different chips.

There is no current use of any value needing three bits, so the
fixed bug is relatively benign.

Fixes: d8840a7edcf0 ("dmaengine: at_hdmac: Use bitfield access macros")
Cc: stable@vger.kernel.org
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Peter Rosin <peda@axentia.se>
Link: https://lore.kernel.org/r/e2c898ba-c3a3-5dd3-384b-0585661c79f2@axentia.se
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/at_hdmac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 6362013b90df..ee3a219e3a89 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -132,7 +132,7 @@
 #define ATC_DST_PIP		BIT(12)		/* Destination Picture-in-Picture enabled */
 #define ATC_SRC_DSCR_DIS	BIT(16)		/* Src Descriptor fetch disable */
 #define ATC_DST_DSCR_DIS	BIT(20)		/* Dst Descriptor fetch disable */
-#define ATC_FC			GENMASK(22, 21)	/* Choose Flow Controller */
+#define ATC_FC			GENMASK(23, 21)	/* Choose Flow Controller */
 #define ATC_FC_MEM2MEM		0x0		/* Mem-to-Mem (DMA) */
 #define ATC_FC_MEM2PER		0x1		/* Mem-to-Periph (DMA) */
 #define ATC_FC_PER2MEM		0x2		/* Periph-to-Mem (DMA) */
-- 
2.41.0



