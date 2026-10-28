Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209051;
	b=d+pquzOiuuUMF2EfYseSenTMSzAkWpqoHnuX0p4hYBLF20o6vqV7EoAIQ8Z31ElNfJsq
	 ONsWBfdnV9AQWDhZfMf1r8mY0uIT64V3TGeCoqgqayJ6LLMTSNu48huPfndYbtal4kad5
	 cpd6U1Kvyt6nA3uv3U5Gv9iDRT71pY5GWTxNCqRn7a/1rvNI66jR+aPxxEhY/XT4tPpwp
	 CmCu9cUY984kKqjN+18zy7CuBgI7qKSTa9/6TuE1b8Xs9/pHhVD8JUaNBe3OCcA+Rq4X9
	 cpve9TPzHSEqNNLapFMDN1hrFd2WnbflhfrFo2o+rZ4+5y9xoRe2tBBqIVyA/KzzNBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209051;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yWZulVmQugojBIYkGDjOPzE8tNzKVytxubLAHfIvl2I=;
	b=o43e2/ykFZeZFvHJlszsgURD31iEAY7bcyZUbUWyIrAmRgwzRADgzFyuaOnNGp1UzUbD
	 sjfP7sqSQtx0ghiyNHF3gtN9a1Jy1LqwIRWvjPtpIZnNlaW6448SdDHCeq210lJAv1eQm
	 Y6T8M46yg7JdItMk7JnbhpFNoNs6fZAnY++bVj8X+A09C4wgvjRiieMzMf+yLbkI5fma6
	 jn5KQLOQFIl0l1pKds4I1SaN39p31YCZGMBtasApGQKO1MwsNw7/kA4qJmQ2ZJ+uUWkyW
	 dyz4OyUHO+6bptamAKCWC1O2HO3fT5BCkcdB3TLjwMjQOkn6V9oTl3Pl2V3oe791iGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UAUgMil6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2517160A2606;
	Wed, 28 Oct 2026 17:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UAUgMil6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7441A1F031F7;
	Wed, 28 Oct 2026 17:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209051;
	bh=yWZulVmQugojBIYkGDjOPzE8tNzKVytxubLAHfIvl2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UAUgMil68GmjXTRtt/c2H4ZfLoLeS8XeCyGqJ+d987GVRSI3AWD4YwHiqgN9Xwp3a
	 iSaxWALIhkAIN6013vEbgPTZctSG0L1FJrnbcAU27g7JsKi/UU5Ne02Gyg2LIAKRkF
	 Tzxec2xfaCVS1yyKFUaGhcgMtSmpjTupr1MUfFEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 5.10 336/516] mmc: sdhci-sprd: disable runtime PM on remove
Date: Wed, 28 Oct 2026 17:58:08 +0100
Message-ID: <20261028170011.447489956@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


