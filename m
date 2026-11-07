Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063054;
	b=14fcBNMS+1DqzUVg1JWsGba7flaRF8c2yi+BXWz+93w6SXXSeifi+PVzz19fe1Qvjq67
	 VevS6/UADIT9wfdCTlVYGk1GKvuRgyLaY9p8q55DzSIMK1WIQhC52pojIWuMJNlpDtBoN
	 qvnXkCcfVDZv3v2zNpaVPpPfyy+lFGkZ0iSH+Orq/TgZ8DQ8PdQMQgyC/DfhVauain112
	 GQPEcVOKp2QU6fGhb4uPHF6cV+HLIVeSLrZxKlNyAHymqsjsWlpxJbAnDrpd/muePzj/x
	 92AyVElVjJafwOig8cBf2ydxad8L5s8cgi8M35lJe/loNo2RcJ8HDyO7ijT7hhuajVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063054;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t3HaC5/iumFoUaU4nH736iaVBlw0iytZlC7WhPBWBOA=;
	b=YY5UqpwkVvCF5x5O9x8ddHuaee7zYIJSPRJv21HHlAF5bEaHzk0kq2q6KyKLXNxe6Zq2
	 7Sbfnn8z1jlfsGTaKocewqic8eZoWPOh4/3i3MDa9i1g3hAI/HpWm1qPU1M8sSfgKxpek
	 en2OGYJKWYOJyUYTtVZxzNyWUIkaOMc3KPcAzF46w5uEovPPSEhliWAXhjEX5AS8ztwli
	 7EHvRGp8Jym+Gev/Yd5PP/6FrDTxDLxXn1lgHP7kiZ8zHE16r795ap5wDhVNBnAPTskBf
	 qNYiwehClCOfjj+N++w9bwrgDmCirhIUlKvDQWNeAQjdHb5E0BvPvaP02Nq08GsJ1GA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=syaOrmww;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FAE606A331;
	Sat,  7 Nov 2026 14:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=syaOrmww
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B724D1F0089F;
	Sat,  7 Nov 2026 14:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063053;
	bh=t3HaC5/iumFoUaU4nH736iaVBlw0iytZlC7WhPBWBOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=syaOrmww/XSN4yn2+DhAkNeZWSFGcXVbWlqsficiNzPT5UAEWbgem6vlEiXYv2QpM
	 TNo3eQHUAiYrI4drZ0LFovLCM/hrs/yJ7vFw1zYLmVRErRQKJ96CKu8j4zDTcxYqXD
	 onmkvB623M/pH+3TOKCz2TLu+VZhyQFoI+P3ZRLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 271/869] iio: pressure: bmp280: validate SPI match data
Date: Sat,  7 Nov 2026 08:49:13 -0500
Message-ID: <20261107134900.871006391@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 206fc54554c28d76c5d8f66091b846ef1dd88f64 ]

A device bound through driver_override need not match an entry in the
driver tables. In that case spi_get_device_match_data() returns NULL,
but bmp280_spi_probe() immediately dereferences the result.

Validate the match data before selecting the regmap bus.

Fixes: faac4dda9a91 ("iio: pressure: bmp280: Use spi_get_device_match_data()")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/pressure/bmp280-spi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/pressure/bmp280-spi.c b/drivers/iio/pressure/bmp280-spi.c
index 3b90384f17d73..e303923df6757 100644
--- a/drivers/iio/pressure/bmp280-spi.c
+++ b/drivers/iio/pressure/bmp280-spi.c
@@ -83,6 +83,8 @@ static int bmp280_spi_probe(struct spi_device *spi)
 	struct regmap *regmap;
 
 	chip_info = spi_get_device_match_data(spi);
+	if (!chip_info)
+		return -ENODATA;
 
 	if (chip_info->spi_read_extra_byte)
 		bmp_regmap_bus = &bmp380_regmap_bus;
-- 
2.53.0



