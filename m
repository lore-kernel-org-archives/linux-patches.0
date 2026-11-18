Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017185;
	b=hv4nuadfjjShswMKrY6fs2XUnEYMvg5TzuWtpoFDSwoF5Fgqx5ka7KgxTARKBEewgdLp
	 72RWhQhsV9lI5ZpAjoIBgKcoDXHdkzKQXzVw/di/mhS7rgsD8X+8WuUftLG1UpMfu9Lxz
	 SCLQU9VzkM8mtoD+OwAi9cEnPIZp4NAzAnaWgT1jBWvssdiNSnWfv8pKgEvUp2vXV8uXX
	 wL5K74XDe+ace5Hq4NguqoiKtVavbQ2jWTME807qLdCiXlZlMUkDLW4nsLVojC0pCUbiG
	 y8JvNWg4gmlW6Hj/y5KrADzaDD8FJGw7mWmQ30lfCAUOd9FARV2rAQOfkvkF/md2kPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017185;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KGr6d1T+NmvMmbgj07ma05gPIe+2WoOzyvNz6P/gWQg=;
	b=0UvENPRySjX2jnSx/balEZwS+AxSLCgijX3eAvUvqzgvsTV3C58CFRyh6wRBIOkaR4Ss
	 ETnr+69J9snIJ4/bAs7K8BY0M90SmKacnYBDydykDLnX8JndMd2fNsR3umtG+CLpLbb7+
	 dGQT7CLh1JVSxftHST9PJdzLdpIKqQiadahQWfnnCdzYowyqSGty0NP3NXlGGMWTQKvOt
	 H7BlMvQVhsfgRX1MuRd9P0sm7BSatZogZx2EjMPoFlGMz59/VIIuaGVuUcd49++HSgzG0
	 J8Fen7cy+bSJcx/fEEdV/TEumrRvTMmgAFUL/aavBpNcQYYSvNAxD4TpEz3DRMUUysw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x8+iS7R1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B84606A31C;
	Wed, 18 Nov 2026 15:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x8+iS7R1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A311F000C4;
	Wed, 18 Nov 2026 15:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017185;
	bh=KGr6d1T+NmvMmbgj07ma05gPIe+2WoOzyvNz6P/gWQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x8+iS7R16gc83sgEr4Aca8mlUB2Bx3GEaPEl4yP9g+MjegD8YHBK/3yb0E0uXKvhr
	 zwuEwMX2+COaXanDcN1FL5wkxCbtezdPpvXDnl67R3vnTTUbjb/ZS5OIo6O2Gu7C+u
	 RY3zI8xp6FQ8KA3jef9CF0OKM8N4QL+eFLIE9kl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0795/2651] ASoC: rt1011: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:33:55 +0100
Message-ID: <20261118150316.500249849@linuxfoundation.org>
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
index 15488a0592837..6e783c3d14aec 100644
--- a/sound/soc/codecs/rt1011.c
+++ b/sound/soc/codecs/rt1011.c
@@ -2094,9 +2094,7 @@ static int rt1011_resume(struct snd_soc_component *component)
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



