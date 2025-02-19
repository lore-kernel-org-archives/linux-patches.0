Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0048C1D90D9;
	Wed, 19 Feb 2025 09:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956366; cv=none; b=FeCT8zwlD+g5D38PVo/mGW53RByAzs4ctT2eBB/8ouQeyYWufDBr8RevT3gCcec5H0xpz/7CvwpyWIkQEQ7j6T77fscOeWEWeW1AgyEK/FHcvcVHIscXTSnGrNSSviPipYzSAr2saTA3GiZfnlSQCNF6lXNSKDFCLUmVp2bdyvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956366; c=relaxed/simple;
	bh=ymr/nouXJxnls4W6g+fjbVSfJujcXqwOlnCT8YFoVxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DDD5/boGM72GVwhex55wO4jKT8FSbtcT2I6gM5R5j075QHyiZ7XsX43psRqdNYxj9d9EC1LHC0p95kpPNzzFoey/Hh7xWZBEi3ANwpLgs+LQOpOdI84kxbQE9rjscSHWgq1vgfyKBr8zLH/DxiGL8odAnqYVLTlrtAkGkxo2Gwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=auJealY/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="auJealY/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74E98C4CEE6;
	Wed, 19 Feb 2025 09:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956365;
	bh=ymr/nouXJxnls4W6g+fjbVSfJujcXqwOlnCT8YFoVxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=auJealY/qeOqB75S7ReV5VFCK5/DqqSwXe4PRkUkUooO9cUtieuAWXKyYFp3Pb4b+
	 oNEg5uirvGnW1dzURaaMO+M+LsXSuXZ/EpadXmFdf5MgGnYlN8+qLZJ5o31Q20kUaT
	 nIvMzZznYOLcGHlBKDjpRmbk9T25KWNEiQJmB/f0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Petr Vorel <petr.vorel@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 155/578] arm64: dts: qcom: msm8994: Describe USB interrupts
Date: Wed, 19 Feb 2025 09:22:39 +0100
Message-ID: <20250219082659.070733074@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit c910544d2234709660d60f80345c285616e73b1c ]

Previously the interrupt lanes were not described, fix that.

Fixes: d9be0bc95f25 ("arm64: dts: qcom: msm8994: Add USB support")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Tested-by: Petr Vorel <petr.vorel@gmail.com>
Link: https://lore.kernel.org/r/20241129-topic-qcom_usb_dtb_fixup-v1-4-cba24120c058@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8994.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/msm8994.dtsi b/arch/arm64/boot/dts/qcom/msm8994.dtsi
index 3c6c2cf99fb9d..5fe9a9be7903a 100644
--- a/arch/arm64/boot/dts/qcom/msm8994.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8994.dtsi
@@ -434,6 +434,15 @@
 			#size-cells = <1>;
 			ranges;
 
+			interrupts = <GIC_SPI 180 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 311 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 133 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 310 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "pwr_event",
+					  "qusb2_phy",
+					  "hs_phy_irq",
+					  "ss_phy_irq";
+
 			clocks = <&gcc GCC_USB30_MASTER_CLK>,
 				 <&gcc GCC_SYS_NOC_USB3_AXI_CLK>,
 				 <&gcc GCC_USB30_SLEEP_CLK>,
-- 
2.39.5



