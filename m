Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A963627F3;
	Tue, 23 Jan 2024 00:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971218; cv=none; b=fz8Rsr37vIftln69zmqsCkOtKqRQMtx07ECPIENCrx1jFXC4iUa3I+FF+mxVey0H/xcI7nX5z4DyMY5mc0aoeYnuHmQswak51JlwNzW8payWW83ksT/oijpf9ZqHmoH8NGhz+T+vsg2DDqLoymEUgL8gOImuyCGKf5RB4h5z7bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971218; c=relaxed/simple;
	bh=woIiynb7kt+ylFZJ2NxalwJmBdy5ldkl0LgcN5pEH2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nxkBVcOW5O0ytb61FoY9vcAjCw/Zsqow5RQg2Fhg3Gp6iYxQZViz/T+Nyj3fl4ZQl6zibXqA+h0xo+NOHeoLzQcBrf/rBtEY9LJiuPlXHcAIZL+ubnIZD53KipcTCS+af6qRoHnW8+Wr+eKjxuUBm7x1rwgr+Nsd7VrUTEcerIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uR7T2z5B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uR7T2z5B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24E4BC433F1;
	Tue, 23 Jan 2024 00:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971218;
	bh=woIiynb7kt+ylFZJ2NxalwJmBdy5ldkl0LgcN5pEH2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uR7T2z5BIRgOaDxFXr7EHmJmaPYD4pYH9XgpHhX0C2y4bcXhSoQR+d4a53raKrJNj
	 MkBARdwr74cbUNDV/0elPPAyXVMt9wGAiPjriEwsYgZ7KYN1L8Gtsar8aohZtEVjCC
	 QI34b0eC8WM6ntvb1/oPOLgc/VqDCNR5J2WXwGCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 113/286] ARM: dts: qcom: apq8064: correct XOADC register address
Date: Mon, 22 Jan 2024 15:56:59 -0800
Message-ID: <20240122235736.455929406@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index fb25ede1ce9f..3f1002c34446 100644
--- a/arch/arm/boot/dts/qcom-apq8064.dtsi
+++ b/arch/arm/boot/dts/qcom-apq8064.dtsi
@@ -760,7 +760,7 @@ pwrkey@1c {
 
 				xoadc: xoadc@197 {
 					compatible = "qcom,pm8921-adc";
-					reg = <197>;
+					reg = <0x197>;
 					interrupts-extended = <&pmicintc 78 IRQ_TYPE_EDGE_RISING>;
 					#address-cells = <2>;
 					#size-cells = <0>;
-- 
2.43.0



