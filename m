Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055479;
	b=PDqFm3wqWBoaHI3X5H3A/5kDzdC97crwFytiBH0FF+As21P1csRrbslYM5NElvMpGiZM
	 zi9hGp6o/Swf++5+IMvkyrHttuDpomC2yKtxWYEW5iInM+nWptYAJOqrLu1gk2+8wGwtT
	 s6lYpq+8oS/jSTjX3Apb/dBXJvnGkO5LEwGthIildOynncvCpfwLM6GK67SoDMkzBb6EG
	 W+8WTSNy8P3YTeEWSc2BVQWRF34liAlxLUM2qlh1SJrZwGMeAEY3j/i0Td4f9TevaI//+
	 qOZpAYVLPuVnvAe8pFlmsDORKlwav8iS/e+eFpi5X7VWfjLe6CHSLLhqpWFjMA0EHSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055479;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o+LNRDQXQp4gZK84yundZ3H7fZhKK7sovbzUuiuB4j0=;
	b=ojbdSZbYFRiyJG0MvFIifOKNPPtKdzhEZeoppGZiuY92x7JRxmL+D7ab5EHSRPrm1+X0
	 IIZNGpS0I2BdN/AVLFGLnh6l5UGPD9vUSJWC1m44OlTo+rfey/OS81MvOYn1QXvHERY60
	 +1fechxzQt4iHVyjtdVciIKS8ah6kv+m26JO9XaIKD6HtKbqJzyq7A6GIYAgXLMwuO7Qj
	 AvmzZ8y2phizTEVuSBOnBPMJxV0DMmjVTUR0wZvzHcHINIYJC9n+Vi075UaEgZHWWb8QP
	 Nz88JyLcAyshyCSWiajqQ7wz3F6bhXlK9YUvvD0PqfxMf+FD1YGWlMZ1mdsZz0dSveQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BGgVSlGq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8670A606A325;
	Thu, 19 Nov 2026 02:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BGgVSlGq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D79131F000C4;
	Thu, 19 Nov 2026 02:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055479;
	bh=o+LNRDQXQp4gZK84yundZ3H7fZhKK7sovbzUuiuB4j0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BGgVSlGqWteTn/yU3GQpFjZC6a/sQKuZ77cF1p63CBcAg0JSBb8VOTaxsrKy+KFV1
	 Pv/XO5qLRWPI37AHw6icfAgAoxudwIYWQUrKgMJvL3qfNDq1Xy6vr3eFN/2NFpc7o6
	 LohRc+3F8pDuucC8PfOIPH7dLDjQjw1yyUgrnsFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1647/2214] ASoC: mediatek: mt8192: fix MCK clock error handling
Date: Wed, 18 Nov 2026 15:55:23 +0100
Message-ID: <20261118150117.792420061@linuxfoundation.org>
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



