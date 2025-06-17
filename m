Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6068F54;
	Tue, 17 Jun 2025 16:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177665; cv=none; b=gNrFNkzc/G0328aTKV6QlsxuZeVS2NviqZ2i0mEFqZDJn8qgFjWjjHaPAasFJEArIBewMHOeRRAIM90BWDf/tyYZeOpEEKP6AdwDmCetrmeGic2Eyr6xut1kcL1pHKM154VfOy3O/5zV6dGLTeMHG3l6yK/WcITaOpINbmdOo5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177665; c=relaxed/simple;
	bh=/ahxeMgchp0wCLfuLhUiaIo+CJyp/eVUWlnS7RTUiAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mwu+kFVk10x9ojC/NO7Cwsx5aTtvl95xZ3+uirgOiVTXBj3RGUKZb5Vx/0PutRGcrz9pvv3LpamZxRZpUnWi489CSGLzwpvQdAjcA8U16GJDvDxa3O7KrO/WRH348lL2Wpo3RrR7R5X/DXO9uurkFdqkoL0uQUmMqVZL9bzmVN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SDOZuzd3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SDOZuzd3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0591C4CEE3;
	Tue, 17 Jun 2025 16:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177665;
	bh=/ahxeMgchp0wCLfuLhUiaIo+CJyp/eVUWlnS7RTUiAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SDOZuzd3XZmbXYPmlpX7dAeduA1FI48TZIqcp3N7bLvyVZUOx99vmr69Ks9Max5jS
	 p8xI65OG5l4jvh54GLM8hR2wPn8Mi7WPniEXBG4yPlUG3CZF4WDiWqeazpWx5ibUis
	 5LHH1UhCi9s6dhN4c7l5Qt2tFyZzdVrgRgAt+958=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 343/780] arm64: dts: qcom: sa8775p: Partially revert "arm64: dts: qcom: sa8775p: add QCrypto nodes"
Date: Tue, 17 Jun 2025 17:20:51 +0200
Message-ID: <20250617152505.421019994@linuxfoundation.org>
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

[ Upstream commit 92979f12a201c54ea94b8b3c9f0737c33bb45e23 ]

Partially revert commit 7ff3da43ef44 ("arm64: dts: qcom: sa8775p: add
QCrypto nodes") by dropping the untested QCE device node.  Devicetree
bindings test failures were reported on mailing list on 16th of January
and after two weeks still no fixes:

  sa8775p-ride.dtb: crypto@1dfa000: compatible: 'oneOf' conditional failed, one must be fixed:
    ...
    'qcom,sa8775p-qce' is not one of ['qcom,ipq4019-qce', 'qcom,sm8150-qce']

Reported-by: Rob Herring <robh@kernel.org>
Closes: https://lore.kernel.org/all/CAL_JsqJG_w9jyWjVR=QnPuJganG4uj9+9cEXZ__UAiCw2ZYZZA@mail.gmail.com/
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250128115333.95021-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sa8775p.dtsi | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sa8775p.dtsi b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
index 2329460b21038..2010b7988b6cc 100644
--- a/arch/arm64/boot/dts/qcom/sa8775p.dtsi
+++ b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
@@ -2420,17 +2420,6 @@
 				 <&apps_smmu 0x481 0x00>;
 		};
 
-		crypto: crypto@1dfa000 {
-			compatible = "qcom,sa8775p-qce", "qcom,qce";
-			reg = <0x0 0x01dfa000 0x0 0x6000>;
-			dmas = <&cryptobam 4>, <&cryptobam 5>;
-			dma-names = "rx", "tx";
-			iommus = <&apps_smmu 0x480 0x00>,
-				 <&apps_smmu 0x481 0x00>;
-			interconnects = <&aggre2_noc MASTER_CRYPTO_CORE0 0 &mc_virt SLAVE_EBI1 0>;
-			interconnect-names = "memory";
-		};
-
 		stm: stm@4002000 {
 			compatible = "arm,coresight-stm", "arm,primecell";
 			reg = <0x0 0x4002000 0x0 0x1000>,
-- 
2.39.5



