Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941911C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:32:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18169C433EF;
	Wed, 28 Dec 2022 16:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245122;
	bh=trbombmzy/J21LlAhr3qICdH815xbrpdGat7fXV2Y5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HevdSiqo6Qk+Hx7EanD/D5TkslQwtNokbndaHN+zlDOykQYyWnocBW+F/gwxrr4+s
	 twUSLV7QoAuvoKzFuQFZkeihPmPval/ob6HwvOKl2YjEx4iuwneIwO/WmVUDruXgo0
	 kkMquNcyXOwnbfQomzAM7Hy4IPZutq+3/XrVIgQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0800/1146] phy: qcom-qmp-pcie: fix ipq8074-gen3 initialisation
Date: Wed, 28 Dec 2022 15:38:59 +0100
Message-Id: <20221228144351.879866989@linuxfoundation.org>
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
index 4b85b0c027d5..842ddc3e0a1c 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
@@ -1497,6 +1497,7 @@ static const struct qmp_phy_cfg ipq8074_pciephy_gen3_cfg = {
 
 	.start_ctrl		= SERDES_START | PCS_START,
 	.pwrdn_ctrl		= SW_PWRDN | REFCLK_DRV_DSBL,
+	.phy_status		= PHYSTATUS,
 
 	.pipe_clock_rate	= 250000000,
 };
-- 
2.35.1



