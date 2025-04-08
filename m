Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C600224F6;
	Tue,  8 Apr 2025 11:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110759; cv=none; b=IfpBVfJLDOER52xy52oCP2Iu4nEz9d1v/FgPxVkmtV9v1T0aVscExPoxptYcediei47wizRtEtL8bhFJg5NGjZ+Re2AHdLL98SaAyF1WPIQdZcg2xAvl7VkwlsKxANQ3di1+cSj6ZaV5AGj8+1sswwWKBprZuL0juhK7tVjGs+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110759; c=relaxed/simple;
	bh=DfKa25rcsAvHqZvS4d4FTLL7hqA2rnxpzWb4r1EGlH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YfY+00BOKheRpABZML6QEtZj7uNAJsEwMmv139jSYSbT6EsXsEg/JAO2jimPb9VgQUGRCwN0YtZt20jtcFyX1Cxtv6GeWonc3kRzhRgAclYolfB+M/3DNb/HMtZbis/IQe4w7YrnqVQI5DLr68OzzTdzjr99oSh9/C5sE00LzXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U6ynsfus; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U6ynsfus"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BEC5C4CEE5;
	Tue,  8 Apr 2025 11:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110758;
	bh=DfKa25rcsAvHqZvS4d4FTLL7hqA2rnxpzWb4r1EGlH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U6ynsfusXVNa6BzBAwb0FgQ2WtlYwFWyzTSdojWo4q60QSa9la+4A2e3yKQbi/qS3
	 tqjqS/16P+yOlK1tr+ki9GhmN3G9sRV8AOtFUnooQoOfh71swfOQ0TUhIeeWzJl+Ax
	 s2Wm21NaMQ17UUtuC/QSLxZWa11mXW4xiT62NvpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wens@csie.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 184/731] arm64: dts: rockchip: Remove bluetooth node from rock-3a
Date: Tue,  8 Apr 2025 12:41:21 +0200
Message-ID: <20250408104918.558114612@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit 6b68387cf5ff5d7b86b189135affb0c679e3384a ]

The Bluetooth node described in the device tree is actually on an M.2
slot. What module is present depends on what the end user installed,
and should be left to an overlay.

Remove the existing bluetooth node. This gets rid of bogus timeout
errors.

Fixes: 8cf890aabd45 ("arm64: dts: rockchip: Add nodes for SDIO/UART Wi-Fi/Bluetooth modules to Radxa Rock 3A")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Link: https://lore.kernel.org/r/20250220165051.1889055-1-wens@kernel.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts b/arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts
index ac79140a9ecd6..44cfdfeed6681 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts
@@ -778,20 +778,6 @@
 	pinctrl-0 = <&uart1m0_xfer &uart1m0_ctsn &uart1m0_rtsn>;
 	uart-has-rtscts;
 	status = "okay";
-
-	bluetooth {
-		compatible = "brcm,bcm43438-bt";
-		clocks = <&rk809 1>;
-		clock-names = "lpo";
-		device-wakeup-gpios = <&gpio4 RK_PB5 GPIO_ACTIVE_HIGH>;
-		host-wakeup-gpios = <&gpio4 RK_PB4 GPIO_ACTIVE_HIGH>;
-		shutdown-gpios = <&gpio4 RK_PB2 GPIO_ACTIVE_HIGH>;
-		pinctrl-names = "default";
-		pinctrl-0 = <&bt_host_wake &bt_wake &bt_enable>;
-		vbat-supply = <&vcc3v3_sys>;
-		vddio-supply = <&vcc_1v8>;
-		/* vddio comes from regulator on module, use IO bank voltage instead */
-	};
 };
 
 &uart2 {
-- 
2.39.5



