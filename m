Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590681;
	b=FxbB5pOw5uc8mKI7tfAnEAI6vJIJ7erucSqc+Ph7ZnAUCcHkAZyPakbc8YdvljgIcbEg
	 ZR+w0sxoJaorg1GUAVagd6UrRHUxaxPm9jYd7gTtWLy9ugMfeh4u0dFOVIfk/w5H0QCJW
	 VV8MgPqLuwT9zmpu+XYla4gOFWguYQKkGw8yTAVOVmX0jeZcQyM07+y4SgbOSJkRiYNr3
	 +KdJ9NEvmJQTLlVNCpdqYugFJWPuSdQbxUEoqyDoW6/1T1YpLi++2O2XW36AgJ/UUXuX/
	 xl2I2ujpWVNKznoSQBLYQfwckaurThH/OYEw+k/aCBybvhtbTRsKAeIZu1OALOaq4tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590681;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1jHyIbjohvo18CUf4izLLrS1t6aUg57gJZoL/mNiAMs=;
	b=E84C6IuF+2yO3gen9JjBhBcmXs/idscAEsKTGUP4OMOPM9K47DkZ7qhQ9B4LCLNpYT68
	 +QV5C8qrjPa7JRkt4UgZeoopOBuSyjwadYrLiU0yNOwoOOFE70vG7A3bdlYxU2Og34s66
	 2Cwt38xq7TkIo4Sem5QkQ3i1B7DdCnzlEf+bL8zdiXZN9xzCX4+lUYEZEk+jw+P3bEDm1
	 OaB+VpyoDFNpO5XYaTFScwvL2KP7yC58Ro9YRu6YeVYW5jMztAP7zGp6Aj0xchaWbVY15
	 tgbuY8/Z9nQgAH6fXMpZYwTUnO38r/c8iXiHdN2IaSkDWeg9y6UJjru91o11SuokeZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e1jsLvjA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 792EA606B21A;
	Fri, 13 Nov 2026 17:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e1jsLvjA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 250A41F000C5;
	Fri, 13 Nov 2026 17:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590681;
	bh=1jHyIbjohvo18CUf4izLLrS1t6aUg57gJZoL/mNiAMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e1jsLvjAoN7p1F0d/+k20iFn6xVRP+nEIoqvToVFy/mMwys/hjPr8hAYtHrU4YbbG
	 fCh8KND/Sk3VJm1LZIwr8zVzMuGlu/hLo19ladmkrvnDSJw9nbJl8DOP/kjTTttFAq
	 PgaUj6rbkTiDRu5kAmtW4nnzr+ZtK8tA81TlB0ps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 558/686] iio: dac: mcp4821: reject devices without match data
Date: Fri, 13 Nov 2026 10:51:31 -0500
Message-ID: <20261113153840.490119788@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

[ Upstream commit 6ac1faf4de61dcf27ffe8f2c25d96fe5f4b2886d ]

A device bound through driver_override need not match an entry in the
driver tables. In that case spi_get_device_match_data() returns NULL,
but mcp4821_probe() dereferences the result while configuring the IIO
device.

Reject devices without match data before using the chip information.

Fixes: cdf3ecb0d8d0 ("iio: dac: driver for MCP4821")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
[ sashal: adjusted context due to missing configurable-gain initialization ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/mcp4821.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/dac/mcp4821.c b/drivers/iio/dac/mcp4821.c
index 748bdca9a964d..daaebf175fedb 100644
--- a/drivers/iio/dac/mcp4821.c
+++ b/drivers/iio/dac/mcp4821.c
@@ -172,9 +172,13 @@ static const struct iio_info mcp4821_info = {
 
 static int mcp4821_probe(struct spi_device *spi)
 {
+	const struct mcp4821_chip_info *info;
 	struct iio_dev *indio_dev;
 	struct mcp4821_state *state;
-	const struct mcp4821_chip_info *info;
+
+	info = spi_get_device_match_data(spi);
+	if (!info)
+		return -ENODATA;
 
 	indio_dev = devm_iio_device_alloc(&spi->dev, sizeof(*state));
 	if (indio_dev == NULL)
@@ -183,7 +187,6 @@ static int mcp4821_probe(struct spi_device *spi)
 	state = iio_priv(indio_dev);
 	state->spi = spi;
 
-	info = spi_get_device_match_data(spi);
 	indio_dev->name = info->name;
 	indio_dev->info = &mcp4821_info;
 	indio_dev->modes = INDIO_DIRECT_MODE;
-- 
2.53.0



