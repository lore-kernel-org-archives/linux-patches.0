Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F567BB02;
	Wed, 21 Feb 2024 13:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523616; cv=none; b=ZhxlPRVuoxmqUHxpHcRrJDX5F8nvvgwPAdW7MfaHTKHSAJ6zX2PVF7hZegYSM4/ptUfb2SDugxNhEL1NmhCE3Uw4leLwy9TBy7NzLVqt6fmBnTllEY4ad74H0ZiiOq6WcOvwMCKRqSak9rdhL7rjwM08EcdxerZG9La1TuqBoJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523616; c=relaxed/simple;
	bh=O1mtQzytfF246fqnDcFYtVlFwHiKDzItq2aY9+crEoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bV/UgVAFLQEs/bxEfxgQzgl1tA3P2Hp8xnSB0bAk6eSDpm0vFOArOSfHZtrmSp1s8UpC6F7WR+4A6hOPhRegkfv1p4faa0vJxxn0wbv9sqwO64VO8MDDa8I0f/zOV89j8wnnrLTLH2kL3fsNFkFa2IMsdQhOUCHotbTrjQQN+68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FL1fi+wA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FL1fi+wA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F204CC43390;
	Wed, 21 Feb 2024 13:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523616;
	bh=O1mtQzytfF246fqnDcFYtVlFwHiKDzItq2aY9+crEoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FL1fi+wAAnZCfcw6KD4QDf/15/nriqGg0dmhSNFByX2yjO3+aq6OLpWeU1p6T0fut
	 51vsfDyxlBu3tylJZdyhKacaHLDNf0k7rKNp8nSyJR2YT+sTNFEbK3JRn4ClbPjNyW
	 tXRTScLSEX2tra646gQwyPJn1C3Wm3pyibRVs3SQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 011/379] serial: sc16is7xx: add check for unsupported SPI modes during probe
Date: Wed, 21 Feb 2024 14:03:10 +0100
Message-ID: <20240221125955.256006545@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

[ Upstream commit 6d710b769c1f5f0d55c9ad9bb49b7dce009ec103 ]

The original comment is confusing because it implies that variants other
than the SC16IS762 supports other SPI modes beside SPI_MODE_0.

Extract from datasheet:
    The SC16IS762 differs from the SC16IS752 in that it supports SPI clock
    speeds up to 15 Mbit/s instead of the 4 Mbit/s supported by the
    SC16IS752... In all other aspects, the SC16IS762 is functionally and
    electrically the same as the SC16IS752.

The same is also true of the SC16IS760 variant versus the SC16IS740 and
SC16IS750 variants.

For all variants, only SPI mode 0 is supported.

Change comment and abort probing if the specified SPI mode is not
SPI_MODE_0.

Fixes: 2c837a8a8f9f ("sc16is7xx: spi interface is added")
Cc:  <stable@vger.kernel.org>
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20231221231823.2327894-3-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sc16is7xx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index dfaca09de79b..31e0c5c3ddea 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -1450,7 +1450,10 @@ static int sc16is7xx_spi_probe(struct spi_device *spi)
 
 	/* Setup SPI bus */
 	spi->bits_per_word	= 8;
-	/* only supports mode 0 on SC16IS762 */
+	/* For all variants, only mode 0 is supported */
+	if ((spi->mode & SPI_MODE_X_MASK) != SPI_MODE_0)
+		return dev_err_probe(&spi->dev, -EINVAL, "Unsupported SPI mode\n");
+
 	spi->mode		= spi->mode ? : SPI_MODE_0;
 	spi->max_speed_hz	= spi->max_speed_hz ? : 4 * HZ_PER_MHZ;
 	ret = spi_setup(spi);
-- 
2.43.0



