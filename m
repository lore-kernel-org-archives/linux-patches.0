Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CECF257859;
	Tue, 26 Aug 2025 13:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213464; cv=none; b=nV9C4x/vN1rwHCI/lKo2P7DbDfzNdlq4mM9ZGAZovaLr4FDEe2UBb3o4JleGTkfqhDAKgX1cIW645+d8/nWiLRdKOtupvhLb+8cr6YQhtAa3Gu+vUhCu4thkfS3k84J0eotjlm2UYOF4DpXAJ8b/J9SnpfvLgN5Ghmejcgo/BSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213464; c=relaxed/simple;
	bh=Q/JehDsQ3lNS/LbGVkogKN+3vMS32BbdpfZBQ05APNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=smvHwEzj6MPZU2s5gO64MvIFRz/W/JHDcEHfHcqOzguz7DSeP0TU7t8OlDpd6GvIx8B1KLQTRe5AqexEhqxJ+fsiHpxLMWyZb4Z84ODrS3N6iW8DUVjuoWE2gOgMKnEoXND8gfAZcWR9w/WqsCX1qu3ottLFwpatGGbUWNQ5JbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u8MFX80N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u8MFX80N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB18C113CF;
	Tue, 26 Aug 2025 13:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213464;
	bh=Q/JehDsQ3lNS/LbGVkogKN+3vMS32BbdpfZBQ05APNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u8MFX80NBtzB5CRTPpTlIbgnD5L5SHIT96bGg/ltsDdQ05ErA4eNMpykfJx6AcNEW
	 Du9LjA8PweY4rRgdhjmNC5AlmxNGr7MXCHmgHgY9ANpx3kOXLpG5APFnAC5VFFpWTT
	 MOgRwQ+UyZT9t5i1mT96QLR6nkvjlFYhkJkjJ0K4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emanuele Ghidoli <emanuele.ghidoli@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH 6.6 357/587] arm64: dts: ti: k3-am62-verdin: Enable pull-ups on I2C buses
Date: Tue, 26 Aug 2025 13:08:26 +0200
Message-ID: <20250826111001.996028960@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

From: Emanuele Ghidoli <emanuele.ghidoli@toradex.com>

commit bdf4252f736cc1d2a8e3e633c70fe6c728f0756e upstream.

Enable internal bias pull-ups on the SoC-side I2C buses that do not have
external pull resistors populated on the SoM. This ensures proper
default line levels.

Cc: stable@vger.kernel.org
Fixes: 316b80246b16 ("arm64: dts: ti: add verdin am62")
Signed-off-by: Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://lore.kernel.org/r/20250528110741.262336-1-ghidoliemanuele@gmail.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62-verdin.dtsi
@@ -448,16 +448,16 @@
 	/* Verdin I2C_2_DSI */
 	pinctrl_i2c2: main-i2c2-default-pins {
 		pinctrl-single,pins = <
-			AM62X_IOPAD(0x00b0, PIN_INPUT, 1) /* (K22) GPMC0_CSn2.I2C2_SCL */ /* SODIMM 55 */
-			AM62X_IOPAD(0x00b4, PIN_INPUT, 1) /* (K24) GPMC0_CSn3.I2C2_SDA */ /* SODIMM 53 */
+			AM62X_IOPAD(0x00b0, PIN_INPUT_PULLUP, 1) /* (K22) GPMC0_CSn2.I2C2_SCL */ /* SODIMM 55 */
+			AM62X_IOPAD(0x00b4, PIN_INPUT_PULLUP, 1) /* (K24) GPMC0_CSn3.I2C2_SDA */ /* SODIMM 53 */
 		>;
 	};
 
 	/* Verdin I2C_4_CSI */
 	pinctrl_i2c3: main-i2c3-default-pins {
 		pinctrl-single,pins = <
-			AM62X_IOPAD(0x01d0, PIN_INPUT, 2) /* (A15) UART0_CTSn.I2C3_SCL */ /* SODIMM 95 */
-			AM62X_IOPAD(0x01d4, PIN_INPUT, 2) /* (B15) UART0_RTSn.I2C3_SDA */ /* SODIMM 93 */
+			AM62X_IOPAD(0x01d0, PIN_INPUT_PULLUP, 2) /* (A15) UART0_CTSn.I2C3_SCL */ /* SODIMM 95 */
+			AM62X_IOPAD(0x01d4, PIN_INPUT_PULLUP, 2) /* (B15) UART0_RTSn.I2C3_SDA */ /* SODIMM 93 */
 		>;
 	};
 
@@ -729,8 +729,8 @@
 	/* Verdin I2C_3_HDMI */
 	pinctrl_mcu_i2c0: mcu-i2c0-default-pins {
 		pinctrl-single,pins = <
-			AM62X_MCU_IOPAD(0x0044, PIN_INPUT, 0) /*  (A8) MCU_I2C0_SCL */ /* SODIMM 59 */
-			AM62X_MCU_IOPAD(0x0048, PIN_INPUT, 0) /* (D10) MCU_I2C0_SDA */ /* SODIMM 57 */
+			AM62X_MCU_IOPAD(0x0044, PIN_INPUT_PULLUP, 0) /*  (A8) MCU_I2C0_SCL */ /* SODIMM 59 */
+			AM62X_MCU_IOPAD(0x0048, PIN_INPUT_PULLUP, 0) /* (D10) MCU_I2C0_SDA */ /* SODIMM 57 */
 		>;
 	};
 


