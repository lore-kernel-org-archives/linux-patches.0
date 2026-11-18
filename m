Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024467;
	b=3vbMOsaNIKX8hh7DVgA8jsyfz863Al7dCGvOkbidkSx8uf4JByCGzRTfB0tUnBLDMuf6
	 YP2K2E8/aSR3l18RuaUsEYLhHlkeSJk8G5lmZUJWn/JThmX+Vf5qWbjyFQvoVZ0MePjVB
	 JSB+erLEAhgAYm3q72juTOCXNX9Qj5gWmQ0F/gAqFYOqfYBiB6tD8GGrezYEjJVwBD6x5
	 gxh4tld1zwePrwuP1bD1qQT7qfHr/eAUe1Bsq2RAdg/mfLg3Mmt7MvCS+6AW8yOYtLfq9
	 ZURVUpnVt8ZCt11uSuwvUk74BIrx2OyVsRWe0aJURkGQB3xIPt/elb1xfd+O/yw7RwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024467;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZuHVM0b9BhCkzEGofz5+W9WApaFvnpM60hGmW1/HBU4=;
	b=LLfPVqFUnNBboiHVmJjlHmFPFPuESs4IvDbUvCfoJZWH8tyWmCvL3n9OI7Rmejc+0F5q
	 5eYNqdwfrs1T1SEowTSmDmaMgwk7tELmzxK06+HVMgLdDnxrRAiFBGs8nPsn4ncnfoxKU
	 WoJNtvRplr3DqFHR1IonFodYV8bG71elAXeh/VgzSOsFQNzzd0raLYoi+ydN81MLdQMwM
	 bW4WXjt0AF0XNmw2Tqapae8d8HnPwwhRqxHIkvVmBHLMgm3yUuvyhgVvrC5AJ+lmnuWn7
	 86dx+2Vz7/O7txyF+Dto4CmZeC6WE43L3ORgSqKyDBMnPo+xx9NXyjgeRomBZ3hHy0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CjnyTeRS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7A6606A32A;
	Wed, 18 Nov 2026 17:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CjnyTeRS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE8721F000CA;
	Wed, 18 Nov 2026 17:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024467;
	bh=ZuHVM0b9BhCkzEGofz5+W9WApaFvnpM60hGmW1/HBU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CjnyTeRSbXyLZVLWIJTKfes5P3UP4vMA8so3h/ZokSKOkeKBcYkxN2hmHNxleuG+2
	 7KncPbHbWvDSOOD0GgvBKMIieF/zs8r2l91RkJlhgvv9d+Kh++NKY/b9+V9NDRGaNF
	 yIe9/Gb2Xcbc7JkmXrJhjLPQQ1VWDsA3VXEI+qAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0696/2151] ASoC: ak4642: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:40:31 +0100
Message-ID: <20261118150147.130682357@linuxfoundation.org>
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
index fe035d2fc9131..08846bd7f80a9 100644
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



