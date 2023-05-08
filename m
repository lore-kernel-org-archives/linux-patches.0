Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5951713AF4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:19:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B3DC4339B;
	Mon,  8 May 2023 10:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541173;
	bh=FJGBPhD8kC3far5fAYAih91aYmVJMrhZCVgzIxdDpMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hgUkvDe7AJOZpnUqyJdf3Do8Is+wH2SEX1cz31pZYRxsTvHYVGi+kZ2RmUMq+dtqR
	 Gvr2a8RYPTDFIsHFWfDMErXD+HDfVPZW09nG4yLak8JGccGCVzvoVSAPoVMHBKPNzJ
	 dbPsFai3wwuyg6qHr0UZIcZ1PR8utH+YE9GYpybQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinod Koul <vkoul@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH 6.2 029/663] phy: qcom-qmp-pcie: sc8180x PCIe PHY has 2 lanes
Date: Mon,  8 May 2023 11:37:35 +0200
Message-Id: <20230508094429.390431255@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
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
@@ -1854,7 +1854,7 @@ static const struct qmp_phy_cfg msm8998_
 };
 
 static const struct qmp_phy_cfg sc8180x_pciephy_cfg = {
-	.lanes			= 1,
+	.lanes			= 2,
 
 	.tbls = {
 		.serdes		= sc8180x_qmp_pcie_serdes_tbl,


