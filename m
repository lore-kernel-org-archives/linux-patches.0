Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024369;
	b=JHF+/P6Z7sQCLkbu0ji4sXl1BcKAssUMEvy/PeWAqwe0j75E9iJOFbg1JfTxyHCWA3kJ
	 gXw4BZ9c3gtIPrUaJV68ov5tAJQDWCZnJlw0FlH8lTmuDT3sEfQ14no3hqao/uRMB8jhg
	 ob265wrlQVkWoTTd695BEimNYMou8+geFjRBELc1QPrTYtjCB/FcEIoJvv+HA9Qo3DClt
	 7oHkH+vFvL/feN3B7WhYeKWpTqH3lKgV2q/GlPc2juPvgjW5g5LCJBMcXuGOPDQOoApVE
	 KYObFEsRDkj4xERDrBj+6+sOqqJs3DXe7xbh3zLFSIclEX49RynNxrKedl0+xwiYUoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024369;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CNgiwDNyYzqbsVvIbPo8pDjPwcXSEYtp/d02NLoL+/w=;
	b=yUqL2go28JnRYbF3FZUWnnRtEQbYjKiT38cKUPwTCvqLb9Ow2d40Ya383ki6rK4/G5OY
	 wCmf1s0J9Pn71E36hnPqCnZWqI8XJci/8holuTY27dBenAkg4ftrMLeLj1M2wvAQzjnkv
	 zZ5KozMPzcNNfvQPF9LA7LOkVfN4e6Tz89+X5VLyi2D85NTGGRTxze/hsK4ZSYkciQWut
	 lTU+M462e/9gYjD/Nud2yX+fWYhxYzU3QoXI7ra5whforQSI18aOezMF5zxWh1LI2DzhA
	 9loRjkBZOkP3pLFev0Le5ELG2ZTH6EpafPuK5W6zSnAp8OOxasF4n5SLhFbWSn8kCuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vOuj9LgM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0BA606A320;
	Wed, 18 Nov 2026 17:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vOuj9LgM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED831F000C4;
	Wed, 18 Nov 2026 17:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024369;
	bh=CNgiwDNyYzqbsVvIbPo8pDjPwcXSEYtp/d02NLoL+/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vOuj9LgMnEcrhnCIz3o/aBavgBC8abefUt205qjv9H7XTvx4k6bmxchfYIwkR+2Fh
	 OM0xg9d0VATkkfQEgE/CEgt4XwCfsgGzIJSJlUZIXia9c8cOZWOrDsgwXwMKptkX5z
	 qjLcxY8FIE/YuMp808PeGLZqDnyYx68IJsKx/Dag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0702/2151] ASoC: rt1305: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:40:37 +0100
Message-ID: <20261118150147.406053170@linuxfoundation.org>
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
index 26b7382f97ef6..df947e145dafa 100644
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



