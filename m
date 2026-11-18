Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015681;
	b=1RrGrt2SqFHB6E1nq6Fi5eLdqV6+rf91yvBSHit13flIWzpAxMLo4BKXwN6wiyyC4/69
	 BsZRWMbuIxq6KapPX9+0pbEmfB1UZ1PFPbdD7xOxnshaqQ3f6ZFIxJaKKvGyPmXDmn419
	 H+SRolEwixRkmIGcOpG9XCuiTUZWWdl9VhYjVrXaaaqG+M60LB8GRADPfHNjuaUKLqWKX
	 qRJQzIie/Y8UL3UuHvEH2BdXrXQx7OsvASF/pX8nrzjzC+0Wud5zvCYqjDhLcy2qDu7uU
	 MJ970y1I8F7bPlTIqFcKM1X5cw41+a2iH4hdITtT0AJ4GZRg/g/QJfWn2mJ/1y+7COw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015681;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UMpULvh2vsDECJpYa9tlcRyot4U841k312o0sIJkMRQ=;
	b=rfVrrH34BQz/MAGtGx7p5xEWpo3OIFcY3FvsFshk40QymTEZiI7JiZkG3v/9ykSNH75K
	 eaYdutHfdZcinNTE9jO8BmFkjmMMY79u9BpG4WXwXO/YC8u9Qzf7iYf42uPYsxzG5In1L
	 oZ9dcLj2yk287HRCrVn04cO7QFxTnc3a6t5pphIIp478uI0/bcuaFnIhXzu3u6sRybPKS
	 MJyaUZOiPiHQ2nXmFBDjeENdpzxICDV8Jz6Q6gaALMpa8B3BSBSZAaJAh8zLgamjutVDD
	 /0uNqeSW3xXafJndwziOkmp9r/stG+lPuM1KYvu1WyKpGJ8PeYLeTfpvUQg249Wf5rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e4B+poo2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4601606A332;
	Wed, 18 Nov 2026 15:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e4B+poo2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 119F31F000C4;
	Wed, 18 Nov 2026 15:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015681;
	bh=UMpULvh2vsDECJpYa9tlcRyot4U841k312o0sIJkMRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e4B+poo2MRfLKcFqwiJsUj8tqp3hGcFW9ooSfQoIkUmK7HKbS0QQ+GRSM7aZYFEib
	 8AT0Q9EXx1AyB79Rp6gf71L1NGUmVH255Cd/5RKEqCE+q1Y/xp4csNVWz87GbyoOw1
	 VySyMRAtcTeOz0ghQY4mrAfuJ8D0HDIBZ6eTLwdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0261/2651] ASoC: es8389: report resume restore errors
Date: Wed, 18 Nov 2026 15:25:01 +0100
Message-ID: <20261118150257.299937840@linuxfoundation.org>
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
index 2ea0c4052ce17..7d6d47e3065bf 100644
--- a/sound/soc/codecs/es8389.c
+++ b/sound/soc/codecs/es8389.c
@@ -1032,20 +1032,28 @@ static int es8389_resume(struct snd_soc_component *component)
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



