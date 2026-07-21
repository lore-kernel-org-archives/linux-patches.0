Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B1E40B112;
	Tue, 21 Jul 2026 15:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648792; cv=none; b=aC6nw3gYq1jpmvot4svE8QnO6nRmTdGWvWq2tOGJEJYovks+D7+PZqwyeX1pOt/OmsgPW8RMbBqnhcKMs5Xfgvu4msrMR7uxIonOfpy7APRyofw/xpJzgKyOPsZ3XRXWCeojgAiiEGDStkO5qcp5pJ+mismqs3jlMurlTQu5upo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648792; c=relaxed/simple;
	bh=s9TjMYVgITR3n1jRvDMPe8oWDNXaVU9Pc8dAuJCkSH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fQpPSff1iGONtGect/O16/ijgGeFKdkg73TzJXPNUZP1TIM3VUzTSWn725S/DoKx2KHMzrS5uL2frIog3AVkVMKQmBOCDPle+fR4NphF1qd0OAkDfo0e+gA8LSiXx7k5joQbgPILT7hhvUcxWucDVavy/M5eF3R8sGNoekO7aJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cDMM7REK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cDMM7REK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9B111F000E9;
	Tue, 21 Jul 2026 15:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648791;
	bh=ppn+uXn/qHymhgG1ZpiJ4qM7fgq9TGYZaKxoGGXc3HA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cDMM7REKjAnTd2MSZ+doMAzIVN1h3bqndjCdhS8Pw/mzrgZ8El/mkGpjcNIJj5zEb
	 kcN42Egn2+sZ6CMt1FLLVPufKdI/iy99rCY0rqxFfeR8F28alhJtG0M/s+DY9HRlBa
	 UIZ/dw2MhILUzsiqLGSfvoU3DDKnTolgGchId3Mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0316/2077] arm64: tegra: Fix address of Tegra264 main GPIO controller
Date: Tue, 21 Jul 2026 16:59:49 +0200
Message-ID: <20260721152600.130855909@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jon Hunter <jonathanh@nvidia.com>

[ Upstream commit 7f2eeae12690aaee6195f85ed129a29c17f156d1 ]

The 64-bit address of the main GPIO controller on Tegra264 is
0x810c300000. The main GPIO controller was incorrectly added under the
bus@0 node instead of the bus@8100000000 node breaking the boot on
Tegra264. Fix this by moving to main GPIO controller node under
bus@8100000000.

Fixes: c70e6bc11d20 ("arm64: tegra: Add Tegra264 GPIO controllers")
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra264.dtsi | 88 ++++++++++++------------
 1 file changed, 44 insertions(+), 44 deletions(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra264.dtsi b/arch/arm64/boot/dts/nvidia/tegra264.dtsi
index 06d8357bdf527d..2d8e7e37830ff2 100644
--- a/arch/arm64/boot/dts/nvidia/tegra264.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra264.dtsi
@@ -3277,50 +3277,6 @@ rtc: rtc@c2c0000 {
 			status = "disabled";
 		};
 
-		gpio_main: gpio@c300000 {
-			compatible = "nvidia,tegra264-gpio";
-			reg = <0x00 0x0c300000 0x0 0x4000>,
-			      <0x00 0x0c310000 0x0 0x4000>;
-			reg-names = "security", "gpio";
-			wakeup-parent = <&pmc>;
-			interrupts =  <GIC_SPI 99 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 100 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 101 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 102 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 103 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 104 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 105 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 106 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 107 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 108 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 109 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 110 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 111 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 112 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 113 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 115 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 116 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 117 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 118 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 119 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 120 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 121 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 122 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 91 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 92 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 93 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 95 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 96 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 97 IRQ_TYPE_LEVEL_HIGH>,
-				      <GIC_SPI 98 IRQ_TYPE_LEVEL_HIGH>;
-			gpio-controller;
-			#gpio-cells = <2>;
-			interrupt-controller;
-			#interrupt-cells = <2>;
-		};
-
 		serial@c4e0000 {
 			compatible = "nvidia,tegra264-utc";
 			reg = <0x0 0x0c4e0000 0x0 0x8000>,
@@ -3586,6 +3542,50 @@ pci@c000000 {
 			status = "disabled";
 		};
 
+		gpio_main: gpio@c300000 {
+			compatible = "nvidia,tegra264-gpio";
+			reg = <0x00 0x0c300000 0x0 0x4000>,
+			      <0x00 0x0c310000 0x0 0x4000>;
+			reg-names = "security", "gpio";
+			wakeup-parent = <&pmc>;
+			interrupts =  <GIC_SPI 99 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 100 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 101 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 102 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 103 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 104 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 105 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 106 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 107 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 108 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 109 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 110 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 111 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 112 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 113 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 115 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 116 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 117 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 118 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 119 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 120 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 121 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 122 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 91 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 92 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 93 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 95 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 96 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 97 IRQ_TYPE_LEVEL_HIGH>,
+				      <GIC_SPI 98 IRQ_TYPE_LEVEL_HIGH>;
+			gpio-controller;
+			#gpio-cells = <2>;
+			interrupt-controller;
+			#interrupt-cells = <2>;
+		};
+
 		i2c14: i2c@c410000 {
 			compatible = "nvidia,tegra264-i2c";
 			reg = <0x00 0x0c410000 0x0 0x10000>;
-- 
2.53.0



