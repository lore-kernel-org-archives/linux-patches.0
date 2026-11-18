Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017191;
	b=jCyk3E1prmc52R3FAScy/yAxiKa0P9lgT3+YoW3trpm7AKwH0C+vT4vn0dMFLWkKfDRZ
	 7rIFJOVk+nY55Jp/9fh1jF7wcdpeidXyjHg4p+DwGIrTlEQcE9+mAH9SLidBAsRBSI8d2
	 MDGBfTvzdH1S/yrhDCiGX3myU/66ChDwREuJLg73j5dnXpWarZjdrnGd1sqds+QKREeik
	 k6y3phGXGNvj4ifGC0iiL310ulzJc8619bAf+fPfHPlr3Dr1ArJSSR/ikw7YOa0DnQlnG
	 ArD54a4yT2NkK+p3W3S1AGkNAmNXAO6I8sjN4HAKEody4aDF2wE2ZDUP/jnmvsfJCMg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017191;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OXLKCDZu5MPGmDKcbgGObbsk77RHRVwqEXeQe6ZkNVU=;
	b=ieZcbn5pFEm4PDGqwN+d5EbU6xnHgfHudiqaDWrfDi4gJb6MAIntg8MqdiTa4QMYcTAx
	 YE2BIQdtuDVlwdwKMhv5lh1LuR44R7tzKY7Z8Xk9xZvLJ7rqhZo/LUIjyS26hzZZZKHMt
	 r8lcpZjkT9pc7/U/3ssmlGuxi67/b5kDpRu+5OcUw+wIwMQOlcImJjWbdscWxwRDQq0pZ
	 v86GkdbZRr3LrGC0F1pJmbybeLBKgLbga03PoihoHmk4JXf3/Mp8P1ZmyU6QLz2ZXD1cO
	 4LkQTin9YqR/HrvuCe756Ig4q//bWCOTlIiBGSfrvaFFS+aEZ6rCZS0kaq9n+qw/VZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oB50r9ll;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28AE4606A332;
	Wed, 18 Nov 2026 15:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oB50r9ll
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B0BE1F000C4;
	Wed, 18 Nov 2026 15:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017191;
	bh=OXLKCDZu5MPGmDKcbgGObbsk77RHRVwqEXeQe6ZkNVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oB50r9llQu1syvBkjd1FLOPz+qMRyeSnW+NHhveWMUgJWxOzVzAWrxQNdRFAqLUV1
	 t5wE+TaPZBfeDCZeP1vItd4KRiMa0iaGh+ohpsVEwYnD+dUT0upZH1n8AJjQgk5enu
	 0RrEFOIP482RpRnOTwCxYXdBRiiGlPLBCEw/pD1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0797/2651] ASoC: rt1305: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:33:57 +0100
Message-ID: <20261118150316.570637742@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 2d5fad76cf528..601cbf9eb1e2e 100644
--- a/sound/soc/codecs/rt1305.c
+++ b/sound/soc/codecs/rt1305.c
@@ -896,9 +896,7 @@ static int rt1305_resume(struct snd_soc_component *component)
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



