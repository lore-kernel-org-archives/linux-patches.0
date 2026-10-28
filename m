Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211724;
	b=y9ZRLUt2oSOOkq4ToYLrIFzR7I6KNXf7sajIwI2YZx1KUCZwjAjTxLn33nOt1B9Qp2T3
	 DMxr42+9GOcTLyoVeulwy9W9OIMTkDu/ppWtxL2dgjMamsixk/ajoU4cjC9Re+gwk1xsI
	 652mCoMhbaK48dK77pwSA40cm6lhkN0qnvwIGHDRqznP121EVjVD1xXF1+QLGkc9nyuL6
	 fO4GTXx+kTNmVw0lIVsuPRirEs5XoFKfJybxNDRYwztrI8rOnIPYopV63soFlkvy0DWG5
	 iBU4cL2VfE9aI7oxPErV9W2Ym6sgYya77lgt2CDOom7KuB87sl5K7CdekMrr8ShmCeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211724;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PD2e3P9OplYRH3NsqXMOoKXvewNeqZ98p9aBOHL6f1Q=;
	b=VEX9RY8hc1UVd5fl1UiK+y/GYAdiqfXzV2Lt+fCgEBgGEJ5Uv3ZfmueWHRc022Brqass
	 b/M/KPX3/1/zwBZRrBtAyaYdLUbEDjfan+h3aQ6tDreHEobl8V1bNyorAJwgleIc9zRZJ
	 UOjOU2B5C594Q10nmKi1hPRsQpWFng68IAwh74GlGh+LrVdsxdTHgRE9sAePpXww21Coc
	 u1HJuAQKjLc6SwmeanPoxN8+TozCFHzG0a3WxEeC1ZoaEjmKwu13EZfVoQHTVyuGz69n6
	 on77low4BdU4sZMY2hjzyOwthlWTQjs0Gi/X/1Jnos72TBQEpPUOPH9e3KKTYiV6IJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1Aoa+GSa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3F260A261C;
	Wed, 28 Oct 2026 18:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1Aoa+GSa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F4591F01825;
	Wed, 28 Oct 2026 18:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211723;
	bh=PD2e3P9OplYRH3NsqXMOoKXvewNeqZ98p9aBOHL6f1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Aoa+GSaczgQFfQor6h/iczy2k2Ho638xAYgl/Cg7esBtmSmutWMeXk/6QwoZ2kqo
	 yn5LTonsjI00QDhqPhhfysRTWK5DZFme2UItXVymp1j63qLbAzYECyAr2WtwGV55hi
	 ZcEhlpa5S67nfxY3fJInGE0Cw1k+gsyI84hMl+nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 479/571] ASoC: nau8822: Fix the 128x oversampling switch bits
Date: Wed, 28 Oct 2026 18:00:26 +0100
Message-ID: <20261028170019.388954280@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 4db45fc1da3d62d0fa6e8f1e457ae92e8741ed07 ]

The DAC and ADC 128x Oversampling Switches use bit 5 of R10 and R14.
The NAU8822 datasheet register map puts DACOS and ADCOS at bit 3 of
those registers.

In R14, bit 5 is inside HPF[6:4], which the High Pass Cut Off control
owns. So turning on ADC oversampling changes the high pass cut-off, and
the oversampling bit cannot be set. In R10, bit 5 is reserved, so the
DAC switch has no effect.

Use bit 3 for both.

Fixes: 1e3cb6c321be ("ASoC: nau8822: new codec driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20261008130953.2446692-7-sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/nau8822.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/nau8822.c b/sound/soc/codecs/nau8822.c
index 6ffd0f5e3a609..7273e01847689 100644
--- a/sound/soc/codecs/nau8822.c
+++ b/sound/soc/codecs/nau8822.c
@@ -379,9 +379,9 @@ static const struct snd_kcontrol_new nau8822_snd_controls[] = {
 		NAU8822_REG_RIGHT_ADC_BOOST_CONTROL, 0, 7, 0, boost_tlv),
 
 	SOC_SINGLE("DAC 128x Oversampling Switch",
-		NAU8822_REG_DAC_CONTROL, 5, 1, 0),
+		NAU8822_REG_DAC_CONTROL, 3, 1, 0),
 	SOC_SINGLE("ADC 128x Oversampling Switch",
-		NAU8822_REG_ADC_CONTROL, 5, 1, 0),
+		NAU8822_REG_ADC_CONTROL, 3, 1, 0),
 };
 
 /* LMAIN and RMAIN Mixer */
-- 
2.53.0



