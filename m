Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015678;
	b=b4HmQPnOR3K4mFb3EZUerM0qiiO9ow+0QVb8+l7YCvQ7ADO+zpWNZII+ZDkIjrXMJh6e
	 m9i9tc8NMrUOzOG5Bna10qjE+4no4NvPJ83jteYtkZad9Z5nRwdfcfawfaxtmFKZHdLcG
	 d6EY8EI5YwBD4bGmP0fbcWOSLtNL8tVEuqC7ZGn2ohpNmUPnMTkghHpodDe2p/l+TtQ/l
	 10qKDkDawnqHWI/HLfOUEA9L4YoG3MshOOWNi/b+gbnH6o9nPT/VPYhL5OJn9BW1MR3qH
	 ig0qHoasUYAn2r/8DORy2kkcSxdefkViYuyrPl98zZv18H6kA6UvGAgg1xJGuqDsnTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015678;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fxNKDaniXCQtMsLjTw3u71Y56svgiLHbjYhzOWdr9b8=;
	b=ffyMIrKh9tDaQWGVBcLmgBPiGi9d0ngqXeyTK79DeAMog1K9rDWgZCNEG9OKM1h2pFrz
	 Vn/IzKHPj3C9Ekdc8yyxEqCZbalvWV4LWOZ/fkN0j1grOeOpBZqjCOuxtq9TNN7xgcugT
	 RKw2o87yu+v8+sHPcnuFugO/qdqEN7uJGmCc1FEeBRORu0BYmgTE9jUHz1vFuAJci3JMG
	 EB3Smr7c0WenpUChJqMw8pua4AE1Q4aSQpGT5ZZoDx3LF7dImQsDDsE4wWivIlSi6dgnX
	 TDPeCNqPO3ckkmDxA3yj5ymPEmcJbFIRheeN+PTGl8/cxTM1b3vSP02oceH2GDHjxjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JGWDTM2I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB68C606A320;
	Wed, 18 Nov 2026 15:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JGWDTM2I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 362F51F000C4;
	Wed, 18 Nov 2026 15:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015678;
	bh=fxNKDaniXCQtMsLjTw3u71Y56svgiLHbjYhzOWdr9b8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JGWDTM2IJNvSWDXmyi18sL/1Oqj+/BWkTXvxQtyFk3Y0TDTgLa1iYTanw1nBsAhxZ
	 96D4EYjhttN8xiZ62fc7+iv8xx59tjt0dTBX5yIekQMdp+4v35vKJEgvQ0DVs+Wg5p
	 zCSMypTgbhfPuRmZ+SYcs2uCJOE09e1c+m0Fn1mA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0260/2651] ASoC: es8375: report resume restore errors
Date: Wed, 18 Nov 2026 15:25:00 +0100
Message-ID: <20261118150257.263639657@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <hppiscas@163.com>

[ Upstream commit 8f43acfd3addf10fbde8d21dd44b1a61e1936ba7 ]

es8375_resume() ignores the clock-status read, bias restoration and
register-cache replay. A read failure can leave reg uninitialized before
it selects the initialization path, and later resume processing cannot
observe a failed restore.

Return the fallible operation results to the ASoC component wrapper, which
reports callback failures while retaining its best-effort resume contract.

The issue was found by our static-analysis tool and manually reviewed.

Fixes: de2b3119f9f7 ("ASoC: codecs: add support for ES8375")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <hppiscas@163.com>
Link: https://patch.msgid.link/20260906034217.85696-3-hppiscas@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8375.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/sound/soc/codecs/es8375.c b/sound/soc/codecs/es8375.c
index e8747bc24433f..2c58225feddd9 100644
--- a/sound/soc/codecs/es8375.c
+++ b/sound/soc/codecs/es8375.c
@@ -577,20 +577,24 @@ static int es8375_resume(struct snd_soc_component *component)
 {
 	struct es8375_priv *es8375 = snd_soc_component_get_drvdata(component);
 	unsigned int reg;
+	int ret;
 
 	regcache_cache_only(es8375->regmap, false);
 	regcache_cache_bypass(es8375->regmap, true);
-	regmap_read(es8375->regmap, ES8375_CLK_MGR2, &reg);
+	ret = regmap_read(es8375->regmap, ES8375_CLK_MGR2, &reg);
 	regcache_cache_bypass(es8375->regmap, false);
+	if (ret)
+		return ret;
 
-	if (reg == 0x00)
+	if (reg == 0x00) {
 		es8375_init(component);
-	else
-		es8375_set_bias_level(component, SND_SOC_BIAS_ON);
-
-	regcache_sync(es8375->regmap);
+	} else {
+		ret = es8375_set_bias_level(component, SND_SOC_BIAS_ON);
+		if (ret)
+			return ret;
+	}
 
-	return 0;
+	return regcache_sync(es8375->regmap);
 }
 
 static int es8375_codec_probe(struct snd_soc_component *component)
-- 
2.53.0



