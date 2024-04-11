Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51211448F3;
	Thu, 11 Apr 2024 10:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830070; cv=none; b=APo3N2diXgDa8/h5jGl0Faimw+C/p+2oIyx/1P8jqbE+Ge6rqJddh16EGoIQlMlUgTPS76iSuMdzdghs025d/2OwVZPwrRPvi+zFP7pyNckXVZ4P7y596jjjhJJvvK0IJvrj2s+LL3WDkK6+w3fzOOVPyYzOM8k4ZyMErCzECG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830070; c=relaxed/simple;
	bh=YOO0uWZmtGE7werAMU4UWyxXufE3eblFT5+Xiy9TOxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GdSG/bTy9Csqswref6RR1Sp/XVNdQTsCfl/9t6AnNVfivgJy27/11sOLJ7iWWMtB+sGRUPQSRO7pw/i51RNqOoBirRgs4VkOpdeWcWYooqCVHCoHF/lgtEfLpPvuwA5Db3vY7F/VZsVyXxs/GFExgTOd6f2B2+r4+jJTUuZlf34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kbm+ofgt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kbm+ofgt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F96C433C7;
	Thu, 11 Apr 2024 10:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830069;
	bh=YOO0uWZmtGE7werAMU4UWyxXufE3eblFT5+Xiy9TOxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kbm+ofgtw89WvkJnyXET/ZTBoTKkkYEXkzW5He+QMz0Aez0nfu/EYnWHCw8nCL/FK
	 htU65MYRQMpZiaNmRUCRIhG+zZjKezn6FwMnH5punztSKE22qeftaLp/W22+L3Znfg
	 tFGNV7/xAOroJPhOiKo1X+DC6tTvbeWUYsEzeV/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Luca Weiss <luca.weiss@fairphone.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <quic_bjorande@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 025/143] arm64: dts: qcom: qcs6490-rb3gen2: Declare GCC clocks protected
Date: Thu, 11 Apr 2024 11:54:53 +0200
Message-ID: <20240411095421.668444165@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Andersson <quic_bjorande@quicinc.com>

[ Upstream commit 7c6bef576a8891abce08d448165b53328032aa5f ]

The SC7280 GCC binding describes clocks which, due to the difference in
security model, are not accessible on the RB3gen2 - in the same way seen
on QCM6490.

Mark these clocks as protected, to allow the board to boot. In contrast
to the present QCM6490 boards GCC_EDP_CLKREF_EN is left out, as this
does not need to be "protected" and is used on the RB3Gen2 board.

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Luca Weiss <luca.weiss@fairphone.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <quic_bjorande@quicinc.com>
Link: https://lore.kernel.org/r/20240209-qcm6490-gcc-protected-clocks-v2-1-11cd5fc13bd0@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dts | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dts b/arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dts
index ae1632182d7c1..ac4579119d3ba 100644
--- a/arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dts
+++ b/arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dts
@@ -413,6 +413,23 @@ vreg_bob_3p296: bob {
 	};
 };
 
+&gcc {
+	protected-clocks = <GCC_CFG_NOC_LPASS_CLK>,
+			   <GCC_MSS_CFG_AHB_CLK>,
+			   <GCC_MSS_GPLL0_MAIN_DIV_CLK_SRC>,
+			   <GCC_MSS_OFFLINE_AXI_CLK>,
+			   <GCC_MSS_Q6SS_BOOT_CLK_SRC>,
+			   <GCC_MSS_Q6_MEMNOC_AXI_CLK>,
+			   <GCC_MSS_SNOC_AXI_CLK>,
+			   <GCC_QSPI_CNOC_PERIPH_AHB_CLK>,
+			   <GCC_QSPI_CORE_CLK>,
+			   <GCC_QSPI_CORE_CLK_SRC>,
+			   <GCC_SEC_CTRL_CLK_SRC>,
+			   <GCC_WPSS_AHB_BDG_MST_CLK>,
+			   <GCC_WPSS_AHB_CLK>,
+			   <GCC_WPSS_RSCP_CLK>;
+};
+
 &qupv3_id_0 {
 	status = "okay";
 };
-- 
2.43.0



