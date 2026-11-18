Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027291;
	b=lYh7urTy0bGCCRTfAWTiBllOrxNTmqg+uDxxs6HJ7Pj8TJCYVjt9SwQ95DxouN37s8u6
	 s1eeTehZLFcJ2xxJSu6WL5zp9vk8EPLlU3nbcCZUlKCJKppvOPqdxnPMaZ/5Le/svK6Sx
	 dba+TdVD4FzZCqGhpe8ep/F9OitW71Uo9vwt/TppAEqQlmvub/P4PgGFG/ZFMcSCgaF2c
	 aISXDnjP4UlqorA+glCXLAPGqP1W4bKaL+jjxaJ4m7ziLgibYo/i0JyumlwHzMiZfZUek
	 Ngm1szLednKM7XRP3A5xwFyAwnJbrHpm2Ct1lgZFVHkOFVURdNUZ0zWRCWsdNZlk3kA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027291;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kxUcFq4xmLoYvrBUxlNI7A87u0wysrBNjqRJDb6K/Uo=;
	b=j4Lw9BMj7brMkBoApnAiocCRJo5LbWFU/mz97s6JaU9TMyunbKJxJ6IL/98ruc9GGvY0
	 wMsR0udzsU3ui3hzyR9fBDzkqHLNchT9wVJXoVqDMvaP9MMIkY1NciUtQ/FwWtqVzj4eZ
	 dGXOkXtbgKx/AFP0PZ+qebLvLIE6iUYTnY5Wy1vbahCsqYkrQnkK58CPsm5V2CYoUMYrC
	 Jc+ltSUKgj0cvFkmkM0i/St5jo/iTIZKBhUzfFW6CnU97swxaZ/BPyb5y2OP22JhUrqTo
	 aptDhZG0T1JdWdiY5nOxUB/bNNFwldKRZhDHohBRogLlORJE5UiAEleSYqXIRW71OWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HTzZlPjC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1377B606A320;
	Wed, 18 Nov 2026 18:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HTzZlPjC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11C131F000C4;
	Wed, 18 Nov 2026 18:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027290;
	bh=kxUcFq4xmLoYvrBUxlNI7A87u0wysrBNjqRJDb6K/Uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HTzZlPjCQj1sR5+wCsoaJQnZa8baiC721tXeSIAisGkVNOfmSGua8uFGEXcfBpxxa
	 dQqnWWc9D1cWhogQDlzIayNPUD9nih1ctKlolczsMJUquXh8z4TsgCCjbDPoh0KPgX
	 MdBZqwp+XoaBlv9SDV+ZMjCpbxpTJymzFxy6M9Ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1696/2151] ASoC: codecs: da732x: Fix definition of ADC2 EQ Overall Volume control
Date: Wed, 18 Nov 2026 15:57:11 +0100
Message-ID: <20261118150223.608893756@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 016c9be3ebdaa..04fe9ceb15db6 100644
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



