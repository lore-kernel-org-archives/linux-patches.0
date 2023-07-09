Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA01522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:26:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 971BBC433C7;
	Sun,  9 Jul 2023 11:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902010;
	bh=07fROOjcSQwt5UMd4ikDWn14WtlRF4n+FDzmZiz9xHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SffQKf05zzwJCn/M5OvfOk7gvTFgY03vsg04xsk9zx2Q/WDI3M7vMEy5elsrWT0uj
	 zJbWge7LyG0/vjkR6clP2Sqjt2SJtb2nmCU4hB8c6k7kO4IJTCwBj6mIsEl+Gtlgdy
	 IjDUlvT+Wm3VLDt1p5hVNoPICotoQSltCv4jGzXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 224/431] arm64: dts: qcom: ipq6018: correct qrng unit address
Date: Sun,  9 Jul 2023 13:12:52 +0200
Message-ID: <20230709111456.412745311@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
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

[ Upstream commit 085058786a7890dd44ec623fe5ac74db870f6b93 ]

Match unit-address to reg entry to fix dtbs W=1 warnings:

  Warning (simple_bus_reg): /soc/qrng@e1000: simple-bus unit address format error, expected "e3000"

Fixes: 5bf635621245 ("arm64: dts: ipq6018: Add a few device nodes")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230419211856.79332-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/ipq6018.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/ipq6018.dtsi b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
index 9ff4e9d45065b..8ec9e282b412c 100644
--- a/arch/arm64/boot/dts/qcom/ipq6018.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
@@ -301,7 +301,7 @@ mdio: mdio@90000 {
 			status = "disabled";
 		};
 
-		prng: qrng@e1000 {
+		prng: qrng@e3000 {
 			compatible = "qcom,prng-ee";
 			reg = <0x0 0x000e3000 0x0 0x1000>;
 			clocks = <&gcc GCC_PRNG_AHB_CLK>;
-- 
2.39.2



