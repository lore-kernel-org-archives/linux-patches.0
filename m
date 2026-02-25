Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8311E2834;
	Wed, 25 Feb 2026 01:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983914; cv=none; b=ao7Cvq2MTJnquKrQ5kGThHz/R3N3kxbp2F8x2g7XBsJ9uZDUyFXEoEyXGKJ8rNOoPzz+62txiZ0s8hrggO8p2fi5iCbjeoj8/qpZtmg2/YOTaJUD1CZz7sNPsxHyhMfVayXtfF/JnTkolmyTdSQM8axlEGHnO5DCcdrHdWi5kZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983914; c=relaxed/simple;
	bh=dcN6eSgvaO3cpkOWinoAXnbUjVZ6gJkAEvGck50+Uzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VrkQ2pU42363fnDJ2moJKqDO/OJRhpOcwkM5mHTMCwhs3OKkH8kn+JFkjip36Lk16ndL2Ljqg3TRkEG+8DxYYuASFipWy/HCiooDCn4xu7Q6uUQLFKSMnlGCX68JknH00iXC11oWJeolOFD+fKcp0O9unkmqXngSSqc+qd5SDCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TF5e9joS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TF5e9joS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97BB4C19423;
	Wed, 25 Feb 2026 01:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983914;
	bh=dcN6eSgvaO3cpkOWinoAXnbUjVZ6gJkAEvGck50+Uzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TF5e9joScO8OqSFDEerVlc6LRMFZXGxs6E5vG9FHv5kiQ+JouIm2AN8CRqkP9x8v6
	 7by34Y2pPlgjmKy9xk0Gd5FV1IHFIvIlHGpiwztKC0AMTzPAoJGGNt595apagtIAcP
	 VVnSWm4V2NjN3x1G5aDhR3yVOibhGbxwXxb21sSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Taniya Das <taniya.das@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 138/641] arm64: dts: qcom: x1e80100: Fix USB combo PHYs SS1 and SS2 ref clocks
Date: Tue, 24 Feb 2026 17:17:44 -0800
Message-ID: <20260225012352.474732372@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 662ad694cd914..3290fd8c2d6e6 100644
--- a/arch/arm64/boot/dts/qcom/x1e80100.dtsi
+++ b/arch/arm64/boot/dts/qcom/x1e80100.dtsi
@@ -2910,7 +2910,7 @@ usb_1_ss1_qmpphy: phy@fda000 {
 			reg = <0 0x00fda000 0 0x4000>;
 
 			clocks = <&gcc GCC_USB3_SEC_PHY_AUX_CLK>,
-				 <&rpmhcc RPMH_CXO_CLK>,
+				 <&tcsr TCSR_USB4_1_CLKREF_EN>,
 				 <&gcc GCC_USB3_SEC_PHY_COM_AUX_CLK>,
 				 <&gcc GCC_USB3_SEC_PHY_PIPE_CLK>;
 			clock-names = "aux",
@@ -2981,7 +2981,7 @@ usb_1_ss2_qmpphy: phy@fdf000 {
 			reg = <0 0x00fdf000 0 0x4000>;
 
 			clocks = <&gcc GCC_USB3_TERT_PHY_AUX_CLK>,
-				 <&rpmhcc RPMH_CXO_CLK>,
+				 <&tcsr TCSR_USB4_2_CLKREF_EN>,
 				 <&gcc GCC_USB3_TERT_PHY_COM_AUX_CLK>,
 				 <&gcc GCC_USB3_TERT_PHY_PIPE_CLK>;
 			clock-names = "aux",
-- 
2.51.0



