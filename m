Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036148;
	b=0m8suxAN9Vea/O0eJGOIGkPDQLhhc8sjEMnG0Hf0bdiPm4hHTU+nYvvG1d4Pj30SwYDq
	 aNRuJ54IcZpIPeRHqP2HtKumk7Ebrer5/3xGUVUIy1McRH3HZWWfq0Llk7M6aKB3QNQuX
	 Gvm2MfNq8YX90oaGa/LkCK3LvVSq6ZGN2sfykyGpHo+sI7zAVD5+wIg6hP530yrsOCdXO
	 dX4Df04MGllfJoj3D/4eoHeFYTUFOEl665ehIqTNDqhAr9sWq8ks8x5qMMN++qgsa55YS
	 apRpV3bLD6oc55sgb0ZQWnS/Hnrp8JuGDrvVLt6t6lWQMIM7WfNqS6cIrBWPuTRenww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036148;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r1adE++wkvmVQTMvYP3PM+bwFXgGsG8ZWKgK/XLNz1o=;
	b=vBE+nQs0KlSSpEh0bmes5WyqhwHNGIpNdLJmeqdQ3ywGLaKmt9CpLIsmU3oYQX1xbou/
	 M66p4aSGmmyfQiu/rJiozsU0NYid6Hwx6Gb2MY7x4UldAUm8B7Es/rlNxyHe34Lr58FeV
	 YHxSCvFAapcigVFWa+g9Seoc2TM3Im3YjlQc7bLOxqQqIKLX6Awx06vcoAgivyCXl9n8s
	 0xcbDWEy8vwibiPnXDvD4lUBIFL+qkud3csdkTf2YHlXQdq7Nz6pSFy4OyFLuc4rkJkVj
	 3f5DvgnbOhrf6s4sfy/78JDoyt53mjyfdyRJFYN5tWlV4p4UJg9PCN5diMpN0hs3ZhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DecFSxEf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41879606A333;
	Wed, 18 Nov 2026 21:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DecFSxEf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C2F1F000C4;
	Wed, 18 Nov 2026 21:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036148;
	bh=r1adE++wkvmVQTMvYP3PM+bwFXgGsG8ZWKgK/XLNz1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DecFSxEfrtTpk3xupiLMBAqh4BCKXEv9pGRknBQLAVWdvCJOvIdOjIgPI8OSysp6V
	 io6PV1yAvioiyqnrvTaYEQ5nfGT7Fiw3n5W2lY2gQGK0cP70MQ7oKputUNyoQBDcS0
	 lysS5b4g6DimAgWMPzLk5JNxGHplh0C+V+G0JpGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0955/3318] iio: potentiometer: x9250: reject devices without match data
Date: Wed, 18 Nov 2026 15:26:17 +0100
Message-ID: <20261118150348.278338163@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



