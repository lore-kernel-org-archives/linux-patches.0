Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024473;
	b=orn05I/wtb6TynNfN9Mh5Q0cTTg1ymCQniHcBWuHjeQJ8bDio+uOm6qO2l6mdiY18ujJ
	 1NlJAf687uK+30Mg9keSL4bQq9K8oM6iBUF7/zVZPyjlclhys92mA0aDwNy0Pr2ECAHiy
	 esoWUCvFs2q4kpIzF4XEaEGsUoWV1YDH5lNSJKbjdBnroPZPi4OEy5vTu7EPMPeNfGVr9
	 b44eZQfU1S1QrNliCX4bY7pgow+Sv9j7Zh26mAGNlmakpqqA1qy5WBCH5oPL8JRP4kBl8
	 gj0hay5FZxG1rZuDADOCEXqNgWKRS0SbSRyenMw9w2ZSyO+sQt3wyR6GQCvUj9O10iA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024473;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BTfgtNcPbe7a9QC4aTnfkdwgGDtPSSl6+2C6GgaQPKo=;
	b=FKHp2E9F9xKFqcjSf42iPMR41hqSbcTSB6pUfUMARNfnbhhgDnLsSJya8Q/2Hu61Iyx5
	 cNHE/LpVm/np9yRtV3xCBCp85AJtucB9iRhEebRCqZQBZ9Ix4+iNeXvqDuQnHjEqNsFGN
	 Ukl0QOZpxUL03k3B0389RrF0bK3rqo/dEZGtbFcNwClFS5LPFCscghtfNfwX9mDL3HhYG
	 HEs0Tza6sa6nbeLGR9ugVey9XPTHLrMsYhMxzSmT/MP87aU4Eidps0j8smcrd4KQ5he3S
	 xKcOEJAyakZJVW9jy1Dnzao+oPml8EcgZUDGv/hGw0CKHFCwqXCHAwwQf9UoeyNDTOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vNPDVQdm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA05606A31C;
	Wed, 18 Nov 2026 17:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vNPDVQdm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 887901F000C7;
	Wed, 18 Nov 2026 17:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024473;
	bh=BTfgtNcPbe7a9QC4aTnfkdwgGDtPSSl6+2C6GgaQPKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vNPDVQdm1eNKPbxcHsJUO9o0Fp6az4BkSk/3y7Vafh4ovZCB4OmueXOx0ph0Mz5PP
	 /MLidPRQ1MUv1UihZ6UxkmrJ7p/d74RBFn5IGzy21CGu8zKNluaIZw1abWJ1vGWbUt
	 A4v0+s97UTl2JKIyHFIArqihr86updABodxsIM9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0698/2151] ASoC: es8323: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:40:33 +0100
Message-ID: <20261118150147.197793409@linuxfoundation.org>
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

[ Upstream commit b7c3f95915a9e791fc8721ce1ecc037f7a55d58c ]

es8323_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: b97391a604b9 ("ASoC: codecs: Add support for ES8323")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-5-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es8323.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/es8323.c b/sound/soc/codecs/es8323.c
index eb85b71e87f39..75c542cd8caff 100644
--- a/sound/soc/codecs/es8323.c
+++ b/sound/soc/codecs/es8323.c
@@ -704,9 +704,7 @@ static int es8323_resume(struct snd_soc_component *component)
 	struct es8323_priv *es8323 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(es8323->regmap, false);
-	regcache_sync(es8323->regmap);
-
-	return 0;
+	return regcache_sync(es8323->regmap);
 }
 
 static const struct snd_soc_component_driver soc_component_dev_es8323 = {
-- 
2.53.0



