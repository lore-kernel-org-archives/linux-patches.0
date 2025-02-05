Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833F21519AA;
	Wed,  5 Feb 2025 14:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764703; cv=none; b=CW9Aoba4r7dN+Ce9F1J0HsVYiCf2JBJlEfHA3veI0x6theXjjV2XrJs1Oqv86eAzl/fFd1cSutrwi4Xc4w7vuvPfB+ECi6laWYnrgm6C2ZyCdq3Zqdq9SxWz0czGDFeVyf0znRFEVB8W6/4kCnVG3Tt/fDeszT2GrWlsUZLxYic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764703; c=relaxed/simple;
	bh=uNq1XKsjfjF2fj4UUR4zg/HD7/ZLAJo4nbyvpe/kqLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hkjyt4Ce8OHovtklQbeWpwKiLk7jRge4BE48EenT4WsgkTZbUnImrOQsVaczKgwgKu8ioLwqZCdPRR5LNsQ30HxY8N/RwpNoYxu+pSoBFaYZ4MDuwYCPbPLu4G0oJDQhgK/PHOgrjosoTHJM2+3coNuPohi1gulT8v8BNYVPQoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uikNXRD7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uikNXRD7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1AA8C4CEDD;
	Wed,  5 Feb 2025 14:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764703;
	bh=uNq1XKsjfjF2fj4UUR4zg/HD7/ZLAJo4nbyvpe/kqLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uikNXRD7FChCqTS0PlVSCQEa0QHeZNJZRJLb38DrQ6SnEDJuCfFK8Fv2Oe1Q8gmc5
	 nRHbJ5aoTM8ML5yQIZWHq71Uuq6JakW4V0PcHAqZoDdhIK88t1dbIabpageP+Qg3Re
	 VJDGtL64FJqognyTqDAF8KtXnuVsu8izO7ytSIb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 126/590] arm64: dts: imx93: Use IMX93_CLK_SPDIF_IPG as SPDIF IPG clock
Date: Wed,  5 Feb 2025 14:38:01 +0100
Message-ID: <20250205134500.081433739@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 570b890e66334f283710af36feb2115f16c7a27c ]

IMX93_CLK_BUS_WAKEUP is not accurate IPG clock, which
missed the clock gate part.

IMX93_CLK_SPDIF_IPG is the correct clock.

Fixes: 1c4a4f7362fd ("arm64: dts: imx93: Add audio device nodes")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Acked-by: Shawn Guo <shawnguo@kernel.org>
Link: https://lore.kernel.org/r/20241119015805.3840606-4-shengjiu.wang@nxp.com
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx93.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx93.dtsi b/arch/arm64/boot/dts/freescale/imx93.dtsi
index 04b9b3d31f4fa..7bc3852c6ef8f 100644
--- a/arch/arm64/boot/dts/freescale/imx93.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx93.dtsi
@@ -917,7 +917,7 @@
 				reg-names = "ram", "regs", "rxfifo", "txfifo";
 				interrupts = <GIC_SPI 203 IRQ_TYPE_LEVEL_HIGH>,
 					     <GIC_SPI 204 IRQ_TYPE_LEVEL_HIGH>;
-				clocks = <&clk IMX93_CLK_BUS_WAKEUP>,
+				clocks = <&clk IMX93_CLK_SPDIF_IPG>,
 					 <&clk IMX93_CLK_SPDIF_GATE>,
 					 <&clk IMX93_CLK_DUMMY>,
 					 <&clk IMX93_CLK_AUD_XCVR_GATE>;
-- 
2.39.5



