Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017194;
	b=Sp36VBrGdRJ5+nMY6ZCqM3NVd8x6W9zGLeDRh74n4meHcVmY1sE8743/fYSUV+dMRyA7
	 gD3AybsrUI8AqNZRuH3zm8T9Z6sy8k2BXnTeJXZ5Nth40aNbQj129YJ3+ucSwQzfx+yD4
	 K0nZnueBK1g9e1TmwzB+SbaEoYmUXXM+SgFUmlUV7SBPFSwXDXcErAAHrVzHZccK+Crbl
	 hmRWmTUGkBBiyZhimeyRKHoFru3K2rfetWUpSi+8/yimPdQYEyAYLzfus/HWPaPFf+gtM
	 /DFTUPFQ2s/UBvr+06XOUK77/36tT2MLoFPcaBcTiVef9RFpobBfYh1p7eGRaKla6JQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017194;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WkBJFpQ1W+DAuvCMY3A4X3iWH/OzgabAgEOgzAJa4Nc=;
	b=4CPfsACkemPMXj0T6Cb0GU3vx5M0mT/qpFHJcsPfyDGgYgx3r7gixHkAHcENCf8p+XKX
	 Oex/9BW1GQmcxxX+khp56cxC0ezI/a3+icbTqlBsB/q3nXhXwCIq+uhL0vgVu9I4WPGfn
	 yHKVzL1E9eeX5uFzukVvHbww6QKoxTl8SMymEChxeMrVQqzfK0p7EeEbQh2cRo0nudyuw
	 x8Doi6qx6Fz9fF6ccjf0JqGfDSe8LOxXNB2nwmoof2w58GC6bllf6rC2wr3r0Eo/48VnX
	 95yaxebQVEl41wE/k1zN0GqG5oEtXNsyY+KDHiRXORfbcZ+/4sIYj7CakuGbpOCSVgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cc7fzBfV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F2B606A32F;
	Wed, 18 Nov 2026 15:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cc7fzBfV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C081F000C5;
	Wed, 18 Nov 2026 15:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017193;
	bh=WkBJFpQ1W+DAuvCMY3A4X3iWH/OzgabAgEOgzAJa4Nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cc7fzBfV0sLu3uuU+k0uqSSmyer9qVP81Z4N4tqzwmSVB7DRDMid++Rs3bB11uF3J
	 9wDsVt/4bQxXAfnEvD5N7b4tUj7qjCibeDiHKB25CaISJeACTMUS4NYxJ9AkP/2EwG
	 oGbAKZvCCfMj1O131L4P10sn4AnROMCrDVrUkstE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0798/2651] ASoC: rt1308: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:33:58 +0100
Message-ID: <20261118150316.606554868@linuxfoundation.org>
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
index 630946cd7cdf8..df95cfbd76d69 100644
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



