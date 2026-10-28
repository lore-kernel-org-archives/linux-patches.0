Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209324;
	b=Rvz8ehdpouRV0RwbUiLBEZofW//IwlhNDzBv/CmHA0sC6I3zx6sAX8Mm1V2yM4qAE++S
	 Af8yuxqjrYEfD5/4/BjQgH9HZ8j+EjvBakikBXsQGLoAtk5705DPoy4nqd3z0nSIbxGTB
	 52yycJWHbeBLNHS5qntrfpa7XIwDS+a95GzsjOvedoWjp9WFXPay1uNQTekFrNOTD0yNx
	 9epF9mYacTUYRNXXgVgmuc625w9C6dS3am1n3WJVXlTOdOHc4lg+VLyID0iLVrknOkhf9
	 aUXfaPy+0FStvOkPdek1L1sw3FXZtI/yvRSTVVK2IOOa5zBVAOo9xBEAsDKZchyqg6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209324;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uFA7Jrv3AvUUVZf3wYQoSoH0kLZcNiy6rpBM7pfDvHc=;
	b=guP8e00v4p1Kg5UmMs23KZRjveAQaX1JjGghi1jIMnBJXdCIl9WJoWDheKSn7qONYbQK
	 6mstaimR/N2veRMHF1zKBF0lFG9m66ply20qFoYkv5xTExnCx8/9sk8mjK+RiQW5tGI3h
	 Rxo9+ITFUD0okgk9BPopTb83Mcct+fAqrUyb8DZGnYoNwEbMrCVwJGsTLA7LWWQEqs6BL
	 TmRqcSpZuzFlNj2GqtwRGKhvSZ2mexIPyytr28KXO0eckIlw7bEkheDl258BzeE2U0m7w
	 u+qFuc1wHpCEM6vPg1kGT+Tku7M3A/506mZ+Owvk0fMmEqMO7anO5UBi2VSpamI+84w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2NiBwtmg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB06606A31C;
	Wed, 28 Oct 2026 17:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2NiBwtmg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C571F01825;
	Wed, 28 Oct 2026 17:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209324;
	bh=uFA7Jrv3AvUUVZf3wYQoSoH0kLZcNiy6rpBM7pfDvHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2NiBwtmglCjyphJyvQjPNMRtb5Ej/qcuaHumFOSsCOUv3OjPlPOukRodIxRfdXRMo
	 oM0TsVlEXU9bdBhsiYKrTgG4H6OmKOiuGqRYn9Oa44nnpsf9jYsoyN0ZjXrd5PaNe6
	 yCz1fSm6WotV1bdk7lvXWJIy4kibxOJqRU529Yms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 432/516] ASoC: pcm3168a: Fix the DAC zero flag polarity bit
Date: Wed, 28 Oct 2026 17:59:44 +0100
Message-ID: <20261028170013.720009543@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

[ Upstream commit b26edc925c1cfa0184cd270ed81d4833db045ce0 ]

The DAC Zero Flag Polarity enum uses PCM3168A_DAC_ATSPDA_SHIFT, which
is bit 6 of register 70. That bit is ATSPDA, the attenuation speed,
which the DAC Volume Rate Multiplier enum already owns. The datasheet
puts ZREV, the zero flag polarity, at bit 0. The header defines
PCM3168A_DAC_ZREV_SHIFT for it, but nothing uses it.

So changing the zero flag polarity changes the attenuation speed, and
ZREV cannot be set.

Use PCM3168A_DAC_ZREV_SHIFT.

Fixes: a9b17a638af5 ("ASoC: pcm3168a: Add driver for pcm3168a codec")
Link: https://www.ti.com/lit/ds/symlink/pcm3168a.pdf
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20261008130953.2446692-4-sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/pcm3168a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/pcm3168a.c b/sound/soc/codecs/pcm3168a.c
index 1056a38992cf1..53e076dcc2122 100644
--- a/sound/soc/codecs/pcm3168a.c
+++ b/sound/soc/codecs/pcm3168a.c
@@ -106,7 +106,7 @@ static SOC_ENUM_SINGLE_DECL(pcm3168a_dac_zf_func, PCM3168A_DAC_ATT_DEMP_ZF,
 static const char *const pcm3168a_pol[] = { "Active High", "Active Low" };
 
 static SOC_ENUM_SINGLE_DECL(pcm3168a_dac_zf_pol, PCM3168A_DAC_ATT_DEMP_ZF,
-		PCM3168A_DAC_ATSPDA_SHIFT, pcm3168a_pol);
+		PCM3168A_DAC_ZREV_SHIFT, pcm3168a_pol);
 
 static const char *const pcm3168a_con[] = { "Differential", "Single-Ended" };
 
-- 
2.53.0



