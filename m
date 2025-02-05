Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1ECC1FC7FE;
	Wed,  5 Feb 2025 14:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766827; cv=none; b=BEGfHq/y4h9MgeJL9SxIIXnC45LeJrQvJX8t8N6WjYimTrWMdiaSqXxWGiArWsmLhgzNqvE7E2QBMyeKiq8GToL9xaEvBCMTyV6L83D4QHDnlUnbllYkdwLPp+mtNszu/rztutLMyVr4IWbuOIlIZJ2eqf/2BPiSmvCr2+l3GVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766827; c=relaxed/simple;
	bh=lLGOfprXQ5hUFpA4Fr/fFPCDx7CDmSIU0XewCQggqnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kfgx7iLi8AavjK20QO1OTfDd8+OwkXSDd/s4AxObY3bBNpVvGR0t2hY9TcxR2zjfNzVr2lIshpAYOeSjkJXxrC8cUKs5Am64UNFOzf7XuP41ZkDPVnituRPXpDG03e2DTFbASuKjHrALvBV6b3YQKdYotAtbrVHvTsgW9ce+ynI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fLoogwO5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fLoogwO5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1677C4CED1;
	Wed,  5 Feb 2025 14:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766827;
	bh=lLGOfprXQ5hUFpA4Fr/fFPCDx7CDmSIU0XewCQggqnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fLoogwO5/xFLqjXeTFyJsXrek+MuGzkgQQoVJz3dIDxHmk8kcIPiuOtcAPv8+BX9N
	 X+eg669BwnXmiSMVlrUamSOD5jt60vkvQ3/StfJ43rvngi8b8HW6IJtgxz9uGfucJs
	 JGo6OigZktsYQGhJxBjhfoBuwCDGsMVRMc3oP2DQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragan Simic <dsimic@manjaro.org>,
	Chen-Yu Tsai <wens@csie.org>,
	Vasily Khoruzhick <anarsoul@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	Frank Oltmanns <frank@oltmanns.dev>,
	Stuart Gathman <stuart@gathman.org>
Subject: [PATCH 6.12 366/590] arm64: dts: allwinner: a64: explicitly assign clock parent for TCON0
Date: Wed,  5 Feb 2025 14:42:01 +0100
Message-ID: <20250205134509.273591845@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Vasily Khoruzhick <anarsoul@gmail.com>

[ Upstream commit 8715c91a836502929c637c76a26335ede8818acf ]

TCON0 seems to need a different clock parent depending on output type.
For RGB it has to be PLL-VIDEO0-2X, while for DSI it has to be PLL-MIPI,
so select it explicitly.

Video output doesn't work if incorrect clock is assigned.

On my Pinebook I manually configured PLL-VIDEO0-2X and PLL-MIPI to the same
rate, and while video output works fine with PLL-VIDEO0-2X, it doesn't
work at all (as in no picture) with PLL-MIPI.

Fixes: ca1170b69968 ("clk: sunxi-ng: a64: force select PLL_MIPI in TCON0 mux")
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Reviewed-by: Chen-Yu Tsai <wens@csie.org>
Tested-by: Frank Oltmanns <frank@oltmanns.dev> # on PinePhone
Tested-by: Stuart Gathman <stuart@gathman.org> # on OG Pinebook
Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
Link: https://patch.msgid.link/20250104074035.1611136-4-anarsoul@gmail.com
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts | 2 ++
 arch/arm64/boot/dts/allwinner/sun50i-a64-teres-i.dts  | 2 ++
 arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi         | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts b/arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts
index 379c2c8466f50..86d44349e0951 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-pinebook.dts
@@ -390,6 +390,8 @@
 &tcon0 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&lcd_rgb666_pins>;
+	assigned-clocks = <&ccu CLK_TCON0>;
+	assigned-clock-parents = <&ccu CLK_PLL_VIDEO0_2X>;
 
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64-teres-i.dts b/arch/arm64/boot/dts/allwinner/sun50i-a64-teres-i.dts
index b407e1dd08a73..ec055510af8b6 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64-teres-i.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64-teres-i.dts
@@ -369,6 +369,8 @@
 &tcon0 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&lcd_rgb666_pins>;
+	assigned-clocks = <&ccu CLK_TCON0>;
+	assigned-clock-parents = <&ccu CLK_PLL_VIDEO0_2X>;
 
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
index a5c3920e0f048..0fecf0abb204c 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
@@ -445,6 +445,8 @@
 			clock-names = "ahb", "tcon-ch0";
 			clock-output-names = "tcon-data-clock";
 			#clock-cells = <0>;
+			assigned-clocks = <&ccu CLK_TCON0>;
+			assigned-clock-parents = <&ccu CLK_PLL_MIPI>;
 			resets = <&ccu RST_BUS_TCON0>, <&ccu RST_BUS_LVDS>;
 			reset-names = "lcd", "lvds";
 
-- 
2.39.5



