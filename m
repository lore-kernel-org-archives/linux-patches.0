Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213397;
	b=OOoyBmG1BWwpYQca6gthG0H14L5ErFwer5OgbEB4eTmJBUAF2dZnNyA8hZv+5jW6jAWd
	 K+v/AFItarUciYcKuQHqAOHGNHDJi1u0F9t/UA9bU+SM6QG78dYcCE39lKmiGJ4VbAwNb
	 x8VmmeT99wknn8leK6LInexqYmQbcasEE9UtGZjsKgLnn56ey8Sjcmy4nClMwzp0iXg8z
	 AL4/5mqLelTtNoKbaGp7+XYwwQw3TlN+4KaVsX4spkRI+W5l6uGX4hVw+MTknOGaxxhZm
	 SPzjAMslDoDrVUPYlUOowPMeY/mDojxeTMGpK3yJ3oM/aQbc904e6wo/2vqT8JxI1AQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213397;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=lYjbbvhunQkmp5hyveqWB6UPtetgOmq7kzh13bnZuv8=;
	b=VpYYiAhy5XHq/XKgWuhdPI697uZ2AGZKA+4t3aqWOruFUZoNluuOdXMLN8gj6Qd3MuEN
	 N+AIiut5a4jcFgvUyargnhY77mig4pABaHNboXZCI2z3Fu3NxCqz2vhsmjYXpOYzvcvll
	 6Wj5HL/ln1q5trl8jsDHs0+oaABvdP8GF2Bq7ojfatPCAEs78TJi47eUUYLgUT+KkKGQ3
	 S1yhaj5lWYeNDdrHNui3tBulKmSoIPmFBMJWoltMINqsdP2JaGaAPHf33rtvZ+f3DmbLV
	 tJC4cJke7yAkgePHKdHNHmSxaPXha2BBO6JLoOYSx10TTerzOON9yS9z4PAyIrSVOqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NrNGhkOp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4285606A31A;
	Wed, 28 Oct 2026 18:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NrNGhkOp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FAEA1F01825;
	Wed, 28 Oct 2026 18:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213396;
	bh=lYjbbvhunQkmp5hyveqWB6UPtetgOmq7kzh13bnZuv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NrNGhkOpR5vT0OM1ky1o43mkw9cZcwNBXoeeilduyNjvGeyGvtjdZuAohyi82u4m7
	 LDeTKkYlESqfzWsWUwvCJPvTz9QoOQSMYtgsrJ2yIn+OS5kzXQRnLBNEEfBcDJnzia
	 V/FfZatkwH17HW4lrtGAfq8LZ/rW4GjeuM7GwiQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin.sipraga@analog.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0492/1887] ASoC: adau1372: fix invalid default state of output ASRC and DAC muxes
Date: Wed, 28 Oct 2026 17:43:08 +0100
Message-ID: <20261028170510.471861686@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alvin Šipraga <alvin.sipraga@analog.com>

[ Upstream commit 36d0e05815ce84266c8b138cd4f84c3feeaf15f4 ]

The chip has strange power-on reset values for the registers that
control the output ASRC and DAC source muxes - the values are actually
marked "Reserved" in the datasheet [1]. This means that until the
underlying kcontrols are modified, the codec will not function as
expected.

The registers in question are:

  register / field       reset value       valid values

  ASRCO_SOURCE_0_1       0x10
   ASRC_OUT_SOURCE0      0                 4 .. 16
   ASRC_OUT_SOURCE1      1                 4 .. 16
  ASRCO_SOURCE_2_3       0x10
   ASRC_OUT_SOURCE2      2                 4 .. 16
   ASRC_OUT_SOURCE3      3                 4 .. 16
  DAC_SOURCE_0_1         0x10
   DAC_SOURCE_0          0                 12 .. 13
   DAC_SOURCE_1          1                 12 .. 13

Set some sane defaults during the driver probe:

  ADC Decimator0 -> Output ASRC0
  ADC Decimator1 -> Output ASRC1
  ADC Decimator2 -> Output ASRC2
  ADC Decimator3 -> Output ASRC3
  Input ASRC0 -> DAC0
  Input ASRC1 -> DAC1

With this, the chip will behave as advertised by the default kcontrol
state exposed by the driver.

[1] https://www.analog.com/media/en/technical-documentation/data-sheets/ADAU1372.pdf

Fixes: 6cd4c6459e47 ("ASoC: Add ADAU1372 audio CODEC support")
Signed-off-by: Alvin Šipraga <alvin.sipraga@analog.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://patch.msgid.link/20261006-asoc-adau1372-fixes-v1-2-599cc17fb5f6@analog.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/adau1372.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/sound/soc/codecs/adau1372.c b/sound/soc/codecs/adau1372.c
index 13673c96bc548..f89555e3e5252 100644
--- a/sound/soc/codecs/adau1372.c
+++ b/sound/soc/codecs/adau1372.c
@@ -1000,6 +1000,17 @@ int adau1372_probe(struct device *dev, struct regmap *regmap,
 
 	regmap_write(regmap, ADAU1372_REG_OP_STAGE_MUTE, 0x0);
 
+	/*
+	 * Set sane default values for the Output ASRC and DAC input muxes,
+	 * since the power-on reset defaults are invalid "Reserved" states.
+	 */
+	regmap_write(regmap, ADAU1372_REG_ASRCO_SOURCE_0_1,
+		     0x54); /* Decimator0, Decimator1 */
+	regmap_write(regmap, ADAU1372_REG_ASRCO_SOURCE_2_3,
+		     0x76); /* Decimator2, Decimator3 */
+	regmap_write(regmap, ADAU1372_REG_DAC_SOURCE,
+		     0xdc); /* Input ASRC0, Input ASRC1 */
+
 	regmap_write(regmap, 0x7, 0x01); /* CLOCK OUT */
 
 	return  devm_snd_soc_register_component(dev, &adau1372_driver, &adau1372_dai_driver, 1);
-- 
2.53.0



