Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0977017CA12;
	Mon, 10 Mar 2025 17:50:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629018; cv=none; b=XAwiHekOiR/G7dXn0KW9/H97G0f0SA5NbPh12kusfk1m5ghcqaZOdqVU/yqHgGyEIihcUto/SOsfjip+5J/k3wmVx5/WT8BpXBMco2Mbzu+DF6VEV0oSYgLLtjBMy1FA0ToVwX4TbxpnkQNi1A9wSAtAUlSksYrt1vXHNzi9wJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629018; c=relaxed/simple;
	bh=auy4lmEcjwGyCSHm6nmaIRg0pV+JYTgiLIQqDxONxpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qpR5ymLt1D0dgyRKlFyqB4zWNitz2EAQOYH2jVbWpyoOCOR9sc0OgvW27nffi6e1LDcFxExwmSjG5M5/t+VThVvsDnNaFgnFUF4NEoV5W5M1qWnR5YE7P3CM3FTnPqyZkubj5IRYf2lpxA1VMEOa2KrK7PTQFpIX2XHG3gBRYKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fJzw5+GI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fJzw5+GI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830C6C4CEE5;
	Mon, 10 Mar 2025 17:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629017;
	bh=auy4lmEcjwGyCSHm6nmaIRg0pV+JYTgiLIQqDxONxpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fJzw5+GI++Yc3pozrlwbI9kQrOhtUqdqIG2cqR/cZ/dmMr82+ad5ZxUWf13lhFcTt
	 v4w6eEirigNjIez6gZWGs+u+XZ71cofO6G5Ohu14pTdwrhH7aFajvVX6e/SY7dC96/
	 O9blRnafIVmK/i1PLk+DBWRpB5xRVYN+WKF+CTyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 117/620] arm64: dts: qcom: msm8996: Fix up USB3 interrupts
Date: Mon, 10 Mar 2025 17:59:23 +0100
Message-ID: <20250310170550.221826248@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9ee8eebfcdb51..ec0f067a6a5d5 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -2608,9 +2608,14 @@
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



