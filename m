Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591431;
	b=e2IiSSMF5ehzbn8SPNViq63Logp/3ejeiXqwdY9vgJRehjx40pmCptKII6tfsGjUnlu4
	 ZXo8xz6Oa+B/KBWkG492Ubi5Xf5ZvWT2qMZh4SgixlGBwEVRGH2kqLe63+wzzkzuZ5R35
	 9VqK+0OGcCmP06LutXOHYqL0zVK1r6ydCp9Nm4B0+hIe9ttIjaWPhLniLJft4+eWm5GZd
	 Jnu0+EdrS1F0KtMJBi5m1s8P/QIVpgVYp3A7jn3dk7C1AhKZC4izrxcuEZDorXUGgID0j
	 Dc5TN3JxUlytYmz8OzAE8St8K8gyh/54yhUcjlkH4mcI3EwbG7MC7zJiSrXb3imLt5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591431;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t7GZABJ2VPgMXlXi0NDqmeAeM+mehhWcmERUXkGJcyM=;
	b=Qxg6V6bRQJlUG2NlaIfzuMWxSsY9brEyzvYHRd206e2dJN58yHXboOZ/W2nZc5Lt6mix
	 p36zpCcuy0FpVjm+QNsIyIqXR15DJP3cT/nwVLwECp4BGd9dIGFQBIdhOGNHGDjXdRNYo
	 9I2u6XkkVUvxiaYMTSMxHWXHqdKsysx6O/UxY8WB6Y5+fAlJHRTc7zexHF+0DxJ01EGsz
	 daNO3Qy5BR41FRUgBOSvdT1qCEt9VVpUUeyJ2J7vz/GpgrkGGYHIcAkvPxbl7FnR78/2E
	 gsGnqODyoDvkZ5NrQNTCCFojUTdOLpy4aP4bx1IqflTGC8JtXuUnfB8uxZGUpmzaadg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XWGDcydp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 259F7607B589;
	Fri, 13 Nov 2026 17:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XWGDcydp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6DE51F000C4;
	Fri, 13 Nov 2026 17:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591431;
	bh=t7GZABJ2VPgMXlXi0NDqmeAeM+mehhWcmERUXkGJcyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XWGDcydpas1jwVyDHpuoolVN9oit/stTl8TVXZ5dhtKY4/XJ7tTQHhb2p5wPfNlxT
	 UY1ZIlBKcrvRwg2dcPLRF3IZPVINHCAg+YEdgt4OU3bbnUm7Y6VpAZQ9BDRAXT2gKi
	 /NEqnxl0CqPtG2jvntBVXm6NXtdGNPL1dXhGevJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 516/670] iio: dac: mcp4821: reject devices without match data
Date: Fri, 13 Nov 2026 10:51:20 -0500
Message-ID: <20261113153829.423950017@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
[ sashal: adjusted context due to missing default gain initialization ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/mcp4821.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/dac/mcp4821.c b/drivers/iio/dac/mcp4821.c
index c1a59bbbba3cc..9e4a3cb2a7120 100644
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



