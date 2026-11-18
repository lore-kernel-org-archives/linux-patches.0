Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048012;
	b=lUIU1fsn+fWU4GGJ5+aPmWgI5bMMQfNmLMQCru052hEkTajFShzIGgEqYr/lrM4cI/HP
	 DDRa4g/dFvhGqcDPAOsfik0agcOlMMwxd/Gng3gXumfPaVnuU1LHO00881be7jQndyHvU
	 JHBQI+kOr9H7I18p4J7Fukjf1Z4OelSMWGQLVnW1tQ6i5DzEDxJqsIUpDSfjLFOsDAYyL
	 nspZsa8ySTAzhL8gW//3HyPU/UPphtuW2RB0DivoGvkc/hZGCJ8UL8nE5b7tBxBpBstGJ
	 6QU/M0IVafQWiK+c42n3OfoydatdFt3R1JY6cIzahl1vIe0wHo4MGWcKtHMnjrHD0sQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048012;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pSKapLSouf8Wu8fnTCvVVHKZqsyAOtoksvwunH/uA0k=;
	b=feTEZnG1uPewVaKSO/sc6IxF83PerDFX1vEU+9q4ifhiGkdTcCZEuFJPLHsOje2mBPz6
	 os5gGgwEu1/ofKqN8ujHU2d61q39UW8ZnSkWbtlf/Cog1ambViD7ZBgM44t+XhdPBdlTF
	 urjByG865hKwAa4crmX/m+OacEOHUU9dqclnefuT8bn3aloV3Qy323GUlbq6bJXpEMFJw
	 kK9+nYF/cWVn1k/vhNfAGFgVWSquzsSH3awatZ4c10Eq3CeHKpi4ZVMnWId+E1kLe2hjW
	 c43CvjPmW5Z6xr0SVXs4Bd5Z85eOrcDNqZr2AN8g6UueaN7h60WW8TOPVZ/xVUmxV0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yo8zX3rM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E0F606A31C;
	Thu, 19 Nov 2026 00:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Yo8zX3rM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98BE21F000C4;
	Thu, 19 Nov 2026 00:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048012;
	bh=pSKapLSouf8Wu8fnTCvVVHKZqsyAOtoksvwunH/uA0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yo8zX3rM3DwW3NcD2eRGrCo0oBB2Nl/xc3DS9G+nKIp2IxmeK+AIPOk0yRgqntmkP
	 6x0BMfSR3MBpCEaZ/byIoJy3ANUjR0oEHstNwr/0zIDnk/8Y8Ydbjt2ag7PQwvV5k0
	 pq9Qo4mKOooEoUwKpSyZk8EI5jx//xDLujp3RJQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1816/2857] ASoC: mediatek: mt8186: Fix APLL enable error handling
Date: Wed, 18 Nov 2026 15:47:30 +0100
Message-ID: <20261118150306.627490665@linuxfoundation.org>
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
index 87b5c23986cf0..c941d7dc08aea 100644
--- a/sound/soc/mediatek/mt8186/mt8186-afe-clk.c
+++ b/sound/soc/mediatek/mt8186/mt8186-afe-clk.c
@@ -410,7 +410,9 @@ int mt8186_apll1_enable(struct mtk_base_afe *afe)
 	int ret;
 
 	/* setting for APLL */
-	apll1_mux_setting(afe, true);
+	ret = apll1_mux_setting(afe, true);
+	if (ret)
+		return ret;
 
 	ret = clk_prepare_enable(afe_priv->clk[CLK_APLL22M]);
 	if (ret) {
@@ -435,9 +437,9 @@ int mt8186_apll1_enable(struct mtk_base_afe *afe)
 	return 0;
 
 err_clk_apll1_tuner:
-	clk_disable_unprepare(afe_priv->clk[CLK_APLL1_TUNER]);
-err_clk_apll22m:
 	clk_disable_unprepare(afe_priv->clk[CLK_APLL22M]);
+err_clk_apll22m:
+	apll1_mux_setting(afe, false);
 
 	return ret;
 }
@@ -463,7 +465,9 @@ int mt8186_apll2_enable(struct mtk_base_afe *afe)
 	int ret;
 
 	/* setting for APLL */
-	apll2_mux_setting(afe, true);
+	ret = apll2_mux_setting(afe, true);
+	if (ret)
+		return ret;
 
 	ret = clk_prepare_enable(afe_priv->clk[CLK_APLL24M]);
 	if (ret) {
@@ -488,9 +492,9 @@ int mt8186_apll2_enable(struct mtk_base_afe *afe)
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



