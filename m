Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26040197534;
	Thu,  6 Jun 2024 14:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682916; cv=none; b=Ax8xxAEhhSovebTRBWt254Nm3miFxbEH1DTQk415slsCY9iQxRTKoOPKDLR//WfakrMOteumhu9T6pgODarrQnI/XBsMIQRNeCtdBsQX9WJzfd8dFA1C7UTeYDmjZQ1PasLQnzUV6Qo7cwmT4cXRNTdRWevh9iKhr1sedBXlnvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682916; c=relaxed/simple;
	bh=UA0SEu7fPWyNaCI23tbovxWhPzOZfHXpzXsMqV5f+Y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fkXuHEV7RjcvXlh98CSdrNw+o2qsmB+3FmJxCJu95/D20EH1bEXHij8UeY/I8w8wa4LjCmu+F7fXDtviUX5b2A+VLN6DvPqA8vFW7G6pxU9Vgf9I1s1soeBsk3vsRpAWcGHhO2XBT/PF+tI5qYeW/VxqTxA4xJUJq7CjnY2T38Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KTOJGvyg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KTOJGvyg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 058CEC2BD10;
	Thu,  6 Jun 2024 14:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682916;
	bh=UA0SEu7fPWyNaCI23tbovxWhPzOZfHXpzXsMqV5f+Y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KTOJGvyge3frNUYq6Nny4UR2RY0MWq93S/n4MZ36lQzFIwyZ4iQHPZwE03CUqDRB4
	 eidGkJC+DfophylX0sJvnKVAbzfJc9Zr3hjhSgwWh/UBAeUcB270zwXyoNncotBmSF
	 3RZIQTWvUASJkdSr+mT9fqIoIbr60xj6tfLMaeOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannah Peuckmann <hannah.peuckmann@canonical.com>,
	Emil Renner Berthing <emil.renner.berthing@canonical.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 047/374] riscv: dts: starfive: visionfive 2: Remove non-existing I2S hardware
Date: Thu,  6 Jun 2024 16:00:26 +0200
Message-ID: <20240606131653.386047193@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannah Peuckmann <hannah.peuckmann@canonical.com>

[ Upstream commit e0503d47e93dead8c0475ea1eb624e03fada21d3 ]

This partially reverts
commit 92cfc35838b2 ("riscv: dts: starfive: Add the nodes and pins of I2Srx/I2Stx0/I2Stx1")

This added device tree nodes for I2S hardware that is not actually on the
VisionFive 2 board, but connected on the 40pin header. Many different extension
boards could be added on those pins, so this should be handled by overlays
instead.
This also conflicts with the TDM node which also attempts to grab GPIO 44:

  starfive-jh7110-sys-pinctrl 13040000.pinctrl: pin GPIO44 already requested by 10090000.tdm; cannot claim for 120c0000.i2s

Fixes: 92cfc35838b2 ("riscv: dts: starfive: Add the nodes and pins of I2Srx/I2Stx0/I2Stx1")
Signed-off-by: Hannah Peuckmann <hannah.peuckmann@canonical.com>
Reviewed-by: Emil Renner Berthing <emil.renner.berthing@canonical.com>
Tested-by: Emil Renner Berthing <emil.renner.berthing@canonical.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../jh7110-starfive-visionfive-2.dtsi         | 58 -------------------
 1 file changed, 58 deletions(-)

diff --git a/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2.dtsi b/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2.dtsi
index d89eef6e26335..2b3e952513e44 100644
--- a/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2.dtsi
+++ b/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2.dtsi
@@ -279,24 +279,6 @@ &i2c6 {
 	status = "okay";
 };
 
-&i2srx {
-	pinctrl-names = "default";
-	pinctrl-0 = <&i2srx_pins>;
-	status = "okay";
-};
-
-&i2stx0 {
-	pinctrl-names = "default";
-	pinctrl-0 = <&mclk_ext_pins>;
-	status = "okay";
-};
-
-&i2stx1 {
-	pinctrl-names = "default";
-	pinctrl-0 = <&i2stx1_pins>;
-	status = "okay";
-};
-
 &mmc0 {
 	max-frequency = <100000000>;
 	assigned-clocks = <&syscrg JH7110_SYSCLK_SDIO0_SDCARD>;
@@ -447,46 +429,6 @@ GPOEN_SYS_I2C6_DATA,
 		};
 	};
 
-	i2srx_pins: i2srx-0 {
-		clk-sd-pins {
-			pinmux = <GPIOMUX(38, GPOUT_LOW,
-					      GPOEN_DISABLE,
-					      GPI_SYS_I2SRX_BCLK)>,
-				 <GPIOMUX(63, GPOUT_LOW,
-					      GPOEN_DISABLE,
-					      GPI_SYS_I2SRX_LRCK)>,
-				 <GPIOMUX(38, GPOUT_LOW,
-					      GPOEN_DISABLE,
-					      GPI_SYS_I2STX1_BCLK)>,
-				 <GPIOMUX(63, GPOUT_LOW,
-					      GPOEN_DISABLE,
-					      GPI_SYS_I2STX1_LRCK)>,
-				 <GPIOMUX(61, GPOUT_LOW,
-					      GPOEN_DISABLE,
-					      GPI_SYS_I2SRX_SDIN0)>;
-			input-enable;
-		};
-	};
-
-	i2stx1_pins: i2stx1-0 {
-		sd-pins {
-			pinmux = <GPIOMUX(44, GPOUT_SYS_I2STX1_SDO0,
-					      GPOEN_ENABLE,
-					      GPI_NONE)>;
-			bias-disable;
-			input-disable;
-		};
-	};
-
-	mclk_ext_pins: mclk-ext-0 {
-		mclk-ext-pins {
-			pinmux = <GPIOMUX(4, GPOUT_LOW,
-					     GPOEN_DISABLE,
-					     GPI_SYS_MCLK_EXT)>;
-			input-enable;
-		};
-	};
-
 	mmc0_pins: mmc0-0 {
 		 rst-pins {
 			pinmux = <GPIOMUX(62, GPOUT_SYS_SDIO0_RST,
-- 
2.43.0



