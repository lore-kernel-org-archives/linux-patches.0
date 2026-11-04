Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830969;
	b=E7qAzaLC5XQ1dsGzgocTp0ztEePPgdlumbj2rRjEsUUOHZbT2WxUWZosOmxMBfNuWTrP
	 F5GHckvo1EwmtQgrh8Z+lVPT3wsrpcws4EUmDth78yeIs7vJBnoMRU9lUE3am59RNBEM1
	 GX3wcEwBHBdcT2V8fL9szIsgYtW+FrwcmoRGxPoITsvo5/MQLGz+sTaLhLlAJRBH6cDO+
	 OhPQJ6Rpg3tO/t2QR7NEVDpPL1eSufIsfs4+BOP0eFqm4sRlx5vDAIdmyEdKQhHii47R+
	 i9GRA5kt3ZyP9EtoPlgw0bRMPSyPO/ndZG6n/lsav+5V7stg4ZVNA9OHzeLNOJZZ9tQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830969;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9YkABSUnJJ9SV9P/t3PhUzbrP7Su5VwWYuG119LEHyk=;
	b=Q6HeorDwQevSlWjIo+AZHQpiuD8qYYjeOllTk8OcYsSTZJ9i2wOOVjPQr8gq1ReO9foS
	 Nhe9fUo3PNACqKO1QUxTLz09ase3GNlSYJtPwNipkygNsUtVds4DKyJuX2+YiOL+DNk9g
	 pRkZiEmE2mcuANVeaCXACdIlQ6C/mnpvcxHKE0cw5x0gTT9dm0hXhlaNJOTvTTLqT4u5n
	 IwCuDFni7SXajWyxlkeIBm8o1wkbs97DofLfp9YUxymL49KG2gEOOJnnOBWTM450I02DT
	 iXDx4owHZTlRr0TZ1Gqa7pnB2E8me4S/xeQSUzoAZqTfmDcMrCGPNZ6J9iHprs2kh6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EYTR1WDI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0624606A876;
	Wed,  4 Nov 2026 22:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EYTR1WDI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874801F000C1;
	Wed,  4 Nov 2026 22:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830968;
	bh=9YkABSUnJJ9SV9P/t3PhUzbrP7Su5VwWYuG119LEHyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EYTR1WDIMHytB+hAbDjMdFrPOYkE9qArVPDeWDAx6HO3zlXOfnzDUkJd3xnys/rm0
	 5cU619NbHladIklEgIGjBOVEehhkq94DK8SEcEo0fGwu6OcfptJFlZ2pzse7W4fszq
	 0z5sWilo4XHPotkSUmis4YvP68JzqXNYyJGf/1PY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0432/1005] ASoC: codec: max98926: fixup invert setup mask
Date: Wed,  4 Nov 2026 16:02:45 -0500
Message-ID: <20261104211056.193258949@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



