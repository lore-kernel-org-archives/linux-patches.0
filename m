Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D165E14A4C2;
	Tue, 23 Jan 2024 00:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969214; cv=none; b=Jtx4CySbKtTK/HOpkSnWAJajmTMK+RXSrygvx2ahFqytecUH3hXCEDKp9ShgIjcEgt7+CPWT7rhKdUXDrNjj+44MSSHSsYVCKURC1+5iD/JJHhGCTHUhW/4Km73iRCbmN/IaN/FRk8LdlXbp1ce4Xhnk5/jzdDZjPgTFlq/6c9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969214; c=relaxed/simple;
	bh=cVLkGBp3N6FTt0O2iV+LA+UFO5uQrXrUEIbZ28kxqBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Awa96tH/epx9+tesfh9FTby60xaVjf0NWDCGgVC9EBWM0HdQrqLdaRtG392GyfsI8PVLgbRf0BtgnU6K5Ram2JC9MjW/QOgLFcK2GGSLWK7105Qd2gg1NlfUyf1Voy3WXPFM55WKs5kEKo5+cIrnzEwNXWuO4/jPA9y9jikP9ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DdrVbF93; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DdrVbF93"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8806FC433C7;
	Tue, 23 Jan 2024 00:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969214;
	bh=cVLkGBp3N6FTt0O2iV+LA+UFO5uQrXrUEIbZ28kxqBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DdrVbF93WYruv37lTO6Mtj/dumJslr0DEUsJKJq0teGrk7YeM6bS7BfSv0IOF85Se
	 cDWrMypVzP0JGwb8cLz/4EvHWaOKcWViQP3MCbv18uUMiRiJPBKA12W3t/D6dgdbX4
	 3hf1FilDuqAA+MjiSNyDEvZK05+mDhCFuquqIEZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 103/641] ARM: dts: qcom: apq8064: correct XOADC register address
Date: Mon, 22 Jan 2024 15:50:07 -0800
Message-ID: <20240122235821.260539239@linuxfoundation.org>
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

[ Upstream commit 554557542e709e190eff8a598f0cde02647d533a ]

The XOADC is present at the address 0x197 rather than just 197. It
doesn't change a lot (since the driver hardcodes all register
addresses), but the DT should present correct address anyway.

Fixes: c4b70883ee33 ("ARM: dts: add XOADC and IIO HWMON to APQ8064")
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20230928110309.1212221-3-dmitry.baryshkov@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom/qcom-apq8064.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/qcom/qcom-apq8064.dtsi b/arch/arm/boot/dts/qcom/qcom-apq8064.dtsi
index 59fd86b9fb47..099a16c34e1f 100644
--- a/arch/arm/boot/dts/qcom/qcom-apq8064.dtsi
+++ b/arch/arm/boot/dts/qcom/qcom-apq8064.dtsi
@@ -738,7 +738,7 @@ pwrkey@1c {
 
 				xoadc: xoadc@197 {
 					compatible = "qcom,pm8921-adc";
-					reg = <197>;
+					reg = <0x197>;
 					interrupts-extended = <&pmicintc 78 IRQ_TYPE_EDGE_RISING>;
 					#address-cells = <2>;
 					#size-cells = <0>;
-- 
2.43.0



