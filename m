Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024386;
	b=HyDCi293TksIinybM3h2Owhu2bZnA92XVeFDLZf9v2+SWqaYmqNC8RrnwsMykXZJ0dhM
	 RlSxIF2/icuihgs7NZgS2ti38LBpD1t7hqcze6swaXgAFionxUkgBHhRXvvyDLOP1Q+lH
	 GNHyRcBpw9sAAlAZo79qRR8aWZO5JuFudwGPo6nAjqGxPoAnmns3B9KS+7k8bjKerMXtg
	 fVDVG+T0fikRu2ekl6KdpgIE9FC4MSOtX1OKnd87P862lA3ncYwGPy0vVFdB2l8IlgJdg
	 RW3pmZZzgo+wQA11iVAnDEqGprUcIa2uHaqg3g+h+WqMzOQ3PFC8LIigRuVxxLQDhRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024386;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MbvlfFyTGI7AM/XWRQDIWTS7xs/G3WI7lAmLgMShCFk=;
	b=XNCDPS2whOhe2A4UGrLvsNcIYOt9By07F+BTXv4IjnAKCamKyccO6iEnv/yak8DD86bM
	 fLwJ3PDvA9o31cLA2JGo7//oT59SWnHwcFmskKgCtLVFr8521GkutGUNbgcNqXxXmSQjN
	 iLPq9KcV3kirYvpBkSALJH4cEfSghr03Y8SL9V/L2sqh5k8SIaJtaszMybrt+VKSXORNJ
	 LMdkMfRqJbTwwjbNKl4/CaBWx/hfqE9odn9H2xV4Xmq4ZAU+2rJ2Ou5DIiUbCONjKQ6Gc
	 RIrEMIi9megZ63MM455A6kAsJmEwfoC/UNmmLrXV0X2GSMG76i98ODvKGnSU6HBKe6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yvn5wk2B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A371A606A32A;
	Wed, 18 Nov 2026 17:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yvn5wk2B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3EC31F000C5;
	Wed, 18 Nov 2026 17:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024386;
	bh=MbvlfFyTGI7AM/XWRQDIWTS7xs/G3WI7lAmLgMShCFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yvn5wk2BPavTqROgDreCrTbvXtD7F1OpOSsJVpjXCK8k4VDEsemxSRBENazhuigLz
	 Rp0pB3TpbrVHxWM4K9K9cF9oYxcqAuGlt/+wKxIBYGtaxDc2/WKyvViyKw/pRItg4H
	 cJl28m9QDRnUKi9wMHQAP9cFF6YH5UjFv0eIkFDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0708/2151] ASoC: rt5665: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:40:43 +0100
Message-ID: <20261118150147.667266938@linuxfoundation.org>
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

[ Upstream commit 9f2933d9a437302d5ae32eb9022efef049d8ab22 ]

rt5665_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: 33ada14a26c8 ("ASoC: add rt5665 codec driver")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-15-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5665.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/rt5665.c b/sound/soc/codecs/rt5665.c
index b16b2c66e754a..2940254703b08 100644
--- a/sound/soc/codecs/rt5665.c
+++ b/sound/soc/codecs/rt5665.c
@@ -4389,9 +4389,7 @@ static int rt5665_resume(struct snd_soc_component *component)
 	struct rt5665_priv *rt5665 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(rt5665->regmap, false);
-	regcache_sync(rt5665->regmap);
-
-	return 0;
+	return regcache_sync(rt5665->regmap);
 }
 #else
 #define rt5665_suspend NULL
-- 
2.53.0



