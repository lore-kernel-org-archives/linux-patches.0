Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7671CC8B0;
	Wed, 19 Feb 2025 09:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956449; cv=none; b=Prwg1DknNDUKqroCM2plKkSKFHxpiDg5cwKsEhxOMDoBAvL7jsHUjydtkottteMvsoj7fNW1RoJPueE01Tge2UBlRjyjlC17WF7aUGvfxILuiIkU8GSX1qhTmhBl2en76oByW2JlXk0GzZAa4uwdoka/Z1a2AlmaFNBdJyr/0zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956449; c=relaxed/simple;
	bh=UZuWw8WwgCe6+h3wiLmSx4prvQCN1MCmZgfrWWkpiFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pk5KnEDAlXMTZGk3syKcp6Jc+s1OpSY+UW0VkyNlLBEI5UtcxaHfkMnppRk+0F3rcEHfPG2MyMOty8Y2C94FzV4lLhGifNd53ewV45rJFLNh5vDk+di5CxLKnDpjYWxMJFKUFN8oPKWzbf5RI6Pfmh1VaIXmRJj4SoXmLj6Bh4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iqlC/VLU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iqlC/VLU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DAC4C4CED1;
	Wed, 19 Feb 2025 09:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956448;
	bh=UZuWw8WwgCe6+h3wiLmSx4prvQCN1MCmZgfrWWkpiFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iqlC/VLUbRHdyhAnza0nlxB6M81yLy/OB8zHoXW52IWK9GqS9w2grI4UoQgvgm1oT
	 rReENz02cdqXCqOzvgS+WKvmCDpBiXTOJtYpCqk0Ol+U4eupRGNSr/Sg0bGzn1O4zG
	 TAReUM4ungb9SwnnnBP7pXGp0s5znaYiYKLRyCfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 149/578] arm64: dts: mediatek: mt8183: willow: Support second source touchscreen
Date: Wed, 19 Feb 2025 09:22:33 +0100
Message-ID: <20250219082658.839424820@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hsin-Te Yuan <yuanhsinte@chromium.org>

[ Upstream commit 9594935260d76bffe200bea6cfab6ba0752e70d9 ]

Some willow devices use second source touchscreen.

Fixes: f006bcf1c972 ("arm64: dts: mt8183: Add kukui-jacuzzi-willow board")
Signed-off-by: Hsin-Te Yuan <yuanhsinte@chromium.org>
Link: https://lore.kernel.org/r/20241213-touchscreen-v3-2-7c1f670913f9@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/mediatek/mt8183-kukui-jacuzzi-willow.dtsi | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-willow.dtsi b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-willow.dtsi
index 76d33540166f9..c942e461a177e 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-willow.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-willow.dtsi
@@ -6,6 +6,21 @@
 /dts-v1/;
 #include "mt8183-kukui-jacuzzi.dtsi"
 
+&i2c0 {
+	touchscreen@40 {
+		compatible = "hid-over-i2c";
+		reg = <0x40>;
+
+		pinctrl-names = "default";
+		pinctrl-0 = <&touchscreen_pins>;
+
+		interrupts-extended = <&pio 155 IRQ_TYPE_LEVEL_LOW>;
+
+		post-power-on-delay-ms = <70>;
+		hid-descr-addr = <0x0001>;
+	};
+};
+
 &i2c2 {
 	trackpad@2c {
 		compatible = "hid-over-i2c";
-- 
2.39.5



