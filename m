Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024476;
	b=3ztMGFu3E19iv1563iUisvUcTWgHwAMy7rsJ32N/koqvqpMroRlsVXBJWXrUV5gkUYSa
	 T7/MNJk9Mozfb17efEsTa7by5xUoVHAoR2U37FuzhCr8pvqOJ5HgVDj8FAX9nVXHgjX9e
	 NbkLN+1l3ipZKfHIIAkQXsJWDEkv5fFcUy4OkJB1eyr3eASm82HXfzuqyxlz3tcBe0SLq
	 KQSL5vZwOsl95kDsI7HUlCEEPHfUN1BcaHO3ROkRM/WX+LSQPk0sYI1mFmZD0zjLMcGNG
	 6JvvmJa+JVbu/QVbxes5WRbmW0TjWUFsWpN7Pft0BdRQzDmX92dNfHXEZcWXrO2a1GQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024476;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yVB9sxrxvNKFVuboeQFPzQAbIL4SaWa0kMwXBsWlXuE=;
	b=HLxL9u8JSfOdZYh+fm8ssT6bOsVI2w/QXJIf85xjY20r3tcPukPPXJS8VNRrQ2XKxH/h
	 gkF7p9HJjXpCLHfaOFqz+GcWZ4ASnFxTrIwF/a5mwFosHXbYk0ImyJTCGIPUAO9ljGYWZ
	 tp62XIb1QJG0Kh/qfvZEde7RkhRTfdJc0kzr5Xq+M3ftBLWdH+TrLSqxR0owkrbR/k9aE
	 Yk+BXWaoFyzgqyc7LLNvaXz6IoWu9jU2VA9qFoMC4B9g2ya1lLAh2NKj02vhLKEHY8X3+
	 eUR/vLufE5lQ4MSU/CEVrB+IshhGOBQbAPbVImwC0eOk3Fr89soZeiIcevKrJwFTW7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bno+NxRV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885F4606A333;
	Wed, 18 Nov 2026 17:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bno+NxRV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C96E1F000C5;
	Wed, 18 Nov 2026 17:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024476;
	bh=yVB9sxrxvNKFVuboeQFPzQAbIL4SaWa0kMwXBsWlXuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bno+NxRVn04h+TZ/V0A7qKpDJWqCaoXVj+m0UlJaGUrtxOzZdlnuS5b3iIjaMx2E4
	 adi/c13NiFC1DNvpkpr7mm4mUFspxY6zH4U6gr8vGXwNUzQCc21alpdv70lAHXmBRu
	 eImg0iJBZ/48p19+tsj1ykb3FEYAAfds7/ytRSvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0699/2151] ASoC: nau8540: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:40:34 +0100
Message-ID: <20261118150147.242141241@linuxfoundation.org>
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

[ Upstream commit 0bf2b3411537e8e4d9c03702646a9fc87198d4b1 ]

nau8540_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: c1644e3de45d ("ASoC: nau8540: new codec driver")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-6-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/nau8540.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/nau8540.c b/sound/soc/codecs/nau8540.c
index caf2edb23088b..2fe45fec54bc9 100644
--- a/sound/soc/codecs/nau8540.c
+++ b/sound/soc/codecs/nau8540.c
@@ -897,9 +897,7 @@ static int __maybe_unused nau8540_resume(struct snd_soc_component *component)
 	struct nau8540 *nau8540 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(nau8540->regmap, false);
-	regcache_sync(nau8540->regmap);
-
-	return 0;
+	return regcache_sync(nau8540->regmap);
 }
 
 static const struct snd_soc_component_driver nau8540_component_driver = {
-- 
2.53.0



