Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7EA61BB6AF;
	Thu,  6 Jun 2024 14:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683494; cv=none; b=bgyAutrDis8HMDJgPDSd93rVaCkU9Qh3xLIRz/4x4ZIH5b9l4arYh20b8x6JwRucayhNEymbN9WPdIuvWz2gqeE/5MuUF624anSpfRVZwCI4OMqpjtaB4GcF6A5PSIkB6/hDV51bU82EvzKyPmdLhy19izPXPmVhAJpbkcYX/vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683494; c=relaxed/simple;
	bh=VSiHb8hGKXD1T4Az9TGQY4YlBBptCxDl8CWIY5Zf0rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gkgdf1jXVlpzhO6ilKINTA4bv4bdD3qOvptyWhQuXhgOvOohMVAEyJUHGpp0i8stWulOjqKMpLZQnC9ARwii3IZ50vGQzvS4XB0wML9ELRLMvH+mBtLUCFjP3diyGVQeVn8yQaqTnMvGKozFM8izERk7N6mHNxqa9VzmumggkdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RqNNkj1F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RqNNkj1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8628EC2BD10;
	Thu,  6 Jun 2024 14:18:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683494;
	bh=VSiHb8hGKXD1T4Az9TGQY4YlBBptCxDl8CWIY5Zf0rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RqNNkj1F6XKk6QurzSPKXsrQIMDSyH5w402yLh4vmURwLPSyEBqdpaP44PNuLoCB9
	 ZWZKeN3DG2H2qVvNvoj66STuaH0efTwWQgjHm4ViNXdFlWKiLwKRfysbOsY3yTfb4/
	 PTcAFyNYwbt+egM1AgVZjVqaf8mHXj7gXcnoWNeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannah Peuckmann <hannah.peuckmann@canonical.com>,
	Emil Renner Berthing <emil.renner.berthing@canonical.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 437/744] riscv: dts: starfive: visionfive 2: Remove non-existing TDM hardware
Date: Thu,  6 Jun 2024 16:01:49 +0200
Message-ID: <20240606131746.495613556@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannah Peuckmann <hannah.peuckmann@canonical.com>

[ Upstream commit dcde4e97b122ac318aaa71e8bcd2857dc28a0d12 ]

This partially reverts
commit e7c304c0346d ("riscv: dts: starfive: jh7110: add the node and pins configuration for tdm")

This added device tree nodes for TDM hardware that is not actually on the
VisionFive 2 board, but connected on the 40pin header. Many different extension
boards could be added on those pins, so this should be handled by overlays
instead.
This also conflicts with the I2S node which also attempts to grab GPIO 44:

  starfive-jh7110-sys-pinctrl 13040000.pinctrl: pin GPIO44 already requested by 10090000.tdm; cannot claim for 120c0000.i2s

Fixes: e7c304c0346d ("riscv: dts: starfive: jh7110: add the node and pins configuration for tdm")
Signed-off-by: Hannah Peuckmann <hannah.peuckmann@canonical.com>
Reviewed-by: Emil Renner Berthing <emil.renner.berthing@canonical.com>
Tested-by: Emil Renner Berthing <emil.renner.berthing@canonical.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../jh7110-starfive-visionfive-2.dtsi         | 40 -------------------
 1 file changed, 40 deletions(-)

diff --git a/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2.dtsi b/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2.dtsi
index 2c02358abd711..c9b212c0eaa8f 100644
--- a/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2.dtsi
+++ b/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2.dtsi
@@ -440,40 +440,6 @@ GPOEN_ENABLE,
 		};
 	};
 
-	tdm_pins: tdm-0 {
-		tx-pins {
-			pinmux = <GPIOMUX(44, GPOUT_SYS_TDM_TXD,
-					      GPOEN_ENABLE,
-					      GPI_NONE)>;
-			bias-pull-up;
-			drive-strength = <2>;
-			input-disable;
-			input-schmitt-disable;
-			slew-rate = <0>;
-		};
-
-		rx-pins {
-			pinmux = <GPIOMUX(61, GPOUT_HIGH,
-					      GPOEN_DISABLE,
-					      GPI_SYS_TDM_RXD)>;
-			input-enable;
-		};
-
-		sync-pins {
-			pinmux = <GPIOMUX(63, GPOUT_HIGH,
-					      GPOEN_DISABLE,
-					      GPI_SYS_TDM_SYNC)>;
-			input-enable;
-		};
-
-		pcmclk-pins {
-			pinmux = <GPIOMUX(38, GPOUT_HIGH,
-					      GPOEN_DISABLE,
-					      GPI_SYS_TDM_CLK)>;
-			input-enable;
-		};
-	};
-
 	uart0_pins: uart0-0 {
 		tx-pins {
 			pinmux = <GPIOMUX(5, GPOUT_SYS_UART0_TX,
@@ -499,12 +465,6 @@ GPOEN_DISABLE,
 	};
 };
 
-&tdm {
-	pinctrl-names = "default";
-	pinctrl-0 = <&tdm_pins>;
-	status = "okay";
-};
-
 &uart0 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&uart0_pins>;
-- 
2.43.0



