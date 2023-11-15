Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B203DB8F
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Weqy5AY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8FFC433C8;
	Wed, 15 Nov 2023 19:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078181;
	bh=i1JI6WqCtTMw4OCt5EOqlqbx7pSQlKpETpmaqpzsoy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Weqy5AYQFCLLxd8puMW4JxC2M2Ib2Tcs8h/ex8pok2ax8FeLLfVrAkEpDqCu6CaL
	 RBC0tkNlUY3WfbkGi0oAc5QvaOX6ZlvQ0+/heQxFbOlT9iSC+7JyjyMnVJN+I45kcC
	 ZXc9qy7khc8/f9x6wX2KNNsmV4ovNd4LPmZOr15A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 161/379] arm64: dts: qcom: sc7280: link usb3_phy_wrapper_gcc_usb30_pipe_clk
Date: Wed, 15 Nov 2023 14:23:56 -0500
Message-ID: <20231115192654.632894605@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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
index 0cdc579f26de7..409dad617a27c 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -820,7 +820,8 @@ gcc: clock-controller@100000 {
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



