Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064192;
	b=x/QUKVtZkQfK4mCiW66tRlT2LKQpagDX3mri91OJ2VZtoThvKmQ0QH+2V7HJL3qS1ctc
	 2xo7EAG/gq8ksFKujT6m0tTTobTV7PT6d0qtXmVAkhSI/dWZut+Wqo7d2I5EYjLjJOWYW
	 h2L2Kc/Yl4ASdTdOTnFbpTO7xNcBVPQJHqXAvpYYgwCv0euY/J/FOlnHXUHD+uDguqj8x
	 buzoXcMpNf0m/13SYIUnxj2DlbCHffb3eW8ka9epunw0qL7gd5GmDdDatdBi5jJ8Mvjpw
	 yvG1A5BiukSeVk+KtXNuDtWuxpe5MJcoI2jy4CVNZiZulBVV2Z5tL+RbfDN9n8oWMFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064192;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bBYCaN5ZTmkqSrx+AdtVRKUZhptQn3hd8PHUX0yvGBE=;
	b=ZxzZgd/XK9Ba/KJN9S4tka/rxlM8Qmbt4pSgZh01YZC5CGKgAXikT87ONaSS+PKztByK
	 Zd+U10mm3O+BSO4nYVH3OdN23cgpluqG2ZDun50/UqEnQzvyDSNYeRJ4Z8a8ZnU+AyyRp
	 YJOK2+a/U7c/GLl8bb8Yva95xNLG2vGM++5yk+HYKXQQ80ydLvOl+PmXWLZDNhr0b7PUH
	 vuEl44Ho9cbZa6/t+wFV6DNwYcHjINkHYCOpoY4JS0AnsuvrskWOChHVUorhIKNie11Ez
	 6bVFYqS82WPXCgJoDiPVNiSP7PEfsYeMbETznkkF5o2gPvTWgAf6JzPZkxsnJIgLT6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=guXfXKOO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826EE606D829;
	Sat,  7 Nov 2026 15:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=guXfXKOO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E08F1F0089F;
	Sat,  7 Nov 2026 15:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064192;
	bh=bBYCaN5ZTmkqSrx+AdtVRKUZhptQn3hd8PHUX0yvGBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=guXfXKOO9Rp6CpPwtDapY7e7spcEZIlA3qW62eEJocPq76/V0sNU8l8f5M7i2FqK7
	 AaLHGks0YHkiI3VCE1v1wdDkRFquy5vnSXkxSvkzH+gyNN9Zz7m0A0EB6Lr00OYc2r
	 EmNs5uRf8xkD9e/+HYXxU3ZxSiFJR/RmLq8zsZuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0332/1257] iio: dac: mcp4821: reject devices without match data
Date: Sat,  7 Nov 2026 08:43:48 -0500
Message-ID: <20261107134948.584491025@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/mcp4821.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/dac/mcp4821.c b/drivers/iio/dac/mcp4821.c
index 8d8c00cd60e98..59defb1b5e621 100644
--- a/drivers/iio/dac/mcp4821.c
+++ b/drivers/iio/dac/mcp4821.c
@@ -255,9 +255,13 @@ static const struct iio_info mcp4821_info = {
 
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
@@ -268,7 +272,6 @@ static int mcp4821_probe(struct spi_device *spi)
 
 	/* default gain is 2x */
 	state->gain = 2;
-	info = spi_get_device_match_data(spi);
 	indio_dev->name = info->name;
 	indio_dev->info = &mcp4821_info;
 	indio_dev->modes = INDIO_DIRECT_MODE;
-- 
2.53.0



