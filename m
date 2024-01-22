Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7999131E54;
	Tue, 23 Jan 2024 00:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969102; cv=none; b=n5bSFTBmUtnPEJlcNFjOJWUlQOM3MCD76EZhSBHrq8zlosiV/MzQmWvt8cZi9eTnepouFKeqOqmxSjkZgRhEDzYa0iGUuhYBel8aU74Y9zT93qoP1CrnUvqwo6izJNBtdQQRmAPpFFOyShp+GrkbwIQ6xW2NcDRs1xmZa0708bQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969102; c=relaxed/simple;
	bh=Zbqjfrwp9If14ov8eoHMVD8cjQx97Hj4MH9AIxyUuZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VzBziv9Zi+llz9xGIMTjJb0LlSNNmIT8kLpt/hKcEbepuO+5WXkxVouLhfVQbUvnYcHTWTHBIfdh7LHFBAZIL0FT9wUvf7/yAgLom/RpcSVPcPFyRbIzPA53I4qSPRH1b9cZ/eSduEAFoT2OnbsDNk426SDOXq0/jL2gfzw9vcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ml0DpH4M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ml0DpH4M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB8CC43390;
	Tue, 23 Jan 2024 00:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969102;
	bh=Zbqjfrwp9If14ov8eoHMVD8cjQx97Hj4MH9AIxyUuZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ml0DpH4MfGfH12exSY/BefnTxsckf5a1FB6kUJDwOwCMgNE+calTe9qscvX7l71SN
	 0TjSg0trKrxugN1hN+7sBxQ/C82hn2YFWKXcMp/YtPJUtsmI8rJDYFQBFSprFdtM8w
	 YC9f9bVfxi22PWlRPFETgTynVzgArejxIq4j2n80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 022/641] spi: spi-zynqmp-gqspi: fix driver kconfig dependencies
Date: Mon, 22 Jan 2024 15:48:46 -0800
Message-ID: <20240122235818.795097182@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>

[ Upstream commit 424a8166764e462258fdccaaefbdeb07517c8b21 ]

ZynqMP GQSPI driver no longer uses spi-master framework. It had been
converted to use spi-mem framework. So remove driver dependency from
spi-master and replace it with spi-mem.

Fixes: 1c26372e5aa9 ("spi: spi-zynqmp-gqspi: Update driver to use spi-mem framework")
Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@amd.com>
Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Link: https://lore.kernel.org/r/1699282435-884917-1-git-send-email-radhey.shyam.pandey@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 70c9dd6b6a31..ddae0fde798e 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -1177,9 +1177,10 @@ config SPI_ZYNQ_QSPI
 
 config SPI_ZYNQMP_GQSPI
 	tristate "Xilinx ZynqMP GQSPI controller"
-	depends on (SPI_MASTER && HAS_DMA) || COMPILE_TEST
+	depends on (SPI_MEM && HAS_DMA) || COMPILE_TEST
 	help
 	  Enables Xilinx GQSPI controller driver for Zynq UltraScale+ MPSoC.
+	  This controller only supports SPI memory interface.
 
 config SPI_AMD
 	tristate "AMD SPI controller"
-- 
2.43.0



