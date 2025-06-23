Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 032C61E5B71;
	Mon, 23 Jun 2025 21:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714121; cv=none; b=Qw6maESG40O1LqUpQz+et+naNR1vPqvCf6j5rWj4Si4gKq/EwL0Kjcq8GbuEkG0+6188X9HENBUeZyBcNGur8u46PFHvmCEoIYYZFywm7epkF2fHHMqxdVUiKizEcESpK3arxnUYSrShy3yg12fekDCUAmsgAvbX6+HTjR889Gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714121; c=relaxed/simple;
	bh=BlD9o4fbN+szLnve2qwsX015eXXxrlaGNy9yuxS3xp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OlLDmBv5pZ0c/RDX9Xdr0DuMnCITxv2EXheRsRlE0ZOBqzaSYxgeLFoC5PO2MRk34sFAoblLvtWZ1p42nxIqhJlgTJ6Bgwjyb9vf4geu0WcNBDzHddcja8slaVqwiytIaZjLuAcHrPvog6GY/FKu55OGFnP2f5v3wS6SfPVCKaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e4Mlnt4t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e4Mlnt4t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EF6CC4CEEA;
	Mon, 23 Jun 2025 21:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714120;
	bh=BlD9o4fbN+szLnve2qwsX015eXXxrlaGNy9yuxS3xp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e4Mlnt4t+GnRU/VinDcr8PkyuTC7FvlkWtvUL81itdOPkoa88uBJlVkZqznisJyyG
	 j5UhfsIjZLCD7jHuJoU55VD23APsTl9zAWLiSkRPYPqBGkg0JH5ekLBFyQEntk4ti/
	 t2LybmgZDtSXv2bUPPTEKleDbd2N9OiTG+Wlucdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 173/508] spi: bcm63xx-spi: fix shared reset
Date: Mon, 23 Jun 2025 15:03:38 +0200
Message-ID: <20250623130649.531362290@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



