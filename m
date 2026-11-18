Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029193;
	b=XwBL9vuii/A4Mat1i0ps/CjkCU8Q3BVvBlZ5Emy/1oSeBfP/yqky4rLuJbpaw5Zqb0bv
	 gCZaRmcF+WZ/6NE9HmGGpTz8Qfb4JTajQQVdTteha0WKnvWCT6jW201jJ6IL3wptJAm0J
	 fH8gO1EzEMZ0SmgwFF2lgkfDSfjBSenMo6Bvn1Bp43JP2uUVDbT7cBh8ARmJ79cAFJuUJ
	 RggqyeFI3H8rhuM77C5M9C8124bW+v6xAPoUessHUdYKBlzQdS1o7em02iq1G4bRV5qVm
	 P0b7pApZDp2vkpuAQiR+OBg86E6NNxUowTtqpmE2ldQyUou/hCQl04iprAiq/I+KpLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029193;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PvGXa/sN6ZpL+BNyghBxTbSP3WlxBEl6+iD5orS6m2Q=;
	b=jXqCjTrNQ0PZOT6WT7I7zOxGkmva5Mfd3rLTpaMwQ0Dawi3ZTRCLKyY0kOUKU/7fqQeH
	 WUC7v8TQqehoKePG242FZtasJcdX7jk+p960nQb3n0Nc8AW4lai2Pc4JjtqwPy7CnvXX+
	 ohHWBAzN2XZ7X/Kraxoo4a24PMsKkLopYpX47GEExrq3Auyhp5AjTQZ4pViu2BrkDRcL3
	 YczcFJS8h3WtZ7EyJQojtPs1Co40mvLd1pljfba9CHFno/nqieGbj5SJSdxR88oUVDjSY
	 fwa0BQZ1r2//a/wBGzZwjyr70Z3xr0rYTNqR4F6UH0Vvrm5aZSRQOZdNW5PhTqc6AFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xcbRifCL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA2A606A333;
	Wed, 18 Nov 2026 19:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xcbRifCL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE801F000C4;
	Wed, 18 Nov 2026 19:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029192;
	bh=PvGXa/sN6ZpL+BNyghBxTbSP3WlxBEl6+iD5orS6m2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xcbRifCLlXSe2S/CLS/Q1Xx+6HoJc3pscL8cZMuIpLow0aSfJuX/D3o8THkfN6K/Q
	 1gwATJ1tkTyRuDd7CulxAflX/33tOlLzdOehNwNNHqV8Ptr50bGBk3Y5YLKobg2Pfz
	 NQ/f/FhvHKAr8Qp+JD5LD1l34EU8Jn0IvCMeP1F8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0261/1756] ASoC: mediatek: mt8186: Fix APLL enable error handling
Date: Wed, 18 Nov 2026 15:39:48 +0100
Message-ID: <20261118150018.750036124@linuxfoundation.org>
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

[ Upstream commit cb552c6b9abe02f254d44d8c29d0dce1ae21f69f ]

Currently, the mt8186_apll*_enable() functions call mux_setting(afe, true)
but do not check its return value to handle failures.

In addition, the cleanup paths of mt8186_apll*_enable() do not call
mux_setting(afe, false) when the enable operation fails, while the
mt8186_apll*_disable() functions do.

Add error handling for apll*_mux_setting() and call mux_setting(afe, false)
in the cleanup paths when mt8186_apll*_enable() fails.

Fixes: 55b423d5623c ("ASoC: mediatek: mt8186: support audio clock control in platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260903051150.178057-5-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8186/mt8186-afe-clk.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/sound/soc/mediatek/mt8186/mt8186-afe-clk.c b/sound/soc/mediatek/mt8186/mt8186-afe-clk.c
index 13781d5ca5444..a54fff16ffa4d 100644
--- a/sound/soc/mediatek/mt8186/mt8186-afe-clk.c
+++ b/sound/soc/mediatek/mt8186/mt8186-afe-clk.c
@@ -408,7 +408,9 @@ int mt8186_apll1_enable(struct mtk_base_afe *afe)
 	int ret;
 
 	/* setting for APLL */
-	apll1_mux_setting(afe, true);
+	ret = apll1_mux_setting(afe, true);
+	if (ret)
+		return ret;
 
 	ret = clk_prepare_enable(afe_priv->clk[CLK_APLL22M]);
 	if (ret) {
@@ -433,9 +435,9 @@ int mt8186_apll1_enable(struct mtk_base_afe *afe)
 	return 0;
 
 err_clk_apll1_tuner:
-	clk_disable_unprepare(afe_priv->clk[CLK_APLL1_TUNER]);
-err_clk_apll22m:
 	clk_disable_unprepare(afe_priv->clk[CLK_APLL22M]);
+err_clk_apll22m:
+	apll1_mux_setting(afe, false);
 
 	return ret;
 }
@@ -461,7 +463,9 @@ int mt8186_apll2_enable(struct mtk_base_afe *afe)
 	int ret;
 
 	/* setting for APLL */
-	apll2_mux_setting(afe, true);
+	ret = apll2_mux_setting(afe, true);
+	if (ret)
+		return ret;
 
 	ret = clk_prepare_enable(afe_priv->clk[CLK_APLL24M]);
 	if (ret) {
@@ -486,9 +490,9 @@ int mt8186_apll2_enable(struct mtk_base_afe *afe)
 	return 0;
 
 err_clk_apll2_tuner:
-	clk_disable_unprepare(afe_priv->clk[CLK_APLL2_TUNER]);
-err_clk_apll24m:
 	clk_disable_unprepare(afe_priv->clk[CLK_APLL24M]);
+err_clk_apll24m:
+	apll2_mux_setting(afe, false);
 
 	return ret;
 }
-- 
2.53.0



