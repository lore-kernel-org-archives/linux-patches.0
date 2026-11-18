Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032260;
	b=X4DwXxLvaKMxPFuP0ROfHdxg+Iu+uUVRPkfbkjBPLWFO9XA15JggP885pD+N2se3zT7s
	 bfnbJH8ICeRHqhvwVMKAzJR/m5vY0Sm6nKZaXy9M1V0wbyr/rCWt8txSmv8FD6Wf1523I
	 pHooFG3BksRHIUkcraOoi7gSNnOx5hToVvg/3twovzpNw4YL0rYDOrOzsSTq3I+Q2MP86
	 9nUWbpCGmfSZEw7rBlyf0gHGJd4d3uxOu9QYiF6CE7NDy3hC2GIiyTnQaR+m3ap9qTwxC
	 fLSBzstd6fnbVRP7Prie8rT4P6AGN7qGnSwCPZMEls40vuech61lwM6ypjrGncOdcow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032260;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bKs7BFRjh6lq1h5dO3kTkK32X9c1z+pcaCLdvZ9QpAM=;
	b=EVOZ7rGNo5+wbS9i+Nf6C2ahVJOhAIJeh2zAgem3ag8gnwjYvjcOcgvC+cPlHoWMX8qw
	 eKKQxHwYGDTj1qYOTzlgJrsba+S+39dtwcuXbAdLUlXoafXJndlIxhI45Ml5TVsjbI5cc
	 RdG2Gk2ZcuoYC6XlFqKz0CDmsdclr/6xaXLQeO3ZdlbSQxNQgMeAXr42hQIETzKY60aby
	 50RGvxRxp0WjDwvOHP1f9KTMBoM+X3JkNOESM+ZL56yp1yqBDwh0k+7BTaql+hEGZET4W
	 vBD/4YkeaUqFXWXSANIvyd6kVH/eAenQ4MWjaofIxauqj0sdOShRzuyXhpZV+zBRkJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fYQHT0at;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E89606A31C;
	Wed, 18 Nov 2026 20:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fYQHT0at
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33CCC1F000C4;
	Wed, 18 Nov 2026 20:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032260;
	bh=bKs7BFRjh6lq1h5dO3kTkK32X9c1z+pcaCLdvZ9QpAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fYQHT0atnwpokgZ0uDiwjezmOezBoEF7XIW4LOa1A3yd0G+M3XanWv0nGf0sQffgN
	 kdUP1yf3zro/vdjM8wAB4536x4roS6lNidpyXzU/c7j3aE80e0SHBx5aYvBaJNU8Cg
	 z+XeYB+hniZeyElGCIXf9VwFvnBXagUPCEIITkLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1349/1756] ASoC: codecs: da732x: Fix definition of ADC2 EQ Overall Volume control
Date: Wed, 18 Nov 2026 15:57:56 +0100
Message-ID: <20261118150103.027167894@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit ebef9212cb469706e28002a20f9d48307d1fd867 ]

The ADC2 EQ overall volume is in DA732X_REG_ADC2_EQ5 (0x9F), not in
DA732X_REG_ADC1_EQ5 (0x97), which holds the ADC1 one.

Fixes: 48e278746070 ("ASoC: codecs: Add DA732x codec driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/35bae3f84cdc3ceb6ca412153f44dee3647fdbd6.1792135144.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/da732x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/da732x.c b/sound/soc/codecs/da732x.c
index b747f6fa12e4b..d622f3612bfe2 100644
--- a/sound/soc/codecs/da732x.c
+++ b/sound/soc/codecs/da732x.c
@@ -511,7 +511,7 @@ static const struct snd_kcontrol_new da732x_snd_controls[] = {
 	SOC_SINGLE_TLV("ACD2 EQ Band 5 Volume", DA732X_REG_ADC2_EQ5,
 		       DA732X_EQ_BAND5_SHIFT, DA732X_EQ_VOL_VAL_MAX,
 		       DA732X_INVERT, eq_band_pga_tlv),
-	SOC_SINGLE_TLV("ADC2 EQ Overall Volume", DA732X_REG_ADC1_EQ5,
+	SOC_SINGLE_TLV("ADC2 EQ Overall Volume", DA732X_REG_ADC2_EQ5,
 		       DA732X_EQ_OVERALL_SHIFT, DA732X_EQ_OVERALL_VOL_VAL_MAX,
 		       DA732X_INVERT, eq_overall_tlv),
 
-- 
2.53.0



