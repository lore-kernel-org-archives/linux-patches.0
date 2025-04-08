Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D09526B2B1;
	Tue,  8 Apr 2025 12:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114394; cv=none; b=LU3poCpZmEipiZ9j9pNFWeaLwNR5izlUCKINfEwl4s4ocqd8ULbquTs4wk1LGkDgi4YXdSMbameWY632BMEhxpOaKxxqNdv+BxU9kEwmto0O56GB9Rramjw9ex57D7nr+k6SmFx6kDgvL7xhMRfFIXXsCL5fCJXn6eYmBLbrCpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114394; c=relaxed/simple;
	bh=BLAo4yJM+YuGZh4yhdqvH5u1vReJ5u2mRBvKHmrlfZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NxEMEsT5ZaMIWiVAu6mzGr+lf90Inblxb/NQlMwuaVWPXKY0MvUJotjdP8l/JE2ejajdJaCSYG6wQcgcj9QhxKkO5dMy/ItM82Y0QmCl9MbnI258+O/RvkyI+cgaeB48bd3JFlr/CKCxX0DPNvl1JWmhsJDlYWn9lZTT+SQNR+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QxiMRg40; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QxiMRg40"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2BB4C4CEEA;
	Tue,  8 Apr 2025 12:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114394;
	bh=BLAo4yJM+YuGZh4yhdqvH5u1vReJ5u2mRBvKHmrlfZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QxiMRg40EWxN9hbt8ffno6+liDyzxnOwltqmX6k0jp8azYUOxFkWTbYQb14lqlGrF
	 yntH7nXhDshdLS+XyZQZxKYbMtSb0ZWk8h821vwoWVoowMcS5NUBHkElE6cfZ8nYox
	 BLwl2/tyqkIeASoESmQXgjeGugnMvV49K9xjidDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 083/499] drm/msm/dsi/phy: Program clock inverters in correct register
Date: Tue,  8 Apr 2025 12:44:55 +0200
Message-ID: <20250408104853.291500761@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit baf49072877726616c7f5943a6b45eb86bfeca0a ]

Since SM8250 all downstream sources program clock inverters in
PLL_CLOCK_INVERTERS_1 register and leave the PLL_CLOCK_INVERTERS as
reset value (0x0).  The most recent Hardware Programming Guide for 3 nm,
4 nm, 5 nm and 7 nm PHYs also mention PLL_CLOCK_INVERTERS_1.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Fixes: 1ef7c99d145c ("drm/msm/dsi: add support for 7nm DSI PHY/PLL")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reported-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/634489/
Link: https://lore.kernel.org/r/20250129115504.40080-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c
index 798168180c1ab..a2c87c84aa05b 100644
--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c
@@ -305,7 +305,7 @@ static void dsi_pll_commit(struct dsi_pll_7nm *pll, struct dsi_pll_config *confi
 	writel(pll->phy->cphy_mode ? 0x00 : 0x10,
 	       base + REG_DSI_7nm_PHY_PLL_CMODE_1);
 	writel(config->pll_clock_inverters,
-	       base + REG_DSI_7nm_PHY_PLL_CLOCK_INVERTERS);
+	       base + REG_DSI_7nm_PHY_PLL_CLOCK_INVERTERS_1);
 }
 
 static int dsi_pll_7nm_vco_set_rate(struct clk_hw *hw, unsigned long rate,
-- 
2.39.5



