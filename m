Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060857;
	b=jUiT20NjoK/B6m4Kt14qqCTMsV1+aLo7JCzN0jKAFEilCkRgmnXxbHrVuHXNUOXLYLLe
	 YAlObR8NWwr5AWb5y/UwVeYupkqLI2Qve2ajnHhUzzgXmUOx2PoW1NvCCTUOiPl81QDxR
	 8qF3VIKKKa5umrC0/i3sYvkqqzSsQLVhr4Em4UXwKqtL67YuGeoU6ARX30gmuzwL+FGRu
	 wY6yEQaHhauuvJ0K/8hpSgK+beLN9uV1K+0DDXrdeEEoD5Rnf4VK9ts0cUrW2pBcOMF4M
	 HwV83bH+qWqtzaEvu8wx0iwZifHLI910T/j55OI9rGSsytbk6AnRnyAgwXpqiLzneDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060857;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ARH2/3jWcZQm8sMWXtEqarcStu+X3XtoKa4Inaro7C0=;
	b=22ck9il3x63hussmUyt327uivkVU74w2QC9CT8UKq791w9L61J+jGhapIfBUMZM7ViLK
	 1yjHaGK9uQkYbtEZti+fuJzk+B6tXVg6a8pV+Ve4EI3cbwVtypgBWQnecC0b4ptU2F2T4
	 0+cPHAYDM0CENnRzwZo4sHQ1lNdxDi9WV6rxdF+crn81g+yHUtn65+U66AdxJFXRcoMDa
	 E1AIzWWnY8c5+p8K07REc5m3ypw9G/CZ7cv2GU2VVEbOvbj8mBNZPdqIeRPSuDZC9FlSh
	 t3RE2SJWRRz/kYDR3Ly6Zj9hSGH77tzCvIh84hmRtMOAjxbwMepCaqHZmgwKwveDQMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xFInr9FZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CBD606A32C;
	Thu, 19 Nov 2026 04:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xFInr9FZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 371051F000C6;
	Thu, 19 Nov 2026 04:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060857;
	bh=ARH2/3jWcZQm8sMWXtEqarcStu+X3XtoKa4Inaro7C0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xFInr9FZixPwY7p/0IWWOL1sHxZIqvQTgtPx3V7n7nCqHSKof08PHLIuA2WFbjxE9
	 lIAIJh4QZOzQYvgn+A05r3zAiW/8f+5v1jemu56M0qfncK7LB3xld6hivnLXON5obc
	 NL5/5z2Xlzvf/2KYgXxK2rgwYNDJigJjXAx1Tr90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1349/1848] ASoC: rt5616: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:56:27 +0100
Message-ID: <20261118150016.122584532@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 8fc9d353d5371a946d9a9952278b96c09070374c ]

rt5616_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: b1d15059957d ("ASoC: rt5616: add rt5616 codec driver")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-12-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5616.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt5616.c b/sound/soc/codecs/rt5616.c
index fd0d3a08e9dda..52408f24a494b 100644
--- a/sound/soc/codecs/rt5616.c
+++ b/sound/soc/codecs/rt5616.c
@@ -1250,8 +1250,7 @@ static int rt5616_resume(struct snd_soc_component *component)
 	struct rt5616_priv *rt5616 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(rt5616->regmap, false);
-	regcache_sync(rt5616->regmap);
-	return 0;
+	return regcache_sync(rt5616->regmap);
 }
 #else
 #define rt5616_suspend NULL
-- 
2.53.0



