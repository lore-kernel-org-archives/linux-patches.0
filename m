Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F012934AB09;
	Tue, 16 Dec 2025 11:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885212; cv=none; b=GNfamG4uq4R6aYTTZRMdZExYGKR0tQj8W252taVJCzHIa42f+nE1J30JdlqhRbtmmRQU3NxkERjHQl8ru71DbSkC3u3itmn4KLEgRxSp9Ne+PW4bzWa0Wg9vd/V7YbNbhoJGWTkuHWJIWpYM7381nR+4MxSP4f0GJrGUIl09VDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885212; c=relaxed/simple;
	bh=ELZfAp7RPxTuTzoTSK/rsRyC/L3f8skWZkzoaanXm4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PhZIE2cCP8kfypmrfhwzwZMqy8/kW2Of7V5RvDlymiUGWNrbGQY7t0oTrc1lGMvALrnueHxjt/0S6EOtLEYRoHdt0vmrzoWGv/nEOLmwyJTiAORX0C1pwZK4NpT58VTFftikQ3qXo05o/+qjo3srUt//1zXwtTT2Hs1Vy7Zwh6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xcL4/n7d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xcL4/n7d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF4AC4CEF1;
	Tue, 16 Dec 2025 11:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885211;
	bh=ELZfAp7RPxTuTzoTSK/rsRyC/L3f8skWZkzoaanXm4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xcL4/n7dUpWzPPn5tn/xvlWYEgEoZJhdwsklkrl9U1f0ForATqj14mEISvhvN+hPu
	 csFgSyFm99IwXpf7pthypaJnEuQO+wRdhJG2+l+Hr7J9FE3zi6hICErhhF6rBjg1+p
	 RT7Du/DO2/rc5hwT7QYp5XN17L+X+9SQqqu5u/00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Imran Shaik <imran.shaik@oss.qualcomm.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 072/507] clk: qcom: camcc-sm6350: Specify Titan GDSC power domain as a parent to other
Date: Tue, 16 Dec 2025 12:08:33 +0100
Message-ID: <20251216111348.150618137@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

[ Upstream commit a76ce61d7225934b0a52c8172a8cd944002a8c6f ]

When a consumer turns on/off a power domain dependent on another power
domain in hardware, the parent power domain shall be turned on/off by
the power domain provider as well, and to get it the power domain hardware
hierarchy shall be described in the CAMCC driver.

Establish the power domain hierarchy with a Titan GDSC set as a parent of
all other GDSC power domains provided by the SM6350 camera clock controller
to enforce a correct sequence of enabling and disabling power domains by
the consumers, this fixes the CAMCC as a supplier of power domains to CAMSS
IP and its driver.

Fixes: 80f5451d9a7c ("clk: qcom: Add camera clock controller driver for SM6350")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Imran Shaik <imran.shaik@oss.qualcomm.com>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Link: https://lore.kernel.org/r/20251021234450.2271279-3-vladimir.zapolskiy@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/camcc-sm6350.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/clk/qcom/camcc-sm6350.c b/drivers/clk/qcom/camcc-sm6350.c
index 8aac97d29ce3f..6c272f7b07219 100644
--- a/drivers/clk/qcom/camcc-sm6350.c
+++ b/drivers/clk/qcom/camcc-sm6350.c
@@ -1693,6 +1693,8 @@ static struct clk_branch camcc_sys_tmr_clk = {
 	},
 };
 
+static struct gdsc titan_top_gdsc;
+
 static struct gdsc bps_gdsc = {
 	.gdscr = 0x6004,
 	.en_rest_wait_val = 0x2,
@@ -1702,6 +1704,7 @@ static struct gdsc bps_gdsc = {
 		.name = "bps_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.parent = &titan_top_gdsc.pd,
 	.flags = VOTABLE,
 };
 
@@ -1714,6 +1717,7 @@ static struct gdsc ipe_0_gdsc = {
 		.name = "ipe_0_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.parent = &titan_top_gdsc.pd,
 	.flags = VOTABLE,
 };
 
@@ -1726,6 +1730,7 @@ static struct gdsc ife_0_gdsc = {
 		.name = "ife_0_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.parent = &titan_top_gdsc.pd,
 };
 
 static struct gdsc ife_1_gdsc = {
@@ -1737,6 +1742,7 @@ static struct gdsc ife_1_gdsc = {
 		.name = "ife_1_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.parent = &titan_top_gdsc.pd,
 };
 
 static struct gdsc ife_2_gdsc = {
@@ -1748,6 +1754,7 @@ static struct gdsc ife_2_gdsc = {
 		.name = "ife_2_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.parent = &titan_top_gdsc.pd,
 };
 
 static struct gdsc titan_top_gdsc = {
-- 
2.51.0



