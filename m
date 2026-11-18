Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055468;
	b=myvYtUZHVqm9uD6zLC+JqKYwufZYfk+yIvBRKfNNmdSCpn1C6rjJ1LQpeHPAYQAiLF01
	 sdkeQvSs9MvvO/qw1IzSAz6S5mESwiOTElTiHMVPD1GnI6bDySf9WSsGNeRka/pKZGufR
	 Zfv3DCgYupmFJWP+SbuqUs1i2/PbQo1T6tjtRLHg6oGozdeg7+F3Y9ZkTpFqxyfKFK1iV
	 OHRxP1fwplJTx0t6oyPl+N/gc7l5Ly/hlWit9nx5l+0ZyARJkz6KtvIlY4+YrSR7/JLrx
	 9CTCDt4d3loF8kvsy1me39a0lo2V1c9D41/Y2hUojiuu4KDPTpXKeJwCjLWm4RyKuaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055468;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yEdmAVeAWiB17Kiue805YQxVU1MDYc11m5lKo4NZ6rs=;
	b=btnGGO9xgkfhu9pPYzLa4WGMTrwHMVJTzbvNp0zNa5w/YIqgxlCxK1xNlqfS9aEztvxq
	 yPKPrZ58Vcut4m2qvn0JWMbJUnVarp2ZPtCpty3/saZbdaKcBzxnLMEfZ3rIkzkpe6GMc
	 Ztwh005Si1ENer9rrfcLDz9Mo7PIvGEKXq1vmYlZ9nKSTV9flPgaMHvqL+wU9Glv89VzY
	 +TSNtLxR/BLEM/u7Am9qd8Tn2lMm5IEfQQOoJiFodVoaAbviqEDBMOmvru2GqOVV9jSqg
	 3YD93jtmCtWfjFKOgYa4fLJcXi4sMqS1rMSvFk/+eetYp0Le6+H/2PX6u3lt+ffm3VA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="avVV/CUC";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB36606A31C;
	Thu, 19 Nov 2026 02:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=avVV/CUC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C01CF1F000C4;
	Thu, 19 Nov 2026 02:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055468;
	bh=yEdmAVeAWiB17Kiue805YQxVU1MDYc11m5lKo4NZ6rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=avVV/CUCCoxU0WOnClVupSh73EoPxU1wNQ67siMTzpKXWiKYil/P6JkkCxmR3JIVe
	 0kuGO/RfyqfxMeHkbtUcd1UEBvEDyWPdhbMgXrxYl+AAH0ELvGrByINSO7hLnwq7y0
	 mU/0LthFgkoss6trHEJr4p6pMOkgNb7oMSe8wBgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1601/2214] ASoC: rt1308: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:54:37 +0100
Message-ID: <20261118150116.009323316@linuxfoundation.org>
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

[ Upstream commit 3db3289178b94056753f7a8c6ee4ab4b232ee6a5 ]

rt1308_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: 2b9def8c0d92 ("ASoC: rt1308: Add RT1308 amplifier driver")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-10-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt1308.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/rt1308.c b/sound/soc/codecs/rt1308.c
index b4e5546e2e217..54cea885515f4 100644
--- a/sound/soc/codecs/rt1308.c
+++ b/sound/soc/codecs/rt1308.c
@@ -717,9 +717,7 @@ static int rt1308_resume(struct snd_soc_component *component)
 	struct rt1308_priv *rt1308 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(rt1308->regmap, false);
-	regcache_sync(rt1308->regmap);
-
-	return 0;
+	return regcache_sync(rt1308->regmap);
 }
 #else
 #define rt1308_suspend NULL
-- 
2.53.0



