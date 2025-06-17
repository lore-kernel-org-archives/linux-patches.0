Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19E5D2F94B2;
	Tue, 17 Jun 2025 16:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177675; cv=none; b=WMucJjsX8h3ANdVOgUhPZeVgSpckD9oeHvSQwwaTL1gsdYBYiFUiOirBSpRr9T6qyjQUIeNh45hxjO3SA5TJewPgjYAtqQAX7AIfFnj/h0Cyk7uCZsXygbMh7EJNF9WBOtOlSHxZvObZKIUWheWF3cxpbEnhOOWVZ+mY87XYubg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177675; c=relaxed/simple;
	bh=JcTJWUsMZ5AlyvopROO0akWxAksp2GbRm1Pi0vO0khA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VkVQ1itQWix1atgqO1ZA/fMk4sUuGDbZD0i1lJn1Gk6sa142Omz1VG8zaTHsrp3LZN64LlU/ME0s81k+rwjawk0SxEkBoWR1efDK69vEIcwbBaVnnUm4yYG25y0c60st+7Oknm4lm+oEHMr86GwPDv5Z2I+5fjNi9vH8pwDQpBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fh4I7zFz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fh4I7zFz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E39BC4CEE3;
	Tue, 17 Jun 2025 16:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177675;
	bh=JcTJWUsMZ5AlyvopROO0akWxAksp2GbRm1Pi0vO0khA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fh4I7zFzn77P3P04egb3r767pk+Qk4k6+PtjgcoPVx4tIwT658oUxZ01HxeM1bUbw
	 igGEUvjBwTXpvWyhCnfopVfJFDZzpPlQcaIy1xninY2P81v6fUicLj2KNlylJ1p3KO
	 KrHZnEJeIVyUbwnCxA9LIHZBKsAdjH3kxM3ik38U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 344/780] arm64: dts: qcom: qcs8300: Partially revert "arm64: dts: qcom: qcs8300: add QCrypto nodes"
Date: Tue, 17 Jun 2025 17:20:52 +0200
Message-ID: <20250617152505.461857349@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit cdc117c40537c5babfa7f261360d5a98e434d59e ]

Partially revert commit a86d84409947 ("arm64: dts: qcom: qcs8300: add
QCrypto nodes") by dropping the untested QCE device node.  Devicetree
bindings test failures were reported on mailing list on 16th of January
and after two weeks still no fixes:

  qcs8300-ride.dtb: crypto@1dfa000: compatible: 'oneOf' conditional failed, one must be fixed:
    ...
    'qcom,qcs8300-qce' is not one of ['qcom,ipq4019-qce', 'qcom,sm8150-qce']

Reported-by: Rob Herring <robh@kernel.org>
Closes: https://lore.kernel.org/all/CAL_JsqL0HzzGXnCD+z4GASeXNsBxrdw8-qyfHj8S+C2ucK6EPQ@mail.gmail.com/
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250128115333.95021-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcs8300.dtsi | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/qcs8300.dtsi b/arch/arm64/boot/dts/qcom/qcs8300.dtsi
index 4a057f7c0d9fa..13b1121cdf175 100644
--- a/arch/arm64/boot/dts/qcom/qcs8300.dtsi
+++ b/arch/arm64/boot/dts/qcom/qcs8300.dtsi
@@ -798,18 +798,6 @@
 				 <&apps_smmu 0x481 0x00>;
 		};
 
-		crypto: crypto@1dfa000 {
-			compatible = "qcom,qcs8300-qce", "qcom,qce";
-			reg = <0x0 0x01dfa000 0x0 0x6000>;
-			dmas = <&cryptobam 4>, <&cryptobam 5>;
-			dma-names = "rx", "tx";
-			iommus = <&apps_smmu 0x480 0x00>,
-				 <&apps_smmu 0x481 0x00>;
-			interconnects = <&aggre2_noc MASTER_CRYPTO_CORE0 QCOM_ICC_TAG_ALWAYS
-					 &mc_virt SLAVE_EBI1 QCOM_ICC_TAG_ALWAYS>;
-			interconnect-names = "memory";
-		};
-
 		ice: crypto@1d88000 {
 			compatible = "qcom,qcs8300-inline-crypto-engine",
 				     "qcom,inline-crypto-engine";
-- 
2.39.5



