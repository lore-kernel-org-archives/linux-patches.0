Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7EB8820
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:53:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811B5C433A0;
	Fri, 10 Mar 2023 14:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460006;
	bh=1xF2UvhqkkLybxOdD8Q4Gqk2SsX0QH9YDM3nXfWwFrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PYt1jwU2PK50bQiCSrxEkgnCTl/w6Ddk88yYQmLze3LIVTsAG30CdesU35yXrJGzh
	 uzGakobMt0er69XIUtJv5+PBtrgHt51WJ8g80UwfaFHLiZ79BY8roKSxJuIxZJjN4x
	 Om8aE31IBKVWHncULy8mE/QMO5iKzFtcLIGY02tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Serge Semin <fancer.lancer@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 192/529] spi: dw_bt1: fix MUX_MMIO dependencies
Date: Fri, 10 Mar 2023 14:35:35 +0100
Message-Id: <20230310133813.887759702@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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
index aadaea052f51d..4d98ce7571df0 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -256,7 +256,6 @@ config SPI_DW_BT1
 	tristate "Baikal-T1 SPI driver for DW SPI core"
 	depends on MIPS_BAIKAL_T1 || COMPILE_TEST
 	select MULTIPLEXER
-	select MUX_MMIO
 	help
 	  Baikal-T1 SoC is equipped with three DW APB SSI-based MMIO SPI
 	  controllers. Two of them are pretty much normal: with IRQ, DMA,
-- 
2.39.2



