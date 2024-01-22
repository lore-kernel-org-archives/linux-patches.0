Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7DC514E2D3;
	Tue, 23 Jan 2024 00:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969361; cv=none; b=N6JmL7gIM9q7SwPwX60ysxVzCFor+dDQHMG/1jznx6F6jSQhqlO4QPSyEkteJYbZ4tMtWZOkqpIX/n4bH8sXOkM7LS6hk69YseYZTFMtYFGFDT/VjP220YLLN9U8sX7Oz3l9UgAhVFWySt+dNEV6SOuq4Ef00Xy/cZASSTJaVoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969361; c=relaxed/simple;
	bh=N6Vv3PxULVIU1BR+Dy+PaF72CdyH6vlm2BIVSf1lpss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KdN9KoL4D6K+17iwdxHYFZVlzkvzNWqm4f8YrMo1uKduKLYqPWB1a+GmLdJhu03OC3/LRnASgxOcpzMBXKUUpZuY0VymB0YAxrpS0xVcGi3OdQNLMUNcLseWUb73J72XyTYuC6W3KL45BgGVyJu2l3oCyG3Py42tM0ot5cOgqx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Au76ZAyT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Au76ZAyT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D55AC433F1;
	Tue, 23 Jan 2024 00:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969361;
	bh=N6Vv3PxULVIU1BR+Dy+PaF72CdyH6vlm2BIVSf1lpss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Au76ZAyTmsVIf3BPoCB183isSJI4/38nmuTSlzOl2y8PnPjcJgD3TG4i4i2tz2+9C
	 m5cK/UeydJAWE6K1Vh/YaUidzpJV0gOhImG0lTKBDDWxUQ7OH1Qa1CmXUQHEbH3Jbx
	 cFdZBF7chI0zNLIWXcLNQdZmka8G1yl8BQXlW1YI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 195/641] arm64: dts: qcom: sm8150: make dispcc cast minimal vote on MMCX
Date: Mon, 22 Jan 2024 15:51:39 -0800
Message-ID: <20240122235824.068498070@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 617de4ce7b1c4b41c1316e493d4717cd2f208def ]

Add required-opps property to the display clock controller. This makes
it cast minimal vote on the MMCX lane and prevents further 'clock stuck'
errors when enabling the display.

Fixes: 2ef3bb17c45c ("arm64: dts: qcom: sm8150: Add DISPCC node")
Acked-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20231215174152.315403-2-dmitry.baryshkov@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8150.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8150.dtsi b/arch/arm64/boot/dts/qcom/sm8150.dtsi
index ad4fab61222b..0e1aa8675879 100644
--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -3932,6 +3932,7 @@ dispcc: clock-controller@af00000 {
 				      "dp_phy_pll_link_clk",
 				      "dp_phy_pll_vco_div_clk";
 			power-domains = <&rpmhpd SM8150_MMCX>;
+			required-opps = <&rpmhpd_opp_low_svs>;
 			#clock-cells = <1>;
 			#reset-cells = <1>;
 			#power-domain-cells = <1>;
-- 
2.43.0



