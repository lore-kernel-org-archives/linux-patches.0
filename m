Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7791D1302;
	Wed,  2 Oct 2024 14:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879661; cv=none; b=n9UmSLXChKKQbLqHQnldsTyLfLIJ/KwKiKftjo8V8qnuWBJ31dSgrLEIn6LWx+zKLuOm6NGOKbxpLAk/fu9M25Us/MdHldzrh/B5dPhnNS5gzCq8GRzM5sRVvT8kT5ODE+vV08QAILBJ5i6tdm7cETyPeQHexA5WFq6wd6fmTW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879661; c=relaxed/simple;
	bh=3n6oSA7WKHEPEX/tnwG7gY8+flshe/6kOqG2XOMKZzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WEOMR0g4pSX5TXoR4xjkc0Ra0lJNBNJ9BgHkcD9D6L2Do9+x9U3Sceb8JRMvmv6qNGLfR45zhLtFBC7TVqYcBpR5m5ngavoCfFQJCc7OqhbjRzFHTiZ8uTHr6FHC6N5Of5lFU8o0e6RHN+qVphBN2SFZAzT4s9oj+ewRZtTDTW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wbI4zauC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wbI4zauC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 479FAC4CEC2;
	Wed,  2 Oct 2024 14:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879661;
	bh=3n6oSA7WKHEPEX/tnwG7gY8+flshe/6kOqG2XOMKZzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wbI4zauCWsJccs6pUf4Jubs7whhLhRDUiKgd1U/Ysd6H7bWnZc5IFyVtWn67xWrwT
	 aetgVchI46NNeC7WQ5MWpTblB6PCtnvjsKM5CcSlbYKz8NMTx7lnCY0y1bkcsaNv69
	 kBXW3X2nrJRsBdEbgJBbP4D8zlEHS2cx6UcD1Ooo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 164/538] drm/msm/dsi: correct programming sequence for SM8350 / SM8450
Date: Wed,  2 Oct 2024 14:56:43 +0200
Message-ID: <20241002125758.727700148@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 89a6344bc8653..f72ce6a3c456d 100644
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



