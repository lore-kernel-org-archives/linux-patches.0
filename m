Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C797E18A6D7;
	Wed,  5 Feb 2025 14:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767221; cv=none; b=ScxxjX+bYIttGSR8WAuX54bt8v4L31j2s8m6rxUVYZaiwrQ+2cJMBkHYcwDb8FpJBmskx7esLy+57k8qeROA342DBXsDhCP5OaQUC7koZ6+cD9tP6iIup2RBp4WVZ3QGKWDnjjLjFRVeuPRJg0305SOI0s5s665/9O5S0oP59ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767221; c=relaxed/simple;
	bh=pFhx1I4Veh21DsepcyiJMX+8N4x8So4UYAnMRhSX8Dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pVxDzWlt9JbRTfCYmfXvGgN6J6GsRKCw1J4M+EcJv4WODjX3473ofOKvwDQ4HEwqfqS1ulkkJ/Jn951T+TMmV6zw8MQkEAwP6XFKeCoz7pVMz2j+ITwQRbw22znqA/PAfvK0GjZyl+SU0eB6k1JSUzQ9dk3jZEscYgQ/ohc7TcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q2DSlTNN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q2DSlTNN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 396AFC4CED1;
	Wed,  5 Feb 2025 14:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767221;
	bh=pFhx1I4Veh21DsepcyiJMX+8N4x8So4UYAnMRhSX8Dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q2DSlTNN9dMg8BsnlIGn9iSWyIAFvLFJDBNiIyiabnaKn/4j/8gWl+SIADukCPqSV
	 5ZgPayF6SYiW1FDDqBhF0o2FH0Nia5Yljd9O47k1RdpKRqvAViOus0oZnFCauqKiqL
	 magD4/zr6nu4+c/GcWl7UKWXckULsos4QI7bGBAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Petr Vorel <petr.vorel@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 374/623] arm64: dts: qcom: msm8994: Describe USB interrupts
Date: Wed,  5 Feb 2025 14:41:56 +0100
Message-ID: <20250205134510.529306191@linuxfoundation.org>
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
index 1acb0f1595119..8c0b1e3a99a76 100644
--- a/arch/arm64/boot/dts/qcom/msm8994.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8994.dtsi
@@ -437,6 +437,15 @@
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



