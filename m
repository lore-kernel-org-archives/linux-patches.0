Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4270D528;
	Sun,  7 Sep 2025 20:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276664; cv=none; b=kCwtfpybbZOMHoFNo2CgPL3bIbHME+9V1dKwrsF7LsxtOk15MOox/uOh6w/RkiiAZxivkoWryFXwV50gKP72RNGitHH2EVYE/il0tWvITFJB0x0r2odLLPM0JvYs1l80AhQVDBs9A0eo9bgr2qNgkjV8467CaTu14YXajw0ccug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276664; c=relaxed/simple;
	bh=O2tjjsFPaqYlMOeHKkyN4Ch6VMnDFIXWCl26zM9Ls04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hntd0QgZWQ4TBoqLmqzqoAOCxQrMObPl0roDTBAcycZWv46+1EoFzBVhHE4cGqBw/BHq7D1MubfNy99Ohkgx2pFYvnQEQe/jK610cw6DqtEb3Igoy0/T+HcWCof3rz3nMok+p64ohl3A3IKO9sUVkKVo5mBzzyI6lVSa7rFwRGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BgkVp1e6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BgkVp1e6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3412C4CEF8;
	Sun,  7 Sep 2025 20:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276664;
	bh=O2tjjsFPaqYlMOeHKkyN4Ch6VMnDFIXWCl26zM9Ls04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BgkVp1e6lwZqTP4pkqOZgZ3pTAE3UM+67OMbmHaU0vVg2wYEhTD/6Sf/8Ir3V5jPc
	 9MDZ8PaoptxDwThVEqPdtyZHixd7Ye6AM+7o/+qa8W1A8shGB8OYKjmsudDc8OcXoE
	 gEy6bbcijf7XY33hYoNlNR3QdckriAr/tGXNRWyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinfeng Wang <jinfeng.wang.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 6.6 071/121] Revert "spi: spi-cadence-quadspi: Fix pm runtime unbalance"
Date: Sun,  7 Sep 2025 21:58:27 +0200
Message-ID: <20250907195611.658686738@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinfeng Wang <jinfeng.wang.cn@windriver.com>

This reverts commit cdfb20e4b34ad99b3fe122aafb4f8ee7b9856e1f which is
commit b07f349d1864abe29436f45e3047da2bdd476462 upstream.

There is cadence-qspi ff8d2000.spi: Unbalanced pm_runtime_enable! error
without this revert.

After reverting commit cdfb20e4b34a ("spi: spi-cadence-quadspi: Fix pm runtime unbalance")
and commit 1af6d1696ca4 ("spi: cadence-quadspi: fix cleanup of rx_chan on failure paths"),
Unbalanced pm_runtime_enable! error does not appear.

These two commits are backported from upstream commit b07f349d1864 ("spi: spi-cadence-quadspi: Fix pm runtime unbalance")
and commit 04a8ff1bc351 ("spi: cadence-quadspi: fix cleanup of rx_chan on failure paths").

The commit 04a8ff1bc351 ("spi: cadence-quadspi: fix cleanup of rx_chan on failure paths")
fix commit b07f349d1864 ("spi: spi-cadence-quadspi: Fix pm runtime unbalance").

The commit b07f349d1864 ("spi: spi-cadence-quadspi: Fix pm runtime unbalance") fix
commit 86401132d7bb ("spi: spi-cadence-quadspi: Fix missing unwind goto warnings").

The commit 86401132d7bb ("spi: spi-cadence-quadspi: Fix missing unwind goto warnings") fix
commit 0578a6dbfe75 ("spi: spi-cadence-quadspi: add runtime pm support").

6.6.y only backport commit b07f349d1864 ("spi: spi-cadence-quadspi: Fix pm runtime unbalance")
and commit 04a8ff1bc351 ("spi: cadence-quadspi: fix cleanup of rx_chan on failure paths"),
but does not backport commit 0578a6dbfe75 ("spi: spi-cadence-quadspi: add runtime pm support")
and commit 86401132d7bb ("spi: spi-cadence-quadspi: Fix missing unwind goto warnings").
And the backport of commit b07f349d1864 ("spi: spi-cadence-quadspi: Fix pm runtime unbalance")
differs with the original patch. So there is Unbalanced pm_runtime_enable error.

If revert the backport for commit b07f349d1864 ("spi: spi-cadence-quadspi: Fix pm runtime unbalance")
and commit 04a8ff1bc351 ("spi: cadence-quadspi: fix cleanup of rx_chan on failure paths"), there is no error.
If backport commit 0578a6dbfe75 ("spi: spi-cadence-quadspi: add runtime pm support") and
commit 86401132d7bb ("spi: spi-cadence-quadspi: Fix missing unwind goto warnings"), there
is hang during booting. I didn't find the cause of the hang.

Since commit 0578a6dbfe75 ("spi: spi-cadence-quadspi: add runtime pm support") and
commit 86401132d7bb ("spi: spi-cadence-quadspi: Fix missing unwind goto warnings") are
not backported, commit b07f349d1864 ("spi: spi-cadence-quadspi: Fix pm runtime unbalance")
and commit 04a8ff1bc351 ("spi: cadence-quadspi: fix cleanup of rx_chan on failure paths") are not needed.
So revert commits commit cdfb20e4b34a ("spi: spi-cadence-quadspi: Fix pm runtime unbalance") and
commit 1af6d1696ca4 ("spi: cadence-quadspi: fix cleanup of rx_chan on failure paths").

Signed-off-by: Jinfeng Wang <jinfeng.wang.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-cadence-quadspi.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -1868,13 +1868,6 @@ static int cqspi_probe(struct platform_d
 			goto probe_setup_failed;
 	}
 
-	pm_runtime_enable(dev);
-
-	if (cqspi->rx_chan) {
-		dma_release_channel(cqspi->rx_chan);
-		goto probe_setup_failed;
-	}
-
 	ret = spi_register_controller(host);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register SPI ctlr %d\n", ret);
@@ -1884,7 +1877,6 @@ static int cqspi_probe(struct platform_d
 	return 0;
 probe_setup_failed:
 	cqspi_controller_enable(cqspi, 0);
-	pm_runtime_disable(dev);
 probe_reset_failed:
 	if (cqspi->is_jh7110)
 		cqspi_jh7110_disable_clk(pdev, cqspi);
@@ -1906,8 +1898,7 @@ static void cqspi_remove(struct platform
 	if (cqspi->rx_chan)
 		dma_release_channel(cqspi->rx_chan);
 
-	if (pm_runtime_get_sync(&pdev->dev) >= 0)
-		clk_disable(cqspi->clk);
+	clk_disable_unprepare(cqspi->clk);
 
 	if (cqspi->is_jh7110)
 		cqspi_jh7110_disable_clk(pdev, cqspi);


