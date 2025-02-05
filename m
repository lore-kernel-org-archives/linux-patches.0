Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE971EED7;
	Wed,  5 Feb 2025 14:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764959; cv=none; b=AM3pHZtY9jdVemwucKU+inaoptIMwn6ZcGLYaeJjoMPBnNDjp63cj2PNJKZ/f2WQFtQc65jbO9iyjOxB8Lb3BVBG+XguFr+RtABfdx6QuSg6KP/8H9i3VcL/ldTKI6JWp0vMc5kQOzwb+iHmyjySpinj20mVUMNMrIIKw30XZiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764959; c=relaxed/simple;
	bh=x71wErcU0Vw2WMOfFsJGmrpJgZlft+Oe1GGVk3eGWgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ez8LLYusU4gdFMj9yQlE9K3oVTuHnyZIRyvp9CgCrrFH2yfVK84c0gFqRDGoY2QguHEnwUcZEnaTmNMo3aSYq8AvOuupe0mjQqxIvgq8EZXm067DcSOMbkFTBvQr8n/jUFg28R+eltpvLFEr+rzTv0sSjTqLXvcI3CMr3iuviVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J6X+38/0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J6X+38/0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C620C4CED1;
	Wed,  5 Feb 2025 14:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764958;
	bh=x71wErcU0Vw2WMOfFsJGmrpJgZlft+Oe1GGVk3eGWgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J6X+38/0IqxpdXN4JOJtni7y7IywqCChH8BkhuSj7SM4Te/2rfEIUWrwiGUww0V7J
	 /oB/ISMlnCRAcSE7rwslBOn94AjzrU1IE0TtAVPNGyQcqRJ2E0xnx5rIy3yTN6Qzyi
	 UIPc6ZY2ZLE0lqLtUOA9a871F3npFHmM7XX/p3WM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 219/393] arm64: dts: mediatek: mt8183: willow: Support second source touchscreen
Date: Wed,  5 Feb 2025 14:42:18 +0100
Message-ID: <20250205134428.682811374@linuxfoundation.org>
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



