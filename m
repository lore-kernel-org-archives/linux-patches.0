Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501861FBEBC;
	Wed,  5 Feb 2025 14:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767215; cv=none; b=fTeuizeaKaNDmf7XIg13vRPtKdQ9KhDqDWtkKtT0pe97njiPZtXhb8OyhD61nlQK6odvuoRuAFTmlIV14zMTsXOQE/IG4MWsNkdrO8GWd+2UoEiljRUH8gH8wVWfGyPZin7ObB6skNpxlPc52Nny4Labf0lKUzVq7LBtRQLAdH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767215; c=relaxed/simple;
	bh=/rkWRLw0yB0phPepySA4gDKmta099bMOIhAA3u82f9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cm4+zr4/wNcLa8UJfQQ4Zqk/2ua+ZXYzOlFLAP20C8flaQn/jX2TjTPEs8YpmWtA9jbhjuQchm3tEU7auXCbMQImv0k/gGK+MQA39KBtPxDfSZ6ZpYP1M7Uzf81nPYTfZD1z5fAKi4SKrKtUGH9fmvUwPkCporvFkAdGtqKBQw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K6fDwWsa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K6fDwWsa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0860C4CED1;
	Wed,  5 Feb 2025 14:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767215;
	bh=/rkWRLw0yB0phPepySA4gDKmta099bMOIhAA3u82f9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K6fDwWsaj6CZf48ZsdqqjhoVnRzgaXPWgnyC3dbBS16VzbHBH9ScHrYv7FDd8Iu9A
	 N57c+Y9c0KfW+rKdNZeVK2v08ClwROgyO4gB+ewVSKcbUBKL6BphBL/By8MWdq3dRP
	 oPGASJVvLLEIDH67ufLAmfak77wyzk/RCNxJOflY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 373/623] arm64: dts: qcom: msm8996: Fix up USB3 interrupts
Date: Wed,  5 Feb 2025 14:41:55 +0100
Message-ID: <20250205134510.490997327@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 9cb9c9f4e1380da317a056afd26d66a835c5796c ]

Add the missing interrupt lines and fix qusb2_phy being an impostor
of hs_phy_irq.

This happens to also fix warnings such as:

usb@6af8800: interrupt-names: ['hs_phy_irq', 'ss_phy_irq'] is too short

Fixes: 4753492de9df ("arm64: dts: qcom: msm8996: Add usb3 interrupts")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20241129-topic-qcom_usb_dtb_fixup-v1-3-cba24120c058@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8996.dtsi | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
index b379623c1b8a0..4719e1fc70d2c 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -3065,9 +3065,14 @@
 			#size-cells = <1>;
 			ranges;
 
-			interrupts = <GIC_SPI 347 IRQ_TYPE_LEVEL_HIGH>,
+			interrupts = <GIC_SPI 180 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 347 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 133 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 243 IRQ_TYPE_LEVEL_HIGH>;
-			interrupt-names = "hs_phy_irq", "ss_phy_irq";
+			interrupt-names = "pwr_event",
+					  "qusb2_phy",
+					  "hs_phy_irq",
+					  "ss_phy_irq";
 
 			clocks = <&gcc GCC_SYS_NOC_USB3_AXI_CLK>,
 				 <&gcc GCC_USB30_MASTER_CLK>,
-- 
2.39.5



