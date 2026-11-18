Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031239;
	b=G77T0bSOS5JSWOH2k5YVrueWJHOPIyieu8eZmg5CJoq8LXM4EPJNBLtEaGlRLujVzJcL
	 oK0USfMrLtluJZydN3uslq+y8AgMP+WxRlfO6A5M+81na8KaD4mVfbJ++WcLuQEHZTCWv
	 qjgisWUsfmBLWDb/+0KLV7SVQC2N3Cpz18q0Uw0+J/BGhV3KTYt1pqf26vRKn+T7rlmka
	 XQlpZIamp2/on0OIsUqZZH22n/vEQ4aPbsa4seFqFb3S0ztRxxt6EcUiHPO4u+cAcf+Df
	 gY9j7NB202465pYSpwBxIEz1AHdzPOFbGi+I/xjNqIuHcRARoLs1nN1kv3pKESpfzUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031239;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L6xWFcx1h8SxDL1PltDPXSn7BGYk92Zee9F/vF7UXwQ=;
	b=MNPNq1J6fD5LHqatXVuH+intkvxppnXVC/ojGxjhFreeJ0wLu43GFGQ6xLCg4SPL8BSl
	 f8SsXXCv62fX1iybLc30av7nBr8QAlgm7bnsDj/WW325ocdVfRKsF6ouvKEmvsX0sTXad
	 q7S1/i4gcUlOxiC2bYni9tbGC9ZWHpLmlkLdYM2JZ8bYh21dNX+tFYgUen+rfW9GiHWGw
	 Ob5FIi5RzgGcULmzVP57UTC3Bz8xh6M1Z8RyLJvoc1ZYQI6lUoMhQxQAXWCWA0WxcSNAj
	 8mmwko6O3l0hdz0hzBfY1nIga7o7/bxzF/5O0pSQ/L1XNor3nZx1DIcq3sCo0aeA+MQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZZQVSGPs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B332A606A320;
	Wed, 18 Nov 2026 19:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZZQVSGPs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105591F000C4;
	Wed, 18 Nov 2026 19:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031239;
	bh=L6xWFcx1h8SxDL1PltDPXSn7BGYk92Zee9F/vF7UXwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZZQVSGPsO6a/r48dKtAAXVSDExgJNpnuPaE8ZwQfGQCU5ipcjNZ6nldINlRiggC5B
	 XNVqMmJitJgiy1FpmhrYhU9HD6N5KydD2vRQBE4AOLF3gndS9HY8xW7yuc1lIlTAoJ
	 IR9X/5RTcYt8r1FUM4QnqbXqxKjbavUY2K1xg2oU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0988/1756] ASoC: mediatek: mt8365: Handle constraint return value in FE startup
Date: Wed, 18 Nov 2026 15:51:55 +0100
Message-ID: <20261118150049.507372981@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 8de3f4e8e81148dd4cdd19e622d4be1fe07a7f52 ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from mt8365_afe_fe_startup(). ASoC only treats 0 as success when marking
the DAI as started, so .shutdown() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: e1991d102bc2 ("ASoC: mediatek: mt8365: Add the AFE driver support")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20261007110858.509341-5-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8365/mt8365-afe-pcm.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/sound/soc/mediatek/mt8365/mt8365-afe-pcm.c b/sound/soc/mediatek/mt8365/mt8365-afe-pcm.c
index 23cfcf7160e3d..50269fa1a6527 100644
--- a/sound/soc/mediatek/mt8365/mt8365-afe-pcm.c
+++ b/sound/soc/mediatek/mt8365/mt8365-afe-pcm.c
@@ -514,11 +514,14 @@ static int mt8365_afe_fe_startup(struct snd_pcm_substream *substream,
 	snd_soc_set_runtime_hwparams(substream, afe->mtk_afe_hardware);
 
 	ret = snd_pcm_hw_constraint_integer(runtime, SNDRV_PCM_HW_PARAM_PERIODS);
-	if (ret < 0)
+	if (ret < 0) {
 		dev_err(afe->dev, "snd_pcm_hw_constraint_integer failed\n");
+		return ret;
+	}
 
 	mt8365_afe_enable_main_clk(afe);
-	return ret;
+
+	return 0;
 }
 
 static void mt8365_afe_fe_shutdown(struct snd_pcm_substream *substream,
-- 
2.53.0



