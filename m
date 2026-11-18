Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048586;
	b=kwWd/6LPaoHFUYlpk+3kGV3Dn9LndfOvJ1kuSJmwlOgpIl3c5sKB9SsAJ63GvWqZ70NC
	 NLV2ng+ea5RNS1phVWNINWoVnmqbMpqnNK6DBDlL6+PhTWhyAXvo6nSPCDzRvPsAoWIkR
	 Z4klfXbBIoPDxUgv0armGKCmBFdKyHvb/duWEb3Hy6/7E/EFVv1uyj4xji/5FHj5dsUXd
	 SWU2ydovJtzGKJLx5VkpEV/MGLXojiOcsjyA2RgHq5MDTPdf6NFmVSFRRsIwnd4wcGGZ7
	 eYlSwdGUD2jRjh6PgBDvzCvrVcvz3Nb6erg8+BJgcT3K99ttsZOblzMIqwKtugSraog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048586;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YJHs0Ln3dcC9fOVeVX7qzgKzREcXlzcJybplLm3eZzg=;
	b=2AuSTS8FfhfunjKR29iPnYu3/Nek2az2dudQ5NmNUpMN7jN+azbLR6VsvhX8xiJGfnTU
	 gR7yCTH0hnSBsChehJRLC/xz7gVmz8hhNRvBoaXAR+zWYdjQcQAR2w8eiBj6s14OHtxEL
	 2l9IvriOi/y++Rn2myRAb7RR1N9bU7yBE3g0ubRCagy46q3cncJ2Qx54SQUwAI7+o2vt0
	 IvEyjaFW/YOAuR4iuCtOd9gsoPIsEyLhQoTMb4j3H/k14EaM4bHtUm6DMnStZp6mP19mS
	 oiptNkDGwOTfNBV8f0UolGcLsPsSiFLoPwmFGnUsfwDx6EBDRe9LbESISZ9E38QWIMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iUb0THig;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD47606A31C;
	Thu, 19 Nov 2026 00:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iUb0THig
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B4061F000C4;
	Thu, 19 Nov 2026 00:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048586;
	bh=YJHs0Ln3dcC9fOVeVX7qzgKzREcXlzcJybplLm3eZzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iUb0THigwFBcJaTWp6riurSGVrCS1G06KJmDj9YlZqlJUR6CO/G7vszENORKSRT/2
	 1NtUMbyQPDXQG/bl0SpHg4ncOCkbeUYENY1SWZzMugH5AVgewHYl155lUN/VhBs39t
	 YkJ16zRRAgF5AaXNQMZ1D4C1CbvE7LSRWtH1NC3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2048/2857] ASoC: rt1016: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:51:22 +0100
Message-ID: <20261118150315.159353533@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 98ace05793c7b80a9f49d92b78fcc88e0970f8e4 ]

rt1016_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: 79a4b670b4b4 ("ASoC: rt1016: Add the rt1016 support")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-8-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt1016.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/rt1016.c b/sound/soc/codecs/rt1016.c
index 37eeec650f035..f013d04edac31 100644
--- a/sound/soc/codecs/rt1016.c
+++ b/sound/soc/codecs/rt1016.c
@@ -571,9 +571,7 @@ static int rt1016_resume(struct snd_soc_component *component)
 	struct rt1016_priv *rt1016 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(rt1016->regmap, false);
-	regcache_sync(rt1016->regmap);
-
-	return 0;
+	return regcache_sync(rt1016->regmap);
 }
 #else
 #define rt1016_suspend NULL
-- 
2.53.0



