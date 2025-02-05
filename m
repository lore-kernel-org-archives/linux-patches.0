Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 827B918A6D7;
	Wed,  5 Feb 2025 14:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766783; cv=none; b=kEOlZwHfSDnN7IOIbYJ8ekXLMtkkB9wZfkckvss7rVGfG8AJJ5rEecgJLaydJJGH0wiGAl0ZJP7Rdq2Rlst6mPRxnOdohheaWZJY/xa0ve2Y2Ob1GrYdEy6is3RyXEh2AARdodADHlxp2pBbd1p2/BTQwaIttwUlQ1dWeaFOLlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766783; c=relaxed/simple;
	bh=7icxgtN24rbhf71XwFKbN6wf3Llszi8cd09ivr2+hig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J4MwqdoegycHnbhvlB+x0pJxyuCbXH/8+XGDDLouiRNA3I8m5pDXjM6kJyqon2xA/AFT7Ej1l3iC9bbWVRN7tSFOqIu+a35aGrZzg1jL2G0RjLenZ5wQ0oHDg52/G3QdOqukxzwVc6kALrMrZLRo8EoJppqgPkQodCf6x6eCLpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XxSCI7kJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XxSCI7kJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC30CC4CED6;
	Wed,  5 Feb 2025 14:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766783;
	bh=7icxgtN24rbhf71XwFKbN6wf3Llszi8cd09ivr2+hig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XxSCI7kJ+Rfq8u87S0qJU+66MXb58PIr016gTz8FjXqCFv6YhCyNrbwSDtifWoEbU
	 q3rZuG/BNB/Tc6lDtIew0f1ZQ2l+IIn/WeaSjWx1g68ZRmo8N5k+4spJC/gozBWlPn
	 1Ir9scFXifOM4DAfimXHhAMP4k1lofbBOKGBzzgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 360/590] arm64: dts: qcom: sm8650: Fix CDSP context banks unit addresses
Date: Wed,  5 Feb 2025 14:41:55 +0100
Message-ID: <20250205134509.043994336@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit ff2b76ae689b71e2d7a2e70bfd8d71537c39164d ]

There is a mismatch between 'reg' property and unit address for last
there CDSP compute context banks.  Current values were taken as-is from
downstream source.  Considering that 'reg' is used by Linux driver as
SID of context bank and that least significant bytes of IOMMU value
match the 'reg', assume the unit-address is wrong and needs fixing.
This also won't have any practical impact, except adhering to Devicetree
spec.

Fixes: dae8cdb0a9e1 ("arm64: dts: qcom: sm8650: Add three missing fastrpc-compute-cb nodes")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20241104144204.114279-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8650.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8650.dtsi b/arch/arm64/boot/dts/qcom/sm8650.dtsi
index 01ac3769ffa62..cd54fd723ce40 100644
--- a/arch/arm64/boot/dts/qcom/sm8650.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8650.dtsi
@@ -5624,7 +5624,7 @@
 
 					/* note: secure cb9 in downstream */
 
-					compute-cb@10 {
+					compute-cb@12 {
 						compatible = "qcom,fastrpc-compute-cb";
 						reg = <12>;
 
@@ -5634,7 +5634,7 @@
 						dma-coherent;
 					};
 
-					compute-cb@11 {
+					compute-cb@13 {
 						compatible = "qcom,fastrpc-compute-cb";
 						reg = <13>;
 
@@ -5644,7 +5644,7 @@
 						dma-coherent;
 					};
 
-					compute-cb@12 {
+					compute-cb@14 {
 						compatible = "qcom,fastrpc-compute-cb";
 						reg = <14>;
 
-- 
2.39.5



