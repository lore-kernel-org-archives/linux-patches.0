Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F74C1DD9D3;
	Tue, 25 Mar 2025 12:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905983; cv=none; b=DrKm9fWoOjL5j+w5B4+EwhyLyf7BfjL2dhcXbQJtIR9xwqCX46UKUcnrZrqrGQUQCE4TV3cW1rQ/cKxb3BMdqHLwGwHZcLtx1w/sq5bEhwav33q26s9B7QTXVeA6kZezId1Cw6TDu5UpgTn3Dg9llJ0P5X44HsItt3FI0A4KgTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905983; c=relaxed/simple;
	bh=TyHI5oWYqU4HG7cGcIDZ+G8k/wTL4R0K0ftNplnyDrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GEyWyMrj+8ZPXpq9A3qKYL5/axSKZo6xLxUtD/qL7T1wNxQvvCeOtsYgXfonBHeLzrHkXPssFMQ2hlSSIu7KngzUZuiXFn0zpC8E8axztRtOMQme/YjoEDjdb+XIw0n23Uk/yD7oGneJGuKpq1tmbGWfm7KmqO1OvG86lx18DsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=feDLn0C5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="feDLn0C5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57069C4CEE4;
	Tue, 25 Mar 2025 12:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905982;
	bh=TyHI5oWYqU4HG7cGcIDZ+G8k/wTL4R0K0ftNplnyDrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=feDLn0C5nYQFOdc4jd6m17lQ+1/lc+IAZAPCcVGvuV5LzxIY+Gwwgl/VDJ+cXx5Ka
	 EUYzAYL3Mxkx/WxRa9z8wM23JRKCQOndhD1WlNOjbPrEC69VzuKzP4frDTYFp0DqI1
	 UjF1To3aujpnN5a+x2bP//Z0KfoAmkO8VwzU41BY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Schulz <quentin.schulz@cherry.de>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.13 071/119] arm64: dts: rockchip: fix pinmux of UART0 for PX30 Ringneck on Haikou
Date: Tue, 25 Mar 2025 08:22:09 -0400
Message-ID: <20250325122150.868627821@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quentin Schulz <quentin.schulz@cherry.de>

commit 2db7d29c7b1629ced3cbab3de242511eb3c22066 upstream.

UART0 pinmux by default configures GPIO0_B5 in its UART RTS function for
UART0. However, by default on Haikou, it is used as GPIO as UART RTS for
UART5.

Therefore, let's update UART0 pinmux to not configure the pin in that
mode, a later commit will make UART5 request the GPIO pinmux.

Fixes: c484cf93f61b ("arm64: dts: rockchip: add PX30-µQ7 (Ringneck) SoM with Haikou baseboard")
Cc: stable@vger.kernel.org
Signed-off-by: Quentin Schulz <quentin.schulz@cherry.de>
Link: https://lore.kernel.org/r/20250225-ringneck-dtbos-v3-1-853a9a6dd597@cherry.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/px30-ringneck-haikou.dts |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/boot/dts/rockchip/px30-ringneck-haikou.dts
+++ b/arch/arm64/boot/dts/rockchip/px30-ringneck-haikou.dts
@@ -222,6 +222,8 @@
 };
 
 &uart0 {
+	pinctrl-names = "default";
+	pinctrl-0 = <&uart0_xfer>;
 	status = "okay";
 };
 


