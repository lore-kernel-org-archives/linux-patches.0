Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F441A6192;
	Tue, 30 Jul 2024 17:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358951; cv=none; b=BiLsWaPxyo3bMfwKkhzGj8QhT1ttBCiTl1y4abOE1EyMwB4orOgsxdzI57heEJgh/XbHqVkqlvVL6HBR9qFHhllTfD75c4iAjmqnVFJhflUi7CoejjhZosnpg1womBAqSdHyXCW0p3V6SaBstIRIXfSZ5TZTyyXWbHP/sGbEQaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358951; c=relaxed/simple;
	bh=FWuH4YEPt032dBg1xlf7MR6WRWcA0bHh7eVjlQCXHf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LR3MwWZpcTDP0sFTGO3yVc1mdE9qPp3Huem6P4FYVZz+JhjKyDCNVXxsT8pGN/JhLYRnj2SK2yg6Xvd5bCtAB3uMzG7NFVguSv436UYfOPUdbxvlgArLqRFMIU6eURZJKs7a9MWqvHhEgO+hlOKGM2VCTS5eEvYwQ0BD+QnDEs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AUBIVeVx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AUBIVeVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D33EAC32782;
	Tue, 30 Jul 2024 17:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358951;
	bh=FWuH4YEPt032dBg1xlf7MR6WRWcA0bHh7eVjlQCXHf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AUBIVeVxlPdVENfwDPEtXOD67IuIOPAdquu7gW9v/byrmaO+HgBXH97M2aCJvQtdU
	 ONdoBSexeFCtSnN6j2KtUAYOrPMiHNr2Qrw8v9bAwHsHh5A9JimawO8XBAiI5zOnHV
	 r1+8Q24fOKbYFyua9oNTI1gQmoerJWCFJdPcesmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taniya Das <quic_tdas@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 393/809] clk: qcom: camcc-sc7280: Add parent dependency to all camera GDSCs
Date: Tue, 30 Jul 2024 17:44:29 +0200
Message-ID: <20240730151740.204113377@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index d89ddb2298e32..582fb3ba9c895 100644
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



