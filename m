Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56894379ED5
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301708; cv=none; b=fzF9iIBuxs9/s62mdMO5441uAQFfpK8KvRRI02nTJeAEZziKPJjrBwf8gGe1kg7pdY25tEPzQ6a/N8fe/WTSlFaP1kYh2SA4FHX7zaLGXS50QiJ2KXztrO+tjqcpd84B8cEf3SiEuESaqRS/MpVpYAxjEhgbsHAyPvbdJcOaGCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301708; c=relaxed/simple;
	bh=lcsKxnsILpFNt75wqOwKCrFRgreuamesH+eBGe409Ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bO6mzip8f+W97LhUAvf8DJ8S3QMTvvXnXLZMdbzk/unovCOiPRGMvxYlJ5tfNilgVUBPiAlxsk28nNUZYdpZUMQo7qMClxlMqjKB6M8YveDv4Kncr3qQs7H6JQ2F9CFmPT4OW6DV9cRczEsCukQrZgrAFc6Ggorq4e3N1160OZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dBPj+ffe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dBPj+ffe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AC98C19424;
	Sat, 28 Feb 2026 18:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301708;
	bh=lcsKxnsILpFNt75wqOwKCrFRgreuamesH+eBGe409Ns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dBPj+ffepvM15NG8f6ltwwfjn2Nm3efCW6LndiFTJ+1cf49Bj0sypuolHlcrmzfIf
	 dA0ScUokyYfCTYYJrPYoemH6o7ipQe4kdxOEY0VLaO1SGdNB/bOYkPTAtj5weH+BXm
	 8cserzU60U7nya4fzUxhmBn/5Kl6C4LqHWjGg+GReo2vchlLyQkDVTV3UNIrr/e6lQ
	 VpqGrQZ2aml6fxc2KwS8dMSohOcmAKUXu1QbEXmavmdUVPsQdcTqU7T6zc8DSmTslD
	 XpRl8bmZwSlAcTh6MKFSFE7T8Mp9K52amWpl/1HowtIGXUs0Ws6tgsl2ipchGiV0Rc
	 YCGFNDDITZqig==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Abel Vesa <abel.vesa@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 102/385] arm64: dts: qcom: x1e80100: Fix USB combo PHYs SS1 and SS2 ref clocks
Date: Sat, 28 Feb 2026 12:55:24 -0500
Message-ID: <20260228180011.1568201-102-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Abel Vesa <abel.vesa@linaro.org>

[ Upstream commit 3af51501e2b8c87564b5cda43b0e5c316cf54717 ]

It seems the USB combo SS1 and SS2 ref clocks have another gate, unlike
the SS0. These gates are part of the TCSR clock controller.

At least on Dell XPS 13 (9345), if the ref clock provided by the TCSR
clock controller for SS1 PHY is disabled on the clk_disable_unused late
initcall, the PHY fails to initialize. It doesn't happen on the SS0 PHY
and the SS2 is not used on this device.

This doesn't seem to be a problem on CRD though. It might be that the
RPMh has a vote for it from some other consumer and does not actually
disable it when ther kernel drops its vote.

Either way, these TCSR provided clocks seem to be the correct ones for
the SS1 and SS2, so use them instead.

Fixes: 4af46b7bd66f ("arm64: dts: qcom: x1e80100: Add USB nodes")
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Taniya Das <taniya.das@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251103-dts-qcom-x1e80100-fix-combo-ref-clks-v1-1-f395ec3cb7e8@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/x1e80100.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/x1e80100.dtsi b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
index 8536403e6ac99..a19b217b6f8ee 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
@@ -2679,7 +2679,7 @@ usb_1_ss1_qmpphy: phy@fda000 {
 			reg = <0 0x00fda000 0 0x4000>;
 
 			clocks = <&gcc GCC_USB3_SEC_PHY_AUX_CLK>,
-				 <&rpmhcc RPMH_CXO_CLK>,
+				 <&tcsr TCSR_USB4_1_CLKREF_EN>,
 				 <&gcc GCC_USB3_SEC_PHY_COM_AUX_CLK>,
 				 <&gcc GCC_USB3_SEC_PHY_PIPE_CLK>;
 			clock-names = "aux",
@@ -2749,7 +2749,7 @@ usb_1_ss2_qmpphy: phy@fdf000 {
 			reg = <0 0x00fdf000 0 0x4000>;
 
 			clocks = <&gcc GCC_USB3_TERT_PHY_AUX_CLK>,
-				 <&rpmhcc RPMH_CXO_CLK>,
+				 <&tcsr TCSR_USB4_2_CLKREF_EN>,
 				 <&gcc GCC_USB3_TERT_PHY_COM_AUX_CLK>,
 				 <&gcc GCC_USB3_TERT_PHY_PIPE_CLK>;
 			clock-names = "aux",
-- 
2.51.0

