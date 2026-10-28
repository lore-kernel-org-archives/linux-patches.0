Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211089;
	b=FbiwuGxwzqTV5hG7+BXxa6FO0CkhuRdLmdjrm0KvDJwBaPFFcTrjmmZ9sUDvUbNkowR8
	 oUPd+HLwmkLZLghOtuuMF+u1fylAoHxKHoPJ/6WQ5V96/Gc8BB23fduLpWivjqU4hQiR/
	 Tc/4iMoQXpiIhY6d17g06F82nxFAe+jMTNOindR573ydd9DCfgsHdqbGla3nanujOt/dW
	 XbfL4KSbB4DonWHd0P8Bb5iot5PCAMR9WuA18PHKkyv4GgJpxpCjvbewRfxELqJ5wvhA2
	 yz2+EzmVM6ovXafW7ttdVr9ffxDzuctGTWUnU0hK2gIupipQlnKMc8jcJqO6F80ZoOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211089;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YTNhL3EQBIlZnk9QycpvtMH+o2kqRtSWywAV+/J27nA=;
	b=sZwXdnu6cM7JcPXOG2JymG6DJQYg6duPSNeYc31lOp3UYOsir5HGWzhYqoV6QsDRewnr
	 Ls8Rmir3OHO+64kXOcmWc8qSUgzCZxoRsAP9aMbQl9qus7lMGbA5hhX5vpic+UK252kAz
	 In0lmnaLSAXE0EbYXncTTpxnszX3hnQwjNWrJHdkV4gshfn6YGZZJT/VqchuPI19KHLUW
	 h4mkrV4mcFKB9oAQHG8tzQI1Bk+nTqGyUnSth2GDcJKg0Sm8hZQKJeiz7pA/iVUDuw4pS
	 fxH1x9VACx+tFgVaXsl8pDBdw5QBh6Lq7gsKCRUXitiiEBJojiiywFpamBFz0wMIQMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=amssHC4l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6244E60A3822;
	Wed, 28 Oct 2026 18:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=amssHC4l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEE301F01828;
	Wed, 28 Oct 2026 18:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211089;
	bh=YTNhL3EQBIlZnk9QycpvtMH+o2kqRtSWywAV+/J27nA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=amssHC4lF8UNIBPi00qbBvI6bW8eeWUGFMfDIb2qAEvb/jAKkF22KP9VrSFzWna3h
	 4rVgPJDCBbZZbjYeYjTWGJrRamJu4h9ZuSU/jXiI6TpKvuqFvVgutEFP74HMjLhnzm
	 /pBhvQtjTFxTB3MV5wVYVtte8Zeb8N+jetQe8YXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.15 254/571] iio: adc: sun4i-gpadc-iio: drop underflowing pm_runtime_put() calls
Date: Wed, 28 Oct 2026 17:56:41 +0100
Message-ID: <20261028170014.031344149@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


