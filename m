Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030070;
	b=18SnC6lQG8qpopo8xKxXZKa9nrXvCkfA7HSEcow2GLozdBycMYA5q0W5iIHNqZ1ALsu7
	 QvbM6sl3tZ8LikAVYry3//111baO5LZAoO9zqC7OHV8974xKo4JGzn13W24vm4FsHhFQg
	 E75vHH7AElddpcexppvqhqhC4M1nnyZSTINvFDNtObQP6bxl498LYOVo2ayhuEdtPmFY7
	 acWLvPqu5vl9VNxWzLJRAgWnO42Hrzymfv3AlkoJ/W2/aTaDO0c9cXbRqbb9LDshcKZvb
	 GDXWu/lZeAZ+E39qaFs8SlwEXZC0gGzar/sOdq4Dl8TuboiITwELwj2NG0Pawcrd7HQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030070;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D+MNP/T4WK3kdoImF//ZIYeq12DphIDkvNNGDqIgiG4=;
	b=nGLszhwZ9tbqk4/BlgjjNmcJzuJfyOLyhVPTh21/tIbJFJoYpcBujwTt1s4Z01PDt33f
	 SK91KQOLoXUhML3yrIl8on5dzAcdiK7+h82ZuyHFM+Y1jnmJits3SOKpJIsSy1vU2wQmT
	 /EI0To2fo1czQn6HvglY8n5ov4q9Ph2YNc2/j6GTya26ZN/oFztBhRNrmSXXqdNp0rNoM
	 ha2DwbqMrzQRMPIKY1mBds0ndIya1bFTQeRBl0EteCWbf1hBeExc5Q+xkKpv8MQa0kOjJ
	 LwhcIAmawiaGShlcI2Av62jbltbw82CGcp6aaIcU6qE12bUmCriWEedvLHZWdRijzGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q99ezmfK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB47606B123;
	Wed, 18 Nov 2026 19:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q99ezmfK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C48F41F000C6;
	Wed, 18 Nov 2026 19:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030070;
	bh=D+MNP/T4WK3kdoImF//ZIYeq12DphIDkvNNGDqIgiG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q99ezmfKu+43+60l9D01k/iFX60EyIHv1obLpXowYr9lQvq/5IwURDVPvgRoDxBe9
	 t1/yh4iF4dtvvVi546a8V+Lt+4/sueRMcHcVisbZaXNJHScwWApwkO5wlZzK+F+0vD
	 pTvXuy7tDTowPmBCQP7+oA6MSWZC/CShJdir4fsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0575/1756] ASoC: rt5660: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:45:02 +0100
Message-ID: <20261118150031.941005132@linuxfoundation.org>
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
index 3ac41d2c279bd..cafc9615f3039 100644
--- a/sound/soc/codecs/rt5660.c
+++ b/sound/soc/codecs/rt5660.c
@@ -1147,9 +1147,7 @@ static int rt5660_resume(struct snd_soc_component *component)
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



