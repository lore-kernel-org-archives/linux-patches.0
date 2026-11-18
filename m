Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048042;
	b=UghdnYmDBQkNnB0J2sCck3P/X65n49A7jv3WkXW488zECUujycVu3Gk9v4gL9N22C+57
	 8I8U0jx7tIOWAgngMITyKGjZhsfoPh44LP7CiUTniHvSIfuuXZ+JgYNBW5cGQ/pEe1ysV
	 OSsBdng7nerhzUjpmzGYLoxhyex3quPaX7H9o6Vc+foKKqb+zVnI3KOyqdt8NpWLvm3+d
	 P4Ufa9SZQT3KDaq1eLrtzhYNdJJ0jkCTeAqyfhOYyV7uzU62isVBfvT3ib/oYto25WJ0n
	 KwtZtZFpg0Z/UnzJqcwrLTOoU8n1xd19okFzAutQk1zT0uA27Eag6WlFLJhI2QSLgIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048042;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GfCUiWkHzEeGo7cizWbEBknbpQ+SXT/AOx/h4o94WF4=;
	b=VTfk28vTsTXZf2Y0icn2y2d/lnLvLEYCl1rQXZEjJgJz+NoW7YyVOtWryDrydjhPbidx
	 pdyeZ9Ql4JGLf6IMf5OGwNXwhf+GE2jqfN4EC4ATcFTGJ5SlZwyolc8DOgAwxAVcgu3m+
	 7NYx9u0ihUWB4u17VmdqIf6mE64F5Cl3ac+aTyhjK26rv7ilEJptoAUs9hvS/0xgNAQUS
	 N7Wyxkt4aULDs/AImQTtGhT9cghMB9HxnU7YWmSc3AziZLOa+jPIXSok6et91xRj4eDhm
	 13AWaboeGTmj/c1xeEjUYtRcvP+J+04RLysI8/lEMsI98e0CkMgwIb9doNG99713c2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TNPHOZ8J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA09D606A325;
	Thu, 19 Nov 2026 00:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TNPHOZ8J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E26E1F000C4;
	Thu, 19 Nov 2026 00:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048042;
	bh=GfCUiWkHzEeGo7cizWbEBknbpQ+SXT/AOx/h4o94WF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TNPHOZ8JqZH5Xs+O3jj0lKQTO+zOMuCiIPSEN3Q/n/oyDMffOyqKnBt8tAYj4MoD6
	 IKMEnEuImAU2KYm1Wofd99KdSc2aU3G/hB9/dSVv8YbohwxucYgvNlgWoBjYA73Uhu
	 0wpE+BsXnCgN6qro1+SepwTEQ5VID+uNQs4TyRpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1817/2857] ASoC: mediatek: mt8186: Fix MCK error handling
Date: Wed, 18 Nov 2026 15:47:31 +0100
Message-ID: <20261118150306.661562140@linuxfoundation.org>
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

[ Upstream commit 996469c1092e8fa81fac98d819174ce56baff821 ]

The mt8186_mck_enable() function returns immediately when a clock
operation fails, leaving previously enabled clocks active.

Add error paths to disable previously enabled clocks before returning
the error.

Fixes: 55b423d5623c ("ASoC: mediatek: mt8186: support audio clock control in platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260903051150.178057-6-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8186/mt8186-afe-clk.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/sound/soc/mediatek/mt8186/mt8186-afe-clk.c b/sound/soc/mediatek/mt8186/mt8186-afe-clk.c
index c941d7dc08aea..b2a6d4d7de1b7 100644
--- a/sound/soc/mediatek/mt8186/mt8186-afe-clk.c
+++ b/sound/soc/mediatek/mt8186/mt8186-afe-clk.c
@@ -577,7 +577,7 @@ int mt8186_mck_enable(struct mtk_base_afe *afe, int mck_id, int rate)
 		if (ret) {
 			dev_err(afe->dev, "%s(), clk_prepare_enable %s fail %d\n",
 				__func__, aud_clks[m_sel_id], ret);
-			return ret;
+			goto ERR_ENABLE_MCLK;
 		}
 		ret = clk_set_parent(afe_priv->clk[m_sel_id],
 				     afe_priv->clk[apll_clk_id]);
@@ -585,7 +585,7 @@ int mt8186_mck_enable(struct mtk_base_afe *afe, int mck_id, int rate)
 			dev_err(afe->dev, "%s(), clk_set_parent %s-%s fail %d\n",
 				__func__, aud_clks[m_sel_id],
 				aud_clks[apll_clk_id], ret);
-			return ret;
+			goto ERR_SELECT_MCLK;
 		}
 	}
 
@@ -594,16 +594,25 @@ int mt8186_mck_enable(struct mtk_base_afe *afe, int mck_id, int rate)
 	if (ret) {
 		dev_err(afe->dev, "%s(), clk_prepare_enable %s fail %d\n",
 			__func__, aud_clks[div_clk_id], ret);
-		return ret;
+		goto ERR_ENABLE_MCLK_DIV;
 	}
 	ret = clk_set_rate(afe_priv->clk[div_clk_id], rate);
 	if (ret) {
 		dev_err(afe->dev, "%s(), clk_set_rate %s, rate %d, fail %d\n",
 			__func__, aud_clks[div_clk_id], rate, ret);
-		return ret;
+		goto ERR_SET_MCLK_RATE;
 	}
 
 	return 0;
+
+ERR_SET_MCLK_RATE:
+	clk_disable_unprepare(afe_priv->clk[div_clk_id]);
+ERR_ENABLE_MCLK_DIV:
+ERR_SELECT_MCLK:
+	if (m_sel_id >= 0)
+		clk_disable_unprepare(afe_priv->clk[m_sel_id]);
+ERR_ENABLE_MCLK:
+	return ret;
 }
 
 void mt8186_mck_disable(struct mtk_base_afe *afe, int mck_id)
-- 
2.53.0



