Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2BF844AB9A;
	Tue, 21 Jul 2026 23:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674802; cv=none; b=knwegByTxq7YxheH6kC7p0g2JNF5ngF8X0PRf17mNmknHvRSaIU1HzKJs1HTODpsAZIy0HEFFQw9UkQYRb2vJX1QIJlua0fnveSBTZb2TEB2b2xAZUR+gZpriXWNq7fAYeyT6FKFgOk97JobKLo4kjoenI3TsLwa/M3SHnt2oRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674802; c=relaxed/simple;
	bh=VaVaWVnwarwm+zbpEWLfC/Ky8vuNIH0Edxg6zfvBORw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qlX96xfnMvOzE+EWp5D+jr5BNXnfL5NqLeuhbrIiPhPXZYLEsQr2IR9nrbgOrVzNkNhHn/JnWcBNRwuwlW67ruKz1je8/jDKvTnL5qJO5idivuh72TZ4p1n2PLmpc95kqADLSdJfItW6xt6cmozPamBsi30a0zgLgKNpzPmk/10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wRNeEbtF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wRNeEbtF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E9761F000E9;
	Tue, 21 Jul 2026 23:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674801;
	bh=Ex4Lj7TPMUhkuYWcCII8P1JdxBOUY41KEYInSXbmnlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wRNeEbtFBDk4jfoEhbHK5DXDSCjudgyr0zfz6fft1khathmypRsRa6mtlUv3LsP66
	 rN22oxeK54taaMK5iy9Xm6gTyYMLl+o4urE9JU5C3Q2LZ9Q66lcjKgYgA8MiEuEv05
	 pPMF58qRP3KBCnrqaJtVqYGr0drR+gxI/QCh4Nfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 676/699] crypto: atmel-sha204a - Mark OF related data as maybe unused
Date: Tue, 21 Jul 2026 17:27:15 +0200
Message-ID: <20260721152411.016940570@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 75f3d950054389e2556277e42170e37dd97cd872 ]

The driver can be compile tested with !CONFIG_OF making certain data
unused:

  drivers/crypto/atmel-sha204a.c:129:34: error: ‘atmel_sha204a_dt_ids’ defined but not used [-Werror=unused-const-variable=]

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: ea5e57cc9718 ("crypto: atmel-sha204a - drop hwrng quality reduction for ATSHA204A")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/atmel-sha204a.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -137,14 +137,16 @@ static int atmel_sha204a_remove(struct i
 	return 0;
 }
 
-static const struct of_device_id atmel_sha204a_dt_ids[] = {
+static const struct of_device_id atmel_sha204a_dt_ids[] __maybe_unused = {
+	{ .compatible = "atmel,atsha204", },
 	{ .compatible = "atmel,atsha204a", },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, atmel_sha204a_dt_ids);
 
 static const struct i2c_device_id atmel_sha204a_id[] = {
-	{ "atsha204a", 0 },
+	{ "atsha204" },
+	{ "atsha204a" },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(i2c, atmel_sha204a_id);


