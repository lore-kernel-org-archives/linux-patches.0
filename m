Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A684730F7E8;
	Sat, 12 Sep 2026 07:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199283; cv=none; b=L86gaAAHdeOGojfJobnxlRxLMhQqs9C6RKRpGYtOmVaZ0QCfGiOl2mZplOsZHIjvrQYGajRiPamjp3z3q/8vH6RqyIIyhlpCvR70BIV+4bDz7mcAVLyA4tXx4doxJ2h/T2iTmKIuZrvOhi9mwAXi2ktLJLZdWkOcRlYL7lsiWNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199283; c=relaxed/simple;
	bh=jRxNytXsPpgYVkrRch+YNyqMrJMoXocM3hP3nCt4fzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JkCfIV+WqQGg9GosWZB9dWWMxYQOFiE1liSJpdNHg++LdJPdiRWchIDmM3n5lVbXbRp79V/zT9smCQ3zCLMp1lralzet0FIKD81RyTNo8GRS7UCPJw0veKscJ+Wi5mksxKlNiPlmHcGFfbzzN9fAelMmr7IPYJvhMst52I07daU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q5vQg1qo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q5vQg1qo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2641F000FF;
	Sat, 12 Sep 2026 07:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199282;
	bh=Xf9WxFYw424llDThioEbcQUm8Alwa7F6bjNtMwOGnhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q5vQg1qoXFssegRbVSkU+5D1iFFJI0r/Xx7kc5p2ZyE11SYvScazSo7qoIPeiUl2V
	 II/a5NUAK+xbwRcWg21hzBVpx0DBZTrnw6p3X8RcMnHLJmYzf3TQZYxwr474DbtcDr
	 2jQkPH84V1JSscUdXjr0n4CjR+U18jKgnuwoYReE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0546/1815] arm64: dts: imx8-ss-audio: Fix LPCG clock indices for ASRC0
Date: Sat, 12 Sep 2026 08:38:16 +0200
Message-ID: <20260912065701.701534685@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 5e4233ccfde46..f473d81f67ffa 100644
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



