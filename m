Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826959;
	b=qj2426WlgHCZNkSECoKaLG22Hyl3EcnKVsefYA8br74uMAdNn6urxxyRqB1ym2iMpFZ6
	 lTZTFd95ggQbwZgmnYRfK/ASvk/SVvrNh2h9Wr1S9I9PJGDYnc6pXKQWqmMJ8m8gafI8i
	 712vgdvTTIF8NT3WJ09bKY3+D//8gfJGmkmjcExBvgiLikLTt/zfD5js5B5EpS3lss+U0
	 jMNy0X8wQAvEkkIkjk+PYvbQPrWcj7JbWElaC4V0DlA1CGD8YILivSPQg5EXoBbVVMU7H
	 smJ15Z7OlAOXRr9b/HJp9blF/IO339+jASmJ7tzOWjn/ujN26NQupUMMgYTvO2hA8eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826959;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xnmbbuSvQ6IcOch3DM0y5PoufXpBM/o9ssUAJ8B1WAo=;
	b=oDrUxaoYyGSXBl2yG4Ercf66sp14RADRQ9ogVSVaYyGjrdkELeMYMAw/ySwI5xrXvWl4
	 btOit4vnNRnQI9jKjFNbtuB+P9kmXMmcLLYcE3O2M3MPvebig2Bif1x4Cq7ZiIbch8n5H
	 XHBHtw78lJRNQhyEo6E6rCADVXRng+roDbR9Dt005mfaqTfWP76PV5tscU4z3GSXvO6UH
	 OYltI1hVmFZCK7odRvVBe0ysajzLH2YC3LQluFmFw2FAxVguYmRkVHtkH2YB7gmtn+zfC
	 VsVGjR/bn/49vqx7sxuKHdzedGAbbQ1tzdL1ODJ2MN7FxrPPXfRmB0qg8rEwFd5r9bQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NSMuUCZW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB82160709B8;
	Wed,  4 Nov 2026 21:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NSMuUCZW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 568611F000C1;
	Wed,  4 Nov 2026 21:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826958;
	bh=xnmbbuSvQ6IcOch3DM0y5PoufXpBM/o9ssUAJ8B1WAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NSMuUCZWIf1guWaBN41Jw8CZi/y1hsWzxOCAjTuMbiZkOfoAHDzgxYCvJ9r6U2xIQ
	 VfZIdBPpjpL5IxcC4vRiPP9JfkZmd/2iTyc8Wcmjj5mI/dqXEHYx3wY/DvVcMZnQIO
	 joo1oAeA1YtU2Nf1O8Ae0i/D7Js4izGYQ12iyuos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	"Daniel Thompson (RISCstar)" <danielt@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 7.3 110/547] backlight: qcom-wled: Fix NULL pointer dereference in wled_remove()
Date: Wed,  4 Nov 2026 16:04:54 -0500
Message-ID: <20261104211041.333382804@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: David Heidelberg <david@ixit.cz>

commit 1dbd46d4b2fb416a8202b1a8e4ef9d0cadbe075f upstream.

wled_probe() doesn't set the driver data for the platform device.
As a result, platform_get_drvdata() in wled_remove() will return NULL,
and the first dereference of it crashes on unbind.

Set the platform device driver data in wled_probe().

Cc: stable@vger.kernel.org
Fixes: feeab87b3072 ("backlight: qcom-wled: Add support for short circuit handling")
Signed-off-by: David Heidelberg <david@ixit.cz>
Reviewed-by: Daniel Thompson (RISCstar) <danielt@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260921-qcom-wled-backlight-v4-1-bab8c7ef73cb@ixit.cz
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/backlight/qcom-wled.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/video/backlight/qcom-wled.c
+++ b/drivers/video/backlight/qcom-wled.c
@@ -1680,6 +1680,7 @@ static int wled_probe(struct platform_de
 
 	wled->regmap = regmap;
 	wled->dev = &pdev->dev;
+	platform_set_drvdata(pdev, wled);
 
 	wled->version = (uintptr_t)of_device_get_match_data(&pdev->dev);
 	if (!wled->version) {


