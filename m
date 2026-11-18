Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016435;
	b=Qpu5HhatwrvQPHfokOuIZ87uh+kihMIMyFaY9Y1w2Z6nECSSXd0Vy0mwwi4Rfc14GZhE
	 EfKkzeGODuCQ7E6sqXCQfLZUxX1VZt3+7EAfMQ9VaOQTQ8s9xqei4uSeauIV7UBJNOCnI
	 5CgrfiBhz7uYYgz48YDdMig+Qv3KnejstGFyaITOJQzmSDNZvKBJflkJ/BuCjI5ZkAunC
	 pu6doI/nlgW7uNMq2NuJaFgVL2qQE2Ui7+jurXODqbw7oJDwHpZcy/EjzUBOOMeO1xJlT
	 1g3/s5JNgYlABACpK6ibssNsOchyVNsb7NLAoEa6A4fKeDEQdkFojJuzT4mh5igWK9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016435;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NIJfJMmfIdYYy3bg5r0u6pOseUkiSmK9V6lHYHPfyg8=;
	b=bBNTQW4UQY56VeHMwVpk9LxFNesmUjhc4DAM+FEGolxb0MxKJx1j4St0KshqznbRf3HE
	 fEzZjEedvjqWHbnp8mGo075CtImN/ooC6Smyf2zpDvA6hCpiDbzRrW8TXEtyNhwRpVUFI
	 Q4pxVp8ycTH0f+zigjxf5P4l75wVAwb0+bGeZz42Q5xUnQXHetGK/qkWrJk22wuc4iaOA
	 JJ4kdGO/LMpRif6QcXJnf8NPvlo3xLod5STexn1gSt/X1Zvh9Ky9cAv+bGINX6gAm7Wey
	 joT9B0Us+D+m9l8s603S58/2Fn8bR1g+Wby7lA5qTX8U0K/cZZMsq45UFoLcm6hRIrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WBiChnOo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851F8606A325;
	Wed, 18 Nov 2026 15:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WBiChnOo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD9121F000C7;
	Wed, 18 Nov 2026 15:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016435;
	bh=NIJfJMmfIdYYy3bg5r0u6pOseUkiSmK9V6lHYHPfyg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WBiChnOoMmyE0We/KZMZTB9rdrcBXMd7Log6CX6nTDsRi8Pj8WbwrVEEpO1uWNYXT
	 olr37mw4Vy1+dJ7fcVILAcT7SDOA6CKAx/Q1UpFh4xKYvl1rtcBseegjDsAvr+rYFE
	 mf5vD0rcY5OUeXa/bmvd6Rlana9/G9eLwFdQdLNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0529/2651] ASoC: mediatek: mt8189: Propagate runtime resume errors
Date: Wed, 18 Nov 2026 15:29:29 +0100
Message-ID: <20261118150306.809906810@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 483e827b005f122755785a3b6094e2bc19eb7685 ]

mt8189_afe_runtime_resume() currently ignores errors from regmap
operations and mt8189_afe_enable_main_clock().

Propagate these errors and clean up the state before returning the
error.

Fixes: 7eb153585598 ("ASoC: mediatek: mt8189: add platform driver")
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260916050020.14575-7-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8189/mt8189-afe-pcm.c | 32 ++++++++++++++++++----
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/sound/soc/mediatek/mt8189/mt8189-afe-pcm.c b/sound/soc/mediatek/mt8189/mt8189-afe-pcm.c
index 77cf2b604f6ce..39cc2804ad4c9 100644
--- a/sound/soc/mediatek/mt8189/mt8189-afe-pcm.c
+++ b/sound/soc/mediatek/mt8189/mt8189-afe-pcm.c
@@ -2332,20 +2332,40 @@ static int mt8189_afe_runtime_resume(struct device *dev)
 	}
 
 	regcache_cache_only(afe->regmap, false);
-	regcache_sync(afe->regmap);
+	ret = regcache_sync(afe->regmap);
+	if (ret)
+		goto err_set_cache_only;
 
 	/* set audio 26M request */
-	regmap_update_bits(afe->regmap, AFE_SPM_CONTROL_REQ, 0x1, 0x1);
-	regmap_update_bits(afe->regmap, AFE_CBIP_CFG0, 0x1, 0x1);
+	ret = regmap_update_bits(afe->regmap, AFE_SPM_CONTROL_REQ, 0x1, 0x1);
+	if (ret)
+		goto err_set_cache_only;
+
+	ret = regmap_update_bits(afe->regmap, AFE_CBIP_CFG0, 0x1, 0x1);
+	if (ret)
+		goto err_clear_26m_req;
 
 	/* force cpu use 8_24 format when writing 32bit data */
-	regmap_update_bits(afe->regmap, AFE_MEMIF_CON0,
-			   CPU_HD_ALIGN_MASK_SFT, 0 << CPU_HD_ALIGN_SFT);
+	ret = regmap_update_bits(afe->regmap, AFE_MEMIF_CON0,
+				 CPU_HD_ALIGN_MASK_SFT, 0 << CPU_HD_ALIGN_SFT);
+	if (ret)
+		goto err_clear_26m_req;
 
 	/* enable AFE */
-	mt8189_afe_enable_main_clock(afe);
+	ret = mt8189_afe_enable_main_clock(afe);
+	if (ret)
+		goto err_clear_26m_req;
 
 	return 0;
+
+err_clear_26m_req:
+	regmap_update_bits(afe->regmap,
+			   AFE_SPM_CONTROL_REQ, 0x1, 0x0);
+err_set_cache_only:
+	regcache_cache_only(afe->regmap, true);
+	mt8189_afe_disable_reg_rw_clk(afe);
+
+	return ret;
 }
 
 static int mt8189_afe_component_probe(struct snd_soc_component *component)
-- 
2.53.0



