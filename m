Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E4CCBA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:07:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7DCAC433EF;
	Tue,  7 Mar 2023 17:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678208879;
	bh=J0Bk/17vgGO+3oHXvnaTeeOLvVyK2WvZ1EDUOuViyog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Y4iFBgcsZ5sDIlYxkUGQj7U5lDE/RR9BwBugIHHm6dOLfOsYZQcUN9Q90pMDtFRe
	 W7vHJXcBvRghHP8cZbMODNiBK/Mr2tfCGuGZIxiihxviBibN05gf50NNMqOzBRaRfN
	 ejpRowVT7KGbbjgEkcXYnaPlvQIOyFPfka3GAE38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0040/1001] arm64: dts: qcom: sdm845: make DP node follow the schema
Date: Tue,  7 Mar 2023 17:46:52 +0100
Message-Id: <20230307170023.876099331@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 19e509d5ea229244b9205f8671bb75b13738a1f9 ]

Drop the #clock-cells (probably a leftover from the times before the DP
PHY split)

Fixes: eaac4e55a6f4 ("arm64: dts: qcom: sdm845: add displayport node")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230110042126.702147-1-dmitry.baryshkov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index 65032b94b46d6..f36c23e7a2248 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -4593,7 +4593,6 @@ mdss_dp: displayport-controller@ae90000 {
 					 <&dispcc DISP_CC_MDSS_DP_PIXEL_CLK>;
 				clock-names = "core_iface", "core_aux", "ctrl_link",
 					      "ctrl_link_iface", "stream_pixel";
-				#clock-cells = <1>;
 				assigned-clocks = <&dispcc DISP_CC_MDSS_DP_LINK_CLK_SRC>,
 						  <&dispcc DISP_CC_MDSS_DP_PIXEL_CLK_SRC>;
 				assigned-clock-parents = <&dp_phy 0>, <&dp_phy 1>;
-- 
2.39.2



