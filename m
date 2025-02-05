Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55001991CF;
	Wed,  5 Feb 2025 14:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767127; cv=none; b=mVgwHI2es+4BqQ3SlMnAcNrSnmm5YASNI8pnWFT4r5/rvx+wklpymqis/JzULYry3Dlmv2N+/V5idThRrcwvUr4MzdMMfQHmL62NW3vwbDWBOOfM5/tCaHyQsobJ540xpKnauwJBYncxMAcq3PebQOXvHLbYMAF/vDBpp2lhS6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767127; c=relaxed/simple;
	bh=gzcRrsfFargmQlRBs+qQyf6yMHDvaeo4HqXDfhO/Q94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FrmyLfgyQzanjOrMHQf5yobYAQTw6U01f73E8PqNdO08Dppr0/+hQvaSXWTHupX8jfnhaelbrXhQqipi6XdHfuZqRLqrq70rDvC1b4eXqR4h5MrFJorMWfhPhgSECaQr0gh7qiYcg8xodweNqZS1AK+8H/1gjaMQteVR4eHSjZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OsZR/Vo7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OsZR/Vo7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54658C4CED1;
	Wed,  5 Feb 2025 14:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767126;
	bh=gzcRrsfFargmQlRBs+qQyf6yMHDvaeo4HqXDfhO/Q94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OsZR/Vo7Vzlu/HntUJWgPNp6nBXhbx51mTVc3ZtRYT3Qlqg+pm5uylal6sOjNBiH3
	 u+i9rxxiGTsTuCYVyXLmthoERtwyZAGqphSQqGtgfTZpxipnYBDHrQ/RLAP7BalYJG
	 5rOEfCgQwKNYzzsK7qFZMBC+47PdG94//keLuHM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 360/623] arm64: dts: mediatek: mt8183: willow: Support second source touchscreen
Date: Wed,  5 Feb 2025 14:41:42 +0100
Message-ID: <20250205134509.995498186@linuxfoundation.org>
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



