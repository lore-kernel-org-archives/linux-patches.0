Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E25530AD0C;
	Wed, 25 Feb 2026 06:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002697; cv=none; b=O47eXcgnTZd4Cy8x3t0UjrmWjjYbe71BEbYkOGSn0S5M6GC/k2pXaV6ZAfYmyXq7otD4+72+jq0hytmYlT2pWgMpOZeRYVxIuiVJVDvYZdK5mGSGx5t3lhrgSAhh/uzaQ/fjh70dwWsCltiCl1XCBnBoLRdVGIoHnIs+qiFLN9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002697; c=relaxed/simple;
	bh=a/PzofcGot8NZA0cIndS0ZdU2HjuLN+bn74jT8Ty3OM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YxDf6a7trWLKVhxvPOhiElOtTW5ZmY7gSMAtzG4+AI8/6DvvISGNFX6uMHX7IgmMwlY2BkyjGiB85xHx3GvrYK71QoZ8GVbRR/O59s9a7HdBnAtuDoSxYZO3c66CxOgBMo1qrUa2cw9zaO9GqRv54FMF7SedPM1sqlTiaEqO8Es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hrY7h/0y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hrY7h/0y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58498C4AF0B;
	Wed, 25 Feb 2026 06:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002697;
	bh=a/PzofcGot8NZA0cIndS0ZdU2HjuLN+bn74jT8Ty3OM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hrY7h/0yn+qYg1x3W/QQx2USzjDd+UMeAZWF+RAVvfkX/VZ4dxtipGDTg07igtjNe
	 bpH8VO0UASc4FKoVPfWQEG6md6a058S3fDdiK1IqjR3tG86P+bBTQHGTxnTd6hxlnn
	 Q19yZgo4kB+BlwJ1xpz96FchTppWyq8KXit3naso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petre Rodan <petre.rodan@subdimension.ro>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 467/641] iio: pressure: mprls0025pa: fix spi_transfer struct initialisation
Date: Tue, 24 Feb 2026 17:23:13 -0800
Message-ID: <20260225012359.830102976@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petre Rodan <petre.rodan@subdimension.ro>

[ Upstream commit 1e0ac56c92e26115cbc8cfc639843725cb3a7d6a ]

Make sure that the spi_transfer struct is zeroed out before use.

Fixes: a0858f0cd28e ("iio: pressure: mprls0025pa add SPI driver")
Signed-off-by: Petre Rodan <petre.rodan@subdimension.ro>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/pressure/mprls0025pa_spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/pressure/mprls0025pa_spi.c b/drivers/iio/pressure/mprls0025pa_spi.c
index d04102f8a4a03..e6bb75de34119 100644
--- a/drivers/iio/pressure/mprls0025pa_spi.c
+++ b/drivers/iio/pressure/mprls0025pa_spi.c
@@ -40,7 +40,7 @@ static int mpr_spi_xfer(struct mpr_data *data, const u8 cmd, const u8 pkt_len)
 {
 	struct spi_device *spi = to_spi_device(data->dev);
 	struct mpr_spi_buf *buf = spi_get_drvdata(spi);
-	struct spi_transfer xfer;
+	struct spi_transfer xfer = { };
 
 	if (pkt_len > MPR_MEASUREMENT_RD_SIZE)
 		return -EOVERFLOW;
-- 
2.51.0



