Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F361A44AB9F;
	Tue, 21 Jul 2026 22:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673030; cv=none; b=E4fH1V3NDJ8FNmEtI/U5RV1/rXT/SyRK9M24/507NXS2gfXYNse4zM/oJ+7pkXX96UVJutl0FwCkirnV4YaKo/iZTOlVQiUvQ9azEaaZtiLJjuLJqDwPUihaMn1dYn4aRiVf/0IsZUwPAbFUdzG1154Zm+5Wbd2fRKDYw1ZYGvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673030; c=relaxed/simple;
	bh=KpP03B2G8C/NFx1EdWuPM/1ThO94vrAJiSsKcvJZjzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CHUYdMsC1VJ6QImDHV4cM4WERT1XJ0fSzK8pQOEr+h9ZRY7+K50iCOLvAp5+LozE8Tr9b1xTlwQCmi8+exFhkyGyVIf19e+jkYZ1YJxL09SBYacTb0NRqZ4trOW/UMMjPunohZF1uGB5/RZ8vDxhEaKGV7qlHHw47qlvmZ+CBEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c3FKTUxG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c3FKTUxG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C3BA1F000E9;
	Tue, 21 Jul 2026 22:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673028;
	bh=6MbB7ZFJXMjWh9aTJRA4WDdMoCRZa3GvkCYyAFuVQ+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c3FKTUxGDe39d2LtUj3HLkP1jVSrT+ivOAa1V1PHRb7zpQ+WmO1L/qX7LSy/nIs2Q
	 V2LOOitNFwH00orHy+8mjA5zEjtLT84+dQmycuoAVw3HTJwYcvTaWAy6NWadQS2ZXf
	 /8zTjIOYuSQgfjyP0o666ZRtWrxpGhfffBdaD7wE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 822/843] crypto: atmel-sha204a - Mark OF related data as maybe unused
Date: Tue, 21 Jul 2026 17:27:37 +0200
Message-ID: <20260721152424.567583068@linuxfoundation.org>
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
@@ -136,14 +136,16 @@ static int atmel_sha204a_remove(struct i
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


