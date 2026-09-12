Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D263F23D0;
	Sat, 12 Sep 2026 08:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201930; cv=none; b=V4uMj7j4GzkNeEIlZN3Fep9vpbVz1zdfTFz460GijRhpRIoWDvB1wrcxxO8gZ4yeyF0eigJFIN8p6bEdQTCfOQWCQ/qDRsmAYpaSfeRJRr6lJGWufM4RIQn568xshRfQ1BuVQ91DSJ9ibmr3b2fTbDxyWs+5o11eOjYwWDSDXSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201930; c=relaxed/simple;
	bh=ZScnRx0IRMtv9/y4cjO06x0hDoTLThW+9vIHsCG89fQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+bydyMj92ZMSxqUS3jRrMR6vTtrvJwYYumuEljJj/bOQDRD2mrxofdmgo9Y0hXE+GtJZ0Tj2lSbYWaMo6H+heWSrt35S8GO5q5tscfQ34sRtNo8rsxQuQeDY03mYal0BOt+xPA8rEzBh6Gwqd9gK6Mc1v1KUrCgn3X1tmxmHY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WLYeKsw9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WLYeKsw9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F121B1F000FF;
	Sat, 12 Sep 2026 08:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201926;
	bh=aCwd3qPZOlDgE4BaDVFmHF0tZQ2mqe4a4FKNfs6NqM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WLYeKsw9vjD2dsumvgGaFYsbXbcwcLcsIauTmeijHpl8r/OOdv8tLhEHTTtnNC/uB
	 k5dpQkZW31xyRynb2WTPr99zGMtmMvrh6mDhKT2M+2rTr8KcazCI3ChhhijxavvvNI
	 7wT2dNSwOCkzaZL/oMN7eYxr0lg4w7jMduQUOLTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Imran Shaik <imran.shaik@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1054/1815] arm64: dts: qcom: agatti: Add missing CX power domain to DISPCC
Date: Sat, 12 Sep 2026 08:46:44 +0200
Message-ID: <20260912065713.760424592@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imran Shaik <imran.shaik@oss.qualcomm.com>

[ Upstream commit 26d7b23caa4b1d8208e28c5981a85cf83e658e7c ]

Add the missing power-domains property to associate DISPCC with CX rail.
This is to ensure the genpd performance state votes on the GDSC to get
propagated to the CX rail and to avoid the rail under-voltage conditions.

Fixes: a2b32096709d ("arm64: dts: qcom: qcm2290: Add display nodes")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Imran Shaik <imran.shaik@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260718-shikra-dispcc-gpucc-v6-12-62703e05ef0f@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/agatti.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/agatti.dtsi b/arch/arm64/boot/dts/qcom/agatti.dtsi
index f0b6ae9b81528..590bd2432d85b 100644
--- a/arch/arm64/boot/dts/qcom/agatti.dtsi
+++ b/arch/arm64/boot/dts/qcom/agatti.dtsi
@@ -2197,6 +2197,7 @@ dispcc: clock-controller@5f00000 {
 				      "gcc_disp_gpll0_div_clk_src",
 				      "dsi0_phy_pll_out_byteclk",
 				      "dsi0_phy_pll_out_dsiclk";
+			power-domains = <&rpmpd QCM2290_VDDCX>;
 			#power-domain-cells = <1>;
 			#clock-cells = <1>;
 			#reset-cells = <1>;
-- 
2.53.0



