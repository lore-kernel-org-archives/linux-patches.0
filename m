Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17852366052;
	Sat, 12 Sep 2026 12:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216035; cv=none; b=QKqrXcv14Q597Sa3XIO14k3aA/wh7NFzJ3L8u4ONP9kkVhRrgobxn4EZVK+ZtBmC+dgbdDXPJ6SeFkNEq7frWyA2ILSNsJIkOSdj5hUJhvgJR0gyTcGShCnwAYGm/D51Vgm1i/I6Vg2mvJ8RmXeClBTpxyKFlqMAxkD/Qef4fhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216035; c=relaxed/simple;
	bh=5fSerMzM4l2xEEv45x7mqIcOSBHQKc2TwB3iawkxU8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P7uKwBzPYrQz83XzAyOh+0xWwGMqK6Hv5ZE6M0mT5waMM2GaApOGO2yuiLnYNlMEHFzOZINeCjzUZHkiwUlquO/mlGghZXjGIRro/NdJdgzfPV41/wcc6pOEm22JTw+xbbhy8UH3QXZF2j1jI6xNYGf6m24BVk7JiEG3+LAzHlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c+vdWHAT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c+vdWHAT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C0F1F000FF;
	Sat, 12 Sep 2026 12:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216034;
	bh=99iVOhWFkMAd0HrpyA/ZIeufIGW2Er1h3DxqlTxijE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c+vdWHATIbrOV257M1R0qzGT6Glnhu8vSVuK1/kqgoyadMxaf6NIHB/xVBoHqYl40
	 VVyFcXz6d+uxpok0B568d1PEU5b1bPCaUv/XKlhweLj6q2iN3D3+eSdsyygXslvjmn
	 UBYjYsNGxpmpz3OXVi0DtcZrnCh4VUNmHCJIVFxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0611/1376] arm64: dts: imx8-ss-audio: Fix LPCG clock indices for ASRC0
Date: Sat, 12 Sep 2026 08:50:37 +0200
Message-ID: <20260912065621.158978496@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ff5df0fed9e96..741a311614ddb 100644
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



