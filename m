Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1280824169F;
	Tue, 26 Aug 2025 11:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207178; cv=none; b=iva+hVto70xtovIeY3krNd/7VWZ+58iJbqEL0a8aoarxxoGLvnSrLpnFFo6pl2+vACIHIy/uOceb/F/9M9Jk1adRJNiplTdhObwQWz3VefPGVjFPWgaj8aC+YI6sp4uGroIin/id+U22lbAYZEdH6ggF3tSfiqIU98tS7bPeBg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207178; c=relaxed/simple;
	bh=t+YkyduaWDLAEGxrrM8Wnn5Th3MWqFAyw4rm8UC/YIg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m185c6LxaUKK975q/m55wCGnsCJq6MElM3RPaTJNLHxf1wwzOQ8bjKlxNZndSUtZAjF2D/gSqSxVkM1l/GJwoOxmIe4yNPvy1fUfqgtkVePincXKxh+R0+jc6tXx6f4L+z2/CAu21Z5XJT5uZtCtG5PScdI0jrlhQ/SZHxOhuTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M8XMLaOa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M8XMLaOa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FAADC4CEF1;
	Tue, 26 Aug 2025 11:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207177;
	bh=t+YkyduaWDLAEGxrrM8Wnn5Th3MWqFAyw4rm8UC/YIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M8XMLaOawo8pvP+DVRn7n7ZXAOjmDHl+XGudd496gXSAoDQBBNgL1BB+8CBsd9rYw
	 AStq0mSuDfo6n6mHOlVHLxAA0pw59INOQIqVKHBFiQbfzhFFsi1m9WYLptHhhG0qTa
	 oUr9IcLxFaxY7Au1h2plHX3qgTIIh7GdtOAyEt2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH 6.16 049/457] arm64: dts: ti: k3-am62-main: Remove eMMC High Speed DDR support
Date: Tue, 26 Aug 2025 13:05:33 +0200
Message-ID: <20250826110938.561425824@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

From: Judith Mendez <jm@ti.com>

commit 265f70af805f33a0dfc90f50cc0f116f702c3811 upstream.

For eMMC, High Speed DDR mode is not supported [0], so remove
mmc-ddr-1_8v flag which adds the capability.

[0] https://www.ti.com/lit/gpn/am625

Fixes: c37c58fdeb8a ("arm64: dts: ti: k3-am62: Add more peripheral nodes")
Cc: stable@vger.kernel.org
Signed-off-by: Judith Mendez <jm@ti.com>
Link: https://lore.kernel.org/r/20250707191250.3953990-1-jm@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-am62-main.dtsi |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm64/boot/dts/ti/k3-am62-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62-main.dtsi
@@ -553,7 +553,6 @@
 		clocks = <&k3_clks 57 5>, <&k3_clks 57 6>;
 		clock-names = "clk_ahb", "clk_xin";
 		bus-width = <8>;
-		mmc-ddr-1_8v;
 		mmc-hs200-1_8v;
 		ti,clkbuf-sel = <0x7>;
 		ti,otap-del-sel-legacy = <0x0>;


