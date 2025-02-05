Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB801FDE12;
	Wed,  5 Feb 2025 14:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766983; cv=none; b=vD3H154VRqBisYMu5qRhImJpbiY/mLqNX1JdgKqbDjnuozZpk+5C2kEmGDmDXfRjjv74/L7s2OOViYw9W3byUcrJWBFVWjZCRHLANzEEpP1B1GXx9jrTyGStcIa3xZlU+naCbGqIGFJoyuxFmlo+SKIF6t4OCsmt2n3xax/uFJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766983; c=relaxed/simple;
	bh=b0oYSoP/TUPY7Ze0b5XvpSy/KvaUz1Tm/Rqc18ulq4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ARt7s5nd7Ya8JQxRPxQqm2JCkMBAXuZjZiZXnL9fAGgiufG4fOflKOM1WhyeNzxvQnMbIhLgOP/GzOxqYMTSO/hWf0dhrytA+r2dAWMXQX79Yw1TfGbokXgv5o118Iazpxd+CPSzkO9S9IDwAmNsAmhovgeO8V6yHUUmNymPMzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zCN/88Yj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zCN/88Yj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16297C4CEDD;
	Wed,  5 Feb 2025 14:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766983;
	bh=b0oYSoP/TUPY7Ze0b5XvpSy/KvaUz1Tm/Rqc18ulq4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zCN/88Yj7pc5HDYnJxBt8FaDweyggrbotSmZjqqgAZ0vi6yLi33Xsa4vfqzbVPaw7
	 0HwepMQxS54SFB5Kn+V96XUmwbjQ7AmUUGl6o2b+bjyOaeJ7ZCWYaHaC94DUbc9yC7
	 s1SWy/9WBH4XYRTPVv0dDKoDQCIYhkQRjRwbvb0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 337/623] arm64: dts: mediatek: mt8516: add i2c clock-div property
Date: Wed,  5 Feb 2025 14:41:19 +0100
Message-ID: <20250205134509.119402450@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 098c32ebf6788..dd17d8a88c190 100644
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



