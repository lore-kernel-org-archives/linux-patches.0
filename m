Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7065347BC6;
	Tue, 21 Jul 2026 22:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673033; cv=none; b=ZdoM6jNrjZTDBzwWbDppfQkm1uupBnNdkq1rZz3Gu1KFGm1qDHSQwyhyrNLbhjCzqBKj7bP8RVqGfxzYXsND5zXEkR4ArKGiEiH/kVrzdSLyZgosX3B7c7kgKpu+7GZD71wWCPm/V6MhocpgtjRAzFiIDyNxpR8JGb7GTp7/TZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673033; c=relaxed/simple;
	bh=Ax5F0TbH6PmHOky90BkxM8NjkKDEQhDShi7xgL5cUc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WLwHoCJIlnCt42RyNKppc1F3bpMvrbfTvrLCJvbU2FFl8G5q2sOYTylv8ONcRtHoOouQtVP60SEf1wgW9s5NyqQ3PA5ChtjMAzpPaRCQ87u5ho03Oj7s8Rt1UuxpXwAoVhOdgWVLNJJPrVPCY5kZe+PA+VghdsLpmK/aGToGlP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kJ48It1j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kJ48It1j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 073BA1F00A3A;
	Tue, 21 Jul 2026 22:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673031;
	bh=6bB4vBq5PoHYJXFN4sCbeND2WZ79evGXbaLI32O1eX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kJ48It1jAnhMCHiAy3LnbVmLm9nw5k+osCkUEHe6h1hdrXBBwozkbkNTp/Qiv8qpc
	 JRT5RhOCq1WzNHmDQ1YYQUJOpl0yQGiMM8cPurY5SwKXq/atj/r/LeeIxuHEzWj9so
	 kAp7ONncqQzKEo7n00LyzjfjOZFPrjqu/xzWUVxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 823/843] crypto: atmel - Drop explicit initialization of struct i2c_device_id::driver_data to 0
Date: Tue, 21 Jul 2026 17:27:38 +0200
Message-ID: <20260721152424.591105511@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -375,7 +375,7 @@ MODULE_DEVICE_TABLE(of, atmel_ecc_dt_ids
 #endif
 
 static const struct i2c_device_id atmel_ecc_id[] = {
-	{ "atecc508a", 0 },
+	{ "atecc508a" },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, atmel_ecc_id);


