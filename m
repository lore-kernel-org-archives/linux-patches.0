Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97E91D0BAE;
	Wed,  2 Oct 2024 14:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877829; cv=none; b=SGijLvj3Xhi4eQn4h+mc7Hh7BZi/9u3pDQCMfmlOmW3sg4AE3d0iFG4C6N0HERAwT0LKMB410H+P8H6eNcghqYrKnMhFRYWK9BUAxkL5vLtm5DNyGWBJYuHQZtxB9E5h7moXc2hzX2VhN2XOvu0W+6ncYjTZDn1vD4pv0xedXaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877829; c=relaxed/simple;
	bh=VA/qLN5H4O2a9zlk7oGh/PQZ+iUXPv+K8RwyFT8xtCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J+i5mZTL+YKtttKpCFqGdUWWPDOI9c60GFf58qT3970WybJHt2p7wgwvxIHC3qqRYiGUjhqeJFLSW+jewEPReKc9uuzr/3y4/InVE7AENIuY6exIqXQiD5CrKCiH+sWdyTOTe7sj5uii9q0i0uATC9J7Zc0W61qA+M0r873/IRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gK3mklg4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gK3mklg4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60263C4CEC5;
	Wed,  2 Oct 2024 14:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877828;
	bh=VA/qLN5H4O2a9zlk7oGh/PQZ+iUXPv+K8RwyFT8xtCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gK3mklg4t+wPhsjFpAd5Mnudt+vmxMWHa/e5UeYsO2/fsj+NxRMBqNEox7ByZrVLC
	 rfa/UU4J59EgVrgm2rH1QU/pEKuxnI1dxk02XaTlkWjbWzmJeAEsRIohTgiWLujT6L
	 hmDlrHtY4wGP4qQh/fgm5E4mTtN+moDs6o3oc3/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 209/634] drm/msm/dsi: correct programming sequence for SM8350 / SM8450
Date: Wed,  2 Oct 2024 14:55:09 +0200
Message-ID: <20241002125819.354767502@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 1328cb7c34bf6d056df9ff694ee5194537548258 ]

According to the display-drivers, 5nm DSI PLL (v4.2, v4.3) have
different boundaries for pll_clock_inverters programming. Follow the
vendor code and use correct values.

Fixes: 2f9ae4e395ed ("drm/msm/dsi: add support for DSI-PHY on SM8350 and SM8450")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/606947/
Link: https://lore.kernel.org/r/20240804-sm8350-fixes-v1-3-1149dd8399fe@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c
index 82d015aa2d634..29aa91238bc47 100644
--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c
@@ -135,7 +135,7 @@ static void dsi_pll_calc_dec_frac(struct dsi_pll_7nm *pll, struct dsi_pll_config
 			config->pll_clock_inverters = 0x00;
 		else
 			config->pll_clock_inverters = 0x40;
-	} else {
+	} else if (pll->phy->cfg->quirks & DSI_PHY_7NM_QUIRK_V4_1) {
 		if (pll_freq <= 1000000000ULL)
 			config->pll_clock_inverters = 0xa0;
 		else if (pll_freq <= 2500000000ULL)
@@ -144,6 +144,16 @@ static void dsi_pll_calc_dec_frac(struct dsi_pll_7nm *pll, struct dsi_pll_config
 			config->pll_clock_inverters = 0x00;
 		else
 			config->pll_clock_inverters = 0x40;
+	} else {
+		/* 4.2, 4.3 */
+		if (pll_freq <= 1000000000ULL)
+			config->pll_clock_inverters = 0xa0;
+		else if (pll_freq <= 2500000000ULL)
+			config->pll_clock_inverters = 0x20;
+		else if (pll_freq <= 3500000000ULL)
+			config->pll_clock_inverters = 0x00;
+		else
+			config->pll_clock_inverters = 0x40;
 	}
 
 	config->decimal_div_start = dec;
-- 
2.43.0



