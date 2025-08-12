Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861B82FF148;
	Tue, 12 Aug 2025 18:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023355; cv=none; b=iVSlsOgKqObDPrPjYAwDBJf0qDonfTdEl/1z7AsrFyGw6J+Z/aDzzqq+RggMuxeki3fLHF3NGn9gTu8WsVTZClx+rwWLRatydf1Ne6dpgtNe3RV8v/M5ullAE59pbHj2nnimYFU1Vk4gIpsmPzDsaYCoowC9K7hnChbIj2wtoSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023355; c=relaxed/simple;
	bh=YSL62HQlw18UkPMm4IVFxwdnk81JnWgoS1BO4wu20Tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=We7cs7GJkez2b2uDZnizEvewl38ox2pcgKWX6G8DchEEjJqZeB0weenRJSaOO5Ee/kRuawuDWl/YCC92XXWQn10FvRbE+tAq0G2OUD1UL31vTOi9y6BvzZYEv6yBewt9BlokAvPrzOJk/dUWPxO66lpFUpDdFkYH3kC6GOga08Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xl9V3ZGQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xl9V3ZGQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B0AC4CEF7;
	Tue, 12 Aug 2025 18:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023355;
	bh=YSL62HQlw18UkPMm4IVFxwdnk81JnWgoS1BO4wu20Tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xl9V3ZGQ8MIRtjdgIVDE83CHbA51AfhwJud2+Q9+s+EVa7FyAfdHUSBshdj0HEHRr
	 uuRwb8L0hA82zF6wLA5Po6V+vRNtOHPeFTB3PHJRZg50FEkHYaO+S/oh3WE3p0DETB
	 q62ziA4PqJY4T+La91MC3G9gZiNTxJa5Nxec7vXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wadim Egorov <w.egorov@phytec.de>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 054/627] arm64: dts: ti: k3-am642-phyboard-electra: Fix PRU-ICSSG Ethernet ports
Date: Tue, 12 Aug 2025 19:25:49 +0200
Message-ID: <20250812173421.384919984@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index f63c101b7d61..129524eb5b91 100644
--- a/arch/arm64/boot/dts/ti/k3-am642-phyboard-electra-rdk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am642-phyboard-electra-rdk.dts
@@ -322,6 +322,8 @@ AM64X_IOPAD(0x0040, PIN_OUTPUT, 7)	/* (U21) GPMC0_AD1.GPIO0_16 */
 &icssg0_mdio {
 	pinctrl-names = "default";
 	pinctrl-0 = <&icssg0_mdio_pins_default &clkout0_pins_default>;
+	assigned-clocks = <&k3_clks 157 123>;
+	assigned-clock-parents = <&k3_clks 157 125>;
 	status = "okay";
 
 	icssg0_phy1: ethernet-phy@1 {
-- 
2.39.5



