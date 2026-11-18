Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030064;
	b=MYQRt7I1E308BVVqw4is4Kipw6mUF5yFpgeO18DR1/SaamZSkDrwNB4WbSjRkAQv2RdU
	 P8fFipYjqd7xP0XXzy79/mKh9tiJtEw8iEaIfPn0EMz9/TDoMtPjaLBBt/yh8oYfZTJco
	 FloIENcTUH/FRV6mu7cA+rgHirv7ZWgEjT4P1jm2d+XfcRrKOB0/AZFbSgKcMxwj1mVaG
	 Ur45X+XgJaOmQMMzHuHpEft+4UC0IWtpw1qNG/oQ2W6198qhKBVael/RiPL2Pf/hw8Lho
	 XV3p8ZfnCRFZEsf9mThJjMduiLJM8qnS91n9tYQi5KCNihGeCfk2dQSyMC/8nkqXlZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030064;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RuyIrMKPHTrJGXqC7YFRh5T2X9U7omvgcl8NkKCn/7Q=;
	b=CrXMEYnvSN7pJJ3MGGEH34VzgI+KdyZCQfjI3LKv9LuCcKd7pUPXQ+27wlbATXL7a8Kb
	 WI3srIDRGb6g3pk8f9xQRyTEIs8MkE2jd7w39TaTjoLHLyoXsjbOLLaJRY4GO/R5O8ceT
	 TNgNq7gaHdz0lZOuXoFNxnOIqr4QAZpswJzAO0n7tMbTNAWl01IqMk+UxMKQWyIuyNMJC
	 TVZJ9hwMPrDyJZfva3F/suvO/u6/QZI8ITZq9luaCO02LUY0xdDpDRQaFwErz3TXhXNGK
	 FIyrUbeTYJAk3ITRYzQEFhtWIyiRE/bU9KhVmpeVkTM/TYjhvY7GeNSo4lF5L4dDGCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qxwUmsCL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D982B606A7E2;
	Wed, 18 Nov 2026 19:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qxwUmsCL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CAE71F000C5;
	Wed, 18 Nov 2026 19:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030064;
	bh=RuyIrMKPHTrJGXqC7YFRh5T2X9U7omvgcl8NkKCn/7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qxwUmsCLPY11TPmvfUXqUC6xwWcAKgyhEm/YGce6MDI2t1mappmtc1gxTFjtB0fXO
	 7APjrEQtvFWimR1y0bJEtBdkTI17DhGtcz8MPYli29RXwGyUILLHibqQAxuIH8Bqzt
	 D2xy+7zEIYDeGk5mVSqXRiio5cdppHyaQJZVKLMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0573/1756] ASoC: rt5616: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:45:00 +0100
Message-ID: <20261118150031.870690734@linuxfoundation.org>
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

[ Upstream commit 8fc9d353d5371a946d9a9952278b96c09070374c ]

rt5616_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: b1d15059957d ("ASoC: rt5616: add rt5616 codec driver")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-12-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5616.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt5616.c b/sound/soc/codecs/rt5616.c
index 34461c4620092..39179fc75c981 100644
--- a/sound/soc/codecs/rt5616.c
+++ b/sound/soc/codecs/rt5616.c
@@ -1247,8 +1247,7 @@ static int rt5616_resume(struct snd_soc_component *component)
 	struct rt5616_priv *rt5616 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(rt5616->regmap, false);
-	regcache_sync(rt5616->regmap);
-	return 0;
+	return regcache_sync(rt5616->regmap);
 }
 #else
 #define rt5616_suspend NULL
-- 
2.53.0



