Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057649;
	b=u4fANOCCmwW2Dypv5r2PNFt1HprGRw18CEiueOcG4Es91yOZ6Cx3TP+HWQodwwubQtoS
	 Jr9+1+O/2tXOvhcvAVupTuuxLrjhZFfP3ZzC+aV7lW1iBokD3W9OsD5ayL930zztMeEyz
	 oLAFyryNQdWJbnLuLCMGdFMfBnwm6TFh2dXBwws9/kb5aBsDT1waGVZJgGWgOUEHU8QHF
	 YoOiFYt6rbqynKbOfD5pB1gLdaMjBS5FjcYLkj6+wEjI1+x8Qud2bK9HQSsUF4zhRV5/W
	 3a+c9zpVYk8oC1T4vTQ5IVAlyw4MWr7zrsfVkAHVBAVK9zMiNb5vWkqKjF5ZYvijq6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057649;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ocmmj4qfhZjxX+mGGB91TlmyG3dUkznI/d2iZblexcg=;
	b=HS4S9NxNci6cTmADtAmfOhfyX59aWQXdJUQdRHXGbgLZt6ofbTFAAt+asrFBzcEupq9g
	 jzuGNRCBi1yO+6YrYvF/K3GsZskAmTYbXQjoDNdl1p5cjKW8ygFFBWljqoc58vi/4sB8P
	 XXD8FD78cUxyZYgDTw/AaUXZQahXW2XhnYgoERVS4k5CgmZ+qeiJ5VQYlZ2hrnhU/vIii
	 VLwTZ3O+F3+7YFTp2IH4JJrS0VsRsKkrU2/qJg7RYzxETxcLa3/wpnuIm8AGLDrWd1ROU
	 aKvplHsNHsn2iw17kvWbI4BB1q3DnN7hb4fTBZDWfOLz2twpr/HwwcPTcedKmp1mugA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a72nGHlZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454A6606A33D;
	Thu, 19 Nov 2026 03:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a72nGHlZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A92A1F000C4;
	Thu, 19 Nov 2026 03:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057649;
	bh=Ocmmj4qfhZjxX+mGGB91TlmyG3dUkznI/d2iZblexcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a72nGHlZCON+Q+C8o7T6bOSo2tbYw6dJ0phUt/TwseXrlW3I+Oo3SqDR8Uyrt7NAo
	 DJOdnMGFdZaqas3Rk1x9kZ2Ywmusx9a5GvzQ6LP98n4ChFNHCQ4kF1SdZGq9VYhgKJ
	 YYpGJeCfiVAV35WKF7WrkrrMoNcNB1piQbO8RXHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0178/1848] ASoC: codec: max98926: fixup invert setup mask
Date: Wed, 18 Nov 2026 15:36:56 +0100
Message-ID: <20261118145918.972866062@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c4dfa8ab1d494..bd9fb0c69794c 100644
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



