Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A7E3093DB;
	Mon, 13 Oct 2025 15:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369115; cv=none; b=kSTO2ZccruOc0VXLEmLNlY/kArOF0gHtpY0B0iGf0eoQSS02CFU7Ne+G82pyvkb262642XgL1Rz9NLe5juAlFjwmUD8VcINqGnzauqCH556QDmXxKpFLZysxotQdrY2EJ+uPqDlEXPPUE6AU1Mbu8733LZI9GmUCOicP/hTlU1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369115; c=relaxed/simple;
	bh=CMaa7k7W8HsZgUWWohY7SG5YmIwUAsRC2IHZTxpSfWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hfk2KHNmoKaqdGdpewVTnlM+FQMp7nleSo68wMVUWNeQO0Zt4UbNYiHVax4ljCVQ/RxD7KsscF+R/keToUp1btsLdXSBqJ9BcfF8BbWaX5l9+4PsgUZ6ouS1riisodFL2sZiQBAR6Hy1cOvPr80suIwtwi4dGEFfRKeMJty71So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rPVqlYZB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rPVqlYZB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27043C4CEE7;
	Mon, 13 Oct 2025 15:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369115;
	bh=CMaa7k7W8HsZgUWWohY7SG5YmIwUAsRC2IHZTxpSfWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rPVqlYZBZz1q4bPhMWwCQwIxB+AbvFGzm4bzsPsGGLCEqvgsSVIgaA8ArZCdXoQ4r
	 28TgMzwVQS+QHOmCbvOJ3dZaMZt3AJpGXx4KZxmrn7g3i8gkJ7ogP86mOIvAQomjmm
	 xefx0dVtjzgbVT/xVVGWTnrE/lQv/+6Ob6W6zyvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Zhovner <pavel@flipperdevices.com>,
	Alexey Charkov <alchark@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 134/563] arm64: dts: rockchip: Add RTC on rk3576-evb1-v10
Date: Mon, 13 Oct 2025 16:39:55 +0200
Message-ID: <20251013144416.146640698@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Charkov <alchark@gmail.com>

[ Upstream commit 0adaae77862932a19cc14c086d7fd15ec0ef7703 ]

Add the I2C connected RTC chip to the Rockchip RK3576 EVB1 board.

Apart from the realtime clock functionality, it also provides a 32 kHz
clock source for the onboard WiFi chip.

Tested-by: Pavel Zhovner <pavel@flipperdevices.com>
Signed-off-by: Alexey Charkov <alchark@gmail.com>
Link: https://lore.kernel.org/r/20250813-evb1-rtcwifibt-v1-1-d13c83422971@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Stable-dep-of: 843367c7ed19 ("arm64: dts: rockchip: Fix network on rk3576 evb1 board")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/rockchip/rk3576-evb1-v10.dts     | 22 +++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3576-evb1-v10.dts b/arch/arm64/boot/dts/rockchip/rk3576-evb1-v10.dts
index 56527c56830e3..bfefd37a1ab8c 100644
--- a/arch/arm64/boot/dts/rockchip/rk3576-evb1-v10.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3576-evb1-v10.dts
@@ -680,6 +680,22 @@ regulator-state-mem {
 	};
 };
 
+&i2c2 {
+	status = "okay";
+
+	hym8563: rtc@51 {
+		compatible = "haoyu,hym8563";
+		reg = <0x51>;
+		clock-output-names = "hym8563";
+		interrupt-parent = <&gpio0>;
+		interrupts = <RK_PA0 IRQ_TYPE_LEVEL_LOW>;
+		pinctrl-names = "default";
+		pinctrl-0 = <&rtc_int>;
+		wakeup-source;
+		#clock-cells = <0>;
+	};
+};
+
 &mdio0 {
 	rgmii_phy0: phy@1 {
 		compatible = "ethernet-phy-ieee802.3-c22";
@@ -708,6 +724,12 @@ &pcie1 {
 };
 
 &pinctrl {
+	hym8563 {
+		rtc_int: rtc-int {
+			rockchip,pins = <0 RK_PA0 RK_FUNC_GPIO &pcfg_pull_up>;
+		};
+	};
+
 	usb {
 		usb_host_pwren: usb-host-pwren {
 			rockchip,pins = <0 RK_PC7 RK_FUNC_GPIO &pcfg_pull_none>;
-- 
2.51.0



