Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040129;
	b=PjmI5/HB8gtaqsM3pvuwnUIWBc5vbW4Xef8MnUXrqdkMNKuwCeGXxmTBbCw+t6d8fSFa
	 wIxoKwtZp4/SzZGfglkT8SIEqYt22aG40AZlIXew4uamshKmjctT6dxsBWCHNdzDcr6Fm
	 JcCd5TFEgYT1hP+Xdi66jcAGHRXYri+zVoqGtFduOq34nI4gSaGxdyKvmsGsWZdjFLsg7
	 DaDVYAKahjYakx1Wf6+xwT5Ej+69E+O1itkvuZRpV7ibvoZz7bfl6D+7GOLNLlKo1zxrC
	 nNiXWZVuofea8cwv43o309zQJ8SztA81y/+ehS7RJt8v22iXXFYmROA/m06o474BkCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040129;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2s9Ig8PmUN3bpDP254DK6bJkhjQCmzC64bgK8yLsmvQ=;
	b=AtnsqiPqHsZjHMwmS/J0SaBq8wvTxjjYtdVEoVdrWGVuuGYzDJfqM7QJL7dTfg/H+ZWt
	 MYqxj/DT/aHXmb+H8trUk7WcGJVQEyobeOc6AN+ci3tZEPPRtHzsv+D6M9eDsiuBHNrWm
	 3rv2MCTuYTDtq3dcn2rIQn4msrBbhF7i1QCywIjfRu9H+FFnnqKnMuglAqTolmvzw53Qs
	 iCdjmCPWdm4NfTEw/Vg+uYVPFWikkSkK8koeVe/pTXmitapFlqJp9FbFlvZ5vLLRJSGOg
	 1Pl/id5xMO4OYIQlGpBIBWcY2le8qfmfKx9bhn/YpxHXPE4uG2G63bLpuSC/K/Vl8kQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fgWp1vd8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D0F606A31C;
	Wed, 18 Nov 2026 22:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fgWp1vd8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ADA71F000C4;
	Wed, 18 Nov 2026 22:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040129;
	bh=2s9Ig8PmUN3bpDP254DK6bJkhjQCmzC64bgK8yLsmvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fgWp1vd8oQddy/ymyBRDaHsrxFgXOEkYOmv/lp+lGoD+oJx53mF7ObgQ7bjcvTXZN
	 CAUzV4oVe8G83Z6L+tAlAfTK03Eovzey8bKtFCf8+1YU14P6S9Fn0ac4a4uBVeH0WB
	 BfxzoMniu5BUgVT4vOQXAF9IFa9o15By13KGjz7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2346/3318] ASoC: adau17x1: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:49:28 +0100
Message-ID: <20261118150432.004716915@linuxfoundation.org>
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

[ Upstream commit 8ca84987c11d11e0ba60f202e3199b3b80c87721 ]

adau17x1_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The optional switch-mode callback remains ordered before the cache
replay.

The issue was found by a tool we developed.

Fixes: 4101866c743a ("ASoC: Add ADAU1X61 and ADAU1X81 CODECs common code")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-2-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/adau17x1.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/adau17x1.c b/sound/soc/codecs/adau17x1.c
index f2932713b4de9..b27fd86ac6501 100644
--- a/sound/soc/codecs/adau17x1.c
+++ b/sound/soc/codecs/adau17x1.c
@@ -989,9 +989,7 @@ int adau17x1_resume(struct snd_soc_component *component)
 	if (adau->switch_mode)
 		adau->switch_mode(component->dev);
 
-	regcache_sync(adau->regmap);
-
-	return 0;
+	return regcache_sync(adau->regmap);
 }
 EXPORT_SYMBOL_GPL(adau17x1_resume);
 
-- 
2.53.0



