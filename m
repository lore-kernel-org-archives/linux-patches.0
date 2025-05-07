Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E76D14A4C7;
	Wed,  7 May 2025 18:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643351; cv=none; b=r7VTiany2Z2dHFgnJ2KPI3e45kA+WDH92L9qsveRBeyb8Ud0+7K4f8UdXBxvstlnPLg7RMZvXbpdyYhCubcA/lPslZU4LuKuI97opuuy2wnXYtRyBG6pCGeT8W3jOIMJgdrcBXlRcDVXHhtX59XX68cY1uRS/PRyfrMEu6vsuhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643351; c=relaxed/simple;
	bh=ezxR5L8jTdsia5S/ZRAaJ+lDdWSak/5kddcf0hhu56U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ITfYnVFezjo2lAm/wOzDqLZEobJCxIv6tN2AB+wtX1yE22656sPv+HJ6Q279cp0tJS+K+A6nWVq+ZySa03XpYQQR0eeM2adlM0l59m9GEmrnR2FaKmNE1YOfi8mluWAyB9U/VxMRcTmO3LI8VfQxBkvMAUm+ABqg+Nmjdco1zG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GJHk9egw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GJHk9egw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79F33C4CEE2;
	Wed,  7 May 2025 18:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643350;
	bh=ezxR5L8jTdsia5S/ZRAaJ+lDdWSak/5kddcf0hhu56U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GJHk9egw5cTHxydJttE2Dko+Az+aZ/7LBC0EKbBIWlKn2k8YA+JJ6W2TuNA6ltsDY
	 spT+mKKG6COdg8tODNBWpni+539qlgHilfPIcSoBtsp8PDzaS6p2KU2Wqdps8bWCDN
	 AA1xcXWnRdzpc7EqWTbc1nKWEgYyZsp8QRcNc0Vs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ihar Salauyou <salauyou.ihar@gmail.com>,
	Ruslan Piasetskyi <ruslan.piasetskyi@gmail.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.15 09/55] mmc: renesas_sdhi: Fix error handling in renesas_sdhi_probe
Date: Wed,  7 May 2025 20:39:10 +0200
Message-ID: <20250507183759.427799684@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183759.048732653@linuxfoundation.org>
References: <20250507183759.048732653@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1078,26 +1078,26 @@ int renesas_sdhi_probe(struct platform_d
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
@@ -1109,8 +1109,6 @@ int renesas_sdhi_probe(struct platform_d
 
 	return ret;
 
-eirq:
-	tmio_mmc_host_remove(host);
 edisclk:
 	renesas_sdhi_clk_disable(host);
 efree:


