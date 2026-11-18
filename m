Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055354;
	b=uu3hgqYJdy+beAax6OsFYFV3oM3OvAzJszIxQnlR15IYKRXABlULIL6l2AN69km+fSYl
	 gcEqSsUb+6YttlUE3i7FeH74ulq3EO/213PaLhN+eyRqbsRRUX8yzxMDnKxzLJcxhDXlw
	 6Yn1svPY7RCQOylQ+W6zv50FlSDtWUog9/2WdRCetJ5ghMdmYu0SPR4gmAuteyWt9WGjW
	 y9uBnhfbzGbrAnYJq1I4CwM4bnE6EqgHeIaom4z9W2Wwialy1nAqjaSmZkVOCnZ7gwFeD
	 1uwKjOZ2YzY0VLS/F1s6fTNuc0au0xgyS8xji8d4wV1oEL2IzSI6lN47WzwuIA0VQ9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055354;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UjROYTaE/SkNmuYuLFB4pMgfEkvcXDgjzF4tR3IYyjo=;
	b=nHACUZXj34J77hIj2M3J4JKUW0N6uJrWIgqV6q2Nr/TUplXfOgSwCw/0HkSX5mvIS9o4
	 dUjwKE9Z61JT1195K8sGyO5Tt1+EcrwZ0LzK4BQSgbcq3A0HMeGiwyjrKQz+j6/Rwla0u
	 I7LtGkO4CVdKKFWqG0t1IXY4wIiY2fPjrjsiz9epqjLGBr4v1VIeA7xnJBlNHgpcjqzHT
	 1x5Gff7HUhgnYRgj3yXyAg54lkL/3LNjCQe7Q3KMBtvug073IlPVE12p3xkd94mm6p6Zr
	 yZ45PQVcCf5r1yCSYJTBJD2uFXMsHNEaVqTxEgXiHjk2bf7+YOWQa2Uv0W7TouYXd7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="rq/b0eAu";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8E8606A320;
	Thu, 19 Nov 2026 02:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rq/b0eAu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F6BF1F000C4;
	Thu, 19 Nov 2026 02:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055354;
	bh=UjROYTaE/SkNmuYuLFB4pMgfEkvcXDgjzF4tR3IYyjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rq/b0eAuQMnuuRvaxalW2YfvMwEaI0DgX2SdNShRr4olpXdsh98fhIE8McYTG7B4O
	 bEwemlw5CxnWtBch5MVphJDMRUIIXbyPWm9QuJUJ0R7B+oMVdzGCYk5DyOCEIgRn/v
	 9kM/6UsvcDTkLu0pyGSL7GP2npO4o30xpTIEzHlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1602/2214] ASoC: rt5616: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:54:38 +0100
Message-ID: <20261118150116.053713177@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index fd0d3a08e9dda..52408f24a494b 100644
--- a/sound/soc/codecs/rt5616.c
+++ b/sound/soc/codecs/rt5616.c
@@ -1250,8 +1250,7 @@ static int rt5616_resume(struct snd_soc_component *component)
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



