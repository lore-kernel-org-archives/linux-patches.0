Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063040;
	b=0FLFHqsGR8MmdIZEKdV+i42aeRZiCyYp87e32HbockgtVRSuj5COAbgydrbOlBPdOGyZ
	 7flXor5OTK3Nq21rBNCa+onr2lpSkD6glUhJhfsU/rh/CPwuJfgcma/UCHdia2tSeBOv4
	 C8aJsSAruKtBvv/3y7J7dehz1p149KKD+B7HY48/v+THJFNYQ4+AA5xA21kzoWhVH31Ff
	 CeGIdnLB9LLQxeR8d4ih8pFRio47LZrghm5KGOF3M0uieUdMqSexvWSnAix+V53peWrta
	 bc+QTgOsXUKt9X2BWKm+z9BNtPNEQQ2bd1kvpW6vVrh7IqxFicXakNdq4rsx2B5zcUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063040;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5Pe6GMoY10fjL1jC4cPBonNRoX8jQa+5VTFM5we1rOA=;
	b=gaF6LJzCNSF+7z+yPUwgWY56L12EA/KfJOtyrgH7Yp/6b4RajMoU4MMYtbSWsJ1yxFsc
	 n6x3Db2CqnQPT9IALMb5o6Ppoh2BKgOnxFyZwmPmCIZOU/Ik81PWAQGv4CaNWK2W5BlG6
	 NLcz9bX+cEf5+uib08nLLZA1WlUKeXh8JHh7TSCn6d9X3wkUmTmqpqcFdgsMA1tTDM0ce
	 Hb4gBC7iIyCrSFQAJf5/wXCdw+PGM7/E1luWKd/Ue0pFtdfqbQmZzYJjWTjqhZeq5ZoQa
	 vxVvD3hHQUlaWgA5GAOP7mctje1KX49zYEBdV40flMwHp1NmWjleEBY6mCNsBOLagUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="p7ff8/7S";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22572606D81C;
	Sat,  7 Nov 2026 14:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p7ff8/7S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C164F1F008A2;
	Sat,  7 Nov 2026 14:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063040;
	bh=5Pe6GMoY10fjL1jC4cPBonNRoX8jQa+5VTFM5we1rOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p7ff8/7SzknIJq8+cAZ5IOS/IGkmLi87gQDlG6x1EKNWTvzMyeJxt1N+TbTYD+FRl
	 YmTgGogBiydBjJCgpa/PtjRKo6SG13Ajcgz1OC6AwBZegKVQgF0uYWLT5r1YEiUvzB
	 Ehb4jNgJBfv3Wnwkc3wcg2bZm4mL/X7lYZ3FVzSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 270/869] iio: potentiometer: x9250: reject devices without match data
Date: Sat,  7 Nov 2026 08:49:12 -0500
Message-ID: <20261107134900.843351312@linuxfoundation.org>
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

[ Upstream commit d13716e3defd5b8cec3ee2c27f4d9b7e01314067 ]

A device bound through driver_override need not match an entry in the
driver tables. In that case spi_get_device_match_data() returns NULL,
but x9250_probe() later dereferences the result while naming the IIO
device.

Reject devices without match data before enabling the regulators.

Fixes: 66bfc528a6fd ("iio: potentiometer: Add support for the Renesas X9250 potentiometers")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/potentiometer/x9250.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/potentiometer/x9250.c b/drivers/iio/potentiometer/x9250.c
index 7353484926997..1c9e22459058b 100644
--- a/drivers/iio/potentiometer/x9250.c
+++ b/drivers/iio/potentiometer/x9250.c
@@ -155,10 +155,15 @@ static const char *const x9250_regulator_names[] = {
 
 static int x9250_probe(struct spi_device *spi)
 {
+	const struct x9250_cfg *cfg;
 	struct iio_dev *indio_dev;
 	struct x9250 *x9250;
 	int ret;
 
+	cfg = spi_get_device_match_data(spi);
+	if (!cfg)
+		return -ENODATA;
+
 	ret = devm_regulator_bulk_get_enable(&spi->dev, ARRAY_SIZE(x9250_regulator_names),
 					     x9250_regulator_names);
 	if (ret)
@@ -176,7 +181,7 @@ static int x9250_probe(struct spi_device *spi)
 
 	x9250 = iio_priv(indio_dev);
 	x9250->spi = spi;
-	x9250->cfg = spi_get_device_match_data(spi);
+	x9250->cfg = cfg;
 	x9250->wp_gpio = devm_gpiod_get_optional(&spi->dev, "wp", GPIOD_OUT_LOW);
 	if (IS_ERR(x9250->wp_gpio))
 		return dev_err_probe(&spi->dev, PTR_ERR(x9250->wp_gpio),
-- 
2.53.0



