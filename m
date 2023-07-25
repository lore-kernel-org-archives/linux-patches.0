Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E8C1D301
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:17:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 782CEC433C9;
	Tue, 25 Jul 2023 11:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283860;
	bh=V+/5q8Dck38EU8gZteKH3IgFoOMfy70Kbdu4MfCgY/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DDOPobBvQJ9zFNJdag7faww2UaQ/VTgXvnDKq8715THIO7Z6flevaWxoVMRsAl742
	 B9d3jT262dPFndNo6/O4IezyUSWD8JLK/i2NkrW1NdVZbyCFCqAMw3Cc0D6mYtJ75k
	 sCFEb9dDF6OTUSgiTKjEmuy7UifJhNZTC4YLogPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 121/509] arm64: dts: qcom: msm8994: correct SPMI unit address
Date: Tue, 25 Jul 2023 12:41:00 +0200
Message-ID: <20230725104559.217691765@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
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
index aeb5762566e91..caaf7102f5798 100644
--- a/arch/arm64/boot/dts/qcom/msm8994.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8994.dtsi
@@ -489,7 +489,7 @@ restart@fc4ab000 {
 			reg = <0xfc4ab000 0x4>;
 		};
 
-		spmi_bus: spmi@fc4c0000 {
+		spmi_bus: spmi@fc4cf000 {
 			compatible = "qcom,spmi-pmic-arb";
 			reg = <0xfc4cf000 0x1000>,
 			      <0xfc4cb000 0x1000>,
-- 
2.39.2



