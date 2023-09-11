Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9A31170D
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23CFC433C8;
	Mon, 11 Sep 2023 14:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441414;
	bh=eSxRgnxSyv+W01+qE/cRKknoXssgEfaKOptHX7AM8po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pEH5xIZiACkS2/ewgzTmfBZp+/Cl8saEyL6kd7aTwavfllfyoOKVTDZtnSJ1s5WUQ
	 1UwSrEi6N16rSO/XiIPwovJWRJCeWtvvURvD1zrBXy6PpC/WDzTeq0a5iwUos0w2T2
	 nncwURaaSqSeUXAVvYnh9zm945CDMeixXZIGGWsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 378/739] clk: qcom: gcc-sc8280xp: Add missing GDSC flags
Date: Mon, 11 Sep 2023 15:42:57 +0200
Message-ID: <20230911134701.727239167@linuxfoundation.org>
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

[ Upstream commit 2fd02de27054576a4a8c89302e2f77122c55e957 ]

All of the 8280's GCC GDSCs can and should use the retain registers so
as not to lose their state when entering lower power modes.

Fixes: d65d005f9a6c ("clk: qcom: add sc8280xp GCC driver")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Acked-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20230620-topic-sc8280_gccgdsc-v2-1-562c1428c10d@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sc8280xp.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/clk/qcom/gcc-sc8280xp.c b/drivers/clk/qcom/gcc-sc8280xp.c
index b90c71637814b..64bea886322d4 100644
--- a/drivers/clk/qcom/gcc-sc8280xp.c
+++ b/drivers/clk/qcom/gcc-sc8280xp.c
@@ -6761,7 +6761,7 @@ static struct gdsc pcie_0_tunnel_gdsc = {
 		.name = "pcie_0_tunnel_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
-	.flags = VOTABLE,
+	.flags = VOTABLE | RETAIN_FF_ENABLE,
 };
 
 static struct gdsc pcie_1_tunnel_gdsc = {
@@ -6772,7 +6772,7 @@ static struct gdsc pcie_1_tunnel_gdsc = {
 		.name = "pcie_1_tunnel_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
-	.flags = VOTABLE,
+	.flags = VOTABLE | RETAIN_FF_ENABLE,
 };
 
 /*
@@ -6787,7 +6787,7 @@ static struct gdsc pcie_2a_gdsc = {
 		.name = "pcie_2a_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
-	.flags = VOTABLE | ALWAYS_ON,
+	.flags = VOTABLE | RETAIN_FF_ENABLE | ALWAYS_ON,
 };
 
 static struct gdsc pcie_2b_gdsc = {
@@ -6798,7 +6798,7 @@ static struct gdsc pcie_2b_gdsc = {
 		.name = "pcie_2b_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
-	.flags = VOTABLE | ALWAYS_ON,
+	.flags = VOTABLE | RETAIN_FF_ENABLE | ALWAYS_ON,
 };
 
 static struct gdsc pcie_3a_gdsc = {
@@ -6809,7 +6809,7 @@ static struct gdsc pcie_3a_gdsc = {
 		.name = "pcie_3a_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
-	.flags = VOTABLE | ALWAYS_ON,
+	.flags = VOTABLE | RETAIN_FF_ENABLE | ALWAYS_ON,
 };
 
 static struct gdsc pcie_3b_gdsc = {
@@ -6820,7 +6820,7 @@ static struct gdsc pcie_3b_gdsc = {
 		.name = "pcie_3b_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
-	.flags = VOTABLE | ALWAYS_ON,
+	.flags = VOTABLE | RETAIN_FF_ENABLE | ALWAYS_ON,
 };
 
 static struct gdsc pcie_4_gdsc = {
@@ -6831,7 +6831,7 @@ static struct gdsc pcie_4_gdsc = {
 		.name = "pcie_4_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
-	.flags = VOTABLE | ALWAYS_ON,
+	.flags = VOTABLE | RETAIN_FF_ENABLE | ALWAYS_ON,
 };
 
 static struct gdsc ufs_card_gdsc = {
@@ -6840,6 +6840,7 @@ static struct gdsc ufs_card_gdsc = {
 		.name = "ufs_card_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.flags = RETAIN_FF_ENABLE,
 };
 
 static struct gdsc ufs_phy_gdsc = {
@@ -6848,6 +6849,7 @@ static struct gdsc ufs_phy_gdsc = {
 		.name = "ufs_phy_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.flags = RETAIN_FF_ENABLE,
 };
 
 static struct gdsc usb30_mp_gdsc = {
@@ -6856,6 +6858,7 @@ static struct gdsc usb30_mp_gdsc = {
 		.name = "usb30_mp_gdsc",
 	},
 	.pwrsts = PWRSTS_RET_ON,
+	.flags = RETAIN_FF_ENABLE,
 };
 
 static struct gdsc usb30_prim_gdsc = {
@@ -6864,6 +6867,7 @@ static struct gdsc usb30_prim_gdsc = {
 		.name = "usb30_prim_gdsc",
 	},
 	.pwrsts = PWRSTS_RET_ON,
+	.flags = RETAIN_FF_ENABLE,
 };
 
 static struct gdsc usb30_sec_gdsc = {
@@ -6872,6 +6876,7 @@ static struct gdsc usb30_sec_gdsc = {
 		.name = "usb30_sec_gdsc",
 	},
 	.pwrsts = PWRSTS_RET_ON,
+	.flags = RETAIN_FF_ENABLE,
 };
 
 static struct gdsc emac_0_gdsc = {
@@ -6880,6 +6885,7 @@ static struct gdsc emac_0_gdsc = {
 		.name = "emac_0_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.flags = RETAIN_FF_ENABLE,
 };
 
 static struct gdsc emac_1_gdsc = {
@@ -6888,6 +6894,7 @@ static struct gdsc emac_1_gdsc = {
 		.name = "emac_1_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.flags = RETAIN_FF_ENABLE,
 };
 
 static struct clk_regmap *gcc_sc8280xp_clocks[] = {
-- 
2.40.1



