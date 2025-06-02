Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B991F5846;
	Mon,  2 Jun 2025 13:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872653; cv=none; b=g0Ldm5OLOxibSgcoKtaBiJR3ZkyfulVaILIs5QX3BZqhFywtgBCvwiGYDfFZwaQLDY8WFjwOZgnu+/XbdaKe1WLaOtEAZsV/nfvuY0sovGejRpdTbpql3F66Kvo9sssT9SJ/NRI6tw+aVocic3v+QthyksefYrdWlgowbnqIy9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872653; c=relaxed/simple;
	bh=oCJ8nRN2KshlCuADpetO3j74o/9Jq10LBW5v6t3fNNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eolMKuHEMZaRaQ+BR+C5r+yKgy9l4XZwu5DluTvjgE+u8hhNb9qVb5IX2BlWuXysmWVipYoPAUfO1GdRAdE+FF052Gs2hk454sb2RnG+5K06QKQzm2p7ninXItFXcDP/OWBnNyk5qhkJ6LyW70dP329j5BHlv5WcGIszTHixKKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h9UlDdFu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h9UlDdFu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81FA2C4CEEB;
	Mon,  2 Jun 2025 13:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872652;
	bh=oCJ8nRN2KshlCuADpetO3j74o/9Jq10LBW5v6t3fNNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h9UlDdFuyCQ1nsMm0S/tA0tRnF3XYr8AU5txKfcgHGUorI5L+5anwcs7bPhDKMKKh
	 b7dg7H4V4MUvrb7xILhibdmI7v7S3QjzpluJCRPEJJpeEXzNW3Pi/i7+2TNsLAfpHv
	 hAIcDP0hkGb0oyzmFaAXsjBndfgWg5QpyqUX/iKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Udit Kumar <u-kumar1@ti.com>,
	Bryan Brattlof <bb@ti.com>,
	Nishanth Menon <nm@ti.com>
Subject: [PATCH 6.14 29/73] arm64: dts: ti: k3-am62p-j722s-common-main: Set eMMC clock parent to default
Date: Mon,  2 Jun 2025 15:47:15 +0200
Message-ID: <20250602134242.842673422@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134241.673490006@linuxfoundation.org>
References: <20250602134241.673490006@linuxfoundation.org>
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

From: Judith Mendez <jm@ti.com>

commit 9c6b73fc72e19c449147233587833ce20f84b660 upstream.

Set eMMC clock parents to the defaults which is MAIN_PLL0_HSDIV5_CLKOUT
for eMMC. This change is necessary since DM is not implementing the
correct procedure to switch PLL clock source for eMMC and MMC CLK mux is
not glich-free. As a preventative action, lets switch back to the defaults.

Fixes: b5080c7c1f7e ("arm64: dts: ti: k3-am62p: Add nodes for more IPs")
Cc: stable@vger.kernel.org
Signed-off-by: Judith Mendez <jm@ti.com>
Acked-by: Udit Kumar <u-kumar1@ti.com>
Acked-by: Bryan Brattlof <bb@ti.com>
Link: https://lore.kernel.org/r/20250429163337.15634-4-jm@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-am62p-j722s-common-main.dtsi |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/arm64/boot/dts/ti/k3-am62p-j722s-common-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62p-j722s-common-main.dtsi
@@ -564,8 +564,6 @@
 		power-domains = <&k3_pds 57 TI_SCI_PD_EXCLUSIVE>;
 		clocks = <&k3_clks 57 1>, <&k3_clks 57 2>;
 		clock-names = "clk_ahb", "clk_xin";
-		assigned-clocks = <&k3_clks 57 2>;
-		assigned-clock-parents = <&k3_clks 57 4>;
 		bus-width = <8>;
 		mmc-ddr-1_8v;
 		mmc-hs200-1_8v;


