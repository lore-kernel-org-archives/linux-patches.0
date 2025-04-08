Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7062192F2;
	Tue,  8 Apr 2025 11:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112150; cv=none; b=mAFbKr5KUzBDwTzLnxdQGZGtQXjobnPwCtuA6R9I3+x0XvM6XPRE24uNGvK6hW2lHkhwnw8opQFwIHBxzKUWWGUi65wqG2X9tlWL9JKO7AETrH/ObX9ftxTtPPtIJOacO649hdAEU70PLh3dbbT8+7UycqWHGEH9I2anVhK+iyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112150; c=relaxed/simple;
	bh=khUJZfkkperJfv7SejENLWkZ1ppp2Z5zxB5ebgw5oyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a31ACOCsZJ7bpc2s4it13Ab64AcQUV7vX+BBPeDkTePoYz08eau86qQteChzpuZ6sx+Xfy0uAXmWjgsC25tQAn2ZMmWlzzNZBWa74nVx5ajAPWnKNvIyzN+W6u9+NQoot+/k5I59jYYt1ADCNu6rCU/vei0x722UwpzTXxV8htU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2qAdxNsS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2qAdxNsS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B42C4CEE5;
	Tue,  8 Apr 2025 11:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112149;
	bh=khUJZfkkperJfv7SejENLWkZ1ppp2Z5zxB5ebgw5oyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2qAdxNsS5rh16xxhFRypcLn0owdi8DSw1kkP1jea47zinDl2lYvt8tanx43Xrkl8i
	 g5q9ijZe/HcEkdUDn/6NzK3Y2sjMzLKKLPe9eyzIAUN+BcwqQbZFCnoIlmSfZoR/f8
	 2ZWimeJDVOnmHAtyvazT4zUXKbxaiLD3ba+mIihU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karel Balej <balejk@matfyz.cz>,
	Adrian Hunter <adrian.hunter@intel.com>,
	=?UTF-8?q?Duje=20Mihanovi=C4=87?= <duje.mihanovic@skole.hr>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.14 695/731] mmc: sdhci-pxav3: set NEED_RSP_BUSY capability
Date: Tue,  8 Apr 2025 12:49:52 +0200
Message-ID: <20250408104930.433652643@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karel Balej <balejk@matfyz.cz>

commit a41fcca4b342811b473bbaa4b44f1d34d87fcce6 upstream.

Set the MMC_CAP_NEED_RSP_BUSY capability for the sdhci-pxav3 host to
prevent conversion of R1B responses to R1. Without this, the eMMC card
in the samsung,coreprimevelte smartphone using the Marvell PXA1908 SoC
with this mmc host doesn't probe with the ETIMEDOUT error originating in
__mmc_poll_for_busy.

Note that the other issues reported for this phone and host, namely
floods of "Tuning failed, falling back to fixed sampling clock" dmesg
messages for the eMMC and unstable SDIO are not mitigated by this
change.

Link: https://lore.kernel.org/r/20200310153340.5593-1-ulf.hansson@linaro.org/
Link: https://lore.kernel.org/r/D7204PWIGQGI.1FRFQPPIEE2P9@matfyz.cz/
Link: https://lore.kernel.org/r/20250115-pxa1908-lkml-v14-0-847d24f3665a@skole.hr/
Cc: stable@vger.kernel.org
Signed-off-by: Karel Balej <balejk@matfyz.cz>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Tested-by: Duje Mihanović <duje.mihanovic@skole.hr>
Link: https://lore.kernel.org/r/20250310140707.23459-1-balejk@matfyz.cz
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-pxav3.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mmc/host/sdhci-pxav3.c
+++ b/drivers/mmc/host/sdhci-pxav3.c
@@ -399,6 +399,7 @@ static int sdhci_pxav3_probe(struct plat
 	if (!IS_ERR(pxa->clk_core))
 		clk_prepare_enable(pxa->clk_core);
 
+	host->mmc->caps |= MMC_CAP_NEED_RSP_BUSY;
 	/* enable 1/8V DDR capable */
 	host->mmc->caps |= MMC_CAP_1_8V_DDR;
 


