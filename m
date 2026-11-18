Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017502;
	b=lHyN1AJRmtuxAnKSaFfZhEBDtabon7krdMrddIv/7jH6sEl3ZTVOz9b7rNkVEsPrBhjR
	 khLmkXea5epNwDHMchyvxC05WN6fNO8VVUgencCha5PWrkxHBotcIr9Rq4nyuP4IRz7ea
	 vM+/U1wH2T9NUfuvjq+02nNS2Yla3HV7gJ2kp7koeFpy3anKBOK0SNU+i+c3dBNRoSN2m
	 kcwlZt0gyAuWjn5qY0jm3lxEW7X8AI3XtLFNsZeVFCkEpa7IMyuaPBgHf8/H3Urs68QvC
	 1V2n+PBFfpItxOBYQn+iv/YSecyZFQZ1DgSv+nWrsS2fq7pUIbOi3UWWEZCEtpyqzwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017502;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MLz356rPPC2nvLvTHGtQHa2KeGB1fay1RRPswV8/fz4=;
	b=cdrDUnW+5x1Qbbpb0rTit9gtwEhYN4Z7F7zoZLGF9mUgBk3UbkM2C35wGVa8NbrA0zjF
	 lH+Ufb4Df/f9eAK4sGut7qiCIyrGOzH/5uyQapZ5T4JhVWpVPf/IOCkD8S2LcQDZ8zYFF
	 VBOhF+zl1/tbkaoXfnTcMZA+M5M2xqWdHgFRtaCUeqzm4wvdh+osTK0N5DQfRx2iN+sxm
	 x4ZELhuoE6EENNlwHEnJlYpfua3wHN4mWeTodFFPAfbl1ICun0w57uYIUihHZE7fhyN02
	 /LibNgiCLOPUJafQz8cDx+0oYUXDUIdG6fbhZErIDgX7TmQ/H1P+n9iAfnq0AyoJ6yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="mS/bRcSX";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F0E606A334;
	Wed, 18 Nov 2026 15:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mS/bRcSX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96B0B1F000C5;
	Wed, 18 Nov 2026 15:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017502;
	bh=MLz356rPPC2nvLvTHGtQHa2KeGB1fay1RRPswV8/fz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mS/bRcSXIysdrXNxk/nVAEA9MIxQz+BG4pXxHeqNy2QlLPCxRmL5lP/NkKGebq2O+
	 /+3JTsLPHj4tjYGmcfxVLgy23NzhniCVXCTz3h2BHkNrR4SiZ77XYvLAbPdjAAPXgy
	 ZD954ucJbSvJcQ+eFP7b8ViQDonayuU7bhPC+6jY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0870/2651] ASoC: mediatek: mt8183: Fix APLL enable error handling
Date: Wed, 18 Nov 2026 15:35:10 +0100
Message-ID: <20261118150319.178217337@linuxfoundation.org>
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

[ Upstream commit 30cf48383006579d7cd35380cc6e766260b72bff ]

Currently, the mt8183_apll*_enable() functions call mux_setting(afe, true)
but do not check its return value to handle failures.

In addition, the cleanup paths of mt8183_apll*_enable() do not call
mux_setting(afe, false) when the enable operation fails, while the
mt8183_apll*_disable() functions do.

Add error handling for apll*_mux_setting() and call mux_setting(afe, false)
in the cleanup paths when mt8183_apll*_enable() fails.

Fixes: a94aec035a12 ("ASoC: mediatek: mt8183: add platform driver")
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260903045203.175337-4-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8183/mt8183-afe-clk.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/sound/soc/mediatek/mt8183/mt8183-afe-clk.c b/sound/soc/mediatek/mt8183/mt8183-afe-clk.c
index dd1a5925af96d..06556689976db 100644
--- a/sound/soc/mediatek/mt8183/mt8183-afe-clk.c
+++ b/sound/soc/mediatek/mt8183/mt8183-afe-clk.c
@@ -376,7 +376,9 @@ int mt8183_apll1_enable(struct mtk_base_afe *afe)
 	int ret;
 
 	/* setting for APLL */
-	apll1_mux_setting(afe, true);
+	ret = apll1_mux_setting(afe, true);
+	if (ret)
+		return ret;
 
 	ret = clk_prepare_enable(afe_priv->clk[CLK_APLL22M]);
 	if (ret) {
@@ -405,6 +407,8 @@ int mt8183_apll1_enable(struct mtk_base_afe *afe)
 ERR_CLK_APLL1_TUNER:
 	clk_disable_unprepare(afe_priv->clk[CLK_APLL22M]);
 ERR_CLK_APLL22M:
+	apll1_mux_setting(afe, false);
+
 	return ret;
 }
 
@@ -430,7 +434,9 @@ int mt8183_apll2_enable(struct mtk_base_afe *afe)
 	int ret;
 
 	/* setting for APLL */
-	apll2_mux_setting(afe, true);
+	ret = apll2_mux_setting(afe, true);
+	if (ret)
+		return ret;
 
 	ret = clk_prepare_enable(afe_priv->clk[CLK_APLL24M]);
 	if (ret) {
@@ -459,6 +465,8 @@ int mt8183_apll2_enable(struct mtk_base_afe *afe)
 ERR_CLK_APLL2_TUNER:
 	clk_disable_unprepare(afe_priv->clk[CLK_APLL24M]);
 ERR_CLK_APLL24M:
+	apll2_mux_setting(afe, false);
+
 	return ret;
 }
 
-- 
2.53.0



