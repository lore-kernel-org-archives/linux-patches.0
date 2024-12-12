Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D7A1487CD;
	Thu, 12 Dec 2024 17:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023782; cv=none; b=ktQhKrOgbXSJ+PtTHQFg5lxIDMdZDdKzn2EmGFraMBAvNc0ekCJYzn+XbaKVgakTD95RUsj2kFQq8/90odai/bafVhQV/MrMPeLanEN7WVWZH/1qrOPl+yGmnFUg2PiiApiwZLHLnAGiqPGulrF+2mlgCRnpUAFFxXbyovyc6Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023782; c=relaxed/simple;
	bh=VCeUuX9eoKOUeIzNqzIKVh718WTsy28cCT/u65FXIpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IdxHi5RB8K58b8awoxl9XbFbf6wSjNU5WaYuz/MUNFiGO1Q4DIPVR1T2leg+4ZGPvvakW1sLujLQw2EOjNOda61q7EjBLQmI+Fl0QsLtGHzxTSi4EwaftxK2yzzx7VPtEu4lIGj8TzfQxSxbUx0V3YJ99a1kp0VxsNBK8rxK638=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jpRfPa0m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jpRfPa0m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF7EC4CECE;
	Thu, 12 Dec 2024 17:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023782;
	bh=VCeUuX9eoKOUeIzNqzIKVh718WTsy28cCT/u65FXIpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jpRfPa0mgn8/tSrayge8au24h1uCexi0HMw4j0QAKv8Gk6NAA/pCuFOV6EGfxC+44
	 KMRUybidtJCb3YmTeRxn/wiCzGZd2a9/8C4ZtZmMtT2twC7I3bSPLzlcNCJJbnT6TH
	 kekUF9HTNJ+qwcQhlN9+KuqS9JmC2HlxJM00/OpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 080/459] spi: spi-fsl-lpspi: downgrade log level for pio mode
Date: Thu, 12 Dec 2024 15:56:58 +0100
Message-ID: <20241212144256.680788296@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit d5786c88cacbb859f465e8e93c26154585c1008d ]

Having no DMA is not an error. The simplest reason is not having it
configured. SPI will still be usable, so raise a warning instead to
get still some attention.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://lore.kernel.org/r/20230531072850.739021-1-alexander.stein@ew.tq-group.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 003c7e01916c ("spi: spi-fsl-lpspi: Use IRQF_NO_AUTOEN flag in request_irq()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-lpspi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-fsl-lpspi.c b/drivers/spi/spi-fsl-lpspi.c
index 8ab3105ae8c07..efd2a9b6a9b26 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -909,7 +909,7 @@ static int fsl_lpspi_probe(struct platform_device *pdev)
 	if (ret == -EPROBE_DEFER)
 		goto out_pm_get;
 	if (ret < 0)
-		dev_err(&pdev->dev, "dma setup error %d, use pio\n", ret);
+		dev_warn(&pdev->dev, "dma setup error %d, use pio\n", ret);
 	else
 		/*
 		 * disable LPSPI module IRQ when enable DMA mode successfully,
-- 
2.43.0



