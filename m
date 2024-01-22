Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C2612A17F;
	Tue, 23 Jan 2024 00:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968890; cv=none; b=pHpxegrBz0RgDmTU+2UFN/ZC4qfnWNuTBAmcl2wlVYvVodYkquEZi+AG/Hm1JSipoakvO8CZPr1XcakfoGF79AtM9IuD8QqywEI90accLYecVwtdKE1doNZ1uyDZl9RRixGw69XRZOpAsjhXNi3QC02g7EzqrixSacS6sBNp/v0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968890; c=relaxed/simple;
	bh=aLtnlYhe++hrtV90T0/97I/Vobwd0LgZL0EXgk8LhUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EoJVZeMQCdKoMpGfq8ADUaXzl28pJgpmp7MpaubQKUGprXd3lpdM+H/IwUyzly/RKcYzGR7dbd995/c1wEunqDnML1ITKwm88JMdUv57ebO7QrBUfC3AWgex7zUpD8QgPWE8ThJLqkqX2/Jmmrnc+an3ETwo5SGTpnsIqQ+64FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RsDUNgMw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RsDUNgMw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D2D1C43390;
	Tue, 23 Jan 2024 00:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968890;
	bh=aLtnlYhe++hrtV90T0/97I/Vobwd0LgZL0EXgk8LhUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RsDUNgMwO4Hm26mJYB3lTEtWSC9ucwVQa6AXZTEZbidnepFCpJip+IQh3vdnBLbCM
	 P+MTo1oYgZKjAHBy/GoGdMhh2rxqMoHmAu5WB3ki1ubQ0wQ2r5UJTTIZThqtt4DJL1
	 r3ofdAI2i9LZxPzTYBOvJgtDPWtT2sJb4z3iOCyo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 083/194] ARM: dts: qcom: apq8064: correct XOADC register address
Date: Mon, 22 Jan 2024 15:56:53 -0800
Message-ID: <20240122235722.816060843@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/boot/dts/qcom-apq8064.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/qcom-apq8064.dtsi b/arch/arm/boot/dts/qcom-apq8064.dtsi
index 8c8a576ab9c0..cd200910ccdf 100644
--- a/arch/arm/boot/dts/qcom-apq8064.dtsi
+++ b/arch/arm/boot/dts/qcom-apq8064.dtsi
@@ -759,7 +759,7 @@ pwrkey@1c {
 
 				xoadc: xoadc@197 {
 					compatible = "qcom,pm8921-adc";
-					reg = <197>;
+					reg = <0x197>;
 					interrupts-extended = <&pmicintc 78 IRQ_TYPE_EDGE_RISING>;
 					#address-cells = <2>;
 					#size-cells = <0>;
-- 
2.43.0



