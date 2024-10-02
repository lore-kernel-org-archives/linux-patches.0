Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1061D0438;
	Wed,  2 Oct 2024 14:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879390; cv=none; b=gdaPxa0MlYLy5Dwxx7V332igG8DYOwiSidVpeGP3FUccMTU+csZ2Z3N0YeHARikXyq+63mWCUol/YXb6Hm+rhTTmBEWlNR0yvK3hIFILoxuynEvXuiTqTlMx6pwO5CcL513PnChRUQpjOrO/QMCPE6swxyRyeyFsb3PWJo/0Nek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879390; c=relaxed/simple;
	bh=Bcokgovt8tTgEydAYxEEIDqWxH85byZEA91ms/L2yiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qiz++SGQ5zradUkObYa649ueAcs41qBP2Zr+wPNv8LNT6xZaWg56bEAzlXNrdGSPaFtXf65xRPViy2ROQKB2p/254WQ+wRNTJ6hPtmpVczlBgk2Kun5m2JIjoIORbEOt17q1sySyW5+MQ4BUTL2qw9+HZLDczZtrl/jeFhsADQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n2gNR9nx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n2gNR9nx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA06DC4CEC2;
	Wed,  2 Oct 2024 14:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879390;
	bh=Bcokgovt8tTgEydAYxEEIDqWxH85byZEA91ms/L2yiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n2gNR9nx6LLSnIrlqqbMb3114o785ZrUdQfy+MsBZg5oQXP4oF4hpE/Za5ai2KpiE
	 3F4Ba6GqvE1em9+T2jX1ivuiPbZ0/ebI8r7OAaPhj2hneq6lyzOYQcSJBuM58rGyMo
	 Nxg29Poe3/7Nh0pbHeR2SwncwQn76qAZLcBBvpF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 103/538] ARM: dts: microchip: sama7g5: Fix RTT clock
Date: Wed,  2 Oct 2024 14:55:42 +0200
Message-ID: <20241002125756.297526047@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea@tuxon.dev>

[ Upstream commit 867bf1923200e6ad82bad0289f43bf20b4ac7ff9 ]

According to datasheet, Chapter 34. Clock Generator, section 34.2,
Embedded characteristics, source clock for RTT is the TD_SLCK, registered
with ID 1 by the slow clock controller driver. Fix RTT clock.

Fixes: 7540629e2fc7 ("ARM: dts: at91: add sama7g5 SoC DT and sama7g5-ek")
Link: https://lore.kernel.org/r/20240826165320.3068359-1-claudiu.beznea@tuxon.dev
Signed-off-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/microchip/sama7g5.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/microchip/sama7g5.dtsi b/arch/arm/boot/dts/microchip/sama7g5.dtsi
index 269e0a3ca269c..7a95464bb78d8 100644
--- a/arch/arm/boot/dts/microchip/sama7g5.dtsi
+++ b/arch/arm/boot/dts/microchip/sama7g5.dtsi
@@ -272,7 +272,7 @@ rtt: rtc@e001d020 {
 			compatible = "microchip,sama7g5-rtt", "microchip,sam9x60-rtt", "atmel,at91sam9260-rtt";
 			reg = <0xe001d020 0x30>;
 			interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&clk32k 0>;
+			clocks = <&clk32k 1>;
 		};
 
 		clk32k: clock-controller@e001d050 {
-- 
2.43.0



