Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205A91C3021;
	Mon, 14 Oct 2024 14:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917600; cv=none; b=n8p6d/iYJbLL/trVk2XN8ALIjsxB0HvCZEMI1qXNPuEEg5H0RUBmm06ME9+NIPtAhyWxPM9Ojllt9GZNWXdroYeN7bfktWeLsAQdgFcEDa4iJfIzJG+ZYgotJo06C71U+YOZhtBv8cHCLwTymyWpap/OgtA3/D+8R5uv8NmIqsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917600; c=relaxed/simple;
	bh=u1zTIAxjINZud+gELEIsayJeWS7mTHyiHmRYsEtehHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MxEnsIMK5k/+gCAFYOdpkcLekb/ijVZvzwFlL/7U+/Q2NXwncN/2NS8416RXVcTsnAyROt39BMeNX0xLHQq6nsreed+3HUmqZg2sZ4uocrdu5a03k+3f8h0QL+QszgrczxuW9hRXUrETx2mWIgoFtUt2QY65cEcuzRvVYhRv23o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QfAS3fyb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QfAS3fyb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 847D6C4CEC3;
	Mon, 14 Oct 2024 14:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917600;
	bh=u1zTIAxjINZud+gELEIsayJeWS7mTHyiHmRYsEtehHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QfAS3fyburvnNNkuu7Q0fS1+A5joIMK73qERgDFwuEVHL8RtsGjccCf6eggChMSa0
	 10pyjN6ALALfrJ3VqLo7AJWl+flWFTjGX8xr94LY4gqsvJjsiLYk6RnHjsKSc9DvbU
	 mUgS8fcDt7TbTDIASw5vVHximZZ0Lbm3odH53TWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 078/798] ARM: dts: microchip: sama7g5: Fix RTT clock
Date: Mon, 14 Oct 2024 16:10:32 +0200
Message-ID: <20241014141221.000784644@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/boot/dts/sama7g5.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sama7g5.dtsi b/arch/arm/boot/dts/sama7g5.dtsi
index 7bd8ae8e8d380..9cc0e86544ad4 100644
--- a/arch/arm/boot/dts/sama7g5.dtsi
+++ b/arch/arm/boot/dts/sama7g5.dtsi
@@ -221,7 +221,7 @@ rtt: rtc@e001d020 {
 			compatible = "microchip,sama7g5-rtt", "microchip,sam9x60-rtt", "atmel,at91sam9260-rtt";
 			reg = <0xe001d020 0x30>;
 			interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&clk32k 0>;
+			clocks = <&clk32k 1>;
 		};
 
 		clk32k: clock-controller@e001d050 {
-- 
2.43.0



