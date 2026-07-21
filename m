Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA8C3BCD29;
	Tue, 21 Jul 2026 23:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674805; cv=none; b=jjrQlJxHKOGPgECsMxFrDfMzXrgG9caD23LkG0EX2IqzkJSQnNJ7N1fejCV7NFgEyUqCMNghGdMsSpdSofZuUokrOvZYixj5BZQOuITJx0zDNaSKwsuHCDWit0rIskuk5yBet2nzmOHsA5U58W/X73mOEzYISmXdieCfNuV0Zlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674805; c=relaxed/simple;
	bh=c2bb++E/0eMXAaPEmc6pMQVtph5ntk5EKlFVrb2vntc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Iw7ratdF2X1kwJyrJLoKoLEOjvPGeMeRciosoOZRpLFL1N/oFflYEwvclD2k1tXlZ+P/YMGMqtMRDAV5IeG7dAvorvj2VNJSj2amafX+FobGZXHMkPPxuQde7R7ayL6FDMWdji1cDPf2/chqiHDtsNaboyGZiJZnF2YAooFqJak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r5W81+jR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r5W81+jR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC851F000E9;
	Tue, 21 Jul 2026 23:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674804;
	bh=79junpQ/eAJSIKcA+vV2c7zGWILuYNthGgP58jebXQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r5W81+jRazoLQUzbQhsZ7AKJ3721yTwtTFxJ8MJ9rPuzD0gTN57WozmywyVRI6Aq8
	 FfyWy9yv/VKyQwdUpaBqLMRj2uvkdmZoqhWI3GCMQwBl0jVwmT3ZQVvn4/2fPR8ZEa
	 o124H1hLpgCxe4GOjR5D1KT/unp2g//rIhN84CYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 677/699] crypto: atmel - Drop explicit initialization of struct i2c_device_id::driver_data to 0
Date: Tue, 21 Jul 2026 17:27:16 +0200
Message-ID: <20260721152411.040775212@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
User-Agent: quilt/0.69
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

[ Upstream commit d86ad3911a5d4549297ed810ee450e5772fd665f ]

These drivers don't use the driver_data member of struct i2c_device_id,
so don't explicitly initialize this member.

This prepares putting driver_data in an anonymous union which requires
either no initialization or named designators. But it's also a nice
cleanup on its own.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: ea5e57cc9718 ("crypto: atmel-sha204a - drop hwrng quality reduction for ATSHA204A")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/atmel-ecc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -387,7 +387,7 @@ MODULE_DEVICE_TABLE(of, atmel_ecc_dt_ids
 #endif
 
 static const struct i2c_device_id atmel_ecc_id[] = {
-	{ "atecc508a", 0 },
+	{ "atecc508a" },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, atmel_ecc_id);


