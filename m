Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051469;
	b=ZlrgMxDncW8IE+5ElofV70YTpsHg21Zn/2WaPZ6p+0r8ZQiIx+PJnlyegTU4vplv6N6z
	 6jzTYXO2BQ4X1GSCdyBBzjIdhrSYnyHKiqP6jhCFtuYimm8nAViC73/xCIzC6fpJMDbEv
	 WK5WBM/rqKVH+UWqWcj5UK28aYEeAFslh8qTXTl4jvYE7mDS9NhRFWBMpUPgUOqCbjpOK
	 10bdmvLga0T7hs4/X3QR9FqobOelo9DhvON9rrCcm8qRs43juFQDCyFgvtg9Q6AZFFWcG
	 QU5di2w2no1nvjaHq6FwHIaTSJKS2lDl2ki+Z6mZ65XRigkVzbjyaUJPqJ91bOtVt2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051469;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IiN072ePfKNrm545XVgI/yre+b8mice3n+hmIBc/iiY=;
	b=PxyGZXCQtSXqU30ekjJXj3OmfbzvQ3615u+lHi7hSpyqOX2YGyRUsNuDyzBJiwemvUDO
	 tZ12d5i206+JE8iHgvZr/irVFmbIi6jXZix6kwj+oXYGhblAyM8xEX9TayX1PkQ+Vp7u3
	 U9bvi1Cci/We/4bahVI+rT4ST4j+RGhOajlc1CtiHLsG3NT6tAqvdPS+b3eFs343i8Sil
	 /DjoDXvW70I9WIQZXOyqgvvFx+J0+NPZyyx1pzaOh2m57RzLEAOcWN+yG9xx53oE5L6kS
	 8i0L3U9UQHadbkiqyzaEg2RTH2GQdDPQk9m4fNly0i/rZ8icrsStCLmuiFPoU2IPXiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kWSDfqKZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A14606A31C;
	Thu, 19 Nov 2026 01:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kWSDfqKZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A60C1F000C7;
	Thu, 19 Nov 2026 01:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051469;
	bh=IiN072ePfKNrm545XVgI/yre+b8mice3n+hmIBc/iiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kWSDfqKZ9eHZPsOvO/TdbsRLWOwa88Q3ZeQVr90L2CUbYVej/xzRVLw/nNoUCW+j3
	 awim//oeDwdr8HGhQX009Zroyt41A8U8BZUd0fmnlyF/txMaME7xzxTYey2aZdhned
	 69TNAYKWQb+wBKh8z2m9XJNqYmU/RUKmTwD8vfK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0220/2214] ASoC: codec: max98926: fixup invert setup mask
Date: Wed, 18 Nov 2026 15:31:36 +0100
Message-ID: <20261118150018.970887593@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f286e572263eb..5b0bea1b64110 100644
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



