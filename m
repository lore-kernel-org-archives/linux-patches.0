Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061028;
	b=H/uK1UHs6Hn7LpLo698ebHDBI18+ayLj4A2GPqYkgu0F/v1Rc36U+l0VoGk56GgOV+An
	 V+FqX0Voftj/9CldQ6xmOJiJ7ia145zxXHG7dh6cTCmCw2zSBovmWDJM58VsiOVw8eCxP
	 E4/eUQXrMReGRVIPQp3P/UiHZdJZWQJa3J/DZUpab+4nSLF9q/BKtJ6vgNdNSiub0ayWR
	 eren0BJCw4/gf3r6bFUOV9dcbtByxS6jnjnS5QW8KxrXzGydMnNUX7/LAyM43qPJpRa6T
	 Gg2C71/3+nnJAICsGTY1AlWqPN7tookB+Mg6qHoVUEcgd0+MdnrBFyHQZnDuqbAiNVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061028;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kqjdPzRgiL33+6jTrUNz3dAQIV04D6Rk0gMX7WlGAfM=;
	b=hsdP77hxs1MVxhZ9o+mzhfelDuPKfD6jO+BIGtqKEGE4u2l2IfBftkKzi974NJVf/UAk
	 O012n1XcL0OUOWe0IwtdDc69sKMepm5A1YeHdc+IwG+WCTsm8EFcIJ46Ux9BeFQbR8wLQ
	 1uGDgmuqUU2dxL3C9v/nz040dmPS+HioHY6XFR4882PQ5JC+/x4XLM5vFhCXmmoVJ6bZE
	 LBMhkbiERtbLhLdtbRrvj4H4EAfYATcOu+2YumpbzMEDmPDnGyeSEHLmu8LEwcWylHFqh
	 IHP7kLeiiIrr5ryb70xINFXJ6AWdShbI4ZnVvBJ1Ttvqymkh0AnMY8OBaVcSdCSEwmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bmqV+zVT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946FE606D81F;
	Sat,  7 Nov 2026 14:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bmqV+zVT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4018E1F0089F;
	Sat,  7 Nov 2026 14:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061028;
	bh=kqjdPzRgiL33+6jTrUNz3dAQIV04D6Rk0gMX7WlGAfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bmqV+zVT38JAX6W3CGumMYmAzlC6Cry4HoXaEijWyGxlk9teCsEzA4JDDHkahTC9F
	 U0uzBNVHXh9ZqK2aTW6c0iVydNib2jeLOaHL7i2wEY6ak1U3OFLN3geCK+scuXvKKV
	 BwpASGpgS3pVXwUxw9R1dVMW5jvw0gTl9zHLapHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0364/1536] ASoC: codec: max98926: fixup invert setup mask
Date: Sat,  7 Nov 2026 08:39:40 -0500
Message-ID: <20261107135007.879903589@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit dd0ae9a2e19a24c532c9aa80a44f572b4907bcdf ]

invert might have both WCI/BCI mask, but regmap_update_bits() masks
BCI only. It needs both mask. Fixup it.

	static int max98926_dai_set_fmt(...)
	{
		...
		switch (fmt & SND_SOC_DAIFMT_INV_MASK) {
		case SND_SOC_DAIFMT_NB_NF:
			break;
		case SND_SOC_DAIFMT_NB_IF:
=>			invert = MAX98926_DAI_WCI_MASK;
			break;   ^^^^^^^^^^^^^^^^^^^^^
		case SND_SOC_DAIFMT_IB_NF:
=>			invert = MAX98926_DAI_BCI_MASK;
			break;   ^^^^^^^^^^^^^^^^^^^^^
		case SND_SOC_DAIFMT_IB_IF:
=>			invert = MAX98926_DAI_BCI_MASK | MAX98926_DAI_WCI_MASK;
			break;   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
		default:
			...
		}
		...
		regmap_update_bits(max98926->regmap, MAX98926_FORMAT,
				MAX98926_DAI_BCI_MASK, invert);
		...		^^^^^^^^^^^^^^^^^^^^^
	}

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://patch.msgid.link/87wltomc97.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/max98926.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/max98926.c b/sound/soc/codecs/max98926.c
index ae962bda163eb..8f48f702d5621 100644
--- a/sound/soc/codecs/max98926.c
+++ b/sound/soc/codecs/max98926.c
@@ -360,7 +360,7 @@ static int max98926_dai_set_fmt(struct snd_soc_dai *codec_dai,
 	regmap_write(max98926->regmap,
 			MAX98926_FORMAT, MAX98926_DAI_DLY_MASK);
 	regmap_update_bits(max98926->regmap, MAX98926_FORMAT,
-			MAX98926_DAI_BCI_MASK, invert);
+			MAX98926_DAI_BCI_MASK | MAX98926_DAI_WCI_MASK, invert);
 	return 0;
 }
 
-- 
2.53.0



