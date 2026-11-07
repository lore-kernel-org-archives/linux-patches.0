Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060798;
	b=PM/AEz/t/4B6dcyXbfObCkn88sj2cujeaSMR1bxIyr9Pv41l6NM1B0uN8ILcUo7EWxkT
	 c1Z/gW0pbZHbrugqP18jx9Nt24M0EDKi0iIhTktKLdHBSnTBkW1xNGvDai5JQURldMkDW
	 IWx+456v1w8a5L4t0P60Olqsx0VoKOKQVaCSgTA5NAFVhipnbCkEp2ECmXHo14Zl34g/W
	 zGd2PgiPynBwxWZfK7Id+eiP30ROffH+g4349KQbDkvPLdEvFJiTXlBV89btyH2N49s5m
	 vRWWOUERhbxD4p/9kXqtebavfHjxD8D/AlVzNcCYXpkQTT+Asessv9rZYLMtpeKVTEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060798;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dxIeCyaD2nQJRCjNl9QcP7vb+eEvASjuch+9VSDcTrs=;
	b=hXAJvE7mGFK4Y/XkLMaqZCynf5zrIhnelY5WMb1Jesw72PmlLfKlMbU91+yRYZsN1CBS
	 xJIa57SBVGJqFObH8waI/pXSqw7x0bTlpY3iTEnYaE7MDeVpgWwp9yGiL+ZA8uL1JUWbC
	 SP1azGMUxnCN5lcf8jk/4KR2atuFW3ck0g9n0/CW2d49PclSvJVWbHZwoj+BQkXKro4cv
	 FXAzt5bVCdICppVPUVsEcBPlXj039UVe+exX/jUjOHU9T9NUKeNyBBMmwMC32ZG56Xiki
	 LSjf0MojxwtdqY9nSSCbtYfGQe7tn8ckjJInIDQwHsSCRTh6Ull/cQ8mbpM0Olu9DiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WIr3wlY4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E33606A332;
	Sat,  7 Nov 2026 14:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WIr3wlY4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF9041F0089F;
	Sat,  7 Nov 2026 14:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060798;
	bh=dxIeCyaD2nQJRCjNl9QcP7vb+eEvASjuch+9VSDcTrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WIr3wlY4mLgVA94Dr8qMyR278l1dx8PPBd7XLca+4Eut2YaV5qH5gK4dFQc08kBfC
	 tTazNCh0lc3O0praZer0dKzSqk2SEfLk62D81vMG892r8hvc5nJA7pgaS5J+jjxyqS
	 l7za/8pEAZc4C9/MCoMMqfAnuvkSKmSw+Lb8EdOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0199/1536] ata: pata_ep93xx: fix PIO fallback when DMA init fails
Date: Sat,  7 Nov 2026 08:36:55 -0500
Message-ID: <20261107135003.251562784@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit c303c3619a1d5cf7d4b457106062d16724724a80 ]

ep93xx_pata_dma_init() returns an error when dma_request_chan() fails,
which causes ep93xx_pata_probe() to abort entirely.  The probe function
already has a PIO fallback path (it checks both channel pointers before
enabling UDMA), so the DMA init should not fail the probe on non-fatal
errors.

Propagate -EPROBE_DEFER, such that we allow the DMA controller driver
to load, in case we got probed before the DMA controller driver.
For all other failures (e.g. -ENODEV when the DMA controller is missing
in the device tree), fall back to PIO.

Assisted-by: Opencode:Big-Pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/pata_ep93xx.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/ata/pata_ep93xx.c b/drivers/ata/pata_ep93xx.c
index f3f5b2b0ecc9f..3ee9753097910 100644
--- a/drivers/ata/pata_ep93xx.c
+++ b/drivers/ata/pata_ep93xx.c
@@ -652,14 +652,22 @@ static int ep93xx_pata_dma_init(struct ep93xx_pata_data *drv_data)
 	 * start of new transfer.
 	 */
 	drv_data->dma_rx_channel = dma_request_chan(dev, "rx");
-	if (IS_ERR(drv_data->dma_rx_channel))
-		return dev_err_probe(dev, PTR_ERR(drv_data->dma_rx_channel),
-				     "rx DMA setup failed\n");
+	if (IS_ERR(drv_data->dma_rx_channel)) {
+		ret = PTR_ERR(drv_data->dma_rx_channel);
+		drv_data->dma_rx_channel = NULL;
+		if (ret == -EPROBE_DEFER)
+			return ret;
+		dev_warn(dev, "rx DMA unavailable, using PIO\n");
+		return 0;
+	}
 
 	drv_data->dma_tx_channel = dma_request_chan(&pdev->dev, "tx");
 	if (IS_ERR(drv_data->dma_tx_channel)) {
-		ret = dev_err_probe(dev, PTR_ERR(drv_data->dma_tx_channel),
-				    "tx DMA setup failed\n");
+		ret = PTR_ERR(drv_data->dma_tx_channel);
+		drv_data->dma_tx_channel = NULL;
+		if (ret == -EPROBE_DEFER)
+			goto fail_release_rx;
+		dev_warn(dev, "tx DMA unavailable, using PIO\n");
 		goto fail_release_rx;
 	}
 
@@ -670,7 +678,7 @@ static int ep93xx_pata_dma_init(struct ep93xx_pata_data *drv_data)
 	conf.src_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
 	ret = dmaengine_slave_config(drv_data->dma_rx_channel, &conf);
 	if (ret) {
-		dev_err_probe(dev, ret, "failed to configure rx dma channel");
+		dev_warn(dev, "failed to configure rx dma channel, using PIO\n");
 		goto fail_release_dma;
 	}
 
@@ -681,7 +689,7 @@ static int ep93xx_pata_dma_init(struct ep93xx_pata_data *drv_data)
 	conf.dst_addr_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
 	ret = dmaengine_slave_config(drv_data->dma_tx_channel, &conf);
 	if (ret) {
-		dev_err_probe(dev, ret, "failed to configure tx dma channel");
+		dev_warn(dev, "failed to configure tx dma channel, using PIO\n");
 		goto fail_release_dma;
 	}
 
@@ -689,10 +697,14 @@ static int ep93xx_pata_dma_init(struct ep93xx_pata_data *drv_data)
 
 fail_release_rx:
 	dma_release_channel(drv_data->dma_rx_channel);
+	drv_data->dma_rx_channel = NULL;
+	if (ret == -EPROBE_DEFER)
+		return ret;
+	return 0;
+
 fail_release_dma:
 	ep93xx_pata_release_dma(drv_data);
-
-	return ret;
+	return 0;
 }
 
 static void ep93xx_pata_dma_start(struct ata_queued_cmd *qc)
-- 
2.53.0



