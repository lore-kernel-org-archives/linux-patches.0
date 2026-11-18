Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043574;
	b=tEE4M2stxt3ogZ9KWH68vs+fHHyHmECTQ9iPbdPeI1u/F84J6/b+X4onwuPwcS+qQgkm
	 mkL2GkVJPvp61Lo9D++ELYYzBdjEI/OZBTIs4s3M/VjILQa/DNxg+XOphCrRGkyq+Osz/
	 lgMsW8xqrYEVKMLLcPvny2Qiz92ODltZ3bU5QRJx9a5yclpof+Wsic7+6SsDU3qDdzrDH
	 4EW0FY+Ddaej1oN+lE8vGgJ3NieXcOa8HoX8TqzMQVLg3cK44vbjQzFEbaJMXn1TSQCwU
	 CSeUJw4qi4nXqRXff9qy6eKfaxz0L7qqwP/VzUZKoD4cRaXMZ1VPEuOwFss6sx/cERw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043574;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q3XzZfAnCRdp9hNkODUa8XK1saMbp37YdrvjY9HLW+s=;
	b=jLjwIgKMhm78tCs3YlRyKKEIDGeav4yMumPmChnIv7VRC6kZmP61i0Q+3Ajp3Yzr+OFi
	 kdWgMJ8jdd8o+wUiik9Z1Vj0PMyo2onOLksmrGFlxjvnasYGegmqbJ3gjNfasm3QFYydh
	 jdArrKolRJ4eub1pVGxAI91QNCgTvCVj9uecxOPRG+a/AGDFaTZLYj6H4sSRPcEG6f+kn
	 XxpJoJDmabcFQMm2WCAxJRa40pZe/FceOcH5cIzQ2lnB6v76HDFchJP4B3hEMavm/wtkC
	 PNVsT9cuyNJgjf5BPcYwLy0VBj0mPMqfg7o/4TgCV7DuUggr3R1HHrSiGA99gdIQMag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dU0jjet5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD53E606A32A;
	Wed, 18 Nov 2026 23:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dU0jjet5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35A791F000C4;
	Wed, 18 Nov 2026 23:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043574;
	bh=Q3XzZfAnCRdp9hNkODUa8XK1saMbp37YdrvjY9HLW+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dU0jjet5zfDfL/+pOUbIlauR2uriXD/1mEe5ctqFMsSA8i1aSfUDH9+qA3Ya0+1w1
	 M9Ew1ZOuH+R0hGnM0IUHjWlwCUWayzv3Ry5u0TPeYK2TPM/DnhLgnKlWTc7kWNGttI
	 EiqMKq29NrOUDsELp0PMLkxhwCMHcXRmTvPp9+T8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0259/2857] ASoC: codec: max98926: fixup invert setup mask
Date: Wed, 18 Nov 2026 15:21:33 +0100
Message-ID: <20261118150210.758772663@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index bffd56e240e9a..019921c8de9b1 100644
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



