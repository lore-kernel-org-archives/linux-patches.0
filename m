Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C13274B39;
	Sat, 12 Sep 2026 16:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232300; cv=none; b=gxgxbeBSbSKHd0Sw8tenhHln/aEpTE/c0Z0+47YNziA6z2qhxxZtPTTtVwJK1tE/qRVYnC0oKL/9mbrCYcRstz29A1HWWcKNCn6vxdObon1xpJ5m+XVFlljbo3SEShbhK7zQKFLEuqxjXHvQ92I6qjRj9YdpxVWDN2bExCWId4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232300; c=relaxed/simple;
	bh=9i6OhKAMNVsm3gEOBDIjF3+emmZCrwBPxZ5BdaIdGkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IrUT8odsvsT94/bCrppt8Ph3uPk+vXKHPpgFoIYPFM5R3aUPzJg6IxAkhEuPzs9ZsWgLSM+xYme68P1OuhwJyRBx0HArj7uF5NczeD4GNWrTTSP10E1lpu52QrThIcRKeLDlQ6PA7LMyVsNxMprwlJLuQM79b+RJRYi8z+3f8zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zkq8ZNj9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zkq8ZNj9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 260621F000FF;
	Sat, 12 Sep 2026 16:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232299;
	bh=c+0OJQYBTUhbgnKhisSe9VtnbG1y/pOLBuF55zDmDpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zkq8ZNj9B+/PQcTBssORmvJ5AxGwDWGadNvZnVpabBOJIKqDTCGSfm0EE5X6hFF74
	 3vl2jWPydZIYtjnOcPy1lIzy1fZxxRuxHyJWQBVwwGkoTDrSDCaQbQGTVFZRjWfMVY
	 k8DwiySYKsZPc4dGlTnfQv8H1YDgXYsZY3HSp+3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1174/1191] arm64: dts: qcom: sm8350: correct PCI phy unit address
Date: Sat, 12 Sep 2026 09:05:02 +0200
Message-ID: <20260912065614.509601117@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit ab98c21bc9246f421a6ae70e69f1b73cea6f85e3 ]

Match unit-address to reg entry to fix dtbs W=1 warnings:

  Warning (simple_bus_reg): /soc@0/phy@1c0f000: simple-bus unit address format error, expected "1c0e000"

Fixes: 6daee40678a0 ("arm64: dts: qcom: sm8350: add PCIe devices")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230419211856.79332-14-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8350.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index 5232c12400b2e..16f9b76e6097a 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -1732,7 +1732,7 @@ pcie1: pci@1c08000 {
 			status = "disabled";
 		};
 
-		pcie1_phy: phy@1c0f000 {
+		pcie1_phy: phy@1c0e000 {
 			compatible = "qcom,sm8350-qmp-gen3x2-pcie-phy";
 			reg = <0 0x01c0e000 0 0x2000>;
 			clocks = <&gcc GCC_PCIE_1_AUX_CLK>,
-- 
2.53.0



