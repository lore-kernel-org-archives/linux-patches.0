Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA28168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:53:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337F0C433EF;
	Mon,  8 May 2023 10:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543212;
	bh=jeuc4JoFCPqwXiJad/GWe37t5buoUxk7bGN9lF/fzn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZQBgYl08X96Ji5r+2De7tXimP33styTLNPV40jTcspcnPcfbDL6qqP0b+iOE6BGJt
	 D0CHbxdqk3t3l704Su0IrY+p8seht8d+xN6BU6rPlCVtqIYKb5miK61EawfFKYu5DZ
	 aU3oEvmp4RBbPrjNQZkQD3CduuJl7x01MQARPFzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinod Koul <vkoul@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH 6.3 008/694] phy: qcom-qmp-pcie: sc8180x PCIe PHY has 2 lanes
Date: Mon,  8 May 2023 11:37:23 +0200
Message-Id: <20230508094432.906917602@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

commit 1db6b0a4246ce708b89f5136571130b9987741d1 upstream.

All PCIe PHYs on sc8180x platform have 2 lanes, so change the number of
lanes to 2.

Fixes: f839f14e24f2 ("phy: qcom-qmp: Add sc8180x PCIe support")
Cc: stable@vger.kernel.org # 5.15
Sgned-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20230331151250.4049-1-dmitry.baryshkov@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-pcie.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-pcie.c
@@ -2152,7 +2152,7 @@ static const struct qmp_phy_cfg msm8998_
 };
 
 static const struct qmp_phy_cfg sc8180x_pciephy_cfg = {
-	.lanes			= 1,
+	.lanes			= 2,
 
 	.tbls = {
 		.serdes		= sc8180x_qmp_pcie_serdes_tbl,


