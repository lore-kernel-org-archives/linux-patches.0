Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041718;
	b=Ao4/pJuL9cKuqR2P5NEhFvB7kJfCLSP9Z7/4+2r+N0sm7UQtVzTjMIiYo8+QpNVvHvVC
	 Q58z+wq/GYWsdGJBhYU4/6qTnTFIigB48LF5K1UYu9UDWGPih12tyJJDxeXBiNgRVPVrt
	 nSTQc89uJgw+b5irBolkAZicy368WHvKdBVsryA9eb8sXbz8dm6c4XcEaesclhRbDN3AU
	 XzkyARscfttmGo7JHDWurZZQr7vyllziSxdeepkbiKsVB/XF5ifpwGK0WfpdBCxIEPc/2
	 JXCU10GkIeuptvgKFWFe2YgZ75F2IXr7+TFtm7i/AE/z42GqmAKJjQp9dGiAYAl+JXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041718;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Sr462d6i51O1peS9k5FrvFXf0eRNkoISZ20UnYfIZlc=;
	b=yFiEjtj1HIdFt+VBBc/mHcGbNbO92UMV48RNKzb5qqKedYrEayhgx1jwcPVlz2FM5kIQ
	 4t3Z8uCeEBNx/LC5vwCFsPjtyoE5wPx686lhvSTY28lPAtgpiev1vUXiOUo8iQtmXkNEB
	 nzDWsF+2Osi7eiDcFeGzdOtzLOasFxXMjgjtfxVDiQmvug6YjaI8NUQ8DUYRVdnVK+oh0
	 bdQQ/wBKGcjmJsz01L55ydT9k4WSfw+/PoaD8BXs/P5ZkyRCoUUf/D7tiYr3zOP3Tfhme
	 XNUPROr0Lw/cCzgCMJ++sIYv523bLiMn4VkeeNbdbMXO3Bkov8Y4d6Ug/1z4ihv1qiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R5EinFUP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA4A4606A325;
	Wed, 18 Nov 2026 22:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R5EinFUP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 459771F000C4;
	Wed, 18 Nov 2026 22:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041718;
	bh=Sr462d6i51O1peS9k5FrvFXf0eRNkoISZ20UnYfIZlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R5EinFUP4tMfMk+dHT33Mu1HBcdTBm9IJrlDK5T9lkn5eJr+4/6FPQbYQPhrFR1qz
	 0MxOGxI4ELnOxMK9ZGNvr8SiWEEwypcvMTNmaTwtsDkWZhE57ntJUi5Nd2BiXlbw9d
	 Ba7i/tMAwvtD1RaJlhUQ/493ytl9oiFzqUC/32Aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Serge Semin <fancer.lancer@gmail.com>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.6 2914/3318] spi: omap2-mcspi: Use new spi_xfer_is_dma_mapped() helper
Date: Wed, 18 Nov 2026 15:58:56 +0100
Message-ID: <20261118150447.862239332@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 6361b4e4f7a43dd5d8e3f2d2ece8148f30b55cb3 ]

Replace a few lines of code by calling a spi_xfer_is_dma_mapped() helper.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8650-QRD
Link: https://lore.kernel.org/r/20240531194723.1761567-5-andriy.shevchenko@linux.intel.com
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Tested-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: c126e07bde21 ("spi: omap2-mcspi: handle DMA setup failures")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-omap2-mcspi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-omap2-mcspi.c b/drivers/spi/spi-omap2-mcspi.c
index 0d8aaf8c5ed0e..97409a4384694 100644
--- a/drivers/spi/spi-omap2-mcspi.c
+++ b/drivers/spi/spi-omap2-mcspi.c
@@ -27,6 +27,8 @@
 
 #include <linux/spi/spi.h>
 
+#include "internals.h"
+
 #include <linux/platform_data/spi-omap2-mcspi.h>
 
 #define OMAP2_MCSPI_MAX_FREQ		48000000
@@ -1204,8 +1206,7 @@ static int omap2_mcspi_transfer_one(struct spi_controller *ctlr,
 		unsigned	count;
 
 		if ((mcspi_dma->dma_rx && mcspi_dma->dma_tx) &&
-		    ctlr->cur_msg_mapped &&
-		    ctlr->can_dma(ctlr, spi, t))
+		    spi_xfer_is_dma_mapped(ctlr, spi, t))
 			omap2_mcspi_set_fifo(spi, t, 1);
 
 		omap2_mcspi_set_enable(spi, 1);
@@ -1216,8 +1217,7 @@ static int omap2_mcspi_transfer_one(struct spi_controller *ctlr,
 					+ OMAP2_MCSPI_TX0);
 
 		if ((mcspi_dma->dma_rx && mcspi_dma->dma_tx) &&
-		    ctlr->cur_msg_mapped &&
-		    ctlr->can_dma(ctlr, spi, t))
+		    spi_xfer_is_dma_mapped(ctlr, spi, t))
 			count = omap2_mcspi_txrx_dma(spi, t);
 		else
 			count = omap2_mcspi_txrx_pio(spi, t);
-- 
2.53.0



