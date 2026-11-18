Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024375;
	b=CIullYzFxoCGPPsISaBV+YorzCkaZQKuBztyBnRBzSX5o2nuKl3UvSA9j/XZnrINw9UG
	 +2ZrhhO98ZDbQEjU8+4QuqoblIc9Z8Pmn/KxelxAsDh0faNxDzxoc/sdBWsVCP2JDbgUH
	 xtgBfA0mwyhigNzAj2sOh7Y/lXmBJ0xbwaqkqtqKb/AhhzLRjkPVriRMHI/RTW8ORtoUi
	 x22jQzh9RodGFhac29Eru/jKoPwFYVeV3N/kB0Vw4SBJ5lBbdDOZkCkhRk8yRALIHUM9K
	 +sHk8xfgU3H84T3WbcImSU+vweZODU8Zfz5ZiGwzBTwp3LZu7u20wqsWqmmJ0MLKxow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024375;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JAOo8DqNwUbJ18zgqkArba3xc32M1yFseUBq1j8YTmY=;
	b=d18myNGlAriyF8k7UK1rDn5AVFi0Kz+XOvW0h/0YEaTxvKv9vlT7rAez8KHng3bzK49N
	 +oLkmMo/118Vjbqw/kbqA6AwW3B9au3u6ZjUAvFWCHaLTqaadVjI7t+AFo1Tq6UE8d7k0
	 CzfuH8vm4tIaImzoj8ugSc4BcFyQ79YjpDf5QTpwI2WyrNc8wnBmgISzFdeliagFNGsA7
	 8LXbW7YfR9lE91cC9mLoYFxtNbIHO93HsjadbfC/lwJnZa4v2XeRRugJtQ+gPLWevhRYM
	 +c9sW5rYmwH3++1dPVzlxc9pUDyFylw0znF0/pgm1G15mOZZxWa04FiB+/8w0vMWR/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WpWZ1gwQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7109C606A325;
	Wed, 18 Nov 2026 17:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WpWZ1gwQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2FDF1F000C4;
	Wed, 18 Nov 2026 17:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024375;
	bh=JAOo8DqNwUbJ18zgqkArba3xc32M1yFseUBq1j8YTmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WpWZ1gwQeYzlZi61VQ0CPvZAv4luWh92fTCT1wvxbBLuNDrNwETsXWH9yzKhb+3ys
	 L7PGncbreWoFtxMXxlHTALSDqrx5QSYuTPTJlLgxaoEQcbwrvch4h78Tr5xmVcIi9O
	 iY4353lXkua+/8viVh+VzuyCWX9evHpgqwRuOPLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0704/2151] ASoC: rt1318: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:40:39 +0100
Message-ID: <20261118150147.531937272@linuxfoundation.org>
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

[ Upstream commit a5735b341c6e8cff5f5f9480295012a5ceebb665 ]

rt1318_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: fe1ff61487ac ("ASoC: rt1318: Add RT1318 audio amplifier driver")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-11-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt1318.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt1318.c b/sound/soc/codecs/rt1318.c
index ae01b2ce630b2..202c853a0f77d 100644
--- a/sound/soc/codecs/rt1318.c
+++ b/sound/soc/codecs/rt1318.c
@@ -1076,8 +1076,7 @@ static int rt1318_resume(struct snd_soc_component *component)
 	struct rt1318_priv *rt1318 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(rt1318->regmap, false);
-	regcache_sync(rt1318->regmap);
-	return 0;
+	return regcache_sync(rt1318->regmap);
 }
 #else
 #define rt1318_suspend NULL
-- 
2.53.0



