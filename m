Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444EB335BA1;
	Mon, 18 Aug 2025 13:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524010; cv=none; b=QDSParJorXY+2BjMGOlw+fhtvmMDUyXbzM+AjbHFHq5BRwNLyBo14MhHCjzZqU565jZDc8xiLj1R5KEjT+qjhYvI/dX6su9ldsPiucniZ7vKitfGgs4CPoEXtc4+tJh5q4R9IbAX54qKMtbQwfAllTp4agAHoiW5Mdd4XDoC1h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524010; c=relaxed/simple;
	bh=8MJ0LrtYpQKXduGvQwj1SCfdhebBs9C4DHyznQXJF+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dWKPOsdB2RIMVGb3hFp1vaxd7PIwLTZS6pY+VdcMWQSr+5jImhKsreMN6d1cQ2MRdaNM4wAmPslOUOD+Tycr23BX55h4TmxuRqvBcq+sH59esC32cd5KtRAHcLGmfbj4eN49ze9/TlPbg2h1EEiD0mEnbD6jNvS43MR8nVMHYJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D5JPldfi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D5JPldfi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5175C4CEEB;
	Mon, 18 Aug 2025 13:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524010;
	bh=8MJ0LrtYpQKXduGvQwj1SCfdhebBs9C4DHyznQXJF+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D5JPldfiAcFZx9NdhwQ3cj8KgCvvHTv4RGoaiapubutlczfaZhYzsf5fbPI8q5LOT
	 L7hd49IrGXzm+y+kL2jbzzOXf44OthvHHhtx/0gTut3tmOFTo1HwIamuNTRIjeTbOy
	 74QbJSp+w+2Mfc9B6/sFzu/X81CvucZLFbMjSsw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Valmantas Paliksa <walmis@gmail.com>,
	Geraldo Nascimento <geraldogabriel@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 341/515] phy: rockchip-pcie: Enable all four lanes if required
Date: Mon, 18 Aug 2025 14:45:27 +0200
Message-ID: <20250818124511.554635376@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Valmantas Paliksa <walmis@gmail.com>

[ Upstream commit c3fe7071e196e25789ecf90dbc9e8491a98884d7 ]

Current code enables only Lane 0 because pwr_cnt will be incremented on
first call to the function. Let's reorder the enablement code to enable
all 4 lanes through GRF.

Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>

Signed-off-by: Valmantas Paliksa <walmis@gmail.com>
Signed-off-by: Geraldo Nascimento <geraldogabriel@gmail.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/16b610aab34e069fd31d9f57260c10df2a968f80.1751322015.git.geraldogabriel@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-pcie.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-pcie.c b/drivers/phy/rockchip/phy-rockchip-pcie.c
index 63e88abc66c6..4e2dfd01adf2 100644
--- a/drivers/phy/rockchip/phy-rockchip-pcie.c
+++ b/drivers/phy/rockchip/phy-rockchip-pcie.c
@@ -159,6 +159,12 @@ static int rockchip_pcie_phy_power_on(struct phy *phy)
 
 	guard(mutex)(&rk_phy->pcie_mutex);
 
+	regmap_write(rk_phy->reg_base,
+		     rk_phy->phy_data->pcie_laneoff,
+		     HIWORD_UPDATE(!PHY_LANE_IDLE_OFF,
+				   PHY_LANE_IDLE_MASK,
+				   PHY_LANE_IDLE_A_SHIFT + inst->index));
+
 	if (rk_phy->pwr_cnt++) {
 		return 0;
 	}
@@ -175,12 +181,6 @@ static int rockchip_pcie_phy_power_on(struct phy *phy)
 				   PHY_CFG_ADDR_MASK,
 				   PHY_CFG_ADDR_SHIFT));
 
-	regmap_write(rk_phy->reg_base,
-		     rk_phy->phy_data->pcie_laneoff,
-		     HIWORD_UPDATE(!PHY_LANE_IDLE_OFF,
-				   PHY_LANE_IDLE_MASK,
-				   PHY_LANE_IDLE_A_SHIFT + inst->index));
-
 	/*
 	 * No documented timeout value for phy operation below,
 	 * so we make it large enough here. And we use loop-break
-- 
2.39.5



