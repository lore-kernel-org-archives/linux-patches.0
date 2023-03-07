Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A59BBA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:06:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8365CC4339B;
	Tue,  7 Mar 2023 18:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212377;
	bh=vfUAMRT1qE9J1/aqt0rnCESVFB3WSq9+Qg8UAOepUoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sdPiElK0NrWtUq/bfiOqlvEFuFAqY0MT3ShKCwjJzZZP2ubVG6W6iVd3SgefZjVgF
	 xfgKTH9qGYk+/P8zXvba+SgtgZLlQeC6lAvERRIA3PbbP3+Fn3V7WEKgBRnoe+JXgt
	 oOt8zk+ctmmWV9DN2p2DD3sTWyQC7RmH5N5clCBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 166/885] thermal/drivers/imx_sc_thermal: Drop empty platform remove function
Date: Tue,  7 Mar 2023 17:51:40 +0100
Message-Id: <20230307170009.145303437@linuxfoundation.org>
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

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 5011a110295d25418f5918a6af7bfcdb00dd4e34 ]

A remove callback just returning 0 is equivalent to no remove callback
at all. So drop the useless function.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20221212220217.3777176-1-u.kleine-koenig@pengutronix.de
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
Stable-dep-of: 4b26b7c9cdef ("thermal/drivers/imx_sc_thermal: Fix the loop condition")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/imx_sc_thermal.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/thermal/imx_sc_thermal.c b/drivers/thermal/imx_sc_thermal.c
index 5d92b70a5d53a..4df925e3a80bd 100644
--- a/drivers/thermal/imx_sc_thermal.c
+++ b/drivers/thermal/imx_sc_thermal.c
@@ -127,11 +127,6 @@ static int imx_sc_thermal_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int imx_sc_thermal_remove(struct platform_device *pdev)
-{
-	return 0;
-}
-
 static int imx_sc_sensors[] = { IMX_SC_R_SYSTEM, IMX_SC_R_PMIC_0, -1 };
 
 static const struct of_device_id imx_sc_thermal_table[] = {
@@ -142,7 +137,6 @@ MODULE_DEVICE_TABLE(of, imx_sc_thermal_table);
 
 static struct platform_driver imx_sc_thermal_driver = {
 		.probe = imx_sc_thermal_probe,
-		.remove	= imx_sc_thermal_remove,
 		.driver = {
 			.name = "imx-sc-thermal",
 			.of_match_table = imx_sc_thermal_table,
-- 
2.39.2



