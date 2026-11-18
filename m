Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055462;
	b=YdvSlVxpUzKzHU0iPmaZnZ3yUxK6GVY8Eyz52CslXspgZ5wculfzkWkW7ZAIpHXxVqkZ
	 V6H1sBYCgetarnr8ZhqAp0vWoW2q2vaipzHFlZcm3N05R7zt1Bi3k6xLGmdglGzL+AzZA
	 e+ehSDRRvH34uGpo7PD9iv2xM6Jb9sGWSQ7NkvIYuV5ExbsE58CDOlqpQUAPWx5a/s/v6
	 oiP+6JaUZ10TGA/gg4J55COeUPpfwQoiUBw9rtq9DvSZMkfl7Czrv2TGAXzHW7FyJ6vZX
	 fk/BTMPjJc7uqAytm3JhY2d0R+do87nxmM+ZuFo3M+MqVapW8gLXqeel8y/Zbi6rKxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055462;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Huc9oEAJwD6VD3bZSVzD/W6qKakVbNUblJe1gpehG6A=;
	b=uaUSr8AHMJJfMpIsAwEzzbbA3L9xvE8qESC42PNoQvuCA7Sx369iAF7QhWjcLeEErGe7
	 I4QvtG0BVli0s4f06i+95/m5xfJHLzqNJEFTrocoWp6HB+1DUuRCBbeS3ndRR/tLR0QuJ
	 5+BsHsxy9hoEnt/k2mbLHudog28PF59OBkZlxTwqHh5emB3FcgjMVCpgkLugHYKAVGkvl
	 nfNltAki6TZihqCymtiSvW23hsEvmGg5TfVX9jK0Wr+NS6jXW2Lt8fOM+NygF6m5ImNP6
	 13aAzIJ6OI8EQGF0TnUxvFTA6f8+bCc6hyaa48HAUy/hRFG4itC1qI61N97TNwfYSKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x2UnTBJO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C408A606A31C;
	Thu, 19 Nov 2026 02:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x2UnTBJO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB631F000C5;
	Thu, 19 Nov 2026 02:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055462;
	bh=Huc9oEAJwD6VD3bZSVzD/W6qKakVbNUblJe1gpehG6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x2UnTBJOohcif/c0xk3xgRvawB6KqqZ8FDVz7FSeJ58FWu8lyXx64EUuYW27ywA+3
	 KAsYMJJkf79Cii1MabyAo/6hfbKO8bYV83KtvYbtDnSFFdCSvtpEQC8vO2k/zQek8S
	 2o5K0ozSkld8qcQHvC1s0/aZIj7Swf/HD8vl70SU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1599/2214] ASoC: rt1016: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:54:35 +0100
Message-ID: <20261118150115.934184576@linuxfoundation.org>
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

[ Upstream commit 98ace05793c7b80a9f49d92b78fcc88e0970f8e4 ]

rt1016_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: 79a4b670b4b4 ("ASoC: rt1016: Add the rt1016 support")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-8-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt1016.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/rt1016.c b/sound/soc/codecs/rt1016.c
index 7561d202274cf..1f31517a076ca 100644
--- a/sound/soc/codecs/rt1016.c
+++ b/sound/soc/codecs/rt1016.c
@@ -571,9 +571,7 @@ static int rt1016_resume(struct snd_soc_component *component)
 	struct rt1016_priv *rt1016 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(rt1016->regmap, false);
-	regcache_sync(rt1016->regmap);
-
-	return 0;
+	return regcache_sync(rt1016->regmap);
 }
 #else
 #define rt1016_suspend NULL
-- 
2.53.0



