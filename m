Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55AA3218D5;
	Mon, 18 Aug 2025 13:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522331; cv=none; b=nI1in5Njv/bU3oDztuD4GaK5R7K8KYYyuGJ9Rbf3VegXD86u/iONxuDSwwvnCahCp1SmdaUk6/ko6twT5mqOhYaaOCC5Pm887jQukBWhqMWxhoNbSh6KQWGleMm6U5pdpjkZVBlCsAkvyabjyKGPRUQe9ORpOq+qeVByc5v3szY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522331; c=relaxed/simple;
	bh=g6yAQmPlG3D2ItiqLRNr5Js4uf5gmzPWs04RA41Xh6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sER/MxNnOv0lJfY1R9CqCn2ckXuYV3aN4AD0FaLcPgW0zUpgtba2Jtvv3ZHLzeHyIa5fKP10HMI9Qi+fxygusLBOL92NXu7UQMvfZvgi2uibKzlVXLs2Sg1UFXl/H/PqX+gP6cDgmizxRm/NSA37W1txU+eEtPCC4h3tfrbHLCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pb48Xey3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pb48Xey3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C6EC4CEEB;
	Mon, 18 Aug 2025 13:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522331;
	bh=g6yAQmPlG3D2ItiqLRNr5Js4uf5gmzPWs04RA41Xh6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pb48Xey39nv/jrr69TC9pV1X0yYPb8iH9L9d6i1qPt2LjU6nrFTx1eO9OoGYvjcfe
	 ze6KumZ/9ymEQODe5RFgjQxragCoz2Pm/168Wx1ET7HxkPnOAmvaJyCB//kjLhtJ90
	 y5nQVFULQ53zwLd+dnHdQUkG+gmMEAAaFbJRe+oc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Geraldo Nascimento <geraldogabriel@gmail.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 283/444] phy: rockchip-pcie: Properly disable TEST_WRITE strobe signal
Date: Mon, 18 Aug 2025 14:45:09 +0200
Message-ID: <20250818124459.575538217@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

From: Geraldo Nascimento <geraldogabriel@gmail.com>

[ Upstream commit 25facbabc3fc33c794ad09d73f73268c0f8cbc7d ]

pcie_conf is used to touch TEST_WRITE strobe signal. This signal should
be enabled, a little time waited, and then disabled. Current code clearly
was copy-pasted and never disables the strobe signal. Adjust the define.
While at it, remove PHY_CFG_RD_MASK which has been unused since
64cdc0360811 ("phy: rockchip-pcie: remove unused phy_rd_cfg function").

Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Geraldo Nascimento <geraldogabriel@gmail.com>
Link: https://lore.kernel.org/r/d514d5d5627680caafa8b7548cbdfee4307f5440.1751322015.git.geraldogabriel@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/rockchip/phy-rockchip-pcie.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/phy/rockchip/phy-rockchip-pcie.c b/drivers/phy/rockchip/phy-rockchip-pcie.c
index 51cc5ece0e63..a75affbb49b6 100644
--- a/drivers/phy/rockchip/phy-rockchip-pcie.c
+++ b/drivers/phy/rockchip/phy-rockchip-pcie.c
@@ -30,9 +30,8 @@
 #define PHY_CFG_ADDR_SHIFT    1
 #define PHY_CFG_DATA_MASK     0xf
 #define PHY_CFG_ADDR_MASK     0x3f
-#define PHY_CFG_RD_MASK       0x3ff
 #define PHY_CFG_WR_ENABLE     1
-#define PHY_CFG_WR_DISABLE    1
+#define PHY_CFG_WR_DISABLE    0
 #define PHY_CFG_WR_SHIFT      0
 #define PHY_CFG_WR_MASK       1
 #define PHY_CFG_PLL_LOCK      0x10
-- 
2.39.5



