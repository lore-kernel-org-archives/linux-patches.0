Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D92495C2;
	Thu, 30 Nov 2023 16:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uHd7S+OX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B42CC433C8;
	Thu, 30 Nov 2023 16:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361448;
	bh=IjWk9tETeq2kFz3c0IMBPvMGYKeH0uzQOzqHHDfpTZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uHd7S+OXSce5W54Xbhuad0LqpVk98kZads9oDjxFqjv+N9lpH1BdmkhkAhHfw4sld
	 oYLvaz6/grhLpIK8kbbuVQrQBvtT+WtqAsYamNowIUd+IoKiUVijm8UpkKzS5XcFJp
	 TUz1E60hBQd0f6ELlWeHZYSvstkzV2VnCSWPW2HM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Marek <jonathan@marek.ca>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 007/112] drm/msm/dsi: use the correct VREG_CTRL_1 value for 4nm cphy
Date: Thu, 30 Nov 2023 16:20:54 +0000
Message-ID: <20231130162140.551424229@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
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

From: Jonathan Marek <jonathan@marek.ca>

[ Upstream commit b3e0f94d15700ac8e8c1c2355834f5d5c753c41d ]

Use the same value as the downstream driver. This change is needed for CPHY
mode to work correctly.

Fixes: 8b034e677111 ("drm/msm/dsi: add support for DSI-PHY on SM8550")
Signed-off-by: Jonathan Marek <jonathan@marek.ca>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/566987/
Link: https://lore.kernel.org/r/20231110000216.29979-1-jonathan@marek.ca
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c
index 3b1ed02f644d2..89a6344bc8653 100644
--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_7nm.c
@@ -918,7 +918,7 @@ static int dsi_7nm_phy_enable(struct msm_dsi_phy *phy,
 	if ((phy->cfg->quirks & DSI_PHY_7NM_QUIRK_V5_2)) {
 		if (phy->cphy_mode) {
 			vreg_ctrl_0 = 0x45;
-			vreg_ctrl_1 = 0x45;
+			vreg_ctrl_1 = 0x41;
 			glbl_rescode_top_ctrl = 0x00;
 			glbl_rescode_bot_ctrl = 0x00;
 		} else {
-- 
2.42.0



