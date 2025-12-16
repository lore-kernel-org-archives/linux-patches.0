Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 853C532862F;
	Tue, 16 Dec 2025 11:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765883994; cv=none; b=fEXB/4GjUd32MFqhX1EjUBjdGQ9QK5aPy4Oqwqf4WlFbu1q3NdKv/EkI/XoD8Sscp3skRVnWjNeVqa5Y70LlG0MJ/JqtarCkHy6idZnIQNXtluXacwp165vQvtug+W8+gc6FDkt3nDRlk4u8W6Z78SWUxIYMBPkm0yYOSSKvrAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765883994; c=relaxed/simple;
	bh=RSnW1nYiaa12KpJ0tToNnGJOxzmDNSAjP19o1PGSs1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lykMFrUUK+xmF4F6NJuX1bDOk/Op7Dddbm8yu8W8Gkmm5V2bj95uPCzHc8cOdHgIhOvP3GS//0jhEL28ayyAziADv2XneAhcxKsRGHfvk+a8PumGJ2jiYRq8F79AAXv7qM9s2gVhAH/KbJx2piQLd3OFauNUbGZO2AEKHQ3JzH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WVUKZNHi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WVUKZNHi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09DBCC4CEF1;
	Tue, 16 Dec 2025 11:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765883994;
	bh=RSnW1nYiaa12KpJ0tToNnGJOxzmDNSAjP19o1PGSs1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WVUKZNHiVG/0dhKNndw7h+My4ny3KVTShfRUNsFteFquf9Z29eintjy5C/kl1Xohl
	 I+eF5v0heWFuc+JtmoVSvQ9CVn2O6pHxyhS3vIA52wfoIBVZ+R1JoKpPGnllvluj7N
	 dZKvoXC55xPl51Clg1+9mjnU4rUaBV6qDAsZjCs4=
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
Subject: [PATCH 6.12 059/354] clk: qcom: camcc-sm6350: Specify Titan GDSC power domain as a parent to other
Date: Tue, 16 Dec 2025 12:10:26 +0100
Message-ID: <20251216111323.057333198@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 418668184ec35..454763425f611 100644
--- a/drivers/clk/qcom/camcc-sm6350.c
+++ b/drivers/clk/qcom/camcc-sm6350.c
@@ -1692,6 +1692,8 @@ static struct clk_branch camcc_sys_tmr_clk = {
 	},
 };
 
+static struct gdsc titan_top_gdsc;
+
 static struct gdsc bps_gdsc = {
 	.gdscr = 0x6004,
 	.en_rest_wait_val = 0x2,
@@ -1701,6 +1703,7 @@ static struct gdsc bps_gdsc = {
 		.name = "bps_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.parent = &titan_top_gdsc.pd,
 	.flags = VOTABLE,
 };
 
@@ -1713,6 +1716,7 @@ static struct gdsc ipe_0_gdsc = {
 		.name = "ipe_0_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.parent = &titan_top_gdsc.pd,
 	.flags = VOTABLE,
 };
 
@@ -1725,6 +1729,7 @@ static struct gdsc ife_0_gdsc = {
 		.name = "ife_0_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.parent = &titan_top_gdsc.pd,
 };
 
 static struct gdsc ife_1_gdsc = {
@@ -1736,6 +1741,7 @@ static struct gdsc ife_1_gdsc = {
 		.name = "ife_1_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.parent = &titan_top_gdsc.pd,
 };
 
 static struct gdsc ife_2_gdsc = {
@@ -1747,6 +1753,7 @@ static struct gdsc ife_2_gdsc = {
 		.name = "ife_2_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.parent = &titan_top_gdsc.pd,
 };
 
 static struct gdsc titan_top_gdsc = {
-- 
2.51.0



