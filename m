Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773843;
	b=RmXaXSksMKqr8bEtfRuP7to6WZqEykLzDzrbp3uieLZyPu5RTce+2DdCM1Ist4ITlYJZ
	 GEL2JcqPgSMthq8Owah+BVm+8o9r71QI3fp9h5LqQJwZ8BVb3U/6EbPVjNz8E2vA2cUhp
	 MZf/Ih3WV3ImUVr3AT5go4ZDhFmdVja/PQSba0tL8KLpVqpgJxjZhkM1ywoGcvuKyeBHo
	 nBAx0u4jASf2GO/9auyhnyErxh2Z7PoSAqBT5d7DfvP9IrglpcblwjA1MKu66ZAcQs8Ys
	 ca1qPcs8hAQsOmC0tRnEfmEEVEdhiPA6Mft+9ziaIY/HVOk6c/rLiqUYj1zxHLui/qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773843;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nP6BX+kmm9/GuyfgdysoBdoFB7CoJnn/XiN63xRXvSE=;
	b=vfG9MXaAnffrYblgJtFIgkKP3GkNxDLNhYOxWgaoqIuN2ob55jo4FPhOebxWJsZRIsMM
	 m4+xElPVbtn9fT8M1uODcLdaWwC8b9l/5M/8gMmzWp1IOWvhgTCEtAjarvLKYXQW8yyEm
	 dgLIK9wzHNsH58U+5GCRa7EkM4MMYtYRMlk+AsxCrM7Bpg1pDVAgktrSHKdCWSz5VELdp
	 RSkA0SzgwCYCW0SgeXw7F2w/eyQmMHhpMjImFqgHRXXW3KfVmA6dpz2M59kuq1JJjyO3W
	 ViRRGiTXhJ6uFEWPPHta9Mq45pkDcvolq++EjIn40inus3BmSf71c15xsaAmOUIpdpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CGSVCXfQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B274606A32F;
	Fri, 23 Oct 2026 16:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CGSVCXfQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F7991F031E2;
	Fri, 23 Oct 2026 16:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773843;
	bh=nP6BX+kmm9/GuyfgdysoBdoFB7CoJnn/XiN63xRXvSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CGSVCXfQt8DYeW/RsTDIL7wTF4+i5oa+VqbfZgcjsQyCbmEivhdF+nh0RIUcQX2jh
	 H6RLJh2XG1J+atP6n0QDxyHaObgoJ11Tc610+GHhlLjeCtYwnAgOsOvt3Gvp7MSqAA
	 PkBzN2xqwXDyvKfUAnj5LpW8PxdRk9ud4KjnpZ5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 034/193] ASoC: pcm3168a: Fix the DAC zero flag polarity bit
Date: Fri, 23 Oct 2026 18:35:11 +0200
Message-ID: <20261023163715.009036651@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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
index 2066cf6c1e976..68d914148bf33 100644
--- a/sound/soc/codecs/pcm3168a.c
+++ b/sound/soc/codecs/pcm3168a.c
@@ -103,7 +103,7 @@ static SOC_ENUM_SINGLE_DECL(pcm3168a_dac_zf_func, PCM3168A_DAC_ATT_DEMP_ZF,
 static const char *const pcm3168a_pol[] = { "Active High", "Active Low" };
 
 static SOC_ENUM_SINGLE_DECL(pcm3168a_dac_zf_pol, PCM3168A_DAC_ATT_DEMP_ZF,
-		PCM3168A_DAC_ATSPDA_SHIFT, pcm3168a_pol);
+		PCM3168A_DAC_ZREV_SHIFT, pcm3168a_pol);
 
 static const char *const pcm3168a_con[] = { "Differential", "Single-Ended" };
 
-- 
2.53.0



