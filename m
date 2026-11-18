Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048644;
	b=QlS6ob9oWLof36gEMlhsGdZYid4WsEhPDnxC8IxH/vQTLur5E/4bj5mldS4+TZ7yqnWg
	 UloyqeWEj1QgqsnP6oPUNEDxwHHWIh7fq09vuZd6+LqeVhlrhIcIQXdKZ/kqQstNX5t5E
	 a81GpwnPW7uf55SvuJd3dhyqGdrQlkPvW3a7pfn7NjAzSdOltfT8O9gX2PRQUp6dbij3f
	 XbWqWxCdXiB/fhGRNEnqcd4vHh/a219wlfvpu8EYzbLjizQt+NjcOb7LE5ieT8IcXiafS
	 oQTu+RMTMOEnh0ZD2vVegycnkDKa2Lo5zO31/yg5oECpx4DRWiZYFT7Uou2s/DMd9oA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048644;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qa/faYzrfItR3732rW/rqCIfapoNmotioIPjH5msTKQ=;
	b=iBayB6tbtt568HfSQunne7cMaCcHf5OrYHFLb0azVapgidp0/YY/PHg12E4xsO3SbYbI
	 c41BgLtfP3D/Pjo7XSJBBZ5+U02wAp90dJQFc3yJYfp2q+SqCVoMaBHbJ5wM1OtAsGN+h
	 dkJzqxDilem9QeWufBZkxzGcDlhc4dQZETVxzudale1wOi3moxyHS8TqApZZJsr8q0uig
	 euimoF3UcvzPbUQK5y/FcyrR71rKUc/8coQLDTuDRfD8Neenv3sY1gv9p/T5GBBIZYhTC
	 J3iCW7fiICP9qDilx4/tmJ9EuQH0x/EvwSglE0D1Ovo3/pvkoW5i+8GMEyin+85p65Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vk6xdf3M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672ED606A31C;
	Thu, 19 Nov 2026 00:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vk6xdf3M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 810A31F000C4;
	Thu, 19 Nov 2026 00:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048644;
	bh=qa/faYzrfItR3732rW/rqCIfapoNmotioIPjH5msTKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vk6xdf3MjbDRbCNL2pSo5ROuAFcCx8yccT8FY6qrb/5kjOMefUk33c5HcMczKJHBr
	 brIMDh8NOsY0lPGWPyE4T6l9XtaA3airiC2P0/Mjz+1M0poKw92tyoqc4ti57/U0E0
	 RoSlQTIQUwxH5NrKRKjHI38O6VisOUicgptVtVYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2067/2857] ASoC: mediatek: mt8183: Fix APLL enable error handling
Date: Wed, 18 Nov 2026 15:51:41 +0100
Message-ID: <20261118150315.840880151@linuxfoundation.org>
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



