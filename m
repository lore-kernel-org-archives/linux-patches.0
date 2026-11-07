Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064246;
	b=qkqGU1n8axebaU+HuAu7O8AQ/L9UtSNxu3RKn1w4PsXlquJlLMd8b2ZJGk6LqPO/2Ish
	 ItEppdeGwXQ6Y3ptn6zEzQZm6jpf3CVv6ZBYXE82ycd3pDGz8uc6W/dtxOETs8/5Ve7xw
	 J0q0BOd8q8YYeY6q4GKvofXEDeB1hwFMxi0U5Q+arKTumbcqnqghYtGnMJrqIhjAbDnJB
	 jF2pAA3rAdABNL6GNu9OzttAMToofxmwJb/257gto293hxWb8XvIAdxGjwubvibX0q+72
	 43kM4NRlvodfTPv9MmbWZuCQnLjnhcH/z7eHCrnpP3qPsG+FhGbT3VBJkx52uvfohZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064246;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vga4M5WP7fTvIuFfrEadwHg65DDOmZBK1JsubpHF0kA=;
	b=za3csVBe9NH+KxGFrNgZ/j4nLPRNHaORrA0outTLKzsf6PXbSzZwk4Wp0ORGQV0Vjreb
	 ElLf6Q6+pERXIBkY/KSLQLqtNKS0292jxm1AnM8bCFrUnFijZeKoZOOcZnDNwtFoNbveZ
	 5cQRvCiQx+20Wxtynh4x5z5Slnxnw/D4jEVHEJBcd4LLMPAc11DwdNkjrzslalP/FOgOU
	 XLMUoSyb9DahMI3TISnAhScZ0XVwrgSfqrAjo8jZnSmGHkVDkaWsU8vg02bgXIK9CEU0g
	 YGT81HzUWUobEYTUO9pYYdB2EnTtpYR9eFMdTi7Bo4Niaiq3/fBEVE2Rs1v5QEfRtZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZjQOAZsV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03871606A332;
	Sat,  7 Nov 2026 15:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZjQOAZsV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5C551F0089F;
	Sat,  7 Nov 2026 15:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064245;
	bh=vga4M5WP7fTvIuFfrEadwHg65DDOmZBK1JsubpHF0kA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZjQOAZsV9lNyxJtCVLIQ+O9X7CBXJ8u5oRsecLcEV+DdJtxgFKg/mpyHQPavKMLCy
	 GSZ4TZ9CgvJV5dW75IY65Gc6GU9YvYV7/1uyZKUVcmuvU57v5JI9bXNNobHC0FoHaH
	 r2ZZUA83RL1v0yn9+EjuF2657BJGbveoqqrpEfdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0349/1257] iio: accel: sca3000: reject devices without match data
Date: Sat,  7 Nov 2026 08:44:05 -0500
Message-ID: <20261107134949.034859559@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit bee629c18a9389cfbbe182df954cf49a9066b383 ]

SPI driver_override allows a device to bind to this driver without
matching either the OF or SPI device ID table. In that case,
spi_get_device_match_data() returns NULL.

sca3000_probe() immediately dereferences the returned chip information
to set the IIO device name and channel layout, causing a NULL pointer
dereference.

Commit 572a00852635 ("iio: dac: ad5686: missing NULL check on match
data") fixed the same driver_override issue in another SPI driver.
Reject devices without match data before using the chip information.

Fixes: d6ae9f202f61 ("iio: sca3000: simplify with spi_get_device_match_data()")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/sca3000.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/accel/sca3000.c b/drivers/iio/accel/sca3000.c
index 8f1ac1d3305ed..acd0890c78a58 100644
--- a/drivers/iio/accel/sca3000.c
+++ b/drivers/iio/accel/sca3000.c
@@ -1462,6 +1462,8 @@ static int sca3000_probe(struct spi_device *spi)
 	st->us = spi;
 	mutex_init(&st->lock);
 	st->info = spi_get_device_match_data(spi);
+	if (!st->info)
+		return -ENODATA;
 
 	indio_dev->name = st->info->name;
 	indio_dev->info = &sca3000_info;
-- 
2.53.0



