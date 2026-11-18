Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055357;
	b=tAPT8ieXfZ/RnQrXgiy+CmIUu5VdYBO2oOUvOV5sO+PgXj9OMsNN+J2YC0u/2KN8B2kZ
	 XtxU7ogABel/GElzG5kxhKjQ0cc+82UXgVBLev3tVS6XXPinJSyvozsfjwYrbtjr3RD+c
	 FxON0dWXFoyNHmMaMZStyOUreA8sRXpX1+8uTlX92dJECIwLVg/smCktZy1Jqlv2FRe/U
	 UqNCQt9Ji+/8+RbnykV/XX3tpZd94rcHbi3YkKJGqhM4GNFwl6Yh0V0Ev8egwwlNRe0JW
	 uLp2SFq2eMAJpA6jnWAA72r2dhf494DDukjcH8BD827PdqO4tBCNAiiAPoHZHVnS76Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055357;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FCham19Md9HZnwU/+AeT3bSRdTx3i8Hg0mTjWmJBK/g=;
	b=AL+BwHCdCIidW5ZMIDSjK6uqbcnJ+ypKVjWwi1M1zZ7a+YIh1KLDQ2UaLZJJqIGPQEEJ
	 NyuYRBApM/HvJKBaaY5/K0Z6ERZK4Mcfvpob2r33oeh3YabFYUb7j4/Q52p4pJkWasFku
	 MmiHwUtB3hPBs3jE0Y8J3RYnFIYal/5MXyTP4K6VFb5RrtMzghK4M7TVm8PwtGuD3hhkY
	 IybEdcooNJm7sfi8hK5DJrO+NToej1kvCvHc+EHJZNeHq5yGPFyvKD1U2eLDeOzlyp/NQ
	 VeiN1o/6zQMMH+hLUtW1PsHrDU7MiG8wZjKGralMvV2lV9gfLw8TD1nY9sNYxeASKIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fhkOcTj2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0BBF60A2610;
	Thu, 19 Nov 2026 02:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fhkOcTj2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE2BB1F000C5;
	Thu, 19 Nov 2026 02:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055357;
	bh=FCham19Md9HZnwU/+AeT3bSRdTx3i8Hg0mTjWmJBK/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fhkOcTj2298UsDw/jAflgGGjAsEy+qNYNVrZAlG5EoOtmDeTeQfPO3FrX1t2dGclq
	 EMHRCJFAjqTvHIiR8qKSaZAuVsJRZNpjXYP5YOLDJgX9LHZdQ1m1Tk3hEFD5MxwxSB
	 s01YwxFIWfgWX5ltGJETOyW/ngd9Q0sD4z9mG2Gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1603/2214] ASoC: rt5659: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:54:39 +0100
Message-ID: <20261118150116.090138651@linuxfoundation.org>
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

[ Upstream commit 3a9b5bce85a1baff95463a2bb021efac64bcf83f ]

rt5659_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: d3cb2de2479b ("ASoC: rt5659: add rt5659 codec driver")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-13-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5659.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/rt5659.c b/sound/soc/codecs/rt5659.c
index 4a50b169fe032..6a85157456d70 100644
--- a/sound/soc/codecs/rt5659.c
+++ b/sound/soc/codecs/rt5659.c
@@ -3705,9 +3705,7 @@ static int rt5659_resume(struct snd_soc_component *component)
 	struct rt5659_priv *rt5659 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(rt5659->regmap, false);
-	regcache_sync(rt5659->regmap);
-
-	return 0;
+	return regcache_sync(rt5659->regmap);
 }
 #else
 #define rt5659_suspend NULL
-- 
2.53.0



