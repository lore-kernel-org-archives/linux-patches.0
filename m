Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027945;
	b=iUUQToOIHCE+Y6MwMQJiebYSDIzpQsxvndAxd12z+nhnjnifUaGYx34UwxNIZ77+9ISK
	 uf9hkMXvmarAe27VnRp7dCRHaVVP1NNjN3flTeyAGhx+vFNSH744IMP2m6J10SGjYaEq5
	 5iNyriRz5E/wdiChMO2FSEw/XQVp2q6+J7zmVshC7A/bb9bGo18XCYXAcczC5Zyif97rh
	 UnfbnE/IkGSg+oZ9dURoahSDh5PYDp7s2cM2PZLtSAE9MaGb1xpW1ohhlA7tc25cmCJDK
	 IgOBobZ/cpeVp3Ao+xlMaZ6tbcpRmIZe2qnkZmu6oRbccitWeWCGi4wXiJebOhXQJ7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027945;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d1TAYRufAD+PRUxT8M9D1SInhNl/66JALEf4JN29umQ=;
	b=gNq6LpgE3qRfj46GS249JHgMlgGJgkY2QnJrWdm3LYzoC4UzIOyWH9/fU5cRhJ0CuQfT
	 LnnbnvDCwrHfohxl78GZeSCKdbHw5+wWNWarrJ223I+2+MN91YJrT20yS5cF4cdZqZkX7
	 Cyv3j/m1PP9sSGt+PxJp+TlGNTvkyR6TngRG8F9L+yeHxLfIiCQz4bPaKvFV80WZm7kVJ
	 gvfDSKPFc2V+19IOYz50VnUjrYzxtnyySpL/IU/0o8D/DjPWD60b3PpjnzwGPva3UCJEw
	 AElwFCWOgKzTD2oRvNA7DLJg+0n+H7uAEJ1IJXHIW259WhyDqsvBmZtUodu47UVNlug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QF4b5InQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11901606A31C;
	Wed, 18 Nov 2026 18:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QF4b5InQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 632841F000C4;
	Wed, 18 Nov 2026 18:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027944;
	bh=d1TAYRufAD+PRUxT8M9D1SInhNl/66JALEf4JN29umQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QF4b5InQ52TjEH7QkpPTkCBEjgYKYo0LVh/iuuHs8Nd4fskYL/y3pbVBLBUm0b/Of
	 e6zKL/37FtC1SRfAtDB8Ybq0/lbEMGYEnRRNt4F1u2ji8ovalLyA3W0HLrSSTPu5EO
	 36TJRAGOz8Dp9xkk8RObzYufOLB1oHKeJ/jUQ2r0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Zhang Yi <zhangyi@everest-semi.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1970/2151] ASoC: codecs: es*: Modify the registers related to ALC RECOVERY
Date: Wed, 18 Nov 2026 16:01:45 +0100
Message-ID: <20261118150233.509523339@linuxfoundation.org>
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
index 9d4cbccf7e298..f7863d3726fae 100644
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



