Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61BA81FF61E;
	Mon,  2 Jun 2025 14:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875114; cv=none; b=UQXikbLQUhqhaSKGe38ku+FfSozgTgfLFoe09jZejscm/Y1FYYGlev2kMNw8WK6sX7u0w9UEROn9axCZrEQJC6X10ya57ZWXnkbu6Q1w2zd/pHK1tXbZxPcruNReUPn9QzVMIMfNF3oE4E8U0wvdFBBFFs2j44mJ1eP+zGMSJXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875114; c=relaxed/simple;
	bh=ReXL8bjJON4H31d8Db1qGZRU27TnY1CgqsbXQPRep40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ovWoOOfsjGcHCi2PgRm09znRDFmYFXLxDN3ToDwARdwF4Wp33bROE2WqshqHTCYlrrv8dViEWikwj4XYNI0vcToQlhcol5auvmQTpdS9sVr4dJPcaX3syX09YXIqU2sg4AjKUEJRpC9cOMcMl8YyieuEjVV7ePemhMau/EJrVcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h3cbs3Bu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h3cbs3Bu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A75C4CEEB;
	Mon,  2 Jun 2025 14:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875114;
	bh=ReXL8bjJON4H31d8Db1qGZRU27TnY1CgqsbXQPRep40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h3cbs3BusOf56DE4BMOkm3oYzeLNs7ZSeJ+N7BhI8jDrPKMb1Qk8Pc2O/5+cog/lz
	 J0dbuu0JsN1bicbrRx3SFEPWMzCm0h6AyzqCQcnsgUVoYvXInejcme/co9uqGrJqwy
	 QLilxo1X+x5ASw2xF0aZ1qJsat65GUSgKRKtNI8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ihar Salauyou <salauyou.ihar@gmail.com>,
	Ruslan Piasetskyi <ruslan.piasetskyi@gmail.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 008/270] mmc: renesas_sdhi: Fix error handling in renesas_sdhi_probe
Date: Mon,  2 Jun 2025 15:44:53 +0200
Message-ID: <20250602134307.537847659@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruslan Piasetskyi <ruslan.piasetskyi@gmail.com>

commit 649b50a82f09fa44c2f7a65618e4584072145ab7 upstream.

After moving tmio_mmc_host_probe down, error handling has to be
adjusted.

Fixes: 74f45de394d9 ("mmc: renesas_sdhi: register irqs before registering controller")
Reviewed-by: Ihar Salauyou <salauyou.ihar@gmail.com>
Signed-off-by: Ruslan Piasetskyi <ruslan.piasetskyi@gmail.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Tested-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250326220638.460083-1-ruslan.piasetskyi@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/renesas_sdhi_core.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/mmc/host/renesas_sdhi_core.c
+++ b/drivers/mmc/host/renesas_sdhi_core.c
@@ -1108,26 +1108,26 @@ int renesas_sdhi_probe(struct platform_d
 	num_irqs = platform_irq_count(pdev);
 	if (num_irqs < 0) {
 		ret = num_irqs;
-		goto eirq;
+		goto edisclk;
 	}
 
 	/* There must be at least one IRQ source */
 	if (!num_irqs) {
 		ret = -ENXIO;
-		goto eirq;
+		goto edisclk;
 	}
 
 	for (i = 0; i < num_irqs; i++) {
 		irq = platform_get_irq(pdev, i);
 		if (irq < 0) {
 			ret = irq;
-			goto eirq;
+			goto edisclk;
 		}
 
 		ret = devm_request_irq(&pdev->dev, irq, tmio_mmc_irq, 0,
 				       dev_name(&pdev->dev), host);
 		if (ret)
-			goto eirq;
+			goto edisclk;
 	}
 
 	ret = tmio_mmc_host_probe(host);
@@ -1139,8 +1139,6 @@ int renesas_sdhi_probe(struct platform_d
 
 	return ret;
 
-eirq:
-	tmio_mmc_host_remove(host);
 edisclk:
 	renesas_sdhi_clk_disable(host);
 efree:


