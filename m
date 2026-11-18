Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048602;
	b=jl8YQ4KOco7noR5u9W349Pa1idOqOfFz9hMw3GrFY94HF6VOeAiKQyWsUHKW71bT5nLz
	 X4Mg3G0ZuKNTpk10d4Yw2HORbVIuq9Ozxc9BBpoDgfNzVAis1J06H40vCYUP5kTyCmSl+
	 ZZlWMTuP2w3Ys8feV8rmd7nDp5mDGjWHHiavB/OOfs+vsFvFiVm4r++sRSYVjPrCPwYUY
	 gsobazbETBd7fP2+N8biuli7kL1LKvi1drGvK4sZ+OB9eCpa8dgCv6uWT23n4I+ccwYu4
	 9wS/wWbdlCmIAT+t7DCo8kdg8cp/nISs54yYAFhes0dcudX8h+DhsmbxAN122UCgcbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048602;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=080DOu7jcQ1wR1JivJdxrnTxy2vwvtOTGj5meWgm14I=;
	b=VC+qHQckWN8BnKfJzcNZJlSdd4irYSCYjI6n49zZlg2Z3hZ08zQjPiC4O9kuQ9NYCqRQ
	 YEmZXIRsyDgDi/1JvCnK1hrKweU5RMTh77Wk9PCaJL0boNZoyEJ9R7o7EsAA+7oUUTj1n
	 9TNxUTf7IpGz7Wy5WEfWae8xMdjXmCbI1IP7LyDPGsKxu7hMD2Y0UerekuR/GrcjKEy3a
	 BFmuNV40/6fhUQ1MjglaIyaDKiiZ1LaXVxPttIKcPc4KhnEcI7DBcD4kwfb2J9/nUIIEg
	 75bgt2hWIlyZX+AWBRXUM6WIYm2a4yCyKjuvXun2f+QU0GoGJMyyg85toyfWqn7bZQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e6CnYAHm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3BB0606A320;
	Thu, 19 Nov 2026 00:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e6CnYAHm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23DCF1F000C4;
	Thu, 19 Nov 2026 00:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048602;
	bh=080DOu7jcQ1wR1JivJdxrnTxy2vwvtOTGj5meWgm14I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e6CnYAHmBLIoplrhwdy3nMKaD4IXOgY7qEb6B1oaFAvKXXXIzHMZBKVq0nKBVhZDs
	 bRaS0EZ2Wr+p6xUm3So2VuFMjyhnnYsjHDcpMZ9nXq5oXcr2BKKrFGB2b4ZHDvDyhM
	 bKiYtZrB77wQsI+0rDg/SD6ED1kreDd7D2pS7wfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2053/2857] ASoC: rt5660: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:51:27 +0100
Message-ID: <20261118150315.338853443@linuxfoundation.org>
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
index 341baa29fdb18..180d5f13b3bcc 100644
--- a/sound/soc/codecs/rt5660.c
+++ b/sound/soc/codecs/rt5660.c
@@ -1152,9 +1152,7 @@ static int rt5660_resume(struct snd_soc_component *component)
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



