Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB8A86334;
	Thu, 15 Jan 2026 17:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497410; cv=none; b=DhXqAxp2q2maDBFDrpyJMgB08CgZNUAqATMbQpztu//WBo6I2pm8w9q2FHTTDuhQt8owsFwV6SVMnnvktF7sEVDp42QTtATIBWGKICPgZhcfmiF2ooZMpPmcU265fXwaT+9srrNcox2lbN6M2aDAHfAHcxQ2ZXkgQCYot2aRKoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497410; c=relaxed/simple;
	bh=k9v2ibAFPVWVfMfRGZPz5gt29JTXZEwSz+Dgvszya2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yh8AJp14N7oEdLkV/U3ynzwZoJaic/Y6mVSBVGfDIPVfNHLIzLFtReUWGsWjmQEcxRANK3R2+RJjNGXXJ6I5y3yCeEb28jIoHkHsOdgfNPjZU2qB0AKz+Afchk5M5ZBTUOz5hw1UOM4USKFpeHbDG2HMBYjYubURC1HxHQoJNY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jjUIAg1x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jjUIAg1x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E13E8C116D0;
	Thu, 15 Jan 2026 17:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497410;
	bh=k9v2ibAFPVWVfMfRGZPz5gt29JTXZEwSz+Dgvszya2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jjUIAg1xuCO65y0GmELaqh3lCqvuoQKwtjGFNTQESyZvbN80Qj3GYz9J/lH5mOgqc
	 yQoY2aH/OTqeH++M07u3phQccR9M4g4GbE9vCz+Rs8IzOUsaDoUPapVmK4t4rC7asY
	 mBokDs7GxPPC7lKmBePEB841RjjBaRAPiyonmfwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Yarlagadda <kyarlagadda@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 072/554] spi: tegra210-quad: add new chips to compatible
Date: Thu, 15 Jan 2026 17:42:18 +0100
Message-ID: <20260115164248.849420584@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krishna Yarlagadda <kyarlagadda@nvidia.com>

[ Upstream commit ea23f0e148b82e5bcbc6c814926f53133552f0f3 ]

Add support for Tegra234 and soc data to select capabilities.

Signed-off-by: Krishna Yarlagadda <kyarlagadda@nvidia.com>
Link: https://lore.kernel.org/r/20220222175611.58051-4-kyarlagadda@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: b4e002d8a7ce ("spi: tegra210-quad: Fix timeout handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra210-quad.c | 33 ++++++++++++++++++++++++++++++---
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-tegra210-quad.c b/drivers/spi/spi-tegra210-quad.c
index c3867c70c61d4..325ff5c1926c4 100644
--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -125,6 +125,10 @@
 #define QSPI_DMA_TIMEOUT			(msecs_to_jiffies(1000))
 #define DEFAULT_QSPI_DMA_BUF_LEN		(64 * 1024)
 
+struct tegra_qspi_soc_data {
+	bool has_dma;
+};
+
 struct tegra_qspi_client_data {
 	int tx_clk_tap_delay;
 	int rx_clk_tap_delay;
@@ -184,6 +188,7 @@ struct tegra_qspi {
 	u32					*tx_dma_buf;
 	dma_addr_t				tx_dma_phys;
 	struct dma_async_tx_descriptor		*tx_dma_desc;
+	const struct tegra_qspi_soc_data	*soc_data;
 };
 
 static inline u32 tegra_qspi_readl(struct tegra_qspi *tqspi, unsigned long offset)
@@ -1199,10 +1204,32 @@ static irqreturn_t tegra_qspi_isr_thread(int irq, void *context_data)
 	return handle_dma_based_xfer(tqspi);
 }
 
+static struct tegra_qspi_soc_data tegra210_qspi_soc_data = {
+	.has_dma = true,
+};
+
+static struct tegra_qspi_soc_data tegra186_qspi_soc_data = {
+	.has_dma = true,
+};
+
+static struct tegra_qspi_soc_data tegra234_qspi_soc_data = {
+	.has_dma = false,
+};
+
 static const struct of_device_id tegra_qspi_of_match[] = {
-	{ .compatible = "nvidia,tegra210-qspi", },
-	{ .compatible = "nvidia,tegra186-qspi", },
-	{ .compatible = "nvidia,tegra194-qspi", },
+	{
+		.compatible = "nvidia,tegra210-qspi",
+		.data	    = &tegra210_qspi_soc_data,
+	}, {
+		.compatible = "nvidia,tegra186-qspi",
+		.data	    = &tegra186_qspi_soc_data,
+	}, {
+		.compatible = "nvidia,tegra194-qspi",
+		.data	    = &tegra186_qspi_soc_data,
+	}, {
+		.compatible = "nvidia,tegra234-qspi",
+		.data	    = &tegra234_qspi_soc_data,
+	},
 	{}
 };
 
-- 
2.51.0



