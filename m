Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030163;
	b=4dsJKQcnSi+7jEz2PPXZtLsnQpsOCfuYmiXdiGnhkeYjA766p3sa7CNMl842QalsNrsY
	 GbadbBhqIT4OmtAaXkuokr6Q9oKCY+Kx3ySY2xbuTw9Osp6hv/yvpehm7D2jaI3QVmZZv
	 X0xM98CIvrcQwvNYArXbph85BchCgNXqe5D9pL8Bvu0MJnfQeHPet9pc7ACjrgITHIL4X
	 WQzra6pJ9du+XcSlHweqy/9CrdPuTk29+vg7WLCQJAOl7zqw5Zyp0NW6h7Hac8ger2SyS
	 d6xls0/9Oaezcomxsp9L7XrPSwgwll0iLlWxi5BzB1GU61PVmnFPocvdTE1/PP8D1Bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030163;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o9jNEajuaYZoWt3OK86wW7jkXO4AORY6VaXeBJ2sZ4w=;
	b=Afg4SjuStPgba8HTD+5348SrQPeQ8vfTdmhE2EQb+gmztTOnrzwbbz+aHBEJb46hOr/Y
	 ftNNma4Vfi5Q9C/8di39sA/HeGPGBSZ1q75uL8weUv3MI0+sibD+0fxgVGZEucNrDMcaD
	 KJTS5yxNkHqOP1jWGlHA8aSzvMTIMI9yLM8xU9LssJuHDfqqZNYeDGqYMjeLJJV+iTugJ
	 TTRRjlfr1S2oDZJUAckG10rG3NBTm4kAwIVvv2uLEneu4gT3d2nbl0oAxaQycPao4Yk91
	 XCaajK+tAy8qJyNJAyQJFiY4WXOpDkQB6Utyie3YV5sWQfVHubHHwK4ezHJwBtEpgMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A80BulFQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41ACF606CC60;
	Wed, 18 Nov 2026 19:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A80BulFQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 594C81F000CC;
	Wed, 18 Nov 2026 19:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030162;
	bh=o9jNEajuaYZoWt3OK86wW7jkXO4AORY6VaXeBJ2sZ4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A80BulFQ9x7mqQNd70fKZnX78zO5GFus713h1gwPvrvx9ti+XPoTOCRgwxtOczlH8
	 gRFOhnB2JdiwzKMwuIAKAkOjjj4eb0RuhwTLB1rLOFWqFNBh/EdjBXY/8HoPV7z7HI
	 jUow1n++RZmmBGjgoL4TvD1de+VHsDmAcKH2wrmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0565/1756] ASoC: ak4642: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:44:52 +0100
Message-ID: <20261118150031.568876764@linuxfoundation.org>
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

[ Upstream commit 7142c34ed92fddca7038787b8695d22c661dc6ec ]

ak4642_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: a3a83d9a7cb0 ("ASoC: Add ak4642/ak4643 codec support")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-3-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/ak4642.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/codecs/ak4642.c b/sound/soc/codecs/ak4642.c
index fe035d2fc9131..08846bd7f80a9 100644
--- a/sound/soc/codecs/ak4642.c
+++ b/sound/soc/codecs/ak4642.c
@@ -533,8 +533,7 @@ static int ak4642_resume(struct snd_soc_component *component)
 	struct regmap *regmap = dev_get_regmap(component->dev, NULL);
 
 	regcache_cache_only(regmap, false);
-	regcache_sync(regmap);
-	return 0;
+	return regcache_sync(regmap);
 }
 static int ak4642_probe(struct snd_soc_component *component)
 {
-- 
2.53.0



