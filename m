Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049771;
	b=FbCswcvbgT/AwbtVG7l/LPcIIFwJnZ4GjUqdHvqWLg3QO5LsYhIOdovKYNPtPNWiEXPt
	 asUA9mZSOkuKhKJtUusH7HRtX26njximHMrPHRxpqiz9EZ7kqP/Apu1YuyWLOw8GEgz7i
	 j8hVlE0RVXseBQux4ng7PQhZCWJ7eFRW55HEbhQoCXj0m7EEUShlTTbQHQQVECS6KF11i
	 +pJyZJP6D67tuRHn1HO5usalzCIu9MtZi1f0ghtLp++hLwAAUzOr+92yALMY2KVCvt+SL
	 90HheMCXAovCZIId7NC/IbZosORaTap0S3PPPp0i7PCS2RPnAtrM4SortslvMGaZg6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049771;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AMxkbFoq/wgLj+LXccPhvPTdb66utI/FVPatke5p5UI=;
	b=I/juRHcXnqcpu998ZcXqLtU7+TKC5HEnM79wvL6qNGPs5z5T6d4eNlBMWod84oC4LqTk
	 rWHMoVqxp8GrtW09HwM+5WvOC+rbZiYSt5pH/imdCXW/16qLD8BOgdctBsHJ4n+JqU5uy
	 TmbXjx85pL+7uiqCAKrSoQsalnhxHJxR6i6Oj71tkfwthXQA5or58m7/ZWXhQCuTKP9Ar
	 o3pXMQbwfzuJe7uEGq/VSW7rtY6BeW/DDAZitjJ1kq0qp08qT5RXK2CaohpkT8rzCJXpA
	 WZwaCTkzJtmxa57cV3ovxhGFDeyp7TOzTWYv12V3gOTGabz8lsTnT94xtl/l2zBnGjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NSCZdxj6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE01606A325;
	Thu, 19 Nov 2026 00:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NSCZdxj6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A2A01F000C4;
	Thu, 19 Nov 2026 00:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049770;
	bh=AMxkbFoq/wgLj+LXccPhvPTdb66utI/FVPatke5p5UI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NSCZdxj6eJvE8QHjJMPtz+gz1Ik91DqcbXamc5z5xRPB+LfOMZocGK+6cPKS9n75i
	 t52endowcCd3swyNBgTPTxqNYntSl69L3Cw68vVqGwDy8k305HIA5+qVjGsNZTK27K
	 R2nTbYmU46lLWECF4YJWA+egiwGJBIdRqeVr7FDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2470/2857] ASoC: codecs: wm8991: Fix definition of LOMIX AINLMUX Bypass Volume control
Date: Wed, 18 Nov 2026 15:58:24 +0100
Message-ID: <20261118150330.499846106@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit fee722db39c2a1f18c944f747271fd1e131910a6 ]

The LOMIX AINLMUX bypass volume (LLBLOVOL) is at bits 2:0 of Output
Mixer5, not at bits 5:3, which hold the AINRMUX bypass volume
(LRBLOVOL).

Fixes: 203db220718c ("ASoC: WM8991: Add initial WM8991 driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/c6e230b0e7d7e3db2136cc751e0b563030dbc16d.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8991.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8991.c b/sound/soc/codecs/wm8991.c
index 72079b73f044a..f7bdd1a26a81f 100644
--- a/sound/soc/codecs/wm8991.c
+++ b/sound/soc/codecs/wm8991.c
@@ -184,7 +184,7 @@ static const struct snd_kcontrol_new wm8991_snd_controls[] = {
 	SOC_SINGLE_TLV("LOMIX AINRMUX Bypass Volume", WM8991_OUTPUT_MIXER5,
 		WM8991_LRBLOVOL_SHIFT, WM8991_LRBLOVOL_MASK, 1, out_mix_tlv),
 	SOC_SINGLE_TLV("LOMIX AINLMUX Bypass Volume", WM8991_OUTPUT_MIXER5,
-		WM8991_LRBLOVOL_SHIFT, WM8991_LRBLOVOL_MASK, 1, out_mix_tlv),
+		WM8991_LLBLOVOL_SHIFT, WM8991_LLBLOVOL_MASK, 1, out_mix_tlv),
 
 	/* ROMIX */
 	SOC_SINGLE_TLV("ROMIX RIN3 Bypass Volume", WM8991_OUTPUT_MIXER4,
-- 
2.53.0



