Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049980;
	b=YmH8a4WyjMOOC59vvjcEZYkQQ8qYDNQDsfMBO1v9BJG6Sw04BEhhUZUYYLTrlJZffTHq
	 4W7Yjnv+LoSOFvJogjAwPrrD2sGt1fQpEhRitz9bpnMTm4QtpiHN/GzSgYAuVZ8Vv+X9X
	 G2xx0s906qxJM/e51TPGNHE70v7LO447+RiwB/qI1RYZWjTrIvYJO9kriY72fNHHELoP4
	 zvo7Qfuxu1LXOrpa1kx4U1tSI8zOB09dbKv5XDGLpUGfCxmNwML+YfK8EHQV6Sbnktvvv
	 K5szCharoQTQPMiW5yGfbXeuiFkxm7Is6z8dgKbjEDgKJ0U3a7Gw8+gCKeUPZxZrgOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049980;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PJ3Fyu2AmefH1AN8Sn9d1zJkeNoJjx8jgA+jAehuaGs=;
	b=LVxAvaPerEzNR5zP2qynK2dgIhytRe1/OT0e/OtVQ54QsHk7IK01t2CB7I4Uu/cHI2k2
	 y8IS68pU7EntImYQ7QzKXWgS3eOHXovYGdeS5T6UOFhMHiL5vsVHPSbSKFzS1+bQpeCh7
	 JYmUI6Z6Elk6cb8uKiXzDvGjhav1ND14ZwKAV7IDik0/yuJ5A4j00j/VHPJsjluKlDqLi
	 bb1cEqb3MdNiW6Uqpxt9X06mWXYPinn+t2eJZ4fKvu17XIN7ZLbCdFAisJM0TssRjY14m
	 ajw9Rto6T2/T+H6Perw8PoysXsiFUhlm3mG8wVIILAvLVzj45H7hfXwp7/QLvMJ+E7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I89U3eVV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725EB606A31C;
	Thu, 19 Nov 2026 00:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I89U3eVV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67F61F000C4;
	Thu, 19 Nov 2026 00:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049980;
	bh=PJ3Fyu2AmefH1AN8Sn9d1zJkeNoJjx8jgA+jAehuaGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I89U3eVV3AAFjf87ZCW/XtMO7wC81l4F64H7YByOhZtH675AuE+bkX/38H6FC/xLh
	 TRn+490OSP6wlyRlorrxXSnYNUwSeTWRRJlb/KFOj3Tz2oa8xvpttPrrkHBRdVr1BO
	 Goo09G5FrrucwoDeUEZ1umjlvQ/8HCXjqjqPPcQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajay Kumar Nandam <ajay.nandam@oss.qualcomm.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2546/2857] ASoC: mediatek: mt8195: Fix register access clock error handling
Date: Wed, 18 Nov 2026 15:59:40 +0100
Message-ID: <20261118150333.185134813@linuxfoundation.org>
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



