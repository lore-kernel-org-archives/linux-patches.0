Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9CD130DED8;
	Mon, 13 Oct 2025 15:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369229; cv=none; b=o+DwNnV5ZwCcKKeSJXBLEQss12SCaFZAnmxfEPMvm/04nSDM334YDKn4uLuVqMCovnAYD6FN3KgKFzHUf0wU/RK68kdbAxGS9F0bkPInDQViOI5p/59t23wB4Ck/t01KUASQ4MyBkIJGNh4EmXttTAdoZxHNirkORHKMngnbKvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369229; c=relaxed/simple;
	bh=PV1x5lluH/CczC+FechKmw2Pb8oCh9670eEDCHjGouM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DGAgR+1MHqwv7N0uhCppd+Fb5X2Xn2bTgXVZgHtaiyMLqL7ecTg3BfZEOiHENRdoXtMbyjqWIvXoNBCJU7HkqfJHUXtR+Bg/9AdfJFmtCZuVC/e1IG7jmrScHlYP7bsp83ktFd6DPzDA7NUtP04LHi7Qv/4PusOXIFk6RrL1Y6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gemHdtYZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gemHdtYZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63B7DC4CEE7;
	Mon, 13 Oct 2025 15:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369229;
	bh=PV1x5lluH/CczC+FechKmw2Pb8oCh9670eEDCHjGouM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gemHdtYZ3ld1AwlFzsUd2oeqEibldibS6sPamXxaAsOknoytxfDl+m54vQrocoSVz
	 ZOM8OeYc14RV2+1go4C2eepzb7PDezAHYUY+21+LRBfnuObYwBIExUM5OPjfQgN9FP
	 5x415snJR4a2w16x6qEjRqIk2OjZ1XLdd6nrsm64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Mikko Rapeli <mikko.rapeli@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 174/563] mmc: select REGMAP_MMIO with MMC_LOONGSON2
Date: Mon, 13 Oct 2025 16:40:35 +0200
Message-ID: <20251013144417.590902245@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikko Rapeli <mikko.rapeli@linaro.org>

[ Upstream commit 67da3f16e5f97a864a0beb4f9758d09e1890a76e ]

COMPILE_TEST with MMC_LOONGSON2 failed to link due to
undeclared dependency:

ERROR: modpost: "__devm_regmap_init_mmio_clk"
[drivers/mmc/host/loongson2-mmc.ko] undefined!

Fixes: 2115772014bd ("mmc: loongson2: Add Loongson-2K SD/SDIO controller driver")

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Suggested-by: Binbin Zhou <zhoubinbin@loongson.cn>
Signed-off-by: Mikko Rapeli <mikko.rapeli@linaro.org>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 7232de1c06887..5cc415ba4f550 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -1115,6 +1115,7 @@ config MMC_LOONGSON2
 	tristate "Loongson-2K SD/SDIO/eMMC Host Interface support"
 	depends on LOONGARCH || COMPILE_TEST
 	depends on HAS_DMA
+	select REGMAP_MMIO
 	help
 	  This selects support for the SD/SDIO/eMMC Host Controller on
 	  Loongson-2K series CPUs.
-- 
2.51.0



