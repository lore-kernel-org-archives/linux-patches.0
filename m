Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05AEF30CDB4;
	Mon, 13 Oct 2025 15:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369179; cv=none; b=e62l8H9HiEYh6lxQZ4nBnYlKSSLt/ghADemvyQbxjgS+ql1oGpw3K+gag/wqYXd/q2ymuCes995IrxLLz5/pYTaKkPpAvEpYGq621+MXzPp1mN/PIt0GxHidA9TyWv9TadEnMh5DCtb3QJg8pfJys3Kie5vy5IgwbUPUkvdwFXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369179; c=relaxed/simple;
	bh=hPWnCJBobnXomezOyb07Od+ZyBOyRW2w+Fit/v2OQhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XDBUuiTol6eSqbMk5LO4HM0GPN9mWMGlFym2UGB7DJb58kL+IvEQttGbkdRfFHuzbNtvHDfemCi4rAS4/NUCwz47vSRUSwtTiP9+4PSluvy24xAuPDHAk27dXlbMKUv7zypxgxmMHKrj5t6JpUxSFMBfH1xt1JyIRfmdqbHqkdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZpEDWDxV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZpEDWDxV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E3DC4CEE7;
	Mon, 13 Oct 2025 15:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369178;
	bh=hPWnCJBobnXomezOyb07Od+ZyBOyRW2w+Fit/v2OQhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZpEDWDxVK/Jr0NXXWYMO1ZK6MWnh5NxqKeyNUpVRkitYSzcOwWk+t0zikdPSwwq5m
	 1yTRZMV4+Jo2WhiUWwe4LV+c1Zhdd5F6MtPiHRWpk+kLJbmGuVxzVimsw7tu2TaXaQ
	 2fvOEC3Ak8VDCQVpW5AMRpSu9j/axQzp2nAHcPKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 154/563] arm64: dts: allwinner: t527: orangepi-4a: hook up external 32k crystal
Date: Mon, 13 Oct 2025 16:40:15 +0200
Message-ID: <20251013144416.868172091@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit bd1ce7ef6aef4ee7349eb3124166e712693650ce ]

When the board was added, its external 32.768 KHz crystal was described
but not hooked up correctly. This meant the device had to fall back to
the SoC's internal oscillator or divide a 32 KHz clock from the main
oscillator, neither of which are accurate for the RTC. As a result the
RTC clock will drift badly.

Hook the crystal up to the RTC block and request the correct clock rate.

Fixes: de713ccb9934 ("arm64: dts: allwinner: t527: Add OrangePi 4A board")
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://patch.msgid.link/20250913102450.3935943-3-wens@kernel.org
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun55i-t527-orangepi-4a.dts | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/boot/dts/allwinner/sun55i-t527-orangepi-4a.dts b/arch/arm64/boot/dts/allwinner/sun55i-t527-orangepi-4a.dts
index d07bb9193b438..b5483bd7b8d5d 100644
--- a/arch/arm64/boot/dts/allwinner/sun55i-t527-orangepi-4a.dts
+++ b/arch/arm64/boot/dts/allwinner/sun55i-t527-orangepi-4a.dts
@@ -346,6 +346,14 @@ &r_pio {
 	vcc-pm-supply = <&reg_bldo2>;
 };
 
+&rtc {
+	clocks = <&r_ccu CLK_BUS_R_RTC>, <&osc24M>,
+		 <&r_ccu CLK_R_AHB>, <&ext_osc32k>;
+	clock-names = "bus", "hosc", "ahb", "ext-osc32k";
+	assigned-clocks = <&rtc CLK_OSC32K>;
+	assigned-clock-rates = <32768>;
+};
+
 &uart0 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&uart0_pb_pins>;
-- 
2.51.0



