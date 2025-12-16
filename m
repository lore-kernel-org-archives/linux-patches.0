Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93748361DAD;
	Tue, 16 Dec 2025 12:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886922; cv=none; b=W74Ku1g6p0Yrk9pok3gv+GX3Y9Fqrh8NShoegnZLEKlFKT7eY8vqlBkE8y+2qIbyLE3y2X31Vr/ihr5ZAzuNTk6RxZ0h0Z1wZ5gwNZVembNjilrQwbyu2LKfumVdfkpjDcEneuC35ZYvE9drabnbotPeELnCg63XsqT4BMWZqU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886922; c=relaxed/simple;
	bh=ym6eWQmlIsJ1P42tn8jt2h6wpu8WY3gl/iO6POkpSEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SOjjTkXyhOiiKug3nMFahESVQT3j/uyzAx035NjnbTQjzBaWch0ohRHwW3g4fj5lNttonC1rFY7JGMtmjkvPvL3SLPTrsMD8fCuvSi+Q5LJtStYe/w5p7jQTv02PFg6PqHPiaWeOWv0FltD4QaXkPk4/JKi9itcYknZTbxKUbB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ICOI8ngl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ICOI8ngl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02F50C4CEF1;
	Tue, 16 Dec 2025 12:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886922;
	bh=ym6eWQmlIsJ1P42tn8jt2h6wpu8WY3gl/iO6POkpSEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ICOI8nglBFrt/Gmcg3mnFlIUkhNQIXrby/NIacyCwRGBETEhLfiPWUu1u1J/OKD29
	 7bdW5RJDGsMu3ZJ3lAZHt2mqvF0YlLauSh5cGVmZVNL7jgAftyHSaaCAsmSPsd8z99
	 BOHViWIkMaMcTny43TlQBlX2J5QtQW4gMBSR+ftA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Griffin <peter.griffin@linaro.org>,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 074/614] arm64: dts: exynos: gs101: fix clock module unit reg sizes
Date: Tue, 16 Dec 2025 12:07:21 +0100
Message-ID: <20251216111403.998382789@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Griffin <peter.griffin@linaro.org>

[ Upstream commit ddb2a16804d005a96e8b5ffc0925e2f5bff65767 ]

The memory map lists each clock module unit as having a size of
0x10000. Additionally there are some undocumented registers in this region
that need to be used for automatic clock gating mode. Some of those
registers also need to be saved/restored on suspend & resume.

Fixes: 86124c76683e ("arm64: dts: exynos: gs101: enable cmu-hsi2 clock controller")
Fixes: 4982a4a2092e ("arm64: dts: exynos: gs101: enable cmu-hsi0 clock controller")
Fixes: 7d66d98b5bf3 ("arm64: dts: exynos: gs101: enable cmu-peric1 clock controller")
Fixes: e62c706f3aa0 ("arm64: dts: exynos: gs101: enable cmu-peric0 clock controller")
Fixes: ea89fdf24fd9 ("arm64: dts: exynos: google: Add initial Google gs101 SoC support")
Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Reviewed-by: André Draszik <andre.draszik@linaro.org>
Link: https://patch.msgid.link/20251013-automatic-clocks-v1-4-72851ee00300@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/exynos/google/gs101.dtsi | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/boot/dts/exynos/google/gs101.dtsi b/arch/arm64/boot/dts/exynos/google/gs101.dtsi
index 31c99526470d0..6335e0a8136be 100644
--- a/arch/arm64/boot/dts/exynos/google/gs101.dtsi
+++ b/arch/arm64/boot/dts/exynos/google/gs101.dtsi
@@ -288,7 +288,7 @@ soc: soc@0 {
 
 		cmu_misc: clock-controller@10010000 {
 			compatible = "google,gs101-cmu-misc";
-			reg = <0x10010000 0x8000>;
+			reg = <0x10010000 0x10000>;
 			#clock-cells = <1>;
 			clocks = <&cmu_top CLK_DOUT_CMU_MISC_BUS>,
 				 <&cmu_top CLK_DOUT_CMU_MISC_SSS>;
@@ -365,7 +365,7 @@ ppi_cluster2: interrupt-partition-2 {
 
 		cmu_peric0: clock-controller@10800000 {
 			compatible = "google,gs101-cmu-peric0";
-			reg = <0x10800000 0x4000>;
+			reg = <0x10800000 0x10000>;
 			#clock-cells = <1>;
 			clocks = <&ext_24_5m>,
 				 <&cmu_top CLK_DOUT_CMU_PERIC0_BUS>,
@@ -911,7 +911,7 @@ spi_14: spi@10a20000 {
 
 		cmu_peric1: clock-controller@10c00000 {
 			compatible = "google,gs101-cmu-peric1";
-			reg = <0x10c00000 0x4000>;
+			reg = <0x10c00000 0x10000>;
 			#clock-cells = <1>;
 			clocks = <&ext_24_5m>,
 				 <&cmu_top CLK_DOUT_CMU_PERIC1_BUS>,
@@ -1265,7 +1265,7 @@ spi_13: spi@10d60000 {
 
 		cmu_hsi0: clock-controller@11000000 {
 			compatible = "google,gs101-cmu-hsi0";
-			reg = <0x11000000 0x4000>;
+			reg = <0x11000000 0x10000>;
 			#clock-cells = <1>;
 
 			clocks = <&ext_24_5m>,
@@ -1332,7 +1332,7 @@ pinctrl_hsi1: pinctrl@11840000 {
 
 		cmu_hsi2: clock-controller@14400000 {
 			compatible = "google,gs101-cmu-hsi2";
-			reg = <0x14400000 0x4000>;
+			reg = <0x14400000 0x10000>;
 			#clock-cells = <1>;
 			clocks = <&ext_24_5m>,
 				 <&cmu_top CLK_DOUT_CMU_HSI2_BUS>,
@@ -1395,7 +1395,7 @@ ufs_0_phy: phy@14704000 {
 
 		cmu_apm: clock-controller@17400000 {
 			compatible = "google,gs101-cmu-apm";
-			reg = <0x17400000 0x8000>;
+			reg = <0x17400000 0x10000>;
 			#clock-cells = <1>;
 
 			clocks = <&ext_24_5m>;
@@ -1497,7 +1497,7 @@ pinctrl_gsacore: pinctrl@17a80000 {
 
 		cmu_top: clock-controller@1e080000 {
 			compatible = "google,gs101-cmu-top";
-			reg = <0x1e080000 0x8000>;
+			reg = <0x1e080000 0x10000>;
 			#clock-cells = <1>;
 
 			clocks = <&ext_24_5m>;
-- 
2.51.0



