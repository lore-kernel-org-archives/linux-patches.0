Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F1A3EFFC9;
	Fri, 15 May 2026 16:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862165; cv=none; b=HG3+yWhms5DmX1fmPjbmehCTFAHRK7g4tWKWs89xugshiZV1hH4hbTtSNLHtT6M+MOTx3D+xMW03RQmOgmh5nhtmNKiPk38L2imnw3ZC1qf+6FBENTG2ofSAyE019O0pvq2S65zMUgXxdx4UC4DytQfibudi+vyuFzh5P8+FBKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862165; c=relaxed/simple;
	bh=UtAbYGv3MWYvYJ+DdN0erbo7GHm2QI51zkxSFgVntL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SIumXpP1P2vQu45J6lsfp0S51hKggeY9/3/M81/Lii1lOinORYWZQqnPDqOa33yeKG/o5lzTtkS5i4WzHA4spiljXQdWaHlOviuEY+fOylC9t5tS+pdPWpL978FmDRxxU7bUsmBp5zfrc++Nq9rcIg7OtIc29RWW41uyQhzEslw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oXeqXmdc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oXeqXmdc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7101C2BCB3;
	Fri, 15 May 2026 16:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862165;
	bh=UtAbYGv3MWYvYJ+DdN0erbo7GHm2QI51zkxSFgVntL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oXeqXmdc4wsjyeF0vdjmqWkc9V0M4uQxX32lgtBx1HYmm6YVZgb6Be//F13pddDG2
	 qLHSxUxPe7BLWNaoantz9ErGCxFkTgoLjQHDy0RkooDGdIIC2r4sGroAYY2toRtkQu
	 ZkCBx+mT/1981QXdOfXHrQj7sys0RZBS+VXwLaAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.18 133/188] arm64: dts: qcom: lemans: Correct QUP interrupt numbers
Date: Fri, 15 May 2026 17:49:10 +0200
Message-ID: <20260515154700.212935838@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

From: Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>

commit c5b22c88cc09b180e3a23010b29f4d02ec117a44 upstream.

Fix GIC_SPI interrupt numbers for QUPv3 SE6 nodes on Lemans SoC.
Using incorrect interrupt lines can prevent IRQs from triggering
and break I2C, SPI, and UART operation.

Fixes: 34a407316b7d3 ("arm64: dts: qcom: sa8775p: Populate additional UART DT nodes")
Fixes: 1b2d7ad5ac14d ("arm64: dts: qcom: sa8775p: add missing spi nodes")
Fixes: ee2f5f906d69d ("arm64: dts: qcom: sa8775p: add missing i2c nodes")
Cc: stable@vger.kernel.org
Signed-off-by: Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260325-lemans-irq-num-v1-1-a470d544966a@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/lemans.dtsi |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm64/boot/dts/qcom/lemans.dtsi
+++ b/arch/arm64/boot/dts/qcom/lemans.dtsi
@@ -1563,7 +1563,7 @@
 				reg = <0x0 0x898000 0x0 0x4000>;
 				#address-cells = <1>;
 				#size-cells = <0>;
-				interrupts = <GIC_SPI 834 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts = <GIC_SPI 833 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&gcc GCC_QUPV3_WRAP2_S6_CLK>;
 				clock-names = "se";
 				pinctrl-0 = <&qup_i2c20_default>;
@@ -1590,7 +1590,7 @@
 				reg = <0x0 0x898000 0x0 0x4000>;
 				#address-cells = <1>;
 				#size-cells = <0>;
-				interrupts = <GIC_SPI 834 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts = <GIC_SPI 833 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&gcc GCC_QUPV3_WRAP2_S6_CLK>;
 				clock-names = "se";
 				pinctrl-0 = <&qup_spi20_default>;
@@ -1615,7 +1615,7 @@
 			uart20: serial@898000 {
 				compatible = "qcom,geni-uart";
 				reg = <0x0 0x00898000 0x0 0x4000>;
-				interrupts = <GIC_SPI 834 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts = <GIC_SPI 833 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&gcc GCC_QUPV3_WRAP2_S6_CLK>;
 				clock-names = "se";
 				pinctrl-0 = <&qup_uart20_default>;
@@ -2561,7 +2561,7 @@
 				reg = <0x0 0xa98000 0x0 0x4000>;
 				#address-cells = <1>;
 				#size-cells = <0>;
-				interrupts = <GIC_SPI 836 IRQ_TYPE_LEVEL_HIGH>;
+				interrupts = <GIC_SPI 835 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&gcc GCC_QUPV3_WRAP1_S6_CLK>;
 				clock-names = "se";
 				pinctrl-0 = <&qup_i2c13_default>;


