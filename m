Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048600;
	b=3GUISm+3URDQLb493MibaWFU/Ly15JQaP137yWeWttqYsltP89fBvxMN7Oy7KCct4lrv
	 S+OM5O0bZDE9sagcOq+8EtPGP+TFp8X5drHKnCoIRMc6Abuh5DkzdmWavpSypd+Px2zhR
	 22bcST4zinMODWNtr1FUr+Zj58RY5dIosT4aViZdaoGymehwgryogvLeTxybuAqj2MUiQ
	 qkz52SA/znfjk3zsmzmR/BUc4nT9otW0K7rC1HcCF3sy7+EdY8HEEC6YnOj5vY2t9dRuJ
	 6DsO6HjfrlpA9z/ETpNjKxdbdhupIPqTDrLgMyrsl7PU2C/CoXeIHWJXHdIiLz1r+Bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048600;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JH56nyPy3RQ4eGotmDdyuHig3Vjbxfbsk3hbkSHS/bI=;
	b=oj9WlnGLjy5Y2cwsgMwOIKnvHErQnxTg3tLv6IqxtfDG+J8Qp4hdpY7sy/FFHsf8FJ8I
	 ZRmShnlLwTKdlSuxoTPEpx9348Huyg+N/LrAegbmDLX6D07D7X0BzGIWV0MvDjrx15eb9
	 Oz5j0b6jRmECN9m6DZO6Sz8oEdEZV3XWFedMIx3K69cVdaiggURS4V+AJdLi5KtVUDeHL
	 4I5WJ7y0LPo9+lXjTAyk4JcxHZ2WmjOZCTWKhFBLu5dj46oBo3LedFi99jWKm/Acr2GZh
	 fU1XQQP+l1aWM+dKcXzsjVFxKUKuzCKYU41RorsO6+PP2wFy+NQGWonNcxhxORV2PmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zfWAPKDP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136A0606A31C;
	Thu, 19 Nov 2026 00:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zfWAPKDP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68FA91F000C4;
	Thu, 19 Nov 2026 00:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048599;
	bh=JH56nyPy3RQ4eGotmDdyuHig3Vjbxfbsk3hbkSHS/bI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zfWAPKDPW9/B7y96WauHJvFOL2VMC32wf9gDxHSO49FOm221xyZNKRnsBeR76mCjd
	 mj3oLb6VJCPmM1l9L1bY9kDZMsneemCEdCf44QUsC8PtxbUJNgi13C1KHqp454qdb4
	 ZzOsQ+PtsRWHcfe+JsyNkweTX8aInAeeE1M3otd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2052/2857] ASoC: rt5659: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:51:26 +0100
Message-ID: <20261118150315.303846739@linuxfoundation.org>
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

[ Upstream commit 3a9b5bce85a1baff95463a2bb021efac64bcf83f ]

rt5659_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: d3cb2de2479b ("ASoC: rt5659: add rt5659 codec driver")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-13-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5659.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/rt5659.c b/sound/soc/codecs/rt5659.c
index 5e21e3c37ab57..e7567140406b0 100644
--- a/sound/soc/codecs/rt5659.c
+++ b/sound/soc/codecs/rt5659.c
@@ -3705,9 +3705,7 @@ static int rt5659_resume(struct snd_soc_component *component)
 	struct rt5659_priv *rt5659 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(rt5659->regmap, false);
-	regcache_sync(rt5659->regmap);
-
-	return 0;
+	return regcache_sync(rt5659->regmap);
 }
 #else
 #define rt5659_suspend NULL
-- 
2.53.0



