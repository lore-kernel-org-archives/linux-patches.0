Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13166168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:29:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BF4FC433D2;
	Mon,  8 May 2023 10:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541763;
	bh=fzFC5vxBVujB4YeLUKgbuN/aVD/16V0LyaVfmWbH8wY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uGDnhzkOwxhyaFv7ZQHbk7HaBc8fIWnuvOziry7yC1PtV/391bkV9IZc6PBA8o7mE
	 04Yz7TBlGjgwvpVOPib56p77IEzqV0kjbKHWIdrSeeP/TWhYKzhPMaPVUA+jswVivM
	 Q23dADlo3MU+TLP9S73V5aQAn0nETsfL5bBtknO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 220/663] arm64: dts: qcom: msm8994-msft-lumia-octagon: drop unit address from PMI8994 regulator
Date: Mon,  8 May 2023 11:40:46 +0200
Message-Id: <20230508094435.473150253@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 7a202df0f3eed006e4a9e7c06d62cf67be56c14c ]

The PMIC regulators are not supposed to have unit addresses.

Fixes: 60b214effb80 ("arm64: dts: qcom: msm8994-octagon: Configure regulators")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230312183622.460488-7-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8994-msft-lumia-octagon.dtsi | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8994-msft-lumia-octagon.dtsi b/arch/arm64/boot/dts/qcom/msm8994-msft-lumia-octagon.dtsi
index 9b67f0d3820cd..63dda2ab06241 100644
--- a/arch/arm64/boot/dts/qcom/msm8994-msft-lumia-octagon.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8994-msft-lumia-octagon.dtsi
@@ -542,8 +542,7 @@
 };
 
 &pmi8994_spmi_regulators {
-	vdd_gfx: s2@1700 {
-		reg = <0x1700 0x100>;
+	vdd_gfx: s2 {
 		regulator-min-microvolt = <980000>;
 		regulator-max-microvolt = <980000>;
 	};
-- 
2.39.2



