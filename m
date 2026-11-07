Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062122;
	b=ZnNfQCRdP4o7i+8WzgGfHWfMJWt2+45Y3sypi1t0q4b8Q2jnz2xmdsEYduGpLes9caXa
	 wDMvj1LpaWJbsvWNDdU6l1/oFjue33wGy+5WMkaS2vEfjLdjkcKeWCPEnswb9m5tLjj67
	 M8h6j51+ha8sTv9sN7bBnSf2zddUF01LpGCJXMwh3gxPYdSwFNTZ5KiZcX91kv+kolC26
	 mjzDKQS8Dr4aRuFyYt5pp8EZmFz31ikLbSdLAFLRGkIgnJyqjRS43tVma8ysepVdr7t8b
	 OkQJ7Q2LiPY7aqMeOpwKm2zOkx4vwjd7DXRdLMt8RFjT3IIlL5+en3tL1+vOEA05JUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062122;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Sw2dhBzw7HrJSUlD8fEVp4ftmL6kFeoVdpSaXY8hok4=;
	b=wjOiG8OFdI27RUezicFOn6vBN69JIFbm7xFlSWYqSEo7uQZA7Uy7RO0qgrwYrzZPoquS
	 y8PTearMjeC1c0UumXsbZ5oFlPkXvo/y4BZ4SZO/V20JUSt8Ea/YViom4Rog/Ek9AmJDs
	 zrB4TcOuruAmPeOtZgJO2PK9b5BJNhOFibpE1ylKeRy3efp8oETgjWlvJCf5WqREMqNBj
	 twNg0fpK/9Ni4KB4iVj00XScpr6jjh/DP/fjVa4m+2odsNctwfAWmVm1PFrx7OASyD74k
	 3Fpe856Bl/AaFmCvUVP8joT2luml3TzkFTEktvwCaSqt7iI+qE30MDHRsnJ+PhAMxQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w7O8j1o6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FF4606EE90;
	Sat,  7 Nov 2026 14:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w7O8j1o6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8176D1F008A2;
	Sat,  7 Nov 2026 14:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062121;
	bh=Sw2dhBzw7HrJSUlD8fEVp4ftmL6kFeoVdpSaXY8hok4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w7O8j1o6BOYCZYBrKpUYYXfERZAt8IP/E8xeJZd7bK/lCpLW767DAvX7wefatDXOI
	 Dk8GmmjU+Q/nW6KoDzU7qDYEm1c5YRnDRX6Iyp3cI8XQ0i5wyeJJdXxdq6wArIGKJw
	 /zC26In0yyYMJBqtQXjoO5BXFvRTLUUtHzautaWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1091/1536] iio: adc: mcp3911: reject devices without match data
Date: Sat,  7 Nov 2026 08:51:47 -0500
Message-ID: <20261107135028.342388984@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit d3410a48d5eb9dd8238099cb0ee368d12005a385 ]

SPI driver_override allows a device to bind to this driver without
matching either the OF or SPI device ID table. In that case,
spi_get_device_match_data() returns NULL.

mcp3911_probe() stores the result and later calls through chip->config
and accesses other chip-specific fields, causing a NULL pointer
dereference.

Commit 572a00852635 ("iio: dac: ad5686: missing NULL check on match
data") fixed the same driver_override issue in another SPI driver.
Reject devices without match data before continuing the probe.

Fixes: 732ad34260d3 ("iio: adc: mcp3911: add support for the whole MCP39xx family")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/mcp3911.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/adc/mcp3911.c b/drivers/iio/adc/mcp3911.c
index 4bd6b5aac4fe8..087c51c407473 100644
--- a/drivers/iio/adc/mcp3911.c
+++ b/drivers/iio/adc/mcp3911.c
@@ -719,6 +719,8 @@ static int mcp3911_probe(struct spi_device *spi)
 	adc = iio_priv(indio_dev);
 	adc->spi = spi;
 	adc->chip = spi_get_device_match_data(spi);
+	if (!adc->chip)
+		return -ENODATA;
 
 	ret = devm_regulator_get_enable_read_voltage(dev, "vref");
 	if (ret < 0 && ret != -ENODEV)
-- 
2.53.0



