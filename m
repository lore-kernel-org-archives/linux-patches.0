Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA281C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:25:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F1F8C433F1;
	Wed, 28 Dec 2022 16:25:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672244743;
	bh=2eJ6V1wIkJp7Pt/McqCpFA1DrIvXB5FPl9d2Ofr8wd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sjyOiBC0Dsepg9LsIfme4UZABFQ9cQEqmdWHFTfBwyRhpelGI69xUh89v18VGWHxc
	 6Vf9mGV7tcwK1pKK6qE/TMBhk0rA4Zv0Qnz0VJ9D6dM0kgdKcOY8S1xhJrCc4FjIzM
	 NCWUJxwaX14uS5AfTCqQyYYfdPspugDm14uCUsXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0766/1073] phy: qcom-qmp-pcie: fix ipq8074-gen3 initialisation
Date: Wed, 28 Dec 2022 15:39:14 +0100
Message-Id: <20221228144348.820424812@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

[ Upstream commit 94b7288eadf6e2c09e6280c65a9d07cca01bf434 ]

The phy_status mask was never set for IPQ8074 (gen3) which meant that
the driver would not wait for the PHY to be initialised during power-on
and would never detect PHY initialisation timeouts.

Fixes: 334fad185415 ("phy: qcom-qmp-pcie: add IPQ8074 PCIe Gen3 QMP PHY support")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20221012085002.24099-2-johan+linaro@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-pcie.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c b/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
index 6d790f2107f5..b17248506fe8 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
@@ -1564,6 +1564,7 @@ static const struct qmp_phy_cfg ipq8074_pciephy_gen3_cfg = {
 
 	.start_ctrl		= SERDES_START | PCS_START,
 	.pwrdn_ctrl		= SW_PWRDN | REFCLK_DRV_DSBL,
+	.phy_status		= PHYSTATUS,
 
 	.has_pwrdn_delay	= true,
 	.pwrdn_delay_min	= 995,		/* us */
-- 
2.35.1



