Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33C71D301
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:06:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57656C433C8;
	Tue, 25 Jul 2023 11:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283177;
	bh=ovV3T5oOOrGn4fvkP9cai8WxMI7YPheuxKvdIQt1i9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pSaOz2S7eEYClAIVTWnswLsifKTY18WkF24D//qFYVc8R56QKP/0H32WMPK0HqW6h
	 2HWs+pw72hUF1p2C58hxkoGsLhHqrknPhyJGzaPagBtu+lVy1+7ShebUjTy46O2uXI
	 HdOH9t6CcvikJegZy9PlaS/tcuNQooOuRzyp8Ds0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abe Kohandel <abe.kohandel@intel.com>,
	Serge Semin <fancer.lancer@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 167/183] spi: dw: Remove misleading comment for Mount Evans SoC
Date: Tue, 25 Jul 2023 12:46:35 +0200
Message-ID: <20230725104513.790361218@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
References: <20230725104507.756981058@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Abe Kohandel <abe.kohandel@intel.com>

commit 5b6d0b91f84cff3f28724076f93f6f9e2ef8d775 upstream.

Remove a misleading comment about the DMA operations of the Intel Mount
Evans SoC's SPI Controller as requested by Serge.

Signed-off-by: Abe Kohandel <abe.kohandel@intel.com>
Link: https://lore.kernel.org/linux-spi/20230606191333.247ucbf7h3tlooxf@mobilestation/
Fixes: 0760d5d0e9f0 ("spi: dw: Add compatible for Intel Mount Evans SoC")
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Link: https://lore.kernel.org/r/20230606231844.726272-1-abe.kohandel@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-dw-mmio.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/drivers/spi/spi-dw-mmio.c
+++ b/drivers/spi/spi-dw-mmio.c
@@ -223,14 +223,7 @@ static int dw_spi_intel_init(struct plat
 }
 
 /*
- * The Intel Mount Evans SoC's Integrated Management Complex uses the
- * SPI controller for access to a NOR SPI FLASH. However, the SoC doesn't
- * provide a mechanism to override the native chip select signal.
- *
- * This driver doesn't use DMA for memory operations when a chip select
- * override is not provided due to the native chip select timing behavior.
- * As a result no DMA configuration is done for the controller and this
- * configuration is not tested.
+ * DMA-based mem ops are not configured for this device and are not tested.
  */
 static int dw_spi_mountevans_imc_init(struct platform_device *pdev,
 				      struct dw_spi_mmio *dwsmmio)


