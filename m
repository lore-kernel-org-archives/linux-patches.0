Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03E43A8CC
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wDrohkmZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD05C433C9;
	Wed, 15 Nov 2023 19:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077397;
	bh=NWpnWef7GwH//Apj8icO1cmBaNidgGW/yzB2eXxyMp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wDrohkmZqdmbeGWV0xwH81uXqt/x8WRoHR+vNdCwnKvmI3Zuelhvb+uRaKyGdV8f2
	 sZtFDtXFuJ7y2yQGU366ajnv4GGvsXizbZDxFj///B9gESO7ioE+PUlLsLCoJ2XRkr
	 uUXaDfggKdRESQuMWXu3Iqr4X52FLI8qCVv3J+Fo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 278/603] arm64: dts: qcom: sc7280: link usb3_phy_wrapper_gcc_usb30_pipe_clk
Date: Wed, 15 Nov 2023 14:13:43 -0500
Message-ID: <20231115191632.604735593@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 70c4a1ca13b333b00e01266d299605fa1041b0d5 ]

Use usb_1_ssphy's clock as gcc's usb3_phy_wrapper_gcc_usb30_pipe_clk
clock source.

Suggested-by: Neil Armstrong <neil.armstrong@linaro.org>
Fixes: 1c39e6f9b534 ("arm64: dts: qcom: sc7280: Add USB related nodes")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20230711120916.4165894-7-dmitry.baryshkov@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280.dtsi | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index 925428a5f6aea..2870fe8fd5263 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -869,7 +869,8 @@ gcc: clock-controller@100000 {
 			clocks = <&rpmhcc RPMH_CXO_CLK>,
 				 <&rpmhcc RPMH_CXO_CLK_A>, <&sleep_clk>,
 				 <0>, <&pcie1_lane>,
-				 <0>, <0>, <0>, <0>;
+				 <0>, <0>, <0>,
+				 <&usb_1_ssphy>;
 			clock-names = "bi_tcxo", "bi_tcxo_ao", "sleep_clk",
 				      "pcie_0_pipe_clk", "pcie_1_pipe_clk",
 				      "ufs_phy_rx_symbol_0_clk", "ufs_phy_rx_symbol_1_clk",
-- 
2.42.0



