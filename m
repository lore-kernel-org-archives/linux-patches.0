Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7247183CBF;
	Tue, 30 Jul 2024 16:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355995; cv=none; b=h06hU0UXgzq65dBG7nVdKVW41N3omOMc2ckVfgFEER5hq5k/uAJK/ctaQSotuTWymA/P+mojuqhY4vjfcKY0ad5gzparNF8BHPZNOORH6QT8yJqDjL5Qm0YIoIxE7nsPaVn/H0aTgkmqJDdgStNY12OeDL7EaohqLMQdrBmIQuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355995; c=relaxed/simple;
	bh=uVFNF/blrHjVW/6/wWH/OiCge3kFtfPPOvV+lCBlFVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aD0x97VJFWIvJPvJ2WbF1wPNvzNdvpjwFxywtxXTPZFiAL2A5rFsCe+GwM5GQsgkuyk4KOanOQokTzcv6wMHAknNG3xOO0wx7OLCwxHE3ti7RhOZfk5CQLcnONwUEDIkqBKx4VDtL0/xTMzQdjW69Nz8bEf97PazFqqxm7q3NSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LFp+f+ql; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LFp+f+ql"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31424C32782;
	Tue, 30 Jul 2024 16:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355995;
	bh=uVFNF/blrHjVW/6/wWH/OiCge3kFtfPPOvV+lCBlFVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LFp+f+qlaHgQa/Z+D4zJ6cmtPvhDaeD74+gPZgr8BKam+7jvPbLL7/VZ2o9i2C00E
	 PaXTb2NyVWXyARo+qT4vDF8N9+orH8KVbycdNkJ2tAVFlmg7ay0Zi1fP4ZglpGzPO8
	 3MoHVBLMhz3OH63IBgEaDXtB9v/xkV4lX6f+7iKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 107/809] arm64: dts: mediatek: mt8183-pico6: Fix wake-on-X event node names
Date: Tue, 30 Jul 2024 17:39:43 +0200
Message-ID: <20240730151728.851620896@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 70bf81dd2c2dedbed1f19dfc5d1d2f22474a5296 ]

The wake-on-bt and wake-on-wlan nodes don't have a button- or event-
prefix that the gpio-keys binding requires.

Fix up the node names to satisfy the binding. While at it, also fix up
the GPIO overriding structure for the wake-on-wlan node. Instead of
referencing the gpio-keys node and then open coding the node, add a
label for the event node, and use that to reference and override the
GPIO settings.

Fixes: 055ef10ccdd4 ("arm64: dts: mt8183: Add jacuzzi pico/pico6 board")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20240131084043.3970576-1-wenst@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/mediatek/mt8183-kukui-jacuzzi-pico6.dts      | 8 +++-----
 arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi            | 2 +-
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-pico6.dts b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-pico6.dts
index 6a7ae616512d6..0d5a11c93c681 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-pico6.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-pico6.dts
@@ -17,7 +17,7 @@ bt_wakeup: bt-wakeup {
 		pinctrl-names = "default";
 		pinctrl-0 = <&bt_pins_wakeup>;
 
-		wobt {
+		event-wobt {
 			label = "Wake on BT";
 			gpios = <&pio 42 GPIO_ACTIVE_HIGH>;
 			linux,code = <KEY_WAKEUP>;
@@ -47,10 +47,8 @@ trackpad@2c {
 	};
 };
 
-&wifi_wakeup {
-	wowlan {
-		gpios = <&pio 113 GPIO_ACTIVE_LOW>;
-	};
+&wifi_wakeup_event {
+	gpios = <&pio 113 GPIO_ACTIVE_LOW>;
 };
 
 &wifi_pwrseq {
diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi b/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi
index feb8a5acf2cd6..2fbd226bf142c 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui.dtsi
@@ -152,7 +152,7 @@ wifi_wakeup: wifi-wakeup {
 		pinctrl-names = "default";
 		pinctrl-0 = <&wifi_pins_wakeup>;
 
-		button-wowlan {
+		wifi_wakeup_event: event-wowlan {
 			label = "Wake on WiFi";
 			gpios = <&pio 113 GPIO_ACTIVE_HIGH>;
 			linux,code = <KEY_WAKEUP>;
-- 
2.43.0



