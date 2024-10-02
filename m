Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CAF1D04A2;
	Wed,  2 Oct 2024 13:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875698; cv=none; b=V+9Gnq19New/8uJvo9YiWl7MUqVgP+WccoSH+RrArEYpEj+7gjiPhCcVgnZixSTQlPIwR1VkDFIiJ0Nox21p6Ve89bR9Juz8CWviDe2ZxbpRxK4YpZxrDwnSZQyCII+BGUctmI8p7PPa564gvsmEYc1DJ9dCzMilYOYgNcUikVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875698; c=relaxed/simple;
	bh=RDCG5fdno0ybqxi3W8UFFTQRtz3xktuDIGnayGSKaxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DfjMN4M5BD8pzK4b/vNzlt+z5ES40L7/jWr03R/d2r6uIw7kC02Yl6dN/CV9/YcRmLc3rmsiZTQY4HNSHhbRJ5IleYc/1piTMUhNaW3E83GxcchxTJi3EPtjlAGO9WoxD+oDxPAY09i6UT1AWtI3yx/JL4h2l7MRNHUVi2X1FMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JHT/Clao; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JHT/Clao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F139C4CEC5;
	Wed,  2 Oct 2024 13:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875698;
	bh=RDCG5fdno0ybqxi3W8UFFTQRtz3xktuDIGnayGSKaxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JHT/ClaofF8iHCeb0yb8gtq2OK2L+rp+gEIzML/MHQY3tBO4ckfg4Q9eQ/sYf3ahv
	 tmPp1w8HRddBn+dgAsyySuzTDjxr0TYwA3nT8//TPkAwPQl6Lg9PiqnQybac23hFCi
	 y0rJ9Dhfyp/W0nPhOQ+18fJ3G0xsmiSgCzZq/FBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 159/695] arm64: dts: mediatek: mt8195: Correct clock order for dp_intf*
Date: Wed,  2 Oct 2024 14:52:37 +0200
Message-ID: <20241002125828.823812996@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 2ee45752583c0..98c15eb68589a 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
@@ -3251,10 +3251,10 @@
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
 
@@ -3521,10 +3521,10 @@
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



