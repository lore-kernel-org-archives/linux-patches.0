Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030059;
	b=snGVwX+NAbVJH96l5CjS9OdydLVvubW4FIhXq5yOBaBYTosVfS3mJqtXM68/KV2pW3KK
	 ZqwzESQ7aKNZG5vwjWmivXS/Q/UjcZ8la0968dLj5FlL4+DKCX+vTEgAZrEamNiYkfgQ3
	 K0lztjy4b5faegXGJ8VsDyfLTWZra1qWLOUwb/YFa3iuRtcDop+IBxqBF0tXBk2+JdYOP
	 8Xrm6dezSs7zeRU/zlOoJSgdXQFdEGm9TWZ6De5dro1/HDbj7XKnkwkss7IfGyNwCEttZ
	 dks4OJtSwejaWxlGq5EuFi/fQKBgbFr/UhkmmyVuPmD51YtNLNAeeiLZn9j5YPSxLQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030059;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3RaYw7ntHIJ3RKSfWxVFJypi2nzrUISaXzg87u4lbJo=;
	b=AbXcAbMd3ih3cR2GHcodqnl8J9HzJBzgHL4qv4+jxR2vDiC+8ZAxl8YAIgGp9TJZMTkT
	 NsnZo40eVNkFUjfi5nZhQ14DupkSHl/0jIUF8ZKmajeHeMgbeZOO4Kc+ywGLz0RUZCFq+
	 PdYeW4mlGtFJajUjxG+an5W3emBJmhC6b9288FwRAQv4g1t7tL4Xra7jkmtQjs3nXJPsu
	 b/yTjBmElQNAWjpoFA1BqjW9B/ILEqQti6cXzxgPmxVZF4p6k1+vSEjaeNiqF77RkWDix
	 i+efuZdT0SzrJha98LwkFHMBY5b2oNEsHfHNL0vVGgoEDD1jiEMwmLbl802tvuuX3kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WISywQwU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770E9606A33E;
	Wed, 18 Nov 2026 19:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WISywQwU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F021F000D1;
	Wed, 18 Nov 2026 19:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030059;
	bh=3RaYw7ntHIJ3RKSfWxVFJypi2nzrUISaXzg87u4lbJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WISywQwUvKG+JZpeF+zRDAEqbl9BrfadfrcLKReBTXlxCQzuS7U28OidDnl1Wlr8m
	 GYV+hAotGTOWFjcId2uOxX/E5vBOglPemb7+keTuLyNgZO0itOich7T+vpZSjbNk9s
	 vLXbqC7kHZlKyQytAr9aHhL1sgdKLz7vd3nSx5Qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0571/1756] ASoC: rt1308: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:44:58 +0100
Message-ID: <20261118150031.794537636@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 3db3289178b94056753f7a8c6ee4ab4b232ee6a5 ]

rt1308_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: 2b9def8c0d92 ("ASoC: rt1308: Add RT1308 amplifier driver")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-10-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt1308.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/rt1308.c b/sound/soc/codecs/rt1308.c
index b366338cea711..a7c21cb95778b 100644
--- a/sound/soc/codecs/rt1308.c
+++ b/sound/soc/codecs/rt1308.c
@@ -715,9 +715,7 @@ static int rt1308_resume(struct snd_soc_component *component)
 	struct rt1308_priv *rt1308 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(rt1308->regmap, false);
-	regcache_sync(rt1308->regmap);
-
-	return 0;
+	return regcache_sync(rt1308->regmap);
 }
 #else
 #define rt1308_suspend NULL
-- 
2.53.0



