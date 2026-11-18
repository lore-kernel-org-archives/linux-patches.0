Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056512;
	b=4ZoG/D8XnISM6HuBt7jl/79R3EcMbNjuVSPBsc91yHOcGHXho/i+Jhw12Fer4Mm2hlpY
	 9FE/JnLiJLDBPh4+LA1BLw0Un/AV5x4ZzQCwuTp6AxTX9teZrodv2yCkXfDFP9DPoWK6s
	 CrUQD7/5lUMBEaXI6xw7AhpPqowsqjFsKfnxcbdg/zJBiptJPwHyVQR+VXGkFNGhIZgQK
	 4z4hxfCxQ1rpMTgRlGqrPZFksKWsJj2rPIswuYXHW6nNqluk9i8A1l3N6m/uyn9hb5T6q
	 7hzbkz4DRl2gO9yjnJx7Ttog5DHy7hKOY+MmApAvjQkx4/Xnp0jgOa7Z/lC5FieOILA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056512;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gx6ej5OVF0EE2Gnw3IvT6wpBF6fJZuOYZ7m2bc+90xo=;
	b=YzoJ47g0GeRmRTQsmVgvUFOz/J7aQHTBA32Ac51NSZz0kO8uL7pgSSe27k0yE8DBtpNs
	 8HWUVHqgNMA+5x0E5cIpahTnfWLtJ2eqFGkHNRgKTAgeh75LlEB0f0VKUJvYTG5vLJVH+
	 MeU2hy8GctM5+W7P4qDOmuOpjs2m6Egr1Ob8FRO7qTpbXdfU+ps4YM9KXLrqHsyY7iM6U
	 Bqwz2XqCwUxwds7+8ivcSAJWP6A1q/0qw4KuGmKn+79IEk6vL7kr7RgSSvugiu1FEq3Ns
	 r6YGqGzBPc8UPCBOdAj69aTYhzEOs33xW5LiM0GpCQIK6kAJOh15Pspj/90o935gSqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NrXwy2w0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05A1606A33E;
	Thu, 19 Nov 2026 02:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NrXwy2w0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C7651F000C4;
	Thu, 19 Nov 2026 02:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056511;
	bh=Gx6ej5OVF0EE2Gnw3IvT6wpBF6fJZuOYZ7m2bc+90xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NrXwy2w0hCmeblsM9Gb+2riU7ovDpFD1CvckCWqwUF/MN5WPtlMO8xyqZqOCZ0fcl
	 0mQgMl94C+IIH6OAsMZVTdtK1Dp9/JQn3epFlVhmnckirs1/FD+V9qPii6Y8reB5yp
	 +PfeuRtZHOlucIYChQfQnbd2IW/DzWzDZVj+xg7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2014/2214] ASoC: codecs: da732x: Fix definition of ADC2 EQ Overall Volume control
Date: Wed, 18 Nov 2026 16:01:30 +0100
Message-ID: <20261118150131.298728605@linuxfoundation.org>
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
index 42d6a3fc3af51..549cf5bccbad1 100644
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



