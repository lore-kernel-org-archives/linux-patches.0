Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E220921CC4F;
	Mon,  2 Jun 2025 14:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872852; cv=none; b=lqgB3gn6R1R4lWN0j5p/xMdHZ+OzU8jRS3skbXSWdR95qmNODUS7YTLYwi8NqlONBrwvlQ0/szUlhdqqQUKEgWIOhfVKLfDQsoaDCUY6W11R7aI3UovE+l9l7FMZiVIkGCP0wfqOhCTgcfE0pcqPdRnRoHBa63SLnbIowF1HLcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872852; c=relaxed/simple;
	bh=p+5GGwXEiWl8Yjol4j22XDvXuDVRQY/UiFTDioVN7YU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VrBRcgEEK0CGe4XkIymhughiRqTyqlO9EGahlYsAOpKHhDGKZ6OsS9SwyOUJGM8Abnr+Vhmtzr3JMzmdT6EC8oy/kBWho/Jq7va1wUl9b9J+9tiMPnPOi6SAi2mviog6wmEZc7Y2AYckWmSw0gSHD+LzcRla4IVq8HAFG8zwmxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VHmNNWdb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VHmNNWdb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E46C4CEEB;
	Mon,  2 Jun 2025 14:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872851;
	bh=p+5GGwXEiWl8Yjol4j22XDvXuDVRQY/UiFTDioVN7YU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VHmNNWdbcbp8GHeyeJH9dR5njhE2LBDfdVprT8Gr1aCKfNUh7WEq1+b59kH8tWXig
	 zO4zcEHcbNM6eY+P7uQxmVe+WSET4nYrCDxUKoWg7jKcwJHE+i0K5+QIKc7+JYziDl
	 JChcFQpJifR9+MlWsaYJ3ZXxfYJSLte7DlZaLHTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Udit Kumar <u-kumar1@ti.com>,
	Bryan Brattlof <bb@ti.com>,
	Nishanth Menon <nm@ti.com>
Subject: [PATCH 6.12 16/55] arm64: dts: ti: k3-am62a-main: Set eMMC clock parent to default
Date: Mon,  2 Jun 2025 15:47:33 +0200
Message-ID: <20250602134238.922729716@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134238.271281478@linuxfoundation.org>
References: <20250602134238.271281478@linuxfoundation.org>
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


