Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A1B12CDBF;
	Tue, 14 May 2024 10:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682233; cv=none; b=o/EEj1NiQr8GUVBuj6XmL5Ulu8rnk6u5BvPYN92nFINk15nTZisqFbg2GwMtf6RSOqdyEVkKQ1zQ2UEIqAO0ce5LAIRaNV9PA6U9CHBJe+MVKduurX3OkW4vTl6WYuWswIla81M6JqcMsak/EzXb9ypHSK/H704jgJWxkPYg+Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682233; c=relaxed/simple;
	bh=yobceU0c0ZE+3TIa/4fFnalsD4cOPdwrkk5DNUCCQvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qt7YGMXWK0YJvPS9t4ovsQhcKUkGFZ48yEm+hYtXgZP11Hs1ZZrNYng3+vaLToa718L5zcIJNIwBhgHh5J7J0O17Fn2zjpj3M7JLvvrnSyUpO2c/uvfgHR7CRWuZti90f7uF3/1JVYEJf+U4XsjcDCRuFOVSZzU7rcNFBygYRr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LplOhK3V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LplOhK3V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A6FEC2BD10;
	Tue, 14 May 2024 10:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682233;
	bh=yobceU0c0ZE+3TIa/4fFnalsD4cOPdwrkk5DNUCCQvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LplOhK3VztC7ZQHR9dO+7DwWxrIXwIDc9LBttbbAeffe2sbmWvbglZA1T6bfEwM3i
	 R0YOSiIefOXl46usR2dZE0ijJ7YpW7AZLvrSrJOBS9jwqgL5dKS1QgBqdVViVwU43q
	 pSog7sEdDvb0TtWBgiGim8La4Gtmx0SXn5A3g64Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 032/336] spi: axi-spi-engine: fix version format string
Date: Tue, 14 May 2024 12:13:56 +0200
Message-ID: <20240514101039.822119739@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 6b0c72bf3395f..2b07b6dbf8a34 100644
--- a/drivers/spi/spi-axi-spi-engine.c
+++ b/drivers/spi/spi-axi-spi-engine.c
@@ -658,7 +658,7 @@ static int spi_engine_probe(struct platform_device *pdev)
 
 	version = readl(spi_engine->base + ADI_AXI_REG_VERSION);
 	if (ADI_AXI_PCORE_VER_MAJOR(version) != 1) {
-		dev_err(&pdev->dev, "Unsupported peripheral version %u.%u.%c\n",
+		dev_err(&pdev->dev, "Unsupported peripheral version %u.%u.%u\n",
 			ADI_AXI_PCORE_VER_MAJOR(version),
 			ADI_AXI_PCORE_VER_MINOR(version),
 			ADI_AXI_PCORE_VER_PATCH(version));
-- 
2.43.0



