Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF9B7DA78;
	Thu, 15 Aug 2024 13:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728974; cv=none; b=ghAH2Uw9qGU5XKaU/Y2RWuiZYMUgwBNHdpxW59G0EiayWPy2lcBLr3qdzz8sLxoK8l4gwXmfQFDaFnwQbBt0d2NRb308Faj44tIrCamGYo5jiu5GKOPzrn2aQ5iUEsp6UHRhLVUSToE9AHr21fplfcfMNmuv32NN/4FI4TkA0tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728974; c=relaxed/simple;
	bh=6IiyBH8b9u3M6I/iaQYfgfCVX6ECxKAn7G6haKDCSEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X3bZhc6veCr1mFgaK1wSqNwylGqlMK+A9Mxq78CzbLBozwAnoWK0y+/Ss26mip+Xgc7MekJS3dk1DfvoLj+WCt8/TqEzVvmw3hyZEktB/bHuIrD+dLMUSCB7XqeQOCGpsQax/vk3gTWia6Au2wfkbIIFq8lfK625kopBvFhMrIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vG68T85O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vG68T85O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C40B9C32786;
	Thu, 15 Aug 2024 13:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728974;
	bh=6IiyBH8b9u3M6I/iaQYfgfCVX6ECxKAn7G6haKDCSEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vG68T85OnoUGlBRjCyPK/IQ4V78/jqAwezb0c1njVxOZoCUNRBEtkaKiBh+v3Ri8l
	 G9gRM+chH1G5P72D81IJylBPMXI0GzakqWdkGYu8iHZwRqZ1yw5EXhahXDZTwS2LXl
	 EBJeOyNqIHnPj7gGFhb+UIlvrkQIvqdfe1vEi4GI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksandr Suvorov <oleksandr.suvorov@toradex.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 170/196] spi: fsl-lpspi: remove unneeded array
Date: Thu, 15 Aug 2024 15:24:47 +0200
Message-ID: <20240815131858.575215374@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksandr Suvorov <oleksandr.suvorov@toradex.com>

[ Upstream commit 2fa98705a9289c758b6154a22174aa8d4041a285 ]

- replace the array with the shift operation
- remove the extra comparing operation.

Signed-off-by: Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
Link: https://lore.kernel.org/r/20200220141143.3902922-2-oleksandr.suvorov@toradex.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 730bbfaf7d48 ("spi: spi-fsl-lpspi: Fix scldiv calculation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-lpspi.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi-fsl-lpspi.c b/drivers/spi/spi-fsl-lpspi.c
index 8e1f6ee0a7993..21c8866ebbd12 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -67,8 +67,6 @@
 #define TCR_RXMSK	BIT(19)
 #define TCR_TXMSK	BIT(18)
 
-static int clkdivs[] = {1, 2, 4, 8, 16, 32, 64, 128};
-
 struct lpspi_config {
 	u8 bpw;
 	u8 chip_select;
@@ -271,15 +269,14 @@ static int fsl_lpspi_set_bitrate(struct fsl_lpspi_data *fsl_lpspi)
 	}
 
 	for (prescale = 0; prescale < 8; prescale++) {
-		scldiv = perclk_rate /
-			 (clkdivs[prescale] * config.speed_hz) - 2;
+		scldiv = perclk_rate / config.speed_hz / (1 << prescale) - 2;
 		if (scldiv < 256) {
 			fsl_lpspi->config.prescale = prescale;
 			break;
 		}
 	}
 
-	if (prescale == 8 && scldiv >= 256)
+	if (scldiv >= 256)
 		return -EINVAL;
 
 	writel(scldiv | (scldiv << 8) | ((scldiv >> 1) << 16),
-- 
2.43.0



