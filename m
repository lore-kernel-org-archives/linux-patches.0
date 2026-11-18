Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024364;
	b=KeeHDUpGyHNEjSduiJpNa93Z0kxw/IqgDovOBXrQZkD/a124intP92ngoo9kdwzYCEHn
	 bs4iVk4/rWG1nswLD6xo+Ho7oBgXNuDVJF9KEEsEdmR8yX67dZxxsc9eYxg6L5385WC2A
	 yLzBzoWIYI42ZyLJqw0+fDcMU0/MtDLIf8MMSMbnBuFCZCa2aLwSbm55vjKlUEIJ97Og0
	 jU+MPaNZs02RKIjA2EYJjlUVcx1Qg2j+r9HIRE7Mw3/gDw6lor4QlTr+tdqTTCy7Phcaz
	 Wv3+IKABnDPiNBTv5LvM5ry4b74thKLT0DfiptGOGcVbYZIIfaFI14G3d6qBHaiJF5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024364;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Sjmlu9lbLZ0z0VHxlhjybiqyEPyL/kjyAIk7QZr51v4=;
	b=BkGJaipaZApcrwOnirDE6QWJC135/lwR8hVw8YcU5mGaTSbdCONBMSMEy1Pg5go1FA7U
	 sQwIrI67UHrhFinNaGm42Ip29CY82cm3UfUe/3C60FgYtwpo30L+HGnv3ha0Ax2ac9CJK
	 7+cnRhQJOQ/e+s9gRBBwMhA81UWEV3w3L2TK8jzxOmx99gK7p8Df6/a94hVkuQmceun10
	 8jaqa/mT8O1qlPEKYL3m2Yp44CoM7XlmnW6k6qYhnYhzNRe6fIFqVs6Cn5HP1Aox9gqaN
	 BMVpjZryu+nV6sjaVugxndv9SipiTQFqWC+M367JeLCaYu6Xt9kjuzNVF/FFcc3LqIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DxAVzZcJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32911606A330;
	Wed, 18 Nov 2026 17:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DxAVzZcJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836021F000C5;
	Wed, 18 Nov 2026 17:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024364;
	bh=Sjmlu9lbLZ0z0VHxlhjybiqyEPyL/kjyAIk7QZr51v4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DxAVzZcJMGrIKSce2WfDqWJDhmscbpMJQryGwIsXemIVQNqXqe8dWdY/puO6jz/pE
	 1aVsR/rkkJNUUIOMQyP09LvYVdcpifzm1MjTHfV9hptas9BRUkx9CCKlWx1TWUbARq
	 DjHAu39RBZTktJlivGqgAay7F/svuQuks6JkvwjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0700/2151] ASoC: rt1011: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:40:35 +0100
Message-ID: <20261118150147.276466434@linuxfoundation.org>
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

[ Upstream commit 432734a00bfae17baeff1a83b61bfc9c2ab20c12 ]

rt1011_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: d6e65bb7ff0d ("ASoC: rt1011: Add RT1011 amplifier driver")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-7-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt1011.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/rt1011.c b/sound/soc/codecs/rt1011.c
index b84dd18ddde95..122462b9f8bf3 100644
--- a/sound/soc/codecs/rt1011.c
+++ b/sound/soc/codecs/rt1011.c
@@ -2099,9 +2099,7 @@ static int rt1011_resume(struct snd_soc_component *component)
 	struct rt1011_priv *rt1011 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(rt1011->regmap, false);
-	regcache_sync(rt1011->regmap);
-
-	return 0;
+	return regcache_sync(rt1011->regmap);
 }
 #else
 #define rt1011_suspend NULL
-- 
2.53.0



