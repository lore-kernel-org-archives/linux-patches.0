Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017182;
	b=mcHu6/RS8TlLRt7cF+S0Hk8bp8pS0BSZ9bZ5D3lof8ltX76tHyLPZJKpYmkzsJTEnM6O
	 i2iaS3FDndHUYp7lLTDF5f1TDE9nJmp13OeisZoRwRgxD2ueNmU+yXSQTIfaMo+fk4Szy
	 wwzXNzYA3OsBXDTz7qXzYr7oZVCNcavMKIsGREsrLrAxCjG6wEqS0tW3xtG0g+LCdd6nC
	 /FhpJbKcVDt2as/5D+3zHCdNBSk+RlcZ25ee5myl716f0qo8ngYGEUeDMtU0BSx7/AWUE
	 oRzRlAG0Nq6v/CKvZNP7ak3KJCWLnB1PyynPyGGgxDLJKTOS8LTVS5MajQBfcR4+1hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017182;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2sp6O7TrD4cMem24l9uyzGh072B/hV9YtbIEcnyq8Po=;
	b=EkFA1T608tq+2yKBjhfC7+TjBQIspvaqpJl1Fi683XO7uAGReiUBtyZ6SyoiHUS5TQne
	 Nps65OwNLLfdfnqdBVaZD4xAstiecIgWUfG/wB15qns4E7ln95VjxdwXBljC9MkiZi7Al
	 23NhBSoBI93Xmykxld/z+H3VKcozfC5XCAdSfOZRNrASTFDrXmX3et2NWek3kQwlPZTHe
	 1/4DKNegsPxG9kbFO1JogEb9SjwqeqeLYEu+HtdTESK3ghrRs+GltaO1N1Mq0DqSZpLmO
	 8i/p28ki4TbA4ZO/1MqkedVJO4wOs3sGd/7uv6FL1XS2AZjNbcajI6LCOxS9b4TY+uQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wzDxMMkl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB99606A31C;
	Wed, 18 Nov 2026 15:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wzDxMMkl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9EC11F000C4;
	Wed, 18 Nov 2026 15:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017182;
	bh=2sp6O7TrD4cMem24l9uyzGh072B/hV9YtbIEcnyq8Po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wzDxMMklTCUNuYwexT7hoDO03+s0OK1ecf9wqJvEZcG1Ea03LwiwccdJybQya9Ew2
	 ewJo8mjRJFrCGEBzu+FNb4pLsnbXNRMmnyUvMJBxItOoV7imSZz+yEiHK+YH0mJ71i
	 t2TFgrhvUG95J4tkNDMhOg2VX/rpz12xuwm0gCJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0794/2651] ASoC: nau8540: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:33:54 +0100
Message-ID: <20261118150316.465095167@linuxfoundation.org>
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
index fefbd5722c004..6c421e2386aa7 100644
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



