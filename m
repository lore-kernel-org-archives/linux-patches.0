Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026996;
	b=jXRCJaVJ1RL8qKeby9ohWsl2pveAElbAmxPCJ+/AtVJZbRqpNOlXd0d0eOihnwEXTugh
	 EyVwgfyZW0L0cbEMCNiq+odj7AP8pSfxN2CE26a2zxTQ4X+tF7XAQdYahJ+Jr0aQlVPMp
	 jLNNwUDg+3vUaPyqzm40s1aRvTqnf3iZqKXmohHENisL7mEJYweWwZswOLyyU5O49wUDM
	 oRQt+BbftnfUOrn3x+7gw+UxJO9h+HqWRFi7eGzrRy3MJ3XQ6T80jwtHL2pM3V8IBKwgS
	 x2iS/2L8FlTJt7poeT3mzxDOQendo0fRtouaXpMfsa7hTUQjoHMKX8aCVbAyyWUQFGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026996;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6CF9/9URPshoScxZQvbhpC0rPbl+Sx3erpADadHvEdI=;
	b=a4lIvlxhaqeBrUIRMuiQVPmg6gCgHGU500bU10unkqcbB2Uz11jVoT+mYyIHXudHM+7k
	 uSDHm6NJX5QqP7vh8C5iIpMJ9F42jcuGFnYYT7d+gUivN8IHOkN++9o3SocItikUODqr/
	 MKBP6YRmRQwIobp7UpQxAgF0OhqPzhBCGxN7mCypJqm/JOq3tXQDw84mMazZxaqlBQFVR
	 VW+g8q3MXdjN6tOUU/ajMrnTMDNQaUQaSHPOPSFOO/utRBCMU6SGohOTa2uWg81JuWg0t
	 Z9wnWb6avDE4vfLbSh0e4ct2XU4FW4dv5RwdOanPIRkYd24gYdMjMhn2k1nSXCw1Uuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mj2Dw16b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A84606A31C;
	Wed, 18 Nov 2026 18:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mj2Dw16b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AA3D1F000C4;
	Wed, 18 Nov 2026 18:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026996;
	bh=6CF9/9URPshoScxZQvbhpC0rPbl+Sx3erpADadHvEdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mj2Dw16bhWXBimmCzbLF9ja8RWqBPPAXToHNB86lMBbTWlf01gVJWaA4pm8m271/l
	 0rKdDBIT4ni+ipCwOFcFj5SJdaDJD3S82FnHI6kHLrucZjmSyXO9J3DyjTyIQ71m40
	 Cn2XOeHkY8Ffk5wgQ84CL0a1l/uwYIIJorurhqZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1632/2151] ASoC: mediatek: mt8195: Fix register access clock error handling
Date: Wed, 18 Nov 2026 15:56:07 +0100
Message-ID: <20261118150221.321383783@linuxfoundation.org>
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

[ Upstream commit c23390ecf5c068976f25d9c8bfa8e298fa12ea3d ]

Check the return value of mt8195_afe_enable_clk() when enabling the
register access clocks.

If enabling a clock fails, disable the clocks that were already
enabled and propagate the error to the caller

Fixes: 6746cc858259 ("ASoC: mediatek: mt8195: add platform driver")
Reviewed-by: Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261014112752.683032-4-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-afe-clk.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/sound/soc/mediatek/mt8195/mt8195-afe-clk.c b/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
index 5d4ba88ceaef1..9940e95b1dcd3 100644
--- a/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
+++ b/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
@@ -608,7 +608,7 @@ static int mt8195_afe_disable_top_cg(struct mtk_base_afe *afe, unsigned int cg_t
 int mt8195_afe_enable_reg_rw_clk(struct mtk_base_afe *afe)
 {
 	struct mt8195_afe_private *afe_priv = afe->platform_priv;
-	int i;
+	int i, ret;
 	static const unsigned int clk_array[] = {
 		MT8195_CLK_SCP_ADSP_AUDIODSP, /* bus clock for infra */
 		MT8195_CLK_TOP_AUDIO_H_SEL, /* clock for ADSP bus */
@@ -620,10 +620,19 @@ int mt8195_afe_enable_reg_rw_clk(struct mtk_base_afe *afe)
 		MT8195_CLK_AUD_A1SYS, /* AFE HW clock */
 	};
 
-	for (i = 0; i < ARRAY_SIZE(clk_array); i++)
-		mt8195_afe_enable_clk(afe, afe_priv->clk[clk_array[i]]);
+	for (i = 0; i < ARRAY_SIZE(clk_array); i++) {
+		ret = mt8195_afe_enable_clk(afe, afe_priv->clk[clk_array[i]]);
+		if (ret)
+			goto err_disable_clk;
+	}
 
 	return 0;
+
+err_disable_clk:
+	while (--i >= 0)
+		mt8195_afe_disable_clk(afe, afe_priv->clk[clk_array[i]]);
+
+	return ret;
 }
 
 int mt8195_afe_disable_reg_rw_clk(struct mtk_base_afe *afe)
-- 
2.53.0



