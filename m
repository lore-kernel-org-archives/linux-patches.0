Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060860;
	b=ghmMz4Ws0/9wKKUbvsZxoOfHcy1GOxPBzkt/GQS8gpmc0lUZ5UaFWNwsKW8DxKVA/ikC
	 V5TwTUp5ouR1TRckXY0Hsua53Z1C1MQGHco17z2g8AMG2hHJcDDg5o3xC04nKhajN5bKC
	 0R7vcF8Di3VHA1/eDAI8p8y479qnq1tjZFzfeKVhhU1toYs81SA8ISW+bABz0OGjVWXYG
	 AIO38DHPeJay8dZkIz9ulnJIRdnjovpiAEkSFU/Qz/zAjhR6CdwgWz5Zh1aQAZHDflbEg
	 suX0o3yoXuCF7d6TfOR9Ea17UJJQ3un67h8FSCS3Iv4CFnEMGD33BpPWfUlnmQqkVKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060860;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tEhWO5mR63xGUExmozJMrMhAcRRVsC3JBSm3PWk5r8I=;
	b=uR1T0pTNsrEN0iuhYweQzKYtkAoR5x7YbtdNxhc6vU9qN5j0hiygizBtHlG7HK1DT0lm
	 kXIeY9Z7Hc3KWGgiOTzuWLsqsdRrsslJBwY52+8QCzP5QF3HzQI6drg5xxfMNN9/RwEI+
	 2NKCYG3CYCZCW3xNZujcNam1yoKtVtaJdNAehe9mlr9iyaoeesj0BOZui+pRbJd1eFDRi
	 q3OBigIQsMar7zxHv/L11DnLsoc9NFrIWRqqG7sdbPXlEk8vU1CbwgmKBfUxbrKCRVQjj
	 TogWqsndsxJQBNS9PsgWW5vd73X83ZOVSlwUg72u5OD/L4PE3tykb4NvLg/BGK3IEPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EIULP7gR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9B2606A32F;
	Thu, 19 Nov 2026 04:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EIULP7gR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5AFE1F000C4;
	Thu, 19 Nov 2026 04:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060860;
	bh=tEhWO5mR63xGUExmozJMrMhAcRRVsC3JBSm3PWk5r8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EIULP7gRyMqyx4M4DP9l5+gCsCdtdt6fszgO6HHoZ5fRaLMcSfpGyTnIljK7BwD/Z
	 sSCE7abM5Fp836VgadoGbZz/AOk49D//23OKfzHnZwJO6OW6Q0lnmBUZYA9yVssXN6
	 BgCvNYFv1Mv+TzSS8CAfVTu3wCBnxyoVZE71KfNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1350/1848] ASoC: rt5659: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:56:28 +0100
Message-ID: <20261118150016.165008537@linuxfoundation.org>
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

[ Upstream commit 3a9b5bce85a1baff95463a2bb021efac64bcf83f ]

rt5659_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: d3cb2de2479b ("ASoC: rt5659: add rt5659 codec driver")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-13-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5659.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/rt5659.c b/sound/soc/codecs/rt5659.c
index a9b079d56fd69..ae6091498d5bd 100644
--- a/sound/soc/codecs/rt5659.c
+++ b/sound/soc/codecs/rt5659.c
@@ -3705,9 +3705,7 @@ static int rt5659_resume(struct snd_soc_component *component)
 	struct rt5659_priv *rt5659 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(rt5659->regmap, false);
-	regcache_sync(rt5659->regmap);
-
-	return 0;
+	return regcache_sync(rt5659->regmap);
 }
 #else
 #define rt5659_suspend NULL
-- 
2.53.0



