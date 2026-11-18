Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024367;
	b=A6MXYXrF1sQEy4bAWiq0hnMGq0CRxSjqU+d3ruSGMXVz2nWsmGfe2NsWrE4mBAW/I2WQ
	 fUhGybqPGG28EMto5JneMPcnPD6kTBeRq1Gx59sFXK7UOIQGXHMv6fVH12dyuCoGJR6A4
	 bzbJCQMTd044wuA44IqjaBD6dudzwdJKnd0or0c8ou06kvcYzmPTNLz7Gb0uoo77aQnPs
	 xxyrjBXARmKEPU0kwN414lpORoRvX4mrsvXCvo6Plbde5n4ospuklkgfN6iirnYLBU+th
	 Gt48Kbd+ehq9Rf62Ga/nH6/cm1PpQqmoykJ3DwU7aAIXEjoQ2k7zQVAQgRTk9DyMS3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024367;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tQV3RNMozc7csdVc5gOjj3uK1PrGf3sigUedpqyIPM0=;
	b=JU5aLSdCQA79oFNUuT/0Y6Z0rrS0GbTLY1oQZd8QKVSFoPbVK/2gktWneAWq5o2XxoV8
	 skncY7jK5v8u6NfYeRfbLEcAyPGPlrZjPbB3bjYd9t4RPX9OKPuYvTjMKkLohwqePli67
	 LUCNnqEdgtyEK0jbcRQ4qdasl58i2rZ18kfjW2lht4PMw1S45O4UPyYkhrhrQKZvaHrMr
	 LfwHP9jejDFiFOy55Bd7VyjnjsYiAmLuPiSiWI9UiIfK6zANDB90r/KRZc7Rex9N1mzC0
	 fQPGgEPVIezPDjBxBek1RMEC09neEqh1q4+mnca0TjAMUjJFjUlzf4Ir8RrezmRzRbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=av0nPyxR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B62606A333;
	Wed, 18 Nov 2026 17:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=av0nPyxR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A771F000C5;
	Wed, 18 Nov 2026 17:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024366;
	bh=tQV3RNMozc7csdVc5gOjj3uK1PrGf3sigUedpqyIPM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=av0nPyxRuezFewqZ8Zrq+sxVTmWHlPBgtSRiI/37M5iI5TqXIZbBNebOKfa8UTbkC
	 om6Q7PM1rQrRB/Z5uS5NoEQGmy8o2v9IwKZ0U8ae+2JLswHdYlEdltnJtgTyyvGDyA
	 3T3TU6wm/SnjRVOk84uAQ9VxAW2jBZx9PIC0Wtxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0701/2151] ASoC: rt1016: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:40:36 +0100
Message-ID: <20261118150147.314137911@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 98ace05793c7b80a9f49d92b78fcc88e0970f8e4 ]

rt1016_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: 79a4b670b4b4 ("ASoC: rt1016: Add the rt1016 support")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-8-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt1016.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/rt1016.c b/sound/soc/codecs/rt1016.c
index 9f86f071fca82..bdb34dfb597b6 100644
--- a/sound/soc/codecs/rt1016.c
+++ b/sound/soc/codecs/rt1016.c
@@ -570,9 +570,7 @@ static int rt1016_resume(struct snd_soc_component *component)
 	struct rt1016_priv *rt1016 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(rt1016->regmap, false);
-	regcache_sync(rt1016->regmap);
-
-	return 0;
+	return regcache_sync(rt1016->regmap);
 }
 #else
 #define rt1016_suspend NULL
-- 
2.53.0



