Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064289;
	b=lMw8h4MqUGRnEPJBDuCgxWlZ9HE6c18w7pGiF7t1Fc0Io2oVkfkDoYcfpn6/rxqOLHZL
	 CSN4/hN8TrgYB3NJx6qmvhcs+Pq6T/Sny5q9M1vPmjBGtR49LbC8nOX/lpxlgqORoQAEK
	 0P9ChBZpSPWAeSCid9LRkZjM19ayUmmlqN1TCNgVim1s4aVJOLkJnd7AFkjbckh0WfkA9
	 fxXZU98kUH2gvJpHF6YpVyHmtdQ66UP2AyoWSKditi2+rv+nqBsjhI9gvD6S3WK53sBKL
	 QlucFh1bSW9nWTvBicY1yA+G+d6swzW0hd3jEt66ZmB1H1+HBlsCxptIIseIrLgCqxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064289;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uvLaU4+b2hLPGX+IcDqYY7Oo6ovPDBKCzibKGXqnFf0=;
	b=0YyOn/d0oJi3haha12DjHmhzkkBz1nbybJJ7v27U3RfsgIMxLEWtzgNdIqG0z3USKtOB
	 86J98tt7aMhAEk/OTmaeXMzojHQdg9DFbosaUQPTlgbD5PfMPAukxzgFeewIC/sijHvtt
	 1Z0UOZjoNwfOfc3SBvEkfxjFMxfQxoafJelQu6ONERo9rUCH2sbfOymwIiMQBHrtd1COv
	 1J3yNwkhyhYieC35jY0WJA9YyW06hCvivbh17ZauifFM51cI6Kd/XNIInMsWa0lE9KleJ
	 hRFRp7PkGturAU22Ln+Vo+W+qV0f5FNTFWTMt1FpmO+pGP17XJL+jd9LHUPseZEC7Bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CRSRn7ai;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F36606A9E6;
	Sat,  7 Nov 2026 15:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CRSRn7ai
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8ADC1F0089F;
	Sat,  7 Nov 2026 15:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064289;
	bh=uvLaU4+b2hLPGX+IcDqYY7Oo6ovPDBKCzibKGXqnFf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CRSRn7aiweCnD1CYMIIZU5OwxTMODHzxMrp2hq52wfzaNbNDc9qZqA+stkZAeQUP8
	 8dxYDm/wFPMyvRQuk8Ed646P1RXqCTFgU7NScMpoGkltO68o2nq0MylVOB3I4Wr7iF
	 +ovBRPyGn/j6oYFLgZKKpWMfDyQ4Zm7mU7XdN0IY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0335/1257] iio: potentiometer: x9250: reject devices without match data
Date: Sat,  7 Nov 2026 08:43:51 -0500
Message-ID: <20261107134948.660803023@linuxfoundation.org>
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
index 974e4447fc2cc..675b78677baa4 100644
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



