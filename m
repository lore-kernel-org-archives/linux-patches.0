Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0716615AFC
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:04:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC45C433CA;
	Tue, 25 Jul 2023 11:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283074;
	bh=8CNmmWFc9LAc7GEzGBxZ9Z/vYxAP72k3i3uL3QYfgnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2GNSaLOYdAafsTGdM4lUuqsMv0RKJXsgrJvneYbvuZ66nTqD2LCf8/lrV5ZqQbenw
	 HrqiJ4OSAPc3QATKNP7YpGpZ/Wnm8l07sICobsrBgjxSQnsLrNCcbXV+HWWesxdHfK
	 scYRmI5v6ncHJVzL77qP37qHqfOfVxI59mbXG7Lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaewon Kim <jaewon02.kim@samsung.com>,
	Chanho Park <chanho61.park@samsung.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 100/183] spi: s3c64xx: clear loopback bit after loopback test
Date: Tue, 25 Jul 2023 12:45:28 +0200
Message-ID: <20230725104511.556694987@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
References: <20230725104507.756981058@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jaewon Kim <jaewon02.kim@samsung.com>

[ Upstream commit 9ec3c5517e22a12d2ff1b71e844f7913641460c6 ]

When SPI loopback transfer is performed, S3C64XX_SPI_MODE_SELF_LOOPBACK
bit still remained. It works as loopback even if the next transfer is
not spi loopback mode.
If not SPI_LOOP, needs to clear S3C64XX_SPI_MODE_SELF_LOOPBACK bit.

Signed-off-by: Jaewon Kim <jaewon02.kim@samsung.com>
Fixes: ffb7bcd3b27e ("spi: s3c64xx: support loopback mode")
Reviewed-by: Chanho Park <chanho61.park@samsung.com>
Link: https://lore.kernel.org/r/20230711082020.138165-1-jaewon02.kim@samsung.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-s3c64xx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index 71d324ec9a70a..1480df7b43b3f 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -668,6 +668,8 @@ static int s3c64xx_spi_config(struct s3c64xx_spi_driver_data *sdd)
 
 	if ((sdd->cur_mode & SPI_LOOP) && sdd->port_conf->has_loopback)
 		val |= S3C64XX_SPI_MODE_SELF_LOOPBACK;
+	else
+		val &= ~S3C64XX_SPI_MODE_SELF_LOOPBACK;
 
 	writel(val, regs + S3C64XX_SPI_MODE_CFG);
 
-- 
2.39.2



