Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055465;
	b=wl0j41Xa/VxGNVotCfPETiC1ff/3aiZxzIvffoJ3Iw5DW/B0uYakdlvrtMJG6nWggHES
	 NlAf1wvGuEoohV/NKRAu/LJPaai/+EA464ab7FUXzodp5v86ST41r6up5g2SZehGSG0Ji
	 t7LyK0erHUZiLGrpvmdxMJkZlqLdAOc4bcrlFoPUktK5xfcCzzeELY3rtty9PBzcTbMSE
	 jF1eRr5jSbpshM75xu3dewUSqp2nYN23ezWPFMspxj/4ZbruRJzd5fk0n8Tw75rWuihfx
	 MXqQ8Cw1ARuncPnAzmaHGgKr4qD4bCx1BTmynE3poJFQVM2HxE+DFUYXfcMpqj6+xWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055465;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AvdbrzSpolyUhKRc4JU3QT/dD7rhiziUvn4ZfhQLGxc=;
	b=2xmNVZceIphKBUdu4nExxFdaacWmfaZHkvcaIq6SLl2E1snm5Hl9D8zT50kmhasDeq4o
	 9MQIcgB5uigK8OJk9LrfB57FAv/0EUjlr460KiKJlzDymW8/Nz5176/rgcF6oYq6y6frg
	 8GK/Alx561Xn4+pQ2h502SaZ+Ip6lrKHu+yvuQFMoKfWem3Re+ItVAzQwDAbbcMQRw1Av
	 Dk1genZGYvJIxOI939lyHOCUQyaBZsgep6u5M+fEQtRLz4Z8JrQgqD5rLgo4tMxg8gWMh
	 kLPFOH6945C9+YKIljY3IZXtLsXGrvXdgT3dxFTvM4Jecxdkr66G5WFyMj/y47DewOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="KHZ/LmE4";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9BEF606A31C;
	Thu, 19 Nov 2026 02:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KHZ/LmE4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 032901F000C4;
	Thu, 19 Nov 2026 02:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055465;
	bh=AvdbrzSpolyUhKRc4JU3QT/dD7rhiziUvn4ZfhQLGxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KHZ/LmE4mC7skeuDWx6gbRnoB4Q7UITKEucH2PbTuTeT4+btSKu1+lBpKoxJleHgA
	 FiXoFbJ+rpsNsqC7OgZZJx6eh3+TI20p5DXIoKUl0JzbKXeeu0Qy7T93/J7tjQRDQi
	 AKBCq7vPaCRcVJZPjGNINvc/hxthzPYET6BP4yFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1600/2214] ASoC: rt1305: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:54:36 +0100
Message-ID: <20261118150115.975510556@linuxfoundation.org>
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

[ Upstream commit 30858325aa90380c6bcdde605214f1ebdbec568c ]

rt1305_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: 29bc643ddd7e ("ASoC: rt1305: Add RT1305/RT1306 amplifier driver")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-9-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt1305.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/rt1305.c b/sound/soc/codecs/rt1305.c
index 7a0094578e467..f0207d97a07e5 100644
--- a/sound/soc/codecs/rt1305.c
+++ b/sound/soc/codecs/rt1305.c
@@ -898,9 +898,7 @@ static int rt1305_resume(struct snd_soc_component *component)
 	struct rt1305_priv *rt1305 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(rt1305->regmap, false);
-	regcache_sync(rt1305->regmap);
-
-	return 0;
+	return regcache_sync(rt1305->regmap);
 }
 #else
 #define rt1305_suspend NULL
-- 
2.53.0



