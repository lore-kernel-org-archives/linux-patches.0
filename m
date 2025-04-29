Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FC0221570;
	Tue, 29 Apr 2025 17:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947760; cv=none; b=aywM7r17dU78S+Syu9gU0uOsKUPTmOmBkAcUls6ABdwXPCvBrvxa/0Skpe37AclOD5Q1YfgO3LSj4NR2CTQAy7sv4C4fLRg7PGPd8W2m/zRBuTs9//cn96x/vGEfKAuCJquq7+n9i1Vc0NvP3aGyvSP2/LG931U/zAZlZoMeYYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947760; c=relaxed/simple;
	bh=NkOATRKNMIXA8TQFa2CyYyvdA/RbiBD4gsd9hMaMxTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OELmsdjE+5m5+ys7AEZ3b11LBt8A7yslkGjGFGV4Kks8x2u3ker9vNrC+jghW3dbViLnRaYqJ2+2XrX9LP7YvYWWWp9LiRZlpuzkngVJIaCf/4ky7t5OWEyWUKVAxePPFuH3RRv8YAiGMtwmaND+0YU8KI2orKoV/vII/ah6SFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Tm5YnCB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Tm5YnCB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B1F9C4CEE9;
	Tue, 29 Apr 2025 17:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947760;
	bh=NkOATRKNMIXA8TQFa2CyYyvdA/RbiBD4gsd9hMaMxTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Tm5YnCBlFSjKIrBs9k3WOtKKV6pucN0rTuNLZA5jEBktjZjwFLU8h9AOoJMyzJJB
	 RbWqK1bodZ3Z2Hc/LYNmZ0wMKiURq0XTctJo+g7dZudF/KRFmvwoVqCqiiDYAP1owl
	 3pdFWAf6Z2upoyB2vSHMxfCBaX12R8/GcU5aN8lg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.12 096/280] crypto: atmel-sha204a - Set hwrng quality to lowest possible
Date: Tue, 29 Apr 2025 18:40:37 +0200
Message-ID: <20250429161119.041732594@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Behún <kabel@kernel.org>

commit 8006aff15516a170640239c5a8e6696c0ba18d8e upstream.

According to the review by Bill Cox [1], the Atmel SHA204A random number
generator produces random numbers with very low entropy.

Set the lowest possible entropy for this chip just to be safe.

[1] https://www.metzdowd.com/pipermail/cryptography/2014-December/023858.html

Fixes: da001fb651b00e1d ("crypto: atmel-i2c - add support for SHA204A random number generator")
Cc: <stable@vger.kernel.org>
Signed-off-by: Marek Behún <kabel@kernel.org>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/atmel-sha204a.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -163,6 +163,12 @@ static int atmel_sha204a_probe(struct i2
 	i2c_priv->hwrng.name = dev_name(&client->dev);
 	i2c_priv->hwrng.read = atmel_sha204a_rng_read;
 
+	/*
+	 * According to review by Bill Cox [1], this HWRNG has very low entropy.
+	 * [1] https://www.metzdowd.com/pipermail/cryptography/2014-December/023858.html
+	 */
+	i2c_priv->hwrng.quality = 1;
+
 	ret = devm_hwrng_register(&client->dev, &i2c_priv->hwrng);
 	if (ret)
 		dev_warn(&client->dev, "failed to register RNG (%d)\n", ret);


