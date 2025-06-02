Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0BB1211A0E;
	Mon,  2 Jun 2025 13:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872133; cv=none; b=IJbQAVlDP9zQ+tubpSFDFb6FngHvbyvEw0lh9ZpyU/krDvh/o9IMZpYRTmSztMVRqTEyG3BZDnLvZzItQI1oKppYi4socD7mYTVOjr8UXp50hHYiaFpnugWftt38KPlL9Z+TLgVJfiNY1nrdccFXCHcuOZYFkMvSlxY9A/okmtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872133; c=relaxed/simple;
	bh=VWczuyRHn/s1y7Y+N0uc1i8ne+uAPb8GH5fm3YlreT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJawQn2it0pPzo5V3CqpqpuVwpPVNZ/5As1pe5wZj3mgg0knkzQ0ulysTCWKhzr20UoFhSF6vVQfjH374Gaz/vLPCh+zGXvGeYlnNK4OCUVbvrJSXDcrxF1LTtZAv8qCxkvzfLaWJ7KV83YPtIoXJCXwEezvQQzVmb/oEBe+nuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lSN6iyfu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lSN6iyfu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC5E3C4CEEB;
	Mon,  2 Jun 2025 13:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872133;
	bh=VWczuyRHn/s1y7Y+N0uc1i8ne+uAPb8GH5fm3YlreT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lSN6iyfuxru1yyDa+SVirOT/1UW1/1htuq3e1UPTUuORCgql6Ej9b9xI9Eyr9PT4k
	 5mFFSWSbvtsnydkA2QC5Fh1Hnosj7pHLn9Zm08n5pLDXA6wYoMq4ZFr06iSdOFjVyt
	 MXn1PZR8gpqTX7oUKK6KrfYI9A7Y668wT/9WCkXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Udit Kumar <u-kumar1@ti.com>,
	Bryan Brattlof <bb@ti.com>,
	Nishanth Menon <nm@ti.com>
Subject: [PATCH 6.15 28/49] arm64: dts: ti: k3-am62a-main: Set eMMC clock parent to default
Date: Mon,  2 Jun 2025 15:47:20 +0200
Message-ID: <20250602134239.050422529@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134237.940995114@linuxfoundation.org>
References: <20250602134237.940995114@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Judith Mendez <jm@ti.com>

commit 6af731c5de59cc4e7cce193d446f1fe872ac711b upstream.

Set eMMC clock parents to the defaults which is MAIN_PLL0_HSDIV5_CLKOUT
for eMMC. This change is necessary since DM is not implementing the
correct procedure to switch PLL clock source for eMMC and MMC CLK mux is
not glich-free. As a preventative action, lets switch back to the defaults.

Fixes: d3ae4e8d8b6a ("arm64: dts: ti: k3-am62a-main: Add sdhci0 instance")
Cc: stable@vger.kernel.org
Signed-off-by: Judith Mendez <jm@ti.com>
Acked-by: Udit Kumar <u-kumar1@ti.com>
Acked-by: Bryan Brattlof <bb@ti.com>
Link: https://lore.kernel.org/r/20250429163337.15634-3-jm@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-am62a-main.dtsi |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/arm64/boot/dts/ti/k3-am62a-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62a-main.dtsi
@@ -575,8 +575,6 @@
 		power-domains = <&k3_pds 57 TI_SCI_PD_EXCLUSIVE>;
 		clocks = <&k3_clks 57 5>, <&k3_clks 57 6>;
 		clock-names = "clk_ahb", "clk_xin";
-		assigned-clocks = <&k3_clks 57 6>;
-		assigned-clock-parents = <&k3_clks 57 8>;
 		bus-width = <8>;
 		mmc-hs200-1_8v;
 		ti,clkbuf-sel = <0x7>;


