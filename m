Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9B713C9C4;
	Wed,  5 Feb 2025 14:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764738; cv=none; b=svjjIj6X+3DuNIFKqv3H4F5fhDqihVY2l4Hv7rmLUUrKtxkemrnI8zOmKiD6qCrvDRq1WQqxRRiufytIzzMAQNZs5SQeBLolBdG8wUgMrbnw8pZFhqZdGLNCbKH3vEDXNhKmApUDl5HiQC1xAYHZQnqEV89QUIG2o6ijSUjsBDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764738; c=relaxed/simple;
	bh=5w8d0bylbo/j/o45WxWaSfF7g0N7vro4RAxg4Q0y2kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N1pIVqs6D1cycu4sccut50/Zw1tUwGX3XVOYbEdbWyL/YvLSki07YrKgJCKW1rpyiOXpMY7Um2YsWF7v/dgnjkOe+MmUlqk+DYCjvTAgN5rxOahW/CCosD6aAp2Fb6unV34IjKNfkBr+fBB8F/o+iqTkNZs2hneXSyuovtUL56I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=exLP04Au; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="exLP04Au"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82B8DC4CED1;
	Wed,  5 Feb 2025 14:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764738;
	bh=5w8d0bylbo/j/o45WxWaSfF7g0N7vro4RAxg4Q0y2kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=exLP04AukgXKvSl+b4dIVPzAlo8u4MsxNEiyl0556nfohYOIJA8TcIr/yBbBb0PyY
	 ilI4Mt5VoSzdBaEPGKh7AgwxwhX+CmsLVc7eoi4OXnzNZUGCB351W1el6Sz24H/biu
	 8IOKkgvOdYGViWlKRA+wevF4Czs6n893+dVfuuHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 200/393] arm64: dts: mediatek: mt8516: add i2c clock-div property
Date: Wed,  5 Feb 2025 14:41:59 +0100
Message-ID: <20250205134427.951095780@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Val Packett <val@packett.cool>

[ Upstream commit eb72341fd92b7af510d236e5a8554d855ed38d3c ]

Move the clock-div property from the pumpkin board dtsi to the SoC's
since it belongs to the SoC itself and is required on other devices.

Fixes: 5236347bde42 ("arm64: dts: mediatek: add dtsi for MT8516")
Signed-off-by: Val Packett <val@packett.cool>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20241204190524.21862-4-val@packett.cool
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8516.dtsi         | 3 +++
 arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi | 2 --
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8516.dtsi b/arch/arm64/boot/dts/mediatek/mt8516.dtsi
index 576be8363ec1c..1ca1393fcc593 100644
--- a/arch/arm64/boot/dts/mediatek/mt8516.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8516.dtsi
@@ -344,6 +344,7 @@
 			reg = <0 0x11009000 0 0x90>,
 			      <0 0x11000180 0 0x80>;
 			interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_LOW>;
+			clock-div = <2>;
 			clocks = <&topckgen CLK_TOP_I2C0>,
 				 <&topckgen CLK_TOP_APDMA>;
 			clock-names = "main", "dma";
@@ -358,6 +359,7 @@
 			reg = <0 0x1100a000 0 0x90>,
 			      <0 0x11000200 0 0x80>;
 			interrupts = <GIC_SPI 81 IRQ_TYPE_LEVEL_LOW>;
+			clock-div = <2>;
 			clocks = <&topckgen CLK_TOP_I2C1>,
 				 <&topckgen CLK_TOP_APDMA>;
 			clock-names = "main", "dma";
@@ -372,6 +374,7 @@
 			reg = <0 0x1100b000 0 0x90>,
 			      <0 0x11000280 0 0x80>;
 			interrupts = <GIC_SPI 82 IRQ_TYPE_LEVEL_LOW>;
+			clock-div = <2>;
 			clocks = <&topckgen CLK_TOP_I2C2>,
 				 <&topckgen CLK_TOP_APDMA>;
 			clock-names = "main", "dma";
diff --git a/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi b/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
index ec8dfb3d1c6d6..a356db5fcc5f3 100644
--- a/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
+++ b/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
@@ -47,7 +47,6 @@
 };
 
 &i2c0 {
-	clock-div = <2>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&i2c0_pins_a>;
 	status = "okay";
@@ -156,7 +155,6 @@
 };
 
 &i2c2 {
-	clock-div = <2>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&i2c2_pins_a>;
 	status = "okay";
-- 
2.39.5



