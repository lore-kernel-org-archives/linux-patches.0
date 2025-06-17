Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B972ED141;
	Tue, 17 Jun 2025 15:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175287; cv=none; b=hyzkzTn516d7kPaXPBbBT1O5Wud2pf81LmzU1mGZKOiMjzQzml9WdKOqY+a1LHVKXkDmNBFGYWyAmoT8+dkEvzpbOvdd7vtSdHEvxC/8skphr192hOPAvDxl9u+dt3qFkxxE8FNT8hg8ZXoF9tr4Ry+Ob7QjcjVEL3BOl1J25Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175287; c=relaxed/simple;
	bh=W2HvXao7aFdZtnkMUqV/qYUx6UhML5I+rmEVM4z8c90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lXj/hJTwALCsbMH0fyRRtZsb+2f/JPbSW9j3P0Tfcs3Sw7Ynikcij5LHm1OqGq9WBR+wdOZ20CO3ity82FT/A+SgRKvlJwsIn4mxBD4sBRBgdGDjok6QYideTI4aVZ/JpuJN58ZAnl+oT+J6EGjdUjnWLZzgw8dX2PiQ5hBPGqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IngvZoQb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IngvZoQb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 665E8C4CEE3;
	Tue, 17 Jun 2025 15:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175286;
	bh=W2HvXao7aFdZtnkMUqV/qYUx6UhML5I+rmEVM4z8c90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IngvZoQbOhu7tJEh1F72GQOwVjA2fp7A03bTRSCt5CgkWceuwEdJwkOuaIUu07SOF
	 y99TLgqbAsZD3HezgXMOO05rOXt6E2R7dgj44N8vSoRczZubVXj6oKyuKKKLeidlwY
	 aXPTc8xbDdDP5re1eA/ZTFx3HVUihDCBAPzy4/J8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neal Gompa <neal@gompa.dev>,
	=?UTF-8?q?Martin=20Povi=C5=A1er?= <povik+lin@cutebit.org>,
	James Calligeros <jcalligeros99@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 055/780] ASoC: tas2764: Reinit cache on part reset
Date: Tue, 17 Jun 2025 17:16:03 +0200
Message-ID: <20250617152453.736371248@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 08aa7ee342568..49b73b74b2d9d 100644
--- a/sound/soc/codecs/tas2764.c
+++ b/sound/soc/codecs/tas2764.c
@@ -546,6 +546,8 @@ static uint8_t sn012776_bop_presets[] = {
 	0x06, 0x3e, 0x37, 0x30, 0xff, 0xe6
 };
 
+static const struct regmap_config tas2764_i2c_regmap;
+
 static int tas2764_codec_probe(struct snd_soc_component *component)
 {
 	struct tas2764_priv *tas2764 = snd_soc_component_get_drvdata(component);
@@ -559,6 +561,7 @@ static int tas2764_codec_probe(struct snd_soc_component *component)
 	}
 
 	tas2764_reset(tas2764);
+	regmap_reinit_cache(tas2764->regmap, &tas2764_i2c_regmap);
 
 	if (tas2764->irq) {
 		ret = snd_soc_component_write(tas2764->component, TAS2764_INT_MASK0, 0xff);
-- 
2.39.5



