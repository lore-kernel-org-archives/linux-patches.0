Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE01E18CC1C;
	Mon, 24 Feb 2025 14:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408655; cv=none; b=GQs5gfIRWcDVy80Zk2hTiOJPDdfr7H7safoGD48GvVrF+o+7FWgblekhgtx/uAirovmhtu5FNMrJMx41yHIVFgRFCXkT8mlB1YaV/sZ8G6TLCmcj/RLbaXwmUjzRuAjqF3ZPVfV/SdOsZdfXM1/I+W9vDLthUdLsU/lqfC33u94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408655; c=relaxed/simple;
	bh=BMD234qbTTXKOnjcV5L4ZjpbvxbY/5u/2JqQ4SALw30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eOSDnJgsndevW/XNCWsx1+m1Ov9E85Xpuj4geF55qT6SKHVw/4+xtoUzqcxj4/xc1li7nR8JHZZ0G/yF2832SYwbQkOAciHLv3lnw480lP5vkZFNyY1YNbdB8ESuwyXup4hDvhmqQtein0D8aXo/7bi7prD/fD62A45O7MBbxoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=INNyZGLx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="INNyZGLx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10784C4CED6;
	Mon, 24 Feb 2025 14:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408654;
	bh=BMD234qbTTXKOnjcV5L4ZjpbvxbY/5u/2JqQ4SALw30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=INNyZGLxTi83Ysbr6DYYoFnAQHHh9e9EoDRYkWYxUQ4i48eJgsOfXWi9+8KsJcbuk
	 fOL4Klgx/HeLHCeIxuxfr+ajFUlvCKIdDksT+7dXEtMocZF5fHiKoVe+1CyvK+ix95
	 AAwFf82CkDNrtLzpLdm1iolEsyEXmHU2DIUxUoJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Lukasz Czechowski <lukasz.czechowski@thaumatec.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.12 120/154] arm64: dts: rockchip: Move uart5 pin configuration to px30 ringneck SoM
Date: Mon, 24 Feb 2025 15:35:19 +0100
Message-ID: <20250224142611.752460957@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukasz Czechowski <lukasz.czechowski@thaumatec.com>

commit 4eee627ea59304cdd66c5d4194ef13486a6c44fc upstream.

In the PX30-uQ7 (Ringneck) SoM, the hardware CTS and RTS pins for
uart5 cannot be used for the UART CTS/RTS, because they are already
allocated for different purposes. CTS pin is routed to SUS_S3#
signal, while RTS pin is used internally and is not available on
Q7 connector. Move definition of the pinctrl-0 property from
px30-ringneck-haikou.dts to px30-ringneck.dtsi.

This commit is a dependency to next commit in the patch series,
that disables DMA for uart5.

Cc: stable@vger.kernel.org
Reviewed-by: Quentin Schulz <quentin.schulz@cherry.de>
Signed-off-by: Lukasz Czechowski <lukasz.czechowski@thaumatec.com>
Link: https://lore.kernel.org/r/20250121125604.3115235-2-lukasz.czechowski@thaumatec.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/px30-ringneck-haikou.dts |    1 -
 arch/arm64/boot/dts/rockchip/px30-ringneck.dtsi       |    4 ++++
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/rockchip/px30-ringneck-haikou.dts
+++ b/arch/arm64/boot/dts/rockchip/px30-ringneck-haikou.dts
@@ -226,7 +226,6 @@
 };
 
 &uart5 {
-	pinctrl-0 = <&uart5_xfer>;
 	rts-gpios = <&gpio0 RK_PB5 GPIO_ACTIVE_HIGH>;
 	status = "okay";
 };
--- a/arch/arm64/boot/dts/rockchip/px30-ringneck.dtsi
+++ b/arch/arm64/boot/dts/rockchip/px30-ringneck.dtsi
@@ -373,6 +373,10 @@
 	status = "okay";
 };
 
+&uart5 {
+	pinctrl-0 = <&uart5_xfer>;
+};
+
 /* Mule UCAN */
 &usb_host0_ehci {
 	status = "okay";


