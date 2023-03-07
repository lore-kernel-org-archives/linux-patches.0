Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0891FBA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:06:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B4A7C433D2;
	Tue,  7 Mar 2023 18:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212380;
	bh=pT08+Ag+ZJPUxmTHA6oYAUDsL2HMfkPh36QdEuKE48c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=adUQTYvgafwn1xURI75cdXRGMyhvUVaGUjmLG+F6pDCgKE25JZ94LHfN28HIKUb2q
	 R1K64ig9zGNMLA60GCq9VAV7erCQfqQvS3iULIeyNnL/0jLN+mu2kww59RU6+V4ciT
	 OENUnKXdH7oOyjXJ7egSOV2lc6TUWM2NT7QOjkuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viorel Suman <viorel.suman@nxp.com>,
	Dong Aisheng <Aisheng.dong@nxp.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 167/885] thermal/drivers/imx_sc_thermal: Fix the loop condition
Date: Tue,  7 Mar 2023 17:51:41 +0100
Message-Id: <20230307170009.187431572@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Viorel Suman <viorel.suman@nxp.com>

[ Upstream commit 4b26b7c9cdefdcb478047c30901d2379ef9e50fc ]

The minimal resource ID is 0: IMX_SC_R_AP_0=0, so fix
the loop condition. Aside of this - constify the array.

Fixes: 31fd4b9db13b ("thermal/drivers/imx_sc: Rely on the platform data to get the resource id")
Signed-off-by: Viorel Suman <viorel.suman@nxp.com>
Reviewed-by: Dong Aisheng <Aisheng.dong@nxp.com>
Link: https://lore.kernel.org/r/20230117091956.61729-1-viorel.suman@oss.nxp.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/imx_sc_thermal.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/imx_sc_thermal.c b/drivers/thermal/imx_sc_thermal.c
index 4df925e3a80bd..dfadb03580ae1 100644
--- a/drivers/thermal/imx_sc_thermal.c
+++ b/drivers/thermal/imx_sc_thermal.c
@@ -88,7 +88,7 @@ static int imx_sc_thermal_probe(struct platform_device *pdev)
 	if (!resource_id)
 		return -EINVAL;
 
-	for (i = 0; resource_id[i] > 0; i++) {
+	for (i = 0; resource_id[i] >= 0; i++) {
 
 		sensor = devm_kzalloc(&pdev->dev, sizeof(*sensor), GFP_KERNEL);
 		if (!sensor)
@@ -127,7 +127,7 @@ static int imx_sc_thermal_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int imx_sc_sensors[] = { IMX_SC_R_SYSTEM, IMX_SC_R_PMIC_0, -1 };
+static const int imx_sc_sensors[] = { IMX_SC_R_SYSTEM, IMX_SC_R_PMIC_0, -1 };
 
 static const struct of_device_id imx_sc_thermal_table[] = {
 	{ .compatible = "fsl,imx-sc-thermal", .data =  imx_sc_sensors },
-- 
2.39.2



