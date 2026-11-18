Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055457;
	b=InIxagGlalFPi+QPpxCJWlcAC2Es1TEXibcAKOfg/e3igP/CV1peaNTL2DHkzDXM4kmN
	 f/JswUkBXYgrDIrfZ29JGeM+reAH9Zo9uEXBvPoyjtkv5nyE+3QTd+WRtfX0/MacOJosw
	 hYctIgf7HqcXKdPlbCQG8Q816po2ceno3IsOWne0hxRXsTmaS4Gf6WIhdMghxQMKkUerM
	 GGB+DErA6dGqtUDgob738hxm3YBNZXjwXHgxQxBXwRNyKyTd1o2VrJgMF/DJ2ESwhmC5q
	 9eZOs9TOHBfViDLyL9X+PpPaDhmWXa1K9YupH36hCD9+66lqLZSR4+OWahDLfFW5cyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055457;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kp+bX147ClgXXBYyz6iUHHJvSBlTs0LPdtSBsLgge24=;
	b=EhOGZ5AflKHqrFkk0YFtxKnT2vH1HqM0NuCsf8QIN21b/jSLyPNfP8wH3/3YothHKm0/
	 MDOcjl2vLzhfc7RI/koRb73CyiZ4RIHMyyDLI6ABhhNKqcet+dOf93OH9P7Rwp8o00IMc
	 irx+kCcG7GM2uw3rQIqVZpBbBVWV1aV1YMe3UgmjX3lAkWnZM3uTxOZfQvuHfGUUVV3vB
	 UZNPo8pSISZBXb/3gVivBNZLur6nW/oPEglan6ldpDyT1ML446iOrHiaFYeP8cqpsdqEE
	 nCMkG+gS6rnjEeOenA+/kUHby8wySvFyLN5JDxHtIXAKLT6t6XUMIDN2l0dbdtxxn5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S73rb5qQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532CC606A31C;
	Thu, 19 Nov 2026 02:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S73rb5qQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A163D1F000C5;
	Thu, 19 Nov 2026 02:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055457;
	bh=kp+bX147ClgXXBYyz6iUHHJvSBlTs0LPdtSBsLgge24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S73rb5qQsE8td9ri23TIqoaKP0U0oCnOeFgO+DE0oa+wtMHBo+HF0itnFsyvufi0u
	 nubHOdzGP3l/VQuWwLuEO9ZX88TYx3O5RtC/rpnRUKMgHZBqzP6tirTxH3sCMkec5Q
	 1NmHAy+Kkndh5b8uRHM05ZOfONusiQWBVWcRkhtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1597/2214] ASoC: nau8540: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:54:33 +0100
Message-ID: <20261118150115.855372599@linuxfoundation.org>
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
index ace96995fedc4..5c5f62b477332 100644
--- a/sound/soc/codecs/nau8540.c
+++ b/sound/soc/codecs/nau8540.c
@@ -786,9 +786,7 @@ static int __maybe_unused nau8540_resume(struct snd_soc_component *component)
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



