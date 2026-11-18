Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040140;
	b=QjqHHcedmTlZ5W8oNjcx6OqAYsO2S+9Go/rvyo+mTs1s5KCGGuzRcwxptR3SS4iE5pKV
	 MwvpKC9poeRdZa7AE11jNg6l0WWfE+mYP4VlXhpxqofJFADntDgs8D6Z0QQNtm+tkIEBN
	 doo8oRarEhb2xN66PbzG6C76ua5iSYMO8jR5AeOYs2J6Llvtb6biQzHQ3lgSS5V5ryNoU
	 MjPQJdhFWxkNorqOdWRNdoT1iNlms2nCJcXoLlTq6qtv4lVxfrBMaWmkPpB+N0Lnkgh9Q
	 t0bIUGscDJIL/eoClCYjPQK+oZbdgzGbw15nXVOuPIT/z93cR7mP4kufW6JOzbDIb0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040140;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F9Y1JhagAXG5h8Gg4YHL9qz/vZgdKinFCZ0jSkAzphc=;
	b=r7OfxQtbXBFxm0qVBq8ek01tCb07Jz7CWlnDBtB7EalUYtWJgjNsEYRpD/+ZbVdzb9/q
	 BfeIdnEpP7CPDwNX9UxiAIqQ6w4OtsQ7GSo1Y2VLKxIChmVG5GZSRtEV39HfT+v2AsJU+
	 /YV7jLBsUQVbTBIMxfz326CXcpHBq6Y/8rYcgYI6ffiU3chCfkW7Iu/poWV1dtu73TXRs
	 8AX0raaRO3qW9N2es8PwQjilp+/Tvr0IPTdJ+bUAwKVjuvP2Tq1Wx0EPKfgWoVAl0ZCOi
	 3Rh+6vsdR1faWZJ0oBh5DoJZ+LFzj09Yt7M5KBuARefK3zKyTiTlDK4UmafN7GQyqgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gXzl4c8d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3CE4606A320;
	Wed, 18 Nov 2026 22:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gXzl4c8d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D31AE1F000C5;
	Wed, 18 Nov 2026 22:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040140;
	bh=F9Y1JhagAXG5h8Gg4YHL9qz/vZgdKinFCZ0jSkAzphc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gXzl4c8d9TpN/MQUF/+8v5SM/fYaEbpwR3F7BwzSz3pszgQ7RmtkCut12W3N+jAED
	 6Wlg7ndPuZ3KEyz2qpEAhH4NP6avcECNIxCHGlxUDm1j4TxL/BeYrfjsHuhXtdFdnB
	 QXuZ8jsJPwGAAJb6xRY9HSlPrEpzNudEQyjssPQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2350/3318] ASoC: rt1011: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:49:32 +0100
Message-ID: <20261118150432.112381148@linuxfoundation.org>
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

[ Upstream commit 432734a00bfae17baeff1a83b61bfc9c2ab20c12 ]

rt1011_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: d6e65bb7ff0d ("ASoC: rt1011: Add RT1011 amplifier driver")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-7-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt1011.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/rt1011.c b/sound/soc/codecs/rt1011.c
index d5285baad53a3..d5f72ac66a765 100644
--- a/sound/soc/codecs/rt1011.c
+++ b/sound/soc/codecs/rt1011.c
@@ -2099,9 +2099,7 @@ static int rt1011_resume(struct snd_soc_component *component)
 	struct rt1011_priv *rt1011 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(rt1011->regmap, false);
-	regcache_sync(rt1011->regmap);
-
-	return 0;
+	return regcache_sync(rt1011->regmap);
 }
 #else
 #define rt1011_suspend NULL
-- 
2.53.0



