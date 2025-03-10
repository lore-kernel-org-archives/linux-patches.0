Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A1117CA12;
	Mon, 10 Mar 2025 17:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629021; cv=none; b=GHatAUPM+Ww9ozetiWoGQxEMDvC4gciEbcuWc6MmBn4QwDK94048yJ3zxjSkB8lbPlQISJcKCnWpGcYGxhuMSq27CkbAtwTO2KeYd61KaQq82DbRZKhoPzrtXmwEkQghWJyY70vGCB245DxR/KBHSINaBmcxXu4Zh2jHYsCTtnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629021; c=relaxed/simple;
	bh=A1DuPepTKkVhwO6tKsh+ZUClx0EVJnz1YRbAo0vPdDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JYHUQ4sFqqPFxysFwMSTGaojkzXBM/Wj4+xiNPz1/2O4AW7qYC0jLtF+sqShFB+2sV/6J8qMbhle1XWskuCVsLPdWGdRNgwxqU7lLpvnOu9OzEbmzYnqZ4HFB2lyWff8zv1MlQbJi8EgbMV7PqADnlPYMBb/ufiOXF6ozD6qZ/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=col8urdj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="col8urdj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76E9EC4CEE5;
	Mon, 10 Mar 2025 17:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629020;
	bh=A1DuPepTKkVhwO6tKsh+ZUClx0EVJnz1YRbAo0vPdDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=col8urdjkwEU7bAbjl26bpanZDiGPxOWL1yCJkonzZuGpV7CjudssnbL73i3FdtcW
	 UGGCbF16LshCXme0J7S+d7S4mpv+NEuJJ8RWIEeRJReBxRmVWX8WPF4AAEtK5Ztr1j
	 SwEcTmu4U4Nz4fxsLulu9tv+dqdsL3GgyNN25DdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Petr Vorel <petr.vorel@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 118/620] arm64: dts: qcom: msm8994: Describe USB interrupts
Date: Mon, 10 Mar 2025 17:59:24 +0100
Message-ID: <20250310170550.260559603@linuxfoundation.org>
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
index 4447ed146b3ac..fafeb790c5c59 100644
--- a/arch/arm64/boot/dts/qcom/msm8994.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8994.dtsi
@@ -419,6 +419,15 @@
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



