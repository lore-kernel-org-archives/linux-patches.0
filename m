Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055393;
	b=1fXv1O2UReMHiU1XQ9bqcpOlXazNrEzj3y/nuV/TJIviYtK7lwKIZ/kDembK5RzZ3jo+
	 j+YTXf8frONonYxvYqgyG9bjqtC1JvFnryPgS03M+6Oi8X6wQMDWVacztRUfNAf9X6/5F
	 C+j8KLkykaDO5EJfeLeX/sygR6lQgpcrFfsxZ2U5ySGAh7ujcLDF4flogNHzmzaEYagTd
	 4J/2kJT1YN0qY58cSMFtMnHhWoFs+NJNQ4EfPnRkj/9zENK4+prMLJbAQ+sZyf2qE4cwB
	 BROPajK4gPVJoty8jcwWUsRuzzhFL7fITOxr/VGGyjTZDX3RCYQ6dylx3TIFboaeq9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055393;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DdcZ78EIxUKlQ9QTaKebhA0mhs8kHTgbFeDKJfxo8Tc=;
	b=SSLD7D0sJYJJfNvDIDHuAJUBFOhiZcaESQR6Cw+zAne3d7Q2WsZfyeXrn9MIm8R89V6b
	 t+LK+oAlt2NQuVzOtbxZnoAwJ+OysO2M8HhJNHyXLsy1ik/wSik8UJHab3sqUv9ecPmD5
	 wVV6b0uH46FoMna3a2zERC5H6q/10mKcsO1ZqeWbsU1+PEbNXKcoa56Ec8ibzyEnGbYFJ
	 Gpjt6unlgQA8QGnqoShcfVF7c3MPa4TUOgD0BnYWAjqlCB/Ns1CAtWeUdAE4UejBD2eZ7
	 EUqxtBGNmHDJm/KURxIDO2I8teskamqO+rPdnfAf0exoEc7NkJNcm0zHEEG+CnitCjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1dF8gu3g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67496606A31C;
	Thu, 19 Nov 2026 02:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1dF8gu3g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A1A1F000C5;
	Thu, 19 Nov 2026 02:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055393;
	bh=DdcZ78EIxUKlQ9QTaKebhA0mhs8kHTgbFeDKJfxo8Tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1dF8gu3gYZv8cvFvRtQPa0LP81IhzT4hyp18y0XlLzU6VU02HReutVCeWpdgBtDes
	 my0A06vGkxj6Pm6HtkNleK9OLAHPVxyYAZRlBDytDCZQ+A1rSFQY9rwEOxC5/6lE52
	 Yb1o2sDKJWw5YmlXTLGuIFQGNAiOOk97yGFICGDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1615/2214] ASoC: mediatek: mt8183: Fix APLL enable error handling
Date: Wed, 18 Nov 2026 15:54:51 +0100
Message-ID: <20261118150116.601627932@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



