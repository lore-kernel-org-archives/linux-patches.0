Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208819;
	b=CgerFUQS7t6BqyfoKA3vTDwX5mTRj7FpOIYAyQSqG56u8qXIhPGmfDgSIYY/4JxJQ9Lc
	 Gql3s79aL28qlRFVQBZG9f9PuxOxHcyVLr3v9jPmYsjpLcYw04aMk6a2Q6a13kkolKYyA
	 VtLxSj/TYnyojx7DC0SoKWaeBvndsICmgNfkP9GJilIfZi4eF7v/fAoWsaufa1F2eoJiK
	 nw+pGIWAai5pYiNRLkhyoLYPQgRkKmxBzsydkqp56lCusHMAgR40bHbiGsSEho6tdNVtc
	 M10lf71ymQMDjYxXqHw6JJgf5FiEbBzEZ2Vneez5qvrUFpMfMt/Dg97iFFTDqmm2F8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208819;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EioETapF1pb1TB7GKh8p/1SojglXq7gRU9tW9C8jqKw=;
	b=AVtpyzNCAvH7aBY7aa0j3dlx8vJZ3w8kesCbvOcmTRZU53fgTRvgW5+A9zhAi6CgxYx/
	 c6Q0V+e0ylEVdS4b4GgyMV8JqJcdoOeRRElWZcNZEpxDcbfjnQ9D5NDlWSYeZ/oB74kwd
	 4RYU9pUmK1k5Dl02K/dv76mKlHsfVyBYnNw/AxkCCqUxk43caVA89APqQwQ0aDhpwgRkD
	 IRwIES4agqtgBZbZBrLvoTEu/S0awRo6PyXkcYVgNRRoUnbbIf2byog0TmsxaoOOHDNsB
	 H9diB8C/5IVnXegPuTc5oTQFIc9pQ5eb6DFqQ17d82SL7yxj2wDF1gj2ABjxn3eX3Xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o3pjthkC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA93F606A32D;
	Wed, 28 Oct 2026 17:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o3pjthkC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCFAA1F031EA;
	Wed, 28 Oct 2026 17:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208818;
	bh=EioETapF1pb1TB7GKh8p/1SojglXq7gRU9tW9C8jqKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o3pjthkCDejXtQzShtczcSy0xvRoCMVYmNj/7wdxiSliGlWB9hq43sJ2BiOUvYUQk
	 +OioqJdZfetxss0igvGPv7dzS7J8aOcK+BkJcgWW0VmBqIButKwavIhHLwQhPPxQHR
	 IhCfQBBm9AtbJJWvvB+K/1HlKs5Qems2PLImTi1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.10 236/516] iio: adc: sun4i-gpadc-iio: drop underflowing pm_runtime_put() calls
Date: Wed, 28 Oct 2026 17:56:28 +0100
Message-ID: <20261028170009.094863011@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

commit 8b958dd214ad0c003f56549e9e039cb8067dc1a2 upstream.

Neither the error path in sun4i_gpadc_probe() nor sun4i_gpadc_remove()
ever holds a runtime PM usage count. So the pm_runtime_put() in both
places always triggers the "Runtime PM usage count underflow!" warning
on every failed probe and every unbind.

Drop both calls.

Fixes: d1caa9905538 ("iio: adc: add support for Allwinner SoCs ADC")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/sun4i-gpadc-iio.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/iio/adc/sun4i-gpadc-iio.c
+++ b/drivers/iio/adc/sun4i-gpadc-iio.c
@@ -664,7 +664,6 @@ err_map:
 	if (!info->no_irq && IS_ENABLED(CONFIG_THERMAL_OF))
 		iio_map_array_unregister(indio_dev);
 
-	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
 	return ret;
@@ -675,7 +674,6 @@ static int sun4i_gpadc_remove(struct pla
 	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
 	struct sun4i_gpadc_iio *info = iio_priv(indio_dev);
 
-	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
 	if (!IS_ENABLED(CONFIG_THERMAL_OF))


