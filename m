Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5133D994;
	Wed,  4 Feb 2026 15:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217932; cv=none; b=N5AuE3albtzonk96D5+l1kPWty53fEgt6p1fNgVZL94HImtTnVb/S3wL9O32Ry9ZWXJN7VSGZ9zJk+MziDhYQaVmPNeRc2UoEtXyR4+2aGU7/vwQpunBV0I+X8DOSlv9iWmunmpLm+swiUbGHfZ4neZm2k8JwEEp3W4XKpPvutg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217932; c=relaxed/simple;
	bh=VW9Ayz1QQiDtFWuWrf8EaklQHzqixiuuJ+x2+SVsOu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r8UbSIjoaznuOBm0Q8aH+3HO1idGqFcnfOfMsQZx9dkqttUAce03S/zLL6hMVVD/doLZjq2TniWnHjUjpi1IYvqZJUJ5XCwooRAstKAHq8CoFwegM/MiD3LwEJ/28EExqUxhWXiOTM5+431B5uHbhbqQ+60vx2g0cmWommbEBRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jCAKWhvd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jCAKWhvd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C9BC4CEF7;
	Wed,  4 Feb 2026 15:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217932;
	bh=VW9Ayz1QQiDtFWuWrf8EaklQHzqixiuuJ+x2+SVsOu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jCAKWhvdhMCFB5gEdcrQod9cPC05hakuAVJFI1sZHxDhZRS9UB8ANjHYvuGA4rC6t
	 +o3JasZqzQan8k6zqnyEUgjWY6F7gGfWHW+BGORxiUeDmJXEXWpBdUhjCHSuDIOyp0
	 kloD+b6C/R7hq2xtIeThdpg+yiTANERZlQSsQvMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Li <yang.lee@linux.alibaba.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 129/280] spi: sprd-adi: Use devm_platform_get_and_ioremap_resource()
Date: Wed,  4 Feb 2026 15:38:23 +0100
Message-ID: <20260204143914.277004404@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Li <yang.lee@linux.alibaba.com>

[ Upstream commit 8499d4b5970f5fd135ee8860075768562a5efe70 ]

According to commit 890cc39a8799 ("drivers: provide
devm_platform_get_and_ioremap_resource()"), convert
platform_get_resource(), devm_ioremap_resource() to a single
call to devm_platform_get_and_ioremap_resource(), as this is exactly
what this function does.

Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Link: https://lore.kernel.org/r/20230327060516.93509-1-yang.lee@linux.alibaba.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 383d4f5cffcc ("spi: spi-sprd-adi: Fix double free in probe error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-sprd-adi.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/spi/spi-sprd-adi.c b/drivers/spi/spi-sprd-adi.c
index 3b158124d79f7..22e39c4c12c4e 100644
--- a/drivers/spi/spi-sprd-adi.c
+++ b/drivers/spi/spi-sprd-adi.c
@@ -541,8 +541,7 @@ static int sprd_adi_probe(struct platform_device *pdev)
 	dev_set_drvdata(&pdev->dev, ctlr);
 	sadi = spi_controller_get_devdata(ctlr);
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	sadi->base = devm_ioremap_resource(&pdev->dev, res);
+	sadi->base = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
 	if (IS_ERR(sadi->base)) {
 		ret = PTR_ERR(sadi->base);
 		goto put_ctlr;
-- 
2.51.0



