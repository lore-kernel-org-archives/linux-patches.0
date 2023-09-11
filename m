Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C821711706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:46:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 460DBC433C7;
	Mon, 11 Sep 2023 14:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443613;
	bh=qvFxsfj0g1OknuyMe9kRn6OvDZZIhvydBWTI2Xx3d6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ixt3penLfeRCsAHPG6CI7G3bUt6eeOMYufN5iBg+QLBfshl7v36fKke78OvgfZ2tZ
	 XH+cSyeis4UhG6NWlqwc0dR6U84g+XtLWrLCYOxmfKvcdlUvs/GB5q2ToF5nFCMr+E
	 PqzeTJ+jWeWIs3hShT4eDf8Nn5g9od1Hj6YGO/S4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 422/737] clk: qcom: dispcc-sc8280xp: Use ret registers on GDSCs
Date: Mon, 11 Sep 2023 15:44:41 +0200
Message-ID: <20230911134702.392444666@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 20e1d75bc043c5ec1fd8f5169fde17db89eb11c3 ]

The DISP_CC GDSCs have not been instructed to use the ret registers.
Fix that.

Fixes: 4a66e76fdb6d ("clk: qcom: Add SC8280XP display clock controller")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230725-topic-8280_dispcc_gdsc-v1-1-236590060531@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/dispcc-sc8280xp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/qcom/dispcc-sc8280xp.c b/drivers/clk/qcom/dispcc-sc8280xp.c
index 167470beb3691..30f636b9f0ec8 100644
--- a/drivers/clk/qcom/dispcc-sc8280xp.c
+++ b/drivers/clk/qcom/dispcc-sc8280xp.c
@@ -3057,7 +3057,7 @@ static struct gdsc disp0_mdss_gdsc = {
 		.name = "disp0_mdss_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
-	.flags = HW_CTRL,
+	.flags = HW_CTRL | RETAIN_FF_ENABLE,
 };
 
 static struct gdsc disp1_mdss_gdsc = {
@@ -3069,7 +3069,7 @@ static struct gdsc disp1_mdss_gdsc = {
 		.name = "disp1_mdss_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
-	.flags = HW_CTRL,
+	.flags = HW_CTRL | RETAIN_FF_ENABLE,
 };
 
 static struct gdsc disp0_mdss_int2_gdsc = {
@@ -3081,7 +3081,7 @@ static struct gdsc disp0_mdss_int2_gdsc = {
 		.name = "disp0_mdss_int2_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
-	.flags = HW_CTRL,
+	.flags = HW_CTRL | RETAIN_FF_ENABLE,
 };
 
 static struct gdsc disp1_mdss_int2_gdsc = {
@@ -3093,7 +3093,7 @@ static struct gdsc disp1_mdss_int2_gdsc = {
 		.name = "disp1_mdss_int2_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
-	.flags = HW_CTRL,
+	.flags = HW_CTRL | RETAIN_FF_ENABLE,
 };
 
 static struct gdsc *disp0_cc_sc8280xp_gdscs[] = {
-- 
2.40.1



