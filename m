Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA5A2BD12;
	Fri,  5 Jan 2024 14:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V09oyIPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4C2C433C7;
	Fri,  5 Jan 2024 14:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704465692;
	bh=hYRaxn92Edn7/vAZqj421DXEwIwwzRb5SiFyQdAD6ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V09oyIPEq8FH6JUS5mIveWP4dIySOoXp8gdAFe/v+fNJTKHxajf1/4jMYnR39jPWn
	 rYqj26fy1nDwx9mRDh5XdKfk9we3uPH8I3OzPXYDfkOz91EUWxy6fyAgC8XXHEPzGH
	 mAF3oogX8V8xKqXm256OdhqkktYgm31kZ0xpkQaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 01/41] arm64: dts: mediatek: mt8173-evb: Fix regulator-fixed node names
Date: Fri,  5 Jan 2024 15:38:41 +0100
Message-ID: <20240105143814.005195815@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240105143813.957669139@linuxfoundation.org>
References: <20240105143813.957669139@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 24165c5dad7ba7c7624d05575a5e0cc851396c71 ]

Fix a unit_address_vs_reg warning for the USB VBUS fixed regulators
by renaming the regulator nodes from regulator@{0,1} to regulator-usb-p0
and regulator-usb-p1.

Cc: stable@vger.kernel.org
Fixes: c0891284a74a ("arm64: dts: mediatek: add USB3 DRD driver")
Link: https://lore.kernel.org/r/20231025093816.44327-8-angelogioacchino.delregno@collabora.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8173-evb.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8173-evb.dts b/arch/arm64/boot/dts/mediatek/mt8173-evb.dts
index 8e6ada20e6dbf..242a9e8dc0a9f 100644
--- a/arch/arm64/boot/dts/mediatek/mt8173-evb.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8173-evb.dts
@@ -51,7 +51,7 @@ extcon_usb: extcon_iddig {
 		id-gpio = <&pio 16 GPIO_ACTIVE_HIGH>;
 	};
 
-	usb_p1_vbus: regulator@0 {
+	usb_p1_vbus: regulator-usb-p1 {
 		compatible = "regulator-fixed";
 		regulator-name = "usb_vbus";
 		regulator-min-microvolt = <5000000>;
@@ -60,7 +60,7 @@ usb_p1_vbus: regulator@0 {
 		enable-active-high;
 	};
 
-	usb_p0_vbus: regulator@1 {
+	usb_p0_vbus: regulator-usb-p0 {
 		compatible = "regulator-fixed";
 		regulator-name = "vbus";
 		regulator-min-microvolt = <5000000>;
-- 
2.43.0



