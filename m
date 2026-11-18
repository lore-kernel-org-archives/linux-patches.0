Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060852;
	b=grT8kmpW/n0LO1Dn6KAx43QcDq5r4Dgn1TvnYDMAtkn7KuWru1qwLud+V8Mvp2A7lnxK
	 KhMe7Afbn9wnz7Xj60C7z82VamMjL7wco+hUo0NV6DTj/5ojdYWj+Zz65PckSFLLEX6aH
	 X4nQPWLqQmeJcQwVtdIcF1fdjIOUPfnQgcH+aTw/rTYakxO6a1NN98bFAivzRauBCQJ4K
	 PS2lH3YR1qpOM9oHodZsVgr+LDlI+c8AgJ5mrl96xZoXs2a5HiyJonpcqgs3drrLPmmDq
	 CgyEiMy6ECfhvoEbhXrBpn4z+VZnQtLQccQ11xzjnsSD0FuF0Z2Qk4+LQswO/FuF4eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060852;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AjgYmcrSljGhv3KKLJ+6UtNUX/aAGBKaBHnEMWq+QXo=;
	b=qBaSkHsf8jsnNkjK0RanzNAKOIrapePWUOIEpSXivi1W8H4UdwTtmZLNNQ3q2aKVvSiU
	 Lcmf23RPRRVdAPsf3mzjbuYnObsZfYSfxN1//N5b3AvPdEUbEP5SrNg60QryCccMiM0xs
	 QlqxmYCrURWQsPePKlNl39tjtecVG0V9UWH2y3VvCE8YkpQqYpunGAZ7hQLY3XDqwrYNF
	 MEwYthWClVsngK8fWAEn4J8L6daLc6Ju8b/cY7RF6NUOEQo8xOglUPvDX9QcoH7ELL0QV
	 S/UAaXcdxK7aQitqFZTbJZbsdPX6zw2+uOzu5nOVAt2vLMFb0Yl7c+/v+xVNVfDXy7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oy3aWL7D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C77F60A2601;
	Thu, 19 Nov 2026 04:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oy3aWL7D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04EA1F000C5;
	Thu, 19 Nov 2026 04:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060852;
	bh=AjgYmcrSljGhv3KKLJ+6UtNUX/aAGBKaBHnEMWq+QXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oy3aWL7DpQmeDDxlZefDD6tShCCFGGauZfsL2Yut0cotqNmh4KwkngapFfP22pS0w
	 llpFOOETQKhBLd9A2EAXNNyTNPU2gUh4GFFk4/zfyxiVeY4zhLRMecJ2suMHrycudc
	 IJL9k3jof8Eyl0WsMNObYTrhKWSfpIRTvUd6Cvc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1347/1848] ASoC: rt1305: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:56:25 +0100
Message-ID: <20261118150016.045922165@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4e9dfd235e59a..223683dc20ff2 100644
--- a/sound/soc/codecs/rt1305.c
+++ b/sound/soc/codecs/rt1305.c
@@ -898,9 +898,7 @@ static int rt1305_resume(struct snd_soc_component *component)
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



