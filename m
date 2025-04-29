Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468AC82C60;
	Tue, 29 Apr 2025 16:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945978; cv=none; b=tXDChel4H9r6EiViIN3WdrJ++te4p+jQYeal00cz5+FW/2ZOE/Y7/p1OrYhbQXZUpARAH+XHinZdtEmzdOVocy3ek1upmJwk7sUnDgL5YjVOjB7OLivCKcSsKw02ujYWuftWLrYGh0efURgUgNKHwtxFxO+9k8P39VK/oqUM3xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945978; c=relaxed/simple;
	bh=yz/TAfUGNi6SfjmyPCmwEAPIDMU+OmB0kmx9i5cEhIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X61vJwApN/CliHfE8ysidosMDiSXcn9ftpSIVDoiKz1TpzDRZMjrot0bZqSKFAC6fDwJMCv2/1zS9SB/4M8OBqmzIummFR23isb+8oqCy8gu+34Kn2f1SKLO1w6WIdu3ptxK+gmADTYIPdja/mQy1iGxhrtx7tK2uKs/iYv1iYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PkaLa3Ot; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PkaLa3Ot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCFFFC4CEE3;
	Tue, 29 Apr 2025 16:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945978;
	bh=yz/TAfUGNi6SfjmyPCmwEAPIDMU+OmB0kmx9i5cEhIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PkaLa3OtT1DIYjlCEZtCV/ivGhgun2medUmzdrJ0W4P3wq8CXWLzoU0PyNBeHMRMU
	 D075hv99tBWh2wud6ReaXd1R6y4QgjaxtUUVcmebPdFbipg8mStFNMVKKCEIXXa9Tr
	 zwz/LgXtmrKYS4AYbo7cdKG8T37aJdZtU/snoolU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.14 112/311] crypto: atmel-sha204a - Set hwrng quality to lowest possible
Date: Tue, 29 Apr 2025 18:39:09 +0200
Message-ID: <20250429161125.620202426@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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


