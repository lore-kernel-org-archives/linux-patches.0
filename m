Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056430;
	b=z6b21yD8sX6x7HjZmF31sAguA5Iv040vdtudxzArJuppjrkSlHV8XKIa1LfpUy/rpqoG
	 UM9Wh6h/L4edjArWPtJRuHC0gMCBQxP4UgXdQHCnVYdCrzDGiRcWrGy5m+vNrAPfPgWWF
	 miw4Zvrvy0wpCrSt6L9sJA5EO6eYueBNqYzV+4S3dBn5Wpoma8QTn8NWmp6OE1geNj+vc
	 gCEASBOvD1N+HIIZN6wk98+VbJ12T+/i2SSsRP2DssuChEqc/vmv24xUhIspb4WxKs9/k
	 etoSlpCrTC2joTo07/0hAjJROKeXIW9IdAknbwWXg6Gp8GI60K58GPXAGl2GJqaGk8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056430;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9QIJcpM8L3NsTc3uzqwN/VNW4K18SPuTxDIxrVFyQiU=;
	b=DmCX/lNmVUqHFdOsHQCTvIgYYAV4FeDfSnabrsd7Elrn9KuNnjgmORX2payTVAarnqtG
	 yWA49jecWVErL7990v9ipqivPNGsdqo+GZLsYA68MYs7nwVEH2mJwZ0ba9TDl3dH5zFLO
	 lb0S0eaY/B+JmP+F336EQR8GoB+Ul2HtMjRo4XxmBtFfQTda9PNgxHRviFm3qOhZ0fh+7
	 pyWX2fs+zIQfoSkv+nbS5uNZU0PR8TIMTFO6Qk7q2JPHOCx6CCB9tO9M7IF/RpMvaCJLL
	 oplo7dXSB/0A3WOG4vpSTfqR46gkEZs4bTFcxEeVPzwC7QQ53iMiFWuvYnA/+6mUERw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zRlz6Fm7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05DC8606A320;
	Thu, 19 Nov 2026 02:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zRlz6Fm7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A3D51F000C4;
	Thu, 19 Nov 2026 02:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056429;
	bh=9QIJcpM8L3NsTc3uzqwN/VNW4K18SPuTxDIxrVFyQiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zRlz6Fm7sSkWaG3q0Em5iQv1pkeZqgzgCseABTamdWpgQNO66XytCl9Ut7XNBQyTa
	 2vPAg2Ysus09NM5NtY62haHn8OCM2Ir90ESynaH26r0njZeqn47ACWSsPOXODXh9Ka
	 LsJLwONB8QYnboaiZSlw+aVMznRyvnqn4XtLXchg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1984/2214] ASoC: mediatek: mt8195: Fix timing system clock error handling
Date: Wed, 18 Nov 2026 16:01:00 +0100
Message-ID: <20261118150130.223706352@linuxfoundation.org>
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

[ Upstream commit f18c0a8e528eb8844ee362324220ab8df3664afe ]

Check the return value of mt8195_afe_enable_clk() when enabling the
timing system clocks.

If enabling a clock fails, disable the clocks that were already
enabled and propagate the error to the caller. In
mt8195_afe_enable_main_clock(), return the error instead of continuing
with AFE clock enable.

Fixes: 6746cc858259 ("ASoC: mediatek: mt8195: add platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261014112752.683032-5-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-afe-clk.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/sound/soc/mediatek/mt8195/mt8195-afe-clk.c b/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
index e5c90f4efde80..6199ce4fd8f99 100644
--- a/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
+++ b/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
@@ -383,7 +383,7 @@ static int mt8195_afe_disable_afe_on(struct mtk_base_afe *afe)
 static int mt8195_afe_enable_timing_sys(struct mtk_base_afe *afe)
 {
 	struct mt8195_afe_private *afe_priv = afe->platform_priv;
-	int i;
+	int i, ret;
 	static const unsigned int clk_array[] = {
 		MT8195_CLK_AUD_A1SYS,
 		MT8195_CLK_AUD_A2SYS,
@@ -394,13 +394,22 @@ static int mt8195_afe_enable_timing_sys(struct mtk_base_afe *afe)
 		MT8195_TOP_CG_26M_TIMING,
 	};
 
-	for (i = 0; i < ARRAY_SIZE(clk_array); i++)
-		mt8195_afe_enable_clk(afe, afe_priv->clk[clk_array[i]]);
+	for (i = 0; i < ARRAY_SIZE(clk_array); i++) {
+		ret = mt8195_afe_enable_clk(afe, afe_priv->clk[clk_array[i]]);
+		if (ret)
+			goto err_disable_clk;
+	}
 
 	for (i = 0; i < ARRAY_SIZE(cg_array); i++)
 		mt8195_afe_enable_top_cg(afe, cg_array[i]);
 
 	return 0;
+
+err_disable_clk:
+	while (--i >= 0)
+		mt8195_afe_disable_clk(afe, afe_priv->clk[clk_array[i]]);
+
+	return ret;
 }
 
 static int mt8195_afe_disable_timing_sys(struct mtk_base_afe *afe)
-- 
2.53.0



