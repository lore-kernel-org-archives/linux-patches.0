Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040160;
	b=mauk/NxiNV4WhYgYj1QBnSH6WlMPXPoBrMY0ZAnFkwCRsZuj0rCM8q96G8zvnQCLQOKd
	 +aYcA5GPxjZ6dDS1060kje9DXo3eNFvnsQxGGvcCHAgpJzpbDZPbhPNSEKRDpn1CQjDmD
	 ognlxAK5Ydf68pPGE1FvpegHEok2VuemIdfgmekWsVKk//kLCBYJO5G2WXzlaOk0OacCu
	 DfYL1FqC0e4dgqJb4Et5wJ3lkELonRgGNaKhvjBCnBhjrd98mJEQNc5U2iCzVyACb8fxj
	 w7xS6SNiSG15N2qI0MppIFM0gb3elURnSgKmyZvGsWVh4RJxZI/CIufF7xGF27u+tuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040160;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Dc0gVFtjeEwsYvKdsNoB4nXUp0bn0Zndra9+2FhrAcE=;
	b=HX/j+6Q6ER0iLdrn3rKqWBMfru9CMSzehVt4y7ivT8OD7rcLL4+mt621ncurpxTG1OJO
	 DQ0b9czcZQGK6PXTFEQ8OJZns9Uqc7Ar9cgdW4oWWx/WbxA4bpaCjjmz7R0FfnFx4H7GD
	 ZCLu+w614eXvCA7BOIHgyoItUVVJtoaWqGE269wl/PJ0qD5S22iU4DYTIG6uKXVrokKHc
	 JVc5ypGL0cM/prcAiQQTLHi9FjYmID8n9MUEmZAbkOqmrGhbkgN7lBPnje17mtB4W6uRO
	 kwSh4QXgCDx16edCxjvB/KbbXChx4tWhaNaHDAtewnf1Lgl+Kk2gruNBEQSDwYg+/ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rCb6C3jY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15829606A325;
	Wed, 18 Nov 2026 22:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rCb6C3jY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662E41F000C4;
	Wed, 18 Nov 2026 22:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040159;
	bh=Dc0gVFtjeEwsYvKdsNoB4nXUp0bn0Zndra9+2FhrAcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rCb6C3jYnrxKwEgAy0jx92uv33EpkiHRIDqM17jKsO8VYzUe7uTIjtqTq6SC5k8nq
	 1n5PnnCSrVrbOc3sjKOytyeZqDWolASwEL3UYKdE3+Vz/k9KeAhqAykV5p0u5l3AMR
	 Z8Q/2DFAtEpxsOT+DujtTDOe1+VAtA4feFukIn9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2356/3318] ASoC: rt5660: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:49:38 +0100
Message-ID: <20261118150432.275874332@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 70fe8997b03078ff8253d985a161fef310f7c346 ]

rt5660_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The power-off resume delay remains ordered before the cache replay.

The issue was found by a tool we developed.

Fixes: 2b26dd4c1fc5 ("ASoC: rt5660: add rt5660 codec driver")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-14-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5660.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/rt5660.c b/sound/soc/codecs/rt5660.c
index 0cecfd6024158..8e25d6756dbc9 100644
--- a/sound/soc/codecs/rt5660.c
+++ b/sound/soc/codecs/rt5660.c
@@ -1150,9 +1150,7 @@ static int rt5660_resume(struct snd_soc_component *component)
 		msleep(350);
 
 	regcache_cache_only(rt5660->regmap, false);
-	regcache_sync(rt5660->regmap);
-
-	return 0;
+	return regcache_sync(rt5660->regmap);
 }
 #else
 #define rt5660_suspend NULL
-- 
2.53.0



