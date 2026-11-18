Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030057;
	b=VEQFVZhenjfw1Ky0cj1Roh9t8sLA2kjyoFZOAJAXYHBG+b68yzTdbBtIkBg90eL4A6Yw
	 wbu2peKnliLxiV7UZ+Wr5NJRvoEzzO4eR9+rM94zCiUx/frp3ULpCNEjO5xXcz1r2eqik
	 BHO0jgg7b2LcDTDyL9Jrh1PSJ7dhELeVMkRNCfaZghmrnNKKdkrpOObaw+K809I8VYOOp
	 QDNi1jxjNSRKjwGUBhZ1x+BphmrFVFdykbz1JwXPmpT900p+rmarNF7KSsp9DCbqMhazV
	 m21mZPyBPsXUKJvCcR6MUnUGq1qRSvR2KyEq/Jv2kEpDgSsO/7qlgvVKDzJkluAI25A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030057;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SjDJvyQNqV3bBKHmrSZc327KXpIgr3Zv/YDKAXO3pfM=;
	b=GiAvFtn3GltT/liWa4qqmoFhfTLkkGZtL0zDmClNjqCeBGJaySENbxorl2D+kWlWt4lQ
	 CD95ohJOmZAmRf5TzUDySvg/nRNosz3esFCeiCpkDPSa5S2iUbhd6AOpwjB4nO75r1o1L
	 BNCeR8XXmiXaYbASRaSnkKEUpH57FBAQKXZPLQd0kJy68wCyE3qWZODE7h1ibGhUuJjQm
	 bXKITI67HyMo3nw9aCCVt8Ptr8R8P3yFBFWIbp51YnAGfdrMYhC/4NLw3ocPZEMxlno2w
	 x1pjLC01fRl+NmZN0/dUWgeOUetj7sn7c2WjTaSzbXuGQg9Djzw+B+LMmbZSeBga0XA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G1ZhOo2p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1922606A330;
	Wed, 18 Nov 2026 19:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G1ZhOo2p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9C71F000D0;
	Wed, 18 Nov 2026 19:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030056;
	bh=SjDJvyQNqV3bBKHmrSZc327KXpIgr3Zv/YDKAXO3pfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G1ZhOo2p/VFvBfHkTmiG/0RKqyMNuej4NCeKybqH7na6HAw9mayHeXW/sZGQffFOM
	 +YUQ+GNXHvyj3zfMBvkg3rFd6UCwOXn76KfK5dFQFNIJb5UngfCHmM44u35yO7V5J4
	 9ddTKKPzQSOKd6iwSpA5QLQL41oNirLToxvde7pM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0570/1756] ASoC: rt1305: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:44:57 +0100
Message-ID: <20261118150031.757388872@linuxfoundation.org>
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

[ Upstream commit 30858325aa90380c6bcdde605214f1ebdbec568c ]

rt1305_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: 29bc643ddd7e ("ASoC: rt1305: Add RT1305/RT1306 amplifier driver")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-9-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt1305.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/rt1305.c b/sound/soc/codecs/rt1305.c
index c2b55be8d1653..b786d4eeca7a8 100644
--- a/sound/soc/codecs/rt1305.c
+++ b/sound/soc/codecs/rt1305.c
@@ -896,9 +896,7 @@ static int rt1305_resume(struct snd_soc_component *component)
 	struct rt1305_priv *rt1305 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(rt1305->regmap, false);
-	regcache_sync(rt1305->regmap);
-
-	return 0;
+	return regcache_sync(rt1305->regmap);
 }
 #else
 #define rt1305_suspend NULL
-- 
2.53.0



