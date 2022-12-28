Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911DA1C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:44:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09DEAC433D2;
	Wed, 28 Dec 2022 16:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245896;
	bh=vVHfPp7JeYnLvDc3rOscU7ObHnZPNJp8nxJpKisZfSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ivpv0cCy8FE4opmK6g85VmQJ9gi9UM1RSPEXBe8tIEp+s1vtEAy7ValapM+Rj4I8T
	 10szfLjA2qwB79N48JJF7RRr+i0ausSPnqH/3ajyg7ZaD5QMPcvK2r4WirgtK0Vql3
	 GmmiXYrlN6moDWXHp+N6FrYaqPuz+GsECNUjLfwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@somainline.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0943/1146] arm64: dts: qcom: sm8450: disable SDHCI SDR104/SDR50 on all boards
Date: Wed, 28 Dec 2022 15:41:22 +0100
Message-Id: <20221228144355.929923989@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

[ Upstream commit 9d561dc4e5cc31e757f91eb7bb709d2e2a8c9ce0 ]

SDHCI on SM8450 HDK also has problems with SDR104/SDR50:

  mmc0: card never left busy state
  mmc0: error -110 whilst initialising SD card

so I think it is safe to assume this issue affects all SM8450 boards.
Move the quirk disallowing these modes to the SoC DTSI, to spare people
working on other boards the misery of debugging this issue.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221026200357.391635-3-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8450-sony-xperia-nagara-pdx223.dts | 2 --
 arch/arm64/boot/dts/qcom/sm8450.dtsi                          | 3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8450-sony-xperia-nagara-pdx223.dts b/arch/arm64/boot/dts/qcom/sm8450-sony-xperia-nagara-pdx223.dts
index d68765eb6d4f..6351050bc87f 100644
--- a/arch/arm64/boot/dts/qcom/sm8450-sony-xperia-nagara-pdx223.dts
+++ b/arch/arm64/boot/dts/qcom/sm8450-sony-xperia-nagara-pdx223.dts
@@ -556,8 +556,6 @@ &sdhc_2 {
 	pinctrl-1 = <&sdc2_sleep_state &sdc2_card_det_n>;
 	vmmc-supply = <&pm8350c_l9>;
 	vqmmc-supply = <&pm8350c_l6>;
-	/* Forbid SDR104/SDR50 - broken hw! */
-	sdhci-caps-mask = <0x3 0x0>;
 	no-sdio;
 	no-mmc;
 	status = "okay";
diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
index dfc799244180..32a37c878a34 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -3192,6 +3192,9 @@ sdhc_2: sdhci@8804000 {
 			bus-width = <4>;
 			dma-coherent;
 
+			/* Forbid SDR104/SDR50 - broken hw! */
+			sdhci-caps-mask = <0x3 0x0>;
+
 			status = "disabled";
 
 			sdhc2_opp_table: opp-table {
-- 
2.35.1



