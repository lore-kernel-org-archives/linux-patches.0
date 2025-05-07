Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C98E14A4C7;
	Wed,  7 May 2025 18:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643461; cv=none; b=GcfraKL1rSF+EKaint21eK066uEWYl4IZDAqvyCVsaYYzaovKSWfI4bsY4cA80HiECg1s/GY8NWruEYDF80FzLtOMN4EjwNGQXUg4Z2J1djr/pSFtPGMVZ51tVHog9Gj5eYUvdKb0vOsOAewYr/Ajjm4WXSH0o4M3gvQBdL0mNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643461; c=relaxed/simple;
	bh=evhziQh+tlDnOP99huLH8+wbi8B5jR1xRUHJBNDAcmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WfXfESPhASAe6YOUeudZO+uoZc3zPKXr3bDZYVUP+rvm4DctFwJGH9w+zrj7zOgQD0LZIDPHwBpJehZ4LqOJXa7ugqE90jV1x7rdp6LIVneKq1HCp5psqPolSqiXRouW5FAAwi+pkLWgFj1fnalSE8Yl7wCAAqZxMyJj+itWq5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mihhDsIM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mihhDsIM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF967C4CEE2;
	Wed,  7 May 2025 18:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643461;
	bh=evhziQh+tlDnOP99huLH8+wbi8B5jR1xRUHJBNDAcmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mihhDsIMwRatX2i5NN5JOSxvQUGeiPbzwZk0HZHHYeagSqGamfLhYbA9Z8cQzUO1K
	 +EZ4vTwTTe1cJDo00vLW3XJ15xlF1DcN9lI9a/KbRDiJ4Dl0nCG0npaEbBgfbK6xLf
	 bW39kFBm2Rf753ww/G0K6w4t1PmtTV4LzcRCqa4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ihar Salauyou <salauyou.ihar@gmail.com>,
	Ruslan Piasetskyi <ruslan.piasetskyi@gmail.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 12/97] mmc: renesas_sdhi: Fix error handling in renesas_sdhi_probe
Date: Wed,  7 May 2025 20:38:47 +0200
Message-ID: <20250507183807.486566193@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183806.987408728@linuxfoundation.org>
References: <20250507183806.987408728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1109,26 +1109,26 @@ int renesas_sdhi_probe(struct platform_d
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
@@ -1140,8 +1140,6 @@ int renesas_sdhi_probe(struct platform_d
 
 	return ret;
 
-eirq:
-	tmio_mmc_host_remove(host);
 edisclk:
 	renesas_sdhi_clk_disable(host);
 efree:


