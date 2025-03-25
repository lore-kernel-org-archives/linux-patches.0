Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 627D425522E;
	Tue, 25 Mar 2025 12:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905984; cv=none; b=P9wL38GCCVtbZL9rrKFhh/m7AwT4O8eWGRm5+5b6rolMTowepjuKAX83TjG9ah7+MwaMGJlZbh56WuSTX2GUT0IVFaewjLMgWpfz6lladxOrNfZbmG+0nTVCXoBX/InfJpdhe6260KAZBJE4tuOdlfy36gSQ2N5RzY1tQe1JHW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905984; c=relaxed/simple;
	bh=SUUyrfqWXg13ldRJjQl6wgbo6c61io0q3nljWXtDG/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S6FWlRlyokEvA9kr9IZkj1osImsS6zBwwrnA3holySu1b406nhU5n+ESi+/C2i+XMj5Jt4kipFN4F10UaI7O3cnsHOOldIUbV2x41JzDkG7eScnRLFSyYXd94IsJtm7b4jdQU0sDV/nRbhq/zEBk4oJCyaiDdpb9QGDmPiY2ucg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TgQXZWoK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TgQXZWoK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1761DC4CEE4;
	Tue, 25 Mar 2025 12:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905984;
	bh=SUUyrfqWXg13ldRJjQl6wgbo6c61io0q3nljWXtDG/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TgQXZWoK/qcG+JuFhXzn6t9XPnTgETsAySnrfipCPUC4EvUxrOXrZUe1akchEXZ6a
	 YjE/26vSe2lGUF4C721aPcxDkYxFm8r7VjWXp73f/2Z8y0/NL8S4pHNJiNx2oDK2lo
	 BrCRcPvquUXn7eMwAa598sgP1iwXuiwo5ZfGXWlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.13 072/119] arm64: dts: rockchip: fix pinmux of UART5 for PX30 Ringneck on Haikou
Date: Tue, 25 Mar 2025 08:22:10 -0400
Message-ID: <20250325122150.897952236@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quentin Schulz <quentin.schulz@cherry.de>

commit 55de171bba1b8c0e3dd18b800955ac4b46a63d4b upstream.

UART5 uses GPIO0_B5 as UART RTS but muxed in its GPIO function,
therefore UART5 must request this pin to be muxed in that function, so
let's do that.

Fixes: 5963d97aa780 ("arm64: dts: rockchip: add rs485 support on uart5 of px30-ringneck-haikou")
Cc: stable@vger.kernel.org
Signed-off-by: Quentin Schulz <quentin.schulz@cherry.de>
Link: https://lore.kernel.org/r/20250225-ringneck-dtbos-v3-2-853a9a6dd597@cherry.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/px30-ringneck-haikou.dts |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/arm64/boot/dts/rockchip/px30-ringneck-haikou.dts
+++ b/arch/arm64/boot/dts/rockchip/px30-ringneck-haikou.dts
@@ -194,6 +194,13 @@
 			  <3 RK_PB3 RK_FUNC_GPIO &pcfg_pull_none>;
 		};
 	};
+
+	uart {
+		uart5_rts_pin: uart5-rts-pin {
+			rockchip,pins =
+			  <0 RK_PB5 RK_FUNC_GPIO &pcfg_pull_none>;
+		};
+	};
 };
 
 &pwm0 {
@@ -228,6 +235,9 @@
 };
 
 &uart5 {
+	/* Add pinmux for rts-gpios (uart5_rts_pin) */
+	pinctrl-names = "default";
+	pinctrl-0 = <&uart5_xfer &uart5_rts_pin>;
 	rts-gpios = <&gpio0 RK_PB5 GPIO_ACTIVE_HIGH>;
 	status = "okay";
 };


