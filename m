Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151901CBE8F;
	Tue, 12 Nov 2024 10:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407311; cv=none; b=hgyLk+Ywbq/g3t6Wxk6ZLn27indjfuuKak2YUgLl1qoFRtSeC30rGnB8/cgarWhHJIqG/vT4211Q5SCMqxedVdLPdgFiKeLf0qM3jFIbvBM3fv/iu0WpMH+Yv38rghTZnVYtFpaspkXRRZZSecs2LgLW483ife1wVWEVGrg9c6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407311; c=relaxed/simple;
	bh=r9X9J4B3jmRUTnVF/kPNhXZSxAsRW8sjpimH34XI/oE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hcxoefvxp5CAYwalui0Mc/Ky5CMvhEPQjxPyVPuD7UK+noUYS4DMYh79trAzrAmBL93n98vjWBoaCSTPTIeDGoaiaG3H8xEPyCnaE7ZAJ+KX+sz5XljxJte8e3WFQAsmGfoFWAvYZU8fhzpeHTrPWPoIRleIeurSBPdRTDtBxcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F5/k4PTk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F5/k4PTk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8943CC4CECD;
	Tue, 12 Nov 2024 10:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407311;
	bh=r9X9J4B3jmRUTnVF/kPNhXZSxAsRW8sjpimH34XI/oE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F5/k4PTkrjfSt/fpyCd5NUlG83b03s689oHVY7YaFfxkQG5E9inTgU/RIeDfMLnCC
	 IPGA0/KWTyVcj7mKClu1uZjBtt7oxaLp2DXQEeyJ5PAIn5zP8mqvXaUyg6IpAttmg4
	 D+0I3WDPDCH7dBTbdKklFxaUnU5n6MTsFr0iMGJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 10/98] arm64: dts: imx8-ss-vpu: Fix imx8qm VPU IRQs
Date: Tue, 12 Nov 2024 11:20:25 +0100
Message-ID: <20241112101844.664547255@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



