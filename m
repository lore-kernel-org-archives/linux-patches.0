Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 773B8BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:26:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC3B3C433EF;
	Tue,  7 Mar 2023 17:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210010;
	bh=YDON1Xo2Gj7X9JkaInKK1RjrkfH6g4LBvF7wIFMwI4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JOcesobwnNSxBo965EqQNG/1PNfWXsDLHNNcBqMJupvqkIkcSUm6XnASu3Z5eJSE7
	 hWZ+LB+40TH4/cDmkg7F1+ujjdWLXfoHvbPE1fIIj71cb83tCDK4q1VS0lWJ4ThoLo
	 nb60AmdReWVBLx9jBKBB+DouIIMxAXiZgNaFSej8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Serge Semin <fancer.lancer@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0404/1001] spi: dw_bt1: fix MUX_MMIO dependencies
Date: Tue,  7 Mar 2023 17:52:56 +0100
Message-Id: <20230307170038.858548079@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit d4bde04318c0d33705e9a77d4c7df72f262011e0 ]

Selecting a symbol with additional dependencies requires
adding the same dependency here:

WARNING: unmet direct dependencies detected for MUX_MMIO
  Depends on [n]: MULTIPLEXER [=y] && OF [=n]
  Selected by [y]:
  - SPI_DW_BT1 [=y] && SPI [=y] && SPI_MASTER [=y] && SPI_DESIGNWARE [=y] && (MIPS_BAIKAL_T1 || COMPILE_TEST [=y])

Drop the 'select' here to avoid the problem. Anyone using
the dw-bt1 SPI driver should make sure they include the
mux driver as well now.

Fixes: 7218838109fe ("spi: dw-bt1: Fix undefined devm_mux_control_get symbol")
Fixes: abf00907538e ("spi: dw: Add Baikal-T1 SPI Controller glue driver")
Link: https://lore.kernel.org/all/20221218192523.c6vnfo26ua6xqf26@mobilestation/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Serge Semin <fancer.lancer@gmail.com>
Link: https://lore.kernel.org/r/20230130140156.3620863-1-arnd@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 3b1c0878bb857..930c6075b78cf 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -295,7 +295,6 @@ config SPI_DW_BT1
 	tristate "Baikal-T1 SPI driver for DW SPI core"
 	depends on MIPS_BAIKAL_T1 || COMPILE_TEST
 	select MULTIPLEXER
-	select MUX_MMIO
 	help
 	  Baikal-T1 SoC is equipped with three DW APB SSI-based MMIO SPI
 	  controllers. Two of them are pretty much normal: with IRQ, DMA,
-- 
2.39.2



