Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B1B9282E1;
	Tue, 12 Aug 2025 18:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022114; cv=none; b=lRv8nCw7Eri5Tl3DR+nPAme+1awmbdrS2BP4lioc9Lt+l4RpntvAXU+6oCp0TiXdVW2vs8C+lmI6CG4a2R2I3u0lrcEYcU27R0QOV5fTncBd86jNqF06LSd0dZtrSnqSW2BaZInXH//ca5TPVsZJufB4yvJ3FNKGPkJelaqgTQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022114; c=relaxed/simple;
	bh=bk/kpa124vFg+bdNeSPjwWDZykP7tzQe9qWJqCX/p5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bp2GUWlEyMxuJjjdChPDMWvHfUqy2UXwk47wJussdA3yraAMW1Rnh2NaZEtb5AcOt/WNLcERgvraVDd5VO8kZyAiUmNdo0h+tr76IoTX3AQsNLeb1DwMuuBQo6IS8rcObj82Jitg3Hz3R8Sw0CrhShyxH0cDF7pZnhOsR/GacOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SpEWUtWk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SpEWUtWk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DDFAC4CEF6;
	Tue, 12 Aug 2025 18:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022114;
	bh=bk/kpa124vFg+bdNeSPjwWDZykP7tzQe9qWJqCX/p5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SpEWUtWkApLW98AOvkcoRKRgFoMEQ+PU65OemnMQJy/p4Xod+/8fuoUGQj4XejKxT
	 b5l184iHvoyPaihDVRqUK8fSOjl9HDfh+teQLR/sNdi0EESjr4Mu/o+fYrpL2qJYgx
	 eL20pV3fpFMqN4jG7hn0fjZjSyVuKY8epbtIstWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wadim Egorov <w.egorov@phytec.de>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 032/369] arm64: dts: ti: k3-am642-phyboard-electra: Fix PRU-ICSSG Ethernet ports
Date: Tue, 12 Aug 2025 19:25:29 +0200
Message-ID: <20250812173015.961334054@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

From: Wadim Egorov <w.egorov@phytec.de>

[ Upstream commit 945e48a39c957924bc84d1a6c137da039e13855b ]

For the ICSSG PHYs to operate correctly, a 25 MHz reference clock must
be supplied on CLKOUT0. Previously, our bootloader configured this
clock, which is why the PRU Ethernet ports appeared to work, but the
change never made it into the device tree.

Add clock properties to make EXT_REFCLK1.CLKOUT0 output a 25MHz clock.

Signed-off-by: Wadim Egorov <w.egorov@phytec.de>
Fixes: 87adfd1ab03a ("arm64: dts: ti: am642-phyboard-electra: Add PRU-ICSSG nodes")
Link: https://lore.kernel.org/r/20250521053339.1751844-1-w.egorov@phytec.de
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am642-phyboard-electra-rdk.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/ti/k3-am642-phyboard-electra-rdk.dts b/arch/arm64/boot/dts/ti/k3-am642-phyboard-electra-rdk.dts
index 60285d736e07..78df1b43a633 100644
--- a/arch/arm64/boot/dts/ti/k3-am642-phyboard-electra-rdk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am642-phyboard-electra-rdk.dts
@@ -319,6 +319,8 @@ AM64X_IOPAD(0x0040, PIN_OUTPUT, 7)	/* (U21) GPMC0_AD1.GPIO0_16 */
 &icssg0_mdio {
 	pinctrl-names = "default";
 	pinctrl-0 = <&icssg0_mdio_pins_default &clkout0_pins_default>;
+	assigned-clocks = <&k3_clks 157 123>;
+	assigned-clock-parents = <&k3_clks 157 125>;
 	status = "okay";
 
 	icssg0_phy1: ethernet-phy@1 {
-- 
2.39.5



