Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040132;
	b=qZxnf2fFyhsxek18ACyudLg+eKeIFTPukEDdCN/e6TWpZGOMsU+Ff7Hu85t/fDsMUxsE
	 5XihOKoQvZNfPJ/ZJmOPCocewHbiyI6OUhzYKmQv2xr0juFIo+6BKE2hScaQdBVyLEpdK
	 VI/vImr2kPcyI+Mmi+LU+1pm61U/MWeBw4SzJAE0CHgrXxxZVu282O1Pa6fFr/WGJNaLw
	 9mk6z8GoPwWxMuvvSXsLBrmEkEFXViutbEsjFbQB2vvXRc+Uu0RgzynLqlPIB+PTwtjaO
	 JgIgjbN1jeY1iQzqbrG7+0gs/anGZI5XBrNOL/xut1/apcpGEnlViZgMxxPID4IMz/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040132;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ka2+7Zj9nNUSDJ566T/86f4/TekCp3wTPD//GZrkcEA=;
	b=aRpR6j714ty/yuowSzaoBa4Zy2XEHvdV/zBqsHMNH659JtJf5BdMTLEAbh0dRMQzJ27J
	 gRmrbVnhW1pLTkNFqr3wI3W9B5oOYd5y3JcNQvKGjIc71oY8lAjDBYxI91wi/h9LxcH2y
	 jx9d8XDBw/ajvd1pKApFffF4LbRgj1sIltZAIDuClWuK/wCCLkDfyg1bWnD6I1qcfncF/
	 WWPsMzdiXE/JMV7yoB3UkH6b7gwWLwj5Yqr5lEgWr3wVqIXdzqM0vkLdvKTTHUZf4QDLn
	 Ei2ax/zi6cwDwdGZ6n9UGNIYLVRMAx0FcnY0PpUULLeg0F6ep1OKO2oemnTGwd45UAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vnbV3IxH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29BF9606A31C;
	Wed, 18 Nov 2026 22:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vnbV3IxH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A951F000C4;
	Wed, 18 Nov 2026 22:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040131;
	bh=Ka2+7Zj9nNUSDJ566T/86f4/TekCp3wTPD//GZrkcEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vnbV3IxHfsYsuY1N6jdT4s9JdUvxln6m0h98gxSgN7v5abZ++L33C2Wqzo73py5Jy
	 gKLCp99ULVAOKEfGpiaZ+RkUps6oZO9aQDb0LMtl4EU1HcZsZ542K8Q2GoRcrUoI6E
	 zYOtB3kDiBsfR7UKAa7OI3aGQI5i2UML8uTzE81s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2347/3318] ASoC: ak4642: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:49:29 +0100
Message-ID: <20261118150432.031350001@linuxfoundation.org>
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

[ Upstream commit 7142c34ed92fddca7038787b8695d22c661dc6ec ]

ak4642_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: a3a83d9a7cb0 ("ASoC: Add ak4642/ak4643 codec support")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-3-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/ak4642.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/codecs/ak4642.c b/sound/soc/codecs/ak4642.c
index 2a8984c1fa9c8..267a93cbe2247 100644
--- a/sound/soc/codecs/ak4642.c
+++ b/sound/soc/codecs/ak4642.c
@@ -533,8 +533,7 @@ static int ak4642_resume(struct snd_soc_component *component)
 	struct regmap *regmap = dev_get_regmap(component->dev, NULL);
 
 	regcache_cache_only(regmap, false);
-	regcache_sync(regmap);
-	return 0;
+	return regcache_sync(regmap);
 }
 static int ak4642_probe(struct snd_soc_component *component)
 {
-- 
2.53.0



