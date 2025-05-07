Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A22F288A8;
	Wed,  7 May 2025 19:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644481; cv=none; b=NbQWdO2UOOghRXATZpaHU1t2tP4paGX9O/BVwY9H/67V1oapi6XusWSLPp/AweB6Fk0BLrbDy4HgUV3m04e90t5pqs3903Amsqahrm+hr+t+Ex09x9lZ/lvf/wMgz5lM+T9/NVDVVjlrbkAwmYNTLpzBH6n0SIa4WIiHG8waDkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644481; c=relaxed/simple;
	bh=tih45WD9HL8kum2A/3si0srtAYWvUJOO9DTV+cWz5go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sWCTlJqXA4d3Il+6HtkIRZjij7zJ0aowp0CEuW9vljIWdl0/aPqfkPEJfTBMOlRvC2gxu//K8quWd4EoQ+ZVlEWySBWcv/KhbS5qwMtAh6/Jog9Yv2hmYF3yUFe1A6aJXjO49tF/qkxku2Whf4qyfqiKz3/qojhbo9yP4ktxv4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M6uVdFVo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M6uVdFVo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B551C4CEE9;
	Wed,  7 May 2025 19:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644481;
	bh=tih45WD9HL8kum2A/3si0srtAYWvUJOO9DTV+cWz5go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M6uVdFVool91/5L3XaFpwOmT5qf8V0KVqPZkFKTKNFzpHJV6SXE37v9Zjd570chc2
	 VzKmBDQQ0iFqhQnKY4hOZTbVUf4QZURM/fC70KhXGyYUrCpjNhD6RYHcCg4gwZUF04
	 +LYfNHcRHlPSh7oqK0P7sIzbSGzFUxZ6SPB3nUS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ihar Salauyou <salauyou.ihar@gmail.com>,
	Ruslan Piasetskyi <ruslan.piasetskyi@gmail.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.12 027/164] mmc: renesas_sdhi: Fix error handling in renesas_sdhi_probe
Date: Wed,  7 May 2025 20:38:32 +0200
Message-ID: <20250507183821.967161964@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1112,26 +1112,26 @@ int renesas_sdhi_probe(struct platform_d
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
@@ -1143,8 +1143,6 @@ int renesas_sdhi_probe(struct platform_d
 
 	return ret;
 
-eirq:
-	tmio_mmc_host_remove(host);
 edisclk:
 	renesas_sdhi_clk_disable(host);
 efree:


