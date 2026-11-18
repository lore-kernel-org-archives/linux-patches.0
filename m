Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034253;
	b=XD5JX7Ur/lDcWzAM4SffSKHbqxKp+SBRbf2uUEfOQrjJrT6F29DGow4D0jAW9Y1okKn1
	 tljxysL2mGnbovztDewQ9AnjegTTPybAci61DfvNOBHquvIX/nGvTSwhUpKar0quoxlsH
	 WUnIjYbQw4EwVuK2biLbIuffIJ+wz3WT8U5sMscsnAQBbbDOL0S+XaHpDgiVhvF2ODsBQ
	 sUw8KkXI3V3yQbxvzKOjlpiB0fzW4BAAIi7nATl/1gTIhtLwQy8FLrDBcRMU2QjrlGFqf
	 RO7lV8J/xHbBTGZHMqccGR/tbf/ERZJZqDX4NJJdnsr5QbLwCx+/Dxq1965ZWgckRkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034253;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e3UU5yUjfEKcwapCEWB84YtnPh6enruU4Yzv1uZy7Dc=;
	b=wmwNVztnNGMW0P8aHx55WhPqY6t1Sc/8tYINlcY6eFVL1hNiPHIYT+/HNbgz8/u7BHiJ
	 8OXLPQfkS0EBPm6dd9ptGS0spilsvNfFB10PVzi+6CgGptOikx9aXeM0A0e8TeZfmlyFX
	 7c09/17GJAhL+BfewGpWmvPgt0kYlO1CuEMH358xGh1vQlxJnUaR/d1hICsthSZcHwQxc
	 gUiL9lmT7Yg+nrP64uk41xPcGw5USmtwkw/X8sHG5ixjvRS+j23RuobXWuVrXuj9NAWmR
	 GbwRtbx+JJTkqV/EAbjQcPAd5UPvVsJf/E1S2bf7IYgkDKx5TXX0MbSEHt0VB5Oy1Hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QR0H2b7r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34D8606A325;
	Wed, 18 Nov 2026 20:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QR0H2b7r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08D81F000C4;
	Wed, 18 Nov 2026 20:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034253;
	bh=e3UU5yUjfEKcwapCEWB84YtnPh6enruU4Yzv1uZy7Dc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QR0H2b7r3Z3QNCkPOtrZN8CWVOugoaHekuEvbpNl41RmSKJdPfVK8XTuSmllo7zCv
	 QKUN7nZx8jxlY/4ytW+RF36F0IbrR7v7T790Ng9c6k06accaqNHnhi5wqeLWD6lZz3
	 vVjO/5p+sM7FCfLy6nhNlODjw7HcaE2NcKI+ODdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0304/3318] ASoC: codec: max98926: fixup invert setup mask
Date: Wed, 18 Nov 2026 15:15:26 +0100
Message-ID: <20261118150324.871342520@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 922ce0dc4e609..d034e8d31be09 100644
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



