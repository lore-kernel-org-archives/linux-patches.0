Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3497371D13;
	Wed, 20 May 2026 16:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295767; cv=none; b=mP/NCLA3GLAy9+xda6SsPwRJYxQUvjV5nWiaeqN6Cg86E/PXsOlgyRi2auGYyKmbGPko+4VcCIanDQa64K6ubVdEpitIV+PJIwzMVJfaq9o93uoSs4n9yEgutNTuXdwozlMCx56nwGcVe+e7TMjAY3tmdHKPse5+pJc7OL/iOe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295767; c=relaxed/simple;
	bh=3Bjk92ly3anyzuJOxPiDkSLivCVXJYTsG4MK3lV/Ovg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p6+U6/Xj3hwV4uHy6x2xiSq0XtwlTLINror6anYh0ANdEBxJ8cIaqFLykEIY58izP9Yw1ToCqXsIV+Q//t9IR0xSoop++6Y171uIe8SI9m8EiwGOxSWsu7j1QKhg3HW55AWpdcAYwQ3aHyVYbu8MkR5WVaYLtq15RQ9WLPhDxgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MuAQl5oC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MuAQl5oC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F351F000E9;
	Wed, 20 May 2026 16:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295766;
	bh=qJtjvwPxYnTJrIfdIFZStet3go/YBZdjAABbGRO3QU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MuAQl5oCCneSLZWIxV8p0Sld8qDaXuAiKWRRzDjh1zPuaKXLyLgbjhv0i9RFm3LXo
	 ve+OxtU4BcrD3a2uWulTVMsptuOtbY/A4IFR1ZafzuN5Jr0nHlSArs5M0DjqAg0R61
	 7Fi277jL5KmxGXJYow3D8ZJPncf1eowDYWuAR8Go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josua Mayer <josua@solid-run.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0544/1146] arm64: dts: lx2160a: add sda gpio references for i2c bus recovery
Date: Wed, 20 May 2026 18:13:14 +0200
Message-ID: <20260520162200.491212632@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josua Mayer <josua@solid-run.com>

[ Upstream commit 89ea0dbd701f89805499d26bd90657468c789545 ]

LX2160A pinmux is done in groups by various length bitfields within
configuration registers.

In particular i2c sda/scl pins are always configured together. Therefore
bus recovery may control both sda and scl.

When pinmux nodes and bus recovery was enabled originally for LX2160,
only the scl-gpios were added to the i2c controller nodes.

Add references to sda-gpios for each i2c controller.

Fixes: 8a1365c7bbc1 ("arm64: dts: lx2160a: add pinmux and i2c gpio to support bus recovery")
Signed-off-by: Josua Mayer <josua@solid-run.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
index 28500e8873909..53b9c5f1f1935 100644
--- a/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-lx2160a.dtsi
@@ -753,6 +753,7 @@ i2c0: i2c@2000000 {
 			pinctrl-0 = <&i2c0_pins>;
 			pinctrl-1 = <&gpio0_3_2_pins>;
 			scl-gpios = <&gpio0 3 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
+			sda-gpios = <&gpio0 2 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
 			status = "disabled";
 		};
 
@@ -769,6 +770,7 @@ i2c1: i2c@2010000 {
 			pinctrl-0 = <&i2c1_pins>;
 			pinctrl-1 = <&gpio0_31_30_pins>;
 			scl-gpios = <&gpio0 31 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
+			sda-gpios = <&gpio0 30 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
 			status = "disabled";
 		};
 
@@ -785,6 +787,7 @@ i2c2: i2c@2020000 {
 			pinctrl-0 = <&i2c2_pins>;
 			pinctrl-1 = <&gpio0_29_28_pins>;
 			scl-gpios = <&gpio0 29 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
+			sda-gpios = <&gpio0 28 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
 			status = "disabled";
 		};
 
@@ -801,6 +804,7 @@ i2c3: i2c@2030000 {
 			pinctrl-0 = <&i2c3_pins>;
 			pinctrl-1 = <&gpio0_27_26_pins>;
 			scl-gpios = <&gpio0 27 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
+			sda-gpios = <&gpio0 26 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
 			status = "disabled";
 		};
 
@@ -817,6 +821,7 @@ i2c4: i2c@2040000 {
 			pinctrl-0 = <&i2c4_pins>;
 			pinctrl-1 = <&gpio0_25_24_pins>;
 			scl-gpios = <&gpio0 25 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
+			sda-gpios = <&gpio0 24 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
 			status = "disabled";
 		};
 
@@ -833,6 +838,7 @@ i2c5: i2c@2050000 {
 			pinctrl-0 = <&i2c5_pins>;
 			pinctrl-1 = <&gpio0_23_22_pins>;
 			scl-gpios = <&gpio0 23 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
+			sda-gpios = <&gpio0 22 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
 			status = "disabled";
 		};
 
@@ -849,6 +855,7 @@ i2c6: i2c@2060000 {
 			pinctrl-0 = <&i2c6_i2c7_pins>;
 			pinctrl-1 = <&gpio1_18_15_pins>;
 			scl-gpios = <&gpio1 16 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
+			sda-gpios = <&gpio1 15 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
 			status = "disabled";
 		};
 
@@ -865,6 +872,7 @@ i2c7: i2c@2070000 {
 			pinctrl-0 = <&i2c6_i2c7_pins>;
 			pinctrl-1 = <&gpio1_18_15_pins>;
 			scl-gpios = <&gpio1 18 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
+			sda-gpios = <&gpio1 17 (GPIO_ACTIVE_HIGH | GPIO_OPEN_DRAIN)>;
 			status = "disabled";
 		};
 
-- 
2.53.0



