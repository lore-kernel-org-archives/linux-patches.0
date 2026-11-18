Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018703;
	b=KyLTeT7fCDwm6iC90g5WoispTrcv8p5PgTubKvchpAOIyo7Io8/JqwKhgRh4HMawrIhb
	 BnTbPaz7gK8GRbydOCGS1sv9qJ33qai4bYrS06yXONwsoi3EroaUD2sjQwLQo9jaU0XG3
	 bIHxnW4wGuulbemQlTGaE/WTNGiqyW/n9NWQbKqY/ehl3YvTN98cT3iG9k/S3VeF5MHdq
	 Li19GjjHPRXpVjuo64OhtRmF3wHBR25cRPWYm42WmzZ3+9SRIr+TTBT9JzlTpQoB5r+H1
	 dsjIYYzIn2fCd9+hZQrsE4nG9CjzbS3rpR2slPIAZ/+88hmc/kKQCurrReyhrkj1NLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018703;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z0wtvvOlHZvgsPsktNNwlS4SPzY3YS08ao+KqbDCiac=;
	b=H8aZC+GYGeZoSf5lvw8bHREUTPBn1WJ4eaR8OTBzTcg5B0gF7o3yHa21rQGrUwK45hNm
	 hyUb5gxPYvoMJYMEXlxVjAmo7/AuW+9h4g2rtw0fot+7rzmTql56oGNQd2WAoqH2R/sGy
	 GETEzsN3mL4noEKrcH7fP0Lk8s/zOj/TYJg5jarMSnDb2BXRJP9H6qP9zuQPbpmJnMR0f
	 zQuMtVsNR0V7pooi8EyZadNdLPeIueF/qJMkEST1hwYoDqVvWLnOVVqs6WWTp4bf4OqIW
	 XyZvbpZNK5lSreLGkowKe88WlhIpIguUFPYkc5GJuNHUgacdEPkhr/2Hgdl5u2SgGFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a7FHv6OR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747E1606A32A;
	Wed, 18 Nov 2026 16:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a7FHv6OR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA9F41F000C5;
	Wed, 18 Nov 2026 16:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018703;
	bh=Z0wtvvOlHZvgsPsktNNwlS4SPzY3YS08ao+KqbDCiac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a7FHv6ORgJNfaZHdy7x/25i38EC9jdoQlE4AqHrXBj00kCkFv+hcbeIFYa4GaMS5X
	 wbbhIC/Kw4tmq8uwMAEUXyrlvFl1CrPT0CcmFD8g6ttl+IIiZ3ILbv7lR4rVnfuhoC
	 FaoiKaHPg8sCFjW2RAPFcGpRdykxhzWh56MGA/Os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1307/2651] ASoC: codecs: es8375: use devm_clk_get_optional() for mclk
Date: Wed, 18 Nov 2026 15:42:27 +0100
Message-ID: <20261118150335.028835611@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 58e7bca5cf264e910ad9199cfc40246e0a2834f4 ]

es8375_read_device_properities() gets "mclk" with devm_clk_get() and
then tests the result for NULL to print "assuming static mclk". A
missing clock makes devm_clk_get() return -ENOENT, so the probe fails
before that test can match.

The binding does not require clocks, its example has none, and
everest,mclk-src lets the codec run from SCLK instead of MCLK. Use
devm_clk_get_optional(), as es8311, es8316, es8323, es8326 and es8389
do for the same clock.

Found with an experimental clang warning about NULL tests on functions
that return error pointers. Tested only in QEMU with i2c-stub in place
of the codec, not on real hardware.

Fixes: de2b3119f9f7 ("ASoC: codecs: add support for ES8375")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20261003190738.77564-1-kmehltretter@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8375.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/es8375.c b/sound/soc/codecs/es8375.c
index 2c58225feddd9..8a3e3a6a748f3 100644
--- a/sound/soc/codecs/es8375.c
+++ b/sound/soc/codecs/es8375.c
@@ -665,7 +665,7 @@ static int es8375_read_device_properities(struct device *dev, struct es8375_priv
 		return ret;
 	}
 
-	es8375->mclk = devm_clk_get(dev, "mclk");
+	es8375->mclk = devm_clk_get_optional(dev, "mclk");
 	if (IS_ERR(es8375->mclk))
 		return dev_err_probe(dev, PTR_ERR(es8375->mclk), "unable to get mclk\n");
 
-- 
2.53.0



