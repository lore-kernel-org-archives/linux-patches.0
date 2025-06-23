Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D37D1F463B;
	Mon, 23 Jun 2025 22:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717661; cv=none; b=VlRxY5iziT8BqKCqYonMrN1HqgoawaNP7voKe+AUm3inrRKSk12ZesVIiZQ3fHTw9ZP6Z4DK7BX+FOOEq8iOUlrR48/hyhwndrSd8ScQD/8wuqlwUAxB4nOUdsDqqRDzVYhfQNZVy0h9y67I9pp5iHPebAerzMAnBpvpNGsobIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717661; c=relaxed/simple;
	bh=J5v6ZxmxrudQhQEyYQtARxWAncyL/rJuWBVvyOLv5sU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hQFqDEKj06RKI4WteeMEO0RCjoAKK/8+ZRcLvhkR86qd90HXQZfdGBzzXHx0tCsIb7HWhRbSQzJBo02SrdemtZYntqlGk9sAT4Hcd5sKPE3KJC9ylXhz29BRmtbujducRd43w5RPsHDncuT8IwtnclEVmPEl29y7i+MtYIjJtqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=icT//SV6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="icT//SV6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 046D5C4CEEA;
	Mon, 23 Jun 2025 22:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717661;
	bh=J5v6ZxmxrudQhQEyYQtARxWAncyL/rJuWBVvyOLv5sU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=icT//SV6ApJpbc0A42Sm54dOTAQDsbO5OUpXlmjLTTqSQW8Mvwz9rW1yvr4GNIc8E
	 6WLvae1atMLmU60N7S3Jm6gBz7MUxmMhEMSvzvAIlnRkIq7TUcasbJ5t4PdJD1P3Z9
	 bBAg2Ck5YN+MRbq3AtGEb+ZxXsW7Wa6Oi4METuJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Nelson <robertcnelson@gmail.com>,
	Shengyu Qu <wiagn233@outlook.com>,
	Tony Lindgren <tony@atomide.com>,
	"Nobuhiro Iwamatsu (CIP)" <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 6.1 494/508] ARM: dts: am335x-bone-common: Add GPIO PHY reset on revision C3 board
Date: Mon, 23 Jun 2025 15:08:59 +0200
Message-ID: <20250623130657.185568709@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengyu Qu <wiagn233@outlook.com>

commit 623cef652768860bd5f205fb7b741be278585fba upstream.

This patch adds ethernet PHY reset GPIO config for Beaglebone Black
series boards with revision C3. This fixes a random phy startup failure
bug discussed at [1]. The GPIO pin used for reset is not used on older
revisions, so it is ok to apply to all board revisions. The reset timing
was discussed and tested at [2].

[1] https://forum.digikey.com/t/ethernet-device-is-not-detecting-on-ubuntu-20-04-lts-on-bbg/19948
[2] https://forum.beagleboard.org/t/recognizing-a-beaglebone-black-rev-c3-board/31249/

Signed-off-by: Robert Nelson <robertcnelson@gmail.com>
Signed-off-by: Shengyu Qu <wiagn233@outlook.com>
Message-ID: <TY3P286MB26113797A3B2EC7E0348BBB2980FA@TY3P286MB2611.JPNP286.PROD.OUTLOOK.COM>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/am335x-bone-common.dtsi |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/arm/boot/dts/am335x-bone-common.dtsi
+++ b/arch/arm/boot/dts/am335x-bone-common.dtsi
@@ -145,6 +145,8 @@
 			/* MDIO */
 			AM33XX_PADCONF(AM335X_PIN_MDIO, PIN_INPUT_PULLUP | SLEWCTRL_FAST, MUX_MODE0)
 			AM33XX_PADCONF(AM335X_PIN_MDC, PIN_OUTPUT_PULLUP, MUX_MODE0)
+			/* Added to support GPIO controlled PHY reset */
+			AM33XX_PADCONF(AM335X_PIN_UART0_CTSN, PIN_OUTPUT_PULLUP, MUX_MODE7)
 		>;
 	};
 
@@ -153,6 +155,8 @@
 			/* MDIO reset value */
 			AM33XX_PADCONF(AM335X_PIN_MDIO, PIN_INPUT_PULLDOWN, MUX_MODE7)
 			AM33XX_PADCONF(AM335X_PIN_MDC, PIN_INPUT_PULLDOWN, MUX_MODE7)
+			/* Added to support GPIO controlled PHY reset */
+			AM33XX_PADCONF(AM335X_PIN_UART0_CTSN, PIN_INPUT_PULLDOWN, MUX_MODE7)
 		>;
 	};
 
@@ -377,6 +381,10 @@
 
 	ethphy0: ethernet-phy@0 {
 		reg = <0>;
+		/* Support GPIO reset on revision C3 boards */
+		reset-gpios = <&gpio1 8 GPIO_ACTIVE_LOW>;
+		reset-assert-us = <300>;
+		reset-deassert-us = <6500>;
 	};
 };
 


