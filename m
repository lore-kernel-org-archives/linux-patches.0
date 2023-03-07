Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2D8BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:08:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6714C433D2;
	Tue,  7 Mar 2023 17:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678208882;
	bh=p7WmyUXTPFnwTxMZFdiyBYLGszmEaQtIbbylizGaKTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GSo49ZmNLoPyGfrO38/gx3ykvQl4/hRKtILlDJQD9lxwiMrU8LPw26BFbjD5J4tkZ
	 h+IAioXK8l/65w3z+9Gr7jv01+pOcV5sCXu9mWCNRN0eE4MC6Kn4PQ8nuua8uxjcdi
	 b6RvvL5oyI2wtsAKeltzxVsCBGj87LzX95JXuTl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0041/1001] arm64: dts: qcom: msm8996-oneplus-common: drop vdda-supply from DSI PHY
Date: Tue,  7 Mar 2023 17:46:53 +0100
Message-Id: <20230307170023.918472778@linuxfoundation.org>
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

[ Upstream commit 1de4e112b97c77efb5cbee39db8541e33dd2b0d5 ]

14nm DSI PHY has the only supply, vcca. Drop the extra vdda-supply.

Fixes: 5a134c940cd3 ("arm64: dts: qcom: msm8996: add support for oneplus3(t)")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230109042406.312047-1-dmitry.baryshkov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8996-oneplus-common.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8996-oneplus-common.dtsi b/arch/arm64/boot/dts/qcom/msm8996-oneplus-common.dtsi
index 20f5c103c63b7..2994337c60464 100644
--- a/arch/arm64/boot/dts/qcom/msm8996-oneplus-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996-oneplus-common.dtsi
@@ -179,7 +179,6 @@ &dsi0_out {
 };
 
 &dsi0_phy {
-	vdda-supply = <&vreg_l2a_1p25>;
 	vcca-supply = <&vreg_l28a_0p925>;
 	status = "okay";
 };
-- 
2.39.2



