Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 802E11CF284;
	Wed,  2 Oct 2024 13:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875704; cv=none; b=ksdC/SLxQXmmLdImwa/c8wNXrd926wfEeTySIGqxwY8JEo7n5h5meEffPjixt4D9S99jkAFykXXjMv8OKm0fANsJQvINumuaT4WRy19MK/Fd6ko5/9vkzLKTHLn8wQu8mJ5siZPuYUGk4WkjasQMVlQ83b8ECbTCyzt9vM/lIXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875704; c=relaxed/simple;
	bh=mFJ0NM1l+ks7fk4Scw79OVtQhPzTgrryLGogdEjEO0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EPqsq8+Zaxr2WkFAd5855YQ9OOa3lPmzlcsJzEN7vTC3am4H2bkTpgs0FX4MDsOLoJGXG1P/TlT/dMwWWBBCusek7k/hjVEZClS0NK6eKmmZYuG5CxsMdJb9reede6WRGE8CdNhOjKVqYxgPbY4F42CeTp67oExy2DdRQtT3xs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rksKG647; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rksKG647"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C0FEC4CEC5;
	Wed,  2 Oct 2024 13:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875704;
	bh=mFJ0NM1l+ks7fk4Scw79OVtQhPzTgrryLGogdEjEO0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rksKG647CgvpiikfH0r5cM6WGFmVo35yRyYhzBbrghKTLP1yirxteujmlgmCHWIJD
	 kx5FhkcIP0ayUnoVEic8cybJuDFIOFoEiy0E9XdSiPw6A57PbKHKe0WXyacfWGOFMO
	 yi3FvLPAZpg2lBK/CICcTdwdUrvyXSPrxB3usfG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 151/695] ARM: dts: microchip: sama7g5: Fix RTT clock
Date: Wed,  2 Oct 2024 14:52:29 +0200
Message-ID: <20241002125828.508703494@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 75778be126a3d..17bcdcf0cf4a0 100644
--- a/arch/arm/boot/dts/microchip/sama7g5.dtsi
+++ b/arch/arm/boot/dts/microchip/sama7g5.dtsi
@@ -272,7 +272,7 @@
 			compatible = "microchip,sama7g5-rtt", "microchip,sam9x60-rtt", "atmel,at91sam9260-rtt";
 			reg = <0xe001d020 0x30>;
 			interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&clk32k 0>;
+			clocks = <&clk32k 1>;
 		};
 
 		clk32k: clock-controller@e001d050 {
-- 
2.43.0



