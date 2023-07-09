Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6D6522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:27:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E106C433C8;
	Sun,  9 Jul 2023 11:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902055;
	bh=NzPkTGL8kaTUB5MrgAHUikqkINDmYY799H7QL2TmWK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GP+kyHMbaDqIPoIqX6H6TVdEgP1y+o0fXooAs/zt4zNa3529vQ7IG+isUo4FDZNin
	 yHcC9bXW4z5Sy+C3S2Gu2UPT/zHm2hPRiHif80pQDv0Hr/WB8wsZFotzWgMI2JbzhE
	 dMImsvTD9g0TUXhnzwMnNmg7Hw6QwkUI0hyRRPtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 239/431] arm64: dts: qcom: sm8550: correct crypto unit address
Date: Sun,  9 Jul 2023 13:13:07 +0200
Message-ID: <20230709111456.762969574@linuxfoundation.org>
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

[ Upstream commit 3cbf49ef16962ab6d99a3659cb34a33c5f147b50 ]

Match unit-address to reg entry to fix dtbs W=1 warnings:

  Warning (simple_bus_reg): /soc@0/crypto@1de0000: simple-bus unit address format error, expected "1dfa000"

Fixes: 433477c3bf0b ("arm64: dts: qcom: sm8550: add QCrypto nodes")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230419211856.79332-16-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index b451e94f2b4c0..3af9da58f65c6 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -1843,7 +1843,7 @@ cryptobam: dma-controller@1dc4000 {
 				 <&apps_smmu 0x481 0x0>;
 		};
 
-		crypto: crypto@1de0000 {
+		crypto: crypto@1dfa000 {
 			compatible = "qcom,sm8550-qce", "qcom,sm8150-qce", "qcom,qce";
 			reg = <0x0 0x01dfa000 0x0 0x6000>;
 			dmas = <&cryptobam 4>, <&cryptobam 5>;
-- 
2.39.2



