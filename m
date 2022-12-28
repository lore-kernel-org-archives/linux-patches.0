Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583E31C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:31:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B65B1C433D2;
	Wed, 28 Dec 2022 16:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245117;
	bh=v875tMKwwAeXW+bic6yRinnmQxsfzhGoBFpUxv4aiRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QoFsV7aUgCidzYhij6zYI8pZmtV2LM+fhbmoYfWDQ6qhHCqHp8l0g//6Jj4QKh3MB
	 IWBI6Ni5AQ4xZyrIHoiI36e5SyxN01tVYvXQ3SKcrbRW3sAjWvVzTHRXt3mDFgytci
	 6W+U3BtaG7BVKssH8hnL1A0j0txTrx4fbgSPmDNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0799/1146] phy: qcom-qmp-pcie: fix sc8180x initialisation
Date: Wed, 28 Dec 2022 15:38:58 +0100
Message-Id: <20221228144351.852243121@linuxfoundation.org>
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

[ Upstream commit 4a9eac5ae2200f1b208dd33738777f89f93dc0fe ]

The phy_status mask was never set for SC8180X which meant that the
driver would not wait for the PHY to be initialised during power-on and
would never detect PHY initialisation timeouts.

Fixes: f839f14e24f2 ("phy: qcom-qmp: Add sc8180x PCIe support")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20221012085002.24099-1-johan+linaro@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-pcie.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c b/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
index 764029b3a26b..4b85b0c027d5 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
@@ -1693,6 +1693,7 @@ static const struct qmp_phy_cfg sc8180x_pciephy_cfg = {
 
 	.start_ctrl		= PCS_START | SERDES_START,
 	.pwrdn_ctrl		= SW_PWRDN | REFCLK_DRV_DSBL,
+	.phy_status		= PHYSTATUS,
 };
 
 static const struct qmp_phy_cfg sdx55_qmp_pciephy_cfg = {
-- 
2.35.1



