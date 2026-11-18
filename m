Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023162;
	b=rZ3OTT9MxnSabkTG8dzkEr+/0MyAafsqOJZtwi71f6Y/D52wOdEhWv7KXLAVxQ1jUwG2
	 R/4nbARotemZ7zpai+cAcXiN94nSLm9neS3gvu3VP6vG/Rvlmhwy7Gln5bvaEeupajhBP
	 9kMPhDj3vTLhBcijxqzONRLjWU/JSC9/CcmvPT1pidAOOHo+GkAHl4KxMXVMioR3KKbJv
	 UDxGDf7lJrsqygChr7+B9jcb1bjlAqi6Tu5nlQ9w0kyrsFdFvvpRHwx1N2T262f8Je/oe
	 SkNLVwRK8d3RLWkH+pw8ThNhFP0ysxvlm4udoJqoBcbK97JO47CmdT93n7ECbDPHDhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023162;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=87mYkPqHi9+KHlu8/G+e2ELUDdrGw3bszKC9VzviN1E=;
	b=AY/0WuzHj3iBYHlKy16QNL3pzfW6vF2/BL60H/0tpVyk5S8hI9AB4iPHxCrIhMItePCM
	 Jmzc9ZQevWRgKLtKkzU6SiL2U6wJTvcE0+PBemcfWXsgRSphytA5DWoYXfHBLq+dWpzsZ
	 Psmeoe6RGAQh+YqqbXTd1q9X9j+taUXphZVMqn8mzdVJZSBpceV7CliPObeBwvnPzbLHq
	 SHuKWptM+AYT7EhxfVTYBQCYyiMRDaMddaCTo2jpRSmQPuiOfSAOx/YrW5KeEVsbo1pZo
	 axYU7xY/VPmy1gEuH4NQRySb6kRXQHeZdb1pYDPBjt9f9QH6wnX7b3ChjQSENOT3c0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DvG5m8tu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EAD606A337;
	Wed, 18 Nov 2026 17:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DvG5m8tu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 803351F000C4;
	Wed, 18 Nov 2026 17:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023162;
	bh=87mYkPqHi9+KHlu8/G+e2ELUDdrGw3bszKC9VzviN1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DvG5m8tuQ0lEzUQb+KHI0yITxrJVzWVbSKuae54g5JpnFb2K39TioSHVrxV8H8MiS
	 8uPryfHwjCYadR/eUHDAyv/H7bOziOcHZH7w6tVAO6WS0MYdXZbSqpq9c2WIK2zWrg
	 4DcPddu9VgFCc0hy0yVgTb03xQwza3NS8WSq3ScY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0270/2151] ASoC: es8389: report resume restore errors
Date: Wed, 18 Nov 2026 15:33:25 +0100
Message-ID: <20261118150131.686763219@linuxfoundation.org>
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

From: Pengpeng Hou <hppiscas@163.com>

[ Upstream commit 8f7d23eb8ffb817ba69049577ab8ca55b93c77cf ]

es8389_resume() ignores the reset-register read, bias restoration and
register-cache replay. A failed read can leave regv uninitialized before
it selects the initialization path.

Check those operations and always leave cache bypass before returning an
error. The ASoC component wrapper reports callback failures while retaining
its best-effort resume contract.

The issue was found by our static-analysis tool and manually reviewed.

Fixes: 0319c26889f7 ("ASoC: codecs: add support for ES8389")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <hppiscas@163.com>
Link: https://patch.msgid.link/20260906034217.85696-4-hppiscas@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8389.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/es8389.c b/sound/soc/codecs/es8389.c
index 20ba0042cb0b0..cf95519a2619f 100644
--- a/sound/soc/codecs/es8389.c
+++ b/sound/soc/codecs/es8389.c
@@ -819,20 +819,28 @@ static int es8389_resume(struct snd_soc_component *component)
 {
 	struct es8389_private *es8389 = snd_soc_component_get_drvdata(component);
 	unsigned int regv;
+	int ret;
 
 	regcache_cache_only(es8389->regmap, false);
 	regcache_cache_bypass(es8389->regmap, true);
-	regmap_read(es8389->regmap, ES8389_RESET, &regv);
+	ret = regmap_read(es8389->regmap, ES8389_RESET, &regv);
+	if (ret)
+		goto disable_bypass;
 
-	if (regv == 0xff)
+	if (regv == 0xff) {
 		es8389_init(component);
-	else
-		es8389_set_bias_level(component, SND_SOC_BIAS_ON);
+	} else {
+		ret = es8389_set_bias_level(component, SND_SOC_BIAS_ON);
+		if (ret)
+			goto disable_bypass;
+	}
 
+disable_bypass:
 	regcache_cache_bypass(es8389->regmap, false);
-	regcache_sync(es8389->regmap);
+	if (ret)
+		return ret;
 
-	return 0;
+	return regcache_sync(es8389->regmap);
 }
 
 static int es8389_probe(struct snd_soc_component *component)
-- 
2.53.0



