Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829618;
	b=QjerVGgZbS6GDQBocDAj+GyaYhvFv+MgavJw087R2ut8pULltEIbAL558Nn4rN1uRM0u
	 f950EA52V1ndqybTRrdJH/DT9iZ+ozsT0GHxJuit7BEYcDNFDN7NP0yeaS1G4YQVA7MxI
	 NmxPjdJDgeR3D+FpBUKG2rH0D9aZJ+wxPgPJh74byjAGi/gpjbqOMVmVpoLKldNwYfhv8
	 sBGBXtiB+ek+4ey5HKFPOu2+9hMrgrmvw/Qn8f1emChWpQf0QOdWG9yVS+oMEvw3d/I29
	 pD+CKfQFpPvIMMlZcly280l3tK/sgMXttlEpiPpZHcJsYG9ynrSMSuRz8MJrz/F3qjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829618;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=puOvPyFuSTBd2QrIiJs0NBC7yH8jomddm/LHjXqLib8=;
	b=sLngl98+U2c7nXiZVqjnKfjoXkg+9UOr1mmF2t7tOCWoP1rO8lndoWjIhi1XF6z2Qf+q
	 8w+cwk9NeziDKJywqM+9X5OQjFw8/7vH1P7LZatMVm5sAAdv87KX9fXFucXATro7qpJjj
	 y3xFLzhpMWMrfZNXdOfZwYPFZJp/QDsg4I5zah9aaYogjHz0sk8XQGwUv5NbwrU1RVKt1
	 DW41J87HXMSqaPv13+TmPN5/FGztBYUWq8rW1qf+vxhLlpQCW3UIMjj1tz4lxoxvjr1Qs
	 IQ2EExQ+mGQO72bzUfThKoKY8W1KH3CPkw4TlpoiRlj1qMEote1NpBe5lQAbUvzw9dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jEdOFNA7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F17F1606B2D8;
	Wed,  4 Nov 2026 22:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jEdOFNA7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ABD81F000C1;
	Wed,  4 Nov 2026 22:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829617;
	bh=puOvPyFuSTBd2QrIiJs0NBC7yH8jomddm/LHjXqLib8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jEdOFNA7GbaaU1uPoVFiHQXRfgJOxCFVpLUMif/D/U2rPJ8hnxIE0W0NPtonUsB8d
	 mS65XWzwbpbQp9GZWtIpbCBks2baU606vFEE9CiK5aJtJwd+oUjcqnpUb9aKYy2Htj
	 ziY2Z3Cl5wlpMCu0PjYkxN/4WzMVM2SKsnZsi6sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0237/1005] ata: pata_ep93xx: fix PIO fallback when DMA init fails
Date: Wed,  4 Nov 2026 15:59:30 -0500
Message-ID: <20261104211050.490184570@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b2b9e0058333e..3f61712af5bbe 100644
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



