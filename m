Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9563B42A9B;
	Tue, 27 May 2025 17:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367697; cv=none; b=sqmYs+diM9rp4+eHS0+NdGjFUBoccem5pgAxhxYgjQXAVMoH3Hu0xufU8X/YcmIV3Mu6VcBqSub4p+ub3T38ZOyM4YfvdJ9dpB9tKOO1+acWlXX6F1SasoC1Uzkw5fseoeVXbW1nE3CPtwtYLO38tHzMmYAQ0yNpab2Oyqqe/Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367697; c=relaxed/simple;
	bh=V9Pic/ZYi7k9yG5/xMRj+Jxidi6iiKyL7uTZoB/0qcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kmrki9yZeL/Snp7zVJLaf5MuScunnbQKTrKsbIm5hGcs5/gevBt/+rwBJ34COuZAArYADkdKY+I/s+0JucpsfAOPE6UnaH9rnPc/IJSFTEeoOaBBE28JIAejCE1GNY9YXMibmt9wLl6SVSQDF8rRBQK4dQtsh+I/ApwBCFYdtkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Adrqe+C7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Adrqe+C7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09FD8C4CEE9;
	Tue, 27 May 2025 17:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367697;
	bh=V9Pic/ZYi7k9yG5/xMRj+Jxidi6iiKyL7uTZoB/0qcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Adrqe+C7ef3PIVBWsT/N3hKwdZErWZN7FwrtM7FeFLj8UDAfEnNMs4OMnTiFK/j0C
	 iot6SjQuGMTC4FI97UTIxvkaL+WpEaajcenObklDG/Rp2FPN3aQATHISq9OtFsuCJC
	 JuJ+UwmJHUM4mFlARrSIhcVES0cPHzKhLGoFvlrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damon Ding <damon.ding@rock-chips.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 470/783] phy: phy-rockchip-samsung-hdptx: Swap the definitions of LCPLL_REF and ROPLL_REF
Date: Tue, 27 May 2025 18:24:27 +0200
Message-ID: <20250527162532.270801142@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 2fb4f297fda3d..920abf6fa9bdd 100644
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



