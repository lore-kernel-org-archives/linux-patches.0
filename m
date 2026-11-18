Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030048;
	b=ojO8JOqTEFNNbbsTyzz6z3zLphFSk+t+T29A04qaTOtysUG5j2j3z2PctofMyzMqa20m
	 Pdj1LBI7QIrLG8dFoHVa25naSCRH5S1cGBxPoPXoX6ZHFUIItkqWjR1206y7aRrXmAB0w
	 xMLINEpK+GqKopMRDUb1n565qplFrauolyHuhA2FZnrIYoJJTDmKBLcWbAX78gcfg2Sxi
	 y2d+9OPb984DZys2TEopcPh5s272B1PUPpw2sizfrizLrQ/mSK4ReEmNMmyI9IqjmAO7I
	 yv8zIwYdXRvAA4iJdgoqJML6ruKUlpy48QQqmnvCaHVenoXH0vesAxPFSnm/UFSmmZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030048;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X3wf3nS0U7VIoQzC0bmVkjLd+lrwN7AAUgQpX32Xe9Y=;
	b=O5LIcCO1kcHe2zphjPBh848BxpnqgsUBMOzj3Nggmoa8VjK3CeL/IRcUcY1n0H8fbK2Y
	 9Mx2bDZPxnMncSQ22fQcElllUCSR4pMPAqm4nzxQMVByfL2TTUxfVQCk9dfpt+Ycai7as
	 Aaq4bkmT5hx6Dt+0+hA7zNZUK4WnkMHB3qbxXXdXrHZLuo3fYgmlhfdF51uLEyyYUqXyy
	 NIPCun1xOkf4+pESOjqyUbqMRvU2XnuJwAXmYtUA4wwi+RjV+qj0wUW0SBYNzefA96dLx
	 gHch45S4SsgH4J0VnPGbjkDqw7Q7dvTDp1xwgzlsrvmtwyQcqLnffjIc9AYSG3YVmyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yj4FOq8+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44BB606A331;
	Wed, 18 Nov 2026 19:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yj4FOq8+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B28E1F000CC;
	Wed, 18 Nov 2026 19:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030047;
	bh=X3wf3nS0U7VIoQzC0bmVkjLd+lrwN7AAUgQpX32Xe9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yj4FOq8+Mch5+Xluoy4R6wcX2kddU9NSRlgy2R0Dlaq1b9JK6GebdSJCP28ZPdY0S
	 MN/7rulCIj+V+b9zwS3NmHYaxF+FFvn1Tj5+JYdv4VhihUAQhQdGJbDvsQNFPIGiDs
	 JADXUBWLgJJwOzpJdUIAHERgJD9t2qxI4mCjCuDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0567/1756] ASoC: nau8540: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:44:54 +0100
Message-ID: <20261118150031.642587409@linuxfoundation.org>
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

[ Upstream commit 0bf2b3411537e8e4d9c03702646a9fc87198d4b1 ]

nau8540_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: c1644e3de45d ("ASoC: nau8540: new codec driver")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-6-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/nau8540.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/nau8540.c b/sound/soc/codecs/nau8540.c
index 7e59448e7ac63..8d878b573f5e1 100644
--- a/sound/soc/codecs/nau8540.c
+++ b/sound/soc/codecs/nau8540.c
@@ -897,9 +897,7 @@ static int __maybe_unused nau8540_resume(struct snd_soc_component *component)
 	struct nau8540 *nau8540 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(nau8540->regmap, false);
-	regcache_sync(nau8540->regmap);
-
-	return 0;
+	return regcache_sync(nau8540->regmap);
 }
 
 static const struct snd_soc_component_driver nau8540_component_driver = {
-- 
2.53.0



