Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040137;
	b=acH/fYIxEkWoogKCtnSrE/89XO8PbQsZD4fG6WGQuFuda1J63PdNyvvclhuF6jETg1Om
	 oPJqPRVhFCdg6lq05uNd0w+0+ZKVo5kKaqbCjw742HpopKOmr99XHn56PDX0UiCgOrkAn
	 +2lx5aAkQdlM5EpBsIi+KHcxJZPHHndpOwLcA68Kh6jmBBXgd1wXI0HmQwBeb92hYXSQQ
	 hYaOGg4+0VqXtffPP1oWiYpPPapoYltYQ156fDprdZI740vlogncqho9qpSQQTVccxX9k
	 nFlM3/URrO85nwYlxw2BV+LNqERdqHBblaq9dhZC4+v3SUg4MmzKz6H5dFWc2T8jATQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040137;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=avlIxUtAQUyUv/8YCkArf1jM9xwNz5NWTamXiF3C3iI=;
	b=DNv75l0DEzD7pSjM2rq4UAIzsKhwHexsMxfcTouM9jBkcVNJcqFFkY4Nd4rIX7iHdA2p
	 Y0f6vWCwqBLqNTv2MDh5nrpmpRCZlSWIJVR8PzTPSZBbVOFF32EKKeAF/4jDRSBZaTKY8
	 ReKPLgWZIByTBiDaqdtiAYXtiPDZ0FqNDS5Sy7Noa6l+NPpaesr4P8S/r/P64kwmIenbs
	 Ujkpu0MZtJ3FU01KmGvYKIoQPY3wB03iJ9ZUQ6HAom5CNYzzXy0IrroNGrW+FmUj/CRsG
	 PBtGCZixi0tFRMN4E2BfGzjglmswPv+ybw2HbbykhAWCMgYthXNPxK+7rQsIoWHSzfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eoulahxR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2AF2606A336;
	Wed, 18 Nov 2026 22:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eoulahxR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EED6E1F000C5;
	Wed, 18 Nov 2026 22:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040137;
	bh=avlIxUtAQUyUv/8YCkArf1jM9xwNz5NWTamXiF3C3iI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eoulahxRF3yVEicCatIaARsUWd/K8/KjCpEDtrWEfEFw6LC6OInLFEPSHLqg+4sTH
	 k9I63yJMpYcKlftsC9PlVWVZS8Pafs+2MEIarFHnSEb2MQ6Cn41BjRYjS/PhRNcu8m
	 ehX8m0aUHPxXMRqRbh8bbi2PB2E/haPrV+K1sqgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2349/3318] ASoC: nau8540: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:49:31 +0100
Message-ID: <20261118150432.085633577@linuxfoundation.org>
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
index 2174a89772fc2..3bc8a859b444d 100644
--- a/sound/soc/codecs/nau8540.c
+++ b/sound/soc/codecs/nau8540.c
@@ -804,9 +804,7 @@ static int __maybe_unused nau8540_resume(struct snd_soc_component *component)
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



