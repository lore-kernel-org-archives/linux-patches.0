Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AFF71C2335;
	Mon, 14 Oct 2024 15:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919601; cv=none; b=EMQFJqYZTim5LISXvIT6tN/9wEdZwTBo9VdVeDY+zwT+JAc8WsclLgmaF1qdPQZ7MZ9xv4GJ6xfsBg6/w6sYWzXCMTit9WoaMj7LCs/sbZ4UQ8S0bv6WQ4mxbTy0luWpb3AGXIUVp42abguqJdwo5ckQ7FakneHMUqPjDmZ/pQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919601; c=relaxed/simple;
	bh=BtOeomBYRsbjFbawBsExer2KMkoSxxAxi9i0KGwDT2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PtZq9x7spG6r8fWoJg1euunhSRJXrOsP2+GQYQe88qRFL9dGW/9TFMDJB6GfVFhh+xF83r+RMZ4igEsZYdaVmOT0Kg4sMI3UicrEYGh3MwS3Nm5vdbxhjnbUPNKJU6zRuw4//zPfB4YVkvqMOTf69/iiHHmfWo3tGnFbawIke04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TZlCAJCS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TZlCAJCS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D49FCC4CEC3;
	Mon, 14 Oct 2024 15:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919601;
	bh=BtOeomBYRsbjFbawBsExer2KMkoSxxAxi9i0KGwDT2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TZlCAJCSz/luBi4IzPlpcJOscnFUbQP/zOM9TjMCmA174jks4uezVJuphKfPfs6Qj
	 Zz8AQte0NN1/23PU8kR3bb5oe3Jirx7XbmCS5v7bqcXJ/E/lCkhkLLY+nldFuKYiho
	 gdklDc8ZQIrKizg5kFjIwFC1mS0epsW0xGkIk0HQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"dmitry.baryshkov@linaro.org, agross@kernel.org, bjorn.andersson@linaro.org, robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org, linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org, Sumit Semwal" <sumit.semwal@linaro.org>,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH 6.1 653/798] Revert "arm64: dts: qcom: sm8250: switch UFS QMP PHY to new style of bindings"
Date: Mon, 14 Oct 2024 16:20:07 +0200
Message-ID: <20241014141243.704889775@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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
@@ -2125,7 +2125,7 @@
 				     "jedec,ufs-2.0";
 			reg = <0 0x01d84000 0 0x3000>;
 			interrupts = <GIC_SPI 265 IRQ_TYPE_LEVEL_HIGH>;
-			phys = <&ufs_mem_phy>;
+			phys = <&ufs_mem_phy_lanes>;
 			phy-names = "ufsphy";
 			lanes-per-direction = <2>;
 			#reset-cells = <1>;
@@ -2169,8 +2169,10 @@
 
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
@@ -2178,12 +2180,18 @@
 
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


