Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267B94248DB;
	Sat, 12 Sep 2026 10:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207792; cv=none; b=ai8IV8eMUHFxCJg2jI6X9+eUrMp2SaFXEbuRVTDwJBiRyK6QAnmggjnd5iG+5rNByZUT/sVuKT3hrsuCKuI78L51HNfsnnap++yPWK9FYlTCsCAusFs3n1EtYOkcOqPPmVdlumBZiJDLHy3T7kfypmvHdWXPDjUFQCWkRtDqA8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207792; c=relaxed/simple;
	bh=9G9Qnrza8CodvmjtdqD37VUPsSlyz48MSM+mS352Chs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eWLOkr5MqaO2LFp+GY8oav7deRWcQa6rC+v6B7+ZHXqEYBIwZWZo+3uVtux+bzXtKHKA4QZyOWM05uYeU7K3yKk5IHDVPBNYr9JDpn3ynLaH9VGo1d5onIPtBF0DY6dzEqO4EUUv1VizJRqTHwub5+Vk1QvRupJZ6quTtv2l5II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WfZ2h3nd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WfZ2h3nd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A69BF1F000FF;
	Sat, 12 Sep 2026 10:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207789;
	bh=yrZBNsG7rXPO9fnciSBqPhh07bL9h8BI8zKr3peMEdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WfZ2h3ndE7zkeR0DVNcnavv1h2MGQRZr4xzJSTR4YeOSUQ7O9IPQh+LPY4STjDXpY
	 h/ovQGvRO1oVENOY5+eEhh9bbQUsNI0rmtzVPdBjk2IpKJ2VO9Cfsk9SxOmnRA9uDD
	 SqDakF4Y1a3OZHDcR6uzWlK5+p60WzBYWLcjzufk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0485/1518] arm64: dts: imx8-ss-audio: Fix LPCG clock indices for ASRC0
Date: Sat, 12 Sep 2026 08:44:14 +0200
Message-ID: <20260912065634.420183811@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit 8563591f76ca02c1a6fd70ce986df1d0dde8d249 ]

The LPCG clock indices for ASRC0 and AUD_PLL_DIV0 are swapped. The ASRC0
LPCG provides only IMX_LPCG_CLK_4, so update the ASRC0 clock consumer to
use IMX_LPCG_CLK_4 instead of the non-existent IMX_LPCG_CLK_0.

Likewise, the AUD_PLL_DIV0 LPCG provides only IMX_LPCG_CLK_0, so update its
clock consumer to use IMX_LPCG_CLK_0 instead of the non-existent
IMX_LPCG_CLK_4.

Fixes: 5125617c7a4d3 ("arm64: dts: imx8qxp: add asrc[0,1], esai0, spdif0 and sai[4,5]")
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8-ss-audio.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8-ss-audio.dtsi b/arch/arm64/boot/dts/freescale/imx8-ss-audio.dtsi
index c32a6947ae9c4..5ddb90be54608 100644
--- a/arch/arm64/boot/dts/freescale/imx8-ss-audio.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8-ss-audio.dtsi
@@ -124,10 +124,10 @@ asrc0: asrc@59000000 {
 		compatible = "fsl,imx8qm-asrc";
 		reg = <0x59000000 0x10000>;
 		interrupts = <GIC_SPI 372 IRQ_TYPE_LEVEL_HIGH>;
-		clocks = <&asrc0_lpcg IMX_LPCG_CLK_0>,
-			 <&asrc0_lpcg IMX_LPCG_CLK_0>,
-			 <&aud_pll_div0_lpcg IMX_LPCG_CLK_4>,
-			 <&aud_pll_div1_lpcg IMX_LPCG_CLK_4>,
+		clocks = <&asrc0_lpcg IMX_LPCG_CLK_4>,
+			 <&asrc0_lpcg IMX_LPCG_CLK_4>,
+			 <&aud_pll_div0_lpcg IMX_LPCG_CLK_0>,
+			 <&aud_pll_div1_lpcg IMX_LPCG_CLK_0>,
 			 <&acm IMX_ADMA_ACM_AUD_CLK0_SEL>,
 			 <&acm IMX_ADMA_ACM_AUD_CLK1_SEL>,
 			 <&clk_dummy>,
-- 
2.53.0



