Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A382E17552;
	Sat,  3 Feb 2024 04:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933551; cv=none; b=NL7iVsb9jDh/sKjoLRlb0jSabhbjsRaGu37+8orRwSwhISD84XVVYDwNRbWl/pLr1MaQDRJeHqvQSuYQ3Y7sexq9sOgI8WjJBwx5gWauJVSL+g2e3/cFtYmZBSrkcxa1OhBfT8ra5znsreCsp5h1yTcoR7VO5FTW7z+9qFrWoRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933551; c=relaxed/simple;
	bh=NxozYNrEJCT5EP4PHhixcMqNymDTayP6V+exMZ7oeW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RGyLWZ3kWLqElk3utjyTrpL3JcNQ82U604Pm0qVJKUr+p4ugUpeOrn4dpQ7mDCLBbnwZOV2mH/0S3iknDQBkHW7p1khjmviuRDueOUeMjC/jRgUb86bJ6fe7brDWod+cVpHNSvoiUlT9f8G2Aoj2+bTaxR21jJzjNSXhc6I0IUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MMFXd3jV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MMFXd3jV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF9BC433F1;
	Sat,  3 Feb 2024 04:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933551;
	bh=NxozYNrEJCT5EP4PHhixcMqNymDTayP6V+exMZ7oeW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MMFXd3jVSQl+U8fi0IUi9bmByFt3KeV84PiX7qbFRdIArYrf8X6ERLNVbjsyBZhZ5
	 8z0euj5h/8ifR9p06Y4/wQANQt7orZjJfrZonK02gZe4ogZqLrpYPxwLq8TPZirO0+
	 Rm2y8m1Rm08pey4/aMpp9rpA//iBgjDWdZDUbeeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 074/322] ARM: dts: samsung: s5pv210: fix camera unit addresses/ranges
Date: Fri,  2 Feb 2024 20:02:51 -0800
Message-ID: <20240203035401.564353647@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 07e6a553c2f1d385edfc9185081dee442a9dd38d ]

The camera node has both unit address and children within the same bus
mapping, thus needs proper ranges property to fix dtc W=1 warnings:

  Warning (unit_address_vs_reg): /soc/camera@fa600000: node has a unit name, but no reg or ranges property
  Warning (simple_bus_reg): /soc/camera@fa600000: missing or empty reg/ranges property

Subtract 0xfa600000 from all its children nodes.  No functional impact
expected.

Link: https://lore.kernel.org/r/20230722121719.150094-3-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/samsung/s5pv210.dtsi | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm/boot/dts/samsung/s5pv210.dtsi b/arch/arm/boot/dts/samsung/s5pv210.dtsi
index f7de5b5f2f38..ed560c9a3aa1 100644
--- a/arch/arm/boot/dts/samsung/s5pv210.dtsi
+++ b/arch/arm/boot/dts/samsung/s5pv210.dtsi
@@ -549,17 +549,17 @@
 
 		camera: camera@fa600000 {
 			compatible = "samsung,fimc";
+			ranges = <0x0 0xfa600000 0xe01000>;
 			clocks = <&clocks SCLK_CAM0>, <&clocks SCLK_CAM1>;
 			clock-names = "sclk_cam0", "sclk_cam1";
 			#address-cells = <1>;
 			#size-cells = <1>;
 			#clock-cells = <1>;
 			clock-output-names = "cam_a_clkout", "cam_b_clkout";
-			ranges;
 
-			csis0: csis@fa600000 {
+			csis0: csis@0 {
 				compatible = "samsung,s5pv210-csis";
-				reg = <0xfa600000 0x4000>;
+				reg = <0x00000000 0x4000>;
 				interrupt-parent = <&vic2>;
 				interrupts = <29>;
 				clocks = <&clocks CLK_CSIS>,
@@ -572,9 +572,9 @@
 				#size-cells = <0>;
 			};
 
-			fimc0: fimc@fb200000 {
+			fimc0: fimc@c00000 {
 				compatible = "samsung,s5pv210-fimc";
-				reg = <0xfb200000 0x1000>;
+				reg = <0x00c00000 0x1000>;
 				interrupts = <5>;
 				interrupt-parent = <&vic2>;
 				clocks = <&clocks CLK_FIMC0>,
@@ -586,9 +586,9 @@
 				samsung,cam-if;
 			};
 
-			fimc1: fimc@fb300000 {
+			fimc1: fimc@d00000 {
 				compatible = "samsung,s5pv210-fimc";
-				reg = <0xfb300000 0x1000>;
+				reg = <0x00d00000 0x1000>;
 				interrupt-parent = <&vic2>;
 				interrupts = <6>;
 				clocks = <&clocks CLK_FIMC1>,
@@ -602,9 +602,9 @@
 				samsung,lcd-wb;
 			};
 
-			fimc2: fimc@fb400000 {
+			fimc2: fimc@e00000 {
 				compatible = "samsung,s5pv210-fimc";
-				reg = <0xfb400000 0x1000>;
+				reg = <0x00e00000 0x1000>;
 				interrupt-parent = <&vic2>;
 				interrupts = <7>;
 				clocks = <&clocks CLK_FIMC2>,
-- 
2.43.0



