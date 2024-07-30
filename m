Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B75D718991A;
	Tue, 30 Jul 2024 16:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357437; cv=none; b=pwKvw34b/dbcT0A7raz2ve+qWAkk6Lb+HvOG8TYR+3F2rAja/g/Z8+9bIFyrgjazcetV+3w30RiOBjmSxpQbv9swDlaqAFgpaCtenMA4EmytPlr9yGfTtAEMkw5NO+qsRobv/H+BI2lunKPsOXyYQpU1H/59Ighh2U9wG9MokS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357437; c=relaxed/simple;
	bh=8ZZDfEHghPJWbZjN+gNaqsIIsoZKK1EZlgW6W35Zx+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hnTRiW2e6sP5oqf91mf9NyZ75YuakwkDocbK+wCx/KHQYZLhZA8m9CbY97JeDbYEJhrePDxvr45tVuSCR4TcUzNhpfMGtF2FO680pUejxCe+KXYXfS1V5ApLGztYzub4GJIrN+fMBTuOanVN1IlGiQpXFMG5wz4HtQzuog4MZ/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NqGtNzBW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NqGtNzBW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E7B1C4AF0A;
	Tue, 30 Jul 2024 16:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357437;
	bh=8ZZDfEHghPJWbZjN+gNaqsIIsoZKK1EZlgW6W35Zx+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NqGtNzBWpOMsVHF0ehW4umwwyH5GnaSO2mMOdxTieJ8gq8H+kMZKm+MJMlQBIHVh3
	 r3UomvMjf9mF3SpAnb77vwpeeX5oXqv0Hmps1HQ6x09oVdVzpfP8dWBp8mWewOcqbK
	 pOXx99yu/S0yzW/XJHiuC17uj7ncse51EZI/zczk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <quic_tdas@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 255/568] clk: qcom: camcc-sc7280: Add parent dependency to all camera GDSCs
Date: Tue, 30 Jul 2024 17:46:02 +0200
Message-ID: <20240730151649.846632405@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taniya Das <quic_tdas@quicinc.com>

[ Upstream commit 63aec3e4d987fd43237f557460345bca3b51e530 ]

Camera titan top GDSC is a parent supply to all other camera GDSCs. Titan
top GDSC is required to be enabled before enabling any other camera GDSCs
and it should be disabled only after all other camera GDSCs are disabled.
Ensure this behavior by marking titan top GDSC as parent of all other
camera GDSCs.

Fixes: 1daec8cfebc2 ("clk: qcom: camcc: Add camera clock controller driver for SC7280")
Signed-off-by: Taniya Das <quic_tdas@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240531095142.9688-4-quic_tdas@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/camcc-sc7280.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/clk/qcom/camcc-sc7280.c b/drivers/clk/qcom/camcc-sc7280.c
index 49f046ea857cb..c1551de51d401 100644
--- a/drivers/clk/qcom/camcc-sc7280.c
+++ b/drivers/clk/qcom/camcc-sc7280.c
@@ -2260,6 +2260,7 @@ static struct gdsc cam_cc_bps_gdsc = {
 		.name = "cam_cc_bps_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.parent = &cam_cc_titan_top_gdsc.pd,
 	.flags = HW_CTRL | RETAIN_FF_ENABLE,
 };
 
@@ -2269,6 +2270,7 @@ static struct gdsc cam_cc_ife_0_gdsc = {
 		.name = "cam_cc_ife_0_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.parent = &cam_cc_titan_top_gdsc.pd,
 	.flags = RETAIN_FF_ENABLE,
 };
 
@@ -2278,6 +2280,7 @@ static struct gdsc cam_cc_ife_1_gdsc = {
 		.name = "cam_cc_ife_1_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.parent = &cam_cc_titan_top_gdsc.pd,
 	.flags = RETAIN_FF_ENABLE,
 };
 
@@ -2287,6 +2290,7 @@ static struct gdsc cam_cc_ife_2_gdsc = {
 		.name = "cam_cc_ife_2_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.parent = &cam_cc_titan_top_gdsc.pd,
 	.flags = RETAIN_FF_ENABLE,
 };
 
@@ -2296,6 +2300,7 @@ static struct gdsc cam_cc_ipe_0_gdsc = {
 		.name = "cam_cc_ipe_0_gdsc",
 	},
 	.pwrsts = PWRSTS_OFF_ON,
+	.parent = &cam_cc_titan_top_gdsc.pd,
 	.flags = HW_CTRL | RETAIN_FF_ENABLE,
 };
 
-- 
2.43.0



