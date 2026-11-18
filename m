Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048591;
	b=xXbLLqoHQ2sD7ZTTbD8Fvkw0OJoUZSyTqU3LTl0kC2uo1A8835svVbebM1Ce9ARWV3Rr
	 Y2nFJ2BNl68bPTuGN6prEUxDD8GXH8DZPC0n6iwNqzEehnemDUvZJvXm23IiJmkCdk8wg
	 +Dk5sienP4OWwXzFcW+OnmqXK86E8VGDEDnkrsQe9/UBGniq12gt+BQzfZt8VurIU50ZK
	 0byZQ/RSeD2nN/8p7Od1hOhP78hmNqXaM9YIh2jjNIbBbm+2fZpiff/XPQxVtAegX4ZR2
	 QKCFz0LcRrRyRC3+z5yFsExynBxV+RwgeY8OGORq61IQ/vgF+7Ikk4hiIxCISyp6dKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048591;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ig33yDy9xpJuyqhvctSod2KmHS68bKvLckquYtm8sKI=;
	b=25kWMQY5+IJnIeAW5kxumI6IqO/31/EhcjHxlrDcLpFUSl1E5y/mW968lYHj+6K1zv8V
	 G6pApD8dStCnNXBXB/KrEe8LIaAlto7D0aXsV7e8QtYdtSz+BVHtwSSYY9KohpPv4PIK2
	 zNm5CfJ7PwlxxNsF7czemnZSleoBS8Qr+qMnBtaDqM12Gt/q2mvz5S4VaWn7q0L3KFCew
	 l4LcXzd2a9QUyOzK19j1hqZUegTdf1h8QnUrMP9Fp7L/qbcB/0CJm0sMYzIYItSKk9XSM
	 HnxmZNjzy9OxOScX2tdsSiBNIdKCZcR7G+CNLxsrLR6tmNexHY3IZ409Wle4HeGQG4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eFf5+Wux;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52D8606A320;
	Thu, 19 Nov 2026 00:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eFf5+Wux
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D8191F000C4;
	Thu, 19 Nov 2026 00:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048591;
	bh=ig33yDy9xpJuyqhvctSod2KmHS68bKvLckquYtm8sKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eFf5+Wuxit+mi8vfR4utIdbw7xsmDKb4ylhODqouXSb+Zx5D/iJH2ZOU8T3dV7bxk
	 QME8+Ei52cx4LKkdh38Cx7kKQlTlZ7ugP65Ts8tDeXa9w7lRVFfncNjICE/3oLvGqB
	 mEbW4cej3LfwCutlA/JWKewGPerQNOuRn95Z8ccE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2050/2857] ASoC: rt1308: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:51:24 +0100
Message-ID: <20261118150315.233781714@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d2a8e9fe3e234..bdde21de7835e 100644
--- a/sound/soc/codecs/rt1308.c
+++ b/sound/soc/codecs/rt1308.c
@@ -717,9 +717,7 @@ static int rt1308_resume(struct snd_soc_component *component)
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



