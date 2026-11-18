Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030160;
	b=jihoJkc/zc6izd3UHMN4q18Tsb7N/k9qpcG5A/ZX9N2lbY+6Tfl5AbeDiUHvpSPNUFGN
	 qiUO5ZQJX26S+y/6sJvJNbv13JIfBYdnRMgk0SRsq6+fjZohv5+Dly7FEBN2OKNJC7pKa
	 Tz03D5jUlBp20z1OU3mbTeY7nKVeeEtsIurMi6Wsk+VJbCchQkfIQqD1EZUCcPj9ReSTY
	 iZ798HFFHS/k0VMcr7XPGZrpIFRtxNqd36fVw6uItdmH/D6aA+00mQMfV2+dusOlS8g6F
	 XJ0EV2kfx6l3gdLuPaH0PY7a+2hy40kO2BYQ/2B7efwNf/5zQoa1IrpVLUjIrFmvFgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030160;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5WBYwDwTlU9EIg41gPUoTf2M+eIJfhmM9iwtDZxN/Tc=;
	b=UN1syFV4rAlBgKU0PmUxjNXwQVanF+CZK2FByIvqfK27094cnta+KMhk+d94vO6guJ+C
	 fxTfc1ziQCAn7LyKTdbCdj8/enxHFjXDnuAj6TCkijbEbrv/AT6uAJwE1hN68fDbDvEGN
	 QgwyevoEgNEpLvWPgQ1DClq8tMdObxS+mpvmmtAZezRRllsLnmPYrI9dvZNjweJXZP6+z
	 tWSl2qTC/DG5I0S3cOUkv86yMTfA6MwJyD/uKvuC07qzaw84lPyTjDYgEHs8hz+4hx8cV
	 XJApXK2QukHhhLI7EmABo/y9lW5hgl/AK/xtUkimc0LMSzPtNFeKsKLyzMimma7mZvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B6SU1Gl5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E071606C712;
	Wed, 18 Nov 2026 19:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B6SU1Gl5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88E3E1F000C4;
	Wed, 18 Nov 2026 19:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030160;
	bh=5WBYwDwTlU9EIg41gPUoTf2M+eIJfhmM9iwtDZxN/Tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B6SU1Gl5/ip5AdAfNkMeHtNFofbUqjWbYeLJPwHS14OoH2OK0hUFNpZW6j+DEc7pX
	 bFddAlYUx+lBktXTFp9cahbfPH33RodGMq0uZ2hx3gsJi01eLgp/gahjL/2uBxnV79
	 OeL6iZCpkVc5vrUVklDkgqfRCAIqdC8/VkrvBqXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0564/1756] ASoC: adau17x1: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:44:51 +0100
Message-ID: <20261118150031.534602175@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4dcc984761e0a..4c56dc7522dec 100644
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



