Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A36B25DB0A;
	Tue, 11 Mar 2025 15:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706491; cv=none; b=qCERcFd/O2MFyoclnkiPfXU+WgYyAsSGpT6XIaz56P29DvXqnNqBFvnJ2juhZOtDcmcsYoK1jLBS3j0mCkpaqLkq6IKPbZc8RPqAzlOhqTiD7cG1/08NokgZynzdXzhVRTmXKs2bbhwei/MTyFXpI49TQ3LcH1oQMsBTrn8czI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706491; c=relaxed/simple;
	bh=L7N60+TTzLDwExwPwBMtQ/vCZKJ6zzGQsH0aoKJSiOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OXDxXCa1g9cApiv2XK122p1wvnt01+04c/Dqbru0HnNai1BAPB1hoTPOlt21FsSykW8FUtanXEIpyK1RjxMJh9Szanw7n1stPMmUenhUV4YhPPoT1V9NpOqXIZRezAsJ65RhIXGnkH24OgtE+iuugc7ilPNX0d1bH32Ei0UqnMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EtjoW4UJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EtjoW4UJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D98C0C4CEE9;
	Tue, 11 Mar 2025 15:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706491;
	bh=L7N60+TTzLDwExwPwBMtQ/vCZKJ6zzGQsH0aoKJSiOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EtjoW4UJdbdi+6Dx3YYDcQ3dWSerrIYVn97ywXWYzDmO0uX7MZzPo0UkTkV/XUw2d
	 Ru5I2TOlgQ5kfxG/V6L7SYiZtgBL5x4B7TScIqjTO29NSpWBJLiIP98nNUxL1K7i3W
	 UWwnfc0Ox4riB+O4FwBJhjqGr4aMhERZqCQMs8fQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 066/462] arm64: dts: mediatek: mt8516: add i2c clock-div property
Date: Tue, 11 Mar 2025 15:55:32 +0100
Message-ID: <20250311145800.958759901@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5163dda398d56..383ae46891ec2 100644
--- a/arch/arm64/boot/dts/mediatek/mt8516.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8516.dtsi
@@ -308,6 +308,7 @@
 			reg = <0 0x11009000 0 0x90>,
 			      <0 0x11000180 0 0x80>;
 			interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_LOW>;
+			clock-div = <2>;
 			clocks = <&topckgen CLK_TOP_I2C0>,
 				 <&topckgen CLK_TOP_APDMA>;
 			clock-names = "main", "dma";
@@ -322,6 +323,7 @@
 			reg = <0 0x1100a000 0 0x90>,
 			      <0 0x11000200 0 0x80>;
 			interrupts = <GIC_SPI 81 IRQ_TYPE_LEVEL_LOW>;
+			clock-div = <2>;
 			clocks = <&topckgen CLK_TOP_I2C1>,
 				 <&topckgen CLK_TOP_APDMA>;
 			clock-names = "main", "dma";
@@ -336,6 +338,7 @@
 			reg = <0 0x1100b000 0 0x90>,
 			      <0 0x11000280 0 0x80>;
 			interrupts = <GIC_SPI 82 IRQ_TYPE_LEVEL_LOW>;
+			clock-div = <2>;
 			clocks = <&topckgen CLK_TOP_I2C2>,
 				 <&topckgen CLK_TOP_APDMA>;
 			clock-names = "main", "dma";
diff --git a/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi b/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
index d5059735c5940..e5e3a3969145b 100644
--- a/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
+++ b/arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi
@@ -48,7 +48,6 @@
 };
 
 &i2c0 {
-	clock-div = <2>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&i2c0_pins_a>;
 	status = "okay";
@@ -157,7 +156,6 @@
 };
 
 &i2c2 {
-	clock-div = <2>;
 	pinctrl-names = "default";
 	pinctrl-0 = <&i2c2_pins_a>;
 	status = "okay";
-- 
2.39.5



