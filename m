Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD3C40587A;
	Tue, 21 Jul 2026 17:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655624; cv=none; b=Im2SdKLZukLH00bVQwCW9pMIqKOMx5r5sfQwFEqdRraxa2u0ovyUJ7zbptEgTCeLglUxB+C8JBnQao7htDaVidzAz4B2KLjQ4G4UIlF5tVdMQDQvE6aAW0TbFloc3x/rG5cwbUMQfRjClwBDRSAAXG8QCQ0Jq5vwPm5RVswylqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655624; c=relaxed/simple;
	bh=hogOO5/DcgOZICisEHGJZWBtGFAE9cww3fvmqtkXNDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQrB+Y/7CGJpLir7EoLV2wRTLsl28o5dD6InnHJvrNamlFNNwQf0NARqgRYM++rvXS0eLvPWRnaIhGKhJNRIw1SiG3mxZUYi9sE8dnJUNf6i0883yMYrRkni5xJ+qIjQRwyACBfaTLdYzt9Ubq8x/djf8cPHWdUdBE8d1s7NKCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UR75TOtb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UR75TOtb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D69931F000E9;
	Tue, 21 Jul 2026 17:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655623;
	bh=CDLpyScMDnWd43gmoLUMSW/rU/MrOQCtaZiYxu07f4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UR75TOtbcC7/OhAhoCE/QT0nmRURe8V2elznQ/LHETrx+i4on5Oo87gzCE2ZTVE/S
	 TIAc74+eNSsRlto/ryA/DeCaIUE8hIi20xweC7SNO1Y6rARIRUVSEuQatqMu9Vftve
	 kJx6pY/SNgtRAJHMecwpSAEzKZ0Y/I+UzWFXPve8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0078/1611] arm64: dts: qcom: ipq5424: Fix USB simple_bus_reg warnings
Date: Tue, 21 Jul 2026 17:03:14 +0200
Message-ID: <20260721152516.595380056@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit 864fde494aa1dd26c68254661f2ce973e9f03832 ]

Correct the unit address of USB nodes in Qualcomm IPQ5424 SoC DTSI to
fix W=1 DTC warnings:

  ipq5424.dtsi:642.22-693.5: Warning (simple_bus_reg): /soc@0/usb2@1e00000: simple-bus unit address format error, expected "1ef8800"
  ipq5424.dtsi:733.22-786.5: Warning (simple_bus_reg): /soc@0/usb3@8a00000: simple-bus unit address format error, expected "8af8800"

Fixes: 113d52bdc820 ("arm64: dts: qcom: ipq5424: Add USB controller and phy nodes")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260405-dts-qcom-w-1-fixes-v2-3-1f2c7b74a93f@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq5424.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq5424.dtsi b/arch/arm64/boot/dts/qcom/ipq5424.dtsi
index 227d5ce2975151..d103368fff9ac4 100644
--- a/arch/arm64/boot/dts/qcom/ipq5424.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq5424.dtsi
@@ -601,7 +601,7 @@ qusb_phy_1: phy@71000 {
 			status = "disabled";
 		};
 
-		usb2: usb2@1e00000 {
+		usb2: usb2@1ef8800 {
 			compatible = "qcom,ipq5424-dwc3", "qcom,dwc3";
 			reg = <0 0x01ef8800 0 0x400>;
 			#address-cells = <2>;
@@ -692,7 +692,7 @@ ssphy_0: phy@7d000 {
 			status = "disabled";
 		};
 
-		usb3: usb3@8a00000 {
+		usb3: usb3@8af8800 {
 			compatible = "qcom,ipq5424-dwc3", "qcom,dwc3";
 			reg = <0 0x08af8800 0 0x400>;
 
-- 
2.53.0



