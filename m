Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3270B79D0;
	Wed,  2 Oct 2024 14:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879408; cv=none; b=oav/KnP4mOy5do6OZkLAYBRwppnVd/HQQ2CJvtHlO7896MCWmsOpsciRc3aDEPb3zDCWSpsH6ZEFK5iwCgydL26EjSXvdMecvoiyZZh35hbNu/uEm1dEvp8YChkQNj2xX1un87t5NB02ZHoUL+qdVmEbxSNa50T69EOck3cFKbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879408; c=relaxed/simple;
	bh=nI2IZdYi+kDTX5LCGlAdeqtwM7dHdLnCnAjqrmyblGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gWEv3G5YprNuT/JIL3uT0dP+dmZo0A2ofBJVj8SRlNU9ShlfevikQvoZ0r/iVCw74paPaMttZN2zz1frS++vwyPSgq8LMprWd6gahapKhMm9Ev/X9zMPCok3x0TgKc1YQ9C37MpSQ/AVO6aooHyBwWhOLIETwUA1c80lKA/Tckg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zA/BGCDx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zA/BGCDx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B62DC4CECD;
	Wed,  2 Oct 2024 14:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879407;
	bh=nI2IZdYi+kDTX5LCGlAdeqtwM7dHdLnCnAjqrmyblGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zA/BGCDxWmZN3X29koftlFmmzThxkKy2PY47TsWyaIG80VdFAbMcxIrK0+Y/rjxAP
	 oZASX6Fh8BZxf+ZtRAUsYp8eH4n12dAsq26Ti5EvmFhmr+VEsC0BPwyw34r0Ls1+Xg
	 DF0RqjKbObNOWjt0acJetyV5ZGEFUf/VktRsPlMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 109/538] arm64: dts: mediatek: mt8195: Correct clock order for dp_intf*
Date: Wed,  2 Oct 2024 14:55:48 +0200
Message-ID: <20241002125756.535287982@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 51bc68debab9e30b50c6352315950f3cfc309b32 ]

The clocks for dp_intf* device nodes are given in the wrong order,
causing the binding validation to fail.

Fixes: 6c2503b5856a ("arm64: dts: mt8195: Add dp-intf nodes")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Link: https://lore.kernel.org/r/20240802070951.1086616-1-wenst@chromium.org
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8195.dtsi | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8195.dtsi b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
index 20e6d90cc4118..d21ba00a5bd5d 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
@@ -2766,10 +2766,10 @@ dp_intf0: dp-intf@1c015000 {
 			compatible = "mediatek,mt8195-dp-intf";
 			reg = <0 0x1c015000 0 0x1000>;
 			interrupts = <GIC_SPI 657 IRQ_TYPE_LEVEL_HIGH 0>;
-			clocks = <&vdosys0  CLK_VDO0_DP_INTF0>,
-				 <&vdosys0 CLK_VDO0_DP_INTF0_DP_INTF>,
+			clocks = <&vdosys0 CLK_VDO0_DP_INTF0_DP_INTF>,
+				 <&vdosys0  CLK_VDO0_DP_INTF0>,
 				 <&apmixedsys CLK_APMIXED_TVDPLL1>;
-			clock-names = "engine", "pixel", "pll";
+			clock-names = "pixel", "engine", "pll";
 			status = "disabled";
 		};
 
@@ -3036,10 +3036,10 @@ dp_intf1: dp-intf@1c113000 {
 			reg = <0 0x1c113000 0 0x1000>;
 			interrupts = <GIC_SPI 513 IRQ_TYPE_LEVEL_HIGH 0>;
 			power-domains = <&spm MT8195_POWER_DOMAIN_VDOSYS1>;
-			clocks = <&vdosys1 CLK_VDO1_DP_INTF0_MM>,
-				 <&vdosys1 CLK_VDO1_DPINTF>,
+			clocks = <&vdosys1 CLK_VDO1_DPINTF>,
+				 <&vdosys1 CLK_VDO1_DP_INTF0_MM>,
 				 <&apmixedsys CLK_APMIXED_TVDPLL2>;
-			clock-names = "engine", "pixel", "pll";
+			clock-names = "pixel", "engine", "pll";
 			status = "disabled";
 		};
 
-- 
2.43.0



