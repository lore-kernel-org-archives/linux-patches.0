Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032920;
	b=MxPx425Rme4fHuzW3LHuBGlTbeSGN97Ufv8CLGxRvYOmQljqawVlrs6tzWBQtrYdp1wn
	 rLh4DvLQ2LtGLReqW2eq5rqaEXjmajr0DHR7jOiUGi3jm4q9ojK/f+B0HV4zig1I8rtdp
	 hH793MrFFXFp79Qj0TYrT3KNF+oyk8LTGRZyDhIM7p8hvOAhIVYKSly/Fa1w0ekqj0MLo
	 XpDDIMwy5X1okI1fuUyV7L6QPaBBZYvrCP8UNAbebGFm6gyOk6+WMzFecKQpbjxqIrEH/
	 f3zAE5fNBgtLFfrcG4pU7EZsV9k1aO9DXCytO4NLyHKZR6PUPS25SPpI0ECV5pvITBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032920;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VUcO129m+ctChe/AQQKtUg/lTqNrXqWi34q/vo/SG6I=;
	b=Qz6RP1ogS5YT6sPfrk+ODOfQ9ZPj6eMAGCOAIGd6XsVx/aft7txLnmNakdjpDeQs4D6C
	 25VfRVwGQJjAA8C+/tdmTzWoEoWTHu1zh152LJZn9P0TzUQyF94CRoULkzmld3ZWqwqco
	 xVnyIHmQpE4Qzv9pjc5W4KZVW+vlmbwB9DR0Vfz7IgCrwx7DzYxsBRMXDyLi5doDJGi5/
	 496R9EuDDeII0tX7UJ8J8FNmIHjgUTNOP3V21EwnKOBmCPURIf9AK0HFFTvu6tBUpjQo/
	 boxCn4lWrlrN/n8dKyh5lphguDcB81nF+EAZORlwerlrUfWSrglkZGbX6nE2Nie1GXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LlgjxYyj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37CB60A2601;
	Wed, 18 Nov 2026 20:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LlgjxYyj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C80B71F000C4;
	Wed, 18 Nov 2026 20:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032920;
	bh=VUcO129m+ctChe/AQQKtUg/lTqNrXqWi34q/vo/SG6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LlgjxYyjnQeLYcDcdVu/U2ld2BmLSPuSpCZ5xigVTehAT0V6KhQKJKXB9eNpflCcs
	 jIw8K2sVw9k/8ZVNAceyVHIMczo2hgPbhLA5qxp8xv0dhXgnmwEu8fIVbUXXrUBTaE
	 uPNUTQsMhdf0GV5NFuIX+YnhkbNAxTSDgmE6xB0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Zhang Yi <zhangyi@everest-semi.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1583/1756] ASoC: codecs: es*: Modify the registers related to ALC RECOVERY
Date: Wed, 18 Nov 2026 16:01:50 +0100
Message-ID: <20261118150112.856755817@linuxfoundation.org>
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

From: Zhang Yi <zhangyi@everest-semi.com>

[ Upstream commit dd64271fe1b935252cf454a72a558cbdb7be57c5 ]

The register related to "ALC Capture Recovery Level" is ES8326_ALC_RECOVERY,
not ES8326_ALC_LEVEL.

Fixes: 5c439937775d ("ASoC: codecs: add support for ES8326")
Reviewed-by: HyeongJun An <sammiee5311@gmail.com>
Signed-off-by: Zhang Yi <zhangyi@everest-semi.com>
Link: https://patch.msgid.link/20261026054837.13618-2-zhangyi@everest-semi.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8326.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/es8326.c b/sound/soc/codecs/es8326.c
index caaacde8b59e3..ea65f32e22698 100644
--- a/sound/soc/codecs/es8326.c
+++ b/sound/soc/codecs/es8326.c
@@ -247,7 +247,7 @@ static const struct snd_kcontrol_new es8326_snd_controls[] = {
 	SOC_SINGLE_TLV("ADC PGA Gain Volume", ES8326_PGAGAIN, 0, 10, 0, adc_analog_pga_tlv),
 	SOC_SINGLE_TLV("ADC Ramp Rate", ES8326_ADC_RAMPRATE, 0, 0x0f, 0, softramp_rate),
 	SOC_SINGLE("ALC Capture Switch", ES8326_ALC_RECOVERY, 3, 1, 0),
-	SOC_SINGLE_TLV("ALC Capture Recovery Level", ES8326_ALC_LEVEL,
+	SOC_SINGLE_TLV("ALC Capture Recovery Level", ES8326_ALC_RECOVERY,
 			0, 4, 0, drc_recovery_tlv),
 	SOC_ENUM("ALC Capture Winsize", alc_winsize),
 	SOC_SINGLE_TLV("ALC Capture Target Level", ES8326_ALC_LEVEL,
-- 
2.53.0



