Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0037E1FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A7FFC433C7;
	Tue,  1 Aug 2023 09:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883065;
	bh=H2poTrPZzfwau/81M7CFMAeFmbKZ+ib77jUqK2qh7EQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1RzGihk4/H+Vhj4ITt+78l/MysifHEDEBOy4/MqTe462TqZbajqG5ijKJP8xjxI7q
	 EpG6PVNQVtA9TAot2Tgv28PSLTLjojU79ujUOwBf7v9OqiOOB7gyN6e+7YVJQYsrdZ
	 Vop3fyfEF4IEHvxmFjZKEzjJd4c/FO6Itl51IwBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 103/239] drm/msm/dsi: Drop unused regulators from QCM2290 14nm DSI PHY config
Date: Tue,  1 Aug 2023 11:19:27 +0200
Message-ID: <20230801091929.425356250@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit 97368254a08e2ca4766e7f84a45840230fe77fa3 ]

The regulator setup was likely copied from other SoCs by mistake.  Just
like SM6125 the DSI PHY on this platform is not getting power from a
regulator but from the MX power domain.

Fixes: 572e9fd6d14a ("drm/msm/dsi: Add phy configuration for QCM2290")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/544536/
Link: https://lore.kernel.org/r/20230627-sm6125-dpu-v2-1-03e430a2078c@somainline.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c
index 3ce45b023e637..31deda1c664ad 100644
--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c
@@ -1087,8 +1087,6 @@ const struct msm_dsi_phy_cfg dsi_phy_14nm_8953_cfgs = {
 
 const struct msm_dsi_phy_cfg dsi_phy_14nm_2290_cfgs = {
 	.has_phy_lane = true,
-	.regulator_data = dsi_phy_14nm_17mA_regulators,
-	.num_regulators = ARRAY_SIZE(dsi_phy_14nm_17mA_regulators),
 	.ops = {
 		.enable = dsi_14nm_phy_enable,
 		.disable = dsi_14nm_phy_disable,
-- 
2.40.1



