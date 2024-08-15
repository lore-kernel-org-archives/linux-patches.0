Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED95A1AE035;
	Thu, 15 Aug 2024 14:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730658; cv=none; b=dIUcwabflMHUgswZGPPW+fR8gRvPSWYhQpF7AVeynvskI8MX+XTfQqgjVZEE4wX0VpGr9ZxIept8saHzsKFov6l/YkkDemE/ROTu1wvkUyfneTwvMwjYYHzJZ3UdDdp1Mkf+0oqSuGEuU7njgvUTZH5l7GEVTp99RXXRd3yf2cY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730658; c=relaxed/simple;
	bh=uy7uWXD86erjX9o0BarSk0posxQh3IMIVb3R5/UPC5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AoERXa4kjnC1Ngo8Hkj/5+6oW5Q6YKEAUCfHnGGd9NA9CTHBpdmhZdikBhiaWxFZdeM1Y2Grhm1ceZY99Di39Bi3lLAb7UPAEm+dTIT87C767a65ehT/dlNQY5vjKF45s15Z5eeAfqsUX5LT8GQu98Ex8fwK1PVIfORZEEd0tsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yMPlh3wk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yMPlh3wk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56C65C32786;
	Thu, 15 Aug 2024 14:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730657;
	bh=uy7uWXD86erjX9o0BarSk0posxQh3IMIVb3R5/UPC5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yMPlh3wkCrc5jxGRvfrKBWKDft/t+ZVpbERWwEAsaD45wQfXIFaleRBst0nnDzkCA
	 TWQhHauegQ9ZzYXnjvkR6ftDxU/YhPw59rSJpyF8KcGSkBbXvSKG5RMIBf5rf6vDSI
	 H1lxh7CO7+V9kKS4hOdrEoQXVxces38yYK2lXtGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.15 477/484] arm64: dts: qcom: msm8996: correct #clock-cells for QMP PHY nodes
Date: Thu, 15 Aug 2024 15:25:35 +0200
Message-ID: <20240815131959.905311010@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

commit b874fff9a7683df30e5aff16d5a85b1f8a43aa5d upstream.

The commit 82d61e19fccb ("arm64: dts: qcom: msm8996: Move '#clock-cells'
to QMP PHY child node") moved the '#clock-cells' properties to the child
nodes. However it missed the fact that the property must have been set
to <0> (as all pipe clocks use of_clk_hw_simple_get as the xlate
function. Also the mentioned commit didn't add '#clock-cells' properties
to second and third PCIe PHY nodes. Correct both these mistakes:

- Set '#clock-cells' to <0>,
- Add the property to pciephy_1 and pciephy_2 nodes.

Fixes: 82d61e19fccb ("arm64: dts: qcom: msm8996: Move '#clock-cells' to QMP PHY child node")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220620071936.1558906-3-dmitry.baryshkov@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/msm8996.dtsi |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -636,7 +636,7 @@
 				      <0x00035400 0x1dc>;
 				#phy-cells = <0>;
 
-				#clock-cells = <1>;
+				#clock-cells = <0>;
 				clock-output-names = "pcie_0_pipe_clk_src";
 				clocks = <&gcc GCC_PCIE_0_PIPE_CLK>;
 				clock-names = "pipe0";
@@ -650,6 +650,7 @@
 				      <0x00036400 0x1dc>;
 				#phy-cells = <0>;
 
+				#clock-cells = <0>;
 				clock-output-names = "pcie_1_pipe_clk_src";
 				clocks = <&gcc GCC_PCIE_1_PIPE_CLK>;
 				clock-names = "pipe1";
@@ -663,6 +664,7 @@
 				      <0x00037400 0x1dc>;
 				#phy-cells = <0>;
 
+				#clock-cells = <0>;
 				clock-output-names = "pcie_2_pipe_clk_src";
 				clocks = <&gcc GCC_PCIE_2_PIPE_CLK>;
 				clock-names = "pipe2";
@@ -2662,7 +2664,7 @@
 				      <0x07410600 0x1a8>;
 				#phy-cells = <0>;
 
-				#clock-cells = <1>;
+				#clock-cells = <0>;
 				clock-output-names = "usb3_phy_pipe_clk_src";
 				clocks = <&gcc GCC_USB3_PHY_PIPE_CLK>;
 				clock-names = "pipe0";


