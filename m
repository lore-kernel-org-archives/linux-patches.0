Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03FC31CBE8F;
	Tue, 12 Nov 2024 10:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407566; cv=none; b=GRRtHo/6r+AuXRqUAjdePpnlw9926uqlaVxwiw3Dye3EEEQTmOUkig3h0eVX/UH5oph7bYYtEZocUX8MjnuUzHPSpTKIRnGwFgEoCuVGREYY5cN/ooUjtGkypqyoTg3GXIaTV0eX/ubJWf+W8ERBdfRVBxWyFvmyO13sEZ5fPfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407566; c=relaxed/simple;
	bh=ilni2XCRLLvqV/GiTANXPVELi49IhI6sVwmhSYo76+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DP2MafHWDsc+695pZiV5p7Wp4Dxc63GC1l+ZD5msOp3ZzxKFf+UHfOj/zHmZZqPs9DBXFqNXTdwgWLqiNADIDhEDP5Rj2Dou/7EmfZPp+1Ewh8gdFi2OonTbCD2+tQysVKZnnIB/8xzcoY7J44SI6Ay0kMLxPEKrWUXFtg2gel0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t580F3Bn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t580F3Bn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73AF7C4CECD;
	Tue, 12 Nov 2024 10:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407565;
	bh=ilni2XCRLLvqV/GiTANXPVELi49IhI6sVwmhSYo76+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t580F3Bnjip4IloKjcFlz62m/o73iDXMLK4Us8YIs1Mwz6Giif7zMmI5kBRDHnGeP
	 /9KruwKJTZxjLCbQnHs7x6heqsxxoGaz1yDKs+dTg6U61xDWS8l+t4/hAFt9P1oJ98
	 lSm+3sdzWqnrYeAMMP8Py2Mnd4PKiwdtKZBXHyBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/119] arm64: dts: imx8-ss-vpu: Fix imx8qm VPU IRQs
Date: Tue, 12 Nov 2024 11:20:23 +0100
Message-ID: <20241112101849.296309358@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit eed2d8e8d0051a6551e4dffba99e16eb88c676ac ]

imx8-ss-vpu only contained imx8qxp IRQ numbers, only mu2_m0 uses the
correct imx8qm IRQ number, as imx8qxp lacks this MU.
Fix this by providing imx8qm IRQ numbers in the main imx8-ss-vpu.dtsi
and override the IRQ numbers in SoC-specific imx8qxp-ss-vpu.dtsi, similar
to reg property for VPU core devices.

Fixes: 0d9968d98467d ("arm64: dts: freescale: imx8q: add imx vpu codec entries")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8-ss-vpu.dtsi    | 4 ++--
 arch/arm64/boot/dts/freescale/imx8qxp-ss-vpu.dtsi | 8 ++++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8-ss-vpu.dtsi b/arch/arm64/boot/dts/freescale/imx8-ss-vpu.dtsi
index c6540768bdb92..87211c18d65a9 100644
--- a/arch/arm64/boot/dts/freescale/imx8-ss-vpu.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8-ss-vpu.dtsi
@@ -15,7 +15,7 @@ vpu: vpu@2c000000 {
 	mu_m0: mailbox@2d000000 {
 		compatible = "fsl,imx6sx-mu";
 		reg = <0x2d000000 0x20000>;
-		interrupts = <GIC_SPI 469 IRQ_TYPE_LEVEL_HIGH>;
+		interrupts = <GIC_SPI 472 IRQ_TYPE_LEVEL_HIGH>;
 		#mbox-cells = <2>;
 		power-domains = <&pd IMX_SC_R_VPU_MU_0>;
 		status = "disabled";
@@ -24,7 +24,7 @@ vpu: vpu@2c000000 {
 	mu1_m0: mailbox@2d020000 {
 		compatible = "fsl,imx6sx-mu";
 		reg = <0x2d020000 0x20000>;
-		interrupts = <GIC_SPI 470 IRQ_TYPE_LEVEL_HIGH>;
+		interrupts = <GIC_SPI 473 IRQ_TYPE_LEVEL_HIGH>;
 		#mbox-cells = <2>;
 		power-domains = <&pd IMX_SC_R_VPU_MU_1>;
 		status = "disabled";
diff --git a/arch/arm64/boot/dts/freescale/imx8qxp-ss-vpu.dtsi b/arch/arm64/boot/dts/freescale/imx8qxp-ss-vpu.dtsi
index 7894a3ab26d6b..f81937b5fb720 100644
--- a/arch/arm64/boot/dts/freescale/imx8qxp-ss-vpu.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8qxp-ss-vpu.dtsi
@@ -5,6 +5,14 @@
  * Author: Alexander Stein
  */
 
+&mu_m0 {
+	interrupts = <GIC_SPI 469 IRQ_TYPE_LEVEL_HIGH>;
+};
+
+&mu1_m0 {
+	interrupts = <GIC_SPI 470 IRQ_TYPE_LEVEL_HIGH>;
+};
+
 &vpu_core0 {
 	reg = <0x2d040000 0x10000>;
 };
-- 
2.43.0



