Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD21355802;
	Tue, 16 Dec 2025 12:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887194; cv=none; b=JTn2m8y59Vg6Eygy7w9DEEbkLjKezQ3FkkNDf8HjdEREcTCLGpzyhy+0NxAs11liCu1e6bI9mmjgiE3CXZbsLVeUR0QuSokubA1G5a5e6At4IMW2rxYc/DkTbIfb+PbEzXQ+uq8vFMM44RrcEOqGOiSZAL9PUuQS7MSA202x6A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887194; c=relaxed/simple;
	bh=zPH8ptpFMuDYG9Fo6aXeooUaLJY8ertEdDTNDuDAZu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ciig8rUNrQcHYpvHXqlHSPd+hx/jAiWctgt/OfQVuuAuUZmnVPgu4tHWhm9sDMMrjaT4HfM1RQ0QITKXY6hyxZHPHqahaVPc409Qev+R9VSiYd58iSWL744ynvxbFU282i5C93Qzoli5td13ZNm9Vp6mDJU8l0Dw0+/GrJ2WWnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x4v/fiIK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x4v/fiIK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43ABAC4CEF1;
	Tue, 16 Dec 2025 12:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887194;
	bh=zPH8ptpFMuDYG9Fo6aXeooUaLJY8ertEdDTNDuDAZu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x4v/fiIKgI4Wh1D0ZDUiYjzD0JWzicgkAM6D6i6SRZvitemquoU64aEH5IwFyQfbZ
	 +AXZISWQx+a1I2r19q3gSez6dXqVS67WkhZY2/0aWDf+m1PiIXSVgL6R1U/6uOkzix
	 9Ag4u3Z9Ywk25oodJJqKY2AKZvh6A+rGctEtjV30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aniket Limaye <a-limaye@ti.com>,
	Udit Kumar <u-kumar1@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 155/614] arm64: dts: ti: k3-j784s4: Fix I2C pinmux pull configuration
Date: Tue, 16 Dec 2025 12:08:42 +0100
Message-ID: <20251216111406.951329182@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aniket Limaye <a-limaye@ti.com>

[ Upstream commit 671c852fc53d1b6f5eccdb03c1889a484c9d1996 ]

The I2C pins for some of the instances on J784S4/J742S2/AM69 are
configured as PIN_INPUT_PULLUP while these pins are open-drain type and
do not support internal pull-ups [0][1][2]. The pullup configuration
bits in the corresponding padconfig registers are reserved and any
writes to them have no effect and readback checks on those bits fail.

Update the pinmux settings to use PIN_INPUT instead of PIN_INPUT_PULLUP
to reflect the correct hardware behaviour.

[0]: https://www.ti.com/lit/gpn/tda4ah-q1 (J784S4 Datasheet: Table 5-1. Pin Attributes)
[1]: https://www.ti.com/lit/gpn/tda4ape-q1 (J742S2 Datasheet: Table 5-1. Pin Attributes)
[2]: https://www.ti.com/lit/gpn/am69a (AM69 Datasheet: Table 5-1. Pin Attributes)

Fixes: e20a06aca5c9 ("arm64: dts: ti: Add support for J784S4 EVM board")
Fixes: 635fb18ba008 ("arch: arm64: dts: Add support for AM69 Starter Kit")
Fixes: 0ec1a48d99dd ("arm64: dts: ti: k3-am69-sk: Add pinmux for RPi Header")
Signed-off-by: Aniket Limaye <a-limaye@ti.com>
Reviewed-by: Udit Kumar <u-kumar1@ti.com>
Link: https://patch.msgid.link/20251022122638.234367-1-a-limaye@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am69-sk.dts                   | 8 ++++----
 arch/arm64/boot/dts/ti/k3-j784s4-j742s2-evm-common.dtsi | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am69-sk.dts b/arch/arm64/boot/dts/ti/k3-am69-sk.dts
index 5896e57b5b9ed..0e2d12cb051da 100644
--- a/arch/arm64/boot/dts/ti/k3-am69-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am69-sk.dts
@@ -236,8 +236,8 @@ J784S4_IOPAD(0x0d4, PIN_OUTPUT, 11) /* (AN38) SPI0_CLK.UART8_TXD */
 
 	main_i2c0_pins_default: main-i2c0-default-pins {
 		pinctrl-single,pins = <
-			J784S4_IOPAD(0x0e0, PIN_INPUT_PULLUP, 0) /* (AN36) I2C0_SCL */
-			J784S4_IOPAD(0x0e4, PIN_INPUT_PULLUP, 0) /* (AP37) I2C0_SDA */
+			J784S4_IOPAD(0x0e0, PIN_INPUT, 0) /* (AN36) I2C0_SCL */
+			J784S4_IOPAD(0x0e4, PIN_INPUT, 0) /* (AP37) I2C0_SDA */
 		>;
 	};
 
@@ -416,8 +416,8 @@ J784S4_WKUP_IOPAD(0x088, PIN_OUTPUT, 0) /* (J37) WKUP_GPIO0_12.MCU_UART0_TXD */
 
 	mcu_i2c0_pins_default: mcu-i2c0-default-pins {
 		pinctrl-single,pins = <
-			J784S4_WKUP_IOPAD(0x0a0, PIN_INPUT_PULLUP, 0) /* (M35) MCU_I2C0_SCL */
-			J784S4_WKUP_IOPAD(0x0a4, PIN_INPUT_PULLUP, 0) /* (G34) MCU_I2C0_SDA */
+			J784S4_WKUP_IOPAD(0x0a0, PIN_INPUT, 0) /* (M35) MCU_I2C0_SCL */
+			J784S4_WKUP_IOPAD(0x0a4, PIN_INPUT, 0) /* (G34) MCU_I2C0_SDA */
 		>;
 	};
 
diff --git a/arch/arm64/boot/dts/ti/k3-j784s4-j742s2-evm-common.dtsi b/arch/arm64/boot/dts/ti/k3-j784s4-j742s2-evm-common.dtsi
index 419c1a70e028d..2834f0a8bbee0 100644
--- a/arch/arm64/boot/dts/ti/k3-j784s4-j742s2-evm-common.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j784s4-j742s2-evm-common.dtsi
@@ -270,8 +270,8 @@ J784S4_IOPAD(0x0d4, PIN_OUTPUT, 11) /* (AN38) SPI0_CLK.UART8_TXD */
 
 	main_i2c0_pins_default: main-i2c0-default-pins {
 		pinctrl-single,pins = <
-			J784S4_IOPAD(0x0e0, PIN_INPUT_PULLUP, 0) /* (AN36) I2C0_SCL */
-			J784S4_IOPAD(0x0e4, PIN_INPUT_PULLUP, 0) /* (AP37) I2C0_SDA */
+			J784S4_IOPAD(0x0e0, PIN_INPUT, 0) /* (AN36) I2C0_SCL */
+			J784S4_IOPAD(0x0e4, PIN_INPUT, 0) /* (AP37) I2C0_SDA */
 		>;
 	};
 
-- 
2.51.0



