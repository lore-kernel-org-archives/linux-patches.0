Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017199;
	b=LMiXpA+g5EwQW42NqkzGELmVzYVqE/sed1UtI6Q3WYlQqt744utsDTJhguSF8ZeKttQ4
	 tmvA9EE4wVjzjm11RY7PBCz1XddQbkRe8XcbBcNB39cnzHN9PMjObAkMQ8jSEdbG+cSk4
	 iFsLyizNn+ss7EoC8qZzcA2bdZCmNqy0Rl4Ia3aitOqoaQkHtLMpL0GSsnb3f2aJ8B0ms
	 6Vsnaf0XPhC6oAaJlPdmb4sgzagiqpfGqqIyhRbd1qG8A134UleHswV22gPNGr751XKLb
	 xZ1zwiuVusU0CvyndFIW+ekh4uU/OeSGR5v5AeD4++j+L6j8376FuvM6xSI0Lco5Dww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017199;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D93b5FPF3fxzBC3WTv1HocUzVqaA6d3MLnIZCcoPvZU=;
	b=2vTpITHKPVxtTcgXPN2/uIgVE9oqjZ5roCPBISGYSZGpMwr1FPnSMaVJm9Tfgmed2tfL
	 RMDIKITrHw3W+Ye76KsOd2I6B/co9bRlPNIXEVifEZaiD9GG6YcXmrvRxmJ3JGLZw98cQ
	 9TL4+FQl8wogXDy5NQbLqvFdgOaJ6sEMv536uTjpsBk4iaxiZR96Azdiz2g6Ullq/j7Gc
	 O3+Q18BiLLW3oi3QybiVT1Vbv44Zw/M89m3L6J1dBeAGpXQYaU33Iy8Zqft/8uDVeU5IX
	 MIrWFyANyKjgLnbLD8ZMUe4UItFikhwvr+MAA/js0tOZQbxEmrYVStolZBIFZc4FtXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zhcxujKU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B37A606A31C;
	Wed, 18 Nov 2026 15:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zhcxujKU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C436B1F000C4;
	Wed, 18 Nov 2026 15:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017199;
	bh=D93b5FPF3fxzBC3WTv1HocUzVqaA6d3MLnIZCcoPvZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zhcxujKUYAXuwpuACjzawDbMMHvPBcz57dDIx2dYe7Lrw1R1UtM3epwz+PQaOsguZ
	 TFFeoQPIc75D1Ut7oxppnQ24obEnouakw9iqZVGJX5WGT6lRmXfIPNTBdPy3dMX3oV
	 CHRD5jABiUn6qrlpp+QnjrUS56ZiaSbM6z++4o7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0799/2651] ASoC: rt1318: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:33:59 +0100
Message-ID: <20261118150316.645952540@linuxfoundation.org>
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
index 55607f1b9a1ed..3dcec7564b82d 100644
--- a/sound/soc/codecs/rt1318.c
+++ b/sound/soc/codecs/rt1318.c
@@ -1075,8 +1075,7 @@ static int rt1318_resume(struct snd_soc_component *component)
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



