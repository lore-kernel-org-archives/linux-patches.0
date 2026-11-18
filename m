Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061937;
	b=Hcle90FDyml/X6lP0vxakLK5PSb7uT/yNh4JoCP2Xy2F0BmaMN+hVJqWKDAakGNyi5Ve
	 7z1oO2fZKDSEMObs1wnmYNiaTdKb/Rk4dpzIFa9x8Ldk3QbUjbU2W41MoenbrL5FXff8z
	 kYQauK1cXEzCPGnc9plHrXbmCo2t0QhctaFhUNVZEyec0OlORMfoAnYfNO79P14KnDls9
	 8ryE+ZWXRMxid7rgJQ2jPzxGMzUxW7fJb9/U9whPNtuAgyrKAgoIW8Oo6Q8nyeKH8sI/7
	 T/ak6qCiVXq+S75leNMJC5M8ziHenmIj4FKkhzQQ5/xrUqYPGbTnv3Wuns9Ru3+9bMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061937;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bjDb/MSwFba3M1CpGAIAG3glewQlezN39L9EJ5KcVFk=;
	b=gXyoOmqTJ5MvmLgLK19beY9txq3nwDrocQY0XjqSaqpk8gP8dIK/Of7Jcn88fuN+8nD+
	 ia5NEeN/8dql7rDfKkp984n+a1qi94IJGT+9hGw9Rp7gBvcvnZv9qsevu+kRcjzX7g3+q
	 A1TG5sUMWGoffKyrZCHjRaGBPZZ61szpE+Ew5Ptv09hR6xc5xbzwfP5/KE9Jrc0EpzDTT
	 CKOnQklRZSXmkSZWSkTxfrpCsjvzBQPwiDuAiiydte/dCRBZ8IUKr1qZvawV+YSwlB/Lx
	 aa3gwbt9EAsFtfyr1OMe6MIPLDHT/5SY+iio1nXfPEiCocKO5kbaOPpTutXyjUbt5cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AH2F0Ofi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8CF8606A320;
	Thu, 19 Nov 2026 04:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AH2F0Ofi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 457131F000C4;
	Thu, 19 Nov 2026 04:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061936;
	bh=bjDb/MSwFba3M1CpGAIAG3glewQlezN39L9EJ5KcVFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AH2F0OfiPR2QF09AAxM6YFsmLvViH5NxCI5xrApArCxRR6wl87gMGjKXDBy4rsubT
	 UOKnhSEtfCvZocYmW5zoY15g7x0JJcDzBNL0v8xjhBocDH0UucMVBeOYfNyVP125Hn
	 nVASgn5qnhNoSDUjqB7gqWlUZF8bF2qVUAWsBA+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1690/1848] ASoC: codecs: da732x: Fix definition of ADC2 EQ Overall Volume control
Date: Wed, 18 Nov 2026 16:02:08 +0100
Message-ID: <20261118150030.528839856@linuxfoundation.org>
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
index d43ee7159ae0e..e864899ba9467 100644
--- a/sound/soc/codecs/da732x.c
+++ b/sound/soc/codecs/da732x.c
@@ -516,7 +516,7 @@ static const struct snd_kcontrol_new da732x_snd_controls[] = {
 	SOC_SINGLE_TLV("ACD2 EQ Band 5 Volume", DA732X_REG_ADC2_EQ5,
 		       DA732X_EQ_BAND5_SHIFT, DA732X_EQ_VOL_VAL_MAX,
 		       DA732X_INVERT, eq_band_pga_tlv),
-	SOC_SINGLE_TLV("ADC2 EQ Overall Volume", DA732X_REG_ADC1_EQ5,
+	SOC_SINGLE_TLV("ADC2 EQ Overall Volume", DA732X_REG_ADC2_EQ5,
 		       DA732X_EQ_OVERALL_SHIFT, DA732X_EQ_OVERALL_VOL_VAL_MAX,
 		       DA732X_INVERT, eq_overall_tlv),
 
-- 
2.53.0



