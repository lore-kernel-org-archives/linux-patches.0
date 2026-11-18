Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024372;
	b=lG747OcZN2RVpKJqtbQv3DnshxTpfR27YlSeAo3rkngYGtR9kAt2FXTmgU2NtsYftWjG
	 qNodPtfqHs0rLM/CkItqd7nswU/JV3wo4+BY9VO6iYZBQWVIWXHEwwJVRY1L5FWzuBl01
	 kqcVzdTmrgO3MjNor7OvoWowrkPB8NMLXp6HrXVrBTvyXggBd11B82H1GzGYoDYcS0IZ0
	 1z14W8Vmk0tq2agyq3oEtA3O5AMJD43aEU9dLf4G5hZCxFKEJ+I4YVIYVZP574a5DAovZ
	 m/TzNquUsEhruYYlzS5wBSMf/f0P4cDCpaxmkisdDYWsgg8xatFkM1Sb9+gnyvhIOyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024372;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iqAYbRMw27f4PajIIMGYOpiBmsbiugDiBFpf4ArHE40=;
	b=DGusman6GVVk+ZYi31UVj2qyb3BotTMKfgwK0NITGQfuTapYWJgOmx+Y1ntBkwCu72bJ
	 GmXBDy/0/T5vO/C0iZ/rbF6aGQvJffkBFHKH0RdwdHLh+QWXmWE8q4+ciwi225LzKp6ap
	 dlTjtvbiiiXF2j/j0mdEa1mUNgfcxtFBQDsvbSIFfp8r+wL+jzBi6Ncb4UXJKAODYisJd
	 0Uyc9s4ZgAeyBv3o3qtCKE8MGQSUFZJsc2kADKIapPiFVCwq6NWt50BHpsqEts6pbEEMt
	 a+hLgLK2VcIoQLke921jL7azOTFlukRWmMoisy+TiJA2bELS8uW7zDiAZKA6O5Vdz9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WbuuLtAP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6DE606A330;
	Wed, 18 Nov 2026 17:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WbuuLtAP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB0D1F000C4;
	Wed, 18 Nov 2026 17:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024372;
	bh=iqAYbRMw27f4PajIIMGYOpiBmsbiugDiBFpf4ArHE40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WbuuLtAPsYXrFkAtDy5ApU6/AqI8FbW9Gxm01WBOJs+9+rtT4wNDjzzL98QnxnpKY
	 fTeo+4eyGH28TzEWnogpntYk6/BwLZFAa7LkVLMSHVwFVpQE5vqwRHbkPjJkkRecJz
	 PkubmBX7f5n243d4PVeevMhQglGKs4MccF8zCp74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0703/2151] ASoC: rt1308: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:40:38 +0100
Message-ID: <20261118150147.502093527@linuxfoundation.org>
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

[ Upstream commit 3db3289178b94056753f7a8c6ee4ab4b232ee6a5 ]

rt1308_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: 2b9def8c0d92 ("ASoC: rt1308: Add RT1308 amplifier driver")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-10-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt1308.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/rt1308.c b/sound/soc/codecs/rt1308.c
index df50b38c24b97..2408eb66988ba 100644
--- a/sound/soc/codecs/rt1308.c
+++ b/sound/soc/codecs/rt1308.c
@@ -715,9 +715,7 @@ static int rt1308_resume(struct snd_soc_component *component)
 	struct rt1308_priv *rt1308 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(rt1308->regmap, false);
-	regcache_sync(rt1308->regmap);
-
-	return 0;
+	return regcache_sync(rt1308->regmap);
 }
 #else
 #define rt1308_suspend NULL
-- 
2.53.0



