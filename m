Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F87D139590;
	Tue, 14 May 2024 11:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686284; cv=none; b=L6eqlIpY0WrTsOSVOcF0DPfqSTRLCCKX9X8Gw7hoL+aTLIJDUvSyw5cDUL1AC6kowqD0MGd4jmDNwoTtfxk2J3l3VHd7Yl1qk2G9v7Fx3eW42yflzrPd3o0PD3h3YAKeA1biUogQCVXWpyZi03kYH4PTaDfcTZCcG2/Qnn7fL9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686284; c=relaxed/simple;
	bh=SbYdU1tNfsc1EttR4DzXoKEwNOdPif34K1tOeCvjtyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ltsMu6ATFnhjcI5nYe+9TbEeFGgSU/f+mHFuLMozUlVnoQ9kUBnIapeujzO6eF6+CBaL58fMJmSBu+tmroQIjOSfkvEbtAQjs9i+Z7ve+y7Tdt3+X2nzR0FQOPCt28+s+58k1apbM+sAKv6yf9Ff/SMuTPMYD8cd04PyY/M1dO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=in1bt71s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="in1bt71s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D6DC4AF09;
	Tue, 14 May 2024 11:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686283;
	bh=SbYdU1tNfsc1EttR4DzXoKEwNOdPif34K1tOeCvjtyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=in1bt71sTqN+hvwKYNmOmc5Kj2na3vGRgGhJmlZDFruqi0SYhTo59SL05YfZp857e
	 SDS3MP3GFVAE/Uosbd8PGQmmN0NZJi62JCe9vLkA8FGLo16L9xzIYVq7yFqdbF3zRu
	 E6Zn7t5A5aWqg4eEcYShdWhPWCNGwY3RZTHhEU6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 052/236] spi: axi-spi-engine: fix version format string
Date: Tue, 14 May 2024 12:16:54 +0200
Message-ID: <20240514101022.320956265@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 719e4f7445361..a5f0a61b266f1 100644
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



