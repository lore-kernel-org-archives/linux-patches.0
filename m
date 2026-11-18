Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060863;
	b=NZ1G2VnMWZWaLkfqYgs6jlnct5/0fkGp3iWGdKs4FdrIC7yMdwANLVr4PA+CKctn5PbT
	 6HxKZaZ3zIBg2+tzEy3fB2LB64bcNN+kx5FVbvapZ6iYsjOuEEEWDdYK/pmVNgZsKCrts
	 TLkwRO+Z6cJDyk3mdg5kB9nC9KHZxluTHCPJBPnFktbNj8YSQjkP/vZ7vGJ7+yjHLKLBb
	 KGwlWbl6CdtWi4hEZCyspTeGXarDfKN90b79W7qlo0z3uPxjD4QTY1ZBNjqJcttElq8tm
	 TIL60PXY/9BNYwekviTD2tlPtYqXOO7NiumYjWA8T+63eu6Nlm6lVJCn+Kj4BwqGMQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060863;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oxCq+yrjLPgbKDNJsdt03ztFj0zd26JrG+nOsbFHdtI=;
	b=JR38dBg14Mk2f/7mNt6drLAtsN7A+GFaAXqb8Ts36IIZXb54QCIxX/mjWSi/sgXdcoDx
	 VJwo7jIZYp/vqcubdGsZzc1G6ESLwmiL2rUg4p+pAkRV0yKpgmKVAnTTrl9j3QlAuub1W
	 hbajGzanxKPRoo6Gnz4Yfc90I8v9KS6ax6+RWHxqtTMzU/gTIqPmvdgxNgX+H2AoUzsOb
	 yRSbmDfN+1d+h67U3/5GEB8CfeyhEoOG43m6E88zMAzZpQuLkWdIvAAcAF5dFdATbVRkp
	 tatnF+r+WYowD+4Lecp9+l3sgAyR9XDtAaxIoLye7CyhopCxtgqZQheKOoG7YM0Jzng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aDyp2C7l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B87E606A325;
	Thu, 19 Nov 2026 04:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aDyp2C7l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF961F000C4;
	Thu, 19 Nov 2026 04:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060863;
	bh=oxCq+yrjLPgbKDNJsdt03ztFj0zd26JrG+nOsbFHdtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aDyp2C7lKry33Kn6oUHTE87WMSOH66oBxrF1OHaA9qodXwb8paz3Zf88F6gMuK81r
	 fEgqQtKP/dfO5MxcvivaM2okpVtgF7870iYyuuyl1fmp9EtJ4IwkyIYNk1Hpc57aRk
	 dpOg7NKgE0pWkJEbKyuayjKZ0z1QIlrmKXHMshdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1351/1848] ASoC: rt5660: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:56:29 +0100
Message-ID: <20261118150016.202052665@linuxfoundation.org>
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
index 9e3813f7583d9..a4fa998db1bc8 100644
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



