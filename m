Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1D78F55
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:40:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE94C433C7;
	Sun, 16 Jul 2023 20:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540045;
	bh=OIKGTJaaRAdzVI6pT3FCln6/I1Gcbt32AxXRxcrRIDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wvKiye5AMEFdbS4COeGKXKVPlIDTGUGMm6jK4TDnVoLEQ8brLZWGefMTtWWOO7gNw
	 H+p9GelxhKXURohcD/di3DGb8OVXkip/OEPZUdKNwARBgAXd+RTTfcA/cXuyFcK9jn
	 kQ/MQb6Q49LUYNeSwXcoBwkCRKsn64aoTHAR9A0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 196/591] arm64: dts: qcom: msm8994: correct SPMI unit address
Date: Sun, 16 Jul 2023 21:45:35 +0200
Message-ID: <20230716194928.944398385@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
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

[ Upstream commit 24f0f6a8059c7108d4ee3476c95db1e7ff4feb79 ]

Match unit-address to reg entry to fix dtbs W=1 warnings:

  Warning (simple_bus_reg): /soc/spmi@fc4c0000: simple-bus unit address format error, expected "fc4cf000"

Fixes: b0ad598f8ec0 ("arm64: dts: qcom: msm8994: Add SPMI PMIC arbiter device")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230419211856.79332-8-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8994.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8994.dtsi b/arch/arm64/boot/dts/qcom/msm8994.dtsi
index 7ed59e698c14d..3c6c2cf99fb9d 100644
--- a/arch/arm64/boot/dts/qcom/msm8994.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8994.dtsi
@@ -746,7 +746,7 @@ restart@fc4ab000 {
 			reg = <0xfc4ab000 0x4>;
 		};
 
-		spmi_bus: spmi@fc4c0000 {
+		spmi_bus: spmi@fc4cf000 {
 			compatible = "qcom,spmi-pmic-arb";
 			reg = <0xfc4cf000 0x1000>,
 			      <0xfc4cb000 0x1000>,
-- 
2.39.2



