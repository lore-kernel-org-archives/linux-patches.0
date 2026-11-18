Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030045;
	b=MgbJXVL8gOaA/nwyz1IPAwNkB2nUzoc/yhDSGBObnhWYcGKxaD95qs2JOB5CJt/K81+t
	 ijFqFLQAc9XpAH2ryAz5jRc44IVDPtPaLMQeik5nvtZdnhN0Go20ApSMeZBUaG0djP9+g
	 uWDW5hmvViQjQDzHvq5OAqe22g8uFCF3RBKh6i+c0aofvntruEyJbfsZE94IIdl5a2B8B
	 Lf/99fYmWhlANUfDYfbNuV+x6NCQpb4Yroh8B4xs18WwZCvtjkw9dpSuLoYN/N3Rp0mzu
	 MWxy9ThVZ4QQZERSClS8aszdQmQe/TrV6CmV1bJLIHml/YpWIbDS59bzR0OJv1iwuOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030045;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XEDMiKOIFktsaLJ7z5wSRsmMem3+hzZ4dV5LbyUcUvo=;
	b=LggD0zBZFxP1ArTugMnOZEDr8JzerkatQiDDBvaPS6cLYOeQ+MLmlDGC/z85dr71O87x
	 8WK7Try8dIBS2wG2eGW+nKjPVS6SrYvQGD5iKVTd4pPZ6UWHmiJiH4UzsrP24EoOotz1V
	 L4BUYj9t1if/FTV9xLsYgpccOdwp5DZ+G4oaa00KTKPYSooWfHPSGhMwYyc3fA+ZRYNu4
	 /E/Xbk0zvr1Hw/ZU7DaIrir902vFeLgUGFJ5NdFd8+ayB+QDKls02akbpHAXTuUrwbAG+
	 sgn4sio1h6OG2nVDGqGPSply5yweNORoxOPVNH1hSqxMLnTUKUmNWnFYwMX2lnx4/6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m+LQTHMg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B61A60A2606;
	Wed, 18 Nov 2026 19:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m+LQTHMg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 956C71F000C8;
	Wed, 18 Nov 2026 19:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030045;
	bh=XEDMiKOIFktsaLJ7z5wSRsmMem3+hzZ4dV5LbyUcUvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m+LQTHMgXoAfekQBk7uONAfTkfuWbbytMyjlm1WlEObOkIstKTrdZ1lUGqMUq/1m9
	 nRnzsTSpoqD5n6vbiGVpesEE13xO0T5mcAsISbitaJB3bckYP3l4PH+083Lp2USebU
	 l8VIchj+av4sodDj2x/Fzz16opLNlbHDTWTm9xiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0566/1756] ASoC: es8316: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:44:53 +0100
Message-ID: <20261118150031.604784725@linuxfoundation.org>
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

[ Upstream commit 243d0c47e57a6af89d95aa451ef5fbf453983b1c ]

es8316_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: 4bac47a7b2f9 ("ASoC: codecs: add suspend and resume for ES8316")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-4-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8316.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/es8316.c b/sound/soc/codecs/es8316.c
index f508df01145bf..da02716a89401 100644
--- a/sound/soc/codecs/es8316.c
+++ b/sound/soc/codecs/es8316.c
@@ -808,9 +808,7 @@ static int es8316_resume(struct snd_soc_component *component)
 	struct es8316_priv *es8316 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(es8316->regmap, false);
-	regcache_sync(es8316->regmap);
-
-	return 0;
+	return regcache_sync(es8316->regmap);
 }
 
 static int es8316_suspend(struct snd_soc_component *component)
-- 
2.53.0



