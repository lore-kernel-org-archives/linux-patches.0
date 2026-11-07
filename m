Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063071;
	b=bjTle1Q2zmcYI7fSu/6Sv/BoeDnP5xpaCAwvAeAgWoheb0/3eCvbmJnCfs2FpKVQc4UF
	 JsxVRcACI9S3he/9zbQw9/fujcErgBYvS7V6u1v+Q6ts0zslWk8ghfwPMJFt3uFQ4Qj5j
	 oEgyk6ijC+awFMhvQELezDVdXy/OtMN2tyWgAMz0kWCNcWRDQzTU4wfJDq1gqJlP1yjkl
	 6wKxlkk3zcbEEspe0J7CLI5jfn81ENTEopws6MLQytEn5rrl0Q7s7j5LhODoBU1QWokzC
	 SFrodmUghuxBvVRWR7eKzcAssiAdWKzYmSjyyXGwo0fuw6CRQBglWJMNMpq2lTwj6jA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063071;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=25dv9gFD/Sr8vOs22rAH2oczJccZyewaF90Ukh2LNcU=;
	b=ntz6NVf7cvOldZlNM9pZUKD9Q51o+kvQn/hsYgLtyVZTIy/q6vHT6QqCTKyhZ1xAqPFl
	 FIL7adfopMhNgTier9wgg8sfMnSezMY23dU80xYRvbVbF0mgfvkquLl4YOvAyDOT7U+UQ
	 sk33XtqfI3RH8gJaH+Xbes1K0dM/2Z0P///9mu6PKOf/Vsap0FeyPERxVvVjZuRwsaqkE
	 O1+WxnHkk7nZLU6QtbTNi11oIDxOoJjwNR3H7Fv379wOnXEsNUSYirqaohi523FOg1zsY
	 lhlZuCLmpLmT6+bSdxkus44othAXiyYaBVfVUcrcxOfDBukfiwABR9GbJwcf7wzdQRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n5f0RMG5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91705606D815;
	Sat,  7 Nov 2026 14:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n5f0RMG5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E95A1F0089F;
	Sat,  7 Nov 2026 14:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063071;
	bh=25dv9gFD/Sr8vOs22rAH2oczJccZyewaF90Ukh2LNcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n5f0RMG5vE9xs9xDfUzOT0HMdtu1f9OHBx0HZffD+aZQUmYDDgFI5SG/9tIZHlyO2
	 epGEIEAO/A5kxFxWv3lwE8P3hFDH7FIYoXldYH4iy4soJaAkogqz9Fk1Z5AT6f8mLk
	 im0tlj8q8fGeGABjijlax34lIsIouhZ4Ng4KWfr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 274/869] iio: adc: mcp3911: reject devices without match data
Date: Sat,  7 Nov 2026 08:49:16 -0500
Message-ID: <20261107134900.951876216@linuxfoundation.org>
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
index a6f21791c6859..5bdfe5e267188 100644
--- a/drivers/iio/adc/mcp3911.c
+++ b/drivers/iio/adc/mcp3911.c
@@ -722,6 +722,8 @@ static int mcp3911_probe(struct spi_device *spi)
 	adc = iio_priv(indio_dev);
 	adc->spi = spi;
 	adc->chip = spi_get_device_match_data(spi);
+	if (!adc->chip)
+		return -ENODATA;
 
 	ret = devm_regulator_get_enable_read_voltage(dev, "vref");
 	if (ret < 0 && ret != -ENODEV)
-- 
2.53.0



