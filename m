Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040202;
	b=V8tr/JS80gFJ2OcgpHNfxJ3jQajQRR54IYMUn8FAAx7yjnSOeCsiU9vMI0gMEpjMo+wj
	 IEYg6fOpwCI8OfCXjSH/qwDWu2m7h9lAC/+hjjfeQ2Iej364/c6IKXi6y7Mrn5Crfulu+
	 2OwukI3YK+WYDrme1jY4Qebvrbr1fLau5NlbIqY/X3f6GRcfz7nLkyQyT7yoFsIdfMRel
	 ZVltJdH2hTx5wVpG0FMC+cvC1WrLZacJYgeYHoNnGORifTY1orYexnidYBvHLbIUEUIc4
	 rxRjskJCLWIGfkQNyypFOAwtldgBTn+T9mgW5SCMSbobTATZo24TjuTWVEc/IbINKLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040202;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u1PfeDrleUoMsVtopCnBeEOQmpBPVprkvNX0iBiQpIg=;
	b=SIcORibjbnrcu74xGrYlt9v2rf2R5oJ5GkYKFAEOxfNzir6lYPoStZ/D2Z5fiqsTsRgz
	 08V8dQeCx0aowfRUXRqizg0/dalXZfLzcUMGBthf7eVD17QQN1k7UsGNMrmO5fQwr2UAe
	 BWAs/fcEAHl8X7l1CkzdLcNPfWgaciRsRe1QuV4fI4mCWyqFpqZo4iLwf+7RW20KBdo9F
	 83qk3nnHTUAKeii+YiigJ8aI8yCNQuz68IZYosM1kk/sxEml8sSO6YlpsWwNgFY4h605j
	 QXoO+RPN17+Y0XH92Rtwk/H72xgdnMpKBRKcXCjlZfOzz0uuCgUL3t6bXVS197yAX6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oz8ubUN9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01BC4606A325;
	Wed, 18 Nov 2026 22:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oz8ubUN9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 538A41F000C4;
	Wed, 18 Nov 2026 22:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040201;
	bh=u1PfeDrleUoMsVtopCnBeEOQmpBPVprkvNX0iBiQpIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oz8ubUN9LOpt8YWvUam7TRkI1T/tvcROlTA9k+7CviAr6iJTqMaKoI6uXqVOcgXU0
	 RCaiTiVGiHO2S5gT2dL/ciKhlWizRZ31Gx4QiAO0hbWPd9vb1XKPrJDW6Z2RVPJIA7
	 CsuXWjT4MreE26erDh9Cmr2qC0sHUJxl8g66r0Aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2374/3318] ASoC: mediatek: mt8183: Fix APLL enable error handling
Date: Wed, 18 Nov 2026 15:49:56 +0100
Message-ID: <20261118150432.772118787@linuxfoundation.org>
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



