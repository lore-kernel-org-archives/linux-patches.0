Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C3C335BA3;
	Mon, 18 Aug 2025 13:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525087; cv=none; b=XtSg9A9JnrepDWuhDU98E0+wB+SRMaaODEZknL8d6hUZRO84+IweAB252XZRaEJe+QVuV0Mqxk994ZUnSqp+Jpwkt27vpODFKFoUIPHAXCoxoUtXC8HuJsklKounyxSHpIfYcBpr0BOqV0ZD0RBAY+Ss3mRTH0uGCuNM3tr9zRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525087; c=relaxed/simple;
	bh=JHCiqtYPKPvf93Z75QBJMSi/qCXtSNe3AFDOXgwkqEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AQu8aHOUVABvmhvg4pOudhh1QE9b35iLWWUEeIMHbFXToKQ5a+W8FIrxf3K7kL4clldXa/FGbng5qX04TW9APy472wtaPRqyX0Z+nCen8a67+eskCXqUTDFJBLctFwXAKHf8TEhGDUftMf0oce+wOcNg6jCPvPmI3DKCD+tuCGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xS2oCVvg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xS2oCVvg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27D1FC4CEEB;
	Mon, 18 Aug 2025 13:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525087;
	bh=JHCiqtYPKPvf93Z75QBJMSi/qCXtSNe3AFDOXgwkqEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xS2oCVvgQkmBZbTfHp8kT5o42wRsRK/npTGAe1IL/YfneqcgWm/KbL+7E+v5qu0u4
	 xJRc+It5VutBdhBCRp/T6yf78sLmvapIMpsPlkIjn9VhBNjv+TFepdA6grD0myb9AO
	 hSBpJM87jjZ5yNnP2AryU3vRgw7N2AjRqNZ5ns1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 154/570] iio: adc: ad_sigma_delta: dont overallocate scan buffer
Date: Mon, 18 Aug 2025 14:42:21 +0200
Message-ID: <20250818124511.747179880@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit 5a2f15c5a8e017d0951e6dc62aa7b5b634f56881 ]

Fix overallocating the size of the scan buffer by converting bits to
bytes. The size is meant to be in bytes, so scanbits needs to be
divided by 8.

Signed-off-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://patch.msgid.link/20250701-iio-adc-ad7173-add-spi-offload-support-v3-1-42abb83e3dac@baylibre.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad_sigma_delta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ad_sigma_delta.c b/drivers/iio/adc/ad_sigma_delta.c
index 4c5f8d29a559..6b3ef7ef403e 100644
--- a/drivers/iio/adc/ad_sigma_delta.c
+++ b/drivers/iio/adc/ad_sigma_delta.c
@@ -489,7 +489,7 @@ static int ad_sd_buffer_postenable(struct iio_dev *indio_dev)
 			return ret;
 	}
 
-	samples_buf_size = ALIGN(slot * indio_dev->channels[0].scan_type.storagebits, 8);
+	samples_buf_size = ALIGN(slot * indio_dev->channels[0].scan_type.storagebits / 8, 8);
 	samples_buf_size += sizeof(int64_t);
 	samples_buf = devm_krealloc(&sigma_delta->spi->dev, sigma_delta->samples_buf,
 				    samples_buf_size, GFP_KERNEL);
-- 
2.39.5



