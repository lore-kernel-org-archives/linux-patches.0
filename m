Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030409;
	b=YG/5FO5dfh9/Ccb3YQXp9v56dtQULk4/ituEqOqJI2sZo9CY77s2qn022XnVHoy62jyb
	 un2jAXfVUnY7zYLHG9JdxowI0X58JhHI/cTvwPx8TyopNy6+PRp2qhyR2dUS2i5yCL1xJ
	 puQ26FfGcEancKVlYFvVUABjxSd8AvCAGf4wAYpMBMFuBUzWGDzDPEoRoCKiYvcVltMSX
	 g1FTYif7NF2+6TFlg6/r/34o/OcPWWqIl6ytYD4n9cLMmoeWY4jTomCOpmdLA+1Omhvs/
	 aMRe1DcL7m/6POjKwXNzHKIanEqGPqnO/psB5GUqzi9mnir3GZCz+j5dMjSoVy4eUNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030409;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IDTBes4H2shKkBBUaXVK4ZK+DRYLu62uk1iOAykO4g8=;
	b=MarbIvXMSqzuWFb+TMZmPzqKZFvvwvQkLGJpYTPSzt/KsZaBzbKUzJrIzRvjlx/eeLBL
	 am+OJFHsFzN0lg/IKaOSeqO5TbDmLSJWgjywqu1uglztq2HWZpwyIgj6EgNWkZfp9X3nZ
	 TuPiqkZCUTslqeIP96grTVbliMP8MRH47who66/5RZC/8mq5LwuwXbuKM+bMbzo0JabnZ
	 IXTOrYUwYAg2jb0wqS0upwnlEXYdgzhkGo92oy/jsaQQCxri7+PAVsbhYdMkLHi/dqqgT
	 1m1hHvXcXeNdCffemoZwe4ba3u3TOOwBUI86winQsCXAQprjVXHO5Ni5MCm4tjW9lIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l1i5AIgW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E422606A336;
	Wed, 18 Nov 2026 19:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l1i5AIgW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 960D91F000C4;
	Wed, 18 Nov 2026 19:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030409;
	bh=IDTBes4H2shKkBBUaXVK4ZK+DRYLu62uk1iOAykO4g8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l1i5AIgW7ZcmJ7Kp0crnBRR2GhCd57SN6GzWW+nmU18zB6ywx+poz0pvFxapT4rh1
	 H+cr+9E3cC13O75si+C1Nm9RVEq0a88n7O/Md5vyEVOpCo99lcGDNtcVMf1WtFIVFi
	 jUXk6JsmE6g5lK9Zo7Z0M/goKyRHSmf/dbipAQ8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0653/1756] ASoC: mediatek: mt8192: Handle regcache_sync() failure in runtime resume
Date: Wed, 18 Nov 2026 15:46:20 +0100
Message-ID: <20261118150034.874512747@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit d9e264741b041fc9dffc555bc1ab68708658cefd ]

Currently, the return value of regcache_sync() in
mt8192_afe_runtime_resume() is ignored. If regcache_sync() fails, the
function continues execution with clocks enabled and regcache out of sync.

Fix this by checking the return value of regcache_sync(). On failure,
restore regcache to cache-only mode and disable the clocks enabled
earlier in the function.

Fixes: 125ab5d588b0 ("ASoC: mediatek: mt8192: add platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260918133912.133799-11-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8192/mt8192-afe-pcm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/soc/mediatek/mt8192/mt8192-afe-pcm.c b/sound/soc/mediatek/mt8192/mt8192-afe-pcm.c
index a65e21b19da49..e574f4fb64a92 100644
--- a/sound/soc/mediatek/mt8192/mt8192-afe-pcm.c
+++ b/sound/soc/mediatek/mt8192/mt8192-afe-pcm.c
@@ -2104,7 +2104,11 @@ static int mt8192_afe_runtime_resume(struct device *dev)
 		goto skip_regmap;
 
 	regcache_cache_only(afe->regmap, false);
-	regcache_sync(afe->regmap);
+	ret = regcache_sync(afe->regmap);
+	if (ret) {
+		regcache_cache_only(afe->regmap, true);
+		mt8192_afe_disable_clock(afe);
+	}
 
 	/* enable audio sys DCM for power saving */
 	regmap_update_bits(afe_priv->infracfg,
-- 
2.53.0



