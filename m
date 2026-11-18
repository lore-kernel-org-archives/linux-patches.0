Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024464;
	b=q+Lsa4wwiur8RYMdLfSuPFfu8FOSqcpUXRrOOOqbrqMdEhAj9jI/fIl3uhF9Q8Px9fMM
	 BsQmCymum4GeTnhsjN0eiAe08F9d2EQlhfgAdxZUq7306wzEXo6qW/Dj7fMfbx8d+VbEa
	 RvJPl96lQTKg5s2/NVT4Ce5X9/nk6jE0x4sU6XPysleYLBWHOGDTdf4DS9XjMFgVQeFy8
	 KsyjwNFW2fl9QL5FbX8AorLMTZWzsFG55yaR5t1rIqat3xhX7buANk+8jpY/4sv21gZuJ
	 En47cKYQialrln0pAf+AQY1qZakrh78OtbMm7GpQAYMqQ25t8mgl2OicDFPjC1Sw7fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024464;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i+npqw580IjmZ1Yg91QawyZLkCiG+Xw42Z7W1Ke9Nto=;
	b=3vxOJKSCn0xuVtC7IbMzD+2cOQV47PK7aJW4dNP6g5EjSpq98rt6C/LSJnIGM7G6IKkP
	 p7biUrsJFBoIgg76PXRarG88kNV09wnoKFJXnNIpYf8nijuWuau9/TscQFGuK/uqmHY+B
	 Rni0G3HUCa7JACFM6rsN4LBu8uRFnKa5L+pyaIkt6/A4GooU9brkOd0wMQTSt8YY/Vp5S
	 kBmzu/jgbKRi8tktSiM0SmRFsWQgqdewu14ac3cdSHDX/F0SQ8dCSqPTYzEzb7HSNRxO8
	 8JWO3E5qY2jdNV6Zb3Dg6JqSTRJIqe76cnTsnoTerqynX2qkM7Uh/F+zi763CgksXTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=imPYEnN3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4ABC606A32F;
	Wed, 18 Nov 2026 17:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=imPYEnN3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EDFA1F000C4;
	Wed, 18 Nov 2026 17:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024464;
	bh=i+npqw580IjmZ1Yg91QawyZLkCiG+Xw42Z7W1Ke9Nto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=imPYEnN3/G8/0P4gcTGPUpVBkWVnnhYZl9BG77Bw+K+zFbO6wJIykRN36YIoxo25E
	 RNA+UhTtgMgqGx7yIv2LzHF+1lf/ZWOw4LnLmkla10gyTAaPwtVVLYp3I5XplRCKv7
	 JCACj7wSYbh6oEVcYwHLdlJJjQWp4GVnpv8OZTIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0695/2151] ASoC: adau17x1: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:40:30 +0100
Message-ID: <20261118150147.098648763@linuxfoundation.org>
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
index 0b6b0d2115eb0..002baa7f31635 100644
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



