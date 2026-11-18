Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030062;
	b=ccb+JX97+jX/ClXt4nuaEhEyOGDpGEiouQQPljX3Wx8R25zEygjXQn2YRnwDj31CMBee
	 EZJ0ztx840s481UH2QQjaQ/Hbh5YbM7fPK/DrG6ZRpmqf7h1u9O4QYgeLmx7ltSLlN5Si
	 j9eKydIj6xJTh64tGllRB/zyqFm0xJlwH2Zxy4Wt8zWTm6eA5zd+3syOoE2yxLWIQPor5
	 OE25dO8/ejBOIrYWgEvBtK0kWBMpRgqleH+LgA+yhjLVA7QaJFdXIafM12Kb9um3oXvv8
	 KRvialxFJ4cumzalgfjOX9monn0IzG3eg/WsYSTtVwvtRC4jSsqaPieSt9MmWkDFcwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030062;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=997bpa43MKxTOqAZM1MQTCVTjiwy/yXs/WubggqHGP0=;
	b=bXamGUVjR+KcFUpwaK9DuBI53Lt79/a112Cmr0YPnYtmBk+Z3Y+iVgzYlUEZtJ0+NVel
	 KpNEOVQ5TDxp4e1FJKcxWCEZXRrBc9OrnwOY1/KKbCD52BUMKr1f/uq0B35//8vKI7ywr
	 1+P7d8H3SW8fAv4Psqw7UHB3nkqZMRJy7IrP5fPzXcTdXhJj2aj8SUdrCXZKWZvd5mtyJ
	 6314OZ8Ej5wxfADWUmQkJBHnBB5KArof4OP3gfoIp4JtdCjGKA9LxDWqAQDhe3JkFj61s
	 xb3hmxAmILhhHlseMTSifQ4fPoqR4bWJn+F7l4EhN1yDesHcmjpUMQZoKLPXhXjK4Uw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uHL9YaOf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5976A60A6F7E;
	Wed, 18 Nov 2026 19:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uHL9YaOf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7909E1F000C6;
	Wed, 18 Nov 2026 19:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030062;
	bh=997bpa43MKxTOqAZM1MQTCVTjiwy/yXs/WubggqHGP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uHL9YaOfW9ZP+GCexWv9JkjoyA7ZFuhE3QnUFpQGcYyG7w8HHoJuohSVbp7mllUuT
	 EZJ3MakKjdwvEs3cJcGpzh0zN/ZTurxnlpPhn6F6jTLAzgz9/OW0ExFwaThFxo/+2W
	 Oy8JjSzTlQExNU9T8pnkCYJJosmbCjFwELzu++ZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0572/1756] ASoC: rt1318: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:44:59 +0100
Message-ID: <20261118150031.835049565@linuxfoundation.org>
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

[ Upstream commit a5735b341c6e8cff5f5f9480295012a5ceebb665 ]

rt1318_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: fe1ff61487ac ("ASoC: rt1318: Add RT1318 audio amplifier driver")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-11-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt1318.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt1318.c b/sound/soc/codecs/rt1318.c
index e12b1e96a53a5..0e8c149628bb7 100644
--- a/sound/soc/codecs/rt1318.c
+++ b/sound/soc/codecs/rt1318.c
@@ -1076,8 +1076,7 @@ static int rt1318_resume(struct snd_soc_component *component)
 	struct rt1318_priv *rt1318 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(rt1318->regmap, false);
-	regcache_sync(rt1318->regmap);
-	return 0;
+	return regcache_sync(rt1318->regmap);
 }
 #else
 #define rt1318_suspend NULL
-- 
2.53.0



