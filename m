Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B10419DF92;
	Thu, 15 Aug 2024 14:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731747; cv=none; b=Iiz8yrBAi5Z8AC00VjrTSv3kyGO4YEQXTbAOZs1/3knW1mG/PMXyIptejv9loC7Mfk7vc4ntOrXIQI7ZYwozqsZE9FQXJ0BEX7cFTKkRrMyYcdaDbWODBwlg6Cxu0twZFurSdMI+K0N2dGMNAjyxBlpgvs0dCjfnwsWmwzXSnew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731747; c=relaxed/simple;
	bh=3NLqioVRavUotdvV8xxvUxdNXfoHZeXXKyzQvGTzV90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NS/+vViLmn6vGtvBESA197Er2LR80ebEtFkeJyVVKMVH+YcuhHKubGa23yynJKlp4RnE6PRgNhoDDrbmDykoHeldgTWXT6FnZcB4cCsK/pXESp8O/P6G0QB51ecw6zCp0T9fHPYybQc+eK6cuDitldl+5axKKZJPkX6KW6hDy6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kTSSF2tn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kTSSF2tn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE095C4AF0C;
	Thu, 15 Aug 2024 14:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731747;
	bh=3NLqioVRavUotdvV8xxvUxdNXfoHZeXXKyzQvGTzV90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kTSSF2tnFOeoXh1rErwjuUkfLLuzrhuvv52TGgaeQH+j91TLmqkNTAx35tTOpsU7V
	 0lQc3QaeLpIF/MzQgR/jCY+8AwtJNnSAWKYXeFdt6rzaMWLZA0WJBNyAwI0nYl2qMl
	 SK1a0js5VpGoZFVPsfhHJJ52XMxII4tmzD/oYLOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksandr Suvorov <oleksandr.suvorov@toradex.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 225/259] spi: fsl-lpspi: remove unneeded array
Date: Thu, 15 Aug 2024 15:25:58 +0200
Message-ID: <20240815131911.463275579@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 58b2da91be1c0..5351185fd9af7 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -86,8 +86,6 @@
 #define TCR_RXMSK	BIT(19)
 #define TCR_TXMSK	BIT(18)
 
-static int clkdivs[] = {1, 2, 4, 8, 16, 32, 64, 128};
-
 struct lpspi_config {
 	u8 bpw;
 	u8 chip_select;
@@ -331,15 +329,14 @@ static int fsl_lpspi_set_bitrate(struct fsl_lpspi_data *fsl_lpspi)
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



