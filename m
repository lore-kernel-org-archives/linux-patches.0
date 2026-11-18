Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023195;
	b=DRkkJSIrgIMiG5xHlvBxYkNW1TVl1cQym3JJgQb41P952q7wdIMDLWFJJ1PzFKdWgU0I
	 OVN2HzygiO3l1tnZDybVLM4nzBIhh+ofH14moAn/OF4guj6Fqmdu/vvfPJsHdrnyQi7rK
	 sLqxLkX3z+gldrSSgoN9qUeqqhC9YV0t9HAsfEsaZnim0LMtly4fJzI6cqQXqNJG/1BxL
	 RfkdZMEEfijdtstn09InU92pV15HQ/ilk+9Vi3nB3CdY+y3uE1jfNEGLWODbV9bv137KR
	 R+bOvXT/BQslCegnGwSBvYo9+4FdX22cUx0hobsi+hzMMo4jpJ04E6l0eE9WEHSe1hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023195;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cddgx8vqzJPPv3Y0GbhCkePCiJsCbzMI7DpcYDkHJ5c=;
	b=XBW2iTWqvjCfdT1TyJ4aanYVO7T3VM7N7Qnkgcurs5aMMRWv1B7gU5eFaugWflz16rBa
	 a2Js3bRK1ifrfoKaoYCaURpWxPLs5WQIXTUjWwtJf3EWE6zXJRclP0nULz3R09b3RBYFk
	 F6/Jyjrf6/jOLtPVgTaDU1I6jsj/QPyM6EqLSVGEURKItqi/fb0Xr4aJdLARh4r5Os12k
	 TuEJV73rppwjzERLxc83yVYZmjDnDQD20dPb8+4LaADQ8SuetxAynOVES2mU8ArvsVe7h
	 UaTAWFk0cvU+qE5XUTshTqGrlULLR4d5J0ziBSa4oUWIE1alxO9kFAvMcznKQbVBeog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mQjmRDgL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92649606CA45;
	Wed, 18 Nov 2026 17:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mQjmRDgL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC1D1F000CC;
	Wed, 18 Nov 2026 17:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023195;
	bh=Cddgx8vqzJPPv3Y0GbhCkePCiJsCbzMI7DpcYDkHJ5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mQjmRDgLRbvZd2P2aiqVHaAJlcooG9fY1U3i4r5fRqopbb/h0nBaOzmTS7KxRVsBQ
	 GOYdrEhdoXtLlIO8l3AjhL4sQd+Dm3C6scG5Ebkxw45eOVBD29vaAtOSdEWUE863Qo
	 GnGwOJCM/jJGJPJKe6bq1pmj4+YH+RObPrIfl9ME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0281/2151] ASoC: mediatek: mt8186: Fix APLL enable error handling
Date: Wed, 18 Nov 2026 15:33:36 +0100
Message-ID: <20261118150132.124984767@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 685dc27c77807..77a0cbc8ee241 100644
--- a/sound/soc/mediatek/mt8186/mt8186-afe-clk.c
+++ b/sound/soc/mediatek/mt8186/mt8186-afe-clk.c
@@ -353,7 +353,9 @@ int mt8186_apll1_enable(struct mtk_base_afe *afe)
 	int ret;
 
 	/* setting for APLL */
-	apll1_mux_setting(afe, true);
+	ret = apll1_mux_setting(afe, true);
+	if (ret)
+		return ret;
 
 	ret = clk_prepare_enable(afe_priv->clk[CLK_APLL22M]);
 	if (ret) {
@@ -378,9 +380,9 @@ int mt8186_apll1_enable(struct mtk_base_afe *afe)
 	return 0;
 
 err_clk_apll1_tuner:
-	clk_disable_unprepare(afe_priv->clk[CLK_APLL1_TUNER]);
-err_clk_apll22m:
 	clk_disable_unprepare(afe_priv->clk[CLK_APLL22M]);
+err_clk_apll22m:
+	apll1_mux_setting(afe, false);
 
 	return ret;
 }
@@ -406,7 +408,9 @@ int mt8186_apll2_enable(struct mtk_base_afe *afe)
 	int ret;
 
 	/* setting for APLL */
-	apll2_mux_setting(afe, true);
+	ret = apll2_mux_setting(afe, true);
+	if (ret)
+		return ret;
 
 	ret = clk_prepare_enable(afe_priv->clk[CLK_APLL24M]);
 	if (ret) {
@@ -431,9 +435,9 @@ int mt8186_apll2_enable(struct mtk_base_afe *afe)
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



