Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048755;
	b=Iw8PoJ3aT+8Lu5cE/Lghze2h/kHjoqAMyngpELwjkE0HVSAq2nj9KktoHi+ndezlkGUK
	 CzvGxiYquQO8SUIbZzq9MaBzCwTOVCAsN0TCQ6e/FXdc5QFVJcrvYNhTu7Q41IMwmgWE2
	 U3arrQU6x0aHz9C3crSUfkMet3tElFx8PPLat/sZ3ik3QhkeSBxDIpX9lylpr6/GEv/1N
	 982y7qm96BgXWFNWRR+kHkMMnGDvjiOAtfjknLLzh1WjhjuEXM9E/le7y7I58Vq+G2Hpp
	 eCqKIHw0PL7UMmB1mtl3jPGtuRBBrSPpwT5SaR5NTK3OqbcvdA0AU1OOddRn+/737sA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048755;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KOpeC8L6/jj2fybxT55fgS5uEiHQ98DVzYnL3HkITsQ=;
	b=ReM9PQjP7R8ViRGatC/xKKq00my7W1d46B/qhoI2Zrhj9lrDa9xD5X87HLA9KBOxRDru
	 /EChF9CL1QyrpWf38oPW18vzGisCRPpIAizC+cWnAFjl50sjKtEGhGpLQxxGl84v0GlM9
	 GHVEt2oM2YqYP2Ql5VvgPklrumsrw+5ffV+yf2KTYO/P3Q/Qpw4Dlsc/PmxQnV0gZ+fzW
	 nMgOHcNpCfxPQYXML2mW/vuEZqpnaNQH61WxaIJTvr8He6vG4aluQ8g7NBEBXuiysi9ML
	 GIP7htKmnFe6dZTxm/LmG1u7udcWcdMOH+ZN9+63YdtSg6Hm8XbSRLWZISa/JJJ9RCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="dE+1/h0X";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0634606A320;
	Thu, 19 Nov 2026 00:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dE+1/h0X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35A3A1F000C4;
	Thu, 19 Nov 2026 00:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048755;
	bh=KOpeC8L6/jj2fybxT55fgS5uEiHQ98DVzYnL3HkITsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dE+1/h0X+80YCld3jrQr5guNRgha5f6wQQStOE86f35elX7F4uqp0C5WFNZVvG3ON
	 Svz9mB2GsBFEPTWfPwtCEukzhYRQFTZbk4Ln+GdESD+/Dd8YqpbnabkJH2wQgtV9Co
	 oE3zytuoS0tNMsVhdyCpzbfa0KxDem6p35jmq98I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2107/2857] ASoC: mediatek: mt8192: fix MCK clock error handling
Date: Wed, 18 Nov 2026 15:52:21 +0100
Message-ID: <20261118150317.276961593@linuxfoundation.org>
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

[ Upstream commit 4a0ab266cb1594f8c6aef3c79726476ad99618c5 ]

If an error occurs after enabling 'm_sel_id' or 'div_clk_id' in
mt8192_mck_enable(), the function returns directly without disabling
the previously enabled clocks, leading to a resource leak.

Fix this by jumping to proper cleanup labels to unwind enabled clocks on
failure paths.

Fixes: 125ab5d588b0 ("ASoC: mediatek: mt8192: add platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260918133912.133799-5-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8192/mt8192-afe-clk.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/sound/soc/mediatek/mt8192/mt8192-afe-clk.c b/sound/soc/mediatek/mt8192/mt8192-afe-clk.c
index fdd7378f8e6cd..6983c63a678f0 100644
--- a/sound/soc/mediatek/mt8192/mt8192-afe-clk.c
+++ b/sound/soc/mediatek/mt8192/mt8192-afe-clk.c
@@ -623,7 +623,7 @@ int mt8192_mck_enable(struct mtk_base_afe *afe, int mck_id, int rate)
 			dev_err(afe->dev, "%s(), clk_set_parent %s-%s fail %d\n",
 				__func__, aud_clks[m_sel_id],
 				aud_clks[apll_clk_id], ret);
-			return ret;
+			goto err_disable_m_sel;
 		}
 	}
 
@@ -632,17 +632,25 @@ int mt8192_mck_enable(struct mtk_base_afe *afe, int mck_id, int rate)
 	if (ret) {
 		dev_err(afe->dev, "%s(), clk_prepare_enable %s fail %d\n",
 			__func__, aud_clks[div_clk_id], ret);
-		return ret;
+		goto err_disable_m_sel;
 	}
 	ret = clk_set_rate(afe_priv->clk[div_clk_id], rate);
 	if (ret) {
 		dev_err(afe->dev, "%s(), clk_set_rate %s, rate %d, fail %d\n",
 			__func__, aud_clks[div_clk_id],
 			rate, ret);
-		return ret;
+		goto err_disable_div_clk;
 	}
 
 	return 0;
+
+err_disable_div_clk:
+	clk_disable_unprepare(afe_priv->clk[div_clk_id]);
+err_disable_m_sel:
+	if (m_sel_id >= 0)
+		clk_disable_unprepare(afe_priv->clk[m_sel_id]);
+
+	return ret;
 }
 
 void mt8192_mck_disable(struct mtk_base_afe *afe, int mck_id)
-- 
2.53.0



