Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029171;
	b=BrNN79Sp6grwqBCDikl2zuLT8qi1F9/k/FVAOisQUBQii8r92jGJ915EXPOr6ra0ceio
	 R4JLd1ahUEdLAtaVrt62cWZkGo8U2ejDxO6tWBVw5IeknlWH8eZ4jFaBwEz7MZ0OoVjpV
	 C1ZpChVL+EI7eLjEtQ2TWYjl8pttwp5q2yEc7CWu+BhftHjpADAhKWF8M5w+2+jHeeNaM
	 Bw3sMKR7DrRZ6UXc6Sdm7LOqcbsGHUWlr4Ug/4+3Ns73IdA0IY6LEhA+a3YQyyzmmI7/X
	 5xImmoOJfJcAd/hQoYb/6OKLPQJLYqtHyNJuoeXwL3aBlSqoSlg1mLO3zkUPG1X8jUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029171;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D77ssWAr1iZ2gOwF1sXy/PHEbigTbTAc/ka2EIPgcxg=;
	b=ekZ1TE+ZncTmXLVjCe0LDto11jpgKfZSnBudqoe5NaYLJLO4gjT/BLvnEQit3xeskYKN
	 b0bXXyXXEwgpdv7+lAxnlGEbXPbSn3wFLELLgkR9IUeU7hQ3AcRfQXrwYWzVC6l3oN5Nz
	 J0oGk2ZQX5Vmn2GQAvwmVA4BkwP1m4vsFJwRZ9W7Y990u+2ADWb1LuSxyIbps68HP0sEU
	 eosMkbb8E+oelX82FvNe0OXXqYHPLEyDYeDIWrVY8tnFEN4eAhpkuLEIedEhX0SVKZ8aw
	 ZHU17Mr5ctwvQa/9JJ0oSKOksQiJ7ONN1ToYBuN62g7JEbNYijvU+oi5e/Gn/B/IlGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GApc+fbI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B07160A2600;
	Wed, 18 Nov 2026 19:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GApc+fbI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 372761F000C4;
	Wed, 18 Nov 2026 19:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029170;
	bh=D77ssWAr1iZ2gOwF1sXy/PHEbigTbTAc/ka2EIPgcxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GApc+fbIq0G9WPdJOP1hn/44x8gFJ+WPbcK51cVGeQS3pmft+npZ8mn6suwHgcezN
	 Kn1VuUxg+M8vWKyZBtv2LCm05+cMXHJ+R4lwzuvjeg1Z2d793pCR5lZbJR9SoNHAkA
	 ggDnsqtNZOJwwjsjOjUIPtnjUYPTLR1o1oz457y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0253/1756] ASoC: es8326: report resume restore errors
Date: Wed, 18 Nov 2026 15:39:40 +0100
Message-ID: <20261118150018.449919195@linuxfoundation.org>
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

From: Pengpeng Hou <hppiscas@163.com>

[ Upstream commit 349e94679968785803cc32c1d2e41e000e8afd5f ]

es8326_resume() ignores the status-register read, the direct clock-state
write and the register-cache replay. A read failure can also leave reg
uninitialized before it selects the reset path, and a cache failure is
followed by jack IRQ processing.

Return these errors before later resume work. The ASoC component wrapper
reports the callback failure while retaining its best-effort resume
contract.

The issue was found by our static-analysis tool and manually reviewed.

Fixes: 5c439937775d ("ASoC: codecs: add support for ES8326")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <hppiscas@163.com>
Link: https://patch.msgid.link/20260906034217.85696-2-hppiscas@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8326.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/sound/soc/codecs/es8326.c b/sound/soc/codecs/es8326.c
index d5362b3be4844..caaacde8b59e3 100644
--- a/sound/soc/codecs/es8326.c
+++ b/sound/soc/codecs/es8326.c
@@ -1082,18 +1082,28 @@ static int es8326_resume(struct snd_soc_component *component)
 {
 	struct es8326_priv *es8326 = snd_soc_component_get_drvdata(component);
 	unsigned int reg;
+	int ret;
 
 	regcache_cache_only(es8326->regmap, false);
 	regcache_cache_bypass(es8326->regmap, true);
-	regmap_read(es8326->regmap, ES8326_CLK_RESAMPLE, &reg);
+	ret = regmap_read(es8326->regmap, ES8326_CLK_RESAMPLE, &reg);
 	regcache_cache_bypass(es8326->regmap, false);
+	if (ret)
+		return ret;
+
 	/* reset internal clock state */
-	if (reg == 0x05)
-		regmap_write(es8326->regmap, ES8326_CLK_CTL, ES8326_CLK_ON);
-	else
+	if (reg == 0x05) {
+		ret = regmap_write(es8326->regmap, ES8326_CLK_CTL,
+				   ES8326_CLK_ON);
+		if (ret)
+			return ret;
+	} else {
 		es8326_init(component);
+	}
 
-	regcache_sync(es8326->regmap);
+	ret = regcache_sync(es8326->regmap);
+	if (ret)
+		return ret;
 
 	es8326_irq(es8326->irq, es8326);
 	return 0;
-- 
2.53.0



