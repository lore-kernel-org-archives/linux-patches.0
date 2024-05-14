Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74C712FF64;
	Tue, 14 May 2024 11:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684424; cv=none; b=UNA7BJ0OExPMs8dTrvR/MzG7jV0Fb80952fzZwQN/hMJCoba9gIF7iuONbltoyHs6f+yTjX0ebNs4RdVC4ExTQA+JPRTy2DQM5ii0v0wswM9IMKAEP1YRPNH8MLR/+PRVAzH+yTKcCFFtrAyQ4YOfPEwrHDNz8Rvwf8FB+xxaF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684424; c=relaxed/simple;
	bh=gAzR9Wz+OeF+jZYER4CoGTQ4pflvRDmAesVSl4n4dOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nK5uoOCRjjJGUM4NQasF5/GlyyPtLvI4llbRa74v7W1SFTR92MIeu4nEjf/1PEGvdOPVA3IcjkkWJBPrjt0G+J4Huh43wNH7gCmP9aROB1bzxQMnuuYeJ4NDjnBKCUnnhbfPMemOgo2773kohoPfoTLfmGDIk9kIBndYMVifCGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pp/NcwL5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pp/NcwL5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 227BBC32781;
	Tue, 14 May 2024 11:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684424;
	bh=gAzR9Wz+OeF+jZYER4CoGTQ4pflvRDmAesVSl4n4dOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pp/NcwL5Y6MxkZrE6h422rJdcq+g5npkwrtvxTopjmlWyX8b/UubIFBK9EEU4iiKF
	 ZIPRgx4HX/No5UWdYiCCrVoWSiBM0g67xqFIyE5CLvKIQ+0Fhf+CyqXUHy/3XQ7uon
	 ROkQAd24mTmkjRq3J0UHAdeZueNE8+MQuEqP/jQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 040/301] spi: axi-spi-engine: fix version format string
Date: Tue, 14 May 2024 12:15:11 +0200
Message-ID: <20240514101033.759063488@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit 0064db9ce4aa7cc794e6f4aed60dee0f94fc9bcf ]

The version format string in the AXI SPI Engine driver was probably
intended to print the version number in the same format as the DT
compatible string (e.g. 1.00.a). However, the version just uses
semantic versioning so formatting the patch number as a character
is not correct and would result in printing control characters for
patch numbers less than 32.

Fixes: b1353d1c1d45 ("spi: Add Analog Devices AXI SPI Engine controller support")
Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://lore.kernel.org/r/20240412-axi-spi-engine-version-printf-v1-1-95e1e842c1a6@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-axi-spi-engine.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-axi-spi-engine.c b/drivers/spi/spi-axi-spi-engine.c
index 9c7b6a92417ce..9faee4fcc049a 100644
--- a/drivers/spi/spi-axi-spi-engine.c
+++ b/drivers/spi/spi-axi-spi-engine.c
@@ -532,7 +532,7 @@ static int spi_engine_probe(struct platform_device *pdev)
 
 	version = readl(spi_engine->base + ADI_AXI_REG_VERSION);
 	if (ADI_AXI_PCORE_VER_MAJOR(version) != 1) {
-		dev_err(&pdev->dev, "Unsupported peripheral version %u.%u.%c\n",
+		dev_err(&pdev->dev, "Unsupported peripheral version %u.%u.%u\n",
 			ADI_AXI_PCORE_VER_MAJOR(version),
 			ADI_AXI_PCORE_VER_MINOR(version),
 			ADI_AXI_PCORE_VER_PATCH(version));
-- 
2.43.0



