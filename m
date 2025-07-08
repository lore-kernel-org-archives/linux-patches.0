Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083CA2E3385;
	Tue,  8 Jul 2025 16:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992901; cv=none; b=Ke1mLehN8oUWqh+HDIHd2uNDvSptmAy+XwD5Ja/8+jz4TXSfzV71/QohaJyaPNsQmBN8FAA0wMEwqdsLXuPmqbDnw7uLda2IlI3pVJjRUEqr25Qq8jjcPKklAos++rVHRtKuibA2iqhzrg9OM7VI34G7WhQ7MpF36diuUiWq39U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992901; c=relaxed/simple;
	bh=sJQ1OgICh6KxhoS1ei2PsckflVqkyRbBTEqFjTfBRxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AkAHBLSv1Y5fCz2L47Zw3ptE2OW59IvVSvx/VDjcBF83Z9AMA2ZUUPDKsLdPMXq1LpUMyEZWF/4fC8wrfI2PQNNV8mJu9RADcb2eVWNJyTHf/GdRonofT/Xy22NCcCfyUp6mD8xpcrFLhn8guJMEDDFWNOtgFzq8QUsxfFTYToY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qsj0byWE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qsj0byWE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24CC0C4CEED;
	Tue,  8 Jul 2025 16:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992900;
	bh=sJQ1OgICh6KxhoS1ei2PsckflVqkyRbBTEqFjTfBRxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qsj0byWEDGAF2CwgaQ8cGdWIpYbhFpcM0MxTzRtLw02bYYDAu3XV+AlP29xXbkMw3
	 liDBfYg+Yg50wXbJoLA/zKL10NYO05YMbLayLRnLxckz5O5X/gbw2wUKkDeeV/FN37
	 ut8LKCaDYoCsruzSInEyeMeSlfBdE+2mfX/V50ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neal Gompa <neal@gompa.dev>,
	=?UTF-8?q?Martin=20Povi=C5=A1er?= <povik+lin@cutebit.org>,
	James Calligeros <jcalligeros99@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 119/232] ASoC: tas2764: Reinit cache on part reset
Date: Tue,  8 Jul 2025 18:21:55 +0200
Message-ID: <20250708162244.555277938@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Povišer <povik+lin@cutebit.org>

[ Upstream commit 592ab3936b096da5deb64d4c906edbeb989174d6 ]

When the part is reset in component_probe, do not forget to reinit the
regcache, otherwise the cache can get out of sync with the part's
actual state. This fix is similar to commit 0a0342ede303
("ASoC: tas2770: Reinit regcache on reset") which concerned the
tas2770 driver.

Fixes: 827ed8a0fa50 ("ASoC: tas2764: Add the driver for the TAS2764")
Reviewed-by: Neal Gompa <neal@gompa.dev>
Signed-off-by: Martin Povišer <povik+lin@cutebit.org>
Signed-off-by: James Calligeros <jcalligeros99@gmail.com>
Link: https://patch.msgid.link/20250406-apple-codec-changes-v5-3-50a00ec850a3@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2764.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/codecs/tas2764.c b/sound/soc/codecs/tas2764.c
index fb34d029f7a6d..e8fbe8a399f6d 100644
--- a/sound/soc/codecs/tas2764.c
+++ b/sound/soc/codecs/tas2764.c
@@ -538,6 +538,8 @@ static uint8_t sn012776_bop_presets[] = {
 	0x06, 0x3e, 0x37, 0x30, 0xff, 0xe6
 };
 
+static const struct regmap_config tas2764_i2c_regmap;
+
 static int tas2764_codec_probe(struct snd_soc_component *component)
 {
 	struct tas2764_priv *tas2764 = snd_soc_component_get_drvdata(component);
@@ -551,6 +553,7 @@ static int tas2764_codec_probe(struct snd_soc_component *component)
 	}
 
 	tas2764_reset(tas2764);
+	regmap_reinit_cache(tas2764->regmap, &tas2764_i2c_regmap);
 
 	if (tas2764->irq) {
 		ret = snd_soc_component_write(tas2764->component, TAS2764_INT_MASK0, 0x00);
-- 
2.39.5



