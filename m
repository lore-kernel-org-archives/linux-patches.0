Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C124274B39;
	Sat, 12 Sep 2026 10:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208675; cv=none; b=YM1Z3SJup1Ca/sTduNHQYEhvV7DVZKcnFcyK8HTGfT8WOOLcbNDWxaO3Txi7TYZmZXNuPz0VVSsTkUYAgszGi5VSPD6HvnVS8ynzhbys4/XWscFPXOGsLp8EqyP7ohul3rBaHoIGZN/v4yU2e0+PJnnX37+dIoZkRmOjUD7p0sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208675; c=relaxed/simple;
	bh=0OLCa7BAECOhQ1xvhqc8C0P3T1rho4F1SnZrzwlHcz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ni6/9ZkWLfPGD3+2SCR4ySpl9M3kg5kybtBEZihYzPQ8eVpQV32iho+yP1kIEEzLxFK9XdBrQ8Wer88Uzmr/KHurq0Mw2ogJCPgZuU34sYAFPDoXQPMhIBHNKV2/nhxZqgGhrTPvJ7/QAQnbMArmBs5DITqkME+01+gIElQKRuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tibMItss; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tibMItss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3BE21F000FF;
	Sat, 12 Sep 2026 10:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208673;
	bh=RT+CG5WQKFEqdcNnF6jcMSU8NCwSY9KSe7d5hsYT1kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tibMItssxnBEVDRx7arp/VFJnxIIR+RenFuJV4b7Q/n5NP0J4ErSHcKvv7GHnjaut
	 ekQNe0V1AiaZU0AWpPxkoXk5deha38pLZbqdRqztpbiiTPpuUkXPQQ2ltRzGJdDxVQ
	 YqyB9b11fCdqboVSF9ihedO89A9ypP2ovy7/Sh6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0665/1518] arm64: dts: qcom: qcs404: Fix DTBS Check errors in usb controller nodes
Date: Sat, 12 Sep 2026 08:47:14 +0200
Message-ID: <20260912065638.477351684@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>

[ Upstream commit 9812d0a3077489f67afaca84dcc7e01a440ee106 ]

The following errors pop up when DTBS check is done for qcs404 based
platforms:

arch/arm64/boot/dts/qcom/qcs404-evb-4000.dtb: usb@79b8800 (qcom,qcs404-
dwc3): interrupt-names:1: 'qusb2_phy' was expected
from schema $id: http://devicetree.org/schemas/usb/qcom,dwc3.yaml

arch/arm64/boot/dts/qcom/qcs404-evb-4000.dtb: usb@79b8800 (qcom,qcs404-
dwc3): interrupt-names:2: 'hs_phy_irq' was expected
from schema $id: http://devicetree.org/schemas/usb/qcom,dwc3.yaml

arch/arm64/boot/dts/qcom/qcs404-evb-4000.dtb: usb@7678800 (qcom,qcs404-
dwc3): interrupt-names:2: 'hs_phy_irq' was expected
from schema $id: http://devicetree.org/schemas/usb/qcom,dwc3.yaml

arch/arm64/boot/dts/qcom/qcs404-evb-4000.dtb: usb@7678800 (qcom,qcs404-
dwc3): interrupt-names:1: 'qusb2_phy' was expected
from schema $id: http://devicetree.org/schemas/usb/qcom,dwc3.yaml

Modify ordering of hs_phy and qusb2_phy interrupts to fix the errors.

Fixes: 927173bf8a0e ("arm64: dts: qcom: Add missing interrupts for qcs404/ipq5332")
Signed-off-by: Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260723-qcs404_dtbs_fix-v1-1-c9ca0dd69f23@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcs404.dtsi | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/qcs404.dtsi b/arch/arm64/boot/dts/qcom/qcs404.dtsi
index 4328c1dda898c..736accfc34f90 100644
--- a/arch/arm64/boot/dts/qcom/qcs404.dtsi
+++ b/arch/arm64/boot/dts/qcom/qcs404.dtsi
@@ -677,11 +677,11 @@ usb3: usb@7678800 {
 			assigned-clock-rates = <19200000>, <200000000>;
 
 			interrupts = <GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 24 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 319 IRQ_TYPE_LEVEL_HIGH>;
+				     <GIC_SPI 319 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 24 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "pwr_event",
-					  "hs_phy_irq",
-					  "qusb2_phy";
+					  "qusb2_phy",
+					  "hs_phy_irq";
 
 			status = "disabled";
 
@@ -716,11 +716,11 @@ usb2: usb@79b8800 {
 			assigned-clock-rates = <19200000>, <133333333>;
 
 			interrupts = <GIC_SPI 32 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 31 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 318 IRQ_TYPE_LEVEL_HIGH>;
+				     <GIC_SPI 318 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 31 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "pwr_event",
-					  "hs_phy_irq",
-					  "qusb2_phy";
+					  "qusb2_phy",
+					  "hs_phy_irq";
 
 			status = "disabled";
 
-- 
2.53.0



