Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0353B361DDC;
	Sat, 12 Sep 2026 08:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200610; cv=none; b=MqtwNpvMJN5sn7eMKjjmlwyKF1CMi/Sbu64YFKBQBtxG5VCYg3PtOJEi+vpG9+6mKWb+ZpfH/XAmwMit09aHTWPWqD5SFxAm59dhvBe6bYM2TlXUZi2/Wq5PH4jS+F2CGvQhxsEF8Lt1xkzRvG8795cp3L2w19mArjH5U0S8bHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200610; c=relaxed/simple;
	bh=U8EIHIWg3xYLv9sotU9s6sXKK60SvCg9BRCfihbtxD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DgfmjiHIZMIZkOJQqSsqj9BKibdYEdbWZe261UOzib4AZ1uIE5kxZwOmAS6D+TTO+9EO/5M8FIw69PxdtbDk+0wL668E25MPfMnuFi95x7LfDX/e3QREQBEPQ7s6yzy2p6E0hrx+P3wOIPxBiqTXK+XzH1gU8jlzJvJOMsjJ31Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s2L43grj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s2L43grj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 212CC1F000FF;
	Sat, 12 Sep 2026 08:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200608;
	bh=r92zkZqqkgvvDLIxmrIjVYgFC8W61ueOfUbZiJiIRJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s2L43grjEl0D+KX5TT1E5C4Ew0FJdgouHjIBV9TerWSQgYwIOJhXcdXeMjoVh2EQJ
	 gx3KEFVpOgSUEIQze5DqSMBLzxVWY2etp8NSizJKKBKypH3P/f6dRfLEuUQJdGIF5+
	 PmGpnLdydeBl8yaRAM+AYXCj5jUFDQKN5yd0Z6Zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0782/1815] arm64: dts: qcom: qcs404: Fix DTBS Check errors in usb controller nodes
Date: Sat, 12 Sep 2026 08:42:12 +0200
Message-ID: <20260912065707.268157273@linuxfoundation.org>
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



