Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8E11C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:32:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51BCEC433EF;
	Wed, 28 Dec 2022 16:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245127;
	bh=c1p2GGnfiBQv48CjHps/2/8lXoGXcBXw1/YdZC0f7IU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yiOmhBRUHnBvtqn/vQen01a4tftkKlFLJzsWqdSdu3rGUaYjgPCL45JnLICWCZQ01
	 SZ7Rygtb/mFARLoTPxkNatvq5iCMW4vC7Jzr4D6d3kmbwY4Qu/WLfGDZuutkfZYag9
	 A/jF2/jO8Wj8XeogsESwILV9pdmav0lafVs7XIBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0801/1146] phy: qcom-qmp-pcie: fix ipq6018 initialisation
Date: Wed, 28 Dec 2022 15:39:00 +0100
Message-Id: <20221228144351.906623950@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit 30518b19895789aa9101474af2ee0f62cd882d5e ]

The phy_status mask was never set for IPQ6018 which meant that the
driver would not wait for the PHY to be initialised during power-on and
would never detect PHY initialisation timeouts.

Fixes: 520264db3bf9 ("phy: qcom-qmp: add QMP V2 PCIe PHY support for ipq60xx")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20221012085002.24099-3-johan+linaro@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-pcie.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c b/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
index 842ddc3e0a1c..6c6c4b7b6b25 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
@@ -1525,6 +1525,7 @@ static const struct qmp_phy_cfg ipq6018_pciephy_cfg = {
 
 	.start_ctrl		= SERDES_START | PCS_START,
 	.pwrdn_ctrl		= SW_PWRDN | REFCLK_DRV_DSBL,
+	.phy_status		= PHYSTATUS,
 };
 
 static const struct qmp_phy_cfg sdm845_qmp_pciephy_cfg = {
-- 
2.35.1



