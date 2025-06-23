Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F967482;
	Mon, 23 Jun 2025 21:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713329; cv=none; b=GKm4GP9YDwo65w6RariOWgvtBpSu3Gs6bSvc9g54LtM9dpiVlOxL2G9NqT3IAIcAlrDjMQ4XG1A4uvl7KYiZaIqLhJ2lHDxaoQnn8g8+6I5EKplvHdL53rVCkBqGafQX1NwoDSGqxeqoe693y5WS0afPsA+oPWPlXFkwmzEou3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713329; c=relaxed/simple;
	bh=rP9DLaa2x5aRufAow3jfk2ztRbUX9ZnkYIIPg7U+bjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rAgD3pNmM2Stiu3YL3QdLGJECRpLGFPbqoW7bEdKTFpbql0BLNYJBf3R5n9HuRCCRptWofkhlSif4xm+qe5Xej4DkB+pNnMY9ZjOgbpVe5UOf8KvizwhT8gYdZ4bWImMd32yPKpr6PQ7oMsChHfePRz5T+hPgd4eM8f9/ml6LqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EVDvX1cO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EVDvX1cO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17DDC4CEEA;
	Mon, 23 Jun 2025 21:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713329;
	bh=rP9DLaa2x5aRufAow3jfk2ztRbUX9ZnkYIIPg7U+bjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EVDvX1cO4PG897aNIw5zy8q22MbnQIJ8Qida75aPKC0OHAHR2R3052AUCMFmd9Nke
	 YCORtkaDrpdrBpklJx/BnVGrD34kdmZBS8tLC3CcvWSTPP8i2cL9R0OamBSscobMC5
	 Yxp8J/0XWImdHV/3e4S8FtYjeFTQUX6hgSwrAhUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 117/411] spi: bcm63xx-spi: fix shared reset
Date: Mon, 23 Jun 2025 15:04:21 +0200
Message-ID: <20250623130636.486446461@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Álvaro Fernández Rojas <noltari@gmail.com>

[ Upstream commit 5ad20e3d8cfe3b2e42bbddc7e0ebaa74479bb589 ]

Some bmips SoCs (bcm6362, bcm63268) share the same SPI reset for both SPI
and HSSPI controllers, so reset shouldn't be exclusive.

Fixes: 38807adeaf1e ("spi: bcm63xx-spi: add reset support")
Reported-by: Jonas Gorski <jonas.gorski@gmail.com>
Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250529130915.2519590-2-noltari@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm63xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-bcm63xx.c b/drivers/spi/spi-bcm63xx.c
index 695ac74571286..2f2a130464651 100644
--- a/drivers/spi/spi-bcm63xx.c
+++ b/drivers/spi/spi-bcm63xx.c
@@ -533,7 +533,7 @@ static int bcm63xx_spi_probe(struct platform_device *pdev)
 		return PTR_ERR(clk);
 	}
 
-	reset = devm_reset_control_get_optional_exclusive(dev, NULL);
+	reset = devm_reset_control_get_optional_shared(dev, NULL);
 	if (IS_ERR(reset))
 		return PTR_ERR(reset);
 
-- 
2.39.5



