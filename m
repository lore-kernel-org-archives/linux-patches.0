Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F03237A3C;
	Thu, 12 Dec 2024 16:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021966; cv=none; b=sb33rR0LLjDg63eH9xW6gfjwvrMLggaHpzv3DJ0f3Ewyo0Zd+4DVcWCb3shPzE7eZFruZ07nxjR0tUiJRcT4M79GM+fcOZpTl9K8pW1w1jVXfyTCmjAMQfenyPzhzRYVYuX/fcgiZMVAtIzJs+Ss6AwQdJoyptOmQPxXn+eIoao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021966; c=relaxed/simple;
	bh=5xQM2zGP5fkp4PrvvNY7KsvgfH30c2V2yxxFuUUhySY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gwx2fIOVhn2g6To/Pki5RQ6LXS2kXsqaJPlbQGqkTY0/mEuMULZh1mtMjNuLr6lB0zGroGpHXogcn1dXGzbM9QSSncKriJqMbVATNmlXaPrGAkIdQOeV3IH74Q2L8wj6Y61CBU+v7Oa16X6mYH4dTNUoSzRybpB4jpG4FxkY2g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v+pnvC6H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v+pnvC6H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6D8C4CECE;
	Thu, 12 Dec 2024 16:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021965;
	bh=5xQM2zGP5fkp4PrvvNY7KsvgfH30c2V2yxxFuUUhySY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v+pnvC6HOqqKitJEvnYlwM+kOeo3Q81oKrTESfACCeM3pruvedx7uV2Dcy9adsmOF
	 5UiLw61LafGHAXuywD1DROLF9tanruzYPQOwzGPR2PUQRopPJjDx+AnLlGEi0+vJLL
	 ooxQoqpsarBmsW8r9fowvNbg7cyHYBg9mJHxA/4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 110/565] spi: spi-fsl-lpspi: downgrade log level for pio mode
Date: Thu, 12 Dec 2024 15:55:05 +0100
Message-ID: <20241212144315.823960083@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



