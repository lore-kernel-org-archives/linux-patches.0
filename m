Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032130;
	b=uCVNTNpMd2pHQFeK8KK/Ty9DVZ8ujDqXjBI3h4/pyaa+zi0qbeP+2GRLG2ysHRFPAg8w
	 /EVVH0bIL9sBYlRL+JvJ3xm/YnJGMGrJhc9IeBYo6YAsY2B/i3i95+iqXW2A2ggzqLHUr
	 2uJoxuBVRCD/Js1OC4EtobjtSYCtp+yGRNaDnHvk27gm993Lmn55Na5f/qMNVDhMSYtLg
	 OecQflLkWlU8jug/d2Q/sc307V1z0Zvr2f/Om9u1bbFjZ/r/iOySXYZSaENciQBUioecR
	 jmezyww88t1jsC4wC7309l1HTIfdyYIs7fbdpOlW1z+4ZjrLiXUcVMWbnkM4V6lbbyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032130;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2fvcHhKL3LLeSQT+ZSrWlAiQ/3loIu8/pq4j+qt1pd0=;
	b=GyP5caImgfc19jdX+I23M6e1dsFCEYJ05tKNn/qn7EGRhnZTQlIdcS1+QxZ39GhOaH+0
	 irxE+Z+J0wsq+meHKrURb2Pccm17Dx7zmDiVu19uyPvwMhYossf9Rr3BKN3bLQUX1l+kR
	 +29zikE1TExDUz9vsVWOUnsJxbAXhJIS1YU6ettCmnCD0LCHjfVw27Zp3hWRVb0VB/OtX
	 ZMnVP2h/d0PFAaPVj3P8hWU8d4kiL6K4z0NdvwHSOAU0wmOzEXv7hK6IqaGb4kyFhmuR2
	 n7u/v4EAPkNtHtzi37MqOxKfi4zBG68ZrP592Jp+xjqf6Yrd7ymze+/CtZqWCCZVa0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sk3rt3Be;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C466606A31C;
	Wed, 18 Nov 2026 20:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Sk3rt3Be
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7BA1F000C4;
	Wed, 18 Nov 2026 20:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032130;
	bh=2fvcHhKL3LLeSQT+ZSrWlAiQ/3loIu8/pq4j+qt1pd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sk3rt3Be2RqaZV6FMxKEH3eDRiV8hyRVnyFDxikc7a7hq6Chi243SKG3ed/xu9IoG
	 Xs2JhKb+6N0jJj2MBZ3Oikww9t8tc5MUXWDbtVVMiEF9As1Pz2snmMyF6BbX+otLr/
	 I46hiPE+wIJEjqTEP26CzFFt2AcIkpZXDpy+0dBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1303/1756] ASoC: mediatek: mt8195: Fix register access clock error handling
Date: Wed, 18 Nov 2026 15:57:10 +0100
Message-ID: <20261118150101.375054364@linuxfoundation.org>
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



