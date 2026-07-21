Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409603B9930;
	Tue, 21 Jul 2026 21:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670811; cv=none; b=aXFwlFzDmvfzeQcYI1s2owqaBBQCI4JTecn1FLSp45AxCXmgmXer5eadyIGQpMzKgt+UalwaxjeAP/J5uwbhy+dbKf9op5QoS20LqhW+d71fqjhwZg3wZsHSoMmqot8FXY3845s5IhduJR5faYekXLUJX806GX3iNVYGUghOoCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670811; c=relaxed/simple;
	bh=GSojnkwpWIeT3IFxLTI4QqeIYCj6b1cuQgezE+N3/+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X734YfmtFPL/yFb1KjlHy0joEP2R49OEDmr0ujX2577fllmX3XEpipUKg/GTn0b/zEgEP1bYQFat5dTOM/jzyrHorOFBREqqRPInzgrDEHfCszQ+16rwjTvHIWv541jdpjGea6mD6O4KHCmyT+sxpzaGwdXFUatl2u/tBZY8Rv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PD7g4kaU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PD7g4kaU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E391F000E9;
	Tue, 21 Jul 2026 21:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670810;
	bh=ZA2EQ2ESp2V/T4lyYRhexZCLEj8lOP5d8xR/schDpcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PD7g4kaUIqf/TfUNmxBk1gpy1drUdmTaWLTwYqUZ4Dq/CJtW65XX6nt9n7XF5uevO
	 t+Encqa6BzrweqP20eQchs67VQ0ffuO3iw5HnkwrsRNWTf2IljXlPeJIaur3Ltlr2I
	 2kbypams8KVpwmkB2n4WDtqrWF0VJvtRcOn0OoeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1030/1067] crypto: atmel-sha204a - Mark OF related data as maybe unused
Date: Tue, 21 Jul 2026 17:27:11 +0200
Message-ID: <20260721152447.617546756@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/crypto/atmel-sha204a.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -132,7 +132,7 @@ static void atmel_sha204a_remove(struct
 	kfree((void *)i2c_priv->hwrng.priv);
 }
 
-static const struct of_device_id atmel_sha204a_dt_ids[] = {
+static const struct of_device_id atmel_sha204a_dt_ids[] __maybe_unused = {
 	{ .compatible = "atmel,atsha204", },
 	{ .compatible = "atmel,atsha204a", },
 	{ /* sentinel */ }


