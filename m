Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B00D528;
	Sun,  7 Sep 2025 20:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276839; cv=none; b=XZqStMnFZvCGYcCCk32h3lAVnX/txDJH7RXW2qPpxCeDinkYJmZj9FhDMkm3BGtbqe1XAcuJUC7LUK8QuAjrkyVbSV/33XGgSEAD9Wv3+PdYltArgPmiFRmYG8Y4H3Cq3usFTHj+SqaUeZ+5ecXAQtIbMocDxKveJKMaW6JTv1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276839; c=relaxed/simple;
	bh=UcQy19zZOI6OUwMOz7cEEr62yY+2xUrMHcWd0Z7sepM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aZkJzj/mP5LefdIeSjgBmejPkO5LjER9ezhq5NNmhtc/p6S1jHFSUoEb86tQOxdogRzG9HFdUVmuTpjB71f+gULoukpE6a8ZPejhZ1Zg5IkrGczVupLTTwPdGnEmRK1ViKoTfMJQ924GdQyRYv1FzZtsSm+ak/NTbxkEeZCJ+F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jwkqxuev; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jwkqxuev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B58EAC4CEF0;
	Sun,  7 Sep 2025 20:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276839;
	bh=UcQy19zZOI6OUwMOz7cEEr62yY+2xUrMHcWd0Z7sepM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JwkqxuevFl347KXV5mWHAC7TssrQtyDFd5Gfag+iBHvkUl803rApVA1hN3pigCkF7
	 M9syv0mJB2r0VtQxXsS3o7opa49U3mbSB8t4+MycpY6ogcfY4F7TKb2D7bYYXjJyD8
	 TjuZqclhxptWTdwq8HH+6D1jyxDY8RWLh8h2GC2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Larisa Grigore <larisa.grigore@nxp.com>,
	James Clark <james.clark@linaro.org>,
	Frank Li <Frank.Li@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 103/121] spi: spi-fsl-lpspi: Set correct chip-select polarity bit
Date: Sun,  7 Sep 2025 21:58:59 +0200
Message-ID: <20250907195612.495385519@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larisa Grigore <larisa.grigore@nxp.com>

[ Upstream commit cbe33705864ba2697a2939de715b81538cf32430 ]

The driver currently supports multiple chip-selects, but only sets the
polarity for the first one (CS 0). Fix it by setting the PCSPOL bit for
the desired chip-select.

Fixes: 5314987de5e5 ("spi: imx: add lpspi bus driver")
Signed-off-by: Larisa Grigore <larisa.grigore@nxp.com>
Signed-off-by: James Clark <james.clark@linaro.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20250828-james-nxp-lpspi-v2-2-6262b9aa9be4@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-lpspi.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-fsl-lpspi.c b/drivers/spi/spi-fsl-lpspi.c
index 06c4fccf2f16d..b1ed34d237948 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -5,6 +5,7 @@
 // Copyright 2016 Freescale Semiconductor, Inc.
 // Copyright 2018, 2023, 2025 NXP
 
+#include <linux/bitfield.h>
 #include <linux/clk.h>
 #include <linux/completion.h>
 #include <linux/delay.h>
@@ -70,7 +71,7 @@
 #define DER_TDDE	BIT(0)
 #define CFGR1_PCSCFG	BIT(27)
 #define CFGR1_PINCFG	(BIT(24)|BIT(25))
-#define CFGR1_PCSPOL	BIT(8)
+#define CFGR1_PCSPOL_MASK	GENMASK(11, 8)
 #define CFGR1_NOSTALL	BIT(3)
 #define CFGR1_HOST	BIT(0)
 #define FSR_TXCOUNT	(0xFF)
@@ -420,7 +421,9 @@ static int fsl_lpspi_config(struct fsl_lpspi_data *fsl_lpspi)
 	else
 		temp = CFGR1_PINCFG;
 	if (fsl_lpspi->config.mode & SPI_CS_HIGH)
-		temp |= CFGR1_PCSPOL;
+		temp |= FIELD_PREP(CFGR1_PCSPOL_MASK,
+				   BIT(fsl_lpspi->config.chip_select));
+
 	writel(temp, fsl_lpspi->base + IMX7ULP_CFGR1);
 
 	temp = readl(fsl_lpspi->base + IMX7ULP_CR);
-- 
2.51.0



