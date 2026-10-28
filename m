Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211545;
	b=BZlUlqslG4CaowKLrt9qyH8sSou52z2bOlKHNG1b/m8V/faW35ZyGegsk0Efa2taqq+a
	 0BN/BCC3uzSZASdXhsT7Lq2pbVdM8ZtzdS2pCoOt0iHhtw/AIjLTv4ofpR0i9RJ38eCYt
	 nHH5A2Y5OdoDuRpIdW54qvqBcgDZKgYWJHSOwDFhp9Os2d9HbZuUPfAuabWhliEZZ6zRi
	 RH8npduUCVE0JKA3EzQtEM5zXsh9VnMl4q6i3L6OdISS2GzGASTHKn3AqYlKqyMG4kOGM
	 o25ifqezzibkLINwVEVlqsVAI7e02eAteOEHPmJFwoJytytxPqlHaJ9KxkVt5akh4Jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211545;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4KQbxRnqEUCy43v3C/dpOlNHMDUfCQ5xSC2BHOI0F2E=;
	b=NDKDITYoGuid4CmpraQj+fQcA0Hc8x5poaByozuUGPTmZRK/vlNbQl4f35YFSu4Uq1TV
	 /f3QEQ5qCGerQLNtHNVHyezD+qzrJnVst3im+OL21tFQ+1z1UUT+Qj0xJXeDePSYaQmsb
	 ISu7oVTX0YhHgMhiv9gUVF2gfqwhPOYmiesvk1Ifr/t+kXznpym4q7kxhNHNj4iObmaoS
	 d4m2IbkX8gPejexqKE5QNeEHAVvl+RoYsKmCwumcdor2ndIX1RtismjWlpLsIYDc1Cxgs
	 dO5EEx9fNcenOBUpLIm3bIi4y+1mqhHI0vfPh+t0W18FMPh6Sm5mrJk6wWZbtDt4i0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UzmnpChx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0BA5606A31A;
	Wed, 28 Oct 2026 18:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UzmnpChx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB0CC1F01825;
	Wed, 28 Oct 2026 18:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211544;
	bh=4KQbxRnqEUCy43v3C/dpOlNHMDUfCQ5xSC2BHOI0F2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UzmnpChxOPmLodUXVmOPSV99rRCJeIvQgAgMYADEz+WZ2SA42AaepptR879nCjRnj
	 jFFuDiCp+K/TpO7zAogU1MsxR+IxGHjhMK3jvqF7wdLmf0o9MF75u8SKtIUF8/9sMt
	 DAqpgZF3PYh9L4aT/S480xEzLmP1LQ8u+XIQ/Nt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 5.15 370/571] mmc: sdhci-sprd: disable runtime PM on remove
Date: Wed, 28 Oct 2026 17:58:37 +0100
Message-ID: <20261028170016.792925430@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit e1c6c10a6a70a69e29b04fcc1ebe4b9bcbc7a49a upstream.

sdhci_sprd_probe() enables runtime PM, while sdhci_sprd_remove() does
not perform the corresponding runtime PM cleanup.

The probe failure path disables runtime PM before disabling the clocks,
but the normal remove path directly disables clocks that are also
managed by the runtime PM callbacks. If the device is runtime
suspended, those clocks may already be disabled.

Resume the device before removal, disable runtime PM and drop the
temporary runtime PM reference before disabling the clocks.

This issue was found by manual code inspection.

Fixes: fb8bd90f83c4 ("mmc: sdhci-sprd: Add Spreadtrum's initial host controller")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-sprd.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/mmc/host/sdhci-sprd.c
+++ b/drivers/mmc/host/sdhci-sprd.c
@@ -743,6 +743,10 @@ static int sdhci_sprd_remove(struct plat
 	struct sdhci_host *host = platform_get_drvdata(pdev);
 	struct sdhci_sprd_host *sprd_host = TO_SPRD_HOST(host);
 
+	pm_runtime_get_sync(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+	pm_runtime_put_noidle(&pdev->dev);
+
 	sdhci_remove_host(host, 0);
 
 	clk_disable_unprepare(sprd_host->clk_sdio);


