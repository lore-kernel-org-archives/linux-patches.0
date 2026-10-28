Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212959;
	b=lZvAobs5QVdib03EO82fHr30E0j4BYYSmRggU6U2TTdMlozLmJPeipqW+212tWT7/XPD
	 ylaYUhEJjlGvIZTqlu0CjHzG85cg9wriJjkHqK9+vTw13IkSMeD1uFaLaA6DFFZZtOles
	 GI1qV25FTmTGYcUFZR5NuMBUv9K9o0sajpgM8IFvyypJhq4dru8yt5jrOJSiX5ySi0OAE
	 qHbhU9otNvQR6rrJmFwrK4NvA/YK5Y+nwDGaWT0LIPplQppWf6kXeXRgvP7pDUSOT3LFn
	 0dKv95YqEQSMUcseZwb4w2QZlvF5DUP3vb2ML04XUpoUGWY1GMP5iSjiMjsngfV5LyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212959;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tlYRWPUZCtDUywVYWtut0T767pwhqJNuRlVese+fUpQ=;
	b=nFCPBi0rx2s8qLdVc9kjrVnETu4l85MeOpRCJRi6lpE7RnAuoobbR/aBAEYoFlScEyYo
	 o1HDw/EAZdSETIWafgN9E5hIrSQwS1lPCl6/VHuY5bsV1KypZTUbzEx1txZQ/eo6S1UJA
	 AZjlfpf4vTGuZL3HsDHL8mRpFAK83DyJxutt8+FoH/ItrNSgx6OMPp4SsCBQo+gH7A5uh
	 2HvfgAroAAnaz+XjJxIf9sgkfEmHnWe5+yaY6isqhmAJ+45bwE0LIupgkJb/r+5HB+wCj
	 TeuOPBdjeGIkdrmbq3nrLMDC55TeGSt4696wUzkHr1QildLYMocPDFkuY1kl+H7iPFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l6eDkadc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E66606A31A;
	Wed, 28 Oct 2026 18:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l6eDkadc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B26DC1F01825;
	Wed, 28 Oct 2026 18:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212959;
	bh=tlYRWPUZCtDUywVYWtut0T767pwhqJNuRlVese+fUpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l6eDkadcJfO3hQ4LIhFLwAcB2Za5b2gMZWr6po0AzB506OGE7D0gWnkGSHgwx8sgA
	 61064RQwEiTzIvjXL0nqBy/lMAFvUr5H3s3pTA7k+EKUkmE+F9HPoA9SMnLVfnh6xz
	 FeV6ANB9g+F+V46q96cw2IEEmMP8ZDlbmzGAbuLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.1 0335/1887] iio: adc: sun4i-gpadc-iio: drop underflowing pm_runtime_put() calls
Date: Wed, 28 Oct 2026 17:40:31 +0100
Message-ID: <20261028170506.851375907@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


