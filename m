Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C2C168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:01:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31749C433EF;
	Mon,  8 May 2023 10:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540115;
	bh=slTunrIV0itmFSwfrGZqPZ+4og0Y9fVyYkUxKCeX2KU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N4SSUSaMFAlc1P+3GdFGFp73bGsjNq1fU6WSuyO0FEV8pa5CgzszN1Onp47Bg+k49
	 H0fo9J27GocV4qanhhR/6BIEh03ouqSf01B3XJrDWTYLGNy6ShQ7JG4pB7+qWtK5DW
	 pl4lMWo3Zr+nYg5AnUNMluu8d7lUvEnR5Rggnk/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 213/611] arm64: dts: qcom: apq8096-db820c: drop unit address from PMI8994 regulator
Date: Mon,  8 May 2023 11:40:55 +0200
Message-Id: <20230508094429.323328768@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
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
index 5cdc7ac1a9c06..c7de5e3b071ef 100644
--- a/arch/arm64/boot/dts/qcom/apq8096-db820c.dts
+++ b/arch/arm64/boot/dts/qcom/apq8096-db820c.dts
@@ -742,8 +742,7 @@
 &pmi8994_spmi_regulators {
 	vdd_s2-supply = <&vph_pwr>;
 
-	vdd_gfx: s2@1700 {
-		reg = <0x1700 0x100>;
+	vdd_gfx: s2 {
 		regulator-name = "VDD_GFX";
 		regulator-min-microvolt = <980000>;
 		regulator-max-microvolt = <980000>;
diff --git a/arch/arm64/boot/dts/qcom/pmi8994.dtsi b/arch/arm64/boot/dts/qcom/pmi8994.dtsi
index 542c215dde107..82b60e988d0f5 100644
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



