Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7EC91DF271;
	Tue, 17 Jun 2025 16:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178835; cv=none; b=cnaW5eCQInKL+eKWag/LRV61wmVpYyx9v0ItNUUQvx18AgZfRgD14K8gdCfLgz+ye8iMIZv3kBRrNyNQ1nEYUBSBtHi7vmqSktUMoU7ZQwEX/JQxOiZBWiiARQAxKOiJpiZnWfP0P6LflGydI5ePm0nvEX/69JzXII/biMUA6N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178835; c=relaxed/simple;
	bh=FIDmewxKZVuUTGQKV+TlEePVuDW9IA85PJaHvW3OHGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qYzBEMziwRWXYH99jjCwy68byEMKkTWofy9bTPDLEw7IAqI2p9/CF8AlW7HuZ58OsbDvYPj7jdK6Ur3vyKQn9kaDZWPfarp2+NQcp0ez6OD6eX7lDFyarj75mtCMFvqCrRT1iLVyFh0UmjiLNdjvLbwJBuyRfaLbqlGoMufDb3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=016T4YmJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="016T4YmJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E64E6C4CEE3;
	Tue, 17 Jun 2025 16:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178835;
	bh=FIDmewxKZVuUTGQKV+TlEePVuDW9IA85PJaHvW3OHGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=016T4YmJLJT+JlUHfverrwLaKtS1mEG6TgAnju3w4p5SWjOSaFyXwtMIlS0NRm88P
	 Ab0q+9IZCd7+sdcIHhrbbSeUmFX9OHQJkmc4m8JHxu3YhKv6yRpaoecGQXJ7vdQ1UC
	 fLK9USzF63CblK1K1nYynj1nMUV2J0d7jGhcma3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 567/780] spi: bcm63xx-spi: fix shared reset
Date: Tue, 17 Jun 2025 17:24:35 +0200
Message-ID: <20250617152514.571081001@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index c8f64ec69344a..b56210734caaf 100644
--- a/drivers/spi/spi-bcm63xx.c
+++ b/drivers/spi/spi-bcm63xx.c
@@ -523,7 +523,7 @@ static int bcm63xx_spi_probe(struct platform_device *pdev)
 		return PTR_ERR(clk);
 	}
 
-	reset = devm_reset_control_get_optional_exclusive(dev, NULL);
+	reset = devm_reset_control_get_optional_shared(dev, NULL);
 	if (IS_ERR(reset))
 		return PTR_ERR(reset);
 
-- 
2.39.5



