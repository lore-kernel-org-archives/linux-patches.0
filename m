Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1D01170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:09:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B52BC433C7;
	Mon, 11 Sep 2023 14:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441374;
	bh=R6pCJE4bCtCCjPbE/r6kR5V48apYQyCI0Cvi67ZzXsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kkbkBruNL0dfQdcPk2YcNGF1dpbzIWszO8ZShUwU4k/rHATuq+stN+ep+WySTDonC
	 sZ2+FcJkgpgS6LObnGLElGjpo1nvi0mQtMVCoJkKFZp4Azt9+pFue/A4xzUorGZb5a
	 555cFYZCmi9JxBU7sAkPlUW+E9bx9CEj8b50rgu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 390/739] clk: qcom: dispcc-sc8280xp: Use ret registers on GDSCs
Date: Mon, 11 Sep 2023 15:43:09 +0200
Message-ID: <20230911134702.083855268@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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



