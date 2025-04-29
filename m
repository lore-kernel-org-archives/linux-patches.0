Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21A0254850;
	Tue, 29 Apr 2025 18:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950365; cv=none; b=OmEYhfNtAI2d5zip7YyIK5zWvbtZ7RV/0MsW+DRrPlwCvXm1G28ADIhlXlTIoSjJ+KymskknW2t1LmH6od+YAbS5q3Y74FsVRg13vfPfjXEhf+bDq40IIdTIdupMESfcaPyqsN+jJPBZ+szlhJnt0pd4V+p8lcZl92frNwWJfkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950365; c=relaxed/simple;
	bh=tOySkvdFzhHoUX0ThP5F1Abxl389SwK+YvKyHQBCNkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NW9O0cmIBh+wchek4Mf3I2eULgfPbxM4/Po21w7OuzaCxxYoOgqiL70yKfEndNkGxTck1HtHt7zde4pKEDSM3bxhE10OfMU1octfo5hvuZtlptk+/v4jDWk7P8xbLTuWOA+vX1UsRtX2eDwiVhXLC11bFRBv9/pQ9YzUqlrIHQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LYS2PDCq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LYS2PDCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA5EC4CEE3;
	Tue, 29 Apr 2025 18:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950364;
	bh=tOySkvdFzhHoUX0ThP5F1Abxl389SwK+YvKyHQBCNkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LYS2PDCqABC7YjwweBKXLDbsC6G6alDvcvdTn6YQGY1G9fMpElaG8MtJ3lU6HSOGg
	 g8NxO1hMUUytvYVX1hagaoraO2J8SBrnniItk2BHXQH1VUdDp+UHCie7WvEza5ACkf
	 KiCEWo5jQBuAC8RYXDLfoeKUaB4V0HW6K5F62ebc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.6 073/204] crypto: atmel-sha204a - Set hwrng quality to lowest possible
Date: Tue, 29 Apr 2025 18:42:41 +0200
Message-ID: <20250429161102.410915515@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -107,6 +107,12 @@ static int atmel_sha204a_probe(struct i2
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


