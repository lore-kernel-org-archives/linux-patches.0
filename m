Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7FE2110E;
	Tue, 27 May 2025 17:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365547; cv=none; b=aMW6UsdaMK64mBAK3M/FJqY7UyK0GIWlo6qU/6NJ4omedxBGSGVKHAhD5Hm+ezYZT5NED28RZK+8GyhMai5GQ8BJSj/t3MurJeIBqqm1i5pRRG+R9BayP4SnyrF9Xao1obQBVGLL2tY4Jw5ww6X8MOOmr5DJ+nVKVCl2Z1ndRvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365547; c=relaxed/simple;
	bh=a1ELm9yYsu+Igx92l8flmi/wTpP4ZKl/1PW9hsyaB6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EFZa7HiMUBvTybsd/4tG6qL3SZZNs4+sM12dW+jboW9jfTsz2qm4YLjIPQw1hdBySb0tn7U6ExuSkQqy+eZeeogZVizE036ZIAMll2PQSutKFa36FLpGPoKUrwzp420YPXl6kryirQZGlvB87t/xLAh3LWOSRKNp5nmBIfLQG2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z1iEGbmh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z1iEGbmh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D098C4CEE9;
	Tue, 27 May 2025 17:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365546;
	bh=a1ELm9yYsu+Igx92l8flmi/wTpP4ZKl/1PW9hsyaB6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z1iEGbmh6mQtSvECMjQxXPaQNnwQ3QTXe1S1DLqMxreG7Ah2FLWe3q5gzK/G8nCqI
	 f5NeEGwoC5SPUVr7gH9e8ZjYfnxuDJ6Znko4KAh9NFtlHyotE3Ot9zRPs0Xwn2kvTO
	 lA1DzqDuzlO774vYbedWTZea/UmYwzFvvTHNqaA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damon Ding <damon.ding@rock-chips.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 381/626] phy: phy-rockchip-samsung-hdptx: Swap the definitions of LCPLL_REF and ROPLL_REF
Date: Tue, 27 May 2025 18:24:34 +0200
Message-ID: <20250527162500.495206668@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damon Ding <damon.ding@rock-chips.com>

[ Upstream commit 2947c8065e9efdd3b6434d2817dc8896234a3fc0 ]

According to the datasheet, setting the dig_clk_sel bit of CMN_REG(0097)
to 1'b1 selects LCPLL as the reference clock, while setting it to 1'b0
selects the ROPLL.

Signed-off-by: Damon Ding <damon.ding@rock-chips.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20250205105157.580060-2-damon.ding@rock-chips.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c b/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
index be6f1ca9095aa..dc6e01dff5c74 100644
--- a/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
+++ b/drivers/phy/rockchip/phy-rockchip-samsung-hdptx.c
@@ -94,8 +94,8 @@
 #define LCPLL_ALONE_MODE		BIT(1)
 /* CMN_REG(0097) */
 #define DIG_CLK_SEL			BIT(1)
-#define ROPLL_REF			BIT(1)
-#define LCPLL_REF			0
+#define LCPLL_REF			BIT(1)
+#define ROPLL_REF			0
 /* CMN_REG(0099) */
 #define CMN_ROPLL_ALONE_MODE		BIT(2)
 #define ROPLL_ALONE_MODE		BIT(2)
-- 
2.39.5



