Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F68B11CA1
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:03:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79F99C433D2;
	Mon,  8 May 2023 11:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543788;
	bh=08hUQEn+VYwrM7/bNpl17sYbHo5GpzvLyMux3XBKkmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=erWw2qv026uZzZlj4XF2Ck3UXoowKhLGW8tAmAWac+ulQ5HbDZf/Xg3fKfdNGYiYv
	 XxEhW+3v1To4XpKheAM4fgCv3Am6aM1Pob8sPtuu0o5DDvkciafG8tdLKlJ7AtsD1N
	 7I5xM8aJC8jTrNdZGuu09foR/YCm1RMLTOJaI5+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 201/694] arm64: dts: qcom: sm8550: misc style fixes
Date: Mon,  8 May 2023 11:40:36 +0200
Message-Id: <20230508094438.920168452@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit f03908b23f84ecd49f12facf4acf34c3ad24f27a ]

Miscellaneous DT fixes to remove spurious blank line and enhance readability.

Fixes: ffc50b2d3828 ("arm64: dts: qcom: Add base SM8550 dtsi")
Fixes: d7da51db5b81 ("arm64: dts: qcom: sm8550: add display hardware devices")
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230308-topic-sm8550-upstream-dt-fixups-v1-3-595b02067672@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index 7da28b36470e8..f05cdb376a175 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -412,7 +412,6 @@
 			no-map;
 		};
 
-
 		hyp_tags_reserved_mem: hyp-tags-reserved-region@811d0000 {
 			reg = <0 0x811d0000 0 0x30000>;
 			no-map;
@@ -2195,7 +2194,8 @@
 
 				assigned-clocks = <&dispcc DISP_CC_MDSS_BYTE0_CLK_SRC>,
 						  <&dispcc DISP_CC_MDSS_PCLK0_CLK_SRC>;
-				assigned-clock-parents = <&mdss_dsi0_phy 0>, <&mdss_dsi0_phy 1>;
+				assigned-clock-parents = <&mdss_dsi0_phy 0>,
+							 <&mdss_dsi0_phy 1>;
 
 				operating-points-v2 = <&mdss_dsi_opp_table>;
 
@@ -2287,8 +2287,10 @@
 
 				power-domains = <&rpmhpd SM8550_MMCX>;
 
-				assigned-clocks = <&dispcc DISP_CC_MDSS_BYTE1_CLK_SRC>, <&dispcc DISP_CC_MDSS_PCLK1_CLK_SRC>;
-				assigned-clock-parents = <&mdss_dsi1_phy 0>, <&mdss_dsi1_phy 1>;
+				assigned-clocks = <&dispcc DISP_CC_MDSS_BYTE1_CLK_SRC>,
+						  <&dispcc DISP_CC_MDSS_PCLK1_CLK_SRC>;
+				assigned-clock-parents = <&mdss_dsi1_phy 0>,
+							 <&mdss_dsi1_phy 1>;
 
 				operating-points-v2 = <&mdss_dsi_opp_table>;
 
@@ -3156,7 +3158,7 @@
 
 		intc: interrupt-controller@17100000 {
 			compatible = "arm,gic-v3";
-			reg = <0 0x17100000 0 0x10000>,	/* GICD */
+			reg = <0 0x17100000 0 0x10000>,		/* GICD */
 			      <0 0x17180000 0 0x200000>;	/* GICR * 8 */
 			ranges;
 			#interrupt-cells = <3>;
-- 
2.39.2



