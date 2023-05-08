Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A05D168C9
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:05:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6277DC433D2;
	Mon,  8 May 2023 11:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543949;
	bh=NdarMadOb4muGY2XAkdlbDhQ7kymBU41E912MQJ3s8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EUkIBZzPzKN9C3XqhBjzyXlG7pV3/MpW5jLsQN8IQl3fhDs15UF2UdzQJbyatvxzf
	 h/eplJ74b48iL0pUrMRYgY20NucOEl1BjFnfamdHU4dWmC/I8DWA14ij5oxZNVsX4j
	 a624imAPDQF/8kZDe3xjNVW1q7jUrU9fExQuM9Bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 254/694] arm64: dts: qcom: apq8096-db820c: drop unit address from PMI8994 regulator
Date: Mon,  8 May 2023 11:41:29 +0200
Message-Id: <20230508094440.550527201@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit ec57cbce1a6d9384f8ac1ff966b204dc262f4927 ]

The PMIC regulators are not supposed to have unit addresses.

Fixes: 2317b87a2a6f ("arm64: dts: qcom: db820c: Add vdd_gfx and tie it into mmcc")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230312183622.460488-8-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/apq8096-db820c.dts | 3 +--
 arch/arm64/boot/dts/qcom/pmi8994.dtsi       | 2 --
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/apq8096-db820c.dts b/arch/arm64/boot/dts/qcom/apq8096-db820c.dts
index fe6c415e82297..5251dbcab4d90 100644
--- a/arch/arm64/boot/dts/qcom/apq8096-db820c.dts
+++ b/arch/arm64/boot/dts/qcom/apq8096-db820c.dts
@@ -706,8 +706,7 @@
 &pmi8994_spmi_regulators {
 	vdd_s2-supply = <&vph_pwr>;
 
-	vdd_gfx: s2@1700 {
-		reg = <0x1700 0x100>;
+	vdd_gfx: s2 {
 		regulator-name = "VDD_GFX";
 		regulator-min-microvolt = <980000>;
 		regulator-max-microvolt = <980000>;
diff --git a/arch/arm64/boot/dts/qcom/pmi8994.dtsi b/arch/arm64/boot/dts/qcom/pmi8994.dtsi
index a0af91698d497..0192968f4d9b3 100644
--- a/arch/arm64/boot/dts/qcom/pmi8994.dtsi
+++ b/arch/arm64/boot/dts/qcom/pmi8994.dtsi
@@ -49,8 +49,6 @@
 
 		pmi8994_spmi_regulators: regulators {
 			compatible = "qcom,pmi8994-regulators";
-			#address-cells = <1>;
-			#size-cells = <1>;
 		};
 
 		pmi8994_wled: wled@d800 {
-- 
2.39.2



