Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0B6011705
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:39:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA535C433C8;
	Mon, 11 Sep 2023 14:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443164;
	bh=epapR4rCWpbCcWOJ81lVy8k7uhU0Z+4x8bXmCQFJJi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WD6uPhXfiGomrAhenA6ZdXCuDwC4jZRPwmj5xhvw9e+S82YcZiZ8ygY3dnXuA0m5G
	 ETs5TKbaDpdhgixzmP3CUVS1Ms2ztvYIG4XN05KmsisIEv/a5t0syM4nJFwuFydp8z
	 C+UO1iFT1FF2asC2cQbUMfFz9G60Qac6gh+4CTsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Degdag Mohamed <degdagmohamed@gmail.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 281/737] arm64: dts: qcom: sm8150: use proper DSI PHY compatible
Date: Mon, 11 Sep 2023 15:42:20 +0200
Message-ID: <20230911134658.418096283@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 3091e5820a367f3368132f57e0a9ba6d545da15d ]

The DSI PHY on the Qualcomm SM8150 platform requires platform-specific
handling. Use the proper SoC-specific compatible string for the DSI
PHYs.

Reported-by: Degdag Mohamed <degdagmohamed@gmail.com>
Fixes: 2ef3bb17c45c ("arm64: dts: qcom: sm8150: Add DISPCC node")
Cc: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230612031623.3620155-1-dmitry.baryshkov@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8150.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8150.dtsi b/arch/arm64/boot/dts/qcom/sm8150.dtsi
index 27dcda0d4288f..fe2d401a858a7 100644
--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -3805,7 +3805,7 @@ opp-358000000 {
 			};
 
 			mdss_dsi0_phy: phy@ae94400 {
-				compatible = "qcom,dsi-phy-7nm";
+				compatible = "qcom,dsi-phy-7nm-8150";
 				reg = <0 0x0ae94400 0 0x200>,
 				      <0 0x0ae94600 0 0x280>,
 				      <0 0x0ae94900 0 0x260>;
@@ -3879,7 +3879,7 @@ mdss_dsi1_out: endpoint {
 			};
 
 			mdss_dsi1_phy: phy@ae96400 {
-				compatible = "qcom,dsi-phy-7nm";
+				compatible = "qcom,dsi-phy-7nm-8150";
 				reg = <0 0x0ae96400 0 0x200>,
 				      <0 0x0ae96600 0 0x280>,
 				      <0 0x0ae96900 0 0x260>;
-- 
2.40.1



