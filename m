Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0FE01E1A35;
	Tue, 15 Oct 2024 12:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994011; cv=none; b=fjtdwmNzMQPKGScil758P//Yzo5hgs7i/Pe9zvQ/rW/ISewI6lKAh/FKjYOYRXtormjDsZQ8NKZsBdKLwgHhdO0amJiD0rA+whpZ2UXTj7S9Q4W1jIudQtFQe/AHKJR4a5Cap+HKH1qA9NYVPRYt+38uAd5UUAyRE4otbUn/1DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994011; c=relaxed/simple;
	bh=Jj7Z7OjsjmoLxTyRyWxsHmP5g17IfZlsOEaT4f1mCBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ppvZxx6+1+gxtDzJd6Rami6YiP4Dnr+/pXAt1L7r/s41sLcckieFO4rNCV+3OFhgp0fTNfcFGriojUqcWZ1wAqxjbALuq0efzIXNL1rI0TB7xc2u2ocCSWBQvlTqoyWYOeUNnLOjyKqW+bAEF43l1H5zs9pGlJ/wrXGDsCeZo/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pEmF7Ckt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pEmF7Ckt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A1FEC4CEC6;
	Tue, 15 Oct 2024 12:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994010;
	bh=Jj7Z7OjsjmoLxTyRyWxsHmP5g17IfZlsOEaT4f1mCBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pEmF7Ckt8RWILIE9O53Ltm1kBSogrkaQ/G20Ls9xSJnOc85WcNPXsJ90OxBFZUqpO
	 hRXiqOnXcicyO/cKFWiPEqakkbMgH8XuZZr92O+Ew3BtF9cChXY5CHyAkRTipwpiK+
	 5Zn46PlZbaq3DyqIK2teR4FAGk1PbbNQQyMZbFdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"dmitry.baryshkov@linaro.org, agross@kernel.org, bjorn.andersson@linaro.org, robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org, linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org, Sumit Semwal" <sumit.semwal@linaro.org>,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH 5.15 579/691] Revert "arm64: dts: qcom: sm8250: switch UFS QMP PHY to new style of bindings"
Date: Tue, 15 Oct 2024 13:28:47 +0200
Message-ID: <20241015112503.321121510@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sumit Semwal <sumit.semwal@linaro.org>

This reverts commit cf9c7b34b90b622254b236a9a43737b6059a1c14.

This commit breaks UFS on RB5 in the 6.1 LTS kernels. The original patch
author suggests that this is not a stable kernel patch, hence reverting
it.

This was reported during testing with 6.1.103 / 5.15.165 LTS kernels
merged in the respective Android Common Kernel branches.

Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi |   20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -1702,7 +1702,7 @@
 				     "jedec,ufs-2.0";
 			reg = <0 0x01d84000 0 0x3000>;
 			interrupts = <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH>;
-			phys = <&ufs_mem_phy>;
+			phys = <&ufs_mem_phy_lanes>;
 			phy-names = "ufsphy";
 			lanes-per-direction = <2>;
 			#reset-cells = <1>;
@@ -1746,8 +1746,10 @@
 
 		ufs_mem_phy: phy@1d87000 {
 			compatible = "qcom,sm8250-qmp-ufs-phy";
-			reg = <0 0x01d87000 0 0x1000>;
-
+			reg = <0 0x01d87000 0 0x1c0>;
+			#address-cells = <2>;
+			#size-cells = <2>;
+			ranges;
 			clock-names = "ref",
 				      "ref_aux";
 			clocks = <&rpmhcc RPMH_CXO_CLK>,
@@ -1755,12 +1757,18 @@
 
 			resets = <&ufs_mem_hc 0>;
 			reset-names = "ufsphy";
+			status = "disabled";
 
 			power-domains = <&gcc UFS_PHY_GDSC>;
 
-			#phy-cells = <0>;
-
-			status = "disabled";
+			ufs_mem_phy_lanes: phy@1d87400 {
+				reg = <0 0x01d87400 0 0x16c>,
+				      <0 0x01d87600 0 0x200>,
+				      <0 0x01d87c00 0 0x200>,
+				      <0 0x01d87800 0 0x16c>,
+				      <0 0x01d87a00 0 0x200>;
+				#phy-cells = <0>;
+			};
 		};
 
 		ipa_virt: interconnect@1e00000 {


