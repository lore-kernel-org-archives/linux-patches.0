Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060894;
	b=y7nOugzWnz/jb2D6X+fiedmd4yz4z2sLCo+r71ftD/r/ouwIhAFA7d7xD2e806uEf0xM
	 /86hbljuEo4bFrMI531n8CFQK3BHT0UFMY8lHBHcdRYCugJj1jiAXeebJvN1U9aEbAjh1
	 SdPOBSQWCEYptdyR7QtOdVeMkTOtre0QoRNcR8ygLwQH1drUwNF/wtFuhtc3BfpsI60Qu
	 wda2MvRwc3lu0A6wZSMjQLJxbE9XrgZkOJkpy6p9tut4oGYzGZQgR4sCD/wi6FXnhLpgU
	 9qPDxtwnGEaPF9HAZDcUhKZZJnnihD20Exvd+XBiCRoC9BraP6KEPEnlIjDN917Anmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060894;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kQ1OcGUV626X2qC7jEd0Tg8OCh67IDe2yTQiWgDbFP4=;
	b=nDwdFd9qOXFR1L2p2vqrQYSBBEiHYhejF0ieR+Q7FDTQl7iIIEiWe+lpeBLjf5k7wuqP
	 KkAWYmvvhZsbJ5Ksjqy0YRVSaaXv53rB5oK+/rPPiExVsVbgaBUGFYGM57sNvEsrQNSEe
	 nIoz9x1aWMlgdeufB+7xUGcPewDQLUliMM1ZAEPG3SSEKO8zqx4ZSIMJ+b/mlfz4nrJSU
	 A6vVB/8/mTwSg18ujoRXJaXuNBmxIwhEDcU42OdlhbfL7k7wgj/+AbuAIQiJ5Guec9HTp
	 GIlmp9NW+vxeprynKGi3qOPKEjXSm92ABT4X01z5PD9MZg/kl2WT4QTE2t1i4WHkdQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iHH+Oqw5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309F0606A325;
	Thu, 19 Nov 2026 04:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iHH+Oqw5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 858DF1F000C4;
	Thu, 19 Nov 2026 04:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060894;
	bh=kQ1OcGUV626X2qC7jEd0Tg8OCh67IDe2yTQiWgDbFP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iHH+Oqw5w0Skpj40ITlGmlosElKlpNnSTOV/zZp1vLlTZPGihVYR9Ol8ulLgRTTR5
	 6oyfeAvbJRi8F7eKuyD9tPUCu3e4CDkjaRCavSIv3jg6HblkMAW9BUA/8VOaDebgrw
	 nTx64GSjtVpX4bzlS50X/3MSKOKbcRyvr0AVnsTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1361/1848] ASoC: mediatek: mt8183: Fix APLL enable error handling
Date: Wed, 18 Nov 2026 15:56:39 +0100
Message-ID: <20261118150016.573174622@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 78c06b1a12059..cd6e2821a701d 100644
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



