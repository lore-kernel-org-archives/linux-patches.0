Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040146;
	b=R6IyvBAgCfZCD4E91ng0BO8vq+RNfb9jhC/t8JOTr/N7D9Tow2/ZB1SVdKF44Ei7sod9
	 Fli3V/c2sIde1xOk3WjCiQyCv8BHfgaLhZlaAQjPLuZKR5dq1AkH2BGNh/5ehdjyh4oL0
	 ipUouUlAgfC2u+rCCsurhlaJ/DBq54jBq8x+bTm5zylX+HzenSBxcYpeW1GBdjwDyzq+W
	 CV7gcIoWTiuBzGVRNTYulxGiceUMcMLmtpGomf8m0BQlGGu5xvCvE6BJncpKXIHNAJZLd
	 14FOIrBmlzYclnpNdF8P0l33+T+2f+DlaCf7PJJEHxF+R6Hb5wqnlJ4IYL96k+Nuf/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040146;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XTmABVgNQEyVjTKD4DBfWDX9UbSetPfKuzQF1tDJlUc=;
	b=VGr9SN5ESaiS8X9yfCK0YHMKKaPp+7SFVVk92fuo6xJTFVfxLz/wTgw++cED9kP/9jcE
	 aytZXzmMjL672uuVZCBOodSnhKYvm7dt1a4mZMk5fN9caaT6mvLeBkePjCgwbBL1bpGsn
	 iZbsAfucoxGpbE5QAAed6tRju2ZrclSg8Ei1s2Wx5y/Hj996teij3AS60bu+bOx+ymD2T
	 fIpR8z4uI/wPMGWvRWMLBaHhwT7+8xbB4XZHuiIZ2RaFvjaEcII8aajhcrFiII0qkhLka
	 OYrYxHvHh5M3Ev/iwSCBJU4B0885Ojr7Sx8zV08XpRYFAjaHiAJviSKQeEdoJNEveYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sb8IHQ2h;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1293A606A325;
	Wed, 18 Nov 2026 22:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sb8IHQ2h
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69EC61F000C7;
	Wed, 18 Nov 2026 22:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040145;
	bh=XTmABVgNQEyVjTKD4DBfWDX9UbSetPfKuzQF1tDJlUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sb8IHQ2hPwd186USEg5Jtjou8QKNIyaRmA5aOhk+ymPdkxqETdTlJBkh8iLUhntiU
	 TDswVaNh+7llgBmX2GoHe7oU1QK3PbDO/PXNFxm1bTb1EtwNxlq3/xDgVDZVPv6R6S
	 UjEbotfp3tCa5/WYr2Ru5Cjf3BRCik7PrQjeuPfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2352/3318] ASoC: rt1305: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:49:34 +0100
Message-ID: <20261118150432.167689591@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 80888cbcf49c9..2c1ce7e1fbfea 100644
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



