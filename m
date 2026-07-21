Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E40395D8E;
	Tue, 21 Jul 2026 20:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664460; cv=none; b=cWIFmX9h8fWeUsgjQh3SsveC7NOwNenQ6acgCpZBnAoSmaoxvg/Xfkz//mJ1rGt7OODujUkL7Ix82cVi7O2Z0hRjU27WUdgYvxnDzDApjabWytZr2+igzu+QSwEct2ij17fx1h5ZeSR/U3Ogg8DpOwfQ3z2M1azyqz78UPQXTAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664460; c=relaxed/simple;
	bh=4PaArK7DdzgLalcp3/gwDPoGH/4Gm2ldgWL0rTEMzbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qEk8d2csPwvfpohIMU9480oEc0LjoCbD/7x/FZ+O36CFV1GM2D9hXTfV/JrKiXbafaJbzvxMbGQcegoSstet5Cs9RUItfMFyqf6bFX2cfM019lhZyu+ORSk08MYnjhr1zVCb7ul+RGY7WvXt9Gw7jEg87uwbZ669u3WxW9fMi6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NJnzsCQp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NJnzsCQp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A7351F000E9;
	Tue, 21 Jul 2026 20:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664459;
	bh=bq/W5pHFwpEL9I6+gbf83hz4eBDILf0nq7/cM24Khoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NJnzsCQp89AP3/vdVLOF42M2nexxNHUIEXeRCQEG1gDzg9e4H91RAa8U5FSIRdiMq
	 zSKgi8OVXg5ax1p4bxRa7mlcBazagnDdkw8/CBBH7vsEurCK/g5zpbGs1wrYSIYFGH
	 GxhZezQ5joXdjqd7z/VGTTxSn+Aw9ViumUEzMlt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1209/1276] crypto: atmel - Drop explicit initialization of struct i2c_device_id::driver_data to 0
Date: Tue, 21 Jul 2026 17:27:32 +0200
Message-ID: <20260721152513.121746164@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/crypto/atmel-ecc.c     |    2 +-
 drivers/crypto/atmel-sha204a.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/crypto/atmel-ecc.c
+++ b/drivers/crypto/atmel-ecc.c
@@ -380,7 +380,7 @@ MODULE_DEVICE_TABLE(of, atmel_ecc_dt_ids
 #endif
 
 static const struct i2c_device_id atmel_ecc_id[] = {
-	{ "atecc508a", 0 },
+	{ "atecc508a" },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, atmel_ecc_id);
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -214,8 +214,8 @@ static const struct of_device_id atmel_s
 MODULE_DEVICE_TABLE(of, atmel_sha204a_dt_ids);
 
 static const struct i2c_device_id atmel_sha204a_id[] = {
-	{ "atsha204", 0 },
-	{ "atsha204a", 0 },
+	{ "atsha204" },
+	{ "atsha204a" },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(i2c, atmel_sha204a_id);


