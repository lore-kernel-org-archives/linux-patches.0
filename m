Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064287;
	b=wmpx3soYYmTOd/ZLcFXNBrp7AyjejdkUKgfpkcvVDLjzHES5884TxLI1veCiE2bBPQES
	 vClPO0h4VFYtaQaEz88Z0aVslWHeAAA5beVCoJHDxN4h86ojVgS3uKTUa0va87zOWydG8
	 qCQOl4YxmePKCKACckJ5d8lch1VG7zItaOVm2sHvQlfA45dJG3ForL15skRjIqr/I21y+
	 Tn1J5X9mVPCYqiU3pdXdQcIT0hCtFngGbMmL06IRW+r6y6Pa8WFYebpxzyuwrwamUSU4c
	 Cxvmcf1hGl2Bby8U/nNQ3z50KQzOPpQR6R3BVK2zgpyWVFSL/omghTYeYA79jSQ51og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064287;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eSdKBkajFgS8FqOc7uubKtSB4/T1FsGSdvsB3EZkRhA=;
	b=SvU7pXId9xbaPq/2gtWr6N9WgK+UE3VH37T1Yycc2B7/yMxyz88Xy6irJyLvmqjrP2O7
	 P7CG6Ffc0Tu3T1SuuvzEyhc0NexXaSxsZ+iulhT7Ln5YbXgj0kaq/zLp4DEWV2Pd1EZlI
	 Jf7RhxqZS69ywNj9+h79aswpOxDdOPk/NVFRHpJf2r9UzXPwHj26Ip1GIQequDg2OW3nb
	 7DwSpk2ij+uPaXsq8UolLV2+YDugKWVGmY7wo3UzlhfWpmb8H42pj7TTY+j0hm0gT+dXi
	 ooU1i4exUxJQ/PT94WbzWAshakwPSoYREpIKvtSA3hUO9Dvxip3vmzU1nut4b0BFDAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1vW+DOLq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3AEE606A9E6;
	Sat,  7 Nov 2026 15:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1vW+DOLq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7346A1F0089F;
	Sat,  7 Nov 2026 15:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064286;
	bh=eSdKBkajFgS8FqOc7uubKtSB4/T1FsGSdvsB3EZkRhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1vW+DOLq5rG004usSoRkY4YnI7Zk1D0V8TyIu76zgK+eQeu108nXmUigAMW54kWkc
	 ypCstwhDOgEyTy7VLeFx0SUzQIHEv6VU8E9utOyxAlWEfZnJtGzWB4djp9QAc5BFoH
	 fUuWsPRBfNRptEn+KbayBfYQxQv7etzQsx1vXJs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Kurt Borja <kuurtb@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0343/1257] iio: adc: ti-ads1018: reject devices without match data
Date: Sat,  7 Nov 2026 08:43:59 -0500
Message-ID: <20261107134948.874260145@linuxfoundation.org>
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

[ Upstream commit 156898c0f91aa731821d54fff910242f60b12e17 ]

SPI driver_override allows a device to bind to this driver without
matching either the OF or SPI device ID table. In that case,
spi_get_device_match_data() returns NULL.

ads1018_spi_probe() immediately dereferences the returned chip
information to initialize the IIO device, causing a NULL pointer
dereference.

Commit 572a00852635 ("iio: dac: ad5686: missing NULL check on match
data") fixed the same driver_override issue in another SPI driver.
Reject devices without match data before allocating the IIO device.

Fixes: bf0bba486b5b ("iio: adc: Add ti-ads1018 driver")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Reviewed-by: Kurt Borja <kuurtb@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ti-ads1018.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ti-ads1018.c b/drivers/iio/adc/ti-ads1018.c
index d9ec4a8d7ce54..8f2d03eee77b6 100644
--- a/drivers/iio/adc/ti-ads1018.c
+++ b/drivers/iio/adc/ti-ads1018.c
@@ -624,12 +624,16 @@ static int ads1018_trigger_setup(struct iio_dev *indio_dev)
 
 static int ads1018_spi_probe(struct spi_device *spi)
 {
-	const struct ads1018_chip_info *info = spi_get_device_match_data(spi);
+	const struct ads1018_chip_info *info;
 	struct device *dev = &spi->dev;
 	struct iio_dev *indio_dev;
 	struct ads1018 *ads1018;
 	int ret;
 
+	info = spi_get_device_match_data(spi);
+	if (!info)
+		return -ENODATA;
+
 	indio_dev = devm_iio_device_alloc(dev, sizeof(*ads1018));
 	if (!indio_dev)
 		return -ENOMEM;
-- 
2.53.0



