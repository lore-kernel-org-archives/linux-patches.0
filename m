Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8B814A4FA;
	Tue, 23 Jan 2024 00:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969234; cv=none; b=cSWdbdwIfq6NJVQVx/lxMqGzsjxeErq2cSbDKO4aAE8UUVXaUXO0SihofAuUlHzwg5daZn9vUqlm40sK8vdyxTWrxx0GsZR79G6CUD+2683m9wZuzF8YzZGDD06WQcj8buVPQnfsWqZa3l/hZOHosPZtqwtf3cQ02OVeZjWMZYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969234; c=relaxed/simple;
	bh=4HbiZDgzg66YElx1ahXSiFWSLl+bxAsWRbPYahlbVaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cHbA5AGc5q1U6bejTRgckMHl2WG+AxQsqqwNaAEYVVEjASn2yEesNE8A+r/Z33JNi7Gg7zqGLHPA78D/C2C1Ky0sNTXc0gUGATpT8AoS/3k3lyFCCFVNEXXBG8PKPzde+JTRNdDiyOBNSmOKSrgSsA/3o5kekbI7Snej+bfd5dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ea+iLLV2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ea+iLLV2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81BBDC433F1;
	Tue, 23 Jan 2024 00:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969234;
	bh=4HbiZDgzg66YElx1ahXSiFWSLl+bxAsWRbPYahlbVaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ea+iLLV2XXt1vhXGDFLDzGLUo5rchL/o7PVAyJ1LHQ6G9WubzVGSP8cYmclIIx4IL
	 3snyBvRoXr/aMqCL31zGB5HDG8Y8rHFKTqOQ2Julb0HoVNA0r6OmRn31tKFSER2c8+
	 fffikKaj3fH6NGNm28owVWnEhbKD5eMEI3avzAyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 117/641] ARM: dts: qcom: sdx65: correct PCIe EP phy-names
Date: Mon, 22 Jan 2024 15:50:21 -0800
Message-ID: <20240122235821.709701542@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 94da379dba88c4cdd562bad21c9ba5656e5ed5df ]

Qualcomm PCIe endpoint bindings expect phy-names to be "pciephy":

  arch/arm/boot/dts/qcom/qcom-sdx65-mtp.dtb: pcie-ep@1c00000: phy-names:0: 'pciephy' was expected

Fixes: 9c0bb38414a4 ("ARM: dts: qcom: sdx65: Add support for PCIe EP")
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20230924183103.49487-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom/qcom-sdx65.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/qcom/qcom-sdx65.dtsi b/arch/arm/boot/dts/qcom/qcom-sdx65.dtsi
index e559adaaeee7..648899b5220f 100644
--- a/arch/arm/boot/dts/qcom/qcom-sdx65.dtsi
+++ b/arch/arm/boot/dts/qcom/qcom-sdx65.dtsi
@@ -338,7 +338,7 @@ pcie_ep: pcie-ep@1c00000 {
 			power-domains = <&gcc PCIE_GDSC>;
 
 			phys = <&pcie_phy>;
-			phy-names = "pcie-phy";
+			phy-names = "pciephy";
 
 			max-link-speed = <3>;
 			num-lanes = <2>;
-- 
2.43.0



